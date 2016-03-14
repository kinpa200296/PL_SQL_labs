set serveroutput on;

create table db_logon_table(
  id int,
  username varchar(50),
  logon_time timestamp
);

create sequence db_logon_seq;

create or replace trigger db_logon_trigger
  after logon on database
  begin
    insert into db_logon_table
      values(db_logon_seq.nextval, user, current_timestamp);
  end;

select * from db_logon_table order by db_logon_table.logon_time desc;
