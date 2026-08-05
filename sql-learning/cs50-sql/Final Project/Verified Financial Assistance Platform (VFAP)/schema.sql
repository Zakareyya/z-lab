-- The `PERSON` table stores individuals requesting financial assistance.

CREATE TABLE "PERSON" (
    "person_id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "date_of_birth" NUMERIC NOT NULL,
    "country" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "email" text NOT NULL,
    "created_at" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("person_id")
);


-- The `ASSISTANCE_CASE` table represents a specific period where a person requires assistance.

CREATE TABLE "ASSISTANCE_CASE" (
    "case_id" INTEGER,
    "person_id" INTEGER,
    "case_status_id" INTEGER,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "opened_at" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "closed_at" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("case_id"),
    FOREIGN KEY ("person_id") REFERENCES "PERSON"("person_id"),
    FOREIGN KEY ("case_status_id") REFERENCES "CASE_STATUS"("case_status_id")
);


-- The `CASE_STATUS` table stores possible statuses for assistance cases.

CREATE TABLE "CASE_STATUS" (
    "case_status_id" INTEGER,
    "status" TEXT NOT NULL DEFAULT 'Open' CHECK ("status" IN ('Open', 'Closed')),
    PRIMARY KEY ("case_status_id")
);


-- The `NEED` table represents a specific assistance requirement belonging to an assistance case.

CREATE TABLE "NEED" (
    "need_id" INTEGER,
    "case_id" INTEGER,
    "need_type_id" INTEGER,
    "need_status_id" INTEGER,
    "amount_requested" NUMERIC NOT NULL CHECK ("amount_requested" > 0),
    "currency" TEXT NOT NULL DEFAULT 'USD' CHECK ("currency" IN ('USD')),
    "priority" TEXT NOT NULL DEFAULT 'Not Urgent' CHECK ("priority" IN ('Not Urgent', 'Urgent')),
    "description" TEXT NOT NULL,
    "created_at" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("need_id"),
    FOREIGN KEY ("case_id") REFERENCES "ASSISTANCE_CASE"("case_id"),
    FOREIGN KEY ("need_type_id") REFERENCES "NEED_TYPE"("need_type_id"),
    FOREIGN KEY ("need_status_id") REFERENCES "NEED_STATUS"("need_status_id")
);


-- The `NEED_TYPE` table stores categories of assistance needs.

CREATE TABLE "NEED_TYPE" (
    "need_type_id" INTEGER,
    "type" TEXT NOT NULL CHECK("type" IN ('Medical Assistance', 'Housing', 'Education', 'Food')),
    "description" TEXT,
    PRIMARY KEY ("need_type_id")
);


-- The `NEED_STATUS` table stores possible statuses for needs.

CREATE TABLE "NEED_STATUS" (
    "need_status_id" INTEGER,
    "status" TEXT NOT NULL DEFAULT 'Pending' CHECK("status" IN ('Pending', 'Fulfilled')),
    PRIMARY KEY ("need_status_id")
);


-- The `DOCUMENT` table stores metadata about evidence supporting a need.

CREATE TABLE "DOCUMENT" (
    "document_id" INTEGER,
    "need_id" INTEGER,
    "document_type" TEXT NOT NULL,
    "file_name" TEXT NOT NULL,
    "uploaded_at" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("document_id"),
    FOREIGN KEY ("need_id") REFERENCES "NEED"("need_id")
);


-- The `VERIFICATION` table stores verification events performed by authorized individuals.

CREATE TABLE "VERIFICATION" (
    "verification_id" INTEGER,
    "need_id" INTEGER,
    "verifier_id" INTEGER,
    "comments" TEXT,
    "verified_at" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("verification_id"),
    FOREIGN KEY ("need_id") REFERENCES "NEED"("need_id"),
    FOREIGN KEY ("verifier_id") REFERENCES "VERIFIER"("verifier_id")
);


-- The `ORGANIZATION` table stores organizations participating in the verification process.

CREATE TABLE "ORGANIZATION" (
    "organization_id" INTEGER,
    "name" TEXT NOT NULL,
    "organization_type" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "country" TEXT NOT NULL,
    PRIMARY KEY ("organization_id")
);


-- The `VERIFIER` table stores individuals authorized to verify assistance needs.

CREATE TABLE "VERIFIER"(
    "verifier_id" INTEGER,
    "organization_id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    PRIMARY KEY ("verifier_id"),
    FOREIGN KEY ("organization_id") REFERENCES "ORGANIZATION"("organization_id")
);


-- The `DONOR` table stores individuals or entities providing donations.

CREATE TABLE "DONOR" (
    "donor_id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "country" TEXT NOT NULL,
    PRIMARY KEY ("donor_id")
);


-- The `DONATION` table stores donations made toward specific needs.

CREATE TABLE "DONATION" (
    "donation_id" INTEGER,
    "donor_id" INTEGER,
    "need_id" INTEGER,
    "amount" NUMERIC NOT NULL CHECK ("amount" > 0),
    "currency" TEXT NOT NULL CHECK ("currency" IN ('USD')),
    "anonymous" INTEGER NOT NULL CHECK ("anonymous" IN (1,0)),
    "donated_at" NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("donation_id"),
    FOREIGN KEY ("donor_id") REFERENCES "DONOR"("donor_id"),
    FOREIGN KEY ("need_id") REFERENCES "NEED"("need_id")
);


---


---- VIEWS:

-- Verified needs awaiting funding sorted by urgency:
-- Displays all pending funding needs with their total donations received, sorted by priority.

CREATE VIEW "Needs_awaiting_funding" AS
SELECT "NEED"."priority" AS 'Priority', "ASSISTANCE_CASE"."title" AS 'Case',
       "NEED_TYPE"."type" AS 'Need', "NEED"."description" AS 'Description',
       SUM("DONATION"."amount") AS 'Total Donations',"NEED"."amount_requested" AS 'Needed Amount',
       "NEED"."currency" AS 'Currency'
FROM "ASSISTANCE_CASE"
JOIN "NEED" ON "NEED"."case_id" = "ASSISTANCE_CASE"."case_id"
JOIN "NEED_TYPE" ON "NEED_TYPE"."need_type_id" = "NEED"."need_type_id"
JOIN "NEED_STATUS" ON "NEED_STATUS"."need_status_id" = "NEED"."need_status_id"
LEFT JOIN "DONATION" ON "DONATION"."need_id" = "NEED"."need_id"
WHERE "NEED_STATUS"."status" LIKE 'Pending'
GROUP BY "NEED"."need_id"
ORDER BY "NEED"."priority" DESC, "ASSISTANCE_CASE"."case_id";


-- Verification history by organization:
-- Displays the verification history for assistance needs, grouped by organization and sorted by most recent verification.

CREATE VIEW "Verification_history_by_organization" AS
SELECT "VERIFICATION"."verified_at" AS 'Verification Date', "ASSISTANCE_CASE"."title" AS 'Case',
       "NEED_TYPE"."type" AS 'Need', "VERIFIER"."first_name" || ' ' || "VERIFIER"."last_name" AS 'Verifier',
       "VERIFIER"."role" AS 'Role', "ORGANIZATION"."name" AS 'Organization'
FROM "ASSISTANCE_CASE"
JOIN "NEED" ON "NEED"."case_id" = "ASSISTANCE_CASE"."case_id"
JOIN "NEED_TYPE" ON "NEED_TYPE"."need_type_id" = "NEED"."need_type_id"
JOIN "VERIFICATION" ON "VERIFICATION"."need_id" = "NEED"."need_id"
JOIN "VERIFIER" ON "VERIFIER"."verifier_id" = "VERIFICATION"."verifier_id"
JOIN "ORGANIZATION" ON "ORGANIZATION"."organization_id" = "VERIFIER"."organization_id"
ORDER BY "ORGANIZATION"."name", "VERIFICATION"."verified_at" DESC;


-- All time donor contribution summary:
-- Displays each donor's total lifetime contributions, ranked from highest to lowest.

CREATE VIEW "All_time_donor_contribution_summary" AS
SELECT "DONOR"."first_name" || ' ' || "DONOR"."last_name" AS 'Donor',
       SUM("DONATION"."amount") AS 'Contribution', "USD" AS 'Currency'
FROM "DONOR"
JOIN "DONATION" ON "DONATION"."donor_id" = "DONOR"."donor_id"
GROUP BY "DONOR"."donor_id"
ORDER BY SUM("DONATION"."amount") DESC, "DONOR"."first_name", "DONOR"."last_name";


-- Fully funded needs:
-- Displays needs that have received donations equal to or greater than the requested amount.

CREATE VIEW "Fully_funded_needs" AS
SELECT "ASSISTANCE_CASE"."title" AS "Case", "NEED_TYPE"."type" AS "Need", "NEED"."description",
       "NEED"."amount_requested" AS "Requested", SUM("DONATION"."amount") AS "Received"
FROM "ASSISTANCE_CASE"
JOIN "NEED" ON "NEED"."case_id" = "ASSISTANCE_CASE"."case_id"
JOIN "NEED_TYPE" ON "NEED_TYPE"."need_type_id" = "NEED"."need_type_id"
LEFT JOIN "DONATION" ON "DONATION"."need_id" = "NEED"."need_id"
GROUP BY "NEED"."need_id"
HAVING SUM("DONATION"."amount") >= "NEED"."amount_requested";



---


------Indexes:

-- Speeds up searching for people by name.
CREATE INDEX "idx_person_name" ON "PERSON"("first_name", "last_name");


-- Speeds up retrieving all cases belonging to a person.
CREATE INDEX "idx_assistance_case_person" ON "ASSISTANCE_CASE"("person_id");


-- Speeds up filtering cases by status.
CREATE INDEX "idx_assistance_case_status" ON "ASSISTANCE_CASE"("case_status_id");


-- Speeds up joins between NEED and ASSISTANCE_CASE.
CREATE INDEX "idx_need_case" ON "NEED"("case_id");


-- Speeds up filtering by need status.
CREATE INDEX "idx_need_status" ON "NEED"("need_status_id");


-- Speeds up joins with NEED_TYPE.
CREATE INDEX "idx_need_type" ON "NEED"("need_type_id");


-- Speeds up retrieving documents for a need.
CREATE INDEX "idx_document_need" ON "DOCUMENT"("need_id");


-- Speeds up verification history lookups.
CREATE INDEX "idx_verification_need" ON "VERIFICATION"("need_id");


-- Speeds up verifier lookups.
CREATE INDEX "idx_verification_verifier" ON "VERIFICATION"("verifier_id");


-- Speeds up grouping verifiers by organization.
CREATE INDEX "idx_verifier_organization" ON "VERIFIER"("organization_id");


-- Speeds up all donation totals per need.
CREATE INDEX "idx_donation_need" ON "DONATION"("need_id");


-- Speeds up donor contribution summary.
CREATE INDEX "idx_donation_donor" ON "DONATION"("donor_id");
