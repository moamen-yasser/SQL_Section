create table Branch (
branchNo varchar(5) primary key not null,
city varchar(50),
telephone varchar(50)
);

create table Staff (
staffNo varchar(5) primary key not null,
fName varchar(50),
lName varchar(50),
city varchar(50),
position varchar(50),
salary int,
branchNo varchar(5)
constraint FK_STAFF_BRANCH foreign key (branchNo) references Branch(branchNo)
);

create table Project(
projNo varchar(5) primary key not null,
city varchar(50),
postCode varchar(10),
staffNo varchar(5)
constraint FK_PROJECT_STAFF foreign key (staffNo) references Staff(staffNo)
);

INSERT INTO Branch VALUES
('B01', 'Banha', '2234'),
('B02', 'Cairo', '2456'),
('B03', 'Mansoura', '3467');

INSERT INTO Staff VALUES
('s1', 'Gad', 'Ahmed', 'Tanta', 'Manager', 60000, 'B02'),
('s2', 'Samy', 'Tamer', 'Cairo', 'Assistant', 30000, 'B02'),
('s3', 'Samy', 'Ahmed', 'Tanta', 'Supervisor', 50000, 'B01'),
('s4', 'Tamer', 'Samir', 'Giza', 'Manager', 40000, 'B03');

INSERT INTO Project VALUES
('PT11', 'Zakazik', '2234', 's3'),
('PT21', 'Mansoura', '2456', 's1'),
('PT32', 'Banha', '3467', 's2');

/*List the staff at the branch located in Cairo.*/
select staffNo, fName, lName, position, salary
from Staff 
where branchNo = (select branchNo from Branch where city ='Cairo'); /*B02*/ /*where branchNo = 'B02' */

/*List all staff whose salary is greater than the average 
salary and show by how much their salary is greater than the average.*/
select staffNo, fName, lName, position, salary - (select avg(salary) from Staff) as salDiff
from Staff
where salary > (select avg(salary) from Staff); /*45000*/ /*where salary > 45000 */


/*List the projects that are handled by staff who work in the branch located in Cairo.*/
select projNo, city, postCode 
from Project 
where staffNo in (select staffNo  /*s1, s2*/
from Staff
where branchNo = (select branchNo from Branch where city = 'Cairo') /*B02*/
);

/*Find all staff whose salary is larger than the salary of at least one member of staff at branch B02.*/
select staffNo, fName, lName, position, salary
from Staff 
where salary > some (select salary from Staff where branchNo = 'B02') /*30000, 60000*/

/*Find all staff with salaries larger than the salary of every member of staff whose first name is Samy.*/
select staffNo, fName, lName, position, salary
from Staff
where salary > all (select salary from Staff where fName = 'Samy')

/*Simple join*/
/*Produce a list of all staff and the projects for which they work.*/
select s.staffNo,fName,lName,projNo,p.city
from Staff s, Project p 
where s.staffNo = p.staffNo;

/*Sorting a join*/
/*Produce a list of all staff and the projects for which they work, arranged in order of project number and the staff number.*/
select projNo,s.staffNo,fName,lName,p.city
from Staff s, Project p 
where s.staffNo = p.staffNo
order by projNo, s.staffNo;

/*Three-table join*/
/*For each branch, list the numbers and names of staff who work in projects, 
including the city in which the branch is located and the project number that the staff manages.*/
select b.branchNo,s.staffNo,fName,lName,b.city,projNo
from Branch b, Staff s, Project p 
where b.branchNo = s.branchNo AND s.staffNo = p.staffNo
order by b.branchNo, p.projNo, s.staffNo;



/*Inner Join*/
select b.*, p.*
from Branch b, Project p 
where b.city = p.city;

select b.*,p.*
from Branch b 
inner join Project p 
on b.city = p.city;

/*Left Outer join*/
/*List all branch offices and any projects that are in the same city*/
select b.*,p.*
from Branch b 
left join Project p 
on b.city = p.city;

/*Right Outer Join*/
/*List all projects and any branch offices that are in the same city*/
select b.*,p.*
from Branch b 
right join Project p  
on b.city = p.city;

/*Full Outer Join*/
/*List the branch offices and projects that are in the same city along with any unmatched branches or projects.*/
select b.*,p.*
from Branch b 
full join Project p  
on b.city = p.city;




/*Union*/
(select city from Branch where city is not null)
Union
(select city from Project where city is not null)


/*Intersect*/
(select city from Branch where city is not null)
Intersect
(select city from Project where city is not null)


select distinct b.city
from Branch b, Project p 
where b.city = p.city;

select distinct b.city
from Branch b
inner join Project p 
on b.city = p.city;

select distinct city
from Branch 
where city in (select city from project);

-- (select * from Branch)
-- INTERSECT CORRESPONDING BY city
-- (select * from Project)

/*Except*/
(select city from Branch where city is not null)
Except
(select city from Project where city is not null)

select distinct city
from Branch 
where city not in (select city from project);
