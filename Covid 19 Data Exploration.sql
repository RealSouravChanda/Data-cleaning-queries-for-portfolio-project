	/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/
	
	
	use portfolioproject ;
	--looking at the Data

	
	select * from [dbo].[covidVaccination$]
	order by 3,4

	select * from [dbo].[covidDeaths$]
	where continent is not null
	order by 3,4;

	select location, date, total_cases,new_cases,total_deaths,population 
	from [dbo].[covidDeaths$]
	order by 1,2

	--looking at total cases vs total deaths
	--shows likelyhood of dying if you contract covid in India
	
	select location, date, total_cases,new_cases,total_deaths,(total_deaths/total_cases)* 100 as 'Death_percentage' 
	from [dbo].[covidDeaths$]
	where location like '%india'
	order by 1,2



	----looking at total cases vs total population
	--shows what percentage of population got covid  in India

		select location, date,total_cases,population, (total_cases/population)* 100 as 'percentage Of Population Infected' 
	from [dbo].[covidDeaths$]
	where location like '%india%'
	order by 1,2

--looking at countries with highest infection rate compared to population 

select location,population,max(total_cases) as 'highestInfectionCount', max((total_cases/population))* 100 as 'percentageOfPopulationInfected' 
	from [dbo].[covidDeaths$]
	group by location,population
	order by 4 desc

	--showing the countries highest dethcount per population 



select location, max(cast (total_deaths as int )) as totalDeathcount 
	from [dbo].[covidDeaths$]
	where continent is not null
	group by location
	order by 2 desc	 

	--LET`S BREAKE THINGS DOWN BY CONTINENT
	
	
select continent , max(cast (total_deaths as int )) as totalDeathcount 
	from [dbo].[covidDeaths$]
	where continent is not  null
	group by continent   
	order by 2 desc	 

	--showing the continent with highest death count per population  

		
select continent , max(cast (total_deaths as int )) as totalDeathcount 
	from [dbo].[covidDeaths$]
	where continent is not  null
	group by continent   
	order by 2 desc	 

	--global numbers

	select   sum(new_cases) as TotalCases,sum(cast(new_deaths as int)) as TotalDeaths, sum(cast(new_deaths as int)) /

	sum(new_cases) *100   as deathPercentage 
	--total_deaths,(total_deaths/total_cases)* 100 as 'Death_percentage' 
	from [dbo].[covidDeaths$]
	--where location like '%india'
	where continent is not null
	--group by date 
	order by 1,2


	--looking at total population vs vaccination

	select dea.continent, dea.location , dea.date, dea.population, vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as bigint)) over(partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccninated
	from portfolioproject..covidDeaths$  dea
	join portfolioproject..covidVaccination$ vac
	on  dea.location = vac.location
	and  dea.date = vac.date
	where dea.continent is not null 
	order by 2,3;


	with popVSvec
	as
	(

		select dea.continent, dea.location , dea.date, dea.population, vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as bigint)) over(partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccninated
	from portfolioproject..covidDeaths$  dea
	join portfolioproject..covidVaccination$ vac
	on  dea.location = vac.location
	and  dea.date = vac.date
	where dea.continent is not null 
	)
	select *,(RollingPeopleVaccninated/population)*100
	from popVSvec



	--temptable

	drop table if exists  #percentpopulationvaccinated
	create table #percentpopulationvaccinated
	(
	continent nvarchar(255),
	lacation nvarchar(255),
	date datetime,
	population numeric,
	new_vaccination  numeric,
	RollingPeopleVaccninated  numeric)

	insert into  #percentpopulationvaccinated

	
	select dea.continent, dea.location , dea.date, dea.population, vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as bigint)) over(partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccninated
	from portfolioproject..covidDeaths$  dea
	join portfolioproject..covidVaccination$ vac
	on  dea.location = vac.location
	and  dea.date = vac.date
	--where dea.continent is not null
	

select *,(RollingPeopleVaccninated/population)*100
	from  #percentpopulationvaccinated


	--creating view to store data for later visualization

	create view percentpopulationvaccinated
	as

	
	select dea.continent, dea.location , dea.date, dea.population, vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as bigint)) over(partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccninated
	from portfolioproject..covidDeaths$  dea
	join portfolioproject..covidVaccination$ vac
	on  dea.location = vac.location
	and  dea.date = vac.date
	--where dea.continent is not null
	--order by 2,3

	select * from percentpopulationvaccinated

	--thankyou--
	
	








