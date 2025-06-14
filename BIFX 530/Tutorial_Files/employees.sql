DROP TABLE IF EXISTS employees;

CREATE TABLE employees
(
    emp_id int unsigned not null auto_increment primary key,
    f_name varchar(20),
    l_name varchar(20),
    title varchar(30),
    age int,
    yos int,
    salary int,
    email varchar(60)
);

INSERT INTO employees (f_name, l_name, title, age, yos, salary, email) values ("Tom", "Jones", "Programmer", 32, 4, 120000, "john_hagan@bignet.com"), ("Dick", "Harrison", "Analyst", 32, 4, 110000, "g_pillai@bignet.com"), ("Harry", "Houdini", "Senior Programmer", 32, 4, 110000, "g_pillai@bignet.com");