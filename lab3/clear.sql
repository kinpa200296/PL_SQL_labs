drop procedure get_my_metrics;
drop trigger on_my_metrics_values_insert;
drop sequence my_metrics_values_seq;
drop table my_metrics_values;
drop trigger on_my_limits_insert;
drop sequence my_limits_seq;
drop table my_limits;
drop trigger on_my_metrics_insert;
drop sequence my_metrics_seq;
drop table my_metrics;
begin
  dbms_scheduler.drop_job('metrics_check', true);
end;
drop procedure send_email;
drop procedure save_state;
drop procedure check_my_metrics;
drop trigger on_xml_files_insert;
drop sequence xml_files_seq;
drop table xml_files;