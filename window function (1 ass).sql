#Question 1
#What is the syntax of a window function?
#select column ,function() over (order by c2) as alias from table;
#Question 2
#What is the purpose of the FIRST_VALUE() and LAST_VALUE() functions?
#first_value() used to get first value from the result set on a specified order.
#last_value() is a window function used to get last value from a result set on a specified order.
 create database win;
 use win;
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary INT,
    hire_date DATE
);
INSERT INTO employees (employee_id, name, department, salary, hire_date) VALUES
(1, 'Alice', 'HR', 55000, '2020-01-15'),
(2, 'Bob', 'HR', 80000, '2019-05-16'),
(3, 'Charlie', 'HR', 70000, '2018-07-30'),
(4, 'Dev', 'Finance', 48000, '2021-01-10'),
(5, 'Imran', 'IT', 68000, '2017-12-25'),
(6, 'Jack', 'Finance', 60000, '2019-11-05'),
(7, 'Jason', 'IT', 45000, '2018-03-15'),
(8, 'Kiara', 'IT', 70000, '2022-06-18'),
(9, 'Michael', 'IT', 42000, '2019-05-20'),
(10, 'Nalini', 'Finance', 41500, '2021-08-24'),
(11, 'Nandini', 'Finance', 52000, '2017-03-25');

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    location VARCHAR(50)
);

INSERT INTO departments (department_id, department_name, location) VALUES
(1, 'HR', 'New York'),
(2, 'IT', 'San Francisco'),
(3, 'Finance', 'Chicago');
#Question 3
#Write an SQL query to assign a unique rank to each employee based on salary (highest first) using ROW_NUMBER()

select *,row_number() over (order by salary desc) as highest_salary from employees;

#Question 4
#Write a query to find each employee's department and their department-wise rank based on salary.
select employee_id name,department ,salary ,dense_rank() over ( partition by department order by salary) as salary_rank from employees;

#Question 5
#What will happen if we use dense rank() instead of rank() 
#rank() function provide rank to each row based on a result but it will skip the rank
#for example :if two row gets rank 1 then it will skip rank 2 and directly provide rank 3;
#dense_rank() : it works same as of rank but it does skip the rank;

#Question 6
#Write a query to calculate a running total of salaries across all employees (ordered by hire_date).
select * ,sum(salary) over (order by hire_date rows between unbounded preceding and current row) as_running_total_salary from employees;

#Question 7
#Write a query to show each employee’s salary and the difference from the highest salary in their department.
select employee_id,name,salary,MAX(salary) over( partition by department) as highest_salary,department ,max(Salary) over(partition by department)-salary as salary_differnce from employees;
#Question 8
#Write a query to compute a 3-period moving average of salaries based on hire date.
select *,avg(salary) over (order by hire_date rows between 2 preceding and current row) as avg_salary from employees;
#Question 9
#Write a query using to find the cumulative distribution of salaries.
select * ,cume_dist() over(order by salary) as comulative_distribution from employees;

#Question 10
#Write a query to retrieve the last hired employee in each department using .
select distinct last_value(name) over(partition by department order by hire_date rows between unbounded preceding and unbounded following) as last_hired_employee from employees;

#What happens when you use RANDE instead of ROWS in a window function? Provide an example query.
#RANGE=RANGE BASICALLY WORKS ON Value by Value;
#rows=rows basically works on row by row;
CREATE TABLE employees11 (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary INT,
    hire_date DATE
);
INSERT INTO employees11 (emp_id, name, department, salary, hire_date) VALUES
(1, 'Aryan', 'IT', 30000, '2022-01-10'),
(2, 'Dev', 'IT', 40000, '2022-02-15'),
(3, 'Shiv', 'IT', 40000, '2022-03-20'),
(4, 'Shyam', 'IT', 50000, '2022-04-25'),
(5, 'Riya', 'HR', 35000, '2022-01-12'),
(6, 'Neha', 'HR', 35000, '2022-02-18'),
(7, 'Aman', 'HR', 45000, '2022-03-22');
#now using rows
select emp_id,salary ,sum(Salary) over (order by salary rows between unbounded preceding and current row) as rows_salary from employees11; 
#now using range
select emp_id,salary ,sum(Salary) over (order by salary range between unbounded preceding and current row) as rows_salary from employees11; 

#Question 12
#Write an SQL query to list employees whose salary is above their department’s average salary. Use a subquery
#with a window function.
with cte1 as(select name,salary,department,avg(salary) over (partition by department) as dept_avg from employees)
select name,salary,department from cte1 where salary>dept_avg ;

#Question 13
#Write a query to join the and tables and calculate each employee’s rank within their
#department based on salary. (Hint: Use Table 2 )

with cte2 as(select * from employees inner join departments on employees.department=departments.department_name)
select name ,salary,department ,rank() over(partition by department order by salary desc ) as rank_salary from cte2;



