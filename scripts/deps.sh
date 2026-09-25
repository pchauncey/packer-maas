#!/bin/sh
# Report packages required without breaking build

# Determine host OS:
ID="" ID_LIKE=""
if [ -f /etc/os-release ]; then
    . /etc/os-release
fi

# Set $pkgs for the OS:
case " $ID $ID_LIKE " in
	*debian*|*ubuntu*)
		pkgs="libnbd-bin nbdkit packer fuse2fs cloud-image-utils ovmf parted mtools"
		query="dpkg -s" ;;
	*rhel*|*fedora*|*suse*)
		pkgs="nbdfuse nbdkit packer e2fsprogs cloud-utils edk2-ovmf parted mtools"
		query="rpm -q" ;;
	*arch*)
		pkgs="libnbd nbdkit packer e2fsprogs edk2-ovmf parted mtools"
		query="pacman -Qi" ;;
	*)
		echo "[deps] unrecognised host (${ID:-?}); skipping dependency check" >&2
		exit 0 ;;
esac

# Print out required packages:
if [ "$1" = print ]; then
	echo $pkgs
	exit 0
fi

# Announce missing packages (if any):
missing=""
for p in $pkgs; do
	$query "$p" >/dev/null 2>&1 || missing="$missing $p"
done
[ -z "$missing" ] || echo "[deps] missing packages:$missing (continuing anyway)" >&2

