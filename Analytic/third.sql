---- checking how much marketing has effect select receive_marketing,
       avg(total_offers) as avg_offers,
       avg(accepted_offers/total_offers) as avg_acceptance_rate
from curated.drivers_activity
group by receive_marketing ;



---checking how much distance has effect tp acceptance


select
    case
    when avg_route_distance<1000 then 'short_distqance'
    when avg_route_distance between 1000 and 3000 then 'medium_distance'
    else 'long_distance'
    end  as distance,
    sum(accepted_offers)/sum(total_offers) as avg_acceptance_rate
from curated.drivers_activity
group by 1;



--- checking new drivers activity 
select
    case
        when (daily_date - date_registration::date) <= 7
            then 'first_7_days_since_registration'
        else 'after_7_days'
        end as tenure_phase,

    count(DISTINCT driver_id) AS drivers_count,
    avg(total_offers) AS avg_daily_offers,
    avg(accepted_offers::numeric / NULLIF(total_offers,0)) AS avg_acceptance_rate

from curated.drivers_activity
group by 1;
