set serveroutput on;

create table students(
  id number,
  name varchar2(60),
  group_id number
);

create table groups(
  id number,
  name varchar2(30),
  c_val number
);