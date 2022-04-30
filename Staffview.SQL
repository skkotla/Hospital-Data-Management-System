-------View for Doctors who are assigned to patients -------

CREATE OR REPLACE VIEW View_Doctor AS
SELECT 
doctor.Doctor_ID,
'Dr.' || doctor.doctor_first_name || ' ' || doctor.doctor_last_name as case_doctor,
doctor.specialization,
doctor.designation,
doctor.doctor_charge,
patient.patient_id,
Patient.PATIENT_FIRST_NAME || ' ' || Patient.PATIENT_LAST_NAME as Patient_Name,
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

Doctor.Doctor_ID = Treatment.Doctor_id
AND Treatment.Patient_ID = Patient.Patient_id
ORDER BY doctor.Doctor_ID ;

select * from View_Doctor;


-------View for Staff who are accomodated to patients -------

CREATE OR REPLACE VIEW View_Staff AS
SELECT 
S.Staff_id,
S.Staff_first_name || ' ' || S.Staff_last_name as Staff_Name,
S.staff_role,
S.staff_level,
patient.patient_id,
Patient.PATIENT_FIRST_NAME || ' ' || Patient.PATIENT_LAST_NAME as Patient_Name,  
'Labs' as Test,
Lab.Lab_Charge as Charge
FROM Staff S  , Patient_Records Patient, Patient_Labtest Lab
WHERE S.Staff_ID = lab.staff_id
AND   Patient.patient_id = lab.patient_id
UNION 
SELECT 
S.Staff_id,
S.Staff_first_name || ' ' || S.Staff_last_name as Staff_Name,
S.staff_role,
S.staff_level,
patient.patient_id,
Patient.PATIENT_FIRST_NAME || ' ' || Patient.PATIENT_LAST_NAME as Patient_Name,  
'Vitals' as Test,
vitals.nurse_fee as Charge
FROM Staff S  , Patient_Records Patient, patient_vitalsigns vitals
WHERE S.Staff_ID = vitals.staff_id
AND   Patient.patient_id = vitals.patient_id;

Select * from View_Staff;
