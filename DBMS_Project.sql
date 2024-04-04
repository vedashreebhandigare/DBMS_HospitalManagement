CREATE TABLE Patient 
(
    P_Id INT primary key,
    P_Name VARCHAR(80),
    Gender VARCHAR(10), 
    DOB DATE,           
    Mob_No BIGINT,      
    Age INT
);

INSERT INTO Patient (P_Id, P_Name, Gender, DOB, Mob_No, Age)
VALUES
(101, 'John Doe', 'Male', '1985-06-20', 1112223333, 36),
(102, 'Jane Smith', 'Female', '1990-09-15', 4445556666, 31),
(103, 'Michael Brown', 'Male', '1978-03-10', 7778889999, 46),
(104, 'Emily Johnson', 'Female', '2000-12-25', 9998887777, 24);


create table Employee(
E_Id int PRIMARY KEY,
Address varchar(40),
Gender varchar(10),
DOB date,
Mob_No bigint,
Salary int);
INSERT INTO Employee (E_Id, Address, Gender, DOB, Mob_No, Salary) VALUES
(1, '123 Main St, CityA', 'Male', '1990-05-15', 1234567890, 50000),
(2, '456 Elm St, CityB', 'Female', '1992-08-20', 9876543210, 60000),
(3, '789 Oak St, CityC', 'Male', '1988-12-10', 5554443333, 55000),
(4, '321 Pine St, CityD', 'Female', '1995-03-25', 9998887777, 65000),
(5, '654 Maple St, CityE', 'Male', '1991-07-05', 3332221111, 70000);

create table Doctor(
D_Name varchar(20),
Dept varchar(40),
Qualification varchar(50));
INSERT INTO Doctor (D_Name, Dept, Qualification) VALUES
('Dr. Smith', 'Cardiology', 'MD, Cardiology'),
('Dr. Johnson', 'Orthopedics', 'MD, Orthopedics'),
('Dr. Williams', 'Pediatrics', 'MD, Pediatrics'),
('Dr. Brown', 'Neurology', 'MD, Neurology');

create table Nurse(
N_Name varchar(20),
Shift varchar(40));
INSERT INTO Nurse (N_Name, Shift) VALUES
('Emily', 'Morning'),
('Sarah', 'Evening'),
('John', 'Night');


create table Receptionist(
Re_Name varchar(20));
INSERT INTO Receptionist (Re_Name) VALUES
('Rebecca'),
('Daniel');


create table Rooms(
R_Id int PRIMARY KEY,
R_Type varchar(40),
P_Id int,
Availability varchar(10),
D_Name varchar(20),
FOREIGN KEY (P_Id) REFERENCES Patient(P_Id));
INSERT INTO Rooms (R_Id, R_Type,P_Id, Availability, D_Name) VALUES
(1, 'Single',101, 'Available', 'Dr. Smith'),
(2, 'Double',102, 'Occupied', 'Dr. Johnson'),
(3, 'Single',103, 'Available', NULL),
(4, 'ICU',104, 'Available', 'Dr. Brown');

create table Records(
Record_no int,
App_no int);
INSERT INTO Records (Record_no, App_no) VALUES
(1, 101),
(2, 102),
(3, 103),
(4, 104);

create table Bills(
B_Id int primary KeY,
P_Id int,
Amount int,
foreign key(P_Id) references Patient(P_Id));
INSERT INTO Bills (B_Id, P_Id, Amount) VALUES
(1, 101, 500),
(2, 102, 750),
(3, 103, 400),
(4, 104, 1200);


create table Test_Report(
R_Id int,
P_Id int,
Test_type varchar(10),
Result varchar(40),
FOREIGN KEY(R_ID) REFERENCES Rooms(R_Id),
foreign key(P_ID) references Patient(P_Id));
INSERT INTO Test_Report (R_Id, P_Id, Test_type, Result) VALUES
(1, 101, 'Blood', 'Normal'),
(2, 102, 'X-Ray', 'Abnormal'),
(3, 103, 'MRI', 'Normal'),
(4, 104, 'Ultrasound', 'Abnormal');
SELECT * FROM test_report;

-- QUERIES

-- 1. Retrieve all doctors from the Cardiology department
SELECT * FROM Doctor WHERE Dept = 'Cardiology';

-- 2. Retrieve the names of all available rooms along with the assigned doctor 
SELECT R_Id, R_Type, Availability, D_Name FROM Rooms WHERE Availability = 'Available';

-- 3. Insert a new patient record into the database
INSERT INTO Patient (P_Id, P_Name, Gender, DOB, Mob_No, Age) 
VALUES (105, 'David Lee', 'Male', '1995-04-30', 6667778888, 29);


-- 4. Retrieve patient names along with their corresponding test results
SELECT p.P_Name AS Patient_Name, tr.Test_type AS Test_Type, tr.Result AS Test_Result
FROM Patient p LEFT JOIN Test_Report tr ON p.P_Id = tr.P_Id;

-- 5.Calculate the total bill amount for each patient
SELECT 
    p.P_Name AS Patient_Name, 
    SUM(b.Amount) AS Total_Bill_Amount
FROM Patient p LEFT JOIN Bills b ON p.P_Id = b.P_Id GROUP BY p.P_Name;

-- 6. Check for any potential data integrity issues (e.g., patients without assigned rooms or doctors)
SELECT * FROM Patient WHERE P_Id NOT IN (SELECT P_Id FROM Rooms);
SELECT * FROM Patient WHERE P_Id NOT IN (SELECT P_Id FROM Doctor);

-- 7. Having Clause to Filter Doctors with More Than One Patient
SELECT D_Name, COUNT(*) AS Patient_Count
FROM Rooms
GROUP BY D_Name
HAVING COUNT(*) > 1;

-- 8. Retrieve the details of all patients who have undergone tests
SELECT DISTINCT p.*
FROM Patient p
INNER JOIN Test_Report tr ON p.P_Id = tr.P_Id;

-- 9.Create a View to Show Nurses and Their Shifts and display it
CREATE VIEW Nurse_Shifts AS
SELECT N_Name, Shift FROM Nurse;
SELECT * FROM Nurse_Shifts;

-- 10. Retrieve the list of patients along with their ages, sorted in descending order of age
SELECT P_Name AS Patient_Name, Age
FROM Patient
ORDER BY Age DESC;

-- 11.calculate the average bill amount for each patient individually
SELECT P_Id, AVG(Amount) AS Avg_Bill_Amount
FROM Bills
GROUP BY P_Id;

-- 12. Query to count the total number of patients
SELECT COUNT(*) AS Total_Patients
FROM Patient;

-- 13. Retrieve the details of patients who have abnormal test results:
SELECT * FROM Patient
WHERE P_Id IN (SELECT P_Id FROM Test_Report WHERE Result = 'Abnormal');

-- 14. Retrieve the details of patients who have not undergone any tests:
SELECT P.*
FROM Patient P
LEFT JOIN Test_Report TR ON P.P_Id = TR.P_Id
WHERE TR.P_Id IS NULL;

-- 15. Retrieve doctor details along with corresponding room details:
SELECT D_name
FROM Doctor
RIGHT JOIN Rooms ON Doctor.D_Name = Rooms.D_Name;

-- 16. Retrieve nurse details along with corresponding room details:
SELECT *
FROM Nurse
NATURAL JOIN Rooms;

-- 17.Retrieve the names of all receptionists
SELECT Re_Name FROM Receptionist;

-- 18. Retrieve the average age of patients
SELECT AVG(Age) AS Average_Patient_Age FROM Patient;

-- 19.Retrieve patient and doctor name along with corresponding room
SELECT P_Name,D_Name,R_Id
FROM patient
NATURAL JOIN Rooms;

-- 20.Insert a new nurse record into the database
INSERT INTO Nurse(N_Name, Shift) VALUES
('Sahil', 'Evening');








