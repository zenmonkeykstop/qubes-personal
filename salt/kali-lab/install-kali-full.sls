install-python-apt:
  pkg.installed:
    - pkgs:
      - python3-apt
      - apt-transport-https
      - ca-certificates
      - curl
      - gnupg2
      - software-properties-common

copy-kali-key:
  file.managed:
    - name: /tmp/kali.key
    - source: "salt://kali-lab/kali.key"
    - user: root
    - group: root
    - mode: 644

add-kali-key:
  cmd.run:
    - name: "cat /tmp/kali.key | apt-key add -"
    - require:
      - file: copy-kali-key

add-kali-repo:
  file.managed:
    - name: /etc/apt/sources.list.d/kali.list
    - user: root
    - group: root
    - mode: 644
    - contents: |
        deb http://http.kali.org/kali kali-rolling main non-free contrib"
    - require:
      - cmd: add-kali-key

# install-kali:
#  cmd.run:
#    - name: "sudo apt-get update -y && DEBIAN_FRONTEND=noninteractive sudo apt-get install kali-linux-large -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold'"
