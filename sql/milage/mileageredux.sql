create database mileage;
use mileage;

create table fillups 
(
	id int not null primary key auto_increment, 
	date_time datetime, 
	volume dec(7, 3), 
	vehicle_id int, 
	odometer int, 
	mpg dec(7, 2), 
	total_cost dec(7, 2), 
	price_per_gal dec(7, 3), 
	is_partial int, 
	`restart` int
);

SET time_zone = 'America/New_York';
select from_unixtime(1392164473694 / 1000);
load data local
infile 'mileage.csv'
into table fillups
fields terminated by ','
ignore 1 lines
(id, @date_time, volume, vehicle_id, odometer, mpg, total_cost, price_per_gal, is_partial, restart)
set date_time=from_unixtime(@date_time / 1000);


alter table fillups
drop column restart;


update fillups
set is_partial = 0
where id = 45;


select min(price_per_gal) as lowest, avg(price_per_gal) as average , max(price_per_gal) as highest 
from fillups;


select vehicle_id, sum(total_cost) as 'total amount spend on gas'
from fillups
group by vehicle_id;


select vehicle_id, round(avg(mpg), 0) as 'average fuel economy'
from fillups
where id not in (45, 1, 54)
group by vehicle_id;


select vehicle_id, round(avg(mpg), 0) as 'average fuel economy',
case
when vehicle_id = 2 then 'Prius' 
when vehicle_id = 4 then 'Other'
end as 'Prius or Other'
from fillups
where id not in (45, 1, 54)
group by vehicle_id;


select hour(date_time) as hour, count(hour(date_time)) as num_times
from fillups
group by hour(date_time);


select DATE_FORMAT(date_time, '%a') as day, count(DATE_FORMAT(date_time, '%a')) as num_fillups
from fillups
group by DATE_FORMAT(date_time, '%a')
order by num_fillups desc;


select left(DATE_FORMAT(date_time, '%M'), 3) as 'month', DATE_FORMAT(date_time, '%Y') as year, vehicle_id, count(left(DATE_FORMAT(date_time, '%M'), 3)) as nbr_fillups, round(sum(volume), 0) as total_gallons
from fillups
group by left(DATE_FORMAT(date_time, '%M'), 3), DATE_FORMAT(date_time, '%Y'), vehicle_id
order by total_gallons desc;


