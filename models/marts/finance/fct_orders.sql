with orders as
( 
 select * from {{ ref('stg_jaffle_shop__orders') }}
),

payments as
(
    select
    orderid,
    sum (case when status = 'success' then amount end) as amount
    from {{ ref('stg_stripe__payments') }}
    group by 1
),

final as
(
    select
    orders.order_id,
    orders.customer_id,
    orders.order_date,
    coalesce(SUM(payments.amount), 0) as amount

    from orders
    left join payments on orders.order_id = payments.orderid
    group by 1,2,3
    order by 1
)

select * from final

