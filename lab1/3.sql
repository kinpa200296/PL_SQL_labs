set serveroutput on;
declare
  function process_mytable return char is
    odd_cnt int := 0;
    even_cnt int := 0;
  begin
    select count(val) into even_cnt from MyTable where mod(val, 2) = 0;
    select count(val) into odd_cnt from MyTable where mod(val, 2) != 0;
    if odd_cnt = even_cnt
    then return 'EQUAL';
    else if odd_cnt < even_cnt
      then return 'TRUE';
      else return 'FALSE';
      end if;
    end if;
  end process_mytable;
begin
  dbms_output.put_line(process_mytable());
end;