--select top 5 * from CovidDeaths
--order by 3,4

--select top 5 * from CovidVaccinations
--order by 3,4

-- Select the data the we are going to use

--SELECT  location, date,total_cases,new_cases, total_deaths, population 
--FROM CovidDeaths
--WHERE location LIKE '%states%' AND (total_cases IS NOT NULL)
--order BY 1,2


-- ====    Total cases vs Total Deaths ========

--1) find the percentage deaths for people who were infected.
 -- This will show the likelihood of someone dying of COVID by location.

--SELECT  location, date,total_cases, total_deaths, 
--        round((total_deaths/total_cases)* 100,2) as death_percentage
--FROM CovidDeaths
--WHERE location LIKE '%states%' AND (total_cases IS NOT NULL)
--order BY 1,2



-- ====  Total cases vs Population   ========
-- 1) shows what percentage of population has contracted COVID
 
-- SELECT  location, date,population,total_cases,
--        round((total_cases/population)* 100,4) as percent_per_population
--FROM CovidDeaths
--WHERE location LIKE '%states%' AND (total_cases IS NOT NULL)
--order BY 1,2


-- ===========  Looking at Countries Infection Rate compared to Population ==============

-- SELECT  location,population,MAX(total_cases) as higest_infection_count,
--        Max(round((total_cases/population)* 100,4)) as percent_per_population
--FROM CovidDeaths
--WHERE total_cases IS NOT NULL
--Group by location,population 
----Having population >= 1000000
--order BY percent_per_population Desc



-- ========== Looking at Countries Death Count per Population =================

-- SELECT  location,population,MAX(cast(total_deaths as int)) as total_death_count,
--        Max(round((total_deaths/population)* 100,4)) as percent_per_population
--FROM CovidDeaths
--WHERE total_cases IS NOT NULL
--      AND
--	  continent IS NOT NULL
--Group by location,population 
----Having population >= 1000000
--order BY total_death_count desc


-- *** United States had the highest tottal of deatrh due to COVID 
 --  *** (ranked 16th when comparing percent of population)


--  ========= Looking at Countries Death Count per infection ==============

-- SELECT  location,population,total_cases, MAX(cast(total_deaths as int)) as total_death_count,
--        Max(round((total_deaths/total_cases)* 100,4)) as percent_death_per_case
--FROM CovidDeaths
--WHERE total_cases IS NOT NULL
--      AND
--	  total_deaths IS NOT NULL
--Group by location,population,total_cases,total_deaths
----Having population >= 1000000
--order BY percent_death_per_case desc



-- ==========  Looking at breakdown by death count by Continent instaed of location ==================

-- SELECT  continent,MAX(cast(total_deaths as int)) as total_death_count
--FROM CovidDeaths
--WHERE total_cases IS NOT NULL
--      AND
--	  continent IS not Null
--Group by continent
----Having population >= 1000000
--Order BY total_death_count desc

--******************************************************************************************
--   =================This gives the right total numbers ==============================
--                   1) changed continent to Location
--                   2) and changed Where statment of continent not null to null

-- SELECT  location,MAX(cast(total_deaths as int)) as total_death_count
--FROM CovidDeaths
--WHERE total_cases IS NOT NULL
--      AND
--	  continent IS null
--Group by location
----Having population >= 1000000
--Order BY total_death_count desc
--******************************************************************************************


-- ==========  Global Numbers ================
--1) Lookint at Death percentages per number of cases Globally

--SELECT date, SUM(cast (new_cases as int)) sum_new_cases,SUM(cast(new_deaths as int)) sum_new_deaths,
--             SUM(cast(new_deaths as int))/SUM(cast(new_cases as int))
        
--FROM CovidDeaths
----WHERE  location LIKE '%states%'
--WHERE continent is not null 
--Group BY date
--Order BY date 

--SELECT date, Sum(new_cases) as ntotal_new_cases,Sum(cast(new_deaths as int)) as total_new_deaths,
--     Round( Sum(cast(new_deaths as int)) / SUM(new_cases)* 100,4) As DeathPercentages
--From CovidDeaths
--WHERE continent is not null
--Group BY date
--ORDER BY 1,2

-- If want to get total cases and death overall just take out the date in SELECT statement 
-- and Group by

--SELECT Sum(new_cases) as ntotal_new_cases,Sum(cast(new_deaths as int)) as total_new_deaths,
--     Round( Sum(cast(new_deaths as int)) / SUM(new_cases)* 100,4) As DeathPercentages
--From CovidDeaths
--WHERE continent is not null
----Group BY date
--ORDER BY 1,2

--==================================================================================================
--                                 CovidVaccine Table (Join to CovidDeaths Table)
--==================================================================================================

--SELECT top 2 * From CovidDeaths
--SELECT top 2 * From CovidVaccinations

-- We want to join them on 2 variable loaction and date bc they
-- are mached more consistantly  on both tables

--SELECT * 
--FROM CovidDeaths as death
--Join CovidVaccinations as vac
--ON death.location = vac.location
--AND death.date = vac.date


-- =========   Want to look at Total Popuation vs how many are vaccinated  ==================

--SELECT death.continent, death.location,death.date,death.population, vac.new_vaccinations
--FROM CovidDeaths as death
--Join CovidVaccinations as vac
--ON death.location = vac.location
--AND death.date = vac.date
--WHERE death.population is not null 
--AND death.continent is not null
--Order BY 2,3 

--===========================================================================================


SELECT death.continent, death.location,death.date,death.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER(Partition BY death.location        --(+)  
order by death.location, death.date) as Rolling_People_Vaccintion              -- can use CONVERT(data type, variable) instaed of cast( as)      
FROM CovidDeaths as death                                                 
Join CovidVaccinations as vac
ON death.location = vac.location
AND death.date = vac.date
WHERE death.population is not null 
AND death.continent is not null
Order BY 2,3 

-- Notes
--(+) OVER(Partition BY death.location) is used to find totals for each location not total for all locations  
--We used added the ORDER BY caluse:       
--      OVER(Partition BY death.location order by death.location,death.date)
-- instaed of : 
--      OVER(Partition BY death.location) 
--     b/c we want to see a rolling sum of each location not just the total sum of each location)


-- ========= USEing  CTE  to be able to use new column ==============
-- Make sure the nimber of colums in CTE mach the number in your SELECT staement
--  MAke sure you have a Select Query and the end sletion from new CTE


