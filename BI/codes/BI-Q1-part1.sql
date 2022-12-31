--catch the day of the transaction_date to remove the effect of time
--then group by that day and count it for each day

select DAY(transaction_date)'uniqe days', COUNT(DAY(transaction_date))'number of transaction'
from trx group by DAY(transaction_date) order by 1;