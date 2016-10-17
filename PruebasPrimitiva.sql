Use PrimitivaJavi
go
set dateformat 'ymd' 
Insert into Sorteos(IdSorteo,FechaSorteo)
Values (100,'20171008')
declare @IdBoleto bigint
Execute GrabaSencilla 15, 1,2,3,4,5,6,@IdBoleto
Select * from Boletos
Select * from NumerosBoletos
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
Insert into Sorteos(IdSorteo,FechaSorteo)
Values(15,'20161110')

Update Sorteos set num1=1,num2=8,num3=4,num4=23,num5=15,num6=24,rein=5,comp=39
where IdSorteo=15

Execute GrabaMuchasSencillas 15,100  --Tiempo de insercion 6 segundos, tamaño 7.23 MB

Execute GrabaMuchasSencillas 15,100000 --Tiempo de inserción 67 segundos,tamaño 33.23 MB

Execute GrabaMuchasSencillas 15,500000 --Tiempo de inserción 322 segundos,tamaño 166.23MB

Execute GrabaMuchasSencillas 15,1000000--Tiempo de inserción 637 segundos,tamaño 432.23MB

Update Boletos set NumeroAcertados=0 where IdSorteo=15
Delete From Boletos 