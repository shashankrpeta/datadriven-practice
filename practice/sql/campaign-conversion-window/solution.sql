with cte1 as(
select ad_campaign,count(impression_id) as impressions,sum(case when clicked=1 then 1 else 0 end) as clicks
from ad_impressions 
where user_id is not null
group by ad_campaign
having sum(case when clicked=1 then 1 else 0 end)>=4)
,cte2 as
(
select ad_campaign,user_id,cast(impression_time as date) as impression_day
from ad_impressions where clicked=1 and user_id is not null
order by ad_campaign,user_id
),cte5 as(
select ad_campaign,count(distinct user_id) as real_clickers
  from cte2
  group by ad_campaign),cte3 as
(
select c.ad_campaign,c.user_id
from cte2 c
where exists(select 1
from transactions t
where t.user_id=c.user_id
and t.transaction_date>=c.impression_day and t.transaction_date<=(c.impression_day+interval '7' day)))
,cte4 as (
select ad_campaign,count(distinct user_id) as converters
from cte3
group by ad_campaign)
select c1.ad_campaign,c1.impressions,c1.clicks,round((c1.clicks*100.0/c1.impressions),2) as ctr_pct,coalesce(c2.converters,0) as conversions,
(c2.converters*100.0)/c3.real_clickers as conversion_rate_pct 
from 
cte1 c1
left join cte4 c2
on c1.ad_campaign=c2.ad_campaign
left join cte5 c3
on c3.ad_campaign=c1.ad_campaign
