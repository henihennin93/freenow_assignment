CREATE TABLE curated.freenow_drivers AS
with main_query as(
select
id,
row_number() over (partition by  id) as rank,
case when country in ('FRANCE','FR','France') then 'france'
     when country in ('Austria','AT','AUSTRIA','Österreich') then 'austria'
end as country,
round(nullif(lower(trim(rating,'null')),'')::numeric ,2) as rating,
nullif(lower(trim(rating_count,'null')),'')::int  as rating_count,
case when length(date_registration) = 10 then to_timestamp(trim(date_registration)::bigint)::date
    else  trim(date_registration)::date
end as date_registration,
case
    when receive_marketing = 'true' then True
    else False
end as receive_marketing

from raw_data.freenow_drivers)
select id,
       country,
       rating,
       rating_count,
       date_registration,
       receive_marketing
from main_query
where rank = 1;


alter table curated.freenow_drivers add constraint freenow_drivers_pk primary key (id);

create index freenow_drivers_idx on curated.freenow_drivers (id);

