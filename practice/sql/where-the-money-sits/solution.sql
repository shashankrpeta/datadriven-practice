select team_name,sum(case when category='compute' then 1 else 0 end) as compute_count,sum(amount) as total_cost from cost_allocs
group by team_name;
