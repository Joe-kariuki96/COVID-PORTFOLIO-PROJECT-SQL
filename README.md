# Report on the Code: COVID-19 Data Analysis

## 1. Initial Data Retrieval:

The code begins by selecting all columns from a table named CovidDeaths$ in the database PortfolioProject, filtering out records where the location is not null, and ordering the results by the third and fourth columns.
## 2. Data Selection for Project:

A subset of columns (location, date, total_cases, new_cases, total_deaths, population) is selected from the same CovidDeaths$ table, filtering records where the continent is not null, and ordering the results by location and date.
## 3. Total Cases vs Total Deaths Analysis:

Another query investigates the relationship between total cases and total deaths, focusing on locations containing the term 'State' in their name.
## 4. Highest Infection Rate by Population:

This query identifies countries with the highest infection rate per population by calculating the percentage of the population infected.
## 5. Countries with Highest Death Per Population:

It identifies countries with the highest death count per population.
## 6. Continent-wise Death Counts:

The code breaks down death counts by continent, listing the total death count for each continent.
## 7. Global COVID-19 Numbers:

This query provides global COVID-19 statistics, including total cases, total deaths, and the percentage of deaths relative to total cases.
## 8. Vaccination Analysis:

The code investigates the relationship between COVID-19 deaths and vaccinations. It includes a rolling sum of new vaccinations for each location.
## 9. Percentage of People Vaccinated:

Two approaches are used to calculate the percentage of people vaccinated: one with a Common Table Expression (CTE) and another with a temporary table (#percentpopulationvaccinated).
## 10. View Creation for Visualization:
- A view named percentpopulationvaccinated is created to facilitate visualization. It includes continent, location, date, population, new_vaccinations, and a rolling sum of vaccinations for each location.
