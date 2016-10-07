Use PrimitivaJavi
go
set dateformat 'ymd' 
Insert into Sorteo(IdSorteo,FechaSorteo)
Values (8,CURRENT_TIMESTAMP)
declare @IdBoleto bigint
Execute GrabaSencilla 8, 1,2,3,4,5,6,@IdBoleto
Select * from Boleto
Select * from NumeroBoleto
ORDER BY Numero
select * from Sorteo

Execute GrabaMuchasSencillas 8,100

Execute Grabamultiple 8,1,2,3,4,5,48,37,23,15

Select * from Boleto
Select * from NumeroBoleto

Insert into Sorteo(IdSorteo,FechaSorteo)
Values (10,'20161105')


declare @IdBoleto bigint
Execute GrabaSencilla 10, 1,2,3,4,5,90,@IdBoleto

Update NumeroBoleto set Numero=8 where Numero=5 
