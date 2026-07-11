# Employee Management System (SQL / MySQL)

A relational database project built in MySQL Workbench that models a complete Employee Management System — covering employee records, department structure, project assignments, payroll, and attendance/leave tracking. Built as a hands-on portfolio project to demonstrate practical SQL skills including joins, subqueries, views, stored procedures, triggers, and window functions.

## Tech Stack
- MySQL 8 / MySQL Workbench

## Database Structure

**Core Tables**
- `departments` — department details (name, location)
- `employees` — employee records with self-referencing manager relationship
- `Projects` — project details linked to departments
- `Employee_Projects` — many-to-many mapping of employees to projects with roles

**Payroll Module**
- `Payroll` — basic salary, HRA, bonus, deductions, and net salary per employee per month

**Attendance & Leave Module**
- `Attendance` — daily attendance status per employee
- `Leaves` — leave requests with type and approval status

**Audit**
- `Employee_Audit` — auto-logs new employee inserts (via trigger)

## Features Implemented

- **Joins**: INNER JOIN, LEFT JOIN, SELF JOIN, multi-table joins across employees/departments/projects/payroll
- **Subqueries**: nested subqueries, correlated subqueries, IN/NOT IN, subqueries in WHERE and HAVING
- **Views**: reusable virtual tables for employee profiles, pending leave requests, and department payroll summaries
- **Stored Procedures**: parameterized procedures for fetching employee details, applying department-wide raises, and submitting leave requests
- **Triggers**: auto-update attendance on leave approval, prevent negative salary updates, audit log on new employee insert
- **Window Functions**: RANK(), ROW_NUMBER(), running totals, and department-wise salary comparisons using PARTITION BY

## How to Run

1. Open MySQL Workbench and connect to a local instance
2. Run the table creation scripts in this order: departments → employees → Projects → Employee_Projects → Payroll → Attendance → Leaves
3. Run the corresponding INSERT statements to load sample data
4. Run the Views, Stored Procedures, and Triggers sections (using DELIMITER // blocks as included)
5. Explore the analytical queries (joins, subqueries, window functions) to see reporting in action

## Sample Use Cases Demonstrated
- Department-wise payroll cost analysis
- Ranking employees by salary within their department
- Identifying employees without payroll or project assignments
- Auto-tracking attendance when a leave request is approved

## Author
**Harshita Paliwal**
BSc Computer Science, Bhupal Nobles University, Udaipur
[LinkedIn](https://linkedin.com/in/harshita-paliwal-9ab9a537b)
