

SELECT*
FROM PortfolioProject..CovidDeaths$
WHERE location IS NOT NULL
ORDER BY 3, 4



--SELECT*
--FROM PortfolioProject..CovidVaccinations$
--ORDER BY 3, 4 


--Selecting data to be used in this project

SELECT location, date,total_cases, new_cases,total_deaths,population
FROM PortfolioProject..CovidDeaths$
WHERE continent IS NOT NULL
ORDER BY 1, 2 

--Looking at Total Cases vs Total Deaths
SELECT location,date,population, total_cases,(total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
WHERE location LIKE '%State%'
AND continent IS NOT NULL
ORDER BY 1, 2 


--Looking at countries with Highsest Infenction Rate Vis Avis population
SELECT location,population, MAX(total_cases) as HighestInfectionCount,  MAX((total_cases/population))*100 as 
PercentagePopulationInfected
FROM PortfolioProject..CovidDeaths$
--WHERE location LIKE '%State%'
WHERE continent IS NOT NULL
GROUP BY location,population 
ORDER BY PercentagePopulationInfected DESC


--Showing Countries with Highest Death Per Population
SELECT location,MAX(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths$
--WHERE location LIKE '%State%'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC



-- BREAKING THINGS DOWN BY CONTINENT
SELECT continent,MAX(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths$
--WHERE location LIKE '%State%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC


-- GLOBAL NUMBERS
SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths as INT))/SUM(new_cases)*100 AS Deathpercentagescount
FROM PortfolioProject..CovidDeaths$
WHERE continent IS NOT NULL
-- GROUP BY date
ORDER BY 1,2



-- Looking at people who have been vaccinated vs Total Popolution

SELECT Dea.continent,Dea.location, Dea.date, Dea.population,Vac.new_vaccinations
,SUM(CONVERT(INT,Vac.new_vaccinations)) OVER (PARTITION BY Dea.location ORDER BY Dea.location,
Dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ Dea
JOIN PortfolioProject..CovidVaccinations$ Vac
ON Dea.location=Vac.location
AND Dea.date=Vac.date
WHERE Dea.continent  IS NOT NULL
ORDER BY 2,3

-- Using CTE to see the % of total number of people vaccinated per location

WITH popvac (continent,location,date,population,new_vaccinations, rollingpeoplevaccinated)
AS
(
SELECT Dea.continent,Dea.location, Dea.date, Dea.population,Vac.new_vaccinations
,SUM(CONVERT(INT,Vac.new_vaccinations)) OVER (PARTITION BY Dea.location ORDER BY Dea.location,
Dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ Dea
JOIN PortfolioProject..CovidVaccinations$ Vac
ON Dea.location=Vac.location
AND Dea.date=Vac.date
WHERE Dea.continent  IS NOT NULL
--ORDER BY 2,3
)
SELECT*, (RollingPeopleVaccinated/population)*100 AS TotPercentagePPleVac
FROM popvac


--Repeating the Same with Temps Table

DROP TABLE IF EXISTS #percentpopulationvaccinated
CREATE TABLE #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
INSERT INTO #percentpopulationvaccinated
SELECT Dea.continent,Dea.location, Dea.date, Dea.population,Vac.new_vaccinations
,SUM(CONVERT(INT,Vac.new_vaccinations)) OVER (PARTITION BY Dea.location ORDER BY Dea.location,
Dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ Dea
JOIN PortfolioProject..CovidVaccinations$ Vac
ON Dea.location=Vac.location
AND Dea.date=Vac.date
WHERE Dea.continent  IS NOT NULL
--ORDER BY 2,3

SELECT*, (RollingPeopleVaccinated/population)*100 AS TotPercentagePPleVac
FROM #percentpopulationvaccinated


--Creating view for visualisation

CREATE VIEW percentpopulationvaccinated AS
SELECT
    Dea.continent,
    Dea.location,
    Dea.date,
    Dea.population,
    Vac.new_vaccinations,
    -- Calculate the rolling sum of new vaccinations for each location
    SUM(CONVERT(INT, Vac.new_vaccinations)) OVER (PARTITION BY Dea.location ORDER BY Dea.location, Dea.date) AS RollingPeopleVaccinated
FROM
    PortfolioProject..CovidDeaths$ Dea
JOIN
    PortfolioProject..CovidVaccinations$ Vac
    ON Dea.location = Vac.location
    AND Dea.date = Vac.date
WHERE
    Dea.continent IS NOT NULL;
