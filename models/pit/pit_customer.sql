{{
    config(
        enabled=True
    )
}}

{%- set source_model = "hub_customer" -%}
{%- set src_pk = "customer_pk" -%}
{%- set src_ldts = "load_date" -%}
{%- set satellites = { "sat_customer_details": {"pk":{"pk": src_pk }, "ldts":{"ldts":src_ldts}},"sat_customer_crm": {"pk":{"pk": src_pk }, "ldts":{"ldts":src_ldts}}} -%}
{%- set stage_tables = ["v_stg_customers","v_stg_customers_crm"] -%}
{%- set as_of_dates_table = "as_of_date" -%}

WITH p AS (
{{ dbtvault.pit(source_model=source_model, src_pk=src_pk,
                as_of_dates_table=as_of_dates_table,
                satellites=satellites,
                stage_tables=stage_tables,
                src_ldts=src_ldts) }}
)

select as_of_date,sat_customer_details_ldts,first_name,last_name,email,country,age from p,
{{ ref('sat_customer_details') }},{{ ref('sat_customer_crm') }}
where p.customer_pk = {{ ref('sat_customer_details') }}.customer_pk
and p.customer_pk = {{ ref('sat_customer_crm') }}.customer_pk
and p.sat_customer_details_ldts = {{ ref('sat_customer_details') }}.load_date
and as_of_date >= '2021-09-09 18:00:00' and as_of_date <= '2021-09-09 21:00:00'