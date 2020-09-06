install-packages:
  pkg.installed:
    - pkgs:
      - curl
      - git
      - gpg
      - make
      - libssl-dev
      - pkg-config
    - refresh: True

create-gpg-homedir:
  file.directory:
    - name: /home/user/.gnupg
    - user: user
    - group: user
    - mode: 700

import-rust-key:
  file.managed:
    - name: /home/user/.gnupg/rust-key.gpg.asc
    - source: salt://personal/files/rust-key.gpg.ascii
    - user: user
    - group: user
    - mode: 600
    - require:
      - file: create-gpg-homedir
  cmd.run:
    - name: sudo -u user gpg --import /home/user/.gnupg/rust-key.gpg.asc
    - require:
      - file: import-rust-key 
    - onchanges:
      - file: import-rust-key

{% import_json "personal/rustconf.json" as c %}

create-rust-basedir:
  file.directory:
    - name: /opt/rust
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True

ensure-tarball-present:
  file.managed:
    - name: /opt/rust/rust-{{ c.version }}-x86_64-unknown-linux-gnu.tar.gz
    - source: salt://personal/files/rust-{{ c.version }}-x86_64-unknown-linux-gnu.tar.gz
    - require:
      - file: create-rust-basedir
    
ensure-sig-present:
  file.managed:
    - name: /opt/rust/rust-{{ c.version }}-x86_64-unknown-linux-gnu.tar.gz.asc
    - source: salt://personal/files/rust-{{ c.version }}-x86_64-unknown-linux-gnu.tar.gz.asc
    - require:
      - file: create-rust-basedir

verify-tarball-sig:
  cmd.run:
    - name: sudo -u user gpg --verify /opt/rust/rust-{{ c.version }}-x86_64-unknown-linux-gnu.tar.gz.asc /opt/rust/rust-{{ c.version }}-x86_64-unknown-linux-gnu.tar.gz
    - require:
      - file: ensure-tarball-present
      - file: ensure-sig-present

untar-rust-tarball:
  cmd.run:
    - name: "tar -C /opt/rust/ -zxf /opt/rust/rust-{{ c.version }}-x86_64-unknown-linux-gnu.tar.gz"
    - require:
      - cmd: verify-tarball-sig
 
install-rust:
  cmd.run:
    - name: "cd /opt/rust/rust-{{ c.version }}-x86_64-unknown-linux-gnu && ./install.sh --prefix=/usr"
    - require:
      - cmd: untar-rust-tarball
