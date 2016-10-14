Use Master
If Not Exists(Select * from dbo.sysdatabases where name='PrimitivaJavi')
	BEGIN
	Create Database PrimitivaJavi
	END
GO
Use PrimitivaJavi
Create table Sorteos(
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
Create table Boletos(
	IdBoleto bigint not null, --No pongo identity porque el id del boleto se repetirá en diferentes sorteos
	IdSorteo bigint not null,
	Reintegro tinyint not null,
	TipoApuesta tinyint not null    /**En esta columna guardaremos la cantidad de números que vamos a seleccionar*/
	constraint PK_Boletos Primary key (IdBoleto,IdSorteo),
	constraint FK_BoletosSorteos Foreign key (IdSorteo) references Sorteos(IdSorteo) on Update cascade on delete no action
	)
go
Create table NumerosBoletos(
	IdSorteo bigint not null,
	IdBoleto bigint not null,
	Numero tinyint not null,
	constraint PK_NumerosBoletos Primary key (IdSorteo,IdBoleto,Numero),
	constraint FK_NumerosBoletos_boletos Foreign key (IdBoleto,IdSorteo) references Boletos(IdBoleto,IdSorteo)
		on Update cascade on Delete no action
	)

