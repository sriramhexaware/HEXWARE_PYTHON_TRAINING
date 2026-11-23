CREATE TABLE wards
(
    ward_id INT PRIMARY KEY,
    ward_name VARCHAR(100),
    bed_capacity INT
);
CREATE TABLE admissions
(
    admission_id INT IDENTITY(1,1) PRIMARY KEY,
    patient_name VARCHAR(100),
    ward_id INT,
    admission_date DATETIME2 DEFAULT SYSDATETIME(),

    FOREIGN KEY (ward_id)
    REFERENCES wards(ward_id)
);
INSERT INTO wards
VALUES
(101, 'General Ward', 2),
(102, 'Emergency Ward', 3),
(103, 'ICU Ward', 1);
SELECT * FROM wards;

-- Task 1 – Create a trigger that blocks an admission when the ward's occupied beds equal its capacity and raises a meaningful error
-- Create the admission capacity trigger

CREATE TRIGGER trg_check_ward_capacity
ON admissions
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check whether the specified ward exists
    IF EXISTS
    (
        SELECT 1
        FROM inserted i
        LEFT JOIN wards w
            ON i.ward_id = w.ward_id
        WHERE w.ward_id IS NULL
    )
    BEGIN
        THROW 51002,
        'Admission rejected: specified ward does not exist.',
        1;
    END;

    -- Check whether the new admissions exceed ward capacity
    IF EXISTS
    (
        SELECT 1
        FROM wards w WITH (UPDLOCK, HOLDLOCK)

        INNER JOIN
        (
            SELECT
                ward_id,
                COUNT(*) AS incoming_count
            FROM inserted
            GROUP BY ward_id
        ) i
            ON w.ward_id = i.ward_id

        CROSS APPLY
        (
            SELECT COUNT(*) AS occupied_count
            FROM admissions a WITH (UPDLOCK, HOLDLOCK)
            WHERE a.ward_id = w.ward_id
        ) o

        WHERE o.occupied_count + i.incoming_count > w.bed_capacity
    )
    BEGIN
        THROW 51001,
        'Admission rejected: ward has no available beds.',
        1;
    END;

    -- Insert only when capacity is available
    INSERT INTO admissions
    (
        patient_name,
        ward_id,
        admission_date
    )
    SELECT
        patient_name,
        ward_id,
        COALESCE(admission_date, SYSDATETIME())
    FROM inserted;
END;

-- Test the trigger
-- Test A – Successful admission
INSERT INTO admissions
(patient_name, ward_id)
VALUES
('Arun', 101);

-- Test B – Fill the remaining bed
INSERT INTO admissions
(patient_name, ward_id)
VALUES
('Bala', 101);

-- Test C – Try admitting another patient
BEGIN TRY

    INSERT INTO admissions
    (patient_name, ward_id)
    VALUES
    ('Charan', 101);

END TRY
BEGIN CATCH

    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;

END CATCH;

-- Test D – Verify the final records
SELECT
    w.ward_name,
    w.bed_capacity,
    COUNT(a.admission_id) AS occupied_beds,
    w.bed_capacity - COUNT(a.admission_id) AS available_beds
FROM wards w
LEFT JOIN admissions a
    ON w.ward_id = a.ward_id
GROUP BY
    w.ward_name,
    w.bed_capacity;

-- Task 2 – Create an AFTER trigger to record admission changes
-- Create the admission_audit table

CREATE TABLE admission_audit
(
    audit_id INT IDENTITY(1,1) PRIMARY KEY,

    admission_id INT,

    old_patient_name VARCHAR(100),
    new_patient_name VARCHAR(100),

    old_ward_id INT,
    new_ward_id INT,

    operation_type VARCHAR(20),

    changed_by VARCHAR(100),
    changed_at DATETIME2 DEFAULT SYSDATETIME()
);

-- Create the AFTER trigger
CREATE TRIGGER trg_admission_audit
ON admissions
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO admission_audit
    (
        admission_id,
        old_patient_name,
        new_patient_name,
        old_ward_id,
        new_ward_id,
        operation_type,
        changed_by,
        changed_at
    )
    SELECT
        COALESCE(i.admission_id, d.admission_id),

        d.patient_name,
        i.patient_name,

        d.ward_id,
        i.ward_id,

        CASE
            WHEN d.admission_id IS NULL THEN 'INSERT'
            WHEN i.admission_id IS NULL THEN 'DELETE'
            ELSE 'UPDATE'
        END,

        SUSER_SNAME(),
        SYSDATETIME()

    FROM inserted i
    FULL OUTER JOIN deleted d
        ON i.admission_id = d.admission_id;
END;

-- Test the audit trigger
-- Test A – INSERT

INSERT INTO admissions
(patient_name, ward_id)
VALUES
('David', 102);

SELECT * FROM admission_audit;

-- Test B – UPDATE

UPDATE admissions
SET ward_id = 103
WHERE patient_name = 'David';
SELECT * FROM admission_audit
ORDER BY audit_id;

-- Test C – DELETE
DELETE FROM admissions
WHERE patient_name = 'David';

SELECT * FROM admission_audit
ORDER BY audit_id;

-- Test D – Verify all operations

SELECT
    audit_id,
    admission_id,
    old_patient_name,
    new_patient_name,
    old_ward_id,
    new_ward_id,
    operation_type,
    changed_by,
    changed_at
FROM admission_audit
ORDER BY audit_id;

