---Show patient history for a patient 
CREATE OR REPLACE PROCEDURE show_patient_history
(pat_id varchar) 
IS
    r_hist PATIENT_MEDICAL_HISTORY%ROWTYPE;
    rcount NUMBER := 0;
BEGIN
            FOR r_hist IN (SELECT * FROM PATIENT_MEDICAL_HISTORY WHERE patient_id = pat_id)
            LOOP
                IF rcount = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('----------------------------------- Medical History for ' || r_hist.PATIENT_NAME || ' -----------------------------------');
                    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------------------------------------');
                    DBMS_OUTPUT.PUT_LINE('Age: ' || r_hist.age);
                    DBMS_OUTPUT.PUT_LINE('Gender: ' || r_hist.gender);
                    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------------------------------------');
                    DBMS_OUTPUT.PUT_LINE('MEDICAL START DATE  |  CASE DOCTOR          |  MEDICAL HISTORY TERM         |  MEDICAL HISTORY DESCRIPTION');
                END IF;
                    DBMS_OUTPUT.PUT_LINE(r_hist.MEDICAL_START_DATE  || ' |  ' || RPAD(r_hist.CASE_DOCTOR,16,' ') || '     |  ' || RPAD(r_hist.MEDICAL_HISTORY_TERM,26,' ') || '  |  ' || r_hist.MEDICAL_HISTORY_DESCRIPTION);
                    rcount := 1;
            END LOOP;
            IF rcount = 0 THEN
                DBMS_OUTPUT.PUT_LINE('------------------------------- There is no medical history for Patient ID - ' || pat_id || ' -------------------------------');
            END IF;
        
 
EXCEPTION 
    WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

-- Show patient history
set SERVEROUTPUT ON;

-- With incorrect patient id
EXECUTE show_patient_history('PAT-105');


---Show patients doctor
CREATE OR REPLACE PROCEDURE show_patients_for_doctor
(doc_id varchar) 
IS
    r_doc PATIENT_VISITS%ROWTYPE;
    rcount NUMBER := 0;
BEGIN
            FOR r_doc IN (SELECT * FROM PATIENT_VISITS WHERE doctor_id = doc_id)
            LOOP
                IF rcount = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('----------------------------------- Patients for ' || r_doc.DOCTOR_NAME || ' -----------------------------------');
                    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------------------------------------');
                    DBMS_OUTPUT.PUT_LINE('Doctor: ' || r_doc.DOCTOR_NAME);
                    DBMS_OUTPUT.PUT_LINE('DocTor ID: ' || r_doc.DOCTOR_ID);
                    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------------------------------------');
                    DBMS_OUTPUT.PUT_LINE('TREATMENT START  |  PATIENT          |  TREATMENT         |  TREATMENT END');
                END IF;
                    DBMS_OUTPUT.PUT_LINE(r_doc.TREATMENT_START_DATE  || ' |  ' || RPAD(r_doc.PATIENT_NAME,16,' ') || '     |  ' || RPAD(r_doc.TREATMENT,26,' ') || '  |  ' || r_DOC.TREATMENT_END_DATE);
                    rcount := 1;
            END LOOP;
            IF rcount = 0 THEN
                DBMS_OUTPUT.PUT_LINE('------------------------------- There are no patients - ' || doc_id || ' -------------------------------');
            END IF;
        
 
EXCEPTION 
    WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

-- Show patients for doctor
set SERVEROUTPUT ON;

-- Number of Patients for given doctor
EXECUTE show_patients_for_doctor('DOC-101');


---Show visit history for a patient 
CREATE OR REPLACE PROCEDURE show_visit_history
(pat_id varchar) 
IS
    r_visit PATIENT_VISITS%ROWTYPE;
    rcount NUMBER := 0;
BEGIN
            FOR r_visit IN (SELECT * FROM PATIENT_VISITS WHERE patient_id = pat_id)
            LOOP
                IF rcount = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('----------------------------------- Visit History for ' || r_visit.PATIENT_NAME || ' -----------------------------------');
                    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------------------------------------');
                    DBMS_OUTPUT.PUT_LINE('Patient: ' || r_visit.PATIENT_NAME);
                    DBMS_OUTPUT.PUT_LINE('Patient ID: ' || r_visit.patient_id);
                    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------------------------------------');
                    DBMS_OUTPUT.PUT_LINE('CASE DOCTOR  |   TREATMENT         |   TREATMENT START       |  TREATMENT END');
                END IF;
                    DBMS_OUTPUT.PUT_LINE(r_visit.Doctor_Name  || ' |  ' || RPAD(r_visit.TREATMENT,16,' ') || '     |  ' || RPAD(r_visit.TREATMENT_START_DATE,26,' ') || '  |  ' || r_visit.TREATMENT_START_DATE);
                    rcount := 1;
            END LOOP;
            IF rcount = 0 THEN
                DBMS_OUTPUT.PUT_LINE('------------------------------- There is no visit history for Patient ID - ' || pat_id || ' -------------------------------');
            END IF;
        
 
EXCEPTION 
    WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

-- Show patient visit history
set SERVEROUTPUT ON;

-- Visit history for patients
EXECUTE show_visit_history('PAT-102');
