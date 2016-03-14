set serveroutput on;

create or replace trigger on_group_delete
  before delete on groups
  for each row
  begin
    delete from students
      where group_id = :old.id;
  end;

create or replace trigger group_id_fk_trigger
  before insert or update of group_id on students
  for each row
  declare
    tmp number;
  begin
    select count(*) into tmp from groups
      where id = :new.group_id;
    if tmp = 0 then
      raise_application_error(-20012, 'group with such id does not exists');
    elsif tmp > 1 then
      raise_application_error(-20013, 'group table error: id is not unique');
    end if;
  end;