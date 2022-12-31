-- first group by the customer_id and then sum the number of logins for each
--customer, then sort by the number of logins in descending order and show the top three.

select top 3 customer_id, sum(count_login)'sum of logins' from login group by customer_id
order by 2 desc;