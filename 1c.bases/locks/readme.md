# Remove 1C locks

[1C@Zabbix] creates lock-file `1c_clusters_cache_NNNN.lock`
in `\Windows\Temp`
and sometimes fail to remove it.

Just removes stale lock file periodically.

[1C@Zabbix]: https://github.com/slothfk/1c_zabbix_template_ce/
