--each day we see how much was the succesullful booking 

SELECT
    daily_date,
    round(SUM(success_booking) / SUM(accepted_offers) ::numeric,2)AS successfull_bookings_rate
FROM curated.drivers_activity
GROUP BY daily_date
ORDER BY daily_date ;



--------does marketing effect on successfull bookings rate
select receive_marketing,
       avg(total_offers) as avg_offers,
       avg(accepted_offers/total_offers) as avg_acceptance_rate
from curated.drivers_activity
group by receive_marketing ;