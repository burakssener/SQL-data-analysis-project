SELECT * 
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null -- Because when rows continent data is null, the data spread regional rather than location and there is misleading data for regions
ORDER BY 3,4

SELECT * 
FROM PortfolioProject..CovidVaccinations$
WHERE continent is not null
ORDER BY 3,4


-- Getting data

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
ORDER BY 1,2

-- Total Cases Vs Deaths

-- Looking specific countries total deaths and death percentage according to case number
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
WHERE location LIKE '%states%'
ORDER BY Cast((total_deaths)AS int) DESC

-- Total Cases vs Population
-- what percentage of population got covid
SELECT Location, date, population,  total_cases,  (total_cases/population)*100 as Covid_Percentage, Percent_Population_Infected
FROM PortfolioProject..CovidDeaths$
WHERE location LIKE '%states%'
ORDER BY Cast((total_deaths)AS int) DESC
-- there is a strong correlation between covid_percentage and total_deaths

-- Countries Highest infection rate compared to population
SELECT Location, population,  MAX(total_cases) AS highestInfectionCount, MAX((total_cases/population)*100) as Percent_Population_Infected
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
GROUP BY Location, Population
ORDER BY 4 DESC

-- Looking Specific Countries for Highest infection rate compared to population and highestinfection count
SELECT Location, population,  MAX(total_cases) AS highestInfectionCount, MAX((total_cases/population)*100) as Percent_Population_Infected
FROM PortfolioProject..CovidDeaths$
WHERE location LIKE 'Turkey'
GROUP BY Location, Population
ORDER BY 4 DESC

-- Showing Countries with Highest death count per Population
SELECT Location, population,  MAX(CAST((total_deaths) AS int)) AS totaldeathcounted, MAX((total_deaths/population)*100) as Percent_Population_Death
FROM PortfolioProject..CovidDeaths$
--WHERE location LIKE 'United Kingdom'
WHERE continent is not null 
GROUP BY Location, Population
ORDER BY 3 DESC

--BREAKING THINGS DOWN BY CONTINENT



--SELECT location,  MAX(CAST((total_deaths) AS int)) AS totaldeathcounted, MAX((total_deaths/population)*100) as Percent_Population_Death
--FROM PortfolioProject..CovidDeaths$
--WHERE continent is null 
--GROUP BY location
--ORDER BY 3 DESC

-- Highest death count per populations with continents

SELECT continent,  MAX(CAST((total_deaths) AS int)) AS totaldeathcounted, MAX((total_deaths/population)*100) as Percent_Population_Death
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null 
GROUP BY continent
ORDER BY 3 DESC

-- GLOBAL NUMBERS
-- Overall stats by world

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths , SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
--GROUP BY date
ORDER BY 1 DESC

-- Overall stats by days
SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths , SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
GROUP BY date
ORDER BY 1 DESC

-- Looking Total Population vs Vaccination
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.Date)
AS rolling_people_vaccinated
FROM PortfolioProject..CovidDeaths$ AS dea 
INNER JOIN PortfolioProject..CovidVaccinations$ AS vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3



-- USE CTE

With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated) AS 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.Date)
AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ AS dea 
INNER JOIN PortfolioProject..CovidVaccinations$ AS vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is not null
)
--ORDER BY 2,3)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac

--MAXA BAKICAKTIM bak

With PopvsVac (Continent, Location,  new_vaccinations, RollingPeopleVaccinated) AS 
(
SELECT dea.continent, dea.location, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.Date)
AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ AS dea 
INNER JOIN PortfolioProject..CovidVaccinations$ AS vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is not null
)
--ORDER BY 2,3)
SELECT *, MAX(RollingPeopleVaccinated)
FROM PopvsVac






-- TEMP TABLE

DROP TABLE IF EXISTS #PercentPopulationVaccinated

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric, --here is a issue if I delete this new_vaccinations from both insert part and here the code will work
RollingPeopleVaccinated numeric,
)
Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.Date)
AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ AS dea 
INNER JOIN PortfolioProject..CovidVaccinations$ AS vac
ON dea.location = vac.location AND dea.date = vac.date
--WHERE dea.continent is not null
--ORDER BY 2,3)
SELECT *, (RollingPeopleVaccinated/Population)*100  AS percentage_vaccinated
FROM VIEW

--CREATING #PercentPopulationVaccinated TO STORE DATA FOR LATER VISUALIZATONS

CREATE VIEW PercentPopulationVaccinatedview AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.Date)
AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ AS dea 
INNER JOIN PortfolioProject..CovidVaccinations$ AS ON
vac dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is not null

Select *
FROM PercentPopulationVaccinatedview