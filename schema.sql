-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it

-- Represent a table of drugs
CREATE TABLE "drugs" (
    "id" INTEGER,
    "drug_name" TEXT NOT NULL,
    "therapeutic_class" TEXT NOT NULL,
    PRIMARY KEY("id")
);

-- Represent the common indications of drugs
CREATE TABLE "indications" (
    "id" INTEGER,
    "indications_name" TEXT NOT NULL,
    PRIMARY KEY("id")
);

-- Represent the max doses of drugs
CREATE TABLE "max_dose" (
    "drug_id" INTEGER,
    "indications_id" INTEGER,
    "maximum_dose" TEXT NOT NULL,
    FOREIGN KEY("drug_id") REFERENCES "drugs"("id"),
    FOREIGN KEY("indications_id") REFERENCES "indications"("id")
);

-- Represent the various strengths each drug comes in
CREATE TABLE "strengths" (
    "id" INTEGER,
    "drug_id" INTEGER,
    "strength_of_drug" TEXT NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("drug_id") REFERENCES "drugs"("id")
);

-- Represent the balance inventory of each drug and their specific strengths
CREATE TABLE "inventory" (
    "drug_id" INTEGER,
    "strengths_id" INTEGER,
    "balance" INTEGER,
    FOREIGN KEY("drug_id") REFERENCES "drugs"("id"),
    FOREIGN KEY("strengths_id") REFERENCES "strengths"("id")
);

-- Represent the transactions of each drug and their specific strengths
CREATE TABLE "transactions" (
    "id" INTEGER,
    "drug_id" INTEGER,
    "strengths_id" INTEGER,
    "transaction_changes" INTEGER NOT NULL,
    "transaction_date" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("id"),
    FOREIGN KEY("drug_id") REFERENCES "drugs"("id"),
    FOREIGN KEY("strengths_id") REFERENCES "strengths"("id")
);

-- Represent a table of patients
CREATE TABLE "patients" (
    "id" INTEGER,
    "pt_firstname" TEXT NOT NULL,
    "pt_lastname" TEXT NOT NULL,
    "gender" TEXT NOT NULL CHECK("gender" IN ('M', 'F'))
    "pt_NRIC" TEXT NOT NULL UNIQUE,
    PRIMARY KEY("id")
);

-- Represent a table of doctors
CREATE TABLE "doctors" (
    "id" INTEGER,
    "dr_firstname" TEXT NOT NULL,
    "dr_lastname" TEXT NOT NULL,
    "dr_MCR" TEXT NOT NULL UNIQUE,
    "dr_title" TEXT NOT NULL CHECK("dr_title" IN ('Con', 'MO', 'Sr Con')),
    PRIMARY KEY("id")
);

-- Represent the outpatient visits for a given patient
CREATE TABLE "op_visits" (
    "id" INTEGER
    "patients_id" INTEGER,
    "visit_type" TEXT NOT NULL,
    "timestamp" NUMERIC NOT NULL,
    "doctors_id" INTEGER,
    FOREIGN KEY("patients_id") REFERENCES "patients"("id"),
    FOREIGN KEY("doctors_id") REFERENCES "doctors"("id"),
    PRIMARY KEY("id")
);

-- Represent the outpatient prescriptions for a given patient
CREATE TABLE "op_rx" (
    "patients_id" INTEGER,
    "doctors_id" INTEGER,
    "drug_id" INTEGER,
    "strengths_id" INTEGER,
    "timestamp" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY("patients_id") REFERENCES "patients"("id"),
    FOREIGN KEY("doctors_id") REFERENCES "doctors"("id"),
    FOREIGN KEY("drug_id") REFERENCES "drugs"("id"),
    FOREIGN KEY("strengths_id") REFERENCES "strengths"("id")

);

-- Create indexes to speed common searches
CREATE INDEX "drug_name_search" ON "drugs" ("drug_name");
CREATE INDEX "patient_search" ON "patients" ("pt_firstname", "pt_lastname");
CREATE INDEX "indication_search" ON "indications" ("indications_name");

-- Create a view to outline the patients with their outpatient visits and the prescriptions prescribed by their given doctor
CREATE VIEW "patients_prescriptions" AS
SELECT P."pt_firstname", P."pt_lastname", V."visit_type", R."drug_id", R."strengths_id"
FROM "patients" P
JOIN "op_rx" R ON P."id" = R."patients_id"
JOIN "op_visits" V ON P."id" = V."patients_id";


-- Create a view to outline the drugs and their maximum doses with indications
CREATE VIEW "max_dose_table" AS
SELECT "drugs"."drug_name", "indications"."indications_name", "max_dose"
FROM "max_dose"
JOIN "indications" ON "indications"."id" = "max_dose"."indications_id"
JOIN "drugs" ON "drugs"."id" = "max_dose"."drug_id";
