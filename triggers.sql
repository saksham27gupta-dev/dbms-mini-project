DELIMITER //

CREATE TRIGGER txn_audit_trigger
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    INSERT INTO audit_log(user_id, action)
    VALUES (
        NEW.sender_id,
        CONCAT('Transferred ', NEW.amount, ' to user ', NEW.receiver_id)
    );
END //

DELIMITER ;
