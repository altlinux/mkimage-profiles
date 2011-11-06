Name: mkimage-profiles
Version: 0.4.3
Release: alt1

Summary: ALT Linux based distribution metaprofile
License: GPLv2+
Group: Development/Other

Url: http://www.altlinux.org/Mkimage/Profiles/next
Source: %name-%version.tar
Packager: Michael Shigorin <mike@altlinux.org>

BuildArch: noarch
Requires: rsync git-core
Requires: time schedutils

%define mpdir %_datadir/%name
%add_findreq_skiplist %mpdir/*.in/*

%description
mkimage-profiles is a collection of bits and pieces useful for
distributions construction: it contains package lists, features,
and whole subprofiles (like "rescue" building block) for you
to choose from, and some ready-made image recipes as well.

Make no mistake: constructing distributions isn't just fun, it takes
a lot of passion and knowledge to produce a non-trivial one.  So m-p
(the short nick for mkimage-profiles) is complex too.  If you need
-- or want -- to make just a few tweaks to an existing recipe, it might
be easier to comprehend the generated profile (aka builddir) which
contains only the needed subprofiles, script hooks and package lists
and is way more compact.

Virtual environment template caches (OpenVZ/LXC) can be made either.

In short, setup hasher (http://en.altlinux.org/hasher) and here we go:
  cd %mpdir
  head README
  make distro/syslinux.iso

But if you're into regular distro hacking and are not afraid of make
and modest metaprogramming (some code generation and introspection),
welcome to the metaprofile itself; read the docs and get the git:
%url

%prep
%setup

%build

%install
mkdir -p %buildroot%mpdir
cp -a * %buildroot%mpdir

%files
%mpdir/*
%doc doc/
%doc README QUICKSTART

%changelog
* Mon Nov 07 2011 Michael Shigorin <mike@altlinux.org> 0.4.3-alt1
- enhancements to logging
- NICE variable: employ nice(1) and ionice(1) if available
- features.in/syslinux: banner tweaked to include target name
- features.in/live: set up unicode locale/consolefont

* Wed Nov 02 2011 Michael Shigorin <mike@altlinux.org> 0.4.2-alt1
- initial package
