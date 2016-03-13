# Collectd Smartmon

* ABOUT  : collectd monitoring script for smartmontools (using smartctl)
* AUTHOR : Samuel B. <samuel_._behan_(at)_dob_._sk> (c) 2012
* LICENSE: GNU GPL v3
* SOURCE: http://devel.dob.sk/collectd-scripts/

## Description:

This script monitors SMART pre-fail attributes of disk drives using smartmon tools.
Generates output suitable for Exec plugin of collectd.
## Requirements:

* smartmontools installed (and smartctl binary)
* User & group for collector:collector
     `groupadd collector`
     `useradd -d /var/lib/collector -g collector -l -m -s /bin/sh collector`
* sudo entry for binary (ie. for sys account):
     `collector ALL=(root) NOPASSWD:/usr/sbin/smartctl *`
* Configuration for collectd.conf

    LoadPlugin exec
    <Plugin exec>
      Exec "collector:collector" "/usr/local/bin/collectd-smartmon" "sda" "sdb"
    </Plugin>

* Ubuntu 12.04 LTS
* A specific smart_drivedb.h file in /etc/smart_drivedb.h with only specifics to
your drive. This repository for example contains missing statement for Intel
DC series SSD not present in smartmontools 5.4.

## Parameters:

    <disk>[:<driver>,<id> ] ...

### Typical usage:

    /etc/collect/smartmon.sh "sda:megaraid,4" "sdb"

Will monitor disk 4, of megaraid adapter mapped as /dev/sda and additionaly
normal disk /dev/sdb. See smartctl manual for more info about adapter driver names.

### Typical output:

    PUTVAL <host>/smart-sda4/gauge-raw_read_error_rate interval=300 N:30320489
    PUTVAL <host>/smart-sda4/gauge-spin_up_time interval=300 N:0
    PUTVAL <host>/smart-sda4/gauge-reallocated_sector_count interval=300 N:472
    PUTVAL <host>/smart-sda4/gauge-end_to_end_error interval=300 N:0
    PUTVAL <host>/smart-sda4/gauge-reported_uncorrect interval=300 N:1140
    PUTVAL <host>/smart-sda4/gauge-command_timeout interval=300 N:85900918876
    PUTVAL <host>/smart-sda4/temperature-airflow interval=300 N:31
    PUTVAL <host>/smart-sda4/temperature-temperature interval=300 N:31
    PUTVAL <host>/smart-sda4/gauge-offline_uncorrectable interval=300 N:5
    PUTVAL <host>/smart-sdb/gauge-raw_read_error_rate interval=300 N:0
    PUTVAL <host>/smart-sdb/gauge-spin_up_time interval=300 N:4352
    ...

## Monitoring additional attributes:

If it is needed to monitor additional SMART attributes provided by smartctl, you
can do it simply by echoing SMART_<Attribute-Name> environment variable as its output
by smartctl -A. It's nothing complicated ;)

## History:

*   2012-04-17 v0.1.0  - public release
*   2012-09-03 v0.1.1  - fixed dash replacement (thx to R.Buehl)
*   2013-08-28 v0.2.0  - Fix sudo command.  - Use dash as it's lower overhead.  - Improve docs.  - Add a few metrics to output.  - Re-order & standardise output lines for easier review & updating.
*   2014-12-09 v0.2.1  - Fix basename calls.
*   2016-03-12 v0.2.2  - Add adapter type - Do not use FQDN - Intel SSD - Nocheck if sleep - specify Drivedb
