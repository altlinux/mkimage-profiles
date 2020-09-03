WHATEVER += files/write.sh

files/write.sh:
	@install -pDm755 lib/50-e2k-write.sh files/write.sh
