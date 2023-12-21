-- Show billing amount of all bills of patient with ID 2
SELECT medicine_charge + room_charge + doctor_charge AS total_amount FROM hospital_management.bill WHERE record_id IN
	(SELECT record_id FROM hospital_management.record WHERE patient_id = 2);

-- Show the name of all patients at the rooms monitored by the nurse with ID 396
SELECT firstname, lastname FROM hospital_management.patient WHERE patient_id IN
	(SELECT patient_id FROM hospital_management.patient WHERE room_id IN
		(SELECT room_id FROM hospital_management.room WHERE nurse_id = 396));
        
-- Show the name of all patients who are being treated by doctors with specialty “Pediatrics”
SELECT firstname, lastname FROM hospital_management.patient WHERE patient_id IN
	(SELECT patient_id FROM hospital_management.record WHERE record_id IN
		(SELECT record_id FROM hospital_management.doctor_cases WHERE doctor_id IN
			(SELECT doctor_id FROM hospital_management.doctor WHERE specialty = "Pediatrics")));

-- Display female nurses working from Wednesday to Saturday
SELECT f.* FROM hospital_management.faculty f JOIN hospital_management.nurse n ON f.staff_id = n.nurse_id
WHERE f.gender = "Female" AND f.working_schedule LIKE "Wednesday - Saturday%";

-- Calculate total medicine_charges of patients according to blood_typ
SELECT blood_type, SUM(medicine_charge) AS total_medicine_charge FROM hospital_management.patient p 
JOIN hospital_management.record r ON p.patient_id = r.patient_id 
JOIN hospital_management.bill b ON r.record_id = b.record_id 
GROUP BY blood_type;

-- Display the medicine that has price of more than 40, quantity >80 and has "hydrochloride" in description
SELECT * FROM hospital_management.medicine 
WHERE price > 40 AND quantity > 80 AND ingre_description LIKE "%hydrochloride%";

-- Retrieve all patients who have at least 2 medical records
SELECT firstname, lastname FROM hospital_management.patient p
WHERE 2 <= (SELECT COUNT(*) FROM hospital_management.record r WHERE p.patient_id = r.patient_id);

-- Show any room that is not housing any patient
SELECT * FROM hospital_management.room r WHERE NOT EXISTS
	(SELECT * FROM hospital_management.patient p WHERE p.room_id = r.room_id);

-- Show all patient with record of being treated by "Pediatrics" doctors or have "cold" in their diagnosis 
SELECT * FROM hospital_management.patient WHERE patient_id IN
	((SELECT patient_id FROM hospital_management.record WHERE record_id IN
		(SELECT record_id FROM hospital_management.doctor_cases WHERE doctor_id IN
			(SELECT doctor_id FROM hospital_management.doctor WHERE specialty = "Pediatrics")))
	UNION
    (SELECT patient_id FROM hospital_management.record WHERE diagnosis LIKE "%cold%"));