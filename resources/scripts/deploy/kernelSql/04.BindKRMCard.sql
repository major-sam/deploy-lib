USE BaltBetM
GO
SET QUOTED_IDENTIFIER ON
GO
-- Добавить карту лояльности первому КРМ-аккаунту, который был сгенерирован после AccountGeneratorWithRealWallets (необходима для эмулятора КРМ)
DECLARE @AccountId int = (SELECT TOP 1 AccountId FROM BaltBetM.dbo.Accounts WHERE PlayerType = 0)
DECLARE @CardDate datetime = GETDATE()
UPDATE BaltBetM.dbo.Accounts
SET CardNumber = '8BA5D61B', CardAttachmentDate = @CardDate
WHERE AccountId = @AccountId
SET IDENTITY_INSERT BaltBetM.dbo.AccountCard ON
INSERT AccountCard (Id, AccountID, CardNumber, StateID, StateDate, PIN, EnterAttemptCount, Blocked, RecoveryAttemptCount)
VALUES (1, @AccountId, '8BA5D61B', 1, @CardDate, '0068', 0, 0, 0)
SET IDENTITY_INSERT BaltBetM.dbo.AccountCard OFF