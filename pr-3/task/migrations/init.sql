-- Create students table
IF OBJECT_ID('dbo.students', 'U') IS NOT NULL
    DROP TABLE dbo.students;

CREATE TABLE dbo.students (
  studentId IDENTITY(1,1) PRIMARY KEY,
  studentName NVARCHAR(255) NOT NULL,
  age INT NOT NULL,
  groupNumber INT NOT NULL
);

-- Optional seed data
INSERT INTO dbo.students (studentName, age, groupNumber) VALUES
('Alice', 20, 1),
('Bob', 22, 1),
('Charlie', 21, 2);