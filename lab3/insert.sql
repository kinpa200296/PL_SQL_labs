insert into my_metrics(name, metric_query)
    values('CPU', 'select round(value/(select VALUE from v$osstat WHERE STAT_NAME = ''NUM_CPUS'')*100, 2) val from v$sysmetric
    where metric_name in (''CPU Usage Per Sec'')');
insert into my_limits(warn_limit, alert_limit, metric_id)
    values(1, 2, (select id from my_metrics where name='CPU'));