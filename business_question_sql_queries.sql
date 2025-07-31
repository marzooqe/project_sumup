select 
	STORE_NAME,
	SUM(AMOUNT) as TOTAL_AMOUNT
from sumup."REPORTING".transaction_performance tp 
group by STORE_NAME 
order by TOTAL_AMOUNT desc 
limit 10;

select 
	PRODUCT_SKU,
	COUNT(*) as TOTAL_QUANTITY, 
	SUM(AMOUNT) as TOTAL_AMOUNT
from sumup."REPORTING".transaction_performance tp 
group by PRODUCT_SKU 
order by TOTAL_QUANTITY desc, TOTAL_AMOUNT desc 
limit 10;

select 
	country,
	typology,
	ROUND(SUM(AMOUNT)/count(distinct id),2) as AVG_TRANSACTED_AMOUNT 
from sumup."REPORTING".transaction_performance tp 
group by 
	COUNTRY,
	TYPOLOGY
order by 
	country,
	AVG_TRANSACTED_AMOUNT desc;

select 
	DEVICE_type,
	ROUND(COUNT(distinct id)*100.00/(select count(distinct id) from sumup."REPORTING".transaction_performance),2)||'%' as PCT_TRANSACTIONS
from sumup."REPORTING".transaction_performance tp 
group by DEVICE_type 
order by PCT_TRANSACTIONS desc 
;

with base_data as 
(
select 
	tp.store_id ,
	STORE_NAME,
	tp.created_at ,
	lead(created_at) over (partition by store_id order by created_at) as next_order_date,
	rank() over (partition by store_id order by created_at) as rank
from sumup."REPORTING".transaction_performance tp
order by rank
)
select 
	store_id,
	store_name,
    AVG(next_order_date - created_at) as avg_time_to_first_five_order
from base_data
where rank <= 5
group by
	store_id,
	store_name
order by
	avg_time_to_first_five_order
;