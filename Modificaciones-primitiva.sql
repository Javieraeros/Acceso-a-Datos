--Premios
Use PrimitivaJavi
--Modifica la base de datos para que, una vez realizado el sorteo, se pueda asignar a cada boleto la cantidad ganada.
Alter table Boletos add Premio money null
Alter table Boletos add NumeroAcertados tinyint default 0 null 
/*		-3 para tres aciertos
		-4 para cuatro aciertos
		-5 para cinco aciertos
		-50 para cinco aciertos más el complementario
		-6 para 6 aciertos
		-60 para 6 aciertos más el complementario
		-15 para 6 aciertos más el reintegro
		-69 para 6 aciertos, el complementario y el reintegro
		-9 para el reintegro solo
*/		
Create Table Premios(
			TipoApuesta tinyint,
			NumerosAcertados tinyint,
			Especial tinyint,
			Primera tinyint,
			Segunda tinyint,
			Tercera tinyint,
			Cuarta tinyint,
			Quinta tinyint,
			constraint PK_Premio primary key (TipoApuesta,NumerosAcertados)
			)
Insert into Premios(TipoApuesta,NumerosAcertados,Especial,Primera,Segunda,Tercera,
					Cuarta,Quinta)
Values(7,69,1,1,6,0,0,0),(7,15,1,1,0,6,0,0),(7,60,0,1,6,0,0,0),(7,6,0,1,0,6,0,0),(7,50,0,0,1,1,5,0),(7,5,0,0,0,2,5,0),(7,4,0,0,0,0,3,4),(7,3,0,0,0,0,0,4),
(8,69,1,1,6,6,15,0),(8,15,1,1,0,12,15,0),(8,60,0,1,6,6,15,0),(8,6,0,1,0,12,15,0),(8,50,0,0,1,2,15,10),(8,5,0,0,0,3,15,10),(8,4,0,0,0,0,6,16),(8,3,0,0,0,0,0,10),
(5,15,1,1,1,42,0,0),(5,6,0,1,1,42,0,0),(5,50,0,0,2,0,42,0),(5,5,0,0,0,2,42,0),(5,4,0,0,0,0,3,41),(5,3,0,0,0,0,0,4),
(9,69,1,1,6,12,45,20),(9,15,1,1,0,18,45,20),(9,60,0,1,6,12,45,20),(9,6,0,1,0,18,45,20),(9,50,0,0,1,3,30,40),(9,5,0,0,0,4,30,40),(9,4,0,0,0,0,10,40),(9,3,0,0,0,0,0,20),
(10,69,1,1,6,18,90,80),(10,15,1,1,0,24,90,80),(10,60,0,1,6,18,90,80),(10,6,0,1,0,24,90,80),(10,50,0,0,1,4,50,100),(10,5,0,0,0,5,50,100),(10,4,0,0,0,0,15,80),(10,3,0,0,0,0,0,35),
(11,69,1,1,6,24,150,200),(11,15,1,1,0,30,150,200),(11,60,0,1,6,24,150,200),(11,6,0,1,0,30,150,200),(11,50,0,0,1,5,75,200),(11,5,0,0,0,6,75,200),(11,4,0,0,0,0,21,140),(11,3,0,0,0,0,0,56),
(6,15,1,0,0,0,0,0),(6,6,0,1,0,0,0,0),(6,50,0,0,1,0,0,0),(6,5,0,0,0,1,0,0),(6,4,0,0,0,0,1,0),(6,3,0,0,0,0,0,1)


go
--Para ello, crea un procedimiento AsignarPremios que calcule los premios de cada boleto y lo guarde en la base de datos.
--Para saber cómo se asignan los premios, debes seguir las instrucciones de este documento, en especial el Capítulo V del Título I 
--(págs 7, 8, 9 y 10) y la tabla de la instrucción 21.4 (pág 14).
Go
Alter Procedure AsignarPremios @IdSorteo bigint as
Begin
	--Numero de apuestas de cada tipo
	declare @tipo5 int,@tipo6 int,@tipo7 int,@tipo8 int
	declare @tipo9 int, @tipo10 int,@tipo11 int

	--Dinero recaudado por cada tipo, y total
	declare @total5 money,@total6 money,@total7 money,@total8 money,@total9 money,@total10 money
	declare @total11 money,@totalrecaudado money,@totalrepartir money,@totalreintegro money

	--Número de aciertos de cada tipo de apuesta
	declare @acertEspecial int,@acertPrimera int,@acertSegunda int,@acertTercera int,@acertCuarta int,@acertQuinta int 

	--Cantidad de dinero que se le repartirá a cada tipo de premio (total)
	declare @especial money=0,@primera money=0,@segunda money=0
	declare @tercera money=0,@cuarta money=0, @quinta money=0

	--Cantidad de dinero que se le dará a un acierto de cada tipo
	declare @unitEspecial money=0,@unitPrimera money=0,@unitSegunda money=0
	declare @unitTercera money=0,@unitCuarta money=0, @unitQuinta money=8

	/*Primero tenemos que saber cuanto se ha recaudado, para ello contaremos el número de apuestas y las multiplicaremos por su coste*/
	Select @tipo5=count(TipoApuesta) from Boletos where TipoApuesta=5 and IdSorteo=@IdSorteo
	Select @tipo6=count(TipoApuesta) from Boletos where TipoApuesta=6 and IdSorteo=@IdSorteo
	Select @tipo7=count(TipoApuesta) from Boletos where TipoApuesta=7 and IdSorteo=@IdSorteo
	Select @tipo8=count(TipoApuesta) from Boletos where TipoApuesta=8 and IdSorteo=@IdSorteo
	Select @tipo9=count(TipoApuesta) from Boletos where TipoApuesta=9 and IdSorteo=@IdSorteo
	Select @tipo10=count(TipoApuesta) from Boletos where TipoApuesta=10 and IdSorteo=@IdSorteo
	Select @tipo11=count(TipoApuesta) from Boletos where TipoApuesta=11 and IdSorteo=@IdSorteo

	set @total5=44*@tipo5
	set @total6=1*@tipo6
	set @total7=7*@tipo7
	set @total8=28*@tipo8
	set @total9=84*@tipo9
	set @total10=210*@tipo10
	set @total11=462*@tipo11
	set @totalrecaudado=@total5+@total6+@total7+@total8+@total9+@total10+@total11  --total recaudado

	--Calculamos la cantidad a repartir entre las 5 categorías y el fondo para el reintegro
	set @totalrepartir=@totalrecaudado*0.45
	set @totalreintegro=@totalrecaudado*0.10

	--Para evitar errores:
	Update Boletos set NumeroAcertados=0 where IdSorteo=@IdSorteo

	--Calculamos según nuestro código el número de aciertos
	Update Boletos set NumeroAcertados=NumeroAcertados+1
	where IdBoleto in (
	Select IdBoleto from Sorteos as S
	inner join NumerosBoletos as NB
	on S.num1=Nb.Numero
	where Nb.IdSorteo=@IdSorteo
	)
	Update Boletos set NumeroAcertados=NumeroAcertados+1
	where IdBoleto in (
	Select IdBoleto from Sorteos as S
	inner join NumerosBoletos as NB
	on S.num2=Nb.Numero
	where Nb.IdSorteo=@IdSorteo
	)
	Update Boletos set NumeroAcertados=NumeroAcertados+1
	where IdBoleto in (
	Select IdBoleto from Sorteos as S
	inner join NumerosBoletos as NB
	on S.num3=Nb.Numero
	where Nb.IdSorteo=@IdSorteo
	)
	Update Boletos set NumeroAcertados=NumeroAcertados+1
	where IdBoleto in (
	Select IdBoleto from Sorteos as S
	inner join NumerosBoletos as NB
	on S.num4=Nb.Numero
	where Nb.IdSorteo=@IdSorteo
	)
	Update Boletos set NumeroAcertados=NumeroAcertados+1
	where IdBoleto in (
	Select IdBoleto from Sorteos as S
	inner join NumerosBoletos as NB
	on S.num5=Nb.Numero
	where Nb.IdSorteo=@IdSorteo
	)
	/*
	Esto lo hacemos, porque en la primitiva, existen apuestas de 5 números
	y el número que falta, se sobreentiende que está acertado
	*/
	Update Boletos set NumeroAcertados=NumeroAcertados+1
	where TipoApuesta=5

	Update Boletos set NumeroAcertados=NumeroAcertados+1
	where IdBoleto in (
	Select IdBoleto from Sorteos as S
	inner join NumerosBoletos as NB
	on S.num6=Nb.Numero
	where Nb.IdSorteo=@IdSorteo
	)
	Update Boletos set NumeroAcertados=NumeroAcertados*10
	where IdBoleto in (
	Select IdBoleto from Sorteos as S
	inner join NumerosBoletos as NB
	on S.comp=Nb.Numero
	where Nb.IdSorteo=@IdSorteo
	)
	Update Boletos set NumeroAcertados=NumeroAcertados+9
	where IdBoleto in (
	Select IdBoleto from Boletos as B
	inner join Sorteos as S
	on B.IdSorteo=S.IdSorteo
	where (NumeroAcertados=6 or NumeroAcertados=60) and B.Reintegro=S.rein
	)

	--Guardamos en las diferentes variables la cantidad de premios de cada tipo
	Select @acertEspecial=count(*)*P.Especial
	from Boletos as B
	inner join Premios as P
	on B.NumeroAcertados=P.NumerosAcertados and B.TipoApuesta=P.TipoApuesta
	group by P.Especial

	Select @acertPrimera=count(*)*P.Primera
	from Boletos as B
	inner join Premios as P
	on B.NumeroAcertados=P.NumerosAcertados and B.TipoApuesta=P.TipoApuesta
	group by P.Primera

	select @acertSegunda=count(*)*P.Segunda
	from Boletos as B
	inner join Premios as P
	on B.NumeroAcertados=P.NumerosAcertados and B.TipoApuesta=P.TipoApuesta
	group by Segunda

	Select @acertTercera=count(*)*P.Tercera
	from Boletos as B
	inner join Premios as P
	on B.NumeroAcertados=P.NumerosAcertados and B.TipoApuesta=P.TipoApuesta
	group by P.Tercera

	Select @acertCuarta=count(*)*P.Cuarta
	from Boletos as B
	inner join Premios as P
	on B.NumeroAcertados=P.NumerosAcertados and B.TipoApuesta=P.TipoApuesta
	group by P.Cuarta

	Select @acertQuinta=count(*)*P.Quinta
	from Boletos as B
	inner join Premios as P
	on B.NumeroAcertados=P.NumerosAcertados and B.TipoApuesta=P.TipoApuesta
	group by P.Quinta

	--Calculamos ahora el total de dinero destinado a cada premio
	set @quinta=@acertQuinta*@unitQuinta

	set @totalrepartir=@totalrepartir-@quinta

	set @especial=@totalrepartir*0.20
	set @primera=@totalrepartir*0.40
	set @segunda=@totalrepartir*0.06
	set @tercera=@totalrepartir*0.13
	set @cuarta=@totalrepartir*0.21

	--calculamos el premio unitario
	if(@acertEspecial=0)
	set @unitEspecial=0
	else
	set @unitEspecial=@especial/@acertEspecial

	if (@acertPrimera=0)
	set @unitPrimera=0
	else
	set @unitprimera=@primera/@acertprimera

	if (@acertSegunda=0)
	set @unitSegunda=0
	else
	set @unitsegunda=@segunda/@acertsegunda

	if (@acertTercera=0)
	set @unitTercera=0
	else
	set @unitTercera=@tercera/@acerttercera

	if (@acertCuarta=0)
	set @unitCuarta=0
	else
	set @unitcuarta=@cuarta/@acertcuarta

	--Calculamos el premio de cada boleto, con la tabla auxiliar y la columna del código de la tabla boletos
	Update Boletos set Premio =(
		Select P.Especial*@unitEspecial+P.Primera*@unitPrimera+
			   P.Segunda*@unitSegunda+P.Tercera*@unitTercera+P.Cuarta*@unitCuarta+P.Quinta*@unitQuinta
		from Premios as P
		inner join Boletos as B
		on P.TipoApuesta=B.TipoApuesta and P.NumerosAcertados=B.NumeroAcertados
		where IdBoleto=31)
End