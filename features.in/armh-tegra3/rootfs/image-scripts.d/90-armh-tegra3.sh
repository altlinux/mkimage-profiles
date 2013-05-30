#!/bin/sh

cd /etc/udev/rules.d || exit 1

cat > 69-tegra-gpu.rules << EOF
# Set the right permissions to the devices provided by the
# tegra driver
ENV{ACL_MANAGE}=="0", GOTO="tegra_gpu_end"
ACTION!="add|change", GOTO="tegra_gpu_end"

# root only devices
KERNEL=="knvrm" OWNER="root" GROUP="root" MODE="0660"
KERNEL=="knvmap" OWNER="root" GROUP="root" MODE="0660"

# graphics devices
ACTION=="add|change", KERNEL=="nvhost*", GROUP="xgrp", MODE="0660"
ACTION=="add|change", KERNEL=="nvmap*", GROUP="xgrp", MODE="0660"
ACTION=="add|change", KERNEL=="tegra*", GROUP="xgrp", MODE="0660"
ACTION=="add|change", KERNEL=="nvram", GROUP="xgrp", MODE="0660"
ACTION=="add|change", KERNEL=="nvhdcp*", GROUP="xgrp", MODE="0660"

LABEL="tegra_gpu_end"
EOF

# FIXME: xgrp is a kludge
cat > 69-tegra-touchscreen.rules << EOF
SUBSYSTEM=="input",ACTION=="add|change",KERNEL=="event*",ATTRS{name}=="elan-touchscreen", SYMLINK+="twofingtouch", MODE="0660", GROUP="xgrp"
EOF
