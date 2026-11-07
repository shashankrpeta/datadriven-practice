select department,count(case when fiscal_quarter='Q1' then 1 else null end) as q1,
count(case when fiscal_quarter='Q2' then 1 else null end) as q2,
count(case when fiscal_quarter='Q3' then 1 else null end) as q3,
count(case when fiscal_quarter='Q4' then 1 else null end) as q4
from employee_metrics
group by department;

-- select department,fiscal_quarter,count(*) from employee_metrics
-- group by department,fiscal_quarter;
