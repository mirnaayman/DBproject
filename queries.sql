USE biobank_db;

-- Query 1: Total Volume and Count of Samples grouped by Sample Type
SELECT 
    st.Type_Name, 
    COUNT(s.Sample_ID) AS Total_Samples, 
    SUM(s.Volume_ml) AS Total_Available_Volume_ml
FROM Sample_Type st
LEFT JOIN Sample s ON st.Type_ID = s.Type_ID
GROUP BY st.Type_Name;

-- Query 2: Approved Requests with Researcher Details
SELECT 
    tr.Request_ID, 
    CONCAT(r.First_Name, ' ', r.Last_Name) AS Researcher_Name, 
    r.Institution_Name, 
    tr.Request_Date, 
    tr.Status
FROM Test_Request tr
JOIN Researcher r ON tr.Researcher_ID = r.Researcher_ID
WHERE tr.Status = 'Approved';

-- Query 3: Total Sample Volume Consumed per Test Request
SELECT 
    su.Request_ID, 
    COUNT(su.Sample_ID) AS Samples_Used, 
    SUM(su.Quantity_Used_ml) AS Total_Volume_Drawn_ml
FROM Sample_Usage su
GROUP BY su.Request_ID;

-- Query 4: Audit Storage Location utilization
SELECT 
    sl.Freezer_Number, 
    sl.Shelf_Number, 
    sl.Box_Number, 
    s.Sample_ID, 
    st.Type_Name
FROM Storage_Location sl
JOIN Sample s ON sl.Location_ID = s.Location_ID
JOIN Sample_Type st ON s.Type_ID = st.Type_ID
ORDER BY sl.Freezer_Number, sl.Shelf_Number;

-- Query 5: Donors who contributed RNA or DNA samples
SELECT DISTINCT 
    d.Donor_ID, 
    CONCAT(d.First_Name, ' ', d.Last_Name) AS Donor_Name, 
    st.Type_Name
FROM Donor d
JOIN Sample s ON d.Donor_ID = s.Donor_ID
JOIN Sample_Type st ON s.Type_ID = st.Type_ID
WHERE st.Type_Name IN ('Genomic DNA', 'RNA Extract');

-- Query 6: Nested query / subquery
-- Donors whose samples have an above-average volume
SELECT 
    d.Donor_ID, 
    d.First_Name, 
    d.Last_Name
FROM Donor d
WHERE d.Donor_ID IN (
    SELECT s.Donor_ID 
    FROM Sample s
    WHERE s.Volume_ml > (SELECT AVG(Volume_ml) FROM Sample)
);

-- Query 7: Insert operation
-- Log a new test request from an existing researcher
INSERT INTO Test_Request (Researcher_ID, Request_Date, Status)
VALUES (2, '2026-07-01', 'Pending');

-- Query 8: Update operation
-- Approve the request just inserted above
UPDATE Test_Request
SET Status = 'Approved'
WHERE Researcher_ID = 2 AND Request_Date = '2026-07-01';

-- Query 9: Delete operation
-- Remove a sample usage record (e.g. logged in error)
DELETE FROM Sample_Usage
WHERE Sample_ID = 6 AND Request_ID = 10;
