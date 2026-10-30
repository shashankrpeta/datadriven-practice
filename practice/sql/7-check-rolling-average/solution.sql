select svc_name,checked,latency,avg(latency) over (partition by svc_name order by checked rows between 6 preceding and current row ) as rolling_avg 
from svc_health
order by svc_name,checked
