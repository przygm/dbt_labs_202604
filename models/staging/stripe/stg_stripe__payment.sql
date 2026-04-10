/*with 

source as (

    select * from {{ source('stripe', 'payment') }} 

),

renamed as (

    select
        id as payment_id,
        orderid as order_id,
        paymentmethod as payment_method,
        status as payment_status,
        amount as payment_amount,
        created as payment_created,
        _batched_at

    from source

)

select * from renamed
*/
select
    id as payment_id,
    orderid as order_id,
    paymentmethod as payment_method,
    status as payment_status,
    -- amount is stored in cents, convert it to dollars
    amount / 100 as payment_amount,
    created as payment_created
from {{ source('stripe', 'payment') }}