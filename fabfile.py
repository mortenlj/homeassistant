#!/usr/bin/env python
# -*- coding: utf-8
from __future__ import absolute_import, print_function, unicode_literals

import os
import tempfile
from fnmatch import fnmatch

import requests
from fabric.api import task, local, execute, hosts
from fabric.context_managers import quiet, cd
from fabric.contrib.files import upload_template
from fabric.operations import put, run, sudo, get

REQUIREMENTS = [
    "Fabric==1.14.0",
    "requests==2.19.1"
]

LOCAL_DIR = os.path.abspath(os.path.dirname(__file__))
LOCAL_PATH, LOCAL_NAME = os.path.split(LOCAL_DIR)
BUILD_VERSION_FILE = ".build_version"


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
    with quiet():
        return run("whoami") != "root"


def _get_homeassistant_version():
    url = "https://pypi.python.org/pypi/homeassistant/json"
    resp = requests.get(url)
    resp.raise_for_status()
    data = resp.json()
    return data["info"]["version"]


def _get_last_built_version():
    with open(BUILD_VERSION_FILE) as fobj:
        return fobj.read().strip()


@task
@hosts("root@emrys")
def deploy_configuration():
    tar_file = "homeassistant_configuration.tar.gz"
    target_dir = "/volume1/k3s_persistent_volumes/homeassistant"
    target_tar = os.path.join("/k3s_persistent_volumes/homeassistant", tar_file)
    tmp_folder = tempfile.mkdtemp()
    source_path = os.path.join(LOCAL_DIR, "babushka-deps", "renderables", "home-assistant")

    try:
        tar_path = os.path.join(tmp_folder, tar_file)
        local("tar -czf %s --exclude-vcs -C %s ." % (tar_path, source_path))
        run("mkdir -p %s" % target_dir)
        put(tar_path, target_tar)
        with cd(target_dir):
            try:
                run("tar --overwrite --no-same-owner --no-same-permissions -xzf %s" % tar_file)
            finally:
                run("rm -f %s" % tar_file)
    finally:
        local("rm -rf %s" % tmp_folder)
        target_dir = "/volume1/k3s_persistent_volumes/homeassistant"
        run("chown -R admin:users %s" % target_dir)
        run("chmod -R 775 %s" % target_dir)


@task
@hosts("rancher@rpi3b02")
def deploy():
    for f in os.listdir("kubernetes"):
        path = os.path.join("kubernetes", f)
        destination = "/var/lib/rancher/k3s/server/manifests/homeassistant-{}".format(f)
        upload_template(path, destination, {"version": _get_last_built_version()}, use_sudo=True, backup=False)


@task
def update_version():
    version = _get_homeassistant_version()
    with open(BUILD_VERSION_FILE, "w") as fobj:
        fobj.write(version)


@task
@hosts("emrys")
def update_known_devices():
    get("/k3s_persistent_volumes/homeassistant/known_devices.yaml",
        "babushka-deps/renderables/home-assistant/known_devices.yaml")
