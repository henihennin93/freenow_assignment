--each day we see how much was the succesullful booking 

select
    sum(accepted_offers)::numeric
        / nullif(sum(read_by_drive_offers),0) as read_accept_rate,
       case when  sum(accepted_offers)/sum(total_offers) as avg_acceptance_rate
from curated.drivers_activity;