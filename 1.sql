CREATE DATABASE IF NOT EXISTS biobank_db;
USE biobank_db;

-- 1. Donor
CREATE TABLE Donor (
    Donor_ID INT AUTO_INCREMENT PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Date_of_Birth DATE NOT NULL,
    Contact_Number VARCHAR(20)
);

-- 2. Consent
CREATE TABLE Consent (
    Consent_ID INT AUTO_INCREMENT PRIMARY KEY,
    Donor_ID INT NOT NULL,
    Consent_Date DATE NOT NULL,
    Consent_Type VARCHAR(50) NOT NULL, -- e.g., General, Specific
    FOREIGN KEY (Donor_ID) REFERENCES Donor(Donor_ID) ON DELETE CASCADE
);

-- 3. Sample_Type
CREATE TABLE Sample_Type (
    Type_ID INT AUTO_INCREMENT PRIMARY KEY,
    Type_Name VARCHAR(50) NOT NULL UNIQUE,
    Handling_Instructions TEXT
);

-- 4. Storage_Location
CREATE TABLE Storage_Location (
    Location_ID INT AUTO_INCREMENT PRIMARY KEY,
    Freezer_Number VARCHAR(20) NOT NULL,
    Shelf_Number INT NOT NULL,
    Box_Number INT NOT NULL
);

-- 5. Sample
CREATE TABLE Sample (
    Sample_ID INT AUTO_INCREMENT PRIMARY KEY,
    Donor_ID INT NOT NULL,
    Type_ID INT NOT NULL,
    Location_ID INT NOT NULL,
    Collection_Date DATE NOT NULL,
    Volume_ml FLOAT CHECK (Volume_ml >= 0),
    FOREIGN KEY (Donor_ID) REFERENCES Donor(Donor_ID) ON DELETE CASCADE,
    FOREIGN KEY (Type_ID) REFERENCES Sample_Type(Type_ID) ON DELETE RESTRICT,
    FOREIGN KEY (Location_ID) REFERENCES Storage_Location(Location_ID) ON DELETE RESTRICT
);

-- 6. Researcher
CREATE TABLE Researcher (
    Researcher_ID INT AUTO_INCREMENT PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Institution_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE
);

-- 7. Test_Request
CREATE TABLE Test_Request (
    Request_ID INT AUTO_INCREMENT PRIMARY KEY,
    Researcher_ID INT NOT NULL,
    Request_Date DATE NOT NULL,
    Status ENUM('Pending', 'Approved', 'Rejected', 'Completed') DEFAULT 'Pending',
    FOREIGN KEY (Researcher_ID) REFERENCES Researcher(Researcher_ID) ON DELETE CASCADE
);

-- 8. Sample_Usage (Associative Table M:N)
CREATE TABLE Sample_Usage (
    Sample_ID INT NOT NULL,
    Request_ID INT NOT NULL,
    Quantity_Used_ml FLOAT NOT NULL CHECK (Quantity_Used_ml > 0),
    Usage_Date DATE NOT NULL,
    PRIMARY KEY (Sample_ID, Request_ID),
    FOREIGN KEY (Sample_ID) REFERENCES Sample(Sample_ID) ON DELETE CASCADE,
    FOREIGN KEY (Request_ID) REFERENCES Test_Request(Request_ID) ON DELETE CASCADE
);
USE biobank_db;

-- Insert Donors
INSERT INTO Donor (First_Name, Last_Name, Date_of_Birth, Contact_Number) VALUES
('Ahmed', 'Hassan', '1985-04-12', '01012345678'), ('Sara', 'Ali', '1990-08-25', '01123456789'),
('Mohamed', 'Ibrahim', '1978-11-05', '01234567890'), ('Mona', 'Zaki', '1995-02-14', '01098765432'),
('Omar', 'Farouk', '1982-09-30', '01198765432'), ('Layla', 'Mahmoud', '1988-12-01', '01298765432'),
('Khaled', 'Said', '1975-06-18', '01055556666'), ('Hana', 'Gamal', '1992-03-22', '01166667777'),
('Youssef', 'Nabil', '1980-10-10', '01277778888'), ('Nour', 'El-Din', '1998-07-07', '01088889999');

-- Insert Consents
INSERT INTO Consent (Donor_ID, Consent_Date, Consent_Type) VALUES
(1, '2026-01-10', 'General'), (2, '2026-01-15', 'Specific'),
(3, '2026-02-01', 'General'), (4, '2026-02-20', 'General'),
(5, '2026-03-05', 'Specific'), (6, '2026-03-12', 'General'),
(7, '2026-04-10', 'General'), (8, '2026-04-18', 'Specific'),
(9, '2026-05-02', 'General'), (10, '2026-05-22', 'General');

-- Insert Sample Types
INSERT INTO Sample_Type (Type_Name, Handling_Instructions) VALUES
('Whole Blood', 'Keep refrigerated at 4C'), ('Blood Plasma', 'Freeze at -80C immediately'),
('Genomic DNA', 'Store at -20C'), ('RNA Extract', 'Store at -80C, sensitive to degradation'),
('Saliva', 'Keep at room temperature before extraction'), ('Tissue Biopsy', 'Snap freeze in liquid nitrogen'),
('Urine', 'Refrigerate at 4C'), ('Serum', 'Freeze at -20C'),
('Cell Culture', 'Incubate at 37C'), ('Protein Extract', 'Store at -80C');

-- Insert Storage Locations
INSERT INTO Storage_Location (Freezer_Number, Shelf_Number, Box_Number) VALUES
('F-01', 1, 1), ('F-01', 1, 2), ('F-01', 2, 1), ('F-02', 1, 1), ('F-02', 1, 2),
('F-03', 1, 1), ('F-03', 2, 1), ('F-04', 1, 1), ('F-04', 2, 2), ('F-05', 1, 1);

-- Insert Samples
INSERT INTO Sample (Donor_ID, Type_ID, Location_ID, Collection_Date, Volume_ml) VALUES
(1, 1, 1, '2026-01-12', 10.5), (2, 2, 2, '2026-01-16', 5.0),
(3, 3, 3, '2026-02-02', 2.0), (4, 4, 4, '2026-02-21', 1.5),
(5, 5, 5, '2026-03-06', 8.0), (6, 6, 6, '2026-03-13', 0.5),
(7, 7, 7, '2026-04-11', 15.0), (8, 8, 8, '2026-04-19', 4.0),
(9, 9, 9, '2026-05-03', 10.0), (10, 10, 10, '2026-05-23', 3.0);

-- Insert Researchers
INSERT INTO Researcher (First_Name, Last_Name, Institution_Name, Email) VALUES
('Tarek', 'Fahmy', 'Nile University', 'tfahmy@nu.edu.eg'), ('Dina', 'Samy', 'Nile University', 'dsamy@nu.edu.eg'),
('Magdy', 'Tolba', 'Cairo University', 'mtolba@cu.edu.eg'), ('Rania', 'Kamal', 'Ain Shams University', 'rkamal@asu.edu.eg'),
('Wael', 'Ghonim', 'Nile University', 'wghonim@nu.edu.eg'), ('Salma', 'Adel', 'Alexandria University', 'sadel@alexu.edu.eg'),
('Hisham', 'Zaki', 'Nile University', 'hzaki@nu.edu.eg'), ('Noha', 'Fouad', 'Cairo University', 'nfouad@cu.edu.eg'),
('Kareem', 'Safwat', 'Nile University', 'ksafwat@nu.edu.eg'), ('Eman', 'Tawfik', 'Ain Shams University', 'etawfik@asu.edu.eg');

-- Insert Test Requests
INSERT INTO Test_Request (Researcher_ID, Request_Date, Status) VALUES
(1, '2026-06-01', 'Approved'), (2, '2026-06-05', 'Pending'),
(3, '2026-06-10', 'Completed'), (4, '2026-06-12', 'Rejected'),
(5, '2026-06-15', 'Approved'), (6, '2026-06-18', 'Pending'),
(7, '2026-06-20', 'Completed'), (8, '2026-06-22', 'Approved'),
(9, '2026-06-25', 'Pending'), (10, '2026-06-28', 'Approved');

-- Insert Sample Usage
INSERT INTO Sample_Usage (Sample_ID, Request_ID, Quantity_Used_ml, Usage_Date) VALUES
(1, 1, 2.0, '2026-06-02'), (2, 3, 1.5, '2026-06-11'),
(3, 5, 0.5, '2026-06-16'), (4, 7, 1.0, '2026-06-21'),
(5, 8, 3.0, '2026-06-23'), (6, 10, 0.2, '2026-06-29'),
(7, 1, 5.0, '2026-06-03'), (8, 3, 2.0, '2026-06-12'),
(9, 5, 4.0, '2026-06-17'), (10, 7, 1.0, '2026-06-22');
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
USE biobank_db;

DELIMITER //

-- Trigger: Prevent using more sample volume than available
CREATE TRIGGER trg_check_sample_volume
BEFORE INSERT ON Sample_Usage
FOR EACH ROW
BEGIN
    DECLARE available_volume FLOAT;
    
    -- Check how much volume the sample currently has
    SELECT Volume_ml INTO available_volume 
    FROM Sample 
    WHERE Sample_ID = NEW.Sample_ID;
    
    -- If they try to use more than available, throw an error
    IF NEW.Quantity_Used_ml > available_volume THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Requested quantity exceeds available sample volume.';
    END IF;
END//

DELIMITER ;
