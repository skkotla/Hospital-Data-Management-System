CREATE OR REPLACE PROCEDURE delete_table(ObjName varchar2,ObjType varchar2)
IS
 v_counter number := 0;   
BEGIN
  if ObjType = 'TABLE' then
    select count(*) into v_counter from user_tables where table_name = upper(ObjName);
    if v_counter > 0 then          
      execute immediate 'drop table ' || ObjName || ' cascade constraints';        
    end if;   
  end if;
END;
/

call delete_table('PATIENT_RECORDS','TABLE');

CREATE TABLE Patient_Records (
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



call delete_table('DEPARTMENT','TABLE');

CREATE TABLE Department (	
Department_ID	Varchar(7)	Primary Key,
Department_Name	Varchar(25)	Not Null,
Responsibilities		Varchar(25)	Not Null,
CONSTRAINT check_departname CHECK ( Department_Name IN ('Staff', 'Doctor'))
);


call delete_table('STAFF','TABLE');

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

call delete_table('DOCTOR_RECORDS','TABLE');
    
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
        ,CONSTRAINT check_doctor_phonenumbers CHECK(LENGTH(Doctor_Phone_No )=10)
        ,CONSTRAINT check_doctor_emails CHECK (REGEXP_LIKE (Doctor_Email , '^\w+(\.\w+)*+@\w+(\.\w+)+$') )
        ,CONSTRAINT check_doctor_zipcodes CHECK (LENGTH(Doctor_Zip_Code)=5)
        ,CONSTRAINT check_doctor_charges CHECK (Doctor_Charge >=0)
	);



call delete_table('PATIENT_INVOICE','TABLE');
    
CREATE TABLE Patient_Invoice (
	Bill_ID VARCHAR(7) PRIMARY KEY
	,Patient_ID	Varchar(7)	REFERENCES Patient_Records(Patient_ID)
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
    
call delete_table('PATIENT_MEDICALHISTORY','TABLE');
    
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
    
call delete_table('PATIENT_MEDICATION','TABLE');
    
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
    

call delete_table('PATIENT_VISIT','TABLE');

CREATE TABLE Patient_Visit (
	 Visit_ID VARCHAR(7) PRIMARY KEY
	,Patient_ID VARCHAR(7) REFERENCES Patient_Records(Patient_ID)
	,Doctor_ID VARCHAR(7) REFERENCES Doctor_Records(Doctor_ID)
	,Diagnostic_Details VARCHAR(200) NOT NULL
	,Visit_Date DATE NOT NULL
    --CONSTRAINT check_Visit_Date CHECK(Visit_Date < Sys_Date)
	);
    
call delete_table('PATIENT_VITALSIGNS','TABLE');

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

call delete_table('PATIENT_LABTEST','TABLE');

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
    
call delete_table('PATIENT_TREATMENT','TABLE');    
    
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

call delete_table('ROOM_DETAILS','TABLE');


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



insert into PATIENT_RECORDS values(	'PAT-100',	'Rosella',	'Burks',	'5-Jan-90'	,	'F',	'White',	'Non - Hispanic/Latino',	9637774065	, 'BurksR@gmail.com',	'16C, Smith St',	'San Juan',	'PR',	'US',	92600,	'Patrica',	'Garrison',	8631113065	,'GarrisonP@gmail.edu',	'16C,Smith St',	'San Juan',	'PR',	'US',	92600	);
insert into PATIENT_RECORDS values(	'PAT-101',	'Damien',	'Avila',	'6-Jan-91'	,	'M',	'White',	'Non - Hispanic/Latino',	9637777914,	'AvilaD@gmail.com',	'17A, Termont St',	'Corona',	'NY',	'US',	11368,	'Leila',	'Effie',	8631111813,	'EffieL@gmail.edu',	'17A, Termont St',	'Corona',	'NY',	'US',	11368	);
insert into PATIENT_RECORDS values(	'PAT-102',	'Robin',	'Olsen',	'7-Jan-92'	,	'M',	'Asian American',	'Non - Hispanic/Latino',	9637779262,	'OlsenR@gmail.com',	'1, James St',	'Chicago',	'IL',	'US',	60629,	'Rose',	'Buckley',	8631118262,	'BuckleyR@gmail.edu',	'1, James St',	'Chicago',	'IL',	'US',	60629	);
insert into PATIENT_RECORDS values(	'PAT-103',	'Edgar',	'Moises',	'7-Jan-93'	,	'M',	'Black or African American',	'Non - Hispanic/Latino',	9637778264,	'MoisesE@gmail.com',	'7A, Temont St',	'El Paso',	'TX',	'US',	79936,	'Kathie',	'Stanton',	8631118263,	'StantonK@gmail.edu',	'7A, Temont St',	'El Paso',	'TX',	'US',	79936	);
insert into PATIENT_RECORDS values(	'PAT-104',	'Heath',	'Brian',	'8-Jan-94'	,	'F',	'Black or African American',	'Non - Hispanic/Latino',	9637777249,	'BrianH@gmail.com',	'6C, Park St',	'Los Angeles',	'CA',	'US',	90011,	'Shannon',	'Banks',	8631111238,	'BanksS@gmail.edu',	'6C, Park St',	'Los Angeles',	'CA',	'US',	90011	);
insert into PATIENT_RECORDS values(	'PAT-105',	'Elvin',	'Claude',	'9-Jan-95'	,	'F',	'White',	'Non - Hispanic/Latino',	9637779730,	'ClaudeE@gmail.com',	'86C, Jack St',	'Norwalk',	'CA',	'US',	90650,	'Cleo',	'Barnes',	8631118130,	'BarnesC@gmail.edu',	'86C, Jack St',	'Norwalk',	'CA',	'US',	90650	);
insert into PATIENT_RECORDS values(	'PAT-106',	'Edmund',	'Mosley',	'10-Jan-96'	,	'M',	'Asian American',	'Hispanic/Latino',	9637779285,	'MosleyE@gmail.com',	'87A, Harper St',	'Pacoima',	'CA',	'US',	91331,	'Nellie',	'Brady',	8631118285,	'BradyN@gmail.edu',	'87A, Harper St',	'Pacoima',	'CA',	'US',	91331	);
insert into PATIENT_RECORDS values(	'PAT-107',	'Antoine',	'Derek',	'10-Jan-97'	,	'M',	'White',	'Non - Hispanic/Latino',	9637775454,	'DerekA@gmail.com',	'8, James St',	'Ketchikan',	'AK',	'US',	99950,	'Ruben',	'Katheryn',	8631115353,	'KatherynR@gmail.edu',	'8, James St',	'Ketchikan',	'AK',	'US',	99950	);
insert into PATIENT_RECORDS values(	'PAT-108',	'Callie',	'Hawkins',	'11-Jan-98'	,	'F',	'White',	'Non - Hispanic/Latino',	9637774949,	'HawkinsC@gmail.com',	'7A, Temont St',	'San Juan',	'PR',	'US',	92600,	'Dianne',	'Michael',	8631113838,	'MichaelD@gmail.edu',	'7A, Temont St',	'San Juan',	'PR',	'US',	92600	);


SELECT * FROM PATIENT_RECORDS;


insert into DEPARTMENT VALUES('D-101','Doctor','Attends the patients');
insert into DEPARTMENT VALUES('D-102','Staff','Hospitality management');


SELECT * FROM DEPARTMENT;

insert into STAFF VALUES('S-101','D-102','Suresh','Singh','Lab Assistant','Level1','SureshS@gmail.com',2312226999,'101 Michael Street' ,'Chicago','IL','US',90045);
insert into STAFF VALUES('S-102','D-102','Simon','Lee','Compounder','Level1','Simlee@gmail.com',5612226999,'502 Haven Street' ,'Los Angeles','CA','US',92363);
insert into STAFF VALUES('S-103','D-102','Andrew','Jose','Compounder','Level1','AndJos@gmail.com',4812226999,'201 Cambridge Street','San Juan','PR','US',21380);
insert into STAFF VALUES('S-104','D-102','Adam','Jen','Nurse','Level1','AdamJen@gmail.com',4812226912,'1 Camel Street','Chicago','IL','US',95545);
insert into STAFF VALUES('S-105','D-102','Bruce','Lee','Nurse','Level2','BruceLee@gmail.com',6812336912,'H-234, Jackson St','San Juan',	'PR',	'US',	92600);
insert into STAFF VALUES('S-106','D-102','Zheng','Zhang','Nurse','Level3','ZhengZhang@gmail.com',7891226912,'16 Mission Hill', 'El Paso',	'TX',	'US',23123);
insert into STAFF VALUES('S-107','D-102','Rasheed','Ahmed','Nurse','Level1','RasheedAhmed@gmail.com',7612226999,'2 Greek Street','Ketchikan','AK','US',21380);
insert into STAFF VALUES('S-108','D-102','Angelina','Jenny','Nurse','Level1','AngelinaJenny@gmail.com',4814426912,'1 Park Street','Chicago','IL','US',21380);
insert into STAFF VALUES('S-109','D-102','James','Jacob','Lab Assistant','Level2','JamesJacob@gmail.com',7812336912,'2, Peak St','San Juan',	'PR',	'US',	72600);
insert into STAFF VALUES('S-110','D-102','Hitech','Reddy','Receptionist','Level1','HitechReddy@gmail.com',6089926912,'11 Mission Hill', 'Pacoima',	'CA',	'US',	91331);
insert into STAFF VALUES('S-111','D-102','Michael','Costa', 'Lab Assistant','Level2',	'Miccos@gmail.com',9012226999,'201 Congress Street', 'El Paso', 'TX',	'US',	21389);
insert into STAFF VALUES('S-112','D-102', 'Saurav','Dsouza', 'Lab Assistant', 'Level1',	'Saudso@gmail.com', 6612226999,	'105 Congress Street', 	'Corona', 'NY',	'US',	21380);

SELECT * FROM STAFF;


insert into DOCTOR_RECORDS VALUES('DOC-100','D-101','Sarvesh','Sinha','Gynecologists','Intern','SarveshSinha@gmail.com',6172347382,200,'Ap #867-859','New York','NY','US',39531);
insert into DOCTOR_RECORDS VALUES('DOC-101','D-101','Olivia','Le','Neurologists','Senior','OliviaLe@gmail.com',6099773234,500,'191-103 Jue Road','New York','NY','US',39531);
insert into DOCTOR_RECORDS VALUES('DOC-102','D-101','Andrea','Germia','Cardiologists','Resident','AndreaG@gmail.com',6372347382,450,'887 Demonte Avenue','New York','NY','US',39531);
insert into DOCTOR_RECORDS VALUES('DOC-103','D-101','Mia','Cova', 'Physician','Intern','Allech@gmail.com',6117347382,400,'511-5762 At Rd.','New York','NY','United States',39531);
insert into DOCTOR_RECORDS VALUES('DOC-104','D-101','Lee','Jamie','Dermatologists','Specialist','LeeJ@gmail.com',7172347382,500,'935-9940 Tortor. Street','New York','NY','United States',39531);
insert into DOCTOR_RECORDS VALUES('DOC-105','D-101','Anushka','Shekhar','Pediatrics','Resident','Kha@gmail.com',6170345382,250,'250 P.O 929 4189 NuncRoad','New York','NY','United States',39531);
insert into DOCTOR_RECORDS VALUES('DOC-106','D-101','John','Goetz','Surgeon'	,'Pediatricians','SarahAl@gmail.com',6179347181,350,'350 Viverra.Avenue','New York','NY','United States',39531);
insert into DOCTOR_RECORDS VALUES('DOC-107','D-101','Thomas','Brook','Surgeon'	,'Neurologists','Mariari@gmail.com',6172347311,300,'300 347-7666 Iaculis St.','New York','NY','United States',39531);

SELECT * FROM DOCTOR_RECORDS;

insert into PATIENT_INVOICE VALUES(	'BIL-100',	'PAT-100',	'12-Oct-22',200, 50,	0,	0,	0,1,	15, 132);
insert into PATIENT_INVOICE VALUES(	'BIL-101',	'PAT-101',	'12-Jan-22',	300,	50,	0,	0,0,0, 15,	365	);
insert into PATIENT_INVOICE VALUES(	'BIL-102',	'PAT-102',	'15-Jan-22',	450,	50,	0,	0,	0,0,	15	,	515	);
insert into PATIENT_INVOICE VALUES(	'BIL-103',	'PAT-103',	'17-Jan-22',	400,	50,	0,	0,	0,	0,15,	232.5	);
insert into PATIENT_INVOICE VALUES(	'BIL-104',	'PAT-104',	'18-Jan-22',	500,	50,	0,	0,	0,	1,15	,	282.5	);

SELECT * FROM PATIENT_INVOICE;

---Insert PATIENT MEDICAL HISTORY---

insert into PATIENT_MEDICALHISTORY values(	'MH-100',	'PAT-100',	'Fever',	'High fever 102',	'21-Apr-20',	'N',	'21-May-20');
insert into PATIENT_MEDICALHISTORY values(	'MH-101',	'PAT-101',	'Asthama',	'Asthma since 1 year',	'20-May-20',	'Y',	NULL);
insert into PATIENT_MEDICALHISTORY values(	'MH-102',	'PAT-102',	'Cold',	'Mild',	'10-Sep-21',	'N',	'13-Oct-21');	
insert into PATIENT_MEDICALHISTORY values(	'MH-103',	'PAT-103',	'Cold',	'High',	'1-Jan-20',	'N',	'2-Feb-20');	
insert into PATIENT_MEDICALHISTORY values(	'MH-104',	'PAT-104',	'Anemia',	'For last 2 years',	'4-Mar-19',	'Y',	NULL);
insert into PATIENT_MEDICALHISTORY values(	'MH-105',	'PAT-105',	'Flu',	'Mild',	'6-Jun-20',	'N',	'9-Jul-20');	
insert into PATIENT_MEDICALHISTORY values(	'MH-106',	'PAT-106',	'Blood Pressure',	'High',	'21-Apr-20',	'Y', NULL);
insert into PATIENT_MEDICALHISTORY values(	'MH-107',	'PAT-107',	'Cough',	'Sour throat',	'20-May-20',	'N',	'19-Jun-20');	
insert into PATIENT_MEDICALHISTORY values(	'MH-108',	'PAT-108',	'Cough',	'Sour throat',	'10-Sep-21',	'N',	'13-Oct-21');

SELECT * FROM PATIENT_MEDICALHISTORY;

--Insert PATIENT MEDICATION--

insert into PATIENT_MEDICATION values(	'MED-100',	'MH-104',	'PAT-100',	'Tylenol',	282,	2,	'Oral',	2,	'2-Jan-22',	'9-Jan-22',	'N'	);
insert into PATIENT_MEDICATION values(	'MED-101',	'MH-104',	'PAT-101',	'Metformin',	306,	3,	'Injection',	1,	'2-Jan-22',	NULL,'Y'	);
insert into PATIENT_MEDICATION values(	'MED-102',	'MH-104',	'PAT-102',	'Tylenol',	337,	1,	'Oral',	3,	'5-Jan-22',	NULL,	'Y'	);
insert into PATIENT_MEDICATION values(	'MED-103',	'MH-100',	'PAT-103',	'Tylenol',	242,	3,	'Oral',	1,	'7-Jan-22',	NULL,	'Y'	);
insert into PATIENT_MEDICATION values(	'MED-104',	'MH-100',	'PAT-104',	'Metformin',	451,	2,	'Injection',	3,	'8-Jan-22',	'18-Jan-22',	'N'	);
insert into PATIENT_MEDICATION values(	'MED-105',	'MH-100',	'PAT-105',	'Tylenol',	307,	1,	'Oral',	2,	'10-Jan-22',	'15-Jan-22',	'N'	);
insert into PATIENT_MEDICATION values(	'MED-106',	'MH-100',	'PAT-106',	'Microzide',	71,	4,	'Oral',	3,	'11-Jan-22',	NULL,	'Y'	);
insert into PATIENT_MEDICATION values(	'MED-107',	'MH-100',	'PAT-107',	'Tylenol',	53,	1,	'Oral',	1,	'11-Jan-22','17-Jan-22',	'N'	);
insert into PATIENT_MEDICATION values(	'MED-108',	'MH-100',	'PAT-108',	'Tylenol',	87,	4,	'Oral',	2,	'12-Jan-22',	'21-Jan-22',	'N'	);


SELECT * FROM PATIENT_MEDICATION;


insert into PATIENT_VISIT values('V-001',	'PAT-100',	'DOC-101',	'Normal ',	'2-Jan-22');
insert into PATIENT_VISIT values('V-002',	'PAT-101',	'DOC-102',	'Normal ',	'2-Jan-22');
insert into PATIENT_VISIT values('V-003',	'PAT-102',	'DOC-103',	'Abnormal',	'5-Jan-22');
insert into PATIENT_VISIT values('V-004',	'PAT-103',	'DOC-104',	'Abnormal',	'7-Jan-22');
insert into PATIENT_VISIT values('V-005',	'PAT-104',	'DOC-107',	'Abnormal',	'8-Jan-22');
insert into PATIENT_VISIT values('V-006',	'PAT-105',	'DOC-101',	'Normal ',	'10-Jan-22');
insert into PATIENT_VISIT values('V-007',	'PAT-106',	'DOC-106',	'Abnormal',	'11-Jan-22');
insert into PATIENT_VISIT values('V-008',	'PAT-107',	'DOC-102',	'Normal ',	'11-Jan-22');
insert into PATIENT_VISIT values('V-009',	'PAT-108',	'DOC-103',	'Normal ',	'12-Jan-22');

SELECT * FROM PATIENT_VISIT;

insert into PATIENT_VITALSIGNS values(	'VS-0001',  'PAT-100',	'S-103',	'V-001',	120,	78,	74,	168,	67,	'Normal ',	50,	'12-Jan-22'	);
insert into PATIENT_VITALSIGNS values(	'VS-0002', 'PAT-101',	'S-112',	'V-002',	115,	180,	70,	165,	54,	'Normal ',	50,	'14-Dec-19'	);
insert into PATIENT_VITALSIGNS values(	'VS-0003', 'PAT-102',	'S-104',	'V-003',	95,	83,	76,	218,	54,	'Abnormal',	50,	'15-Dec-19'	);
insert into PATIENT_VITALSIGNS values(	'VS-0004', 'PAT-103',	'S-106',	'V-004',	51,	75,	78,	190,	50,	'Abnormal',	50,	'16-Dec-19'	);
insert into PATIENT_VITALSIGNS values(	'VS-0005', 'PAT-104',	'S-102',	'V-005',	94,	82,	71,	197,	88,	'Abnormal',	50,	'17-Dec-19'	);
insert into PATIENT_VITALSIGNS values(	'VS-0006', 'PAT-105',	'S-110',	'V-006',	114,	87,	76,	213,	55,	'Normal ',	50,	'18-Dec-19'	);
insert into PATIENT_VITALSIGNS values(	'VS-0007', 'PAT-106',	'S-110',	'V-007',	156,	100,	72,	194,	60,	'Abnormal',	50,	'19-Dec-19'	);
insert into PATIENT_VITALSIGNS values(	'VS-0008', 'PAT-107',	'S-107',	'V-008',	119,	97,	78,	211,	123,	'Normal ',	50,	'20-Dec-19'	);
insert into PATIENT_VITALSIGNS values(	'VS-0009', 'PAT-108',	'S-109',	'V-009',	123,	98,	76,	167,	77,	'Normal ',	50,	'21-Dec-19'	);

SELECT * FROM PATIENT_VITALSIGNS;

INSERT INTO PATIENT_LABTEST VALUES('T01','HEMATOLOGY – RBC','Measurement of red blood cell count','PAT-100','DOC-101','V-001','Normal','NA','ABC Diagnostic','S-110','2-Jan-2022','5-Jan-2022','15');
INSERT INTO PATIENT_LABTEST VALUES('T02','HEMATOLOGY – RBC','Measurement of red blood cell count','PAT-101','DOC-107','V-002','Normal','NA','ABC Diagnostic','S-111','2-Jan-2022','7-Jan-2022','15');	
INSERT INTO PATIENT_LABTEST VALUES('T03','HEMATOLOGY – RBC','Measurement of red blood cell count ','PAT-102','DOC-106','V-003','Abnormal','Low RBC Counts','ABC Diagnostic','S-112','5-Jan-2022','8-Jan-2022','15');
INSERT INTO PATIENT_LABTEST VALUES('T04','HEMOGLOBIN','Measurement of hemoglobin in the blood','PAT-103','DOC-102','V-004','Abnormal','Low hemoglobin levels','ABC Diagnostic','S-103','7-Jan-2022','10-Jan-2022','15');					
INSERT INTO PATIENT_LABTEST VALUES('T05','HEMOGLOBIN','Measurement of hemoglobin in the blood','PAT-104','DOC-105','V-005','Abnormal','Low hemoglobin levels','ABC Diagnostic','S-104','8-Jan-2022','11-Jan-2022','15');					
INSERT INTO PATIENT_LABTEST VALUES('T06','GENERAL CHEMISTRY','Number of the body’s components','PAT-105','DOC-103','V-006','Normal','NA','ABC Diagnostic','S-110','10-Jan-2022','11-Jan-2022','15'); 					
INSERT INTO PATIENT_LABTEST VALUES('T07','GENERAL CHEMISTRY','Number of the body’s components','PAT-106','DOC-101','V-007','Normal','NA','ABC Diagnostic','S-111','11-Jan-2022','12-Jan-2022','15'); 					
INSERT INTO PATIENT_LABTEST VALUES('T08','URINE','Urine tests to diagnose metabolic and kidney disorder','PAT-107','DOC-104','V-008','Normal','NA','ABC Diagnostic','S-112','11-Jan-2022','13-Jan-2022','15'); 					
INSERT INTO PATIENT_LABTEST VALUES('T09','URINE','Urine tests to diagnose metabolic and kidney disorder','PAT-108','DOC-107','V-009','Normal','NA','ABC Diagnostic','S-103','12-Jan-2022','14-Jan-2022','15'); 					


SELECT * FROM PATIENT_LABTEST;

INSERT INTO PATIENT_TREATMENT VALUES('T-100','PAT-100','DOC-101','V-001',       '12-Jan-2022',       '2-Jan-2022',      'N','Y',        'A',    394,    2,      'Oral',       2,        'N/A',   'Normal' ,     'N',0);
INSERT INTO PATIENT_TREATMENT VALUES('T-101','PAT-101',	'DOC-103','V-002',	'12-Jan-2022',	'2-Jan-2022',	'N','Y',	'B',	274,	1,	'Injection'	,3,	'N/A'	,'Normal' ,	'N',0);
INSERT INTO PATIENT_TREATMENT VALUES('T-102','PAT-102',	'DOC-105','V-003',	'15-Jan-2022',	'5-Jan-2022',	'N','Y',	'F',	238,	3,	'Injection',	1,	'N/A',	'Abnormal',	'N',0);
INSERT INTO PATIENT_TREATMENT VALUES('T-103','PAT-103',	'DOC-102','V-004',	'17-Jan-2022',	'7-Jan-2022',	'N','Y',	'G',	234,	2,	'Oral',	3,	'N/A',	'Abnormal',	'N',0);
INSERT INTO PATIENT_TREATMENT VALUES('T-104','PAT-104',	'DOC-107','V-005',	'18-Jan-2022',	'8-Jan-2022',	'N','Y',	'K',	182,	1,	'Oral',	2,	'N/A',	'Abnormal',	'N',	0);
INSERT INTO PATIENT_TREATMENT VALUES('T-105','PAT-105',	'DOC-101','V-006',	'20-Jan-2022',	'10-Jan-2022',	'N','Y',	'A',	176,	3,	'Injection',	1,	'N/A',	'Normal', 	'N',	0);
INSERT INTO PATIENT_TREATMENT VALUES('T-106','PAT-106',	'DOC-102','V-007',	'19-Jan-2022',	'11-Jan-2022',	'N','Y',	'B',	440,	2,	'Injection',	2,	'N/A',	'Normal', 	'N',	0);
INSERT INTO PATIENT_TREATMENT VALUES('T-107','PAT-107',	'DOC-106','V-008',	'17-Jan-2022',	'11-Jan-2022',	'N','Y',	'F',	355,	1,	'Oral',	3,	'N/A',	'Normal',  'N',	0);
INSERT INTO PATIENT_TREATMENT VALUES('T-108','PAT-108',	'DOC-104','V-009',	'18-Jan-2022',	'16-Jan-2022',	'N','Y',	'G',	279,	3,	'Oral',	1,	'N/A',	'Normal' 	,'Y',	400);
INSERT INTO PATIENT_TREATMENT VALUES('T-109','PAT-103',	'DOC-103','V-001',	'20-Jan-2022',	'13-Jan-2022',	'N','N',	'K',	105,	2,	'Injection',	3,	'N/A',	'Normal', 	'Y'	,300);
INSERT INTO PATIENT_TREATMENT VALUES('T-110','PAT-105',	'DOC-107','V-004',	'19-Jan-2022',	'14-Jan-2022',	'N','N',	'A',	281,	1,	'Injection',	2,	'N/A',	'Normal', 	'Y',	800);
INSERT INTO PATIENT_TREATMENT VALUES('T-111','PAT-102',	'DOC-102','V-002',	'1-Feb-2022',	'15-Jan-2022',	'N','N',	'B',	420,	3,	'Oral',	1,	'N/A',	'Abnormal',	'Y'	,700);

SELECT * FROM PATIENT_TREATMENT;

INSERT INTO ROOM_DETAILS VALUES('R-101', 'PAT-101', 'V-009', '2-Jan-22', '6-Jan-22', '30', '5', '150');
INSERT INTO ROOM_DETAILS VALUES('R-102', 'PAT-108', 'V-001', '5-Jan-22', '7-Jan-22', '30', '3', '90');
INSERT INTO ROOM_DETAILS VALUES('R-103', 'PAT-101', 'V-006', '10-Jan-22', '14-Jan-22', '45', '5', '225');
INSERT INTO ROOM_DETAILS VALUES('R-104', 'PAT-102', 'V-002', '11-Jan-22', '14-Jan-22', '30', '4', '120');
INSERT INTO ROOM_DETAILS VALUES('R-105', 'PAT-104', 'V-007', '18-Jan-22', '23-Jan-22', '45', '6', '270');
INSERT INTO ROOM_DETAILS VALUES('R-106', 'PAT-105', 'V-008', '21-Jan-22', '24-Jan-22', '30', '4', '120');
INSERT INTO ROOM_DETAILS VALUES('R-107', 'PAT-107', 'V-004', '1-Feb-22', '8-Feb-22', '40', '8', '320');
INSERT INTO ROOM_DETAILS VALUES('R-108', 'PAT-106', 'V-006', '8-Feb-22', '11-Jan-22', '40', '4', '160');
INSERT INTO ROOM_DETAILS VALUES('R-109', 'PAT-107', 'V-003', '18-Feb-22', '20-Jan-22', '35', '3', '315');
INSERT INTO ROOM_DETAILS VALUES('R-110', 'PAT-104', 'V-009', '20-Feb-22', '26-Jan-22', '45', '7', '250');


SELECT * FROM ROOM_DETAILS;







