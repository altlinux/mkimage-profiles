ifdef BUILDDIR

include $(BUILDDIR)/distcfg.mk

all: dir = $(BUILDDIR)/files/etc/net/ifaces/eth0
all:
	@write_static() { \
		echo "$(VM_NET_IPV4ADDR)" > "$(dir)/ipv4address"; \
		echo "default via $(VM_NET_IPV4GW)" > "$(dir)/ipv4route"; \
	}; \
	if [ -n "$(VM_NET)" ] && mkdir -p "$(dir)"; then \
		case "$(VM_NET)" in \
		dhcp) ;; \
		static) write_static;; \
		*) \
			echo "** error: unknown value of $(VM_NET)" >&2; \
			exit 1;; \
		esac; \
		{ \
			echo "TYPE=eth"; \
			echo "DISABLED=no"; \
			echo "BOOTPROTO=$(VM_NET)"; \
		} > "$(dir)/options"; \
	fi

endif
