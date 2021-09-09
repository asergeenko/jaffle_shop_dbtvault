WITH util_days AS (
    {{ dbt_utils.date_spine(
        datepart="hour",
        start_date="date_trunc('day', now()) - interval '1 day'",
        end_date="date_trunc('day', now()) + interval '1 day'"
    )
    }}
)

select date_hour as AS_OF_DATE from util_days
