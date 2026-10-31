select consumer,count(*) as deliveries,count(distinct part_key) as unique_events
from stream_msgs
where consumer is not null
group by consumer;
