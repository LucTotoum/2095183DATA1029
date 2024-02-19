-- Creons une nouvelle base de donne library 2
create database library2;
-- suppression de l'ancien BD 
drop database if exists library_08_02_24;
use library2;
drop table if exists jobs;
create table Jobs (
job_id tinyint not null auto_increment /*primary key*/,
job_desc varchar(50) unique not null,
min_lvl enum("Stagiaire","Junior","Intermediare","Seinior") null,
max_lvl enum("Stagiaire","Junior","Intermediare","Seinior") null,
constraint pk_Jobs primary key(job_id)
/*constraint uniq_job_desc unique(job_desc)*/
);
use library2;
drop table if exists publishers;
create table Publishers (
pub_id tinyint not null,   
pub_name varchar(50) not null unique,
city varchar(50) not null,
state varchar(50) null,
country varchar(50) not null,
email varchar(50) not null unique,
constraint pk_Publishers primary key(pub_id),
constraint check_email check(email like "%@%")
);
use library2;
drop table if exists employee;
create table Employees(
emp_id tinyint not null primary key auto_increment unique,
emp_name varchar(50) not null unique,
salary smallint not null,
fname varchar(50) not null,
lname varchar(30) not null,
job_id smallint not null,
pub_id smallint not null /*references pubblishers(pub_id)*/,
pub_date date not null,
email varchar(50) not null unique,
constraint fk_employees foreign key(job_id) references jobs(job_id),
constraint check_email check(email like "%@%")
);
use library2;
drop table if exists authors;
create table Authors(
au_id tinyint not null auto_increment unique,
au_lname varchar(50) not null,
au_fname varchar(50) not null,
phone varchar(20) not null unique,
address varchar(50) not null,
city varchar(50) not null,
state varchar(50) null,
country varchar(50) not null,
zip varchar(6) not null,
contract text not null unique,
email varchar(50) not null unique,
constraint pk_Authors primary key(au_id)
);
use library2;
drop table if exists Redactions;
create table Redactions (
au_id tinyint not null /*references Authors(au_id)*/,
title_id tinyint not null /*references Titles(title_id)*/,
au_ord tinyint not null,
royalty float not null,
constraint fk_Redactions foreign key (au_id, title_id) references Authors(au_id),
constraint fk_Redactions foreign key(title_id) references Titles(title_id)
);
use library2;
drop table if exists Titles;
create table Titles(
title_id tinyint not null auto_increment primary key,
title varchar(100)not null unique,
type enum("Roman","Politique","Science","Histoire")not null,
pub_id smallint not null references publishers(pub_id),
price float not null,
advance float null,
notes varchar(225) not null,
pub_date date not null
);
use library2;
drop table if exists sales;
create table Sales(
store_id tinyint not null unique /*references Stores(store_id)*/,
ord_num tinyint null,
title_id smallint not null /*references Titles(title_id)*/,
ord_date datetime null,
qty int not null,
constraint fk_Sales_Stores foreign key (stor_id) references Stores(stor_id),
constraint fk_Sales_Titles foreign key(title_id) references Titles(title_id)
);
use library2;
drop table if exists stores;
create table Stores(
stor_id tinyint not null primary key,
stor_name varchar(50) not null unique,
stor_address varchar(50) not null unique,
city varchar(50) not null,
state varchar(50) null,
country varchar(50) not null
);



  