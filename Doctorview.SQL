-------View for Doctors -------

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
