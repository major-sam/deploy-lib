/*Скрипт очистки таблиц с платежами и подмены ExchangeId */ 

USE BaltBetM
GO
SET QUOTED_IDENTIFIER ON
GO

delete from [BaltBetM].[dbo].[Exchange]
delete from [BaltBetM].[Payments].[PaymentRequests]


DECLARE @MinValue int = 10000000
DECLARE @MaxValue int = 90000000
DECLARE @ExchangeId int = RAND()*(@MaxValue - @MinValue) + @MinValue

INSERT INTO [BaltBetM].[dbo].[Exchange]
VALUES(@ExchangeId, 2, NULL, NULL, 1, GETDATE(), 0, 0, NULL, NULL, GETDATE(), NULL, 0, 57, NULL, NULL, 0, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)

INSERT INTO [BaltBetM].[Payments].[PaymentRequests]
VALUES(@ExchangeId, NEWID(), 845, 110, NEWID(), 10, 130, 10, GETDATE(), NULL, 1, 643, 1, 0, NULL, NULL, NULL, NULL, 10, NULL, 1, 0, NULL, NULL, NULL, DEFAULT, NULL, NULL, NULL, 0, GETDATE(), NULL, NULL,0)