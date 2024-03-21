SELECT * 
FROM PortofolioProject..CovidDeaths
WHERE continent is not null
order by 3,4

--SELECT * 
--FROM PortofolioProject..CovidVaccinations
--order by 3,4

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortofolioProject..CovidDeaths
order by 1,2

--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract Covid in your country
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortofolioProject..CovidDeaths
WHERE location like '%states%'
order by 1,2

--total cases vs population, what % of the pop had Covid
SELECT Location, date, population, total_cases, (total_cases/population)*100 as DeathStrike
FROM PortofolioProject..CovidDeaths
WHERE location like '%state%'
order by 1,2


--Looking at Countries with Highest Infection Rate per capita

SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopInfected
FROM PortofolioProject..CovidDeaths
--WHERE location like '%state%'
GROUP BY location, population
order by PercentPopInfected desc

--Showing Countries with the Highest Deatch Count per capita

SELECT location, MAX(cast(total_deaths as int)) as TotaltDeathCount
FROM PortofolioProject..CovidDeaths
WHERE continent is not null
GROUP BY location
order by TotaltDeathCount desc

--Breaking things up by continent 
-- Showing the continents with the highest death count
SELECT continent, MAX(cast(total_deaths as int)) as TotaltDeathCount
FROM PortofolioProject..CovidDeaths
WHERE continent is not null
GROUP BY continent
order by TotaltDeathCount desc

--Global Numbers

SELECT  SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(New_deaths as int))/SUM(New_cases)*100 as DeathPercentage
FROM PortofolioProject..CovidDeaths
WHERE continent is not null
--GROUP BY date
order by 1,2

--Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location ORder by dea.location, dea.Date) as RollingPeopleVaccinated
FROM PortofolioProject..CovidDeaths dea
JOIN PortofolioProject..CovidVaccinations vac
     On  dea.location = vac.location
	 and dea.date = vac.date
	 where dea.continent is not null
	 order by 2,3

--- USE CTE

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location ORder by dea.location, dea.Date) as RollingPeopleVaccinated
FROM PortofolioProject..CovidDeaths dea
JOIN PortofolioProject..CovidVaccinations vac
     On  dea.location = vac.location
	 and dea.date = vac.date
	 where dea.continent is not null
	 --order by 2,3
	 )
	SELECT *, (RollingPeopleVaccinated/Population)*100
	FROM PopvsVac

	--TEMP TABLE
	DROP TABLE if exists #PercetPopulationVaccinated
	Create Table #PercetPopulationVaccinated
	(
	Continent nvarchar(255),
	Location nvarchar(255),
	Date datetime,
	Population numeric,
	New_vaccinations numeric,
	RollingPeopleVaccinated numeric
	)
	Insert into #PercetPopulationVaccinated
	SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location ORder by dea.location, dea.Date) as RollingPeopleVaccinated
FROM PortofolioProject..CovidDeaths dea
JOIN PortofolioProject..CovidVaccinations vac
     On  dea.location = vac.location
	 and dea.date = vac.date
	 where dea.continent is not null
	 --order by 2,3
	 SELECT *, (RollingPeopleVaccinated/Population)*100
	FROM #PercetPopulationVaccinated

--Creating View to store data for later visualizations

CREATE View PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location ORder by dea.location, dea.Date) as RollingPeopleVaccinated
FROM PortofolioProject..CovidDeaths dea
JOIN PortofolioProject..CovidVaccinations vac
     On  dea.location = vac.location
	 and dea.date = vac.date
	 where dea.continent is not null
	 --order by 2,3
	 
Create View TotalDeathsPopulation as
SELECT continent, MAX(cast(total_deaths as int)) as TotaltDeathCount
FROM PortofolioProject..CovidDeaths
WHERE continent is not null
GROUP BY continent
--order by TotaltDeathCount desc

