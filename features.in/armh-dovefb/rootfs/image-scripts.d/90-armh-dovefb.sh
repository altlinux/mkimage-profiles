#!/bin/sh

mkdir -p /etc/udev/rules.d
cd /etc/udev/rules.d

cat > 99-bmm.rules << EOF
KERNEL=="bmm|bmm[0-9]", GROUP="xgrp", MODE="0660"
EOF

cat > 99-fb.rules << EOF
KERNEL=="fb|fb[0-9]", GROUP="xgrp", MODE="0660"
EOF

cat > 99-galcore.rules << EOF
KERNEL=="galcore|galcore[0-9]", GROUP="xgrp", MODE="0660"
EOF

cat > 99-uio.rules << EOF
KERNEL=="uio|uio[0-9]", GROUP="xgrp", MODE="0660"
EOF

mkdir -p /etc/X11
cd /etc/X11

cat > xorg.conf.720 << EOF
Section "Device"
	Identifier	"Videocard0"
	Driver		"dovefb"
#	Option		"ExaAccel"	"on"
	Option		"Solid"		"on"
	Option		"Copy"		"on"
	Option		"Composite"	"on"
	Option		"Commit"	"on"
	Option		"XvAccel"	"on"
	Option		"UseGPU"	"on"
EndSection

Section "Monitor"
	Identifier	"LCD0"
	Option		"PreferredMode"	"1280x720"
EndSection

Section "Screen"
	Identifier	"Screen 0"
	Device		"Videocard0"
	Monitor		"LCD0"
	DefaultDepth	24
	DefaultFbBpp	24
	SubSection	"Display"
		Depth	24
		Modes	"1280x720"
	EndSubSection
EndSection

Section "ServerLayout"
	Identifier "Main Layout"
	Screen	0  "Screen 0"
EndSection
EOF

cat > xorg.conf.1080 << EOF
Section "Device"
	Identifier	"Videocard0"
	Driver		"dovefb"
#	Option		"ExaAccel"	"on"
	Option		"Solid"		"on"
	Option		"Copy"		"on"
	Option		"Composite"	"on"
	Option		"Commit"	"on"
	Option		"XvAccel"	"on"
	Option		"UseGPU"	"on"
	#Option		"Debug"		"on"
EndSection

Section "Monitor"
	Identifier "LCD0"
	Option "PreferredMode" "1920x1080"
EndSection

Section "Screen"
	Identifier "Screen 0"
	Device "Videocard0"
	Monitor "LCD0"
	DefaultDepth 16
	DefaultFbBpp 16
	SubSection "Display"
		Depth 16
		Modes "1920x1080@60"
	EndSubSection
	SubSection "Display"
		Depth 24
		Modes "1920x1080@60"
	EndSubSection
	SubSection "Display"
		Depth 32
		Modes "800x600@60"
	EndSubSection
EndSection

Section "ServerLayout"
	Identifier "Main Layout"
	Screen 0 "Screen 0"
EndSection
EOF

ln -s xorg.conf.1080 xorg.conf
