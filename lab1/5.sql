  set serveroutput on;

declare
  procedure insert_data(v int) is
  begin
    insert into MyTable values(MyTable_seq.nextval, v);
  end;
  
  procedure update_data(iden int, v int) is
  begin
    update MyTable set val = v where id = iden;
  end;
  
  procedure delete_data(iden int) is
  begin
    delete from MyTable where id = iden;
  end;
  
begin
  --insert_data(30);
  --update_data(1, 12);
  delete_data(1);
end;