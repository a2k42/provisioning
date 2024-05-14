# Example Preseed Files

## Minimal

This is the most basic configuration which gets through the auto-installer without prompting for any answers.

Similarly, the script to run it with qemu has also been kept simple.

```bash
./minimal-install.sh
```

```bash
virt-viewer --connect qemu:///system --wait minimal
```