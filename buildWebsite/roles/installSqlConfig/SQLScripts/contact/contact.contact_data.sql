--
-- CONTACT / CONTACT_DATA
--
DELIMITER //

DROP TABLE IF EXISTS CONTACT.CONTACT_DATA //

CREATE TABLE CONTACT.CONTACT_DATA (
    CN VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL UNIQUE,
    EMAIL VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    TELEPHONENUMBER VARCHAR(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL NOT NULL,
    PAGER VARCHAR(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    PRIMARY KEY (CN),
    UNIQUE KEY EMAIL (EMAIL),
    INDEX IDX_CONTACT (CN, EMAIL, TELEPHONENUMBER, PAGER),
    FULLTEXT KEY FT_USERS (EMAIL, TELEPHONENUMBER, PAGER),
    CONSTRAINT FK_CONTACT_DATA
        FOREIGN KEY (CN)
        REFERENCES CWSSEC.USERS (CN)
            ON DELETE CASCADE
            ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COLLATE utf8mb4_0900_ai_ci //
COMMIT //

GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON CONTACT.* TO 'appadm'@'localhost' //
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON CONTACT.* TO 'appadm'@'appsrv.lan' //

--
--
--
DROP PROCEDURE IF EXISTS CONTACT.updateUserEmail //
DROP PROCEDURE IF EXISTS CONTACT.updateUserContact //
DROP PROCEDURE IF EXISTS CONTACT.getUserByEmail //
DROP PROCEDURE IF EXISTS CONTACT.validateEmailUpdate //
DROP PROCEDURE IF EXISTS CONTACT.getContactData //

CREATE PROCEDURE CONTACT.getUserByEmail(
    IN attributeName VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci
)
BEGIN
    SELECT
        CN,
        EMAIL,
        TELEPHONENUMBER,
        PAGER,
    MATCH (EMAIL, TELEPHONENUMBER, PAGER)
    AGAINST (+attributeName WITH QUERY EXPANSION)
    FROM CONTACT.CONTACT_DATA
    WHERE MATCH (EMAIL, TELEPHONENUMBER, PAGER)
    AGAINST (+attributeName);
END //
COMMIT //

CREATE PROCEDURE CONTACT.updateUserEmail(
    IN reqUserGuid VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
    IN newEmail VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
    OUT updateCount INTEGER
)
BEGIN
    UPDATE CONTACT.CONTACT_DATA
    SET EMAIL = newEmail
    WHERE CN = reqUserGuid;

    COMMIT;

    SELECT COUNT(*)
    INTO updateCount
    FROM CONTACT.CONTACT_DATA
    WHERE CN = reqUserGuid
    AND EMAIL = newEmail;
END //
COMMIT //

CREATE PROCEDURE CONTACT.validateEmailUpdate(
    IN reqUserGuid VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
    IN newEmail VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci
)
BEGIN
    SELECT COUNT(*)
    FROM CONTACT.CONTACT_DATA
    WHERE EMAIL = newEmail
    AND CN = reqUserGuid;
END //
COMMIT //

CREATE PROCEDURE CONTACT.updateUserContact(
    IN reqUserGuid VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
    IN newPhone VARCHAR(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
    IN newCell VARCHAR(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
    OUT updateCount INTEGER
)
BEGIN
    UPDATE CONTACT.CONTACT_DATA
    SET
        TELEPHONENUMBER = newPhone,
        PAGER = newCell
    WHERE
        CN = reqUserGuid;

    COMMIT;

    SELECT COUNT(*)
    INTO updateCount
    FROM CONTACT.CONTACT_DATA
    WHERE CN = reqUserGuid
    AND TELEPHONENUMBER = newPhone
    AND PAGER = newCell;
END //
COMMIT //

GRANT EXECUTE ON PROCEDURE CONTACT.updateUserContact TO 'appadm'@'localhost' //
GRANT EXECUTE ON PROCEDURE CONTACT.updateUserEmail TO 'appadm'@'localhost' //
GRANT EXECUTE ON PROCEDURE CONTACT.getUserByEmail TO 'appadm'@'localhost' //
GRANT EXECUTE ON PROCEDURE CONTACT.validateEmailUpdate TO 'appadm'@'localhost' //
GRANT EXECUTE ON PROCEDURE CONTACT.validateEmailUpdate TO 'appadm'@'localhost' //
GRANT EXECUTE ON PROCEDURE CONTACT.updateUserContact TO 'appadm'@'localhost' //

GRANT EXECUTE ON PROCEDURE CONTACT.updateUserContact TO 'appadm'@'appsrv.lan' //
GRANT EXECUTE ON PROCEDURE CONTACT.updateUserContact TO 'appadm'@'appsrv.lan' //
GRANT EXECUTE ON PROCEDURE CONTACT.updateUserEmail TO 'appadm'@'appsrv.lan' //
GRANT EXECUTE ON PROCEDURE CONTACT.getUserByEmail TO 'appadm'@'appsrv.lan' //
GRANT EXECUTE ON PROCEDURE CONTACT.validateEmailUpdate TO 'appadm'@'appsrv.lan' //

DELIMITER ;
