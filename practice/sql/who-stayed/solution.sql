with cte as
(
select distinct user_id,extract(month from session_start) AS session from user_sessions
where extract(month from session_start)<=6 and extract(year from session_start)=2026
order by session_start
),cte2 as (
    select
        user_id,
        session,session-row_number() over (partition by user_id order by session) as island_id
    from cte
),cte3 as (
select user_id,island_id,count(*) as streak
from cte2
group by user_id,island_id)
select user_id,max(streak) as streak_length,dense_rank() over( order by max(streak) desc) as standing
from cte3
group by user_id
order by standing;
