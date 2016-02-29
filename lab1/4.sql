set serveroutput on;
declare
  function generate_insert(iden int) return varchar is
    res varchar(100) := 'insert into MyTable values(';
    value int;
  begin
    select val into value from MyTable where id=iden;
    res := concat(res, to_char(iden));
    res := concat(res, ', ');
    res := concat(res, to_char(value));
    res := concat(res, ');');
    return res;
  exception
    when NO_DATA_FOUND then
      return 'no data found!';
    when TOO_MANY_ROWS then
      return 'too many rows!';
  end generate_insert;
begin
  dbms_output.put_line(generate_insert(1));
end;