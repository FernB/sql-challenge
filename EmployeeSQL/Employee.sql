ALTER DATABASE "Employees" SET datestyle TO "ISO, MDY";

CREATE TABLE Departments (
    dept_no VARCHAR(20)   NOT NULL,
    dept_name VARCHAR(30)   NOT NULL,
    CONSTRAINT pk_Departments PRIMARY KEY (
        dept_no
     )
);

CREATE TABLE Employees (
    emp_no INTEGER   NOT NULL,
    emp_title_id VARCHAR(20)   NOT NULL,
    birth_date DATE   NOT NULL,
    first_name VARCHAR(30)   NOT NULL,
    last_name VARCHAR(30)   NOT NULL,
    sex VARCHAR(1)   NOT NULL,
    hire_date DATE   NOT NULL,
    CONSTRAINT pk_Employees PRIMARY KEY (
        emp_no
     )
);

CREATE TABLE Department_Employee (
    emp_no INTEGER   NOT NULL,
    dept_no VARCHAR(20)   NOT NULL,
    CONSTRAINT pk_Department_Employee PRIMARY KEY (
        emp_no,dept_no
     )
);

CREATE TABLE Department_Manager (
    dept_no VARCHAR(20)   NOT NULL,
    emp_no INTEGER   NOT NULL,
    CONSTRAINT pk_Department_Manager PRIMARY KEY (
        dept_no,emp_no
     )
);

CREATE TABLE Salaries (
    emp_no INTEGER   NOT NULL,
    salary MONEY   NOT NULL,
    CONSTRAINT pk_Salaries PRIMARY KEY (
        emp_no
     )
);

CREATE TABLE Titles (
    title_id VARCHAR(20)   NOT NULL,
    title VARCHAR(30)   NOT NULL,
    CONSTRAINT pk_Titles PRIMARY KEY (
        title_id
     )
);

ALTER TABLE Employees ADD CONSTRAINT fk_Employees_emp_title_id FOREIGN KEY(emp_title_id)
REFERENCES Titles (title_id);

ALTER TABLE Department_Employee ADD CONSTRAINT fk_Department_Employee_emp_no FOREIGN KEY(emp_no)
REFERENCES Employees (emp_no);

ALTER TABLE Department_Employee ADD CONSTRAINT fk_Department_Employee_dept_no FOREIGN KEY(dept_no)
REFERENCES Departments (dept_no);

ALTER TABLE Department_Manager ADD CONSTRAINT fk_Department_Manager_dept_no FOREIGN KEY(dept_no)
REFERENCES Departments (dept_no);

ALTER TABLE Department_Manager ADD CONSTRAINT fk_Department_Manager_emp_no FOREIGN KEY(emp_no)
REFERENCES Employees (emp_no);

ALTER TABLE Salaries ADD CONSTRAINT fk_Salaries_emp_no FOREIGN KEY(emp_no)
REFERENCES Employees (emp_no);

CREATE VIEW employee_salaries AS
SELECT e.emp_no,e.first_name,e.last_name,e.sex, s.salary 
FROM employees AS e
LEFT JOIN salaries AS s ON
e.emp_no = s.emp_no;

CREATE VIEW employees_1986 AS
SELECT first_name, last_name, hire_date
FROM employees 
WHERE EXTRACT(YEAR FROM hire_date) = 1986;

SELECT * FROM employees_1986;


CREATE VIEW managers AS
SELECT m.dept_no, d.dept_name, m.emp_no, e.first_name, e.last_name
FROM department_manager AS m
LEFT JOIN employees AS e ON
m.emp_no = e.emp_no
LEFT JOIN departments AS d ON
m.dept_no = d.dept_no;

SELECT * FROM managers;

CREATE VIEW department_employees AS
SELECT e.emp_no, e.first_name, e.last_name, d.dept_name
FROM department_employee AS de
LEFT JOIN employees AS e ON
de.emp_no = e.emp_no
LEFT JOIN departments AS d ON
de.dept_no = d.dept_no;

SELECT * FROM department_employees;

CREATE VIEW hercules AS
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

SELECT * FROM hercules;

CREATE VIEW sales AS
SELECT e.emp_no, e.first_name, e.last_name, d.dept_name
FROM department_employee AS de
LEFT JOIN employees AS e ON
de.emp_no = e.emp_no
LEFT JOIN departments AS d ON
de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales';

SELECT * FROM sales;

CREATE VIEW sales_development AS
SELECT e.emp_no, e.first_name, e.last_name, d.dept_name
FROM department_employee AS de
LEFT JOIN employees AS e ON
de.emp_no = e.emp_no
LEFT JOIN departments AS d ON
de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales' OR d.dept_name = 'Development';

SELECT * FROM sales_development;

CREATE VIEW employee_count AS
SELECT last_name, COUNT(last_name) AS "number of employees" FROM employees 
GROUP BY last_name
ORDER BY "number of employees" DESC;

SELECT * FROM employee_count;

