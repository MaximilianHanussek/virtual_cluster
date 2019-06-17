if [[ $(lsblk /dev/vdb -no fstype) ]]; then
	echo "[INFO] Disk is already formatted"
	sudo mount /dev/vdb /mnt/
        sudo chmod 777 /mnt/
else
	sudo mkfs.xfs /dev/vdb
	sudo mount /dev/vdb /mnt/
	sudo chmod 777 /mnt/
fi
