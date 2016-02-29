set serveroutput on;
begin
  dbms_random.initialize(dbms_utility.get_time());
  for i in 1..10000
  loop
    insert into MyTable values(MyTable_seq.nextval, dbms_random.random);
  end loop;
end;