
-- 1)  Weekdays and weekend payments statistics 
select 
case 
when weekday(a.order_purchase_timestamp)=5 or
weekday(a.order_purchase_timestamp)=6  then "Weekend"
else "Weekday"
end as Day_Status,  
concat('$   ', round(sum(b.payment_value))) as Payment_Statistics,
concat(round(sum(b.payment_value) / (select sum(payment_value) from olist_order_payments_dataset) * 100, 2), '%') as Percentage_of_Total
from olist_orders_dataset a join olist_order_payments_dataset b on a.order_id=b.order_id
group by Day_Status;


-- 2) Number of Orders with review score 5 and payment type as credit card.
select count(r.order_id) as Order_Count
from review_dataset as r
join olist_order_payments_dataset as p on r.order_id = p.order_id
where r.review_score = 5 and p.payment_type = 'Credit_Card';

-- 3)Average number of days taken for order_delivered_customer_date for pet_shop.
select product.product_category_name,
round(avg(datediff(ord.order_delivered_customer_date,ord.order_purchase_timestamp)),0) as AVG_DELIVERY_DATE
from olist_orders_dataset as ord join 
(select product_id,order_id,product_category_name from olist_products_dataset join olist_order_items_dataset using (product_id)) as product
on ord.order_id = product.order_id where product.product_category_name = "pet_shop" 
group by product.product_category_name;

-- 4)Average price and payment values from customers of sao paulo city.

 ----- (Avg price value)
  select cust.customer_city, 
round(avg(pmt_price.price),0) as AVG_PRICE from olist_customers_dataset as cust
join (select pymnt.customer_id,pymnt.payment_value,item.price from olist_order_items_dataset as item 
join(select ord.order_id,ord.customer_id,pmt.payment_value from olist_orders_dataset as ord 
join olist_order_payments_dataset as pmt on ord.order_id = pmt.order_id) as pymnt
on item.order_id = pymnt.order_id) as pmt_price on cust.customer_id = pmt_price.customer_id where cust.customer_city = "sao paulo";


 ----- (Avg payment value)
select cust.customer_city, 
round(avg(pmt.payment_value),0) as AVG_PAYMENT_VALUE 
 from olist_customers_dataset as cust
 inner join olist_orders_dataset as ord 
 on cust.customer_id = ord.customer_id inner join olist_order_payments_dataset as pmt on ord.order_id = pmt.order_id 
 where customer_city= "sao paulo";
 
 -- 5. Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.
select r.Review_Score, 
	   round(avg(datediff(order_delivered_customer_date, order_purchase_timestamp))) as Avg_Shipping_Days 
from olist_orders_dataset as o 
join review_dataset as r 
on o.order_id = r.order_id 
group by review_score order by review_score desc;

