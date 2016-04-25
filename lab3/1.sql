create table my_metrics(
  id int,
  name varchar2(128) not null,
  metric_query varchar2(512) not null,
  constraint metric_pk primary key(id)
);

create table my_limits(
  id int,
  metric_id int not null,
  warn_limit number not null,
  alert_limit number not null,
  constraint limit_pk primary key(id),
  constraint limits_metric_fk
    foreign key(metric_id) references my_metrics(id)
);

create table my_metrics_values (
  id int,
  metric_id int not null,
  value number not null,
  date_taken timestamp default systimestamp not null,
  constraint metric_value_pk primary key(id),
  constraint metrics_values_metric_fk
    foreign key(metric_id) references my_metrics(id)
);

create sequence my_metrics_seq;
create sequence my_limits_seq;
create sequence my_metrics_values_seq;

create or replace trigger on_my_metrics_insert
  before insert on my_metrics
  for each row
  begin
    :new.id := my_metrics_seq.nextval;
  end;

create or replace trigger on_my_limits_insert
  before insert on my_limits
  for each row
  begin
    :new.id := my_limits_seq.nextval;
  end;

create or replace trigger on_my_metrics_values_insert
  before insert on my_metrics_values
  for each row
  begin
    :new.id := my_metrics_values_seq.nextval;
  end;

create or replace procedure get_my_metrics authid current_user is
  cursor metrics_cursor is
    select id, name, metric_query from my_metrics;
  m_id int;
  m_name varchar2(128);
  m_query varchar2(512);
  res number := 0;
  begin
    open metrics_cursor;
    loop
      fetch metrics_cursor into m_id, m_name, m_query;
        exit when metrics_cursor % notfound;
      execute immediate m_query into res;
      insert into my_metrics_values(metric_id, value)
        values(m_id, res);
    end loop;
    close metrics_cursor;
  end;
