import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


THIS_DIR = os.path.dirname(os.path.abspath(__file__))
ROLES_DIR = os.path.join(THIS_DIR, *[os.pardir]*3)


def test_hadoop_cmd(host):
    defaults = host.ansible(
        "include_vars",
        os.path.join(ROLES_DIR, "defaults", "main.yml")
    )["ansible_facts"]
    hadoop = os.path.join(
        defaults["hadoop_parent"], "hadoop", "bin", "hadoop"
    )
    out = host.check_output("%s version" % hadoop)
    hadoop_version = out.split("\n", 1)[0].split(" ")[-1]
    assert hadoop_version == defaults["hadoop_version"]
