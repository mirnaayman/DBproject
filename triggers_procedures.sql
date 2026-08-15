USE biobank_db;

DELIMITER //

-- Trigger 1: Prevent using more sample volume than available
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

-- Trigger 2: Deduct the used quantity from the sample's remaining volume
-- Fixes the gap where sp_deduct_sample_volume existed but was never called:
-- without this, Volume_ml never actually decreased after a usage record
-- was inserted, so trg_check_sample_volume always compared against the
-- original volume instead of what was really left.
CREATE TRIGGER trg_deduct_sample_volume
AFTER INSERT ON Sample_Usage
FOR EACH ROW
BEGIN
    UPDATE Sample
    SET Volume_ml = Volume_ml - NEW.Quantity_Used_ml
    WHERE Sample_ID = NEW.Sample_ID;
END//

-- Procedure: Manual/standalone volume deduction (e.g. for corrections
-- or usage recorded outside of a normal Sample_Usage insert)
CREATE PROCEDURE sp_deduct_sample_volume(
    IN p_sample_id INT,
    IN p_quantity FLOAT
)
BEGIN
    UPDATE Sample
    SET Volume_ml = Volume_ml - p_quantity
    WHERE Sample_ID = p_sample_id;
END//

DELIMITER ;
