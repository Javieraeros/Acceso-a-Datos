Use Master
If Not Exists(Select * from dbo.sysdatabases where name='PrimitivaJavi')
	BEGIN
	Create Database PrimitivaJavi
	END
GO
Use PrimitivaJavi
Create table Sorteo(
	IdSorteo bigint not null,
	FechaSorteo smalldatetime not null,
	num1 tinyint null,
	num2 tinyint null,
	num3 tinyint null,
	num4 tinyint null,
	num5 tinyint null,
	num6 tinyint null,
	comp tinyint null,
	rein tinyint null,
	constraint PK_Sorteo Primary key (IdSorteo)
	)
go
Create table Boleto(
	IdBoleto bigint not null, --No pongo identity porque el id del boleto se repetirá en diferentes sorteos
	IdSorteo bigint not null,
	Reintegro tinyint not null,
	TipoApuesta tinyint not null    /**En esta columna guardaremos la cantidad de números que vamos a seleccionar*/
	constraint PK_Boleto Primary key (IdBoleto,IdSorteo),
	constraint FK_BoletoSorteo Foreign key (IdSorteo) references Sorteo(IdSorteo) on Update cascade on delete no action
	)
go
Create table NumeroBoleto(
	IdSorteo bigint not null,
	IdBoleto bigint not null,
	Numero tinyint not null,
	constraint PK_NumeroBoleto Primary key (IdSorteo,IdBoleto,Numero),
	constraint FK_NumeroBoleto_boleto Foreign key (IdBoleto,IdSorteo) references Boleto(IdBoleto,IdSorteo)
		on Update cascade on Delete no action
	)


--Programación parte 1

--Implementa un procedimiento almacenado GrabaSencilla que grabe una apuesta simple. Datos de entrada: El sorteo y los seis números
go
CREATE PROCEDURE GrabaSencilla @IdSorteo bigint,
							   @num1 tinyint,@num2 tinyint,@num3 tinyint,@num4 tinyint,@num5 tinyint,@num6 tinyint,
							   @IdBoleto bigint OUTPUT as
Begin
	If(@num1<> @num2 and @num1<>@num3 and @num1<>@num4 and @num1<>@num5 and @num1<>@num6
		 and @num2<>@num3 and @num2<>@num4 and @num2<>@num5 and @num2<>@num6
		 and @num3<>@num4 and @num3<>@num5 and @num3<>@num6
		 and @num4<>@num5 and @num4<>@num6 and @num5<>@num6)
	Begin
		--set @IdBoleto=NEWID() no vale
		Select Top 1 @IdBoleto=IdBoleto+1 from Boleto where IdSorteo=@IdSorteo
		Order by IdBoleto desc

		if (@IdBoleto is null)
		Begin
			set @IdBoleto=1
		End
		declare @Reintegro tinyint
		set @Reintegro=ABS(checksum(NEWID()))%10
	
		Insert into Boleto(IdBoleto,IdSorteo,Reintegro,TipoApuesta)
		Values(@IdBoleto,@IdSorteo,@Reintegro,6)

		/*
		--------------------Versión 1.0--------------------
		Insert into NumeroBoleto(IdBoleto,IdSorteo,Numero)
		Values(@IdBoleto,@IdSorteo,@num1)

		Insert into NumeroBoleto(IdBoleto,IdSorteo,Numero)
		Values(@IdBoleto,@IdSorteo,@num2)

		Insert into NumeroBoleto(IdBoleto,IdSorteo,Numero)
		Values(@IdBoleto,@IdSorteo,@num3)

		Insert into NumeroBoleto(IdBoleto,IdSorteo,Numero)
		Values(@IdBoleto,@IdSorteo,@num4)

		Insert into NumeroBoleto(IdBoleto,IdSorteo,Numero)
		Values(@IdBoleto,@IdSorteo,@num5)

		Insert into NumeroBoleto(IdBoleto,IdSorteo,Numero)
		Values(@IdBoleto,@IdSorteo,@num6)
		*/


		DECLARE @Numeros as TABLE(
		IdSorteo bigint not null,
		IdBoleto bigint not null,
		Numero tinyint not null)
		Insert into @Numeros(IdSorteo,IdBoleto,Numero)
				Values(@IdSorteo,@IdBoleto,@num1),
				(@IdSorteo,@IdBoleto,@num2),
				(@IdSorteo,@IdBoleto,@num3),
				(@IdSorteo,@IdBoleto,@num4),
				(@IdSorteo,@IdBoleto,@num5),
				(@IdSorteo,@IdBoleto,@num6)

		Insert into NumeroBoleto(IdSorteo,IdBoleto,Numero)
			Select * from @Numeros

		--Crear trigger que elimine todos lso inserts de haber algún número que se repita, es decir
		-- si no se han completado todos lso insert values
	End
	else
	Begin
		Raiserror('Error, los números no pueden estar repetidos',16,1)
	End
End
go

--Implementa un procedimiento GrabaMuchasSencillas que genere n boletos con una apuesta sencilla utilizando el procedimiento GrabaSencilla.
--Datos de entrada: El sorteo y el valor de n

Create Procedure GrabaMuchasSencillas @IdSorteo bigint, @cantidadboletos int as

Begin
	declare @contador int
	declare @num1 int,@num2 int,@num3 int,@num4 int,@num5 int,@num6 int
	declare @idBoleto bigint
	set @num2=0
	set @num3=0
	set @num4=0
	set @num5=0
	set @num6=0 
	set @contador=0
	while @contador<@cantidadboletos
	Begin
		set @num1=ABS(checksum(NEWID()))%49+1
		while @num2=0 or @num1=@num2
		Begin 
			set @num2=ABS(checksum(NEWID()))%49+1
		End

		while @num3=0 or @num3=@num2 or @num3=@num1
		begin
			set @num3=ABS(checksum(NEWID()))%49+1
		end

		while @num4=0 or @num4=@num3 or @num4=@num2 or @num4=@num1
		begin
			set @num4=ABS(checksum(NEWID()))%49+1
		end

		while @num5=0 or @num5=@num4 or @num5=@num3 or @num5=@num2 or @num5=@num1
		begin
			set @num5=ABS(checksum(NEWID()))%49+1
		end

		while @num6=0 or @num6=@num5 or @num6=@num4 or @num6=@num3 or @num6=@num2 or @num6=@num1
		begin
			set @num6=ABS(checksum(NEWID()))%49+1
		end

		Execute GrabaSencilla @IdSorteo,@num1,@num2,@num3,@num4,@num5,@num6,@idBoleto
		
		set @contador=@contador+1

		set @num2=0
		set @num3=0
		set @num4=0
		set @num5=0
		set @num6=0 
	End
End

--Implementa un procedimiento almacenado GrabaMultiple que grabe una apuesta multiple. Datos de entrada: El sorteo y entre 5 y 11 números
go
Create PROCEDURE Grabamultiple @IdSorteo bigint, @num1 tinyint,@num2 tinyint,@num3 tinyint,@num4 tinyint,@num5 tinyint,@num6 tinyint=0,
								@num7 tinyint=0,@num8 tinyint=0,@num9 tinyint=0,@num10 tinyint=0,@num11 tinyint=0 as
Begin
	if (@num1<> @num2 and @num1<>@num3 and @num1<>@num4 and @num1<>@num5 and @num1<>@num6 and @num1<>@num7 and @num1<>@num8 and @num1<>@num9 and @num1<>@num10 and @num1<>@num11
		 and @num2<>@num3 and @num2<>@num4 and @num2<>@num5 and @num2<>@num6 and @num2<>@num7 and @num2<>@num8 and @num2<>@num9 and @num2<>@num10 and @num2<>@num11
		 and @num3<>@num4 and @num3<>@num5 and @num3<>@num6 and @num3<>@num7 and @num3<>@num8 and @num3<>@num9 and @num3<>@num10 and @num3<>@num11
		 and @num4<>@num5 and @num4<>@num6 and @num4<>@num7 and @num4<>@num8 and @num4<>@num9 and @num4<>@num10 and @num4<>@num11
		 and @num5<>@num6 and @num5<>@num7 and @num5<>@num8 and @num5<>@num9 and @num5<>@num10 and @num5<>@num11
		 and @num6<>@num7 and @num6<>@num8 and @num6<>@num9 and @num6<>@num10 and @num6<>@num11 or @num6=0
		 and @num7<>@num8 and @num7<>@num9 and @num7<>@num10 and @num7<>@num11 or @num7=0
		 and @num8<>@num9 and @num8<>@num10 and @num8<>@num11 or @num8=0
		 and @num9<>@num10 and @num9<>@num11 or @num9=0
		 and @num10<>@num11 or @num10=0)
	Begin
		Declare @IdBoleto bigint
		Declare @TipoApuesta tinyint

		Select Top 1 @IdBoleto=IdBoleto+1 from Boleto where IdSorteo=@IdSorteo
		Order by IdBoleto desc

		if (@IdBoleto is null)
		Begin
		set @IdBoleto=1
		End
		declare @Reintegro tinyint
		set @Reintegro=ABS(checksum(NEWID()))%10

		if(@num11<>0)
			set @TipoApuesta=11
		else
		if(@num10<>0)
			set @TipoApuesta=10
		else
		if(@num9<>0)
			set @TipoApuesta=9
		else
		if(@num8<>0)
			set @TipoApuesta=8
		else
		if(@num7<>0)
			set @TipoApuesta=7
		else
		if(@num6<>0)
			set @TipoApuesta=6
		else
			set @TipoApuesta=5
				
		Insert into Boleto(IdSorteo,IdBoleto,Reintegro,TipoApuesta)
		values(@IdSorteo,@IdBoleto,@Reintegro,@TipoApuesta)

		Insert into NumeroBoleto(IdSorteo,IdBoleto,Numero)
		values(@IdSorteo,@IdBoleto,@num1)

		Insert into NumeroBoleto(IdSorteo,IdBoleto,Numero)
		values(@IdSorteo,@IdBoleto,@num2)

		Insert into NumeroBoleto(IdSorteo,IdBoleto,Numero)
		values(@IdSorteo,@IdBoleto,@num3)

		Insert into NumeroBoleto(IdSorteo,IdBoleto,Numero)
		values(@IdSorteo,@IdBoleto,@num4)

		Insert into NumeroBoleto(IdSorteo,IdBoleto,Numero)
		values(@IdSorteo,@IdBoleto,@num5)

		If(@TipoApuesta>=6)
		Insert into NumeroBoleto(IdSorteo,IdBoleto,Numero)
		values(@IdSorteo,@IdBoleto,@num6)
		
		If(@TipoApuesta>=7)
		Insert into NumeroBoleto(IdSorteo,IdBoleto,Numero)
		values(@IdSorteo,@IdBoleto,@num7)

		If(@TipoApuesta>=8)
		Insert into NumeroBoleto(IdSorteo,IdBoleto,Numero)
		values(@IdSorteo,@IdBoleto,@num8)

		If(@TipoApuesta>=9)
		Insert into NumeroBoleto(IdSorteo,IdBoleto,Numero)
		values(@IdSorteo,@IdBoleto,@num9)

		If(@TipoApuesta>=10)
		Insert into NumeroBoleto(IdSorteo,IdBoleto,Numero)
		values(@IdSorteo,@IdBoleto,@num10)

		If(@TipoApuesta=11)
		Insert into NumeroBoleto(IdSorteo,IdBoleto,Numero)
		values(@IdSorteo,@IdBoleto,@num11)
	End
	Else
	Begin
		raiserror ('Error, no puede introducir números repetidos',16,1)
	End
End
go

--Implementar restricciones
--Mediante restricciones check y triggers, asegurate de que se cumplen las siguientes reglas
--No se puede insertar un boleto si queda menos de una hora para el sorteo. Tampoco para sorteos que ya hayan tenido lugar
--Una vez insertado un boleto, no se pueden modificar sus números
--Todos los números están comprendido entre 1 y 49
--En las apuestas no se repiten números
--Las apuestas sencillas tienen seis números
--Las apuestas múltiples tienen5, 7, 8, 9, 10 u 11 números


--Pruebas de rendimiento
--Realiza inserciones de 10.000, 100.000, 500.000 y 1.000.000 de boletos y mide el tiempo y el tamaño de la base de datos
--Anota los resultados en este formulario (uno por grupo)


--Premios
--Modifica la base de datos para que, una vez realizado el sorteo, se pueda asignar a cada boleto la cantidad ganada. 
--Para ello, crea un procedimiento AsignarPremios que calcule los premios de cada boleto y lo guarde en la base de datos.
--Para saber cómo se asignan los premios, debes seguir las instrucciones de este documento, en especial el Capítulo V del Título I 
--(págs 7, 8, 9 y 10) y la tabla de la instrucción 21.4 (pág 14).
