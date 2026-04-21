DELIMITER //

CREATE PROCEDURE add_money(IN uid INT, IN amt DECIMAL(10,2))
BEGIN
    UPDATE wallet 
    SET balance = balance + amt 
    WHERE user_id = uid;

    INSERT INTO audit_log(user_id, action)
    VALUES (uid, CONCAT('Added ', amt, ' to wallet'));
END //

CREATE PROCEDURE transfer_money(
    IN sender INT,
    IN receiver INT,
    IN amt DECIMAL(10,2)
)
BEGIN
    DECLARE bal DECIMAL(10,2);

    START TRANSACTION;

    SELECT balance INTO bal 
    FROM wallet 
    WHERE user_id = sender;

    IF bal >= amt THEN

        UPDATE wallet 
        SET balance = balance - amt 
        WHERE user_id = sender;

        UPDATE wallet 
        SET balance = balance + amt 
        WHERE user_id = receiver;

        INSERT INTO transactions(sender_id, receiver_id, amount, status)
        VALUES (sender, receiver, amt, 'SUCCESS');

        COMMIT;

    ELSE
        ROLLBACK;
    END IF;

END //

DELIMITER ;
