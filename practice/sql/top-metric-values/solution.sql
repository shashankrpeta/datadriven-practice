select metric_value from employee_metrics
where metric_value is not null
group by metric_value
order by metric_value desc
limit 5;
