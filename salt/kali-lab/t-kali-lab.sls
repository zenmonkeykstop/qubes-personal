clone-template:
  qvm.clone:
    - name: t-kali-lab
    - source: debian-10

configure-template:
  qvm.prefs:
    - name: t-kali-lab
    - require:
      - clone-template
    - memory: 2048
    - vcpus: 2
    - label: black

extend-template:
  cmd.run:
    - require:
      - configure-template
    - name: sudo qvm-volume extend t-kali-lab:root 40Gib
