SELECT*
FROM [Covid-19_DataExploration]..CovidDeaths$
--where continent is not null
order by 3,4

--SELECT*
--FROM [Covid-19_DataExploration]..CovidVaccinations$
--ORDER BY 3,4

--select data that we are going to use

select location , date , total_cases, new_cases , total_deaths , population
FROM [Covid-19_DataExploration]..CovidDeaths$
where continent is not null
order by 1 , 2

-- LOKKING AT TOTAL_CASES VS TOTAL_DEATHS
-- SHOWS LIKELIHOOD OF DYING IF YOU CONTRACT COVID IN EGYPT FOR (30/APRIL/2021)
select location , date , total_cases, new_cases , total_deaths ,(total_deaths/total_cases)*100 as Death_Percentage
FROM [Covid-19_DataExploration]..CovidDeaths$
where location like '%egypt%'
AND continent is not null
order by 1,2


-- LOOKING AT THE TOTAL_CASES VS POPULATION
-- SHOWS WHAT PERCENTAGE OF POPULATION GOT COVID (30/APRIL/2021)
select location , date ,population, total_cases ,(total_cases/population)*100 as Percent_Population_Infected
FROM [Covid-19_DataExploration]..CovidDeaths$
--where location like '%egypt%'
where continent is not null
order by 1,2


--LOOKING AT COUNTRIES WITH HEIEST INFECTION RATE COMPARED TO POPULATION

select location , population , MAX(total_cases) AS heiest_infection_count, MAX((total_cases/population))*100 as Percent_Population_Infected
FROM [Covid-19_DataExploration]..CovidDeaths$
where continent is not null
group by  location , population
order by Percent_Population_Infected desc

--LOOKING AT THE COUNTRIES WITH HIGHEST DEATHS COUNT PER LOCATION

select location  , MAX(cast(total_deaths as int)) AS heiest_death_count
FROM [Covid-19_DataExploration]..CovidDeaths$
where continent is not null
group by  location
order by heiest_death_count desc


--LOOKING AT THE continents WITH HIGHEST DEATHS COUNT PER POPULATION

select continent , MAX(cast(total_deaths as int)) AS heiest_death_count
FROM [Covid-19_DataExploration]..CovidDeaths$
where continent is not null
group by  continent
order by heiest_death_count desc



Select DEA.continent , DEA.location , DEA.date , population , VAC.new_vaccinations
, SUM(cast(VAC.new_vaccinations as int)) OVER (partition by DEA.location order by DEA.location , DEA.date)
AS Rolling_People_Vaccinations --, (Rolling_People_Vaccinations/population)*100
From [Covid-19_DataExploration]..CovidDeaths$ DEA
join [Covid-19_DataExploration]..CovidVaccinations$ VAC
	on DEA.location = VAC.location
	AND DEA.date = VAC.date
where DEA.continent is not null
--and DEA.location like '%Albania%'
order by 2,3

-- USE CTE

with popvsvac (continent , location , date , population , new_vaccinations , RollingPeapleVaccinations)
as(
Select DEA.continent , DEA.location , DEA.date , population , VAC.new_vaccinations
, SUM(cast(VAC.new_vaccinations as int)) OVER (partition by DEA.location order by DEA.location , DEA.date)
AS Rolling_People_Vaccinations --, (Rolling_People_Vaccinations/population)*100
From [Covid-19_DataExploration]..CovidDeaths$ DEA
join [Covid-19_DataExploration]..CovidVaccinations$ VAC
	on DEA.location = VAC.location
	AND DEA.date = VAC.date
where DEA.continent is not null)
--and DEA.location like '%Albania%'
select * , (RollingPeapleVaccinations/population)*100 AS Rolling_People_Vaccinations_Percentage
from popvsvac


--TEMP TABLE
drop table if exists #percentagepopulationvaccinated
create table #percentagepopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
RollingPeapleVaccinated numeric
)

insert into #percentagepopulationvaccinated
Select DEA.continent , DEA.location , DEA.date , population , VAC.new_vaccinations
, SUM(cast(VAC.new_vaccinations as int)) OVER (partition by DEA.location order by DEA.location , DEA.date)
AS Rolling_People_Vaccinations
From [Covid-19_DataExploration]..CovidDeaths$ DEA
join [Covid-19_DataExploration]..CovidVaccinations$ VAC
	on DEA.location = VAC.location
	AND DEA.date = VAC.date
--where DEA.continent is not null

select* ,(RollingPeapleVaccinated/population)*100 AS Rolling_People_Vaccinations_Percentage
from #percentagepopulationvaccinated



--Creating View to store data later for visualizations
/*
Go
Create View
percentagepopulationvaccinated as
Select DEA.continent , DEA.location , DEA.date , population , VAC.new_vaccinations
, SUM(cast(VAC.new_vaccinations as int)) OVER (partition by DEA.location order by DEA.location , DEA.date)
AS Rolling_People_Vaccinations --, (Rolling_People_Vaccinations/population)*100
From [Covid-19_DataExploration]..CovidDeaths$ DEA
join [Covid-19_DataExploration]..CovidVaccinations$ VAC
	on DEA.location = VAC.location
	AND DEA.date = VAC.date
where DEA.continent is not null
*/


-- 1. 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc












-- Queries I originally had, but excluded some because it created too long of video
-- Here only in case you want to check them out


-- 1.

Select dea.continent, dea.location, dea.date, dea.population
, MAX(vac.total_vaccinations) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Covid-19_DataExploration]..CovidDeaths$ dea
Join [Covid-19_DataExploration]..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
group by dea.continent, dea.location, dea.date, dea.population
order by 1,2,3




-- 2.
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [Covid-19_DataExploration]..CovidDeaths$
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2


-- 3.

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From [Covid-19_DataExploration]..CovidDeaths$
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc



-- 4.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Covid-19_DataExploration]..CovidDeaths$
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc



-- 5.

--Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where continent is not null 
--order by 1,2

-- took the above query and added population
Select Location, date, population, total_cases, total_deaths
From [Covid-19_DataExploration]..CovidDeaths$
--Where location like '%states%'
where continent is not null 
order by 1,2


-- 6. 


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
From PopvsVac


-- 7. 

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Covid-19_DataExploration]..CovidDeaths$
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc

