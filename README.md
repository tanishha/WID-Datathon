# Real-Time Data Monitoring & Anomaly Detection System  
**Satellite Decay Prediction and Orbital Debris Analytics**  
Datanauts Femme - WiD Datathon 2025

## Project Summary
This project implements an end-to-end **data engineering and machine learning pipeline** to ingest, process, store, analyze, and model satellite and orbital debris data. The system is built using **Python, Azure SQL, Azure Functions, REST APIs, Pandas, Scikit-learn, and Tableau**.

Historical orbital elements from **Space-Track.org** are ingested via REST APIs, transformed into analytics-ready tables in Azure SQL, visualized using Tableau, and used to train machine learning models that predict satellite decay risk based on orbital characteristics such as altitude, inclination, eccentricity, and mean anomaly.

The primary focus is on **pipeline reliability, data modeling, automation, and explainable machine learning**, following cloud-native data engineering best practices.

## Problem Definition
Earth’s orbit is increasingly congested with inactive satellites and orbital debris. Manual analysis of orbital data does not scale and lacks predictive capability. This project addresses the following technical challenges:

- Scalable ingestion of large, historical orbital datasets  
- Transformation of raw orbital elements into trusted, analytics-ready data  
- Identification of features contributing to satellite decay and collision risk  
- Development of predictive models that balance accuracy and interpretability  

## Data Source
**Space-Track.org (U.S. Space Command)**

- REST API–based access  
- 10+ years of historical satellite and debris data  
- Orbital elements, launch metadata, conjunction events, decay indicators  

Data is retrieved in JSON format and requires extensive parsing and normalization.

## System Architecture
The system follows a layered data architecture with automation and orchestration.

### High-Level Flow
1. REST API ingestion from Space-Track.org  
2. Raw data persistence in staging tables  
3. Data transformation and validation  
4. Upsert into trusted target tables  
5. Analytics, visualization, and machine learning  

### Core Components
- **Azure Functions** – Time-triggered pipeline orchestration  
- **Azure SQL Database** – Staging and target schemas  
- **Python** – Ingestion, transformation, analytics, and modeling  
- **Tableau** – Exploratory analysis and dashboards  

## Data Pipeline Implementation

### 1. Data Acquisition
- Authenticated REST API calls to Space-Track.org  
- Retrieved approximately 10 years of orbital data including:
  - Orbital parameters  
  - Launch and object metadata  
  - Decay-related indicators  

### 2. Parsing and Transformation
- JSON responses parsed using Python  
- Converted into Pandas DataFrames  
- Data quality operations performed:
  - Handling missing and null values  
  - Normalizing and trimming string fields  
  - Correcting data types  
  - Removing duplicates  
  - Standardizing orbital parameters  

### 3. Storage Design
**Stage Tables**
- Store raw, as-is ingested data  
- Support traceability and reprocessing  

**Target Tables**
- Store cleaned, transformed, analytics-ready data  
- Serve as the single source of truth  

### 4. Data Integration and Automation
- Initial full load executed manually  
- Incremental updates automated using:
  - Weekly Azure Function triggers  
  - Python-based transformation scripts  
- Upsert strategy used to efficiently handle:
  - New satellite objects  
  - Updates to existing orbital parameters  

This design minimizes manual effort while ensuring data freshness.

## Analytics and Visualization
- Tableau used for exploratory and diagnostic analysis  
- Analysis includes:
  - Growth trends of space objects over time  
  - Orbital density across altitude bands  
  - Ownership-based distribution analysis  
  - Mean anomaly and orbital distance behavior  

Insights from visualization informed downstream feature selection for modeling.

## Machine Learning Pipeline

### Feature Engineering
Key features used for modeling:
- Altitude  
- Inclination  
- Eccentricity  
- Mean anomaly  

These features capture orbital stability, atmospheric drag exposure, and collision likelihood.

### Models Implemented

#### Logistic Regression
- Baseline, interpretable model  
- Produces probability-based decay risk scores  
- Useful for explainability and stakeholder communication  

#### Random Forest
- Ensemble-based model  
- Captures non-linear relationships  
- Higher predictive performance  
- Provides feature importance rankings  

### Model Comparison
- Logistic Regression prioritized for interpretability  
- Random Forest prioritized for accuracy and robustness  
- Both models consistently identify altitude, eccentricity, and inclination as dominant predictors of decay risk  

## Key Technical Findings
- Low Earth Orbit ranges (~200–600 km) show the highest decay and collision risk  
- Eccentric orbits experience increased atmospheric drag at perigee  
- Certain inclination ranges lead to greater orbital instability  
- Multi-feature modeling significantly outperforms single-parameter analysis  

## Tech Stack
- **Programming Language:** Python  
- **Data Processing:** Pandas  
- **Database:** Azure SQL  
- **Cloud & Orchestration:** Azure Functions  
- **Visualization:** Tableau  
- **Data Access:** REST APIs  
