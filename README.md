# World Smartphone Market 2025

## About
This project aims to explore the World Smartphone Market 2025 dataset containing over 1000 smartphone models from leading brands (Apple, Samsung, Xiaomi, Oppo, Vivo, Google, OnePlus, Realme, Infinix). The goal is to analyze pricing trends, compare specifications, identify value-for-money devices, track brand performance, and understand consumer perception in the 2025 global smartphone market.

"A comprehensive dataset of 1000+ smartphone models with price, specs, battery, camera, display, performance, and realistic ratings for the year 2025. Perfect for price prediction, market analysis, brand comparison, and machine learning projects."

## Purposes Of The Project
The major aim of this project is to gain deep insights into the 2025 global smartphone landscape to understand pricing strategies, feature-to-price relationships, brand positioning, flagship vs budget trends, and consumer rating patterns across segments.

## About Data
The dataset contains detailed specifications and pricing for smartphones released/sold in 2025. All prices are in USD. Ratings are realistic simulated averages (3.5–5.0 scale). Data is 100% complete with no missing values.

- **Brands Included:** Apple, Samsung, Xiaomi, Oppo, Vivo, Google, OnePlus, Realme, Infinix (9 brands total)  
- **Total Models:** 2,000+ (cleaned to ~1,800 after deduplication)  
- **Key Features:** Brand, Model, Price (USD), RAM (GB), Storage (GB), Camera (MP), Battery (mAh), Display Size (inch), Charging (Watt), 5G Support, OS, Processor, Rating, Release Month, Year  
- **Technologies Used:** MySQL for data storage, cleaning, and advanced analysis; Looker Studio for interactive dashboards and visualizations.

_Add a screenshot of the Looker Studio dashboard here:_  
**Smartphone Market 2025 Dashboard**  
**Live Dashboard:** Link to Looker Studio report

## Analysis List
- **Price & Segment Analysis:** Identify price distribution across budget, mid-range, premium, and flagship segments.  
- **Brand Performance Analysis:** Compare average pricing, ratings, specs, and value-for-money across top brands.  
- **Feature-to-Price Correlation:** Analyze how RAM, camera, battery, processor, and display impact final retail price.  
- **Rating & Consumer Perception:** Study relationship between specs, price, and user ratings.

## Approach Used

### Data Wrangling
- Created working copies: `worldsmartphonetable1 → worldsmartphonetable2 → worldsmartphonetable3`  
- Standardized all text and numeric fields using `TRIM(TRAILING '.' FROM ...)`  
- Confirmed zero null or empty values  
- Identified and removed exact duplicates using `ROW_NUMBER()` partitioning  
- Final clean table: `worldsmartphonetable3`

### Build a Database

```sql
CREATE DATABASE IF NOT EXISTS world_smartphone_market_2025;
USE world_smartphone_market_2025;

CREATE TABLE worldsmartphonetable3 (
    brand TEXT,
    model TEXT,
    price_usd INT,
    ram_gb INT,
    storage_gb INT,
    camera_mp INT,
    battery_mah INT,
    display_size_inch DOUBLE,
    charging_watt INT,
    5g_support TEXT,
    os TEXT,
    processor TEXT,
    rating DOUBLE,
    release_month TEXT,
    year INT
);
````

### Feature Engineering

This will help us generate some new columns from existing ones.

* **price_segment**: (Budget, Mid-range, Premium, Flagship) based on price in USD
* **value_score**: rating ÷ price (higher = better value-for-money)
* **camera_total_mp**: summed megapixels of the rear camera system
* **performance_tier**: (Entry, Mid, High, Flagship) extracted from processor name
* **battery_efficiency**: battery capacity (mAh) per USD spent
* **screen_to_body_estimate**: estimated screen-to-body ratio based on display size and 2025 trends

*All feature engineering steps are implemented in `sql/feature_engineering.sql` and applied to `worldsmartphonetable3`.*

## Exploratory Data Analysis (EDA)

All queries in `sql/eda_queries.sql`. Key insights visualized in Looker Studio.

## Conclusion

* Realme leads in average customer rating (4.31)
* Xiaomi offers the most models under $400 (54 models)
* Oppo dominates the flagship segment (> $1000) with 94 models
* Premium segment ($800–$1200) has the highest average rating (4.26)
* Fast charging (65W+) phones have slightly higher ratings (4.24 vs 4.22)
* Apple achieves perfect 5.0 ratings on multiple models
* Best value-for-money: Xiaomi Mi 14 462 (value_score = 0.0457)

## Business Questions & Answers

### Generic Questions

* How many unique brands? → 9
* Most models by brand? → Xiaomi (228), Vivo (244)
* Price range in 2025? → $101 – $1,499

### Price & Segment

* Most expensive phone? → Oppo V30 125 ($1,499)
* Best value-for-money? → Xiaomi Mi 14 462 (0.0457 rating per dollar)
* Highest rated segment? → Premium ($800–$1200) at 4.26 avg rating

### Brand Analysis

* Highest average rating? → Realme (4.31)
* Most budget models (<$400)? → Xiaomi (54)
* Flagship leader (> $1000)? → Oppo (94 models)
* Best camera? → Apple (200 MP total)

### Feature Impact

* Fast charging (65W+)? → Yes, slightly higher avg rating (4.24 vs 4.22)

### Rating & 5.0 Phones (2025)

* Oppo F27 Pro 537
* Apple iPhone 14 358 / iPhone 16 Pro 711
* Samsung Galaxy S24 Ultra 700
* Realme C65 744

### Calculations

```sql
-- Value Score
rating / price_usd

-- Battery Efficiency
battery_mah / price_usd
```

## Code

All cleaning, feature engineering, and analysis queries are in `SQL_queries.sql`
Final cleaned + enriched table: `worldsmartphonetable3`

## Installation & Setup

1. Clone the repo
2. Run `sql/setup.sql` to create database and tables
3. Import original CSV into `worldsmartphonetable1`
4. Run full cleaning + feature engineering script
5. Connect to Looker Studio → build interactive dashboards

## Contributing

Fork → improve queries, add ML price prediction model, enhance dashboards → open PR

## Maintained by

@Sirmequtter

## License

MIT License

*Last updated: November 21, 2025*
By @Sirmequtter │ Kenya

```

This preserves your content exactly, structured cleanly for GitHub Markdown.
```
