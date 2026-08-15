USE biobank_db;

-- View 1: Complete Donor Profile with Consent Status
CREATE VIEW view_donor_profiles AS
SELECT 
    d.Donor_ID, 
    CONCAT(d.First_Name, ' ', d.Last_Name) AS Full_Name,
    d.Contact_Number, 
    c.Consent_Type, 
    c.Consent_Date
FROM Donor d
JOIN Consent c ON d.Donor_ID = c.Donor_ID;

-- View 2: Detailed Sample Inventory
CREATE VIEW view_sample_inventory AS
SELECT 
    s.Sample_ID, 
    st.Type_Name, 
    s.Volume_ml, 
    s.Collection_Date,
    sl.Freezer_Number, 
    sl.Box_Number
FROM Sample s
JOIN Sample_Type st ON s.Type_ID = st.Type_ID
JOIN Storage_Location sl ON s.Location_ID = sl.Location_ID
WHERE s.Volume_ml > 0;
