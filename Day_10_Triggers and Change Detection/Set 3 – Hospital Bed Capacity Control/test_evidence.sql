-- Task 3 – Test a multi-row insert where one admission exceeds capacity
-- 1. Check the initial ward occupancy

SELECT
    w.ward_id,
    w.ward_name,
    w.bed_capacity,
    COUNT(a.admission_id) AS occupied_beds,
    w.bed_capacity - COUNT(a.admission_id) AS available_beds
FROM wards w
LEFT JOIN admissions a
    ON w.ward_id = a.ward_id
GROUP BY
    w.ward_id,
    w.ward_name,
    w.bed_capacity
ORDER BY w.ward_id;

DELETE FROM admissions;

INSERT INTO admissions
(patient_name, ward_id)
VALUES
('Arun', 101),
('Bala', 101);

-- Test a successful multi-row insert
INSERT INTO admissions
(patient_name, ward_id)
VALUES
('Charan', 102),
('David', 102);

SELECT * FROM admissions
WHERE ward_id = 102;

-- Test a multi-row insert that exceeds capacity

BEGIN TRY

    INSERT INTO admissions
    (patient_name, ward_id)
    VALUES
    ('Ezhil', 102),
    ('Farhan', 102);

    PRINT 'Admissions inserted successfully';

END TRY
BEGIN CATCH

    PRINT 'Admission batch rejected';

    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;

END CATCH;

-- Verify the result

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

SELECT *
FROM admission_audit
ORDER BY audit_id;

