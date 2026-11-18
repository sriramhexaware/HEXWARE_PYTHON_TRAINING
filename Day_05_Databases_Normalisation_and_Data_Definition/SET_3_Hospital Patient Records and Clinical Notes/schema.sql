-- Database and Table creation

USE Hexaware;


CREATE TABLE Patients (
    Patient_ID INT IDENTITY(1,1) PRIMARY KEY,
    Patient_Name VARCHAR(100) NOT NULL,
    Address VARCHAR(200) NOT NULL,
    Phone_Number VARCHAR(15) 
);

CREATE TABLE Departments (
    Department_ID INT IDENTITY(1,1) PRIMARY KEY,
    Department_Name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Doctors (
    Doctor_ID INT IDENTITY(1,1) PRIMARY KEY,
    Doctor_Name VARCHAR(100) NOT NULL,
    Department_ID INT NOT NULL,

    FOREIGN KEY (Department_ID)
    REFERENCES Departments(Department_ID)
);

CREATE TABLE Visits (
    Visit_ID INT IDENTITY(1,1) PRIMARY KEY,
    Patient_ID INT NOT NULL,
    Doctor_ID INT NOT NULL,
    Visit_Date DATE NOT NULL,
    Diagnosis VARCHAR(200) NOT NULL,
    Prescription VARCHAR(500),

    CONSTRAINT CK_Visits_VisitDate
    CHECK (Visit_Date <= CAST(GETDATE() AS DATE)),

    FOREIGN KEY (Patient_ID)
    REFERENCES Patients(Patient_ID),

    FOREIGN KEY (Doctor_ID)
    REFERENCES Doctors(Doctor_ID)
);

CREATE TABLE Billing (
    Bill_ID INT IDENTITY(1,1) PRIMARY KEY,
    Visit_ID INT NOT NULL UNIQUE,
    Bill_Amount DECIMAL(12,2) NOT NULL,
    Payment_Status VARCHAR(20) NOT NULL DEFAULT 'Open',

    CONSTRAINT CK_Billing_Amount
    CHECK (Bill_Amount >= 0),

    CONSTRAINT CK_Billing_Status
    CHECK (Payment_Status IN ('Open', 'Paid', 'Pending')),

    FOREIGN KEY (Visit_ID)
    REFERENCES Visits(Visit_ID)
);

-- insert records
INSERT INTO Departments (Department_Name)
VALUES
('Cardiology'),
('Neurology'),
('Orthopedics'),
('General Medicine'),
('Dermatology');

INSERT INTO Patients (Patient_Name, Address, Phone_Number)
VALUES
('Arun Kumar', 'T Nagar, Chennai', '9876543210'),
('Priya Sharma', 'RS Puram, Coimbatore', '9876543211'),
('Rahul Verma', 'Anna Nagar, Chennai', '9876543212'),
('Divya Raj', 'MG Road, Bangalore', '9876543213'),
('Karthik S', 'Peelamedu, Coimbatore', '9876543214');

INSERT INTO Doctors (Doctor_Name, Department_ID)
VALUES
('Dr. Rajesh', 1),
('Dr. Meera', 2),
('Dr. Suresh', 3),
('Dr. Priya', 4),
('Dr. Anand', 5);

INSERT INTO Visits
(Patient_ID, Doctor_ID, Visit_Date, Diagnosis, Prescription)
VALUES
(1, 1, '2026-11-01', 'High Blood Pressure', 'Amlodipine 5mg'),
(2, 2, '2026-11-03', 'Migraine', 'Paracetamol 500mg'),
(3, 3, '2026-10-15', 'Knee Pain', 'Pain Relief Medication'),
(4, 4, '2026-10-20', 'Fever', 'Paracetamol 650mg'),
(5, 5, '2026-09-10', 'Skin Allergy', 'Antihistamine'),
(1, 4, '2026-11-10', 'Common Cold', 'Cetirizine 10mg'),
(2, 1, '2026-11-12', 'Chest Pain', 'Further Evaluation'),
(3, 3, '2026-11-14', 'Joint Pain', 'Physiotherapy');

INSERT INTO Billing (Visit_ID, Bill_Amount, Payment_Status)
VALUES
(1, 2500.00, 'Paid'),
(2, 1800.00, 'Open'),
(3, 3500.00, 'Paid'),
(4, 1200.00, 'Pending'),
(5, 900.00, 'Open'),
(6, 1500.00, 'Paid'),
(7, 5000.00, 'Open'),
(8, 2200.00, 'Pending');

--Test the DEFAULT constraint
INSERT INTO Billing (Visit_ID, Bill_Amount)
VALUES (9, 3000.00);


--Alter Commands
ALTER TABLE Patients
ADD insurance_id VARCHAR(30);

--Rename table
EXEC sp_rename 'Doctors', 'HospitalDoctors';

--new insert
INSERT INTO Visits
(Patient_ID, Doctor_ID, Visit_Date, Diagnosis, Prescription)
VALUES
(4, 2, '2026-11-16', 'Severe Headache', 'MRI Scan Recommended');

--update patient record
UPDATE Visits
SET Diagnosis = 'Migraine'
WHERE Visit_ID = 9;

--delete a record
DELETE FROM Billing
WHERE Visit_ID = 8;

--patients visited this month
SELECT
    P.Patient_ID,
    P.Patient_Name,
    V.Visit_Date,
    V.Diagnosis
FROM Patients P
INNER JOIN Visits V
    ON P.Patient_ID = V.Patient_ID
WHERE V.Visit_Date BETWEEN '2026-11-01' AND '2026-11-30';

--retrive doctor
SELECT
    D.Doctor_ID,
    D.Doctor_Name,
    DP.Department_Name
FROM HospitalDoctors D
INNER JOIN Departments DP
    ON D.Department_ID = DP.Department_ID
WHERE DP.Department_Name LIKE '%Cardio%';




