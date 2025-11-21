```sql
create table  worldsmartphonetable2 like worldsmartphonetable1;
insert worldsmartphonetable2
select * from worldsmartphonetable1;
-- preveiw and basic counts
select count(*) as row_s from worldsmartphonetable2;
# standardization
select
brand, trim(trailing '.' from brand) ,
model, trim(trailing '.' from model),
price_usd, trim(trailing '.' from price_usd),
ram_gb, trim(trailing '.' from ram_gb),
storage_gb, trim(trailing '.' from storage_gb),
camera_mp, trim(trailing '.' from camera_mp),
battery_mah, trim(trailing '.' from battery_mah),
display_size_inch, trim(trailing '.' from display_size_inch),
charging_watt, trim(trailing '.' from charging_watt),
5g_support, trim(trailing '.' from 5g_support),
os, trim(trailing '.' from os),
processor, trim(trailing '.' from processor),
rating, trim(trailing '.' from rating),
release_month, trim(trailing '.' from release_month),
year, trim(trailing '.' from year)
from worldsmartphonetable2;
update worldsmartphonetable2
set brand = trim(trailing '.' from brand),
	model =  trim(trailing '.' from model),
	price_usd = trim(trailing '.' from price_usd),
    ram_gb = trim(trailing '.' from ram_gb),
    storage_gb = trim(trailing '.' from storage_gb),
    camera_mp = trim(trailing '.' from camera_mp),
    battery_mah = trim(trailing '.' from battery_mah),
    display_size_inch = trim(trailing '.' from display_size_inch),
    charging_watt = trim(trailing '.' from charging_watt),
    5g_support = trim(trailing '.' from 5g_support),
    os = trim(trailing '.' from os),
    processor = trim(trailing '.' from processor),
    rating = trim(trailing '.' from rating),
    release_month = trim(trailing '.' from release_month),
    year = trim(trailing '.' from year);
    -- null values
    select * from worldsmartphonetable2
    where brand is null or brand = null or brand = ' '
    or
	model is null or model = null or model = ' '
    or
	price_usd is null or price_usd = null or price_usd = ' '
    or
	ram_gb is null or ram_gb = null or ram_gb = ' '
    or
	storage_gb is null or storage_gb = null or storage_gb = ' '
    or
	camera_mp is null or camera_mp = null or camera_mp = ' '
    or
	battery_mah is null or battery_mah = null or battery_mah = ' '
    or
	display_size_inch is null or display_size_inch = null or display_size_inch = ' '
    or
	charging_watt is null or charging_watt = null or charging_watt = ' '
    or
	5g_support is null or 5g_support = null or 5g_support = ' '
    or
	os is null or os = null or os = ' '
    or
	processor is null or processor = null or processor = ' '
    or
	rating is null or rating = null or rating = ' '
    or
    release_month is null or release_month = null or release_month = ' '
    or
	year is null or year = null or year = ' ';
    # no null values are present on the dataset
    -- ------------------------------------------------- --
    # duplicates
    select *,
    row_number() over(partition by brand, model, price_usd, ram_gb, storage_gb, camera_mp, battery_mah, display_size_inch, charging_watt, 
    5g_support, os, processor, rating, release_month, year) as row_num from worldsmartphonetable2;
    
    select * from worldsmartphonetable2 where model like 'iPhone 14 154%' and storage_gb like '128%' ;
    # There are duplicates in the data set
    
    with duplicates as(select *,
    row_number() over(partition by brand, model, price_usd, ram_gb, storage_gb, camera_mp, battery_mah, display_size_inch, charging_watt, 
    5g_support, os, processor, rating, release_month, year) as row_num from worldsmartphonetable2 ) select * from duplicates where row_num > 1;
    
    CREATE TABLE `worldsmartphonetable3` (
  `brand` text,
  `model` text,
  `price_usd` int DEFAULT NULL,
  `ram_gb` int DEFAULT NULL,
  `storage_gb` int DEFAULT NULL,
  `camera_mp` int DEFAULT NULL,
  `battery_mah` int DEFAULT NULL,
  `display_size_inch` double DEFAULT NULL,
  `charging_watt` int DEFAULT NULL,
  `5g_support` text,
  `os` text,
  `processor` text,
  `rating` double DEFAULT NULL,
  `release_month` text,
  `year` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into worldsmartphonetable3 
select *,
    row_number() over(partition by brand, model, price_usd, ram_gb, storage_gb, camera_mp, battery_mah, display_size_inch, charging_watt, 
    5g_support, os, processor, rating, release_month, year) as row_num from worldsmartphonetable2;

delete from worldsmartphonetable3 where row_num > 1;
-- removing columns
alter table worldsmartphonetable3
drop column row_num;
# Feature Engineering
# Add a new column named price_segment (Budget, Mid-Range, Premium, Flagship) based on price in USD
select price_usd,
case 
when price_usd < 400 then 'Budget'
when price_usd >= 400 and price_usd < 800 then 'Mid-range'
when price_usd >= 800 and price_usd < 1200 then 'Premium'
when price_usd > 1200 then 'Flagship'
else 'Unknown'
end as price_segment
from worldsmartphonetable3;

alter table worldsmartphonetable3
add column price_segment varchar(20);
update worldsmartphonetable3
set price_segment = case 
when price_usd < 400 then 'Budget'
when price_usd >= 400 and price_usd < 800 then 'Mid-range'
when price_usd >= 800 and price_usd < 1200 then 'Premium'
when price_usd > 1200 then 'Flagship'
else 'Unknown'
end;

# Add a new column named value_score that contains the calculated rating divided by price (higher = better value-for-money)
alter table worldsmartphonetable3
add column value_score decimal(10,4);
update worldsmartphonetable3
set value_score = rating / price_usd;

# Add a new column named camera_total_mp that contains the summed megapixels of the rear camera system
alter table worldsmartphonetable3
add column  camera_total_mp int;
update worldsmartphonetable3
set camera_total_mp = camera_mp;

# Add a new column named performance_tier (Entry, Mid, High, Flagship) extracted from processor name
select processor,
case
    when processor like '%Helio G99%' then 'Entry'
    when processor like '%Snapdragon 6 Gen 1%' then 'Mid'
    when processor like '%Tensor G4%' then 'High'
    when processor like '%Snapdragon 7+ Gen 2%' then 'High'
    when processor like '%Snapdragon 8 Gen 3%' then 'Flagship'
    when processor like '%Dimensity 9300%' then 'Flagship'
    when processor like '%Exynos 2400%' then 'Flagship'
    when processor like '%A18 Pro%' then 'Flagship'
    else 'Unknown'
end as performance_tier
from worldsmartphonetable3;
alter table worldsmartphonetable3
add column performance_tier varchar(20);
update worldsmartphonetable3
set performance_tier =  case
    when processor like '%Helio G99%' then 'Entry'
    when processor like '%Snapdragon 6 Gen 1%' then 'Mid'
    when processor like '%Tensor G4%' then 'High'
    when processor like '%Snapdragon 7+ Gen 2%' then 'High'
    when processor like '%Snapdragon 8 Gen 3%' then 'Flagship'
    when processor like '%Dimensity 9300%' then 'Flagship'
    when processor like '%Exynos 2400%' then 'Flagship'
    when processor like '%A18 Pro%' then 'Flagship'
    else 'Unknown'
end;

# Add a new column named battery_efficiency that contains battery capacity (mAh) per USD spent
alter table  worldsmartphonetable3
add column battery_efficiency decimal(10,4);
update worldsmartphonetable3
set  battery_efficiency = battery_mah / price_usd;
# Add a new column named screen_to_body_estimate that contains an estimated screen-to-body ratio based on display size and 2025 trends
select display_size_inch,
case 
when display_size_inch >= 7.0 then 92.00
when display_size_inch >= 6.5 then 89.00
when display_size_inch >= 6.0 then 87.00
when display_size_inch >= 5.6 then 85.00
else 82.00
end as  screen_to_body_estimate
from worldsmartphonetable3;
alter table worldsmartphonetable3
add column screen_to_body_estimate decimal(5, 2);
update worldsmartphonetable3
set screen_to_body_estimate = case 
when display_size_inch >= 7.0 then 92.00
when display_size_inch >= 6.5 then 89.00
when display_size_inch >= 6.0 then 87.00
when display_size_inch >= 5.6 then 85.00
else 82.00
end ;

# exploratory Data Analysis
# Generic Questions
# How many unique brands are in the dataset?  
select count(distinct brand) from worldsmartphonetable3;
# Answer:  
# count(distinct brand)
# 9

# How many models per brand?  
select count(model) as total_models, brand from worldsmartphonetable3 group by brand;
# Answer: 
# total_models, brand
# 214, Apple
# 232, Google
# 210, Infinix
# 232, OnePlus
# 220, Oppo
#210, Realme
# 210, Samsung
# 244, Vivo
# 228, Xiaomi

# What is the price range in 2025?
select min(price_usd), max(price_usd) from worldsmartphonetable3 where year = 2025;
# Answer: 
# min(price_usd), max(price_usd)
# 101, 1499

# Price & Segment
# What is the most expensive smartphone in 2025?  
select model, price_usd from worldsmartphonetable3 order by price_usd desc limit 1;
# Answer: 
# model, price_usd
# V30 125, 1499

# What is the best value-for-money device (highest rating per dollar)?  
select model, value_score from worldsmartphonetable3 order by value_score desc limit 1; 
# answer:
# model, value_score
# Mi 14 462, 0.0457

# Which price segment has the highest average rating?  
select price_segment, avg(rating) as average_rating from worldsmartphonetable3 group by price_segment order by average_rating desc limit 1;
# Answer: 
# price_segment, average_rating
# Premium, 4.260553633217993

# Average price by brand?
select brand, avg(price_usd) from worldsmartphonetable3 group by brand;
# Answer:
# brand, avg(price_usd)
# Apple, 835.6916
# Google, 808.0603
# Infinix, 839.1714
# OnePlus, 812.2500
# Oppo, 826.3273
# Realme, 771.7810
# Samsung, 791.7238
# Vivo, 807.9016
# Xiaomi, 827.7368

# Brand Analysis
# Which brand has the highest average rating?  
select brand, avg(rating) from worldsmartphonetable3 group by brand order by avg(rating) desc limit 1;
# Answer: 
# brand, avg(rating)
# Realme, 4.312380952380951

# Which brand offers the most models under $400?  
select brand, count(model) from  worldsmartphonetable3  where price_usd < 400 group by brand order by count(model) desc limit 1;
# answer:
# brand, count(model)
# Xiaomi, 54

# Who dominates the flagship segment (>$1000)?  
select brand, count(*) from worldsmartphonetable3 where price_usd > 1000 group by brand order by count(*) desc limit 1;
# Answer:
# brand, count(*)
# Oppo, 94

# Best camera phones by brand?
select brand, camera_total_mp from worldsmartphonetable3 order by camera_total_mp desc limit 1;
# Answer: 
# brand, camera_total_mp
# Apple, 200

# Feature Impact
# How much does +2GB RAM increase price on average?  
select 
    avg(case when ram_gb >= 2 then price_usd end) 
      - avg(case when ram_gb < 2 then price_usd end) as avg_price_increase_2GB
from worldsmartphonetable3 ;
# Answer: 
# no increase on avg_price_increase_2GB

# Does fast charging (65W+) affect rating?  
select 
    case 
        when charging_watt >= 65 then 'Fast Charging (65W+)' 
        else 'Standard Charging (<65W)' 
    end as  charging_type,
    avg(rating) as avg_rating
from worldsmartphonetable3
group by  charging_type;
# Answer: 
# charging_type, avg_rating
# Fast Charging (65W+), 4.238401559454194
# Standard Charging (<65W), 4.2209445585215635
# phones with fast charging (65W+) have a slightly higher average rating (4.24) compared to standard charging phones (4.22).

# Best gaming phones (processor + storage_gb + display)
select 
    brand,
    model,
    processor,
    storage_gb,
    display_size_inch,
    (processor*0.5 + storage_gb*0.2 + display_size_inch*0.3) as gaming_score
from worldsmartphonetable3
order by  gaming_score desc limit 10;
# Answer:
# brand, model, processor, storage_gb, display_size_inch, gaming_score
# Oppo, Reno 11 414, Snapdragon 6 Gen 1, 1024, 7.2, 206.96
# OnePlus, OnePlus 13 728, Snapdragon 7+ Gen 2, 1024, 7.2, 206.96
# OnePlus, OnePlus 13 728, Snapdragon 7+ Gen 2, 1024, 7.2, 206.96
# Apple, iPhone 15 620, Snapdragon 8 Gen 3, 1024, 7.2, 206.96
# Samsung, Galaxy M55 821, Exynos 2400, 1024, 7.2, 206.96
# Vivo, V29e 883, Tensor G4, 1024, 7.2, 206.96
# Oppo, Reno 11 414, Snapdragon 6 Gen 1, 1024, 7.2, 206.96
# Apple, iPhone 15 620, Snapdragon 8 Gen 3, 1024, 7.2, 206.96
# Samsung, Galaxy M55 821, Exynos 2400, 1024, 7.2, 206.96
# Vivo, V29e 883, Tensor G4, 1024, 7.2, 206.96

# Rating & Perception
# Most highly rated smartphone of 2025?  
select brand,rating from worldsmartphonetable3 order by rating desc limit 1;
# Answer: 
# brand, rating
# Apple, 5

# Do expensive phones always get higher ratings?
select brand,model,rating from worldsmartphonetable3 where price_segment like 'Premium%' or 
price_segment like 'Flagship%' order by rating desc limit 5;
# Answer: 
# brand, model, rating
# Oppo, F27 Pro 537, 5
# Apple, iPhone 14 358, 5
# Apple, iPhone 16 Pro 711, 5
# Samsung, Galaxy S24 Ultra 700, 5
# Realme, C65 744, 5
```
