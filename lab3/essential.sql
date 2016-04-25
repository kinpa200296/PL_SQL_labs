grant execute on utl_smtp to public;
create or replace public synonym utl_smtp for sys.utl_smtp;
grant select any dictionary to system;