AC_INIT( [mkimage-profiles], [0.1], [http://bugzilla.altlinux.org] )

AC_ARG_WITH(aptconf,
	    AC_HELP_STRING([--with-aptconf=file],
			   [custom apt.conf location, e.g '--with-aptconf=/home/me/apt.conf']),
			   [
			    AC_MSG_CHECKING([apt.conf file])
			    if test -r "$with_aptconf"  ; then
				    APTCONF="$with_aptconf"
				    AC_MSG_RESULT([$with_aptconf exists])
				    else
					    echo "WARNING: $with_aptconf missing, ignoring"
				    fi
				    ],
				    [
				     APTCONF=/etc/apt/apt.conf
				     ])

AC_ARG_WITH(mkimage,
	    AC_HELP_STRING([--with-mkimage=dir],
			   [custom mkimage prefix, e.g '--with-mkimage=/home/me/usr/share/mkimage']),
			   [
			    AC_MSG_CHECKING([mkimage])
			    if test -d "$with_mkimage/tools"; then
				    MKIMAGE_PREFIX="$with_mkimage"
				    AC_MSG_RESULT([$with_mkimage/tools exists])
			    fi
			    ],
			    [
			     MKIMAGE_PREFIX='/usr/share/mkimage'
			     ])

# with-kernel: provide two separate desktop/server default substs?

AC_SUBST(APTCONF)
AC_SUBST(MKIMAGE_PREFIX)

AC_SUBST(DISTRO)
AC_SUBST(LABEL)
AC_CONFIG_FILES([
		 globals.mk
])

AC_OUTPUT
