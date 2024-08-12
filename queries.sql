-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

-- Find all the maximum doses of a given drug given it's name and which indication it is used to treat
SELECT "max_dose"."maximum_dose", "indications"."indications_name"
FROM "max_dose"
JOIN "indications" ON "indications"."id" = "max_dose"."indications_id"
WHERE "max_dose"."drug_id" = (
    SELECT "id"
    FROM "drugs"
    WHERE "drug_name" = 'Fluoxetine'
) AND "max_dose"."indications_id" = (
    SELECT "id"
    FROM "indications"
    WHERE "indications_name" = 'Anxiety'
);

-- Find all the strengths of the drug we keep given it's name
SELECT "strength_of_drug"
FROM "strengths"
WHERE "drug_id" = (
    SELECT "id"
    FROM "drugs"
    WHERE "drug_name" = 'Fluoxetine'
);

-- Find the current inventory balance of a drug given its name and strength
SELECT "inventory"."balance"
FROM "inventory"
JOIN "strengths" ON "inventory"."strengths_id" = "strengths"."id"
WHERE "inventory"."drug_id" = (
    SELECT "id"
    FROM "drugs"
    WHERE "drug_name" = 'Fluoxetine'
) AND "inventory"."strengths_id" = (
    SELECT "id"
    FROM "strengths"
    WHERE "drug_id" = (
        SELECT "id"
        FROM "drugs"
        WHERE "drug_name" = 'Fluoxetine'
    ) AND "strenghts" = '20mg'
);

-- Find all the transactions of a drug given its name and strength
SELECT "transactions"."transaction_changes", "transactions"."transaction_date"
FROM "transactions"
JOIN "strengths" ON "transactions"."strengths_id" = "strengths"."id"
WHERE "transactions"."drug_id" = (
    SELECT "id"
    FROM "drugs"
    WHERE "drug_name" = 'Fluoxetine'
) AND "transactions"."strengths_id" = (
    SELECT "id"
    FROM "strengths"
    WHERE "drug_id" = (
        SELECT "id"
        FROM "drugs"
        WHERE "drug_name" = 'Fluoxetine'
    ) AND "strengths" = '20mg'
);

-- Find the information of a patient given its firstname and lastname
SELECT *
FROM "patients"
WHERE "pt_firstname" = 'Alan' AND "pt_lastname" = 'Skywalker';

-- Find the list of all indications a drug can treat given a particular drug from the created max_dose_table view
SELECT "drugs"."drug_name", "indications"."indications_name"
FROM "max_dose_table"
WHERE "drugs"."drug_name" LIKE '%luoxetin%';

-- Add a new drug
INSERT INTO "drugs" ("drug_name", "therapeutic_class")
VALUES ('Lisinopril', 'CVM');

-- Add a new patient
INSERT INTO "patients" ("pt_firstname", "pt_lastname", "gender", "pt_NRIC")
VALUES ('Alan', 'Skywalker', 'M', 'Z8928374D');

-- Add a new transaction
INSERT INTO "transactions" ("drug_id", "strengths_id", "transaction_changes")
VALUES ('98', '34', '+10000');
