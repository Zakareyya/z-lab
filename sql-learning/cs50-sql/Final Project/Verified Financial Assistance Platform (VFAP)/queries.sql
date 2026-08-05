-- Add a new person requesting assistance

INSERT INTO "PERSON"
("first_name", "last_name", "date_of_birth", "country", "phone", "email")
VALUES
('Ali', 'Hassan', '1990-03-15', 'Lebanon', '+96171123456', 'ali.hassan@email.com');


-- Create a new assistance case for a person

INSERT INTO "ASSISTANCE_CASE"
("person_id", "case_status_id", "title", "description")
VALUES
(1, 1, 'Emergency Housing Support',
'Temporary housing assistance after job loss.');


-- Add a new need under an assistance case

INSERT INTO "NEED"
("case_id", "need_type_id", "need_status_id",
"amount_requested", "priority", "description")
VALUES
(1, 1, 1, 2500, 'Urgent',
'Medical treatment expenses.');


-- View all pending needs awaiting funding

SELECT *
FROM "Needs_awaiting_funding";


-- View verification history

SELECT *
FROM "Verification_history_by_organization";


-- Add a verification record for a need

INSERT INTO "VERIFICATION"
("need_id", "verifier_id", "comments")
VALUES
(1, 1, 'Documents reviewed and need confirmed.');


-- Upload a supporting document

INSERT INTO "DOCUMENT"
("need_id", "document_type", "file_name")
VALUES
(1, 'Medical Report', 'medical_report.pdf');


-- Add a donor

INSERT INTO "DONOR"
("first_name", "last_name", "email", "country")
VALUES
('John', 'Smith', 'john.smith@email.com', 'USA');


-- Record a donation

INSERT INTO "DONATION"
("donor_id", "need_id", "amount", "currency", "anonymous")
VALUES
(1, 1, 500, 'USD', 0);


-- Show donations received for a specific need:

SELECT "ASSISTANCE_CASE"."title" AS "Case", SUM("DONATION"."amount") AS "Total Donations"
FROM "ASSISTANCE_CASE"
JOIN "NEED" ON "NEED"."case_id" = "ASSISTANCE_CASE"."case_id"
JOIN "DONATION" ON "DONATION"."need_id" = "NEED"."need_id"
WHERE "NEED"."need_id" = 1
GROUP BY "NEED"."need_id";


--Update a need status after funding:

UPDATE "NEED"
SET "need_status_id" = 2
WHERE "need_id" = 1;


-- View all cases of a specific status:

SELECT "ASSISTANCE_CASE"."title" AS 'Case', "ASSISTANCE_CASE"."description" AS 'Description'
FROM "ASSISTANCE_CASE"
JOIN "CASE_STATUS" ON "CASE_STATUS"."case_status_id" = "ASSISTANCE_CASE"."case_status_id"
WHERE "CASE_STATUS"."status" = 'Open';


