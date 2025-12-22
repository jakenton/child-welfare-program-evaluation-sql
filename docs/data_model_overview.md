# Data Model Overview

## Purpose of the Data Model
This data model was designed to support **child welfare program evaluation** by linking **program funding**, **service activity**, and **child permanency outcomes** into clear, auditable, and analysis-ready structure. The model reflects common public-secotr data practices and supports performance measurement, trend analysis, and equity-focused evaluation.

All data represtend in this project is **full simulated** and intended solely for demonstration purposes.

---

## Design Principles
The data model was developed using the following principles:

-**Clarity:** Tables are organized around intuitive entities (programs, funding, outcomes).
-**Traceability:** Funding and outcomes can be linked back to specific programs and fiscal years.
-**Governance:** The structure supports validation, documentation, and repeatable analysis.
-**Evaluation-Focused:** The model prioritizes analytical questions over transactional complexity.

---

## Core Tables

### 1. Programs
This table represents welfare programs or initiatives being evaluated.


**Purpose:**
- Acts as the central reference point for all analysis.
- Enables comparisons across programs.

**Key Attributes (examples):**
- Program ID (primary key)
- Program Name
- Program Type (e.g., prevention, permanency support)
- Region

---

### 2. Program Funding
This table captures funding allocations and expenditures by program and fiscal year.

**Purpose:**
- Supports fiscal accountability and efficiency analysis.
- Enables calculation of budget utilization and cost per outcome.

**Key Attributes (examples):**
- Funding ID (primary key)
- Program ID (foreign key)
- Fiscal Year
- Allocated Amount
- Spent Amount

---

### 3. Outcomes
This table records aggregated child permanency outcome associated with each program.

**Purpose:**
- Support outcome measurement and trend analysis.
- Enables comparison of permanency types across programs and regions.

**Key Attributes (examples):**
- Outcome ID (primary key)
- Program ID (foreign key)
- Fiscal Year
- Outcome Type (Reunification, Adoption, Aging Out)
- Outcome Count

---

### 4. Regions
This table standardizes geographic regions used for equity and comparative analysis.

**Purpose:**
- Enables regional outcome comparisons.
- Supports equity-focused evaluation.

**Key Attributes (examples):**
- Region ID (primary key)
- Region Name

---

## Relationships Between Tables
- Each **Program** can have multiple funding recors across fiscal years.
- Each **Program** can have multiple outcome records.
- Funding and outcomes are linked through the **Program ID** and **Fiscal Year**.
- Regions provide a consistent geographic dimension for analysis.

This structure enables efficient SQL joins and supports performance measure calculations without duplicating data.

---

## Analytical Use Cases Supported
The data model supports analysis such as
- Cost per permanency outcome by program
- Budget utilization by fiscal year
- Outcome trends over time
- Regional comparisons of permanency outcomes
- Identification of programs for targeted improvement

---

## Ethical Considerations
This model intentionally avoids
- Case-level data
- Personally identifiable information
- Sensitive child or family attributes

All analysis is conduceted at an **aggregate level** to reflect ethical data use practices in child welfare evaluation.

---

**Summary**
This data model provides a practical foundation for **program evaluation**, **continuous quality improvement**, and **leadership reporting**. Its structure mirrors how public-sector agencies organize data to answer complex questions about effeciveness, efficiency, and equity.