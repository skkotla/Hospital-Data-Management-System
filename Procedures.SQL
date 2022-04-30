-------HIRE DOCTOR---------
CREATE OR REPLACE PROCEDURE hire_doctor
(
Doctor_ID VARCHAR,
--Department_ID VARCHAR,
Doctor_First_Name VARCHAR
,Doctor_Last_Name VARCHAR
,Specialization VARCHAR
,Designation VARCHAR
,Doctor_Email VARCHAR
,Doctor_Phone_No VARCHAR
,Doctor_Charge INTEGER
,Doctor_House_Street VARCHAR
,Doctor_City VARCHAR
,Doctor_State VARCHAR
,Doctor_Country VARCHAR
,Doctor_Zip_Code INTEGER
,Doctor_Status VARCHAR
)
IS
EMAIL_INC EXCEPTION;
PHONE_INC EXCEPTION;
department_id Varchar(7);


BEGIN

DBMS_OUTPUT.PUT_LINE('--------------------------------------------HIRING DOCTOR--------------------------------------------');


BEGIN
SELECT Department_ID INTO department_id FROM DEPARTMENT WHERE Department_ID = 'D-101';
EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('Department - ' || department_id || ' is not present');
RETURN;
END;

-- SELECT TO_NUMBER(TO_CHAR(sysdate,'yyyy')) INTO pyear FROM DUAL;

IF NOT REGEXP_LIKE (Doctor_Email,'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$') THEN
RAISE EMAIL_INC;
ELSIF NOT REGEXP_LIKE (Doctor_Phone_No,'[[:digit:]]{10}') THEN
RAISE PHONE_INC;

ELSE
INSERT INTO DOCTOR_RECORDS
VALUES (

Doctor_ID
,Department_ID
,Doctor_First_Name
,Doctor_Last_Name
,Specialization
,Designation
,Doctor_Email
,Doctor_Phone_No
,Doctor_Charge
,Doctor_House_Street
,Doctor_City
,Doctor_State
,Doctor_Country
,Doctor_Zip_Code
,Doctor_Status );

DBMS_OUTPUT.PUT_LINE('DOCTOR - ' || DOCTOR_ID || ' successfully hired');
COMMIT;
END IF;
EXCEPTION
WHEN EMAIL_INC THEN
DBMS_OUTPUT.PUT_LINE('Please enter correct email address');
WHEN PHONE_INC THEN
DBMS_OUTPUT.PUT_LINE('Please enter correct 10 digit phone number');


END hire_doctor;

SET SERVEROUTPUT ON;

--EXECUTE hire_doctor('DOC-201','Sav','Siha','Gynecologists','Fellow','SavSiha@gmail.com',8796543210,300,'Ap #856-859','New York','NY','US',39531,'Available');

EXECUTE hire_doctor('DOC-202','Nihal','Lee','Gynecologists','Fellow','NihalLee@gmail.com',8572079277,300,'Ap #896-859','New York','NY','US',39531,'Available');

SELECT * FROM DOCTOR_RECORDS;

-----------------------DELETE DOCTOR RECORD----------------------------	
	CREATE OR REPLACE PROCEDURE Remove_doctor (
Doc_ID IN Doctor_Records.Doctor_ID%TYPE)
IS
BEGIN
DELETE FROM DOCTOR_RECORDS WHERE Doctor_ID = Doc_ID;
END;


SELECT * FROM DOCTOR_RECORDS;

EXECUTE Remove_doctor('DOC-202');

------------------UPDATE PATIENT RECORD---------------
CREATE OR REPLACE PROCEDURE update_patient_information
( Pat_id IN VARCHAR
,Pat_First_Name IN VARCHAR
,Pat_Last_Name IN VARCHAR
,D_O_B IN DATE
,Gen IN VARCHAR
,Race IN VARCHAR
,Ethinicity IN VARCHAR
,Phoneno IN INTEGER
,Email IN VARCHAR
,HouseStreet IN VARCHAR
,City IN VARCHAR
,State IN VARCHAR
,Country IN VARCHAR
,Zip IN INTEGER
,EmergencyContactFirst_Name IN VARCHAR
,EmergencyContactStart_Name IN VARCHAR
,EmergencyContactPhone IN INTEGER
,EmergencyContactEmail IN VARCHAR
,EmergencyContactStreet IN VARCHAR
,EmergencyContactCity IN VARCHAR
,EmergencyContactState IN VARCHAR
,EmergencyContactCountry IN VARCHAR
,EmergencyContactZipcode IN INTEGER )
IS
s_pat PATIENT_RECORDS%ROWTYPE;
updateno NUMBER := 0;
GENDER_INCORRECT EXCEPTION;
STATE_INCORRECT EXCEPTION;
EMAIL_INCORRECT EXCEPTION;
PHONE_INCORRECT EXCEPTION;
--pati_id NUMBER;
NO_INPUT_TO_UPDATE EXCEPTION;
BEGIN
DBMS_OUTPUT.PUT_LINE('--------------------------------------------UPDATING PATIENT DETAILS--------------------------------------------');
BEGIN
SELECT * INTO s_pat FROM PATIENT_RECORDS WHERE patient_id = Pat_id;
EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('Patient - ' || Pat_id || ' not found in the sytem');
RETURN;
END;
IF Gen IS NOT NULL THEN
IF Gen NOT IN ('M','F','NA') THEN
RAISE GENDER_INCORRECT;
END IF;
s_pat.Gender := Gen;
updateno := 1;
END IF;
IF State IS NOT NULL THEN
IF LENGTH(State)>2 THEN
RAISE STATE_INCORRECT;
END IF;
s_pat.State := State;
updateno := 1;
END IF;
IF Email IS NOT NULL THEN
IF NOT REGEXP_LIKE (Email,'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$') THEN
RAISE EMAIL_INCORRECT;
END IF;
s_pat.Email := Email;
updateno := 1;
END IF;
IF Phoneno IS NOT NULL THEN
IF NOT REGEXP_LIKE (Phoneno,'[[:digit:]]{10}') THEN
RAISE PHONE_INCORRECT;
END IF;
s_pat.Phone_No := Phoneno;
updateno := 1;
END IF;
--IF PRIM_C_DOC IS NOT NULL THEN
--SELECT doctor_id INTO doc_id FROM DOCTOR WHERE doctor_id = PRIM_C_DOC;
--s_pat.PRIM_CARE_DOC_ID := PRIM_C_DOC;
--updateno := 1;
--END IF;
IF Pat_First_Name IS NOT NULL THEN
s_pat.Patient_First_Name := Pat_First_Name;
updateno := 1;
END IF;
IF Pat_Last_Name IS NOT NULL THEN
s_pat.Patient_Last_Name := Pat_Last_Name;
updateno := 1;
END IF;
IF D_O_B IS NOT NULL THEN
s_pat.Date_of_Birth := D_O_B;
updateno := 1;
END IF;
IF Race IS NOT NULL THEN
s_pat.Race := Race;
updateno := 1;
END IF;
IF Ethinicity IS NOT NULL THEN
s_pat.Ethinicity := Ethinicity;
updateno := 1;
END IF;
IF HouseStreet IS NOT NULL THEN
s_pat.House_Street := HouseStreet;
updateno := 1;
END IF;
IF City IS NOT NULL THEN
s_pat.City := City;
updateno := 1;
END IF;
IF Country IS NOT NULL THEN
s_pat.Country := Country;
updateno := 1;
END IF;IF Zip IS NOT NULL THEN
s_pat.Zip_Code := Zip;
updateno := 1;
END IF;
IF EmergencyContactFirst_Name IS NOT NULL THEN
s_pat.Emergency_Contact_First_Name := EmergencyContactFirst_Name;
updateno := 1;
END IF;
IF EmergencyContactStart_Name IS NOT NULL THEN
s_pat.Emergency_Contact_Start_Name := EmergencyContactStart_Name;
updateno := 1;
END IF;
IF EmergencyContactPhone IS NOT NULL THEN
s_pat.Emergency_Contact_Phone := EmergencyContactPhone;
updateno := 1;
END IF;
IF EmergencyContactEmail IS NOT NULL THEN
s_pat.Emergency_Contact_Email := EmergencyContactEmail;
updateno := 1;
END IF;
IF EmergencyContactStreet IS NOT NULL THEN
s_pat.Emergency_Contact_Street := EmergencyContactStreet;
updateno := 1;
END IF;
IF EmergencyContactCity IS NOT NULL THEN
s_pat.Emergency_Contact_City := EmergencyContactCity;
updateno := 1;
END IF;
IF EmergencyContactState IS NOT NULL THEN
s_pat.Emergency_Contact_State := EmergencyContactState;
updateno := 1;
END IF;
IF EmergencyContactCountry IS NOT NULL THEN
s_pat.Emergency_Contact_Country := EmergencyContactCountry;
updateno := 1;
END IF;
IF EmergencyContactZipcode IS NOT NULL THEN
s_pat.Emergency_Contact_Zip_code := EmergencyContactZipcode;
updateno := 1;
END IF;
IF updateno = 0 THEN
RAISE NO_INPUT_TO_UPDATE;
ELSE
UPDATE PATIENT_RECORDS SET ROW = s_pat WHERE patient_id = Pat_id;
DBMS_OUTPUT.PUT_LINE('Patient - ' || Pat_id || ' updated successfully ');
COMMIT;
END IF;
EXCEPTION
WHEN GENDER_INCORRECT THEN
DBMS_OUTPUT.PUT_LINE('Wrong input - Only supported GENDER by system - M/F/NA');
WHEN STATE_INCORRECT THEN
DBMS_OUTPUT.PUT_LINE('Wrong input - Please enter 2 character STATE code');
WHEN EMAIL_INCORRECT THEN
DBMS_OUTPUT.PUT_LINE('Wrong input - Please enter emailId in correct format');
WHEN PHONE_INCORRECT THEN
DBMS_OUTPUT.PUT_LINE('Wrong input - Please enter a 10 digit phone number');
--WHEN NO_DATA_FOUND THEN
--DBMS_OUTPUT.PUT_LINE('Wrong input - Primary care doctor not found in system');
WHEN NO_INPUT_TO_UPDATE THEN
DBMS_OUTPUT.PUT_LINE('No input fields to Update');
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE(SQLERRM);
END update_patient_information;


SET SERVEROUTPUT ON;

EXECUTE update_patient_information('PAT-117',	'Zhang',	'Wright',	'11-Nov-98'	,	'M',	'White',	'Non - Hispanic/Latino',	7636789023,	'ZhangW@gmail.com',	'8A, Temp St',	'Dallas',	'TX',	'US',	90003,	'Dean',	'Hope',	6631413838,	'Hope@gmail.edu',	'7A, Temp St',	'Dallas',	'TX',	'US',	90003	); 

SELECT * FROM PATIENT_RECORDS;




---------------DELETE PATIENT RECORD---------------
CREATE OR REPLACE PROCEDURE Remove_patient (
Pat_ID IN Patient_Records.Patient_ID%TYPE)
IS
BEGIN
DELETE FROM patient_records WHERE Patient_ID = Pat_ID;
END;

SET SERVEROUTPUT ON;

EXECUTE Remove_patient('PAT-117');

SELECT * FROM PATIENT_RECORDS;


---Show patient billing for a patient
CREATE OR REPLACE PROCEDURE Show_Patients_Billing
(pat_id varchar)
IS
r_bill View_Patients_Billing%ROWTYPE;
rcount NUMBER := 0;
BEGIN
FOR r_bill IN (SELECT * FROM View_Patients_Billing WHERE patient_id = pat_id)
LOOP
IF rcount = 0 THEN
DBMS_OUTPUT.PUT_LINE('----------------------------------- Medical History for ' || r_bill.PATIENT_NAME || ' -----------------------------------');
DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------------------------------------');
DBMS_OUTPUT.PUT_LINE('Age: ' || r_bill.age);
DBMS_OUTPUT.PUT_LINE('Gender: ' || r_bill.gender);
DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------------------------------------');
DBMS_OUTPUT.PUT_LINE('PAYMENT DATE | BILL ID | TOTAL CHARGE | PATIENT ID');
END IF;
DBMS_OUTPUT.PUT_LINE(r_bill.Payment_Date || ' | ' || RPAD(r_bill.Bill_ID,16,' ') || ' | ' || RPAD(r_bill.Total_Billing,26,' ') || ' | ' || r_bill.patient_id);
rcount := 1;
END LOOP;
IF rcount = 0 THEN
DBMS_OUTPUT.PUT_LINE('------------------------------- There is no bill for Patient ID - ' || pat_id || ' -------------------------------');
END IF;
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/




-- Show patient total billing 
set SERVEROUTPUT ON;
-- With incorrect patient id
EXECUTE show_patients_billing('PAT-101');



