CREATE OR REPLACE TRIGGER Roomupdate
AFTER INSERT
ON Room_Details
FOR EACH ROW
BEGIN
UPDATE room set room_status = 'Occupied' WHERE room_id = :new.room_id;
DBMS_OUTPUT.PUT_LINE('Room - ' || :new.room_id || ' is Occupied now - by update_room_sts_after_admission Trigger');
END;
