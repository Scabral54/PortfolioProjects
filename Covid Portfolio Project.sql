--Covid data from Janurary 22nd, 2020 to April 30th, 2021

SELECT *
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 3,4


--SELECT *
--FROM PortfolioProject.dbo.CovidVaccinations
--ORDER BY 3,4

--Select Data that we are going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 1,2


--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country
 SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE location like '%states'
ORDER BY 1,2


--Looking at Total Cases vs Population
--Shows what percentage of population that contracted Covid

SELECT Location, date, Population, total_cases, (total_cases/population)*100 AS ContractedCovid
FROM PortfolioProject.dbo.CovidDeaths
WHERE location like '%states'
ORDER BY 1,2

-- Looking at countries with highest infection rate compared to population

SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS ContractedCovid
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location like '%states'
GROUP BY location, population
ORDER BY ContractedCovid DESC


--Showing Countries with the Highest Death Count per Population

SELECT Location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC


--LET'S BREAK THINGS DOWN BY CONTINENT


--Showing Continents with the highest death count

SELECT location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC


-- GLOBAL NUMBERS

SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS int)) AS total_deaths, SUM(cast(new_deaths AS int))/SUM(New_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2


--Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, 
dea.date) AS RollingVaccinationCount
, (RollingVaccinationCount/population)*100
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null	
ORDER BY 2, 3



--USE CTE

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingVaccinationCount)
AS 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, 
dea.date) AS RollingVaccinationCount
--, (RollingVaccinationCount/population)*100
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null	
--ORDER BY 2, 3
)
SELECT *, (RollingVaccinationCount/population)*100 AS PercentagePopulationVaccinated
FROM PopvsVac


-- TEMP TABLE

DROP TABLE IF exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingVaccinationCount numeric,
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, 
dea.date) AS RollingVaccinationCount
--, (RollingVaccinationCount/population)*100
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent is not null	
--ORDER BY 2, 3

SELECT *, (RollingVaccinationCount/population)*100 AS PercentagePopulationVaccinated
FROM #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, 
dea.date) AS RollingVaccinationCount
--, (RollingVaccinationCount/population)*100
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null	
--ORDER BY 2, 3



SELECT * 
FROM PercentPopulationVaccinated

