-- first, define a day
--for each trx date with LAG() go to previous row of date for each customer
--subtract trx date a day and if the result is equal to the previous row date
--put consecutive 0 and else 1
--then make batchno for each customer which count sume of ones in consecutive column for each custumer
--at the end in batchcnt calculate number of consecutve days for each custumer

With ConsecutiveCTE as 

(Select customer_id, toal_amount_ofday, 

	transaction_date, DateAdd(d, -1, transaction_date) as PrevDt,

	LAG(transaction_date) OVER (Partition by customer_id Order by transaction_date) as LagDt ,

	Case When DateAdd(d, -1, transaction_date) = 

	LAG(transaction_date) OVER (Partition by customer_id Order by transaction_date) 

Then 0 Else 1 END as Consecutive
FROM modifiedtrx) 



, BatchCTE as 

(Select *, SUM(Consecutive) OVER(Partition by customer_id Order by transaction_date)  as BatchNo 

FROM ConsecutiveCTE) 



, BatchCntCTE as 

(Select *, 

	Row_Number() OVER (Partition by customer_id, BatchNo Order by transaction_date Desc) as BatchCnt 

From BatchCTE) 



Select * 

from BatchCntCTE 

WHERE Consecutive = 1