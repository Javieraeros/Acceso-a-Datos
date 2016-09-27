Use Primitiva
go
Insert into Sorteo(IdSorteo,FechaSorteo)
Values (8,CURRENT_TIMESTAMP)
declare @IdBoleto bigint
Execute GrabaSencilla 8, 1,2,3,4,5,6,@IdBoleto
Select * from Boleto
Select * from NumeroBoleto