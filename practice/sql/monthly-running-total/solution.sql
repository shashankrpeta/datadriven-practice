with cte as
(select product_id,total_amount,to_char(transaction_date,'yyyy-mm') as year_mon 
from transactions)
select product_id,year_mon as month,sum(total_amount) as monthly_total,
sum(total_amount) over(partition by product_id order by year_mon) as cumulative_total
from cte
where product_id is not null
group by product_id,year_mon
order by product_id;
