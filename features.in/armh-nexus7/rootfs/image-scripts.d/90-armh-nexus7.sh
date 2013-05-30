#!/bin/sh

# FIXME: the exact partition may vary
cat >> /etc/fstab << EOF
# YMMV, this might be /dev/mmcblk0p10 either
/dev/mmcblk0p9 / ext4 defaults 1 1
EOF

cd /etc/udev/rules.d || exit 1

cat > 90-tegra-rt5640.rules << EOF
SUBSYSTEM!="sound", GOTO="tegra_rt5640_end"
ACTION!="change", GOTO="tegra_rt5640_end"
KERNEL!="card*", GOTO="tegra_rt5640_end"

ATTRS{id}=="tegrart5640", ENV{PULSE_PROFILE_SET}="tegra-nexus7.conf"

LABEL="tegra_rt5640_end"
EOF

cd /usr/share/pulseaudio/alsa-mixer/profile-sets || exit 1
cat > tegra-nexus7.conf << EOF
[General]
auto-profiles = yes

[Mapping analog-stereo]
device-strings = front:%f hw:%f plughw:%f
channel-map = left,right
paths-output = tegra-nexus7-speaker tegra-nexus7-headphone
paths-input = tegra-nexus7-intmic
priority = 10
EOF

cd /etc/X11 || exit 1
cat > xorg.conf << EOF
Section "Device"
	Identifier	"nexus"
	Driver		"tegra"
EndSection
EOF

cd /etc/X11/xorg.conf.d || exit 1
cat > 99-nexus-calibration.conf << EOF
Section "InputClass"
    Identifier    "Nexus 7 Touchscreen"
    MatchIsTouchscreen "on"
    MatchProduct  "elan-touchscreen"
    MatchDevicePath "/dev/input/event*"
    MatchDriver   "evdev"
#    Option  "Calibration"   "29 2125 106 1356"
#    Option  "SwapAxes"      "0"
#    Option  "Calibration"   "566 1201 1025 2075"
#    Option  "SwapAxes"      "1"
     Option  "Calibration"   "6 2132 29 1294"
     Option  "SwapAxes"      "0"
EndSection
EOF

cat > 99-nexus-rotation.conf << EOF
Section "Monitor"
    Identifier	"Monitor"
    Option	"Rotate" "right"
EndSection

Section "Screen"
    Identifier    "Screen"
    Monitor       "Monitor"
EndSection
EOF

cd /usr/share/pulseaudio/alsa-mixer/paths || exit 1
cat > tegra-nexus7-headphone.conf << EOF
[General]
priority = 90
name = analog-output-headphones

[Jack HP-detect]
state.plugged = yes

[Element Master]
switch = mute
volume = merge
override-map.1 = all
override-map.2 = all-left,all-right

[Element HP]
switch = mute
volume = merge
override-map.1 = all
override-map.2 = all-left,all-right

[Element Headphone Jack]
switch = mute
volume = merge
override-map.1 = all
override-map.2 = all-left,all-right

[Element Int Spk]
switch = off

; Due to a kernel bug (?) the "Int Mic" is a playback control.
; Therefore we enable it here instead of in the proper place
[Element Int Mic]
switch = on

EOF

cat > tegra-nexus7-intmic.conf << EOF
[General]
priority = 90
name = analog-input-microphone-internal

[Element ADC]
; For some reason the ADC volume seems not to be affecting input gain
switch = mute
volume = zero
override-map.1 = all
override-map.2 = all-left,all-right

[Element ADC Boost Gain]
switch = mute
volume = merge
override-map.1 = all
override-map.2 = all-left,all-right

[Element Int Mic]
switch = mute

[Element DMIC]
enumeration = select

[Option DMIC:DMIC1]
priority = 89
name = analog-input-internal-microphone

EOF

cat > tegra-nexus7-speaker.conf << EOF
[General]
priority = 100
name = analog-output-speaker

[Jack HP-detect]
state.plugged = no
state.unplugged = unknown

[Element Master]
switch = mute
volume = merge
override-map.1 = all
override-map.2 = all-left,all-right

[Element Speaker]
switch = mute
volume = merge
override-map.1 = all
override-map.2 = all-left,all-right

[Element Int Spk]
switch = mute
volume = merge
override-map.1 = all
override-map.2 = all-left,all-right

[Element Headphone Jack]
switch = off

; Due to a kernel bug (?) the "Int Mic" is a playback control.
; Therefore we enable it here instead of in the proper place
[Element Int Mic]
switch = on
EOF
