with cte as
(
select *,min(log_timestamp) over(partition by server_name,message order by log_timestamp) as earliest_timestamp,row_number() over(partition by server_name,message order by log_timestamp) as rnk
from server_logs
),cte2 as
(
select max(log_timestamp) as newest_entry from server_logs)
select log_id,server_name,log_level,message,response_time_ms,log_timestamp from 
-- server_logs t1
-- join cte t2
-- on t1.server_name=t2.server_name and
-- t1.message=t2.message
cte where rnk=1 and earliest_timestamp>(select newest_entry from cte2)-interval '90 days';
