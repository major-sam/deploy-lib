-- Вносим игры в бд фотона. Временный костыль - если фотон тронется с места, надо будет дорабатывать 
insert into PhotonServer.dbo.GameTypes (Name, RelativePath, ClassName, MinBetValue, MaxBetValue, IsEnabled)
values ('RockClimberSlots', 'PhotonServer.Slots.dll', 'PhotonServer.Slots.SlotGame', 0.1, 100, 1)

-- Вносим данные обо всех играх из базы фотона в базу кернел веба. 
-- Сделано с заделом на будущее, если фотон вдруг продолжат разрабатывать
DECLARE @counter INT
DECLARE @tableLength INT
DECLARE @gameId INT
DECLARE @gameName nvarchar(30)

DECLARE @cursor CURSOR
SET @cursor = CURSOR SCROLL
FOR SELECT Id, Name FROM PhotonServer.dbo.GameTypes
OPEN @cursor

SET @counter = 0
SET @tableLength = (SELECT COUNT(*) FROM PhotonServer.dbo.GameTypes)

WHILE @counter < @tableLength
BEGIN
    SET @counter = @counter + 1
    FETCH NEXT FROM @cursor INTO @gameId, @gameName
    INSERT INTO BaltBetWeb.dbo.SlotGameType(Id, Name)
        VALUES (@gameId, @gameName)
END
CLOSE @cursor
DEALLOCATE @cursor