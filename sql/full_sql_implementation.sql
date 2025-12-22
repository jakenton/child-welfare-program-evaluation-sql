/* ============================================================
   CHILD WELFARE PROGRAM EVALUATION DATABASE
   Platform: PostgreSQL (ANSI SQL–compliant)
   Purpose: Evaluate funding efficiency and child outcomes
   ============================================================ */


/* TABLE: Programs
   Stores high-level child welfare programs */
CREATE TABLE Programs (
    ProgramID INT PRIMARY KEY,
    ProgramName VARCHAR(100),
    ProgramType VARCHAR(50),             -- Prevention, Foster Care, Permanency
    FederalFundingSource VARCHAR(50)      -- IV-E, CAPTA, CBCAP
);


/* TABLE: FiscalYears
   Enables time-based funding and trend analysis */
CREATE TABLE FiscalYears (
    FiscalYear INT PRIMARY KEY,
    StartDate DATE,
    EndDate DATE
);


/* TABLE: ProgramFunding
   Tracks allocated vs. spent funds by program and year
   Supports budget accountability and reporting */
CREATE TABLE ProgramFunding (
    FundingID INT PRIMARY KEY,
    ProgramID INT,
    FiscalYear INT,
    AllocatedAmount DECIMAL(12,2),
    SpentAmount DECIMAL(12,2),
    FOREIGN KEY (ProgramID) REFERENCES Programs(ProgramID),
    FOREIGN KEY (FiscalYear) REFERENCES FiscalYears(FiscalYear)
);


/* TABLE: Children
   Represents children served (simulated only) */
CREATE TABLE Children (
    ChildID INT PRIMARY KEY,
    BirthYear INT,
    Region VARCHAR(50),
    EntryDate DATE
);


/* TABLE: Outcomes
   Tracks permanency and exit outcomes */
CREATE TABLE Outcomes (
    OutcomeID INT PRIMARY KEY,
    ChildID INT,
    ProgramID INT,
    OutcomeType VARCHAR(30),   -- Reunification, Adoption, Aging Out
    OutcomeDate DATE,
    FOREIGN KEY (ChildID) REFERENCES Children(ChildID),
    FOREIGN KEY (ProgramID) REFERENCES Programs(ProgramID)
);


/* ============================================================
   SIMULATED DATA INSERTS
   ============================================================ */

INSERT INTO Programs VALUES
(1, 'Family Preservation Services', 'Prevention', 'CBCAP'),
(2, 'Foster Care Services', 'Foster Care', 'Title IV-E'),
(3, 'Permanency Planning', 'Permanency', 'Title IV-E');

INSERT INTO FiscalYears VALUES
(2022, '2021-07-01', '2022-06-30'),
(2023, '2022-07-01', '2023-06-30');

INSERT INTO ProgramFunding VALUES
(1, 1, 2022, 1500000, 1420000),
(2, 2, 2022, 3200000, 3400000),
(3, 3, 2022, 2100000, 1980000),
(4, 1, 2023, 1600000, 1500000),
(5, 2, 2023, 3300000, 3500000),
(6, 3, 2023, 2200000, 2150000);

INSERT INTO Children VALUES
(1, 2010, 'Northwest', '2021-03-15'),
(2, 2012, 'Central', '2021-06-10'),
(3, 2005, 'South', '2020-11-01'),
(4, 2007, 'Central', '2019-08-20');

INSERT INTO Outcomes VALUES
(1, 1, 1, 'Reunification', '2022-02-10'),
(2, 2, 2, 'Adoption', '2023-04-18'),
(3, 3, 2, 'Aging Out', '2022-09-30'),
(4, 4, 3, 'Reunification', '2023-05-12');


/* ============================================================
   ANALYTICAL QUERIES (PROGRAM EVALUATION)
   ============================================================ */


/* 1. Budget Variance Analysis
   Identifies over- and under-spending by program and year */
SELECT
    p.ProgramName,
    f.FiscalYear,
    pf.AllocatedAmount,
    pf.SpentAmount,
    (pf.SpentAmount - pf.AllocatedAmount) AS BudgetVariance
FROM ProgramFunding pf
JOIN Programs p ON pf.ProgramID = p.ProgramID
JOIN FiscalYears f ON pf.FiscalYear = f.FiscalYear
ORDER BY ABS(BudgetVariance) DESC;


/* 2. Cost Per Outcome
   Measures program efficiency and supports CQI */
SELECT
    p.ProgramName,
    o.OutcomeType,
    COUNT(o.OutcomeID) AS OutcomeCount,
    ROUND(SUM(pf.SpentAmount) / COUNT(o.OutcomeID), 2) AS CostPerOutcome
FROM Outcomes o
JOIN Programs p ON o.ProgramID = p.ProgramID
JOIN ProgramFunding pf ON p.ProgramID = pf.ProgramID
GROUP BY p.ProgramName, o.OutcomeType;


/* 3. Outcome Distribution
   Supports federal reporting and settlement monitoring */
SELECT
    OutcomeType,
    COUNT(*) AS TotalCases,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS Percentage
FROM Outcomes
GROUP BY OutcomeType;


/* 4. Regional Equity Analysis
   Identifies potential disparities in outcomes */
SELECT
    c.Region,
    o.OutcomeType,
    COUNT(*) AS OutcomeCount
FROM Outcomes o
JOIN Children c ON o.ChildID = c.ChildID
GROUP BY c.Region, o.OutcomeType
ORDER BY c.Region;


/* 5. Outcome Trend Over Time
   Supports leadership monitoring of progress */
SELECT
    EXTRACT(YEAR FROM OutcomeDate) AS OutcomeYear,
    COUNT(*) AS TotalOutcomes
FROM Outcomes
GROUP BY OutcomeYear
ORDER BY OutcomeYear;


/* REPORTING VIEW
   Simplifies dashboard and reporting integration */
CREATE VIEW ProgramOutcomeSummary AS
SELECT
    p.ProgramName,
    o.OutcomeType,
    COUNT(*) AS OutcomeCount
FROM Outcomes o
JOIN Programs p ON o.ProgramID = p.ProgramID
GROUP BY p.ProgramName, o.OutcomeType;
