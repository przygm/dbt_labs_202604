/*{%- set payment_methods = ["bank_transfer", "credit_card", "coupon", "gift_card"] -%}*/
{% set payment_methods_query %}
    select distinct payment_method from {{ ref('stg_stripe__payment') }} order by 1
{% endset %}

{% set results = run_query(payment_methods_query) %}

{% if execute %}
    {% set payment_methods = results.columns[0].values() %}
{% else %}
    {% set payment_methods = [] %}
{% endif %}

with 
    payments as (
        select * from {{ ref("stg_stripe__payment") }}
        ),
    
    final as (
        select
            order_id,
            {% for payment_method in payment_methods -%}
                sum(
                    case
                        when payment_method = '{{ payment_method }}' then payment_amount else 0
                    end
                ) as {{ payment_method }}_amount
                {%- if not loop.last -%}, {% endif -%}
            {%- endfor %}
        from payments
        group by 1
    )
select * from final