Use Primitiva
go
Insert into Sorteo(IdSorteo,FechaSorteo)
Values (5,CURRENT_TIMESTAMP)
declare @IdBoleto bigint
Execute GrabaSencilla 5, 1,2,3,4,5,6,@IdBoleto
Select * from Boleto
Select * from NumeroBoleto