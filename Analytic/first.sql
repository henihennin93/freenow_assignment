-- with this one i checked which day of week we have more orders and how many of them is orphan 
--also we check accpetance rate dure each day of week

with total_order as(
SELECT
    TO_CHAR(daily_date, 'Day') AS weekday,
    sum(total_offers) as total_orders
FROM curated.drivers_activity
group by 1
order by total_orders desc),


total_ordphan_orders as(
SELECT
    TO_CHAR(daily_date, 'Day') AS weekday,
    sum(total_offers) as total_orders
FROM curated.drivers_activity
where orphan_driver is true
group by 1
order by total_orders desc),


accepted_ration as(

SELECT
TO_CHAR(daily_date, 'Day') AS weekday,
round(sum(accepted_offers)/sum(total_offers)::numeric,2) as acceptance_rate
from curated.drivers_activity
group by 1

)

select  tor.*,
        toph.total_orders as total_orders_orphans_driver,
        ar.acceptance_rate
from total_order tor
join total_ordphan_orders toph on toph.weekday=tor.weekday
join accepted_ration ar on ar.weekday=tor.weekday
order by tor.total_orders desc


