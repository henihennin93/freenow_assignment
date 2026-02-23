 create table curated.freenow_bookings as
 with raw_data as (
 select id,
        row_number() over (partition by id order by request_date) as rank,
        trim(request_date)::date as request_date,
        status::text, nullif(id_driver,'null') as driver_id,
        round(nullif(estimated_route_fare,'null')::numeric,2) as estimated_route_fare
 from raw_data.freenow_bookings)
select id,
       request_date,
       status,
       driver_id,
       estimated_route_fare
from raw_data
where rank = 1;



alter table curated.freenow_bookings add constraint freenow_bookings_pk primary key (id);

create index freenow_bookings_request_date_idx on curated.freenow_bookings (id);