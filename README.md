# 🧬 SQL COVID-19 Data Exploration

This project contains a collection of SQL queries used to explore COVID-19 data, including global trends in infections, deaths, and vaccinations. The analysis was conducted in **Microsoft SQL Server** using two tables:

- `CovidDeaths$`
- `CovidVaccinations$`

---

## 📌 Objectives

- Analyze total COVID-19 cases and deaths
- Calculate death rates per country
- Identify countries with the highest infection and death counts
- Track vaccination progress over time
- Use CTEs, temp tables, and views for modular analysis

---

## 🛠️ Key SQL Features Used

- **Window Functions** – e.g., `SUM() OVER (PARTITION BY ...)`
- **CTEs** – to simplify complex queries
- **Temporary Tables** – to store intermediate results
- **Joins** – combining death and vaccination data
- **Aggregation** – `SUM`, `MAX`, `CAST`, `GROUP BY`

---

## 📂 Data Assumptions

- Data is stored in a SQL Server database named:  
  `Covid-19_DataExploration`
- Tables used:
  - `CovidDeaths$`
  - `CovidVaccinations$`

> 💡 You’ll need to load the appropriate CSVs or SQL tables into your own SQL Server instance to execute these queries.

---

## 🧪 Example Analyses

- Death percentage:  
  ```sql
  SELECT location, date, total_cases, total_deaths, 
         (total_deaths / total_cases) * 100 AS Death_Percentage
  FROM CovidDeaths$
  WHERE location LIKE '%egypt%'
