with cte as
(select user_id,cast(min(session_start) as date) as first_session
from user_sessions
where session_id is not null
group by user_id
order by user_id),
cte2 as 
(
select c.user_id,c.first_session
from cte c
where exists(select 1 from user_sessions u
where c.user_id=u.user_id and cast(u.session_start as date)>(c.first_session) and 
cast(u.session_start as date)<=(c.first_session+interval '90' day))
)
select 
  round(count(t2.user_id)/(count(t1.user_id)*1.0),3) as retention_rate
from cte t1
left join cte2 t2
on t1.user_id=t2.user_id;
