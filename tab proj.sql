use jun3;

select * from used_cars_train_data;
select count(*) from used_cars_train_data;
rename table used_cars_train_data to uct;


select * from uct;
select count(*) from uct;
show tables;

select count(*) from used_cars_train_data;


rename table used_cars_train_data to uc1;


select * from uc1;

# remove units from table
update uc1  set engine = replace(Engine,' CC','');
update uc1  set Power = replace(Power,' bhp','');
update uc1  set Mileage = replace(Mileage,' km/kg','');
update uc1  set Mileage = replace(Mileage,' kmpl','');

update uc1  set Power = replace(Power,'null',0);







select * from uc1;


describe uc1;


## change data type

alter  table uc1 modify Mileage float;

alter  table uc1 modify Engine int;


alter  table uc1 modify power float;




drop table uc1;
drop table used_cars_test_data;

##
select * from uc1;


describe uc1;

#  1> find avg of kms,engine,mileage,power,seats,price

select round(avg(Engine),2) as avg_engine ,round(avg(Mileage),2) as avg_mileage, round(avg(Power),2) as avg_power,
round(avg(seats),2) as avg_seats, round(avg(Kilometers_driven),2) as avg_km
from uc1;

# 2>  find year wise avg price per location rank them;
select*, dense_rank()over(partition by year order by avg_price desc) as ranks from
(select Year,Location,round(avg(price),2) avg_price
from uc1 
where year>2009
group by Year,Location
order by year)dt;


## dynamic by year
## stored procedure or user defined functions

delimiter //
create procedure year_wise_rank_sp(in year_param int)
begin

select*, dense_rank()over(partition by year order by avg_price desc) as ranks from
(select Year,Location,round(avg(price),2) avg_price
from uc1 
where year=year_param
group by Year,Location
order by year)dt;

end //
delimiter   ;


call year_wise_rank_sp(2012);



## assume any target avg price
 -- find location wise avg price,avg price target,percentage to target
 # use target avg price and locations as arguments from sp
 
 # target= 25
 # percentage to target
 select *,round((avg_price_target/avg_price)*100,2) as percent_to_target  from
 (select *,25-avg_price as avg_price_target from
 (select Location,round(avg(price),2) avg_price
 from uc1
 group by Location)dt)dt1;
 
 

delimiter //
create procedure target(in target_param int,in Loc varchar(50))
begin

 select *,round((avg_price_target/avg_price)*100,2) as percent_to_target  from
 (select *,target_param-avg_price as avg_price_target from
 (select Location,round(avg(price),2) avg_price
 from uc1
 where Location=Loc
 group by Location)dt)dt1;


end //
delimiter  ;
  
  
call target(20)

delimiter //
create procedure target1(in target_param int,in Loc varchar(50))
begin

 select *,round((avg_price_target/avg_price)*100,2) as percent_to_target  from
 (select *,target_param-avg_price as avg_price_target from
 (select Location,round(avg(price),2) avg_price
 from uc1
 where Location=Loc
 group by Location)dt)dt1;


end //
delimiter  ;



call target1(25,'Delhi');

select * from uc1 ;


##  2 find dimenson count for each dimensionality dynamically
select location,Owner_Type,count(location)
from uc1
group by location;



