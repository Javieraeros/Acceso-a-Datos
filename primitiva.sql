--Implementar restricciones
--Mediante restricciones check y triggers, asegurate de que se cumplen las siguientes reglas
--No se puede insertar un boleto si queda menos de una hora para el sorteo. Tampoco para sorteos que ya hayan tenido lugar
--Una vez insertado un boleto, no se pueden modificar sus n�meros
--Todos los n�meros est�n comprendido entre 1 y 49
--En las apuestas no se repiten n�meros
--Las apuestas sencillas tienen seis n�meros
--Las apuestas m�ltiples tienen5, 7, 8, 9, 10 u 11 n�meros


--Pruebas de rendimiento
--Realiza inserciones de 10.000, 100.000, 500.000 y 1.000.000 de boletos y mide el tiempo y el tama�o de la base de datos
--Anota los resultados en este formulario (uno por grupo)


--Premios
--Modifica la base de datos para que, una vez realizado el sorteo, se pueda asignar a cada boleto la cantidad ganada. 
--Para ello, crea un procedimiento AsignarPremios que calcule los premios de cada boleto y lo guarde en la base de datos.
--Para saber c�mo se asignan los premios, debes seguir las instrucciones de este documento, en especial el Cap�tulo V del T�tulo I 
--(p�gs 7, 8, 9 y 10) y la tabla de la instrucci�n 21.4 (p�g 14).


Use Master
If Not Exists(Select * from dbo.sysdatabases where name='Primitiva')
	BEGIN
	Create Database Primitiva
	END
GO
Use Primitiva
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
	IdBoleto bigint not null, --No pongo identity porque el id del boleto se repetir� en diferentes sorteos
	IdSorteo bigint not null,
	Reintegro tinyint not null,
	TipoApuesta tinyint not null    /**En esta columna guardaremos la cantidad de n�meros que vamos a seleccionar*/
	constraint PK_Boleto Primary key (IdBoleto,IdSorteo),
	constraint FK_BoletoSorteo Foreign key (IdSorteo) references Sorteo(IdSorteo) on Update cascade on delete no action
	)
go
Create table NumeroBoleto(
	IdSorteo bigint not null,
	IdBoleto bigint not null,
	Numero tinyint not null,
	constraint PK_NumeroBoleto Primary key (IdBoleto,Numero),
	constraint FK_NumeroBoleto_boleto Foreign key (IdBoleto,IdSorteo) references Boleto(IdBoleto,IdSorteo)
		on Update cascade on Delete no action
	)
Use Master
Drop database Primitiva
--Programaci�n parte 1

--Implementa un procedimiento almacenado GrabaSencilla que grabe una apuesta simple. Datos de entrada: El sorteo y los seis n�meros
--Implementa un procedimiento GrabaMuchasSencillas que genere n boletos con una apuesta sencilla utilizando el procedimiento GrabaSencilla.
--Datos de entrada: El sorteo y el valor de n
--Implementa un procedimiento almacenado GrabaMultiple que grabe una apuesta simple. Datos de entrada: El sorteo y entre 5 y 11 n�meros
go
CREATE PROCEDURE GrabaSencilla @IdSorteo bigint,
							   @num1 tinyint,@num2 tinyint,@num3 tinyint,@num4 tinyint,@num5 tinyint,@num6 tinyint,
							   @IdBoleto bigint OUTPUT as
Begin
	set @IdBoleto=NEWID()
	declare @Reintegro tinyint
	set @Reintegro=RAND()*10

	Insert into Boleto(IdBoleto,IdSorteo,Reintegro,TipoApuesta)
	Values(@IdBoleto,@IdSorteo,@Reintegro,6)

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

	--Crear trigger que elimine todos lso inserts de haber alg�n n�mero que se repita, es decir
	-- si no se han completado todos lso insert values
End
go

Insert into Sorteo(IdSorteo,

Execute GrabaSencilla 5, 1,2,3,4,5,6