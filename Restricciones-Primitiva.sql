
--Implementar restricciones
Use PrimitivaJavi

--Mediante restricciones check y triggers, asegurate de que se cumplen las siguientes reglas
--No se puede insertar un boleto si queda menos de una hora para el sorteo. Tampoco para sorteos que ya hayan tenido lugar


Go
Create Trigger InsertarBoletoInvalido ON Boletos After insert,Update AS
	declare @fechaSorteo smalldatetime
	select @fechaSorteo =FechaSorteo from Sorteos where (Select IdSorteo from inserted)=IdSorteo

	If(DateDiff(minute,Current_TimeStamp,@fechaSorteo)<60)
	Begin
		RollBack Transaction
	End 
Go

--Una vez insertado un boleto, no se pueden modificar sus n�meros

Create Trigger Tramposo ON NumerosBoletos for Update AS
Raiserror('No puedes pasar!!!',16,1)
rollback transaction
go


--Todos los n�meros est�n comprendido entre 1 y 49
Alter Table NumerosBoletos add constraint CK_NumerosValidos check (Numero between 1 and 49)
go

--En las apuestas no se repiten n�meros

/*Ya implementada en la base de datos mediante la inserci�n del n�mero en la primary key*/

--Las apuestas sencillas tienen seis n�meros
--Las apuestas m�ltiples tienen5, 7, 8, 9, 10 u 11 n�meros

/*Ya implementada en los diferentes procedimientos*/


