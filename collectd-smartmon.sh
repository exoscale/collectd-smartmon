#!/bin/dash
###
# ABOUT  : collectd monitoring script for smartmontools (using smartctl)
# AUTHOR : Samuel B. <samuel_._behan_(at)_dob_._sk> (c) 2012
# LICENSE: GNU GPL v3
# SOURCE: http://devel.dob.sk/collectd-scripts/
###

if [ -z "$*" ]; then
	echo "Usage: $(basename $0) <disk> <disk>..." >&2
	exit 1
fi

for disk in "$@"; do
	disk=${disk%:*}
	if ! [ -e "/dev/$disk" ]; then
		echo "$(basename $0): disk /dev/$disk not found !" >&2
		exit 1
	fi
done

HOST=`hostname`
INTERVAL=300
while true; do
	for disk in "$@"; do
		dsk=${disk%:*}
		drv=${disk#*:}
		id=
		adp=

		if [ "$disk" != "$drv" ]; then
			id=${drv#*,}
			adp="-${drv%,*}"
			drv="-d $drv"
		else
			drv=
		fi

		eval `sudo /usr/sbin/smartctl -n standby $drv -A "/dev/$dsk" | awk '$3 ~ /^0x/ && $2 ~ /^[a-zA-Z0-9_-]+$/ { gsub(/-/, "_"); print "SMART_" $2 "=" $10 }' 2>/dev/null`
                
                # Health status: 8 bits mask, read smartctl for meaning, anything > 0 is bad
                echo "PUTVAL $HOST/smart$adp-$dsk/$id/gauge-health-status interval=$INTERVAL N:$?"
                
                # Generic values
		[ -n "$SMART_Current_Pending_Sector" ] &&
			echo "PUTVAL $HOST/smart$adp-$dsk/$id/gauge-current_pending_sector interval=$INTERVAL N:${SMART_Current_Pending_Sector:-U}"
		[ -n "$SMART_End_to_End_Error" ] &&
			echo "PUTVAL $HOST/smart$adp-$dsk/$id/gauge-end_to_end_error interval=$INTERVAL N:${SMART_End_to_End_Error:-U}"
		[ -n "$SMART_Hardware_ECC_Recovered" ] &&
			echo "PUTVAL $HOST/smart$adp-$dsk/$id/gauge-hardware_ecc_recovered interval=$INTERVAL N:${SMART_Hardware_ECC_Recovered:-U}"
		[ -n "$SMART_Offline_Uncorrectable" ] &&
			echo "PUTVAL $HOST/smart$adp-$dsk/$id/gauge-offline_uncorrectable interval=$INTERVAL N:${SMART_Offline_Uncorrectable:-U}"
		[ -n "$SMART_Raw_Read_Error_Rate" ] &&
			echo "PUTVAL $HOST/smart$adp-$dsk/$id/gauge-raw_read_error_rate interval=$INTERVAL N:${SMART_Raw_Read_Error_Rate:-U}"
		[ -n "$SMART_Reallocated_Sector_Ct" ] &&
			echo "PUTVAL $HOST/smart$adp-$dsk/$id/gauge-reallocated_sector_count interval=$INTERVAL N:${SMART_Reallocated_Sector_Ct:-U}"
		[ -n "$SMART_Reported_Uncorrect" ] &&
			echo "PUTVAL $HOST/smart$adp-$dsk/$id/gauge-reported_uncorrect interval=$INTERVAL N:${SMART_Reported_Uncorrect:-U}"
		[ -n "$SMART_Spin_Up_Time" ] &&
			echo "PUTVAL $HOST/smart$adp-$dsk/$id/gauge-spin_up_time interval=$INTERVAL N:${SMART_Spin_Up_Time:-U}"
		# Intel SSD DCxx
		[ -n "$SMART_Temperature_Case" ] &&
			echo "PUTVAL $HOST/smart$adp-$dsk/$id/temperature-case interval=$INTERVAL N:${SMART_Temperature_Case:-U}"
		[ -n "$SMART_Temperature_Internal" ] &&
			echo "PUTVAL $HOST/smart$adp-$dsk/$id/temperature-internal interval=$INTERVAL N:${SMART_Temperature_Internal:-U}"
		[ -n "$SMART_Media_Wearout_Indicator" ] &&
			echo "PUTVAL $HOST/smart$adp-$dsk/$id/gauge-media_wearout_indicator interval=$INTERVAL N:${SMART_Media_Wearout_Indicator:-U}"
		[ -n "$SMART_Power_On_Hours" ] &&
			echo "PUTVAL $HOST/smart$adp-$dsk/$id/gauge-power-on-hour interval=$INTERVAL N:${SMART_Power_On_Hours:-U}"
		[ -n "$SMART_Power_Cycle_Count" ] &&
			echo "PUTVAL $HOST/smart$adp-$dsk/$id/gauge-power-cycle-count interval=$INTERVAL N:${SMART_Power_Cycle_Count:-U}"
		[ -n "$SMART_Workld_Media_Wear_Indic" ] &&
			echo "PUTVAL $HOST/smart$adp-$dsk/$id/gauge-workld-media-wear-indic interval=$INTERVAL N:${SMART_Workld_Media_Wear_Indic:-U}"
		[ -n "$SMART_Workld_Media_Wear_Perc" ] &&
			echo "PUTVAL $HOST/smart$adp-$dsk/$id/gauge-workld-media-wear-perc interval=$INTERVAL N:${SMART_Workld_Media_Wear_Perc:-U}"
		[ -n "$SMART_Workload_Minutes" ] &&
			echo "PUTVAL $HOST/smart$adp-$dsk/$id/gauge-workld-minutes interval=$INTERVAL N:${SMART_Workload_Minutes:-U}"
		[ -n "$SMART_Host_Writes_32MiB" ] &&
			echo "PUTVAL $HOST/smart$adp-$dsk/$id/gauge-host-writes-32mb interval=$INTERVAL N:${SMART_Host_Writes_32MiB:-U}"
		[ -n "$SMART_Host_Reads_32MiB" ] &&
			echo "PUTVAL $HOST/smart$adp-$dsk/$id/gauge-host-reads-32mb interval=$INTERVAL N:${SMART_Host_Reads_32MiB:-U}"
		[ -n "$SMART_Available_Reservd_Space" ] &&
			echo "PUTVAL $HOST/smart$adp-$dsk/$id/gauge-available-reservd-space interval=$INTERVAL N:${SMART_Available_Reservd_Space:-U}"
		[ -n "$SMART_NAND_Writes_32MiB" ] &&
			echo "PUTVAL $HOST/smart$adp-$dsk/$id/gauge-nand-writes-32mb interval=$INTERVAL N:${SMART_NAND_Writes_32MiB:-U}"
	done

	sleep $INTERVAL || true
done
