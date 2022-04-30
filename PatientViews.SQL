-------View to check patient visits-------

CREATE OR REPLACE VIEW PATIENT_VISITS AS
SELECT
Patient.PATIENT_ID, 
Patient.PATIENT_FIRST_NAME || ' ' || Patient.PATIENT_LAST_NAME as Patient_Name,
Patient.Gender,
floor(months_between(trunc(sysdate),patient.Date_of_Birth )/12) as Age,
visits.Visit_ID as Visit_ID,
visits.diagnostic_details,
TO_CHAR(Visits.Visit_Date ,'DD-MON-YYYY HH24:MI') Visit_date,
Treatment.Treatment,
doctor.doctor_id, 'Dr.' || doctor.doctor_first_name || ' ' || doctor.doctor_last_name as Doctor_Name,
doctor.specialization,
TO_CHAR(Treatment.Treatment_Start_Date ,'DD-MON-YYYY HH24:MI') Treatment_start_date,
Ongoing_Flag,
TO_CHAR(Treatment.Treatment_End_Date ,'DD-MON-YYYY HH24:MI') Treatment_end_date
FROM Doctor_Records Doctor ,Patient_Visit Visits, Patient_Records Patient, Patient_Treatment Treatment
WHERE Doctor.Doctor_id = Visits.Doctor_id
AND Visits.Patient_id = Patient.Patient_id
AND Treatment.Patient_ID = Patient.Patient_id
order by Visits.Visit_Date;

select * from PATIENT_VISITS;

-------View to check medical history of the patients -------

CREATE OR REPLACE VIEW PATIENT_MEDICAL_HISTORY AS
SELECT patient.patient_id,
Patient.PATIENT_FIRST_NAME || ' ' || Patient.PATIENT_LAST_NAME as Patient_Name,
floor(months_between(trunc(sysdate),patient.Date_of_Birth )/12) as age, 
Patient.gender,
'Dr.' || doctor.doctor_first_name || ' ' || doctor.doctor_last_name as case_doctor,
Medical_History_Term,
Medical_History_Description,
TO_CHAR(Medicalhistory.Medical_History_Start_Date ,'DD-MON-YYYY HH24:MI') Medical_start_date,
TO_CHAR(Medicalhistory.Medical_History_End_Date ,'DD-MON-YYYY HH24:MI') Medical_end_date,
Ongoing FROM Doctor_Records Doctor , Patient_MedicalHistory Medicalhistory, Patient_Records Patient, Patient_Treatment Treatment
WHERE
Medicalhistory.patient_id = Patient.patient_id
AND Treatment.Patient_ID = Patient.Patient_id
AND Treatment.Doctor_ID = Doctor.Doctor_id;
select * from PATIENT_MEDICAL_HISTORY;

-------View to check on going medication of the patients -------

CREATE OR REPLACE VIEW PATIENT_MEDICATIONS AS
SELECT patient.patient_id,
Patient.PATIENT_FIRST_NAME || ' ' || Patient.PATIENT_LAST_NAME as Patient_Name,
floor(months_between(trunc(sysdate),patient.Date_of_Birth )/12) as age, 
Patient.gender,
'Dr.' || doctor.doctor_first_name || ' ' || doctor.doctor_last_name as case_doctor,
Medications ,
Medication_Dose,
Medication_Dose_Units,
Medication_Route,
Medication_Frequency,
TO_CHAR(Medication.Medication_Start_Date ,'DD-MON-YYYY HH24:MI') Medication_start_date,
TO_CHAR(Medication.Medication_End_Date ,'DD-MON-YYYY HH24:MI') Medication_end_date,
Medication_Ongoing FROM Doctor_Records Doctor , Patient_Medication Medication, Patient_Records Patient, Patient_Treatment Treatment
WHERE
Medication.patient_id = Patient.patient_id
AND Treatment.Patient_ID = Patient.Patient_id
AND Treatment.Doctor_ID = Doctor.Doctor_id 
order by patient.patient_id ;

Select * from PATIENT_MEDICATIONS ;


-- All Patients Vitals View
CREATE OR REPLACE VIEW PATIENT_VITALS AS
select patient.patient_id,
Patient.PATIENT_FIRST_NAME || ' ' || Patient.PATIENT_LAST_NAME as Patient_Name,
floor(months_between(trunc(sysdate),patient.Date_of_Birth )/12) as age, 
Patient.gender,
Diastolic_Blood_Pressure,
Heart_Rate,
Height_cms,
Weight_kgs,
Comments,
Vitals_Date_Time
FROM Patient_Records Patient, Patient_VitalSigns Vitals
WHERE
Vitals.patient_id = Patient.patient_id
and Vitals_Date_Time =(select max(Vitals_Date_Time)
from Patient_VitalSigns Vitals1
where Vitals.patient_id =Vitals1.patient_id ) ORDER BY Vitals.patient_id;

select * from PATIENT_VITALS;

-------View patients treament details -------

CREATE OR REPLACE VIEW PATIENT_TREATMENTS AS
SELECT patient.patient_id,
Patient.PATIENT_FIRST_NAME || ' ' || Patient.PATIENT_LAST_NAME as Patient_Name,
floor(months_between(trunc(sysdate),patient.Date_of_Birth )/12) as age, 
Patient.gender,
'Dr.' || doctor.doctor_first_name || ' ' || doctor.doctor_last_name as case_doctor,
Treatment.Treatment,
Treatment.Treatment_Start_Date,
Treatment.Treatment_End_Date,
Treatment.ongoing_flag,
Treatment.Dose,
Treatment.dose_units,
Treatment.Treatment_Route,
Treatment.Treatment_Frequency,
Treatment.Remarks
FROM Doctor_Records Doctor , Patient_Records Patient, Patient_Treatment Treatment
WHERE
Treatment.Patient_ID = Patient.Patient_id
AND Treatment.Doctor_ID = Doctor.Doctor_id;

select * from PATIENT_TREATMENTS;

-------View patients billing details -------
CREATE OR REPLACE VIEW View_Patients_Billing AS
SELECT
patient.patient_id,
Patient.PATIENT_FIRST_NAME || ' ' || Patient.PATIENT_LAST_NAME as Patient_Name,
floor(months_between(trunc(sysdate),patient.Date_of_Birth )/12) as age, 
Patient.gender,
Invoice.Bill_ID,
Payment_Date,
Doctor_Charge,
Nurse_Charge,
Operation_Charge,
Number_of_days,
Room_Charge,
Lab_Charge,
Total_Billing

FROM Patient_Records Patient, Patient_Invoice Invoice
WHERE
Invoice.Patient_ID = Patient.Patient_id;


select * from View_Patients_Billing;


