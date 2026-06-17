# Hands-on: AWS Core Services (S3, Glue, CloudWatch, Athena)

**ITCS 6190/8190 — Summer 2026**
**Dataset:** [E-Commerce Sales Data](https://www.kaggle.com/datasets/thedevastator/unlock-profits-with-e-commerce-sales-data) — `Amazon Sale Report.csv`

## Pipeline

`S3 (raw-data/) → Glue Crawler → Data Catalog (raw_data) → Athena → S3 (processed-data/)`

- **S3:** bucket `itcs6190-data-sweldebe` (us-east-2) with `raw-data/` (source CSV) and `processed-data/` (Athena output).
- **IAM:** role `Glue-Crawler-Role-sweldebe` with `AWSGlueServiceRole` + `AmazonS3ReadOnlyAccess`.
- **Glue:** crawler `itcs6190-crawler-sweldebe` → database `itcs6190_db_sweldebe`, table `raw_data` (24 columns).
- **CloudWatch:** crawler run monitored via `/aws-glue/crawlers`.
- **Athena:** ran the 5 queries; results saved to `processed-data/`.

## Queries

The 5 queries are in [`queries.sql`](queries.sql); results in [`results/`](results/).

1. Basic table exploration (first 10 records)
2. Orders by product category
3. Revenue & quantity by fulfilment method
4. Monthly sales trend
5. Top 5 SKUs per category

## Contents

```
README.md
queries.sql
results/        (5 CSVs)
screenshots/    (s3_buckets.png, iam_role.png, cloudwatch.png)
```
