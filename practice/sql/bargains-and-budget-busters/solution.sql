WITH combined AS (
    SELECT
        region,
        svc_name,
        amount
    FROM cloud_costs

    UNION ALL

    SELECT
        region,
        svc_name,
        amount
    FROM cost_allocs
),
ranked AS (
    SELECT
        region,
        svc_name,
        amount,

        ROW_NUMBER() OVER (
            PARTITION BY region
            ORDER BY amount DESC
        ) AS biggest_rank,

        ROW_NUMBER() OVER (
            PARTITION BY region
            ORDER BY amount ASC
        ) AS smallest_rank

    FROM combined
)
SELECT
    region,

    MAX(
        CASE
            WHEN biggest_rank = 1 THEN svc_name
        END
    ) AS most_expensive,

    MAX(
        CASE
            WHEN smallest_rank = 1 THEN svc_name
        END
    ) AS cheapest

FROM ranked
GROUP BY region
ORDER BY region;


-- with cte1 as
-- (select t1.region,t1.svc_name,sum(amount) as t1_sum
-- from cloud_costs t1
-- group by t1.region,t1.svc_name),cte2 as
-- (
-- select t2.region,t2.svc_name,sum(amount) as t2_sum
--  from cost_allocs t2
--  group by t2.region,t2.svc_name 
-- )
-- ,cte3 as(
-- select c1.region as c1_region,c1.svc_name as c1_svcname,c2.region as c2_region,c2.svc_name as c2_svcname,coalesce(c1.t1_sum,0) as c1_amt,
-- coalesce(c2.t2_sum,0) as c2_amt
--   from cte1 c1
--   full outer join cte2 c2
--   on c1.region=c2.region and c1.svc_name=c2.svc_name
-- ),cleaned_data as
--   (
-- select coalesce(c1_region,c2_region) as one_region,coalesce(c1_svcname,c2_svcname) as one_service,
-- sum(c1_amt+c2_amt) as total_sum,dense_rank() over(partition by coalesce(c1_region,c2_region) order by sum(c1_amt+c2_amt) desc) as first_rank,
-- dense_rank() over(partition by coalesce(c1_region,c2_region) order by sum(c1_amt+c2_amt)) as last_rank
-- from cte3
-- group by one_region,one_service
-- )
-- -- select  from cleaned_data;
-- -- SELECT
-- --     one_region,
-- --     MAX(CASE
-- --         WHEN first_rank = 1 THEN one_service
-- --     END) AS most_expensive,
-- --     MAX(CASE
-- --         WHEN last_rank = 1 THEN one_service
-- --     END) AS cheapest
-- -- FROM cleaned_data
-- -- GROUP BY one_region
-- -- ORDER BY one_region;
-- select *
-- from cloud_costs
-- group by region,svc_name
