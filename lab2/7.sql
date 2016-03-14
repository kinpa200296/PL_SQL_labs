set serveroutput on;

create or replace trigger on_student_quantity_change
  after delete or update or insert on students
  for each row
  declare
    tmp number;
    pragma autonomous_transaction;
  begin
    case
      when inserting then
        select c_val into tmp from groups where id = :new.group_id;
        update groups set c_val = tmp + 1 where id = :new.group_id;
      when deleting then
        select c_val into tmp from groups where id = :old.group_id;
        update groups set c_val = tmp - 1 where id = :old.group_id;
      when updating then
        if :new.group_id != :old.group_id then
          select c_val into tmp from groups where id = :old.group_id;
          update groups set c_val = tmp - 1 where id = :old.group_id;
          select c_val into tmp from groups where id = :new.group_id;
          update groups set c_val = tmp + 1 where id = :new.group_id;
        end if;
    end case;
    commit;
  exception
    when no_data_found then
      dbms_output.put_line('group with such id does not exists');
  end;