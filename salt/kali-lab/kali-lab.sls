kali-lab:
  qvm.present:
    - name: kali-lab
    - template: t-kali-lab
    - label: red
    - netvm: sys-firewall
