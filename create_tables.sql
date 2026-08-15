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
