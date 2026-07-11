CREATE DATABASE IF NOT EXISTS employee_management_system;
USE employee_management_system;

CREATE TABLE Departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(50) NOT NULL,
    location VARCHAR(50)
);

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    hire_date DATE,
    salary DECIMAL(10,2),
    department_id INT,
    manager_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id),
    FOREIGN KEY (manager_id) REFERENCES Employees(employee_id)
);

CREATE TABLE Projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    project_name VARCHAR(100) NOT NULL,
    start_date DATE,
    end_date DATE,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Employee_Projects (
    employee_id INT,
    project_id INT,
    role VARCHAR(50),
    PRIMARY KEY (employee_id, project_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id)
);

INSERT INTO Departments (department_name, location) VALUES
('Human Resources', 'Udaipur'),
('IT', 'Udaipur'),
('Finance', 'Jaipur'),
('Marketing', 'Mumbai');

INSERT INTO Employees (first_name, last_name, email, phone, hire_date, salary, department_id, manager_id) VALUES
('Rohit', 'Sharma', 'rohit.sharma@company.com', '9876543210', '2020-01-15', 75000.00, 2, NULL),
('Anita', 'Verma', 'anita.verma@company.com', '9876543211', '2020-03-10', 65000.00, 1, NULL),
('Suresh', 'Patel', 'suresh.patel@company.com', '9876543212', '2021-06-20', 55000.00, 2, 1),
('Priya', 'Singh', 'priya.singh@company.com', '9876543213', '2021-08-05', 50000.00, 2, 1),
('Vikram', 'Rathore', 'vikram.rathore@company.com', '9876543214', '2019-11-30', 80000.00, 3, NULL),
('Neha', 'Joshi', 'neha.joshi@company.com', '9876543215', '2022-02-14', 48000.00, 4, NULL),
('Amit', 'Kumar', 'amit.kumar@company.com', '9876543216', '2022-05-19', 52000.00, 2, 1);

INSERT INTO Projects (project_name, start_date, end_date, department_id) VALUES
('HR Portal Upgrade', '2023-01-01', '2023-06-30', 1),
('Inventory System', '2023-02-01', '2023-09-30', 2),
('Financial Audit Tool', '2023-03-15', '2023-12-31', 3),
('Social Media Campaign', '2023-04-01', '2023-07-31', 4);

INSERT INTO Employee_Projects (employee_id, project_id, role) VALUES
(1, 2, 'Project Lead'),
(3, 2, 'Developer'),
(4, 2, 'Tester'),
(2, 1, 'Project Lead'),
(5, 3, 'Project Lead'),
(6, 4, 'Project Lead'),
(7, 2, 'Developer');
-- Employees with department name
SELECT e.employee_id, e.first_name, e.last_name, d.department_name
FROM Employees e
JOIN Departments d ON e.department_id = d.department_id;

-- Above average salary
SELECT first_name, last_name, salary
FROM Employees
WHERE salary > (SELECT AVG(salary) FROM Employees);

-- Employee count per department
SELECT d.department_name, COUNT(e.employee_id) AS total_employees
FROM Departments d
LEFT JOIN Employees e ON d.department_id = e.department_id
GROUP BY d.department_name;

-- Employee with manager name
SELECT e.first_name AS employee_name, m.first_name AS manager_name
FROM Employees e
LEFT JOIN Employees m ON e.manager_id = m.employee_id;

-- Projects with assigned employees
SELECT p.project_name, e.first_name, e.last_name, ep.role
FROM Employee_Projects ep
JOIN Employees e ON ep.employee_id = e.employee_id
JOIN Projects p ON ep.project_id = p.project_id;

-- Highest paid employee per department
SELECT d.department_name, e.first_name, e.last_name, e.salary
FROM Employees e
JOIN Departments d ON e.department_id = d.department_id
WHERE e.salary = (
    SELECT MAX(salary) FROM Employees e2 WHERE e2.department_id = e.department_id
);
CREATE TABLE Payroll (
    payroll_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    basic_salary DECIMAL(10,2),
    hra DECIMAL(10,2),
    bonus DECIMAL(10,2),
    deductions DECIMAL(10,2),
    pay_month VARCHAR(20),
    net_salary DECIMAL(10,2),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

INSERT INTO Payroll (employee_id, basic_salary, hra, bonus, deductions, pay_month, net_salary) VALUES
(1, 750000.00, 15000.00, 5000.00, 8000.00, 'June 2026', 762000.00),
(2, 650000.00, 13000.00, 3000.00, 6500.00, 'June 2026', 659500.00),
(3, 550000.00, 11000.00, 2000.00, 5500.00, 'June 2026', 557500.00),
(4, 50000.00, 5000.00, 1000.00, 2000.00, 'June 2026', 54000.00),
(5, 800000.00, 16000.00, 6000.00, 9000.00, 'June 2026', 813000.00),
(6, 40000.00, 4000.00, 500.00, 1500.00, 'June 2026', 43000.00),
(7, 48000.00, 4800.00, 800.00, 1800.00, 'June 2026', 51800.00);
-- INNER JOIN: Employee + Department + Payroll
SELECT e.first_name, e.last_name, d.department_name, p.net_salary, p.pay_month
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN Payroll p ON e.employee_id = p.employee_id;

-- LEFT JOIN: All employees, even without payroll
SELECT e.first_name, e.last_name, p.net_salary
FROM employees e
LEFT JOIN Payroll p ON e.employee_id = p.employee_id;

-- SELF JOIN: Employee with manager name
SELECT e.first_name AS employees_name, m.first_name AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;

-- Total salary payout per department
SELECT d.department_name, SUM(p.net_salary) AS total_payout
FROM departments d
JOIN employees e ON d.department_id = e.department_id
JOIN Payroll p ON e.employee_id = p.employee_id
GROUP BY d.department_name
ORDER BY total_payout DESC;

-- Employee + Project + Department together
SELECT e.first_name, e.last_name, d.department_name, pr.project_name, ep.role
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN Employee_Projects ep ON e.employee_id = ep.employee_id
JOIN Projects pr ON ep.project_id = pr.project_id;
CREATE TABLE Attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    attendance_date DATE,
    status ENUM('Present', 'Absent', 'Half Day', 'On Leave') DEFAULT 'Present',
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE Leaves (
    leave_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    leave_type ENUM('Sick', 'Casual', 'Paid', 'Unpaid') DEFAULT 'Casual',
    start_date DATE,
    end_date DATE,
    status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

INSERT INTO Attendance (employee_id, attendance_date, status) VALUES
(1, '2026-07-01', 'Present'),
(1, '2026-07-02', 'Present'),
(1, '2026-07-03', 'On Leave'),
(3, '2026-07-01', 'Present'),
(3, '2026-07-02', 'Absent'),
(3, '2026-07-03', 'Present');

INSERT INTO Leaves (employee_id, leave_type, start_date, end_date, status) VALUES
(1, 'Sick', '2026-07-03', '2026-07-03', 'Approved'),
(4, 'Casual', '2026-07-10', '2026-07-12', 'Pending'),
(6, 'Paid', '2026-07-15', '2026-07-16', 'Pending');
CREATE VIEW vw_employee_profile AS
SELECT e.employee_id, e.first_name, e.last_name, d.department_name,
       p.net_salary, p.pay_month
FROM employees e
JOIN departments d ON e.department_id = d.department_id
LEFT JOIN Payroll p ON e.employee_id = p.employee_id;

CREATE VIEW vw_pending_leaves AS
SELECT e.first_name, e.last_name, l.leave_type, l.start_date, l.end_date, l.status
FROM Leaves l
JOIN employees e ON l.employee_id = e.employee_id
WHERE l.status = 'Pending';

CREATE VIEW vw_department_payroll_summary AS
SELECT d.department_name, COUNT(e.employee_id) AS total_employees,
       SUM(p.net_salary) AS total_payroll, AVG(p.net_salary) AS avg_salary
FROM departments d
JOIN employees e ON d.department_id = e.department_id
JOIN Payroll p ON e.employee_id = p.employee_id
GROUP BY d.department_name;

select*from vw_employee_profile;
DELIMITER //

CREATE PROCEDURE GetEmployeeDetails(IN emp_id INT)
BEGIN
    SELECT e.first_name, e.last_name, d.department_name, p.net_salary
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    LEFT JOIN Payroll p ON e.employee_id = p.employee_id
    WHERE e.employee_id = emp_id;
END //
DELIMITER //
CREATE PROCEDURE GiveDepartmentRaise(IN dept_id INT, IN raise_percent DECIMAL(5,2))
BEGIN
    UPDATE Payroll p
    JOIN employees e ON p.employee_id = e.employees_id
    SET p.net_salary = p.net_salary * (1 + raise_percent / 100)
    WHERE e.department_id = dept_id;
END //
DELIMITER //
CREATE PROCEDURE ApplyLeave(
    IN emp_id INT, IN l_type VARCHAR(20),
    IN s_date DATE, IN e_date DATE
)
BEGIN
    INSERT INTO Leaves (employee_id, leave_type, start_date, end_date, status)
    VALUES (emp_id, l_type, s_date, e_date, 'Pending');
END //

DELIMITER ;

--
-- CALL GetEmployeeDetails(1);
-- CALL GiveDepartmentRaise(2, 10);
-- CALL ApplyLeave(7, 'Casual', '2026-07-20', '2026-07-21');
DELIMITER //

CREATE TRIGGER trg_leave_approved
AFTER UPDATE ON Leaves
FOR EACH ROW
BEGIN
    IF NEW.status = 'Approved' AND OLD.status != 'Approved' THEN
        INSERT INTO Attendance (employee_id, attendance_date, status)
        VALUES (NEW.employee_id, NEW.start_date, 'On Leave');
    END IF;
END //

CREATE TRIGGER trg_prevent_negative_salary
BEFORE UPDATE ON Payroll
FOR EACH ROW
BEGIN
    IF NEW.net_salary < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Net salary cannot be negative';
    END IF;
END //

DELIMITER ;

CREATE TABLE Employee_Audit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    action VARCHAR(20),
    action_time DATETIME
);

DELIMITER //

CREATE TRIGGER trg_new_employee_audit
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO Employee_Audit (employee_id, action, action_time)
    VALUES (NEW.employee_id, 'INSERTED', NOW());
END //

DELIMITER ;
-- Rank employees by salary within department
SELECT e.first_name, e.last_name, d.department_name, p.net_salary,
       RANK() OVER (PARTITION BY d.department_name ORDER BY p.net_salary DESC) AS salary_rank
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN Payroll p ON e.employee_id = p.employee_id;

-- Running total of payroll cost
SELECT e.first_name, e.last_name, p.net_salary,
       SUM(p.net_salary) OVER (ORDER BY e.employee_id) AS running_total
FROM employees e
JOIN Payroll p ON e.employee_id = p.employee_id;

-- Compare salary to department average
SELECT e.first_name, e.last_name, d.department_name, p.net_salary,
       AVG(p.net_salary) OVER (PARTITION BY d.department_name) AS dept_avg_salary,
       p.net_salary - AVG(p.net_salary) OVER (PARTITION BY d.department_name) AS diff_from_avg
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN Payroll p ON e.employee_id = p.employee_id;

-- Top 2 highest paid per department
SELECT * FROM (
    SELECT e.first_name, e.last_name, d.department_name, p.net_salary,
           ROW_NUMBER() OVER (PARTITION BY d.department_name ORDER BY p.net_salary DESC) AS rn
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN Payroll p ON e.employee_id = p.employee_id
) ranked
WHERE rn <= 2;
