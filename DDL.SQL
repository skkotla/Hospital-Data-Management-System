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

---CREATE TABLE DEPARTMENT RECORDS ---

CREATE TABLE Department (	
Department_ID	Varchar(7)	Primary Key,
Department_Name	Varchar(25)	Not Null,
Responsibilities		Varchar(25)	Not Null,
CONSTRAINT check_departname CHECK ( Department_Name IN ('Staff', 'Doctor'))
);

----CREATE TABLE STAFF RECORDS ---
CREATE TABLE Staff (
	Staff_ID VARCHAR(7) PRIMARY KEY
	,Department_ID Varchar(7) REFERENCES Department(Department_ID)
	,Staff_First_Name VARCHAR(25) NOT NULL
	,Staff_Last_Name VARCHAR(25) NOT NULL
	,Staff_Role VARCHAR(25) NOT NULL
	,Staff_Level VARCHAR(25) NOT NULL
	,Staff_Email VARCHAR(25) NOT NULL
	,Staff_Phone_No VARCHAR(25) NOT NULL
	,Staff_House_Street VARCHAR(25) NOT NULL
	,Staff_City VARCHAR(25) NOT NULL
	,Staff_State VARCHAR(25) NOT NULL
	,Staff_Country VARCHAR(25) NOT NULL
	,Staff_Zip_Code INTEGER NOT NULL
        ,CONSTRAINT check_staff_phonenumber CHECK(LENGTH(Staff_Phone_No )=10)
        ,CONSTRAINT check_staff_email CHECK (REGEXP_LIKE (Staff_Email , '^\w+(\.\w+)*+@\w+(\.\w+)+$') )
        ,CONSTRAINT check_staff_zipcode CHECK (LENGTH(Staff_Zip_Code)=5)
	);
	
----CREATE TABLE DOCTORS RECORDS ---
    
CREATE TABLE Doctor_Records (
	Doctor_ID Varchar(7) PRIMARY KEY
	,Department_ID Varchar(7) REFERENCES Department(Department_ID)
	,Doctor_First_Name VARCHAR(25) NOT NULL
	,Doctor_Last_Name VARCHAR(25) NOT NULL
	,Specialization VARCHAR(25) NOT NULL
	,Designation VARCHAR(25) NOT NULL
	,Doctor_Email VARCHAR(25) NOT NULL
	,Doctor_Phone_No VARCHAR(25) NOT NULL
	,Doctor_Charge INTEGER NOT NULL
	,Doctor_House_Street VARCHAR(25) NOT NULL
	,Doctor_City VARCHAR(25) NOT NULL
	,Doctor_State VARCHAR(25) NOT NULL
	,Doctor_Country VARCHAR(25) NOT NULL
	,Doctor_Zip_Code INTEGER NOT NULL
        ,CONSTRAINT check_doctor_phonenumber CHECK(LENGTH(Doctor_Phone_No )=10)
        ,CONSTRAINT check_doctor_email CHECK (REGEXP_LIKE (Doctor_Email , '^\w+(\.\w+)*+@\w+(\.\w+)+$') )
        ,CONSTRAINT check_doctor_zipcode CHECK (LENGTH(Doctor_Zip_Code)=10)
        ,CONSTRAINT check_doctor_charge CHECK (Doctor_Charge >=0)
	);
	
----CREATE TABLE PATIENT VISIT RECORDS ---
    
CREATE TABLE Patient_Visit (
	 Visit_ID VARCHAR(7) PRIMARY KEY
	,Patient_ID VARCHAR(7) REFERENCES Patient_Records(Patient_ID)
	,Doctor_ID VARCHAR(7) REFERENCES Doctor_Records(Doctor_ID)
	,Diagnostic_Details VARCHAR(200) NOT NULL
	,Visit_Date DATE NOT NULL
    --CONSTRAINT check_Visit_Date CHECK(Visit_Date < Sys_Date)
	);

----CREATE TABLE PATIENT VITALSIGNS RECORDS ---
    
CREATE TABLE Patient_VitalSigns (
	Vital_ID VARCHAR(7) PRIMARY KEY,
    Patient_ID	Varchar(7)	REFERENCES Patient_Records(Patient_ID)
    ,Staff_ID	Varchar(7)	REFERENCES Staff(Staff_ID)
    ,Visit_ID	Varchar(7)	REFERENCES Patient_Visit(Visit_ID)
	,Systolic_Blood_Pressure INTEGER NOT NULL
	,Diastolic_Blood_Pressure INTEGER NOT NULL
	,Heart_Rate INTEGER NOT NULL
	,Height_cms INTEGER NOT NULL
	,Weight_kgs INTEGER NOT NULL
	,Comments VARCHAR(100) NOT NULL
	,Nurse_Fee FLOAT NOT NULL
	,Vitals_Date_Time DATE NOT NULL
	);
 
----CREATE TABLE PATIENT LABTEST RECORDS ---
   
CREATE TABLE Patient_LabTest (
	Test_ID VARCHAR(7) PRIMARY KEY
	,Test_Name VARCHAR(25) NOT NULL
	,Test_Description VARCHAR(200) NOT NULL
	,Patient_ID Varchar(7)	REFERENCES Patient_Records(Patient_ID)
	,Doctor_ID VARCHAR(7)  REFERENCES Doctor_Records(Doctor_ID)
	,Visit_ID  Varchar(7)	REFERENCES Patient_Visit(Visit_ID)
	,Test_Result  VARCHAR(25) NOT NULL
	,Test_Comments VARCHAR(200) NOT NULL
	,Test_Center  VARCHAR(100) NOT NULL
	,Staff_ID Varchar(7)	REFERENCES Staff(Staff_ID)
	,Test_Date_Time DATE NOT NULL
	,Result_Date_Time DATE NOT NULL
	,Lab_Charge FLOAT NOT NULL
    ,CONSTRAINT check_Lab_Charge CHECK(Lab_Charge > 0)
	);

----CREATE TABLE PATIENT TREATMENT RECORDS ---

CREATE TABLE Patient_Treatment (
Treatment_ID Varchar(7)	Primary Key,
Patient_ID	Varchar(7)	REFERENCES PATIENT_RECORDS(Patient_ID),
Doctor_ID	Varchar(7)	REFERENCES DOCTOR_RECORDS(Doctor_ID),
Visit_ID	Varchar(7)	REFERENCES Patient_Visit(Visit_ID),
Treatment_End_Date	Date	Null,
Treatment_Start_Date	Date	Not Null,
Ongoing_Flag	Varchar(2)	Null,
Lab_Test_Flag	Varchar(2)	Null,
Treatment	Varchar(10)	Null,
Dose Integer	Null,
Dose_Units	Varchar(10)	Null,
Treatment_Route	Varchar(10)	Null,
Treatment_Frequency	 Varchar(10)	Null,
Remarks		Varchar(200)	Null,
Diagnostic_Details	Varchar(200)	Not Null,
Hospitalized	Varchar(2)	Null,
Operation_Charge Float	Not Null,
CONSTRAINT check_Date_Comparision CHECK(Treatment_Start_Date < Treatment_End_Date),
CONSTRAINT check_Ongoing_Flag CHECK(Ongoing_Flag IN('Y','N')),
CONSTRAINT check_LabTest_Flag CHECK(Lab_Test_Flag IN('Y','N')),
CONSTRAINT check_OperationCharge CHECK(Operation_Charge >=0)
);


----CREATE TABLE ROOM DETAILS RECORDS ---

CREATE TABLE Room_Details (
	 Room_ID VARCHAR(7) PRIMARY KEY
	,Patient_ID	Varchar(7)	REFERENCES Patient_Records(Patient_ID) 
	,Visit_ID	Varchar(7)	REFERENCES Patient_Visit(Visit_ID)
	,Room_Start_Date DATE NOT NULL
	,Room_End_Date DATE NULL
	,Room_Daily_Charge FLOAT NOT NULL
	,No_of_Days INTEGER NOT NULL
	,Room_Charge INTEGER NULL
    ,CONSTRAINT check_Room_Charge CHECK(Room_Charge >=0)
	);

----CREATE TABLE PATIENT MEDICAL HISTORY RECORDS ---

CREATE TABLE Patient_MedicalHistory (
	MedicalHistory_ID VARCHAR(10) PRIMARY KEY
	,Patient_ID	Varchar(7)	REFERENCES Patient_Records(Patient_ID)
	,Medical_History_Term VARCHAR(25) NOT NULL
	,Medical_History_Description VARCHAR(100) NOT NULL
	,Medical_History_Start_Date DATE NOT NULL
	,Ongoing VARCHAR(2) NULL
	,Medical_History_End_Date DATE NULL
        ,CONSTRAINT check_Medical_Ongoing CHECK (Ongoing= 'Y' OR Ongoing='N')
        --,CONSTRAINT check_Medical_History_Start_Date CHECK(Medical_History_Start_Date < Sys_Date)
        ,CONSTRAINT check_Medication_History_Dates CHECK(Medical_History_Start_Date < Medical_History_End_Date)
        --,CONSTRAINT check_Medication_Future_End_Date CHECK(Medical_History_Start_Date < Sys_Date)
	);

----CREATE TABLE PATIENT MEDICATION RECORDS ---

CREATE TABLE Patient_Medication (
	Medication_ID Varchar(7) PRIMARY KEY 
    ,MedicalHistory_ID Varchar(7) REFERENCES Patient_MedicalHistory(MedicalHistory_ID)
	,Patient_ID	Varchar(7)	REFERENCES Patient_Records(Patient_ID)
	,Medications VARCHAR(25) NOT NULL
	,Medication_Dose INTEGER NULL
	,Medication_Dose_Units VARCHAR(10) NULL
	,Medication_Route VARCHAR(10) NULL
	,Medication_Frequency VARCHAR(10) NULL
	,Medication_Start_Date DATE NOT NULL
	,Medication_End_Date DATE NULL
	,Medication_Ongoing VARCHAR(2) NULL
        ,CONSTRAINT check_Medication_Ongoing CHECK (Medication_Ongoing = 'Y' OR Medication_Ongoing ='N')
       -- ,CONSTRAINT check_Medication_Future_Start_Date CHECK(Medication_Start_Date < Sys_Date)
        ,CONSTRAINT check_History_Dates CHECK(Medication_Start_Date < Medication_End_Date)
        --,CONSTRAINT check_Medication_Future_End_Date CHECK(Medication_End_Date < Sys_Date)
	);

----CREATE TABLE PATIENT INVOICE RECORDS ---

CREATE TABLE Patient_Invoice (
	Bill_ID VARCHAR(7) PRIMARY KEY
	,Patient_ID	Varchar(7) REFERENCES Patient_Records(Patient_ID)
	,Payment_Date Date NOT NULL
	,Doctor_Charge INTEGER NOT NULL
	,Nurse_Charge INTEGER NOT NULL
	,Operation_Charge INTEGER NULL
	,Number_of_days INTEGER NULL
	,Room_Charge INTEGER NULL
	,Health_Card INTEGER NULL
	,Lab_Charge INTEGER NULL
	,Total_Billing INTEGER NOT NULL
	);




