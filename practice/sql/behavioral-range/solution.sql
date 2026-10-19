select u.user_id,count(distinct e.event_type) as event_type_count
  from users u
  left join event_data e
  on u.user_id=e.user_id
  group by u.user_id;
