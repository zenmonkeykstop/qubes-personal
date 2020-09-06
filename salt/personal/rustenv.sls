create-rustenv-template:
  qvm.vm:
    - name: rustenv-template
    - clone:
      - source: debian-10
      - label: black
    - tags:
      - add: 
        - personal

create-rust-pals:
  qvm.vm:
    - name: rust-pals
    - present:
      - template: rustenv-template
      - label: red
      - mem: 2000
    - prefs:
      - template: rustenv-template

