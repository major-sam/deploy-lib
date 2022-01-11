GO
PRINT N'Creating Table [dbo].[OperCashBookRequests]...';


GO
CREATE TABLE [dbo].[OperCashBookRequests] (
    [Id]            BIGINT             IDENTITY (1, 1) NOT NULL,
    [BetPointId]    BIGINT             NOT NULL,
    [DateTime]      DATETIMEOFFSET (7) NOT NULL,
    [Balance]       DECIMAL (18, 2)    NOT NULL,
    [PersonId]      BIGINT             NOT NULL,
    [Status]        TINYINT            NOT NULL,
    [StatusComment] NVARCHAR (MAX)     NULL,
    CONSTRAINT [PK_OperCashBookRequests] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Index [dbo].[OperCashBookRequests].[IX_PersonId]...';


GO
CREATE NONCLUSTERED INDEX [IX_PersonId]
    ON [dbo].[OperCashBookRequests]([PersonId] ASC);


GO
PRINT N'Creating Index [dbo].[OperCashBookRequests].[IX_BetPointId]...';


GO
CREATE NONCLUSTERED INDEX [IX_BetPointId]
    ON [dbo].[OperCashBookRequests]([BetPointId] ASC);


GO
PRINT N'Update complete.';