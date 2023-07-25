--SELECT *
--FROM coviddeaths
--ORDER BY 3,4

--SELECT *
--FROM covidvaccination
--ORDER BY 3,4

--SELECT Location, date, total_cases, new_cases, total_deaths, population
--FROM coviddeaths
--ORDER BY 1,2

SELECT
    Location,
    date,
	population,
    total_cases,
    (CONVERT(float, total_cases) / CONVERT(float, population)) * 100 AS DeathPercentage
FROM coviddeaths
WHERE Location LIKE '%Nigeria%'
ORDER BY Location, date;

SELECT *
FROM coviddeaths
WHERE continent is not null
ORDER BY 3,4

SELECT
    Location,
    date,
	population,
    total_cases,
    (CONVERT(float, total_cases) / CONVERT(float, population)) * 100 AS PercentOfPopulationAffected
FROM coviddeaths
--WHERE Location LIKE '%Nigeria%'
WHERE continent is not null
ORDER BY Location, date;


SELECT
    Location,
    date,
    MAX(population) as population,
    MAX(total_cases) as HighestInfectionCount,
    (MAX(CONVERT(float, total_cases)) / MAX(CONVERT(float, population))) * 100 AS PercentOfPopulationAffected
FROM coviddeaths
WHERE continent is not null
GROUP BY Location, date
ORDER BY PercentOfPopulationAffected desc;


SELECT
    Location,
	MAX(cast(total_deaths as int)) as TotalDeathCount
FROM coviddeaths
WHERE continent is not null
--THIS IS THE RIGHT WAY
--WHERE continent is null
GROUP BY Location
ORDER BY TotalDeathCount desc;


SELECT
    continent,
	MAX(cast(total_deaths as int)) as TotalDeathCount
FROM coviddeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc;


SELECT
    date,
    SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths,
    SUM(CONVERT(float, new_deaths)) / NULLIF(SUM(CONVERT(float, new_cases)), 0) * 100 AS DeathPercentage
FROM
    coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY
    date
ORDER BY
    date;

SELECT
    --date,
    SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths,
    SUM(CONVERT(float, new_deaths)) / NULLIF(SUM(CONVERT(float, new_cases)), 0) * 100 AS DeathPercentage
FROM coviddeaths
WHERE continent IS NOT NULL
--GROUP BY
--    date
ORDER BY 1,2;

--SELECT *
--FROM coviddeaths dea
--join  covidvaccination vac
--	on dea.location = vac.location
--	and dea.date = vac.date

SELECT 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations,
	SUM(CONVERT(FLOAT,vac.new_vaccinations)) OVER (partition by dea.location ORDER BY dea.location, dea.date) 
	as RollingPeopleVaccinated
	--(RollingPeopleVaccinated/population)*100 
FROM coviddeaths dea
join  covidvaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3

--USE CTE

with PopvsVac (continent, location, date, population,new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations,
	SUM(CONVERT(FLOAT,vac.new_vaccinations)) OVER (partition by dea.location ORDER BY dea.location, dea.date) 
	as RollingPeopleVaccinated
	--(RollingPeopleVaccinated/population)*100 
FROM coviddeaths dea
join  covidvaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac

DROP  TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
SELECT 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations,
	SUM(CONVERT(FLOAT,vac.new_vaccinations)) OVER (partition by dea.location ORDER BY dea.location, dea.date) 
	as RollingPeopleVaccinated
	--(RollingPeopleVaccinated/population)*100 
FROM coviddeaths dea
join  covidvaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2, 3

SELECT *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated



CREATE VIEW PercentPopulationVaccinated as
SELECT 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations,
	SUM(CONVERT(FLOAT,vac.new_vaccinations)) OVER (partition by dea.location ORDER BY dea.location, dea.date) 
	as RollingPeopleVaccinated
	--(RollingPeopleVaccinated/population)*100 
FROM coviddeaths dea
join  covidvaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3


SELECT *
FROM PercentPopulationVaccinated