create table xml_files (
  id int,
  xml_file clob,
  constraint xml_file_pk primary key(id)
);

create sequence xml_files_seq;

create or replace trigger on_xml_files_insert
  before insert on xml_files
  for each row
  begin
    :new.id := xml_files_seq.nextval;
  end;

create or replace procedure send_email(alerts in varchar2, warns in varchar2) authid current_user is
  sender varchar2(50) := 'followthetask@gmail.com';
  receiver VARCHAR2(50):= 'pkindruk@gmail.com';
  mail_host VARCHAR2(30):= 'localhost';
  mail_port INTEGER := 25;
  mail_conn utl_smtp.Connection;
  msg varchar2(512) :=
         'Subject: '|| 'Oracle Notification' || '\n\n' ||
         'Date: '   || to_char(sysdate, 'Dy, DD Mon YYYY hh24:mi:ss') || '\n' ||
         'Something is wrong!'|| '\n' || 'Your attention is required!'|| '\n';
  begin
    msg := msg || 'Alerts: \n' || alerts || '\n';
    msg := msg || 'Warnings: \n' || warns || '\n';
    mail_conn := utl_smtp.open_connection(mail_host, mail_port);
    utl_smtp.Helo(mail_conn, mail_host);
    utl_smtp.Mail(mail_conn, sender);
    utl_smtp.Rcpt(mail_conn, receiver);
    utl_smtp.Data(mail_conn, msg);
    utl_smtp.Quit(mail_conn);
  exception
    when utl_smtp.Transient_Error or utl_smtp.Permanent_Error then
    dbms_output.put_line('Error in sending mail '|| sqlerrm);
  end;

create or replace procedure save_state authid current_user is
    xml_info xmltype;
  begin
    select xmlagg(xmlelement("SESSION", xmlforest(username, command, status, schemaname, type)))
      into xml_info from v$session where status = 'ACTIVE';
    insert into xml_files(xml_file) values(xml_info.getclobval());
  exception
    when others then
      dbms_output.put_line('Error in xml: ' || sqlerrm);
  end;

create or replace procedure check_my_metrics authid current_user is
  cursor metrics_cursor is
    select id, name, metric_query from my_metrics;
  m_id int;
  m_name varchar2(128);
  m_query varchar2(512);
  res number := 0;
  warn number;
  alert number;
  warn_msg varchar2(512) := '';
  alert_msg varchar2(512) := '';
  warn_flag int := 0;
  alert_flag int := 0;
  begin
    open metrics_cursor;
    loop
      fetch metrics_cursor into m_id, m_name, m_query;
        exit when metrics_cursor % notfound;
      select warn_limit, alert_limit into warn, alert
        from my_limits where metric_id = m_id;
      execute immediate m_query into res;
      insert into my_metrics_values(metric_id, value)
        values(m_id, res);
      if alert > warn then
        if res >= alert then
          alert_msg := alert_msg || '\n Alert: ' || m_name || ' : ' || res;
          alert_flag := 1;
        else if res >= warn then
            warn_msg := warn_msg || '\n Warning: ' || m_name || ' : ' || res;
            warn_flag := 1;
          end if;
        end if;
      else
        if res <= alert then
          alert_msg := alert_msg || '\n Alert: ' || m_name || ' : ' || res;
          alert_flag := 1;
        else if res <= warn then
            warn_msg := warn_msg || '\n Warning: ' || m_name || ' : ' || res;
            warn_flag := 1;
          end if;
        end if;
      end if;
    end loop;
    close metrics_cursor;

    if alert_flag != 0 or warn_flag != 0 then
      send_email(alert_msg, warn_msg);
    end if;
    if alert_flag != 0 then
      save_state();
    end if;
  end;

begin
  dbms_scheduler.create_job(
    job_name => 'metrics_check',
    job_type => 'stored_procedure',
    job_action => 'check_my_metrics',
    start_date => systimestamp,
    repeat_interval => 'freq=secondly;interval=20',
    enabled => true);
end;