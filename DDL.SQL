----DROP TABLES IF EXISTING---
DROP TABLE Patient_Invoice;

DROP TABLE Patient_Medication;

DROP TABLE Patient_MedicalHistory;

DROP TABLE Room_Details;

DROP TABLE Patient_Treatment;

DROP TABLE Patient_LabTest;

DROP TABLE Patient_VitalSigns;

DROP TABLE Patient_Visit;

DROP TABLE Doctor_Records;

DROP TABLE Staff;

DROP TABLE Department;

DROP TABLE Patient_Records;

----CREATE TABLE PATIENT RECORDS ---

CREATE TABLE Patient_Records(
	Patient_ID VARCHAR(7) PRIMARY KEY
	,Patient_First_Name VARCHAR(25) NOT NULL
	,Patient_Last_Name VARCHAR(25) NOT NULL
	,Date_of_Birth DATE NOT NULL
	,Gender VARCHAR(2) NOT NULL
	,Race VARCHAR(25) NOT NULL
	,Ethinicity VARCHAR(25) NOT NULL
	,Phone_No INTEGER NOT NULL
	,Email VARCHAR(25) NOT NULL 
	,House_Street VARCHAR(25) NOT NULL
	,City VARCHAR(25) NOT NULL
	,State VARCHAR(25) NOT NULL
	,Country VARCHAR(25) NOT NULL
	,Zip_Code INTEGER NOT NULL
	,Emergency_Contact_First_Name VARCHAR(25) NOT NULL
	,Emergency_Contact_Start_Name VARCHAR(25) NOT NULL
	,Emergency_Contact_Phone INTEGER NOT NULL
	,Emergency_Contact_Email VARCHAR(25) NOT NULL
	,Emergency_Contact_Street VARCHAR(25) NOT NULL
	,Emergency_Contact_City VARCHAR(25) NOT NULL
	,Emergency_Contact_State VARCHAR(25) NOT NULL
	,Emergency_Contact_Country VARCHAR(25) NOT NULL
	,Emergency_Contact_Zip_code INTEGER NOT NULL
        ,CONSTRAINT check_patient_phonenumber CHECK(LENGTH(Phone_No)=10)
        --,CONSTRAINT check_patient_dateofbirth CHECK(Date_of_Birth < Sys_Date)
        ,CONSTRAINT check_patient_gender CHECK (Gender IN ('M' ,'F','O'))
        ,CONSTRAINT check_patient_email CHECK (REGEXP_LIKE (Email , '^\w+(\.\w+)*+@\w+(\.\w+)+$') )
        ,CONSTRAINT check_emergencycontact_phonenumber CHECK (LENGTHB(Emergency_Contact_Phone)=10)
        ,CONSTRAINT check_emergencycontact_email CHECK (REGEXP_LIKE (Emergency_Contact_Email , '^\w+(\.\w+)*+@\w+(\.\w+)+$') )
        ,CONSTRAINT check_patient_zipcode CHECK (LENGTH(Zip_Code)=5)
        ,CONSTRAINT check_emergencycontact_zipcode CHECK (LENGTH(Emergency_Contact_Zip_code)=5)
        ,CONSTRAINT check_patient_race  CHECK ( Race IN ('White', 'Black or African American',  'Asian American',  'American Indian/Alaska Native',  'Native Hawaiian/Pacific Islander'))
        ,CONSTRAINT check_patient_ethinicity CHECK ( Ethinicity IN ('Hispanic/Latino', 'Non - Hispanic/Latino'))
     
        
);

