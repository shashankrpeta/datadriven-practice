with cte as
(
select user_id,event_name,rank() over(partition by user_id order by event_ts) as rnk
from app_event_deliveries
)
select distinct user_id,event_name
from cte
where rnk=1 and user_id is not null
