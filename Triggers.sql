ALTER TRIGGER  Check_participant_limit
ON study_meetings
FOR INSERT
AS
BEGIN
    DECLARE @participants_count INT;
    DECLARE @max_limit INT = 100;

    SELECT @participants_count = COUNT(*)
    FROM study_meetings
    WHERE study_meeting_id IN (SELECT study_meeting_id FROM inserted);

    IF @participants_count >= @max_limit
    BEGIN
        RAISERROR ('Przekroczono limit uczestników w spotkaniu studiów.', 16, 1);
        ROLLBACK;
    END;
END;


CREATE OR ALTER TRIGGER Update_order_date
ON Orders
AFTER UPDATE
AS
BEGIN
    UPDATE Orders
    SET order_date = GETDATE()
    WHERE order_id IN (SELECT order_id FROM inserted);
END;



CREATE TRIGGER Update_order_status
ON orders
AFTER UPDATE
AS
BEGIN
    UPDATE orders
    SET order_succeed = CASE
        WHEN order_succeed = 1 THEN 1
        ELSE 0
    END
    WHERE order_id IN (SELECT order_id FROM inserted);
END;




CREATE OR ALTER TRIGGER Check_payment_amount
ON Courses_Order_Details
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    DECLARE @min_payment_amount MONEY = 10.00;

    IF EXISTS (
        SELECT *
        FROM inserted
        WHERE unit_price < @min_payment_amount
    )
    BEGIN
        PRINT 'Kwota p³atnoœci jest mniejsza ni¿ minimalna.';
        ROLLBACK TRANSACTION;
    END;
    ELSE
    BEGIN
        INSERT INTO Courses_Order_Details (order_id, course_id, unit_price)
        SELECT order_id, course_id, unit_price
        FROM inserted;
    END;
END;




CREATE OR ALTER TRIGGER Update_course_description
ON Modules
AFTER INSERT
AS
BEGIN
    UPDATE c
    SET description = m.description
    FROM Courses c
    INNER JOIN inserted i ON c.course_id = i.course_id
    INNER JOIN Modules m ON i.module_id = m.module_id;
END;



CREATE OR ALTER TRIGGER Update_diploma_status
ON Courses_Users
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE d
    SET diploma_ready = 1, diploma_sent = 0
    FROM Courses_Users_Diplomas d
    INNER JOIN inserted i ON d.user_id = i.user_id;
END;



CREATE OR ALTER TRIGGER Check_language_uniqueness
ON Languages
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE EXISTS (
            SELECT 1
            FROM Languages l
            WHERE l.language_name = i.language_name
            AND l.language_id <> COALESCE(i.language_id, 0)
        )
    )
    BEGIN
        PRINT ('Jêzyk o podanej nazwie ju¿ istnieje.');
        ROLLBACK TRANSACTION;
    END;
    ELSE
    BEGIN
        INSERT INTO Languages (language_id, language_name)
        SELECT language_id, language_name
        FROM inserted;
    END;
END;



CREATE OR ALTER TRIGGER Check_translator_existence
ON Translators_Languages
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE NOT EXISTS (
            SELECT 1
            FROM Translators t
            WHERE t.translator_id = i.translator_id
        )
    )
    BEGIN
        PRINT ('Podany t³umacz nie istnieje.');
        ROLLBACK TRANSACTION;
    END;
END;



CREATE OR ALTER TRIGGER Update_translator_id
ON Translators
AFTER UPDATE
AS
BEGIN
    UPDATE tl
    SET tl.translator_id = i.translator_id
    FROM Translators_Languages tl
    INNER JOIN inserted i ON tl.translator_id = i.translator_id;
END;
– Trigger do sprawdzania, czy jêzyk istnieje w tabeli Languages w tabeli Classes_Languages

CREATE OR ALTER TRIGGER Karolcheck_language_existence_classes_languages
ON Classes_Languages
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE NOT EXISTS (
            SELECT 1
            FROM Languages l
            WHERE l.language_id = i.language_id
        )
    )
    BEGIN
        PRINT ('Podany jêzyk nie istnieje.');
        ROLLBACK TRANSACTION;
    END;
END;



CREATE OR ALTER TRIGGER Update_webinar_description
ON Webinars
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Webinars (webinar_id, title, description, is_free)
    SELECT
        webinar_id,
        title,
        COALESCE(description, 'No description'),
        is_free
    FROM inserted;
END;




CREATE OR ALTER TRIGGER Check_webinar_price
ON Webinars_Prices
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.price < 0
    )
    BEGIN
        PRINT ('Cena webinaru nie mo¿e byæ ujemna.');
        ROLLBACK TRANSACTION;
    END;
    ELSE
    BEGIN
        INSERT INTO Webinars_Prices (webinar_id, price)
        SELECT webinar_id, price
        FROM inserted;
    END;
END;



CREATE OR ALTER TRIGGER Check_shared_from_date
ON Webinars_Users
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE YEAR(i.shared_from) < 2020
    )
    BEGIN
        PRINT ('Data udostêpnienia webinaru nie mo¿e byæ wczeœniejsza ni¿ 2020 rok.');
        ROLLBACK TRANSACTION;
    END;
END;



CREATE OR ALTER TRIGGER  Check_pay_due_date
ON Users_Webinars_Exceptions
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE YEAR(i.pay_due) < 2020
    )
    BEGIN
        PRINT ('Termin p³atnoœci nie mo¿e byæ wczeœniejszy ni¿ 2020 rok.');
        ROLLBACK TRANSACTION;
    END;
END;



CREATE OR ALTER TRIGGER Check_dates
ON Employees_Roles
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE start_date >= end_date OR YEAR(start_date) < 2020
    )
    BEGIN
        PRINT('Nieprawid³owe daty w tabeli Employees_Roles');
    END;
    ELSE
    BEGIN
        INSERT INTO Employees_Roles (employee_id, employee_type_id, start_date, end_date)
        SELECT employee_id, employee_type_id, start_date, end_date
        FROM inserted;
    END;
END;



CREATE OR ALTER TRIGGER Check_unique_address
ON Addresses
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE EXISTS (
            SELECT 1
            FROM Addresses a
            WHERE a.street = i.street
            AND a.house_number = i.house_number
            AND a.postal_code = i.postal_code
            AND a.buiding_name = i.buiding_name
        )
    )
    BEGIN
        PRINT('Duplikat adresu w tabeli Addresses');
    END;
    ELSE
    BEGIN
        INSERT INTO Addresses (address_id, city_id, street, house_number, postal_code, buiding_name)
        SELECT address_id, city_id, street, house_number, postal_code, buiding_name
        FROM inserted;
    END;
END;



CREATE OR ALTER TRIGGER Check_unique_login
ON Employees
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE EXISTS (
            SELECT 1
            FROM Employees e
            WHERE e.login = i.login
        )
    )
    BEGIN
        PRINT('Login pracownika ju¿ istnieje');
    END;
    ELSE
    BEGIN
        INSERT INTO Employees (employee_id, first_name, last_name, phone, email, login, password)
        SELECT employee_id, first_name, last_name, phone, email, login, password
        FROM inserted;
    END;
END;
