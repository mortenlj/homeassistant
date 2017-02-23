#!/usr/bin/env python
# -*- coding: utf-8
from __future__ import absolute_import, print_function, unicode_literals

import os
import tempfile
from fnmatch import fnmatch

from fabric.api import task, local, env, cd
from fabric.utils import error
from fabric.operations import put, run, sudo
from fabric.context_managers import quiet

# Download kernel from https://github.com/dhruvvyas90/qemu-rpi-kernel/blob/master/kernel-qemu-4.4.34-jessie
# Download img from https://blog.hypriot.com/downloads/

BABUSHKA_REPO = "https://github.com/mortenlj/babushka.git -bpatch-1"
LOCAL_DIR = os.path.abspath(os.path.dirname(__file__))
LOCAL_PATH, LOCAL_NAME = os.path.split(LOCAL_DIR)

env.roledefs = {
    "test": ["pirate@localhost:5022"],
    "prod": ["pirate@home-assistant"]
}


def _find_file(pattern):
    for dirpath, dirnames, filenames in os.walk("."):
        for filename in filenames:
            if fnmatch(filename, pattern):
                return os.path.join(dirpath, filename)


def _executable(exe, use_sudo=False):
    with quiet():
        runner = sudo if use_sudo else run
        res = runner("command -v {}".format(exe))
        return res.return_code == 0


def _is_not_root():
    return run("whoami") != "root"


@task
def start_vm():
    if "test" in env.effective_roles:
        kernel = _find_file("kernel-qemu*")
        image = _find_file("hypriotos-rpi-*.img")
        local('qemu-system-arm -kernel {} -cpu arm1176 -m 256 -M versatilepb -no-reboot -daemonize'
              ' -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" -redir tcp:5022::22 -drive file={},format=raw'.format(
                kernel, image
                ))


@task
def deploy_code():
    tar_file = "%s.tar.gz" % LOCAL_NAME
    target_tar = os.path.join("/tmp", tar_file)
    tmp_folder = tempfile.mkdtemp()

    try:
        tar_path = os.path.join(tmp_folder, tar_file)
        local("tar -czf %s --exclude=dev-tools --exclude-vcs-ignores -C %s %s" % (tar_path, LOCAL_PATH, LOCAL_NAME))
        put(tar_path, target_tar)
        with cd("/tmp"):
            try:
                run("rm -rf %s" % LOCAL_NAME)
                run("tar -xzf %s" % tar_file)
            finally:
                run("rm -f %s" % tar_file)
    finally:
        local("rm -rf %s" % tmp_folder)


@task
def babushka(reinstall=False):
    remote_dir = os.path.join("/tmp", LOCAL_NAME)
    with cd(remote_dir):
        if _is_not_root() and (not _executable("sudo")):
            error("Not root, and sudo is not available. This needs some human interaction.")
        if not _executable("git"):
            sudo("apt-get install -qqy git")
        if not _executable("ruby"):
            sudo("apt-get install -qqy ruby")
        if not _executable("babushka") or reinstall:
            with quiet():
                sudo("rm -rf /opt/babushka")
            sudo("mkdir -p /opt")
            sudo("git clone {} /opt/babushka".format(BABUSHKA_REPO))
            with cd("/usr/local/bin"):
                sudo("ln -sf /opt/babushka/bin/babushka.rb babushka")
            if not _executable("babushka"):
                error("Failed to install babushka!")
        run("babushka main")