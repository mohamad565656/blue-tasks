--first unpivot table so we will have 3 column : id-step-status
--second update unpivoted table with condition which if id and step is same and status=0
--so maske greater status=0
--at the end again pivot the table and make id as rows and steps as columns and
--status as values.

select id, step, status
into unpivotbug
from bug
unpivot
(
	status
	for step in ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9])
) as unpivotbug
go

update a
	set a.status=0
	from unpivotbug a
	where exists (select 1 
              from unpivotbug b where b.id=a.id and b.step=a.step 
               and b.step>= (select min(c.step) from unpivotbug c where c.id=b.id and c.status=0) );
go

select id,[0],[1],[2],[3],[4],[5],[6],[7],[8],[9]
into repivotedbug
from unpivotbug
pivot
(
	sum(status)
	for step in ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9])
)as pivotedbug
go

select top 30 * from repivotedbug
order by id