--Programaci�n parte 1

Use PrimitivaJavi

--Implementa un procedimiento almacenado GrabaSencilla que grabe una apuesta simple. Datos de entrada: El sorteo y los seis n�meros
go
Create PROCEDURE GrabaSencilla @IdSorteo bigint,
							   @num1 tinyint,@num2 tinyint,@num3 tinyint,@num4 tinyint,@num5 tinyint,@num6 tinyint,
							   @IdBoleto bigint OUTPUT as
Begin
SET NOCOUNT ON
	If(@num1<> @num2 and @num1<>@num3 and @num1<>@num4 and @num1<>@num5 and @num1<>@num6
		 and @num2<>@num3 and @num2<>@num4 and @num2<>@num5 and @num2<>@num6
		 and @num3<>@num4 and @num3<>@num5 and @num3<>@num6
		 and @num4<>@num5 and @num4<>@num6 
		 and @num5<>@num6)
	Begin
	
		--set @IdBoleto=NEWID() no vale
		Select @IdBoleto=max(IdBoleto)+1 from Boletos
		where IdSorteo=@IdSorteo

		if (@IdBoleto is null)
		Begin
			set @IdBoleto=1
		End
		declare @Reintegro tinyint
		set @Reintegro=ABS(checksum(NEWID()))%10

		declare @SeFastidio bit=0
		
		Begin Transaction
		Insert into Boletos(IdBoleto,IdSorteo,Reintegro,TipoApuesta)
		Values(@IdBoleto,@IdSorteo,@Reintegro,6)
		
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
		
		BEGIN TRY  
   		Insert into NumerosBoletos(IdSorteo,IdBoleto,Numero)
			Select IdSorteo,IdBoleto,Numero from @Numeros
		END TRY  
		BEGIN CATCH  
			SET @SeFastidio = 1
			ROLLBACK
		END CATCH
		IF @SeFastidio <> 1
			Commit Transaction
	End
	else
	Begin
		Raiserror('Error, los n�meros no pueden estar repetidos',16,1)
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

--Implementa un procedimiento almacenado GrabaMultiple que grabe una apuesta multiple. Datos de entrada: El sorteo y entre 5 y 11 n�meros
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

		Select Top 1 @IdBoleto=IdBoleto+1 from Boletos where IdSorteo=@IdSorteo
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
				
		Insert into Boletos(IdSorteo,IdBoleto,Reintegro,TipoApuesta)
		values(@IdSorteo,@IdBoleto,@Reintegro,@TipoApuesta)

		Insert into NumerosBoletos(IdSorteo,IdBoleto,Numero)
		values(@IdSorteo,@IdBoleto,@num1)

		Insert into NumerosBoletos(IdSorteo,IdBoleto,Numero)
		values(@IdSorteo,@IdBoleto,@num2)

		Insert into NumerosBoletos(IdSorteo,IdBoleto,Numero)
		values(@IdSorteo,@IdBoleto,@num3)

		Insert into NumerosBoletos(IdSorteo,IdBoleto,Numero)
		values(@IdSorteo,@IdBoleto,@num4)

		Insert into NumerosBoletos(IdSorteo,IdBoleto,Numero)
		values(@IdSorteo,@IdBoleto,@num5)

		If(@TipoApuesta>=6)
		Insert into NumerosBoletos(IdSorteo,IdBoleto,Numero)
		values(@IdSorteo,@IdBoleto,@num6)
		
		If(@TipoApuesta>=7)
		Insert into NumerosBoletos(IdSorteo,IdBoleto,Numero)
		values(@IdSorteo,@IdBoleto,@num7)

		If(@TipoApuesta>=8)
		Insert into NumerosBoletos(IdSorteo,IdBoleto,Numero)
		values(@IdSorteo,@IdBoleto,@num8)

		If(@TipoApuesta>=9)
		Insert into NumerosBoletos(IdSorteo,IdBoleto,Numero)
		values(@IdSorteo,@IdBoleto,@num9)

		If(@TipoApuesta>=10)
		Insert into NumerosBoletos(IdSorteo,IdBoleto,Numero)
		values(@IdSorteo,@IdBoleto,@num10)

		If(@TipoApuesta=11)
		Insert into NumerosBoletos(IdSorteo,IdBoleto,Numero)
		values(@IdSorteo,@IdBoleto,@num11)
	End
	Else
	Begin
		raiserror ('Error, no puede introducir n�meros repetidos',16,1)
	End
End
go