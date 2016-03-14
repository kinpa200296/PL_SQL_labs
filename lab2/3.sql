set serveroutput on;

create sequence students_seq;

create sequence groups_seq;

create or replace trigger on_student_insert
  before insert on students
  for each row
  begin
    :new.id := students_seq.nextval;
  end;

create or replace trigger on_group_insert
  before insert on groups
  for each row
  declare
    tmp number;
  begin
    select count(*) into tmp from groups
      where name = :new.name;
    if tmp = 0 then
      :new.id := groups_seq.nextval;
      :new.c_val := 0;
    else
      raise_application_error(-20011, 'group name is not unique');
    end if;
  end;

create or replace trigger on_student_update
  before update on students
  for each row
  begin
    if :old.id <> :new.id then
      :new.id := :old.id;
      dbms_output.put_line('student id change prevented');
    end if;
  end;

create or replace trigger on_group_update
  before update on groups
  for each row
  declare
    tmp number;
  begin
    if :old.name <> :new.name then
      select count(*) into tmp from groups
        where name = :new.name;
      if tmp <> 0 then
        raise_application_error(-20011, 'group name is not unique');
      end if;
    end if;
    if :old.id <> :new.id then
      :new.id := :old.id;
      dbms_output.put_line('group id change prevented');
    end if;
  end;