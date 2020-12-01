update-debian-repos-to-bullseye:
  file.replace:
    - name: /etc/apt/sources.list
    - pattern: "buster"
    - repl: "bullseye"

rename-updates-to-security:
  file.replace:
    - name: /etc/apt/sources.list
    - pattern: "bullseye/updates"
    - repl: "bullseye-security"
    - require:
      - file: update-debian-repos-to-bullseye

update-qubes-repos-to-bullseye:
  file.replace:
    - name: /etc/apt/sources.list.d/qubes-r4.list
    - pattern: "buster"
    - repl: "bullseye"
    - require:
      - file: rename-updates-to-security

update-repos:
  cmd.run:
    - name: "sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold'"

install-gcc-8:
  cmd.run:
    - name: "DEBIAN_FRONTEND=noninteractive apt-get install gcc-8-base -y -o APT::Immediate-Configure=0 --no-install-recommends"

upgrade-to-bullseye:
  cmd.run:
    - name: "sudo DEBIAN_FRONTEND=noninteractive apt full-upgrade -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold'"
    - requires: install-gcc-8
