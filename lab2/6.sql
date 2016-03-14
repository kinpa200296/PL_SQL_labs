set serveroutput on;

create or replace procedure restore_students(restore_time timestamp) is
  action_field varchar2(10);
  id_field number;
  name_field varchar2(60);
  group_id_field number;
  cursor backup_cursor is
    select change_action, id, name, group_id from students_table_log
      where change_time > restore_time
      order by change_time desc;
begin
  open backup_cursor;
  loop
    fetch backup_cursor into action_field, id_field, name_field, group_id_field;
    exit when backup_cursor%notfound;
    case
      when action_field = 'update' then
        update students set name = name_field, group_id = group_id_field where id = id_field;
      when action_field = 'insert' then
        delete from students where id = id_field;
      when action_field = 'delete' then
       insert into students values (id_field, name_field, group_id_field);
    end case;
  end loop;
  close backup_cursor;
end;

begin
  restore_students(to_timestamp('2016-03-13 23:39:00', 'yyyy-MM-dd hh24:mi:ss'));
end;

select * from students_table_log order by change_time desc;