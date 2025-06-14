use jjs14db;
# Database Table Creation
	
#  First drop any existing tables. Any errors are ignored.

DROP TABLE IF EXISTS works;
DROP TABLE IF EXISTS dept;
DROP TABLE IF EXISTS emp;

#  Now, add each table.

create table emp(
	eid INTEGER UNSIGNED,
	ename VARCHAR(30),
	age INTEGER UNSIGNED,
	salary FLOAT(10,2),
	primary key (eid)
	)ENGINE=InnoDB;

create table dept(
	did  INTEGER UNSIGNED,
	dname VARCHAR(40),
	budget FLOAT(20,2),
	managerid INTEGER UNSIGNED,
	primary key (did),
	foreign key(managerid) references emp(eid)
	)ENGINE=InnoDB;

create table works(
	eid INTEGER UNSIGNED,
	did INTEGER UNSIGNED,
	pct_time INTEGER UNSIGNED,
	primary key(eid,did),
	foreign key(eid) references emp(eid),
	foreign key(did) references dept(did)
	)ENGINE=InnoDB;