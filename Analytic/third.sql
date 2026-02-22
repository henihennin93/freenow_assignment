-- in here we will see since driver joins freenow the number of order they accept is mrore in first week or second week 

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
