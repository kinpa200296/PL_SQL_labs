set serveroutput on;
--drop table MyTable;
--drop sequence MyTable_seq;
--select count(id) from MyTable where mod(val, 2) = 0;
--select count(id) from MyTable where mod(val, 2) != 0;
--select mod(val, 2) from mytable;
--select * from MyTable;
--select * from db_logon_table;
select * from my_metrics;
select * from my_limits;
select * from my_metrics_values;
select * from xml_files;
select job_name, state, enabled, repeat_interval from user_scheduler_jobs;
select * from xml_files;