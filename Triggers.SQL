CREATE TRIGGER Roomupdate
AFTER UPDATE OF Room_End_Date ON Room_Details
FOR EACH ROW
WHEN (new.Room_End_Date IS NOT NULL)
BEGIN
INSERT INTO Room_Details (room_status)
VALUES ( 'Occupied');
END;
