# 📊 SQL Data Analytics Portfolio
📌 Project Overview

In this project, I built a complete data analysis portfolio using SQL Server. I started by exploring the raw tables to understand the data, wrote advanced queries to analyze business performance, and built final reports to summarize customer and product insights.

🛠️ Tools Used: SQL Server (T-SQL), SSMS. 

📂 Project Structure & Code
1. 🔍 Exploratory Data Analysis (EDA)

In this folder, I wrote scripts to understand what information is inside the database:

01_Database_Exploration: Checking all the tables and how they connect.

02_Dimensions_Exploration: Looking at the categories (like customers and products).

03_Date_Range_Exploration: Finding the start and end dates of the sales data.

04_Measures_Exploration: A quick look at the main numbers (Key Metrics).

05_Magnitude_Analysis: Checking the size and totals of the data.

06_Ranking_Analysis: Finding out what the top items are.

2. 📈 Advanced Analytics

In this folder, I used more complex SQL to find business trends:

07_change_over_time_analysis: Seeing how sales grow or drop over the months.

08_cumulative_analysis: Calculating "running totals" as time goes on.

09_performance_analysis: Checking how well different parts of the business are doing.

10_part_to_whole_analysis: Seeing how much one category contributes to the total sales.

11_data_segmentation: Grouping data into useful categories.

3. 🏆 Final Reports

This folder contains the final views I built to summarize the business:

Customer Report: A script that groups customers by age and segments them into "VIP", "Regular", or "New" based on how much they spend and how long they have been buying.

Product Report: A script that categorizes products into "High-Performers", "Mid-Range", or "Low-Performers" based on their total sales. It also calculates the average selling price, total unique customers per product, and average monthly revenue.

🚀 How to Run This Project

Download the Database: Get the DataWarehouseAnalytics.bak file from the repository.

Restore it: Open SQL Server Management Studio (SSMS) and restore the backup file.

Run the Scripts: Open the files in order (starting from 01) to see how I analyzed the data!
