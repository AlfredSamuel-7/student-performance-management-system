-- Student Performance Management System
-- File: student_performance_management.sql
-- Purpose: Create database, tables, sample data, views, and useful queries
-- DBMS: MySQL 8+ (uses window functions and CTEs)

-- ----------------------
-- 1) CLEANUP + DATABASE
-- ----------------------
DROP DATABASE IF EXISTS spms;
CREATE DATABASE spms CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE spms;

-- ----------------------
-- 2) TABLES
-- ----------------------
-- students: basic student information
CREATE TABLE students (
  student_id INT AUTO_INCREMENT PRIMARY KEY,
  enrollment_no VARCHAR(20) NOT NULL UNIQUE,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50),
  dob DATE,
  gender ENUM('M','F','O') DEFAULT 'O',
  batch VARCHAR(20),
  section VARCHAR(10),
  email VARCHAR(100),
  phone VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- subjects: list of subjects offered
CREATE TABLE subjects (
  subject_id INT AUTO_INCREMENT PRIMARY KEY,
  subject_code VARCHAR(20) NOT NULL UNIQUE,
  subject_name VARCHAR(100) NOT NULL,
  credits TINYINT UNSIGNED DEFAULT 3
);

-- marks: stores marks for a student in a subject for a given exam/term
CREATE TABLE marks (
  mark_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  subject_id INT NOT NULL,
  exam VARCHAR(50) NOT NULL,        -- e.g., 'Midterm', 'Final', 'Term1'
  exam_date DATE,
  marks_obtained DECIMAL(5,2) NOT NULL CHECK (marks_obtained >= 0),
  max_marks DECIMAL(5,2) DEFAULT 100,
  pass_marks DECIMAL(5,2) DEFAULT 40,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_marks_student FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
  CONSTRAINT fk_marks_subject FOREIGN KEY (subject_id) REFERENCES subjects(subject_id) ON DELETE CASCADE
);

-- Add some indexes to speed common queries
CREATE INDEX idx_marks_student ON marks(student_id);
CREATE INDEX idx_marks_subject ON marks(subject_id);
CREATE INDEX idx_marks_exam ON marks(exam);

-- ----------------------
-- 3) SAMPLE DATA
-- ----------------------
-- students (10 sample students)
INSERT INTO students (enrollment_no, first_name, last_name, dob, gender, batch, section, email, phone) VALUES
('22UECE0001','Arjun','Kumar','2003-05-12','M','2022-2026','A','arjun.kumar@example.com','+919800000001'),
('22UECE0002','Bhavya','Reddy','2003-09-03','F','2022-2026','A','bhavya.reddy@example.com','+919800000002'),
('22UECE0003','Alfred','Samuel','2003-11-20','M','2022-2026','B','alfred.samuel@example.com','+919800000003'),
('22UECE0004','Chitra','Nair','2004-02-17','F','2022-2026','B','chitra.nair@example.com','+919800000004'),
('22UECE0005','Deepak','Sharma','2003-03-30','M','2022-2026','A','deepak.sharma@example.com','+919800000005'),
('22UECE0006','Esha','Verma','2003-07-05','F','2022-2026','A','esha.verma@example.com','+919800000006'),
('22UECE0007','Faiz','Khan','2003-12-12','M','2022-2026','B','faiz.khan@example.com','+919800000007'),
('22UECE0008','Gita','Patel','2004-01-25','F','2022-2026','A','gita.patel@example.com','+919800000008'),
('22UECE0009','Harish','Iyer','2003-10-11','M','2022-2026','B','harish.iyer@example.com','+919800000009'),
('22UECE0010','Isha','Gupta','2004-04-18','F','2022-2026','A','isha.gupta@example.com','+919800000010');

-- subjects (6 sample subjects)
INSERT INTO subjects (subject_code, subject_name, credits) VALUES
('CS101','Introduction to Programming',4),
('CS102','Data Structures',4),
('CS103','Database Systems',3),
('CS104','Operating Systems',3),
('CS105','Computer Networks',3),
('CS106','Discrete Mathematics',3);

-- marks: create marks for two exams: Midterm and Final
-- We'll insert a few marks for each student and subject (for brevity some subjects are omitted)

-- Helper: simple distribution of marks
INSERT INTO marks (student_id, subject_id, exam, exam_date, marks_obtained, max_marks, pass_marks) VALUES
-- Student 1 (Arjun)
(1,1,'Midterm','2024-09-01',78,100,40),
(1,2,'Midterm','2024-09-01',82,100,40),
(1,3,'Midterm','2024-09-01',74,100,40),
(1,1,'Final','2024-12-15',85,100,40),
(1,2,'Final','2024-12-15',88,100,40),
(1,3,'Final','2024-12-15',79,100,40),

-- Student 2 (Bhavya)
(2,1,'Midterm','2024-09-01',92,100,40),
(2,2,'Midterm','2024-09-01',89,100,40),
(2,3,'Midterm','2024-09-01',95,100,40),
(2,1,'Final','2024-12-15',90,100,40),
(2,2,'Final','2024-12-15',93,100,40),
(2,3,'Final','2024-12-15',94,100,40),

-- Student 3 (Alfred)
(3,1,'Midterm','2024-09-01',60,100,40),
(3,2,'Midterm','2024-09-01',55,100,40),
(3,3,'Midterm','2024-09-01',62,100,40),
(3,1,'Final','2024-12-15',68,100,40),
(3,2,'Final','2024-12-15',64,100,40),
(3,3,'Final','2024-12-15',70,100,40),

-- Student 4 (Chitra)
(4,1,'Midterm','2024-09-01',45,100,40),
(4,2,'Midterm','2024-09-01',50,100,40),
(4,3,'Midterm','2024-09-01',47,100,40),
(4,1,'Final','2024-12-15',52,100,40),
(4,2,'Final','2024-12-15',58,100,40),
(4,3,'Final','2024-12-15',55,100,40),

-- Student 5 (Deepak)
(5,1,'Midterm','2024-09-01',34,100,40), -- failed
(5,2,'Midterm','2024-09-01',40,100,40),
(5,3,'Midterm','2024-09-01',39,100,40),
(5,1,'Final','2024-12-15',48,100,40),
(5,2,'Final','2024-12-15',52,100,40),
(5,3,'Final','2024-12-15',50,100,40),

-- Student 6 (Esha)
(6,1,'Midterm','2024-09-01',88,100,40),
(6,2,'Midterm','2024-09-01',82,100,40),
(6,3,'Midterm','2024-09-01',85,100,40),
(6,1,'Final','2024-12-15',91,100,40),
(6,2,'Final','2024-12-15',89,100,40),
(6,3,'Final','2024-12-15',87,100,40),

-- Student 7 (Faiz)
(7,1,'Midterm','2024-09-01',58,100,40),
(7,2,'Midterm','2024-09-01',61,100,40),
(7,3,'Midterm','2024-09-01',55,100,40),
(7,1,'Final','2024-12-15',65,100,40),
(7,2,'Final','2024-12-15',68,100,40),
(7,3,'Final','2024-12-15',62,100,40),

-- Student 8 (Gita)
(8,1,'Midterm','2024-09-01',75,100,40),
(8,2,'Midterm','2024-09-01',70,100,40),
(8,3,'Midterm','2024-09-01',73,100,40),
(8,1,'Final','2024-12-15',80,100,40),
(8,2,'Final','2024-12-15',78,100,40),
(8,3,'Final','2024-12-15',76,100,40),

-- Student 9 (Harish)
(9,1,'Midterm','2024-09-01',41,100,40),
(9,2,'Midterm','2024-09-01',44,100,40),
(9,3,'Midterm','2024-09-01',38,100,40),
(9,1,'Final','2024-12-15',50,100,40),
(9,2,'Final','2024-12-15',55,100,40),
(9,3,'Final','2024-12-15',49,100,40),

-- Student 10 (Isha)
(10,1,'Midterm','2024-09-01',85,100,40),
(10,2,'Midterm','2024-09-01',87,100,40),
(10,3,'Midterm','2024-09-01',90,100,40),
(10,1,'Final','2024-12-15',88,100,40),
(10,2,'Final','2024-12-15',91,100,40),
(10,3,'Final','2024-12-15',92,100,40);

-- ----------------------
-- 4) VIEWS and STORED QUERIES
-- ----------------------
-- view: student_transcript (average per subject per student across exams)
CREATE OR REPLACE VIEW student_transcript AS
SELECT
  s.student_id,
  s.enrollment_no,
  s.first_name,
  s.last_name,
  sub.subject_id,
  sub.subject_code,
  sub.subject_name,
  ROUND(AVG(m.marks_obtained),2) AS avg_marks,
  ROUND(AVG(m.marks_obtained)/AVG(m.max_marks)*100,2) AS avg_percentage
FROM students s
JOIN marks m ON s.student_id = m.student_id
JOIN subjects sub ON m.subject_id = sub.subject_id
GROUP BY s.student_id, sub.subject_id;

-- view: subject_summary (class average, highest and lowest for each subject & exam)
CREATE OR REPLACE VIEW subject_summary AS
SELECT
  sub.subject_id,
  sub.subject_code,
  sub.subject_name,
  m.exam,
  ROUND(AVG(m.marks_obtained),2) AS avg_marks,
  MAX(m.marks_obtained) AS max_marks,
  MIN(m.marks_obtained) AS min_marks,
  COUNT(*) AS num_records
FROM subjects sub
JOIN marks m ON sub.subject_id = m.subject_id
GROUP BY sub.subject_id, m.exam;

-- ----------------------
-- 5) SAMPLE REPORT QUERIES (UNCOMMENT and RUN as needed)
-- ----------------------

-- 5.1 Full list of students with overall average (across all subjects & exams)
-- SELECT s.student_id, s.enrollment_no, CONCAT(s.first_name,' ',s.last_name) AS student_name,
--        ROUND(AVG(m.marks_obtained),2) AS overall_avg,
--        ROUND(AVG(m.marks_obtained)/AVG(m.max_marks)*100,2) AS overall_percentage
-- FROM students s
-- JOIN marks m ON s.student_id = m.student_id
-- GROUP BY s.student_id
-- ORDER BY overall_percentage DESC;

-- 5.2 Top 5 performers (by overall percentage)
-- WITH student_avg AS (
--   SELECT s.student_id, CONCAT(s.first_name,' ',s.last_name) AS name,
--     ROUND(AVG(m.marks_obtained)/AVG(m.max_marks)*100,2) AS percentage
--   FROM students s JOIN marks m ON s.student_id = m.student_id
--   GROUP BY s.student_id
-- )
-- SELECT *, RANK() OVER (ORDER BY percentage DESC) AS rank FROM student_avg WHERE percentage IS NOT NULL LIMIT 5;

-- 5.3 Subject wise average and toppers
-- SELECT ss.subject_code, ss.subject_name, ss.exam, ss.avg_marks, ss.max_marks
-- FROM subject_summary ss ORDER BY ss.subject_code, ss.exam;

-- 5.4 Students who failed in any subject in Final exam
-- SELECT DISTINCT s.student_id, CONCAT(s.first_name,' ',s.last_name) AS student_name
-- FROM students s JOIN marks m ON s.student_id = m.student_id
-- WHERE m.exam = 'Final' AND m.marks_obtained < m.pass_marks;

-- 5.5 Student transcript (averages per subject) for a given student_id (replace ? with id)
-- SELECT * FROM student_transcript WHERE student_id = 3 ORDER BY subject_code;

-- 5.6 Rank students in Final exam by overall percentage
-- WITH final_avg AS (
--   SELECT s.student_id, CONCAT(s.first_name,' ',s.last_name) AS name,
--     ROUND(SUM(m.marks_obtained)/SUM(m.max_marks)*100,2) AS percentage
--   FROM students s JOIN marks m ON s.student_id = m.student_id
--   WHERE m.exam = 'Final'
--   GROUP BY s.student_id
-- )
-- SELECT *, RANK() OVER (ORDER BY percentage DESC) AS rank FROM final_avg;

-- 5.7 Grade assignment example (A,B,C,D,F) for a given student's Final exam
-- SELECT s.student_id, CONCAT(s.first_name,' ',s.last_name) AS name, f.percentage,
-- CASE
--   WHEN f.percentage >= 90 THEN 'A+'
--   WHEN f.percentage >= 80 THEN 'A'
--   WHEN f.percentage >= 70 THEN 'B'
--   WHEN f.percentage >= 60 THEN 'C'
--   WHEN f.percentage >= 50 THEN 'D'
--   ELSE 'F'
-- END AS grade
-- FROM (
--   SELECT s.student_id, ROUND(SUM(m.marks_obtained)/SUM(m.max_marks)*100,2) AS percentage
--   FROM students s JOIN marks m ON s.student_id = m.student_id
--   WHERE m.exam = 'Final'
--   GROUP BY s.student_id
-- ) f JOIN students s ON s.student_id = f.student_id
-- ORDER BY f.percentage DESC;

-- 5.8 Subject failure rate
-- SELECT sub.subject_code, sub.subject_name,
--   ROUND(SUM(CASE WHEN m.marks_obtained < m.pass_marks THEN 1 ELSE 0 END)/COUNT(*)*100,2) AS failure_percentage
-- FROM subjects sub JOIN marks m ON sub.subject_id = m.subject_id
-- GROUP BY sub.subject_id;

-- ----------------------
-- 6) EXTRA: Example stored procedure to insert a mark safely
-- ----------------------
DELIMITER $$
CREATE PROCEDURE sp_insert_mark(
  IN p_student_id INT,
  IN p_subject_id INT,
  IN p_exam VARCHAR(50),
  IN p_exam_date DATE,
  IN p_marks DECIMAL(5,2),
  IN p_max_marks DECIMAL(5,2)
)
BEGIN
  -- Basic validations
  IF p_marks < 0 OR p_marks > p_max_marks THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid marks value';
  END IF;

  INSERT INTO marks (student_id, subject_id, exam, exam_date, marks_obtained, max_marks)
  VALUES (p_student_id, p_subject_id, p_exam, p_exam_date, p_marks, p_max_marks);
END$$
DELIMITER ;

-- ----------------------
-- 7) NOTES / NEXT STEPS
-- ----------------------
-- 1) To run: save this file as student_performance_management.sql and run:
--    mysql -u <user> -p < student_performance_management.sql
-- 2) Customize: add more subjects, exams, and more students as needed.
-- 3) Extensions: add tables for teachers, classes, attendance, course_enrollment, assignments, weights for grade calculations.
-- 4) Indexes: add composite indexes if queries require (student_id,exam) or (subject_id,exam) for performance.

-- End of file
