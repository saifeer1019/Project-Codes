





--All the data that I will be working with
select * from coviddeaths
where continent is not NULL
order by continent, country, date


--total cases vs population how many people are infected out of the 
select (continent, country, total_cases, population) from 






--countries with the highest infection





Select country, continent, population, max(total_cases*100/population) as infection from coviddeaths

where total_cases is not NULL and continent is not NULL
group by country, continent, population
order by infection desc
--h

--highest death count
select country, continent, max(total_deaths) as death_count
from coviddeaths
where continent is not NULL and total_deaths is not NULL
group by continent, country

order by death_count desc




----------total cases vs total deaths, show the probability of death if infected with covid in a certain country

select continent, country, date, population, total_cases, CAST((total_deaths*100/population) as decimal (4,2)) as probability_of_death_country from coviddeaths




create view view_percent_vaxed as(
with percent_vaxed as (
	select covidA.continent, covidA.country, covidA.date, population, covidB.new_vaccinations,
	SUM(covidB.new_vaccinations) over (Partition by covidA.country order by covidA.country, covidA.date) 
	as RollingPopulation_Vaccinated

	from coviddeaths covidA
	left join covidvax covidB

	on covidA.date = covidB.date
	and covidA.country = covidB.country

	where covidA.continent is not NULL 
	order by covidA.country
		)
		
select continent, country, date, (rollingpopulation_vaccinated*100/population) as percent_vaccinated
from percent_vaxed)
















-- temp table	
create view as _view_temp_tabble(
drop table if exists temp_percent_vaxed;
create temporary table temp_percent_vaxed (continent varchar(60), country varchar(60), "date" date, population int, new_vaccinations int, rolling_population_vaccinated int);
insert into temp_percent_vaxed
select covidA.continent, covidA.country, covidA.date, population, covidB.new_vaccinations,
	SUM(covidB.new_vaccinations) over (Partition by covidA.country order by covidA.country, covidA.date) 
	as RollingPopulation_Vaccinated

	from coviddeaths covidA
	left join covidvax covidB

	on covidA.date = covidB.date
	and covidA.country = covidB.country

	where covidA.continent is not NULL 
	order by covidA.country;
	
select * from temp_percent_vaxed)