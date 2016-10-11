Use PrimitivaJavi
go
set dateformat 'ymd' 
Insert into Sorteos(IdSorteo,FechaSorteo)
Values (100,'20171008')
declare @IdBoleto bigint
Execute GrabaSencilla 100, 1,2,3,4,5,6,@IdBoleto
Select * from Boletos
Select * from NumersoBoletos
ORDER BY Numero
select * from Sorteos

Execute GrabaMuchasSencillas 8,100

Execute Grabamultiple 8,1,2,3,4,5,48,37,23,15

Select * from Boletos
Select * from NumeroBoletos

Insert into Sorteos(IdSorteo,FechaSorteo)
Values (10,'20161105')


declare @IdBoleto bigint
Execute GrabaSencilla 10, 1,2,3,4,5,90,@IdBoleto

Update NumerosBoletos set Numero=8 where Numero=5 



--Pruebas de rendimiento
--Realiza inserciones de 10.000, 100.000, 500.000 y 1.000.000 de boletos y mide el tiempo y el tamaño de la base de datos
--Anota los resultados en este formulario (uno por grupo)
Insert into Sorteo(IdSorteo,FechaSorteo)
Values(15,'20161110')
Execute GrabaMuchasSencillas 15,10000
Execute GrabaMuchasSencillas 15,100000
Execute GrabaMuchasSencillas 15,500000
Execute GrabaMuchasSencillas 15,1000000
