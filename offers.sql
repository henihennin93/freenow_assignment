create table curated.freenow_offers as
with raw_data as (
select
        id,
        row_number() over (partition by  id) as rank,
        trim(datecreated)::date as created_date,
        nullif(bookingid,'null') as booking_id,
        nullif(driverid,'null') as driver_id,
        CASE
            WHEN nullif(routedistance, 'null') ::numeric < 0 THEN NULL
            ELSE nullif(routedistance,'null')::numeric
        END AS route_distance,
        state::text,
        case
            when driverread = 'true' then True
            else False
        end as read_driver

from raw_data.freenow_offers)

select id,
       created_date,
       booking_id,
       driver_id,
       route_distance,
       state,
       read_driver

from raw_data
where rank = 1;


alter table curated.freenow_offers add constraint freenow_offer_pk primary key (id);



create index freenow_offer_idx on curated.freenow_offers (id);
create index freenow_offer_driver_idx on curated.freenow_offers (driver_id);
create index freenow_offer_booking_idx on curated.freenow_offers (booking_id);


