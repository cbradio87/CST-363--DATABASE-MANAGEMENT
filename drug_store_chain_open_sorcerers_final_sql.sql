CREATE SCHEMA drug_store_chain_open_sorcerers;
USE drug_store_chain_open_sorcerers;

-- Create table doctors
CREATE TABLE doctors (
  ssn INT NOT NULL,
  name VARCHAR(45) NOT NULL,
  specialty VARCHAR(45) NULL,
  years_experience INT NULL,
  PRIMARY KEY (ssn)
);

-- Create table patients
CREATE TABLE patients (
  ssn INT NOT NULL,
  name VARCHAR(45) NOT NULL,
  age INT NULL,
  address VARCHAR(100) NULL,
  PRIMARY KEY (ssn)
);

-- Create table pharma_companies
CREATE TABLE pharma_companies (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(45) NOT NULL,
  phone VARCHAR(45) NOT NULL,
  PRIMARY KEY (id)
);

-- Create table formulas
CREATE TABLE formulas (
  id INT NOT NULL AUTO_INCREMENT,
  active_ingredient VARCHAR(45) NOT NULL,
  concentration DECIMAL(2) NOT NULL,
  PRIMARY KEY (`id`)
);

-- Create table drugs
CREATE TABLE drugs (
  id INT NOT NULL AUTO_INCREMENT,
  trade_name VARCHAR(45) NULL,
  formula_id INT NOT NULL,
  PRIMARY KEY (id),
    CONSTRAINT fk_drugs_formulas1
    FOREIGN KEY (formula_id)
    REFERENCES formulas (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Create table pharmacies
CREATE TABLE pharmacies (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(45) NOT NULL,
  address VARCHAR(45) NULL,
  phone VARCHAR(45) NULL,
  PRIMARY KEY (id)
);

-- Create many to many with doctors and patients
CREATE TABLE patients_has_doctors (
  patients_ssn INT NOT NULL,
  doctors_ssn INT NOT NULL,
  CONSTRAINT fk_patients_has_doctors_patients
    FOREIGN KEY (patients_ssn)
    REFERENCES patients (ssn)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_patients_has_doctors_doctors1
    FOREIGN KEY (doctors_ssn)
    REFERENCES doctors (ssn)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Create many to many relationship for pharmacies and drugs.
CREATE TABLE pharmacies_has_drugs (
  pharmacies_id INT NOT NULL,
  drugs_id INT NOT NULL,
  price DECIMAL(18, 2) NOT NULL,
  CONSTRAINT fk_pharmacies_has_drugs_pharmacies1
    FOREIGN KEY (pharmacies_id)
    REFERENCES pharmacies (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_pharmacies_has_drugs_drugs1
    FOREIGN KEY (drugs_id)
    REFERENCES drugs (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Create many to many relationship between drugs and pharma companies.
CREATE TABLE drugs_has_pharma_companies (
  drugs_id INT NOT NULL,
  pharma_companies_id INT NOT NULL,
  CONSTRAINT fk_drugs_has_pharma_companies_drugs1
    FOREIGN KEY (drugs_id)
    REFERENCES drugs (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_drugs_has_pharma_companies_pharma_companies1
    FOREIGN KEY (pharma_companies_id)
    REFERENCES pharma_companies (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Create table prescriptions
CREATE TABLE prescriptions (
  patients_ssn INT NOT NULL,
  doctors_ssn INT NOT NULL,
  drug_id INT NOT NULL,
  filling_pharmacy_id INT NULL,
  prescribed_on DATE NOT NULL,
  filled_on DATE NULL,
  quantity INT NOT NULL,
  CONSTRAINT fk_prescriptions_patients_has_doctors1
    FOREIGN KEY (patients_ssn)
    REFERENCES patients_has_doctors (patients_ssn)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_prescriptions_patient_has_doctors2
	FOREIGN KEY (doctors_ssn)
    REFERENCES patients_has_doctors (doctors_ssn)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_prescriptions_drugs1
    FOREIGN KEY (drug_id)
    REFERENCES drugs (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_prescriptions_pharmacies1
    FOREIGN KEY (filling_pharmacy_id)
    REFERENCES pharmacies (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Create table supervisors
CREATE TABLE supervisors (
  employee_id INT NOT NULL,
  name VARCHAR(45) NOT NULL,
  phone VARCHAR(45) NOT NULL,
  PRIMARY KEY (employee_id)
);

-- Create table contracts
CREATE TABLE contracts (
  pharmacy_id INT NOT NULL,
  pharma_company_id INT NOT NULL,
  contract_copy LONGTEXT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  supervisors_employee_id INT NOT NULL,
  CONSTRAINT fk_pharmacies_has_pharma_companies_pharmacies1
    FOREIGN KEY (pharmacy_id)
    REFERENCES pharmacies (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_pharmacies_has_pharma_companies_pharma_companies1
    FOREIGN KEY (pharma_company_id)
    REFERENCES pharma_companies (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_contracts_supervisors1
    FOREIGN KEY (supervisors_employee_id)
    REFERENCES supervisors (employee_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Create many to many relationship between pharmacies and supervisors.
CREATE TABLE pharmacies_has_supervisors (
  pharmacies_id INT NOT NULL,
  supervisors_id INT NOT NULL,
  CONSTRAINT fk_pharmacies_has_supervisors_pharmacies1
    FOREIGN KEY (pharmacies_id)
    REFERENCES pharmacies (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_pharmacies_has_supervisors_supervisors1
    FOREIGN KEY (supervisors_id)
    REFERENCES supervisors (employee_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Sample doctors
INSERT INTO doctors
VALUES
	(132543355, 'Amy Gonzales', 'Hematology Oncology', 15),
    (134589405, 'Nathan Jobes', 'ENT', 20),
    (940385647, 'Chris Bray', 'Oncology', 32);

-- Sample patients
INSERT INTO patients
VALUES 
	(387498273, 'Jack Nicholson', 75, '123 Somewhere Court'),
    (867019283, 'The Rock', 40, '123 Somewhere Circle'),
    (574049384, 'Bill Gates', 55, '123 Somewhere Avenue'),
    (182930473, 'Bill Clinton', 85, '123 Somewhere Street'),
    (938472907, 'Richard Gere', 32, '123 Somewhere Road'),
    (184382937, 'Madds Mikkelsen', 38, '123 Somewhere Manor');

-- Sample pharmaceutical companies
INSERT INTO pharma_companies (name, phone)
VALUES
	('Johnson & Johnson', '(925) 556-5463'),
    ('Pfizer', '(510) 334-5566'),
    ('AstraZeneca', '(123) 456-7890');

-- Sample formulas
INSERT INTO formulas (active_ingredient, concentration)
VALUES
    ('ibuprofen', 0.25),
    ('acetominophen', 0.15),
    ('amoxicillin trihydrate', 1);

-- Sample drugs
INSERT INTO drugs (trade_name, formula_id)
VALUES
	('Motrin', 1),
    ('Vicodin', 2),
    ('Amoxicillin', 3);

-- Sample pharmacies
INSERT INTO pharmacies (name, address, phone)
VALUES
	('Prescription Palace', '123 Sesame Street, Walnut Creek, CA, 99999', '(925) 123-4567'),
    ('Over the Counter', '123 Sesame Avenue, Walnut Creek, CA, 99999', '(925) 123-9876'),
    ('Lozenge Lane', '123 Sesame Circle, Walnut Creek, CA, 99999', '(510) 123-4343');

-- Sample entries for patient doctor relationships.
INSERT INTO patients_has_doctors
VALUES
	(387498273, 132543355),
    (867019283, 132543355),
    (574049384, 134589405),
    (182930473, 134589405),
    (938472907, 940385647);

-- Sample entries for relationship between pharmacies and drugs.
INSERT INTO pharmacies_has_drugs
VALUES
	(1, 1, 15.00),
    (2, 2, 30.00),
    (2, 1, 10.50),
    (3, 2, 15.00),
    (3, 3, 120.75);

INSERT INTO drugs_has_pharma_companies
VALUES
	(1, 1),
    (1, 2),
    (2, 2),
    (2, 3),
    (3, 1),
    (3, 2),
    (3, 3);

INSERT INTO prescriptions
VALUES
    (387498273, 132543355, 1, NULL, '2021-05-17', NULL, 90),
    (867019283, 132543355, 2, 1, '2021-05-17', '2021-05-21', 120),
    (182930473, 134589405, 3, NULL, '2021-05-17', NULL, 80),
    (938472907, 940385647, 2, 3, '2021-05-08', '2021-05-12', 120),
    (938472907, 134589405, 2, 1, '2021-05-08', '2021-05-12', 120);
    
    

INSERT INTO supervisors
VALUES
    (523654, 'Jeremiah Bullfrog', '(123) 456-7890'),
    (839483, 'Jimmy Johns', '(123) 456-2612'),
    (102867, 'Ricky Ricksters', '(123) 201-2936');

INSERT INTO contracts
VALUES
    (1, 1, 'You shall pay an immense amount of money to us.', '2021-01-10', '2022-01-10', 523654),
    (2, 2, 'We only want you to sell two million units.', '2020-05-17', '2022-05-17', 839483),
    (3, 3, 'Please sell as much as you can, and pay us 100% of the profits.', '2018-02-28', '2020-02-28', 102867);

INSERT INTO pharmacies_has_supervisors
VALUES
	(1, 523654),
    (2, 839483),
    (3, 102867);

/*
	Find the start and end date of the contract, name of the pharmacy,
    name of the drug, and name of the pharma company where the drug name is Motrin.
*/
SELECT
	contracts.start_date AS contract_start_date,
    contracts.end_date AS contract_end_date,
    pharmacies.name AS pharmacy_name,
    drugs.trade_name AS drug_trade_name,
    pharma_companies.name AS pharma_company_name
FROM contracts
JOIN pharmacies ON contracts.pharmacy_id = pharmacies.id
JOIN pharmacies_has_drugs ON pharmacies.id = pharmacies_has_drugs.pharmacies_id
JOIN drugs ON pharmacies_has_drugs.drugs_id = drugs.id
JOIN pharma_companies ON contracts.pharma_company_id = pharma_companies.id
WHERE drugs.trade_name = 'Motrin';

-- Minimum price of a given drug across all pharmacies.
SELECT pharmacy_name, drug_trade_name, price FROM (
	SELECT
		pharmacies.name AS pharmacy_name,
		drugs.trade_name AS drug_trade_name,
		price
	FROM pharmacies_has_drugs
	JOIN pharmacies ON pharmacies_has_drugs.pharmacies_id = pharmacies.id
	JOIN drugs ON pharmacies_has_drugs.drugs_id = drugs.id
	WHERE drugs.trade_name = 'Motrin'
) AS Motrins
WHERE price = (
	SELECT min(price) AS minPrice FROM (
		SELECT
			pharmacies.name AS pharmacy_name,
			drugs.trade_name AS drug_trade_name,
			price
		FROM pharmacies_has_drugs
		JOIN pharmacies ON pharmacies_has_drugs.pharmacies_id = pharmacies.id
		JOIN drugs ON pharmacies_has_drugs.drugs_id = drugs.id
		WHERE drugs.trade_name = 'Motrin'
	) AS Motrins
);

-- Get all doctor patient relationships for Dr. Amy Gonzales
SELECT patients.name, doctors.name FROM patients, patients_has_doctors, doctors
WHERE doctors.ssn = patients_has_doctors.doctors_ssn
AND patients.ssn = patients_has_doctors.patients_ssn
AND doctors.name = 'Amy Gonzales';

-- Find the number of contracts supervised by the supervisor "Jimmy Johns"
SELECT count(*) as number_of_contracts FROM (
	SELECT * FROM contracts, supervisors
    WHERE contracts.supervisors_employee_id = supervisors.employee_id
    AND supervisors.name = "Jimmy Johns"
) AS something;

-- Finds how many products are using that active ingredient.
SELECT formulas.active_ingredient, COUNT(formulas.id) AS productCount FROM drugs
JOIN formulas ON formulas.id = drugs.formula_id
GROUP BY formulas.active_ingredient;
