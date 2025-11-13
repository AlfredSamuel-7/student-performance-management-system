# Student Performance Management System (SQL Mini Project)

This project is a complete SQL-based system designed to manage students, subjects, marks, and performance analytics. It includes database creation, table structures, sample data insertion, views, stored procedures, and analytical SQL queries.

---

## Project File

**student_performance_management.sql**

This file includes:

- Database creation (`spms`)
- Table definitions:
  - `students`
  - `subjects`
  - `marks`
- Sample data:
  - 10 students
  - 6 subjects
  - 60 marks records
- Views:
  - `student_transcript`
  - `subject_summary`
- Stored Procedure:
  - `sp_insert_mark`
- Useful reporting queries (commented)

---

## Features

### Student Management
- Stores student profile details (name, enrollment number, batch, section, gender, contact).
- Ensures unique enrollment numbers.
- Automatic timestamps.

### Subject Management
- Stores subject codes, names, and credits.

### Marks Management
- Stores marks for Midterm and Final exams.
- Includes exam dates, max marks, and pass marks.

### Performance Analytics
- Student transcript view (average marks per subject).
- Subject summary view (average, maximum, minimum).
- Aggregate and analytical SQL using:
  - Joins
  - Grouping
  - CTEs
  - Window functions (ranking)
- Failure analysis and grade classification.

---

## How to Run

### 1. Using Command Line
```bash
mysql -u root -p < student_performance_management.sql
```

### 2. Using MySQL Workbench
1. Open Workbench  
2. Go to **File → Open SQL Script**  
3. Select `student_performance_management.sql`  
4. Click **Execute**

### 3. Verify
```sql
SHOW DATABASES;
USE spms;
SHOW TABLES;
```

---

## Sample Queries

### Top 5 Performers
```sql
WITH student_avg AS (
    SELECT 
        s.student_id,
        CONCAT(s.first_name, ' ', s.last_name) AS name,
        ROUND(AVG(m.marks_obtained) / AVG(m.max_marks) * 100, 2) AS percentage
    FROM students s
    JOIN marks m ON s.student_id = m.student_id
    GROUP BY s.student_id
)
SELECT *
FROM student_avg
ORDER BY percentage DESC
LIMIT 5;
```

### Subject-wise Average (Final Exam)
```sql
SELECT 
    sub.subject_name,
    ROUND(AVG(m.marks_obtained), 2) AS avg_marks
FROM subjects sub
JOIN marks m ON sub.subject_id = m.subject_id
WHERE m.exam = 'Final'
GROUP BY sub.subject_name;
```

### Student Transcript View
```sql
SELECT *
FROM student_transcript
WHERE student_id = 3;
```

---

## Technologies Used
- MySQL 8.0+
- MySQL Workbench
- SQL (DDL, DML, Joins, Aggregates, CTEs, Window Functions, Views, Stored Procedures)

---

## Developed By
**Alfred Samuel**  
B.Tech – Computer Science and Design (AI & ML)  
Vel Tech Rangarajan Dr. Sagunthala R&D Institute of Science and Technology
