/* Проверка*/
select count (distinct customer_id) as TotalConsumer from customer
where store_id = 1;

select count (distinct customer_id) as TotalConsumer from customer
where store_id = 2;

/* Домашнее задание*/
select store_id as NumberStore, count(distinct customer_id) as TotalCustomers from customer
group by store_id
having count(distinct customer_id) > 300;