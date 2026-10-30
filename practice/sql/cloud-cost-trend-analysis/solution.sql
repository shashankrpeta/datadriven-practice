select svc_name,bill_date,amount,amount-lag(amount) over (partition by svc_name order by bill_date)
from cloud_costs
order by svc_name,bill_date;
