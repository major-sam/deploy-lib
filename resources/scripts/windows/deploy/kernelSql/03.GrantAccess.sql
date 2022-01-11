USE BaltBetM
GO
SET QUOTED_IDENTIFIER ON
GO
--Сбросить пароль на пробел:
UPDATE WORKERS SET WorkerPassword = '29077aa9749cf2d34fb50c1589b1b68c',WorkerPasswordDate = NULL WHERE WorkerId NOT IN (49,57,1833,4047,4114,6766,6767)
--Выдать все права отделу IT:
INSERT INTO WorkerRights(WorkerRightId, WorkerId, RightId)
SELECT
(SELECT MAX(WorkerRightId) FROM WorkerRights) + ROW_NUMBER() over (ORDER BY Rights.RightId), Workers.WorkerId, Rights.RightId
FROM Workers
CROSS APPLY Rights
LEFT OUTER JOIN WorkerRights ON WorkerRights.RightId = Rights.RightId AND WorkerRights.WORKERID = Workers.WorkerId
WHERE Workers.RightTypeId = 80 AND WorkerRights.WorkerRightId IS NULL
--Дать доступ ко всем ППС отделу IT:
INSERT INTO WorkerClientsBind(WorkerClientsBindId, WorkerId, ClientId)
SELECT
(SELECT MAX(WorkerClientsBindId) FROM WorkerClientsBind) + ROW_NUMBER() over (ORDER BY Clients.ClientID), Workers.WorkerId, Clients.ClientID
FROM Clients
CROSS APPLY Workers
LEFT OUTER JOIN WorkerClientsBind ON WorkerClientsBind.WorkerID = Workers.WorkerId AND Clients.ClientID = WorkerClientsBind.ClientId
WHERE Workers.RightTypeId = 80 AND WorkerClientsBind.WorkerClientsBindId IS NULL
--Выдача администраторских прав отделу IT:
UPDATE workers SET RightTypeId = 1 WHERE RightTypeId = 80
--Открыть все ППС (кроме сербских) и выдать им дефолтные значения ККМ:
UPDATE Clients
SET Status = 0, AcceptGoods = 1, KKMNumber = '1234567', EKLZNumber = '1234567'
WHERE ClientRegionId != 13
--Добавить по 10 карт лояльности на каждый ППС:
DECLARE goods_cursor CURSOR READ_ONLY
FOR SELECT ClientId FROM Clients
DECLARE @ClientId int
DECLARE @GoodId int
DECLARE @GoodPlacementId int
OPEN goods_cursor
FETCH NEXT FROM goods_cursor INTO @ClientId
WHILE @@FETCH_STATUS <> -1
BEGIN
    SELECT @GoodId = ISNULL(MAX(GoodId),0)+1 FROM Goods
    INSERT INTO Goods(GoodId, GoodTypeId, GoodCategoryId, Price, ItemWeight, Comment, Vat)
    VALUES (@GoodId, 14, NULL, 0, 1, '', 0)
    SELECT @GoodPlacementId = ISNULL(MAX(GoodPlacementId),0)+1 FROM GoodPlacements
    INSERT INTO GoodPlacements(GoodPlacementId, GoodId, ClientId, WorkerId, Quantity, Comment, Valid, Status)
    VALUES (@GoodPlacementId, @GoodId, @ClientId, NULL, 10, '', 1, 2)
	FETCH NEXT FROM goods_cursor INTO @ClientId
END
CLOSE goods_cursor
DEALLOCATE goods_cursor
