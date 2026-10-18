with cte as (
select edge_loc,req_path,sum(bytes) as total_bytes,sum(case when cache_hit>0 then 1 else 0 end) as cache_hit_api_per_location

from cdn_logs
where req_path like '/api/%'
group by edge_loc)
select edge_loc,req_path,total_bytes
from cte
where cache_hit_api_per_location>0
order by total_bytes
