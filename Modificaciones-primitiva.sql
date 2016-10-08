--Premios
Use PrimitivaJavi
--Modifica la base de datos para que, una vez realizado el sorteo, se pueda asignar a cada boleto la cantidad ganada.
Alter table Boleto add Premios smallmoney null

--Para ello, crea un procedimiento AsignarPremios que calcule los premios de cada boleto y lo guarde en la base de datos.
--Para saber cómo se asignan los premios, debes seguir las instrucciones de este documento, en especial el Capítulo V del Título I 
--(págs 7, 8, 9 y 10) y la tabla de la instrucción 21.4 (pág 14).
Go
Create Procedure AsignarPremios as
Begin
	/*Primero tenemos que saber cuanto se ha recaudado, para ello contaremos el número de apuestas y las multiplicaremos por su coste*/
	declare @tipo5 int,@tipo6 int,@tipo7 int,@tipo8 int
	declare @tipo9 int, @tipo10 int,@tipo11 int,@total int
	declare @total5 int,@total6 int,@total7 int,@total8 int
	declare @total9 int,@total10 int,@total11 int,@total12 int

	Select @tipo5=count(TipoApuesta) from Boleto where TipoApuesta=5
	Select @tipo6=count(TipoApuesta) from Boleto where TipoApuesta=6
	Select @tipo7=count(TipoApuesta) from Boleto where TipoApuesta=7
	Select @tipo8=count(TipoApuesta) from Boleto where TipoApuesta=8
	Select @tipo9=count(TipoApuesta) from Boleto where TipoApuesta=9
	Select @tipo10=count(TipoApuesta) from Boleto where TipoApuesta=10
	Select @tipo11=count(TipoApuesta) from Boleto where TipoApuesta=11

	set @total5=44*@tipo5
	set @total6=1*@tipo6
	set @total7=7*@tipo7
	set @total8=28*@tipo8
	set @total9=84*@tipo9
	set @total10=210*@tipo10
	set @total11=462*@tipo11
	set @total=@total5+@total6+@total7+@total8+@total9+@total10+@total11


End

