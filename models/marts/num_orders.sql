with sat_order_details as (
    select * from {{ ref('sat_order_details') }}
)

select date_part('year', order_date)::numeric as year,
       date_part('week', order_date)::numeric AS week,
 status, count(*) as num_orders
from sat_order_details
group by year,week, status
order by year,week, status