# freenow_assignment

## Project Overview

This project transforms raw CSV data into a curated analytics data product designed to measure and monitor driver engagement and performance.

The pipeline follows two main stages:

Raw Data Preparation (Curated Layer)

Driver Activity Data Product (Aggregated Mart)

The final output is a driver-level daily fact table covering the period 01.06.2021–14.06.2021, designed for analytical consumption.

# 1. Raw Data Preparation (Curated Layer)

To ensure a clean and maintainable data pipeline, I implemented a layered schema architecture:

raw → stores original imported CSV data

curated → stores cleaned, standardized, analytics-ready tables

This separation ensures:

Clear data lineage

Reproducibility

Safe reprocessing of raw data

Controlled transformations

Production-ready modeling

3.1 Drivers Table Transformation
Duplicate Removal

Duplicates were detected using:

row_number() over (partition by id)


Only one record per driver ID was retained to enforce uniqueness.

Country Standardization

Country values appeared in multiple inconsistent formats:

France, FR, fr, FRANCE

Austria, AT, Österreich

These were normalized and unified into:

france

austria

All values were converted to lowercase to prevent duplicate groupings.

Null Cleaning

Several columns contained the string 'null' instead of actual SQL NULL.

These were converted using:

nullif(column, 'null')


This ensures proper aggregation and filtering.

Numeric Standardization

rating → cast to numeric, rounded to 2 decimals

rating_count → cast to integer

This prevents calculation errors and ensures consistency.

Registration Date Standardization

Two formats were identified:

Standard timestamp/date format

10-digit epoch seconds (e.g., 1584554068)

Logic applied:

If length = 10 → convert using to_timestamp()

Otherwise → cast to date

All values were standardized to DATE.

Boolean Normalization

receive_marketing was converted from string to BOOLEAN.

This allows clean segmentation and correct filtering.

3.2 Bookings Table Transformation
Duplicate Removal

Ensured one unique row per booking ID using row ranking logic.

Date Standardization

request_date was cast to DATE.

Null Handling

id_driver contained 'null' strings which were converted to SQL NULL.

Fare Cleaning

estimated_route_fare:

Converted from text to numeric

Rounded to 2 decimals

Cleaned from string 'null'

This ensures accurate revenue aggregation.

3.3 Offers Table Transformation
Duplicate Removal

One record per offer ID retained.

Date Standardization

datecreated converted to DATE format.

Null Cleaning

Converted 'null' strings to actual SQL NULL.

Route Distance Validation

Some route_distance values were negative.

Since distance cannot be negative:

CASE
  WHEN route_distance < 0 THEN NULL
  ELSE route_distance
END


This prevents distortion in average distance calculations.

Boolean Normalization

driverread converted from string to BOOLEAN.

Column Naming Standardization

All columns were renamed and formatted to:

Lowercase

Snake_case

Consistent naming conventions

This improves readability and maintainability.

4. Integrity & Optimization

In the curated schema:

Primary keys were enforced

Indexes created on join columns (driver_id, booking_id)

Data types strictly defined

Duplicate IDs eliminated

This ensures:

Referential integrity

Efficient joins

Faster aggregations

Reliable analytical outputs

Final Architecture Summary

The pipeline follows a structured ELT pattern:

Load raw CSVs into raw

Clean & standardize into curated

Build aggregated analytical mart (drivers_activity)

Perform engagement analysis

This layered design mirrors production analytics engineering standards and ensures scalability, transparency, and reliability.