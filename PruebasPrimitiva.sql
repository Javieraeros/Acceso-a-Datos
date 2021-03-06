Use PrimitivaJavi
go
set dateformat 'ymd' 
Insert into Sorteos(IdSorteo,FechaSorteo)
Values (15,'20171008')
declare @IdBoleto bigint
Execute GrabaSencilla 15, 1,2,3,4,5,6,@IdBoleto OUTPUT
Select * from Boletos
Select * from NumersoBoletos
ORDER BY Numero
select * from Sorteos

Execute GrabaMuchasSencillas 8,100

Execute Grabamultiple 8,1,2,3,4,5,48,37,23,15

Select * from Boletos
Select * from NumeroBoletos

Insert into Sorteos(IdSorteo,FechaSorteo)
Values (9652,'20161105')


declare @IdBoleto bigint
Execute GrabaSencilla 9652, 1,2,3,4,5,90,@IdBoleto

Update NumerosBoletos set Numero=8 where Numero=5 



--Pruebas de rendimiento
--Realiza inserciones de 10.000, 100.000, 500.000 y 1.000.000 de boletos y mide el tiempo y el tama�o de la base de datos
--Anota los resultados en este formulario (uno por grupo)
Insert into Sorteos(IdSorteo,FechaSorteo)
Values(15,'20161110')

Update Sorteos set num1=1,num2=8,num3=4,num4=23,num5=15,num6=24,rein=5,comp=39
where IdSorteo=15

Execute GrabaMuchasSencillas 15,10000  --Tiempo de insercion 6 segundos, tama�o 7.23 MB

Execute GrabaMuchasSencillas 15,100000 --Tiempo de inserci�n 67 segundos,tama�o 33.23 MB

Execute GrabaMuchasSencillas 15,500000 --Tiempo de inserci�n 322 segundos,tama�o 166.23MB

Execute GrabaMuchasSencillas 15,1000000--Tiempo de inserci�n 637 segundos,tama�o 432.23MB

Update Boletos set NumeroAcertados=0 where IdSorteo=15
select * from Sorteos
declare @IdBoleto bigint
Execute GrabaSencilla 15,1,8,4,23,15,24,@IdBoleto
Select sum(Premio) from Boletos
Select * from Boletos
Select sum(Premio) from Boletos where Premio<10
Execute AsignarPremios 15

Insert into Sorteos(IdSorteo,FechaSorteo)
Values (16,'20171008')
Update Sorteos set num1=1,num2=8,num3=4,num4=23,num5=15,num6=24,rein=5,comp=39
where IdSorteo=16

Execute GrabaMuchasSencillas 16,10000

declare @IdBoleto bigint
Execute GrabaSencilla 16, 1,4,8,15,23,24,@IdBoleto

select * from Boletos where IdSorteo=16
Execute AsignarPremios 16
select * from Boletos where IdSorteo=16
order by Premio
select count(*) from Boletos where NumeroAcertados=3