--Premios
Use PrimitivaJavi
--Modifica la base de datos para que, una vez realizado el sorteo, se pueda asignar a cada boleto la cantidad ganada.
Alter table Boleto add Premios smallmoney null
/*		-3 para tres aciertos
		-4 para cuatro aciertos
		-5 para cinco aciertos
		-6 para cinco aciertos más el complementario
		-7 para 6 aciertos
		-8 para 6 aciertos más el complementario
		-9 para 6 aciertos más el reintegro
		-10 para 6 aciertos, el complementario y el reintegro
		- "-1" para el reintegro solo
*/		
Create Table Premio(
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
Create Table BoletoPremio (
			IdSorteo bigInt,
			IdBoleto bigInt,
			Especial tinyint,
			Primera tinyint,
			Segunda tinyint,
			Tercera tinyint,
			Cuarta tinyint,
			Quinta tinyint,
			constraint PK_BoletoPremio primary key (IdSorteo,IdBoleto),
			constraint FK_BoletoPremio_Boleto foreign key (IdSorteo,IdBoleto) references Boleto(IdSorteo,IdBoleto)

/*
Create function compruebaAciertos (IdSorteo bigint,IdBoleto bigint) return int as
Funcion que devuelve el número de aciertos de un boleto, independientemente del tipo de boleto que sea
Entrada:El id del sorteo y el id del boleto
Salida:El número de aciertos:

go
Create function compruebaAciertos (@IdSorteo bigint,@Idboleto bigint) returns tinyint as
Begin
	declare @aciertos tinyint=0
	If((Select num1 from Sorteo where IdSorteo=@IdSorteo)=(Select Numero from NumeroBoleto where IdSorteo=@IdSorteo and IdBoleto=@Idboleto))
		set @aciertos=@aciertos+1
	If((Select num2 from Sorteo where IdSorteo=@IdSorteo)=(Select Numero from NumeroBoleto where IdSorteo=@IdSorteo and IdBoleto=@Idboleto))
		set @aciertos=@aciertos+1
	If((Select num3 from Sorteo where IdSorteo=@IdSorteo)=(Select Numero from NumeroBoleto where IdSorteo=@IdSorteo and IdBoleto=@Idboleto))
		set @aciertos=@aciertos+1
	If((Select num4 from Sorteo where IdSorteo=@IdSorteo)=(Select Numero from NumeroBoleto where IdSorteo=@IdSorteo and IdBoleto=@Idboleto))
		set @aciertos=@aciertos+1
	If((Select num5 from Sorteo where IdSorteo=@IdSorteo)=(Select Numero from NumeroBoleto where IdSorteo=@IdSorteo and IdBoleto=@Idboleto))
		set @aciertos=@aciertos+1
	If((Select comp from Sorteo where IdSorteo=@IdSorteo)=(Select Numero from NumeroBoleto where IdSorteo=@IdSorteo and IdBoleto=@Idboleto))
		set @aciertos=@aciertos+1


	if((Select TipoApuesta from Boleto where IdBoleto=@Idboleto and IdSorteo=@IdSorteo) =5)
	Begin
		Select Numero from NumeroBoleto
	End
	return @aciertos 
End
*/
go
--Para ello, crea un procedimiento AsignarPremios que calcule los premios de cada boleto y lo guarde en la base de datos.
--Para saber cómo se asignan los premios, debes seguir las instrucciones de este documento, en especial el Capítulo V del Título I 
--(págs 7, 8, 9 y 10) y la tabla de la instrucción 21.4 (pág 14).
Go
Create Procedure AsignarPremios @IdSorteo bigint as
Begin
	/*Primero tenemos que saber cuanto se ha recaudado, para ello contaremos el número de apuestas y las multiplicaremos por su coste*/
	declare @tipo5 int,@tipo6 int,@tipo7 int,@tipo8 int
	declare @tipo9 int, @tipo10 int,@tipo11 int,@total int
	declare @total5 int,@total6 int,@total7 int,@total8 int
	declare @total9 int,@total10 int,@total11 int,@total12 int

	Select @tipo5=count(TipoApuesta) from Boleto where TipoApuesta=5 and IdSorteo=@IdSorteo
	Select @tipo6=count(TipoApuesta) from Boleto where TipoApuesta=6 and IdSorteo=@IdSorteo
	Select @tipo7=count(TipoApuesta) from Boleto where TipoApuesta=7 and IdSorteo=@IdSorteo
	Select @tipo8=count(TipoApuesta) from Boleto where TipoApuesta=8 and IdSorteo=@IdSorteo
	Select @tipo9=count(TipoApuesta) from Boleto where TipoApuesta=9 and IdSorteo=@IdSorteo
	Select @tipo10=count(TipoApuesta) from Boleto where TipoApuesta=10 and IdSorteo=@IdSorteo
	Select @tipo11=count(TipoApuesta) from Boleto where TipoApuesta=11 and IdSorteo=@IdSorteo

	set @total5=44*@tipo5
	set @total6=1*@tipo6
	set @total7=7*@tipo7
	set @total8=28*@tipo8
	set @total9=84*@tipo9
	set @total10=210*@tipo10
	set @total11=462*@tipo11
	set @total=@total5+@total6+@total7+@total8+@total9+@total10+@total11

	--Guardamos en una tabla el id del boleto, la cantidad de aciertos y su premio correspondiente:
	create Table #tablaAciertos (IdBoleto bigint,Aciertos tinyint,Premio smallmoney)
	Insert into #tablaAciertos(IdBoleto) Select IdBoleto from Boleto where IdSorteo=@IdSorteo
	--If(

	declare @tablaSorteo as Table (NumeroSorteo tinyint)
	insert into @tablaSorteo Select num1 from Sorteo where IdSorteo=@IdSorteo
	insert into @tablaSorteo Select num2 from Sorteo where IdSorteo=@IdSorteo
	insert into @tablaSorteo Select num3 from Sorteo where IdSorteo=@IdSorteo
	insert into @tablaSorteo Select num4 from Sorteo where IdSorteo=@IdSorteo
	insert into @tablaSorteo Select num5 from Sorteo where IdSorteo=@IdSorteo
	insert into @tablaSorteo Select num6 from Sorteo where IdSorteo=@IdSorteo

	Select IdBoleto, count(*) from NumeroBoleto as NB
	inner join @tablaSorteo as TS
	on NB.Numero=TS.NumeroSorteo
	where NB.IdSorteo=@IdSorteo
	group by IdBoleto
	

End

