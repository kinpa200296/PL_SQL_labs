set serveroutput on;

create table students_table_log(
  change_time timestamp,
  change_action VARCHAR2(10),
  id number,
  name varchar2(60),
  group_id number
);

create or replace trigger students_table_logger
  after delete or insert or update on students
  for each row
  begin
    case
      when deleting then
        insert into students_table_log
          values (current_timestamp, 'delete', :old.id, :old.name, :old.group_id);

      when updating then
        insert into students_table_log
          values (current_timestamp, 'update', :old.id, :old.name, :old.group_id);

      when inserting then
        insert into students_table_log
          values (current_timestamp, 'insert', :new.id, :new.name, :new.group_id);
    end case;
  end;