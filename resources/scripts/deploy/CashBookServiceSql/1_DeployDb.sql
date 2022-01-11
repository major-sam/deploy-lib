GO
USE CashBookService;


GO
PRINT N'Creating Schema [doc]...';


GO
CREATE SCHEMA [doc]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating Table [doc].[CashOutOrders]...';


GO
CREATE TABLE [doc].[CashOutOrders] (
    [Id] BIGINT NOT NULL,
    CONSTRAINT [PK_CashOutOrders] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Table [doc].[CashInOrders]...';


GO
CREATE TABLE [doc].[CashInOrders] (
    [Id] BIGINT NOT NULL,
    CONSTRAINT [PK_CashInOrders] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Table [doc].[CRReports]...';


GO
CREATE TABLE [doc].[CRReports] (
    [Id]                      BIGINT          NOT NULL,
    [SessionId]               INT             NOT NULL,
    [CashRegisterId]          BIGINT          NOT NULL,
    [BetWindowId]             BIGINT          NOT NULL,
    [OperatorId]              BIGINT          NOT NULL,
    [Type]                    TINYINT         NOT NULL,
    [Sale]                    DECIMAL (18, 2) NOT NULL,
    [CashSale]                DECIMAL (18, 2) NOT NULL,
    [AcquiringSale]           DECIMAL (18, 2) NOT NULL,
    [SaleCount]               INT             NOT NULL,
    [Purchase]                DECIMAL (18, 2) NOT NULL,
    [CashPurchase]            DECIMAL (18, 2) NOT NULL,
    [AcquiringPurchase]       DECIMAL (18, 2) NOT NULL,
    [PurchaseCount]           INT             NOT NULL,
    [SaleReturn]              DECIMAL (18, 2) NOT NULL,
    [CashSaleReturn]          DECIMAL (18, 2) NOT NULL,
    [AcquiringSaleReturn]     DECIMAL (18, 2) NOT NULL,
    [SaleReturnCount]         INT             NOT NULL,
    [PurchaseReturn]          DECIMAL (18, 2) NOT NULL,
    [CashPurchaseReturn]      DECIMAL (18, 2) NOT NULL,
    [AcquiringPurchaseReturn] DECIMAL (18, 2) NOT NULL,
    [PurchaseReturnCount]     INT             NOT NULL,
    [Income]                  DECIMAL (18, 2) NOT NULL,
    [IncomeCount]             INT             NOT NULL,
    [Outcome]                 DECIMAL (18, 2) NOT NULL,
    [OutcomeCount]            INT             NOT NULL,
    [Cash]                    DECIMAL (18, 2) NOT NULL,
    [TotalSale]               DECIMAL (18, 2) NOT NULL,
    [TotalPurchase]           DECIMAL (18, 2) NOT NULL,
    [IsTaxAudit]              BIT             NOT NULL,
    CONSTRAINT [PK_CRReports] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Index [doc].[CRReports].[IX_CRReports_OperatorId]...';


GO
CREATE NONCLUSTERED INDEX [IX_CRReports_OperatorId]
    ON [doc].[CRReports]([OperatorId] ASC);


GO
PRINT N'Creating Index [doc].[CRReports].[IX_CRReports_CashRegisterId]...';


GO
CREATE NONCLUSTERED INDEX [IX_CRReports_CashRegisterId]
    ON [doc].[CRReports]([CashRegisterId] ASC);


GO
PRINT N'Creating Index [doc].[CRReports].[IX_CRReports_BetWindowId]...';


GO
CREATE NONCLUSTERED INDEX [IX_CRReports_BetWindowId]
    ON [doc].[CRReports]([BetWindowId] ASC);


GO
PRINT N'Creating Table [doc].[CashOrders]...';


GO
CREATE TABLE [doc].[CashOrders] (
    [Id]                BIGINT          NOT NULL,
    [Sum]               DECIMAL (18, 2) NOT NULL,
    [DebitId]           BIGINT          NOT NULL,
    [CreditId]          BIGINT          NOT NULL,
    [BetPointId]        BIGINT          NOT NULL,
    [CashierId]         BIGINT          NULL,
    [PersonId]          BIGINT          NULL,
    [ChiefAccountantId] BIGINT          NULL,
    [BasisInfo]         NVARCHAR (MAX)  NULL,
    [ApplicationInfo]   NVARCHAR (MAX)  NULL,
    CONSTRAINT [PK_CashOrders] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Index [doc].[CashOrders].[IX_CashOrders_PersonId]...';


GO
CREATE NONCLUSTERED INDEX [IX_CashOrders_PersonId]
    ON [doc].[CashOrders]([PersonId] ASC);


GO
PRINT N'Creating Index [doc].[CashOrders].[IX_CashOrders_DebitId]...';


GO
CREATE NONCLUSTERED INDEX [IX_CashOrders_DebitId]
    ON [doc].[CashOrders]([DebitId] ASC);


GO
PRINT N'Creating Index [doc].[CashOrders].[IX_CashOrders_CreditId]...';


GO
CREATE NONCLUSTERED INDEX [IX_CashOrders_CreditId]
    ON [doc].[CashOrders]([CreditId] ASC);


GO
PRINT N'Creating Index [doc].[CashOrders].[IX_CashOrders_ChiefAccountantId]...';


GO
CREATE NONCLUSTERED INDEX [IX_CashOrders_ChiefAccountantId]
    ON [doc].[CashOrders]([ChiefAccountantId] ASC);


GO
PRINT N'Creating Index [doc].[CashOrders].[IX_CashOrders_CashierId]...';


GO
CREATE NONCLUSTERED INDEX [IX_CashOrders_CashierId]
    ON [doc].[CashOrders]([CashierId] ASC);


GO
PRINT N'Creating Index [doc].[CashOrders].[IX_CashOrders_BetPointId]...';


GO
CREATE NONCLUSTERED INDEX [IX_CashOrders_BetPointId]
    ON [doc].[CashOrders]([BetPointId] ASC);


GO
PRINT N'Creating Table [doc].[DocumentBases]...';


GO
CREATE TABLE [doc].[DocumentBases] (
    [Id]             BIGINT             IDENTITY (1, 1) NOT NULL,
    [DateTime]       DATETIMEOFFSET (7) NOT NULL,
    [Number]         INT                NULL,
    [IsRegistered]   BIT                NOT NULL,
    [IsTaxSubmitted] BIT                NOT NULL,
    [ParentId]       BIGINT             NULL,
    CONSTRAINT [PK_DocumentBases] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Index [doc].[DocumentBases].[IX_DocumentBases_ParentId]...';


GO
CREATE NONCLUSTERED INDEX [IX_DocumentBases_ParentId]
    ON [doc].[DocumentBases]([ParentId] ASC);


GO
PRINT N'Creating Table [dbo].[AccountingEntries]...';


GO
CREATE TABLE [dbo].[AccountingEntries] (
    [Id]                   BIGINT             IDENTITY (1, 1) NOT NULL,
    [DateTime]             DATETIMEOFFSET (7) NOT NULL,
    [DebitId]              BIGINT             NOT NULL,
    [CreditId]             BIGINT             NOT NULL,
    [DebitSubkonto1Value]  BIGINT             NULL,
    [CreditSubkonto1Value] BIGINT             NULL,
    [Sum]                  DECIMAL (18, 2)    NOT NULL,
    [RegistrarId]          BIGINT             NOT NULL,
    CONSTRAINT [PK_AccountingEntries] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Index [dbo].[AccountingEntries].[IX_AccountingEntries_RegistrarId]...';


GO
CREATE NONCLUSTERED INDEX [IX_AccountingEntries_RegistrarId]
    ON [dbo].[AccountingEntries]([RegistrarId] ASC);


GO
PRINT N'Creating Index [dbo].[AccountingEntries].[IX_AccountingEntries_DebitId]...';


GO
CREATE NONCLUSTERED INDEX [IX_AccountingEntries_DebitId]
    ON [dbo].[AccountingEntries]([DebitId] ASC);


GO
PRINT N'Creating Index [dbo].[AccountingEntries].[IX_AccountingEntries_CreditId]...';


GO
CREATE NONCLUSTERED INDEX [IX_AccountingEntries_CreditId]
    ON [dbo].[AccountingEntries]([CreditId] ASC);


GO
PRINT N'Creating Table [dbo].[Accounts]...';


GO
CREATE TABLE [dbo].[Accounts] (
    [Id]            BIGINT         NOT NULL,
    [Code]          NVARCHAR (MAX) NULL,
    [Name]          NVARCHAR (MAX) NULL,
    [ParentId]      BIGINT         NULL,
    [Subkonto1Id]   NVARCHAR (10)  NULL,
    [Discriminator] NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_Accounts] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Index [dbo].[Accounts].[IX_Accounts_Subkonto1Id]...';


GO
CREATE NONCLUSTERED INDEX [IX_Accounts_Subkonto1Id]
    ON [dbo].[Accounts]([Subkonto1Id] ASC);


GO
PRINT N'Creating Index [dbo].[Accounts].[IX_Accounts_ParentId]...';


GO
CREATE NONCLUSTERED INDEX [IX_Accounts_ParentId]
    ON [dbo].[Accounts]([ParentId] ASC);


GO
PRINT N'Creating Table [dbo].[BetCities]...';


GO
CREATE TABLE [dbo].[BetCities] (
    [Id]          BIGINT         NOT NULL,
    [Name]        NVARCHAR (100) NOT NULL,
    [BetOfficeId] BIGINT         NOT NULL,
    CONSTRAINT [PK_BetCities] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Index [dbo].[BetCities].[IX_BetCities_BetOfficeId]...';


GO
CREATE NONCLUSTERED INDEX [IX_BetCities_BetOfficeId]
    ON [dbo].[BetCities]([BetOfficeId] ASC);


GO
PRINT N'Creating Table [dbo].[BetDistricts]...';


GO
CREATE TABLE [dbo].[BetDistricts] (
    [Id]   BIGINT         NOT NULL,
    [Name] NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_BetDistricts] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Table [dbo].[BetOffices]...';


GO
CREATE TABLE [dbo].[BetOffices] (
    [Id]          BIGINT         NOT NULL,
    [Name]        NVARCHAR (100) NOT NULL,
    [BetRegionId] BIGINT         NOT NULL,
    CONSTRAINT [PK_BetOffices] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Index [dbo].[BetOffices].[IX_BetOffices_BetRegionId]...';


GO
CREATE NONCLUSTERED INDEX [IX_BetOffices_BetRegionId]
    ON [dbo].[BetOffices]([BetRegionId] ASC);


GO
PRINT N'Creating Table [dbo].[BetPointBalanceHistories]...';


GO
CREATE TABLE [dbo].[BetPointBalanceHistories] (
    [Id]       BIGINT             NOT NULL,
    [DateTime] DATETIMEOFFSET (7) NOT NULL,
    [Balance]  DECIMAL (18, 2)    NOT NULL,
    CONSTRAINT [PK_BetPointBalanceHistories] PRIMARY KEY CLUSTERED ([DateTime] ASC, [Id] ASC)
);


GO
PRINT N'Creating Index [dbo].[BetPointBalanceHistories].[IX_BetPointBalanceHistories_Id]...';


GO
CREATE NONCLUSTERED INDEX [IX_BetPointBalanceHistories_Id]
    ON [dbo].[BetPointBalanceHistories]([Id] ASC);


GO
PRINT N'Creating Table [dbo].[BetPointLimitHistories]...';


GO
CREATE TABLE [dbo].[BetPointLimitHistories] (
    [Id]       BIGINT             NOT NULL,
    [DateTime] DATETIMEOFFSET (7) NOT NULL,
    [Sum]      DECIMAL (18, 2)    NOT NULL,
    CONSTRAINT [PK_BetPointLimitHistories] PRIMARY KEY CLUSTERED ([Id] ASC, [DateTime] ASC)
);


GO
PRINT N'Creating Table [dbo].[BetPointPageNumbers]...';


GO
CREATE TABLE [dbo].[BetPointPageNumbers] (
    [Id]              BIGINT             NOT NULL,
    [DateTime]        DATETIMEOFFSET (7) NOT NULL,
    [PageNumber]      INT                NOT NULL,
    [PageCount]       INT                NOT NULL,
    [IsSubmitted]     BIT                NOT NULL,
    [IsFullAccounted] BIT                NOT NULL,
    CONSTRAINT [PK_BetPointPageNumbers] PRIMARY KEY CLUSTERED ([Id] ASC, [DateTime] ASC)
);


GO
PRINT N'Creating Table [dbo].[BetPoints]...';


GO
CREATE TABLE [dbo].[BetPoints] (
    [Id]        BIGINT         NOT NULL,
    [Name]      NVARCHAR (100) NOT NULL,
    [KPP]       NVARCHAR (MAX) NULL,
    [BetCityId] BIGINT         NOT NULL,
    CONSTRAINT [PK_BetPoints] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Index [dbo].[BetPoints].[IX_BetPoints_BetCityId]...';


GO
CREATE NONCLUSTERED INDEX [IX_BetPoints_BetCityId]
    ON [dbo].[BetPoints]([BetCityId] ASC);


GO
PRINT N'Creating Table [dbo].[BetRegions]...';


GO
CREATE TABLE [dbo].[BetRegions] (
    [Id]            BIGINT         NOT NULL,
    [Name]          NVARCHAR (100) NOT NULL,
    [BetDistrictId] BIGINT         NOT NULL,
    CONSTRAINT [PK_BetRegions] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Index [dbo].[BetRegions].[IX_BetRegions_BetDistrictId]...';


GO
CREATE NONCLUSTERED INDEX [IX_BetRegions_BetDistrictId]
    ON [dbo].[BetRegions]([BetDistrictId] ASC);


GO
PRINT N'Creating Table [dbo].[BetWindows]...';


GO
CREATE TABLE [dbo].[BetWindows] (
    [Id]         BIGINT         NOT NULL,
    [Name]       NVARCHAR (100) NOT NULL,
    [BetPointId] BIGINT         NOT NULL,
    CONSTRAINT [PK_BetWindows] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Index [dbo].[BetWindows].[IX_BetWindows_BetPointId]...';


GO
CREATE NONCLUSTERED INDEX [IX_BetWindows_BetPointId]
    ON [dbo].[BetWindows]([BetPointId] ASC);


GO
PRINT N'Creating Table [dbo].[CashRegisters]...';


GO
CREATE TABLE [dbo].[CashRegisters] (
    [Id]           BIGINT        IDENTITY (1, 1) NOT NULL,
    [SerialNumber] NVARCHAR (20) NOT NULL,
    CONSTRAINT [PK_CashRegisters] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Index [dbo].[CashRegisters].[IX_CashRegisters_SerialNumber]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_CashRegisters_SerialNumber]
    ON [dbo].[CashRegisters]([SerialNumber] ASC);


GO
PRINT N'Creating Table [dbo].[ManagerBetPoints]...';


GO
CREATE TABLE [dbo].[ManagerBetPoints] (
    [ManagerId]   BIGINT NOT NULL,
    [BetPointId]  BIGINT NOT NULL,
    [BetPointId1] BIGINT NULL,
    [ManagerId1]  BIGINT NULL,
    CONSTRAINT [PK_ManagerBetPoints] PRIMARY KEY CLUSTERED ([BetPointId] ASC, [ManagerId] ASC)
);


GO
PRINT N'Creating Index [dbo].[ManagerBetPoints].[IX_ManagerBetPoints_ManagerId1]...';


GO
CREATE NONCLUSTERED INDEX [IX_ManagerBetPoints_ManagerId1]
    ON [dbo].[ManagerBetPoints]([ManagerId1] ASC);


GO
PRINT N'Creating Index [dbo].[ManagerBetPoints].[IX_ManagerBetPoints_ManagerId]...';


GO
CREATE NONCLUSTERED INDEX [IX_ManagerBetPoints_ManagerId]
    ON [dbo].[ManagerBetPoints]([ManagerId] ASC);


GO
PRINT N'Creating Index [dbo].[ManagerBetPoints].[IX_ManagerBetPoints_BetPointId1]...';


GO
CREATE NONCLUSTERED INDEX [IX_ManagerBetPoints_BetPointId1]
    ON [dbo].[ManagerBetPoints]([BetPointId1] ASC);


GO
PRINT N'Creating Table [dbo].[Managers]...';


GO
CREATE TABLE [dbo].[Managers] (
    [Id] BIGINT NOT NULL,
    CONSTRAINT [PK_Managers] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Table [dbo].[PersonAdditionalAccounts]...';


GO
CREATE TABLE [dbo].[PersonAdditionalAccounts] (
    [Id]        BIGINT NOT NULL,
    [ParrentId] BIGINT NOT NULL,
    CONSTRAINT [PK_PersonAdditionalAccounts] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Index [dbo].[PersonAdditionalAccounts].[IX_PersonAdditionalAccounts_ParrentId]...';


GO
CREATE NONCLUSTERED INDEX [IX_PersonAdditionalAccounts_ParrentId]
    ON [dbo].[PersonAdditionalAccounts]([ParrentId] ASC);


GO
PRINT N'Creating Table [dbo].[Persons]...';


GO
CREATE TABLE [dbo].[Persons] (
    [Id]         BIGINT           NOT NULL,
    [Surname]    NVARCHAR (50)    NOT NULL,
    [Name]       NVARCHAR (50)    NOT NULL,
    [Patronymic] NVARCHAR (50)    NOT NULL,
    [Birthdate]  DATETIME2 (7)    NOT NULL,
    [Guid]       UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_Persons] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Index [dbo].[Persons].[IX_Guid]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Guid]
    ON [dbo].[Persons]([Guid] ASC);


GO
PRINT N'Creating Table [dbo].[Subkonto]...';


GO
CREATE TABLE [dbo].[Subkonto] (
    [Id]            NVARCHAR (10)  NOT NULL,
    [Name]          NVARCHAR (100) NULL,
    [Discriminator] NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_Subkonto] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Table [dbo].[TaxAuditCRReports]...';


GO
CREATE TABLE [dbo].[TaxAuditCRReports] (
    [Id] BIGINT NOT NULL,
    CONSTRAINT [PK_TaxAuditCRReports] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Foreign Key [doc].[FK_CashOutOrders_CashOrders_Id]...';


GO
ALTER TABLE [doc].[CashOutOrders] WITH NOCHECK
    ADD CONSTRAINT [FK_CashOutOrders_CashOrders_Id] FOREIGN KEY ([Id]) REFERENCES [doc].[CashOrders] ([Id]);


GO
PRINT N'Creating Foreign Key [doc].[FK_CashInOrders_CashOrders_Id]...';


GO
ALTER TABLE [doc].[CashInOrders] WITH NOCHECK
    ADD CONSTRAINT [FK_CashInOrders_CashOrders_Id] FOREIGN KEY ([Id]) REFERENCES [doc].[CashOrders] ([Id]);


GO
PRINT N'Creating Foreign Key [doc].[FK_CRReports_BetWindows_BetWindowId]...';


GO
ALTER TABLE [doc].[CRReports] WITH NOCHECK
    ADD CONSTRAINT [FK_CRReports_BetWindows_BetWindowId] FOREIGN KEY ([BetWindowId]) REFERENCES [dbo].[BetWindows] ([Id]);


GO
PRINT N'Creating Foreign Key [doc].[FK_CRReports_CashRegisters_CashRegisterId]...';


GO
ALTER TABLE [doc].[CRReports] WITH NOCHECK
    ADD CONSTRAINT [FK_CRReports_CashRegisters_CashRegisterId] FOREIGN KEY ([CashRegisterId]) REFERENCES [dbo].[CashRegisters] ([Id]);


GO
PRINT N'Creating Foreign Key [doc].[FK_CRReports_DocumentBases_Id]...';


GO
ALTER TABLE [doc].[CRReports] WITH NOCHECK
    ADD CONSTRAINT [FK_CRReports_DocumentBases_Id] FOREIGN KEY ([Id]) REFERENCES [doc].[DocumentBases] ([Id]);


GO
PRINT N'Creating Foreign Key [doc].[FK_CRReports_Persons_OperatorId]...';


GO
ALTER TABLE [doc].[CRReports] WITH NOCHECK
    ADD CONSTRAINT [FK_CRReports_Persons_OperatorId] FOREIGN KEY ([OperatorId]) REFERENCES [dbo].[Persons] ([Id]);


GO
PRINT N'Creating Foreign Key [doc].[FK_CashOrders_Accounts_CreditId]...';


GO
ALTER TABLE [doc].[CashOrders] WITH NOCHECK
    ADD CONSTRAINT [FK_CashOrders_Accounts_CreditId] FOREIGN KEY ([CreditId]) REFERENCES [dbo].[Accounts] ([Id]);


GO
PRINT N'Creating Foreign Key [doc].[FK_CashOrders_Accounts_DebitId]...';


GO
ALTER TABLE [doc].[CashOrders] WITH NOCHECK
    ADD CONSTRAINT [FK_CashOrders_Accounts_DebitId] FOREIGN KEY ([DebitId]) REFERENCES [dbo].[Accounts] ([Id]);


GO
PRINT N'Creating Foreign Key [doc].[FK_CashOrders_BetPoints_BetPointId]...';


GO
ALTER TABLE [doc].[CashOrders] WITH NOCHECK
    ADD CONSTRAINT [FK_CashOrders_BetPoints_BetPointId] FOREIGN KEY ([BetPointId]) REFERENCES [dbo].[BetPoints] ([Id]);


GO
PRINT N'Creating Foreign Key [doc].[FK_CashOrders_DocumentBases_Id]...';


GO
ALTER TABLE [doc].[CashOrders] WITH NOCHECK
    ADD CONSTRAINT [FK_CashOrders_DocumentBases_Id] FOREIGN KEY ([Id]) REFERENCES [doc].[DocumentBases] ([Id]);


GO
PRINT N'Creating Foreign Key [doc].[FK_CashOrders_Persons_CashierId]...';


GO
ALTER TABLE [doc].[CashOrders] WITH NOCHECK
    ADD CONSTRAINT [FK_CashOrders_Persons_CashierId] FOREIGN KEY ([CashierId]) REFERENCES [dbo].[Persons] ([Id]);


GO
PRINT N'Creating Foreign Key [doc].[FK_CashOrders_Persons_ChiefAccountantId]...';


GO
ALTER TABLE [doc].[CashOrders] WITH NOCHECK
    ADD CONSTRAINT [FK_CashOrders_Persons_ChiefAccountantId] FOREIGN KEY ([ChiefAccountantId]) REFERENCES [dbo].[Persons] ([Id]);


GO
PRINT N'Creating Foreign Key [doc].[FK_CashOrders_Persons_PersonId]...';


GO
ALTER TABLE [doc].[CashOrders] WITH NOCHECK
    ADD CONSTRAINT [FK_CashOrders_Persons_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Persons] ([Id]);


GO
PRINT N'Creating Foreign Key [doc].[FK_DocumentBases_DocumentBases_ParentId]...';


GO
ALTER TABLE [doc].[DocumentBases] WITH NOCHECK
    ADD CONSTRAINT [FK_DocumentBases_DocumentBases_ParentId] FOREIGN KEY ([ParentId]) REFERENCES [doc].[DocumentBases] ([Id]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_AccountingEntries_Accounts_CreditId]...';


GO
ALTER TABLE [dbo].[AccountingEntries] WITH NOCHECK
    ADD CONSTRAINT [FK_AccountingEntries_Accounts_CreditId] FOREIGN KEY ([CreditId]) REFERENCES [dbo].[Accounts] ([Id]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_AccountingEntries_Accounts_DebitId]...';


GO
ALTER TABLE [dbo].[AccountingEntries] WITH NOCHECK
    ADD CONSTRAINT [FK_AccountingEntries_Accounts_DebitId] FOREIGN KEY ([DebitId]) REFERENCES [dbo].[Accounts] ([Id]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_AccountingEntries_DocumentBases_RegistrarId]...';


GO
ALTER TABLE [dbo].[AccountingEntries] WITH NOCHECK
    ADD CONSTRAINT [FK_AccountingEntries_DocumentBases_RegistrarId] FOREIGN KEY ([RegistrarId]) REFERENCES [doc].[DocumentBases] ([Id]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_Accounts_Accounts_ParentId]...';


GO
ALTER TABLE [dbo].[Accounts] WITH NOCHECK
    ADD CONSTRAINT [FK_Accounts_Accounts_ParentId] FOREIGN KEY ([ParentId]) REFERENCES [dbo].[Accounts] ([Id]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_Accounts_Subkonto_Subkonto1Id]...';


GO
ALTER TABLE [dbo].[Accounts] WITH NOCHECK
    ADD CONSTRAINT [FK_Accounts_Subkonto_Subkonto1Id] FOREIGN KEY ([Subkonto1Id]) REFERENCES [dbo].[Subkonto] ([Id]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_BetCities_BetOffices_BetOfficeId]...';


GO
ALTER TABLE [dbo].[BetCities] WITH NOCHECK
    ADD CONSTRAINT [FK_BetCities_BetOffices_BetOfficeId] FOREIGN KEY ([BetOfficeId]) REFERENCES [dbo].[BetOffices] ([Id]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_BetOffices_BetRegions_BetRegionId]...';


GO
ALTER TABLE [dbo].[BetOffices] WITH NOCHECK
    ADD CONSTRAINT [FK_BetOffices_BetRegions_BetRegionId] FOREIGN KEY ([BetRegionId]) REFERENCES [dbo].[BetRegions] ([Id]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_BetPointBalanceHistories_BetPoints_Id]...';


GO
ALTER TABLE [dbo].[BetPointBalanceHistories] WITH NOCHECK
    ADD CONSTRAINT [FK_BetPointBalanceHistories_BetPoints_Id] FOREIGN KEY ([Id]) REFERENCES [dbo].[BetPoints] ([Id]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_BetPointLimitHistories_BetPoints_Id]...';


GO
ALTER TABLE [dbo].[BetPointLimitHistories] WITH NOCHECK
    ADD CONSTRAINT [FK_BetPointLimitHistories_BetPoints_Id] FOREIGN KEY ([Id]) REFERENCES [dbo].[BetPoints] ([Id]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_BetPointPageNumbers_BetPoints_Id]...';


GO
ALTER TABLE [dbo].[BetPointPageNumbers] WITH NOCHECK
    ADD CONSTRAINT [FK_BetPointPageNumbers_BetPoints_Id] FOREIGN KEY ([Id]) REFERENCES [dbo].[BetPoints] ([Id]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_BetPoints_BetCities_BetCityId]...';


GO
ALTER TABLE [dbo].[BetPoints] WITH NOCHECK
    ADD CONSTRAINT [FK_BetPoints_BetCities_BetCityId] FOREIGN KEY ([BetCityId]) REFERENCES [dbo].[BetCities] ([Id]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_BetRegions_BetDistricts_BetDistrictId]...';


GO
ALTER TABLE [dbo].[BetRegions] WITH NOCHECK
    ADD CONSTRAINT [FK_BetRegions_BetDistricts_BetDistrictId] FOREIGN KEY ([BetDistrictId]) REFERENCES [dbo].[BetDistricts] ([Id]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_BetWindows_BetPoints_BetPointId]...';


GO
ALTER TABLE [dbo].[BetWindows] WITH NOCHECK
    ADD CONSTRAINT [FK_BetWindows_BetPoints_BetPointId] FOREIGN KEY ([BetPointId]) REFERENCES [dbo].[BetPoints] ([Id]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_ManagerBetPoints_BetPoints_BetPointId]...';


GO
ALTER TABLE [dbo].[ManagerBetPoints] WITH NOCHECK
    ADD CONSTRAINT [FK_ManagerBetPoints_BetPoints_BetPointId] FOREIGN KEY ([BetPointId]) REFERENCES [dbo].[BetPoints] ([Id]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_ManagerBetPoints_BetPoints_BetPointId1]...';


GO
ALTER TABLE [dbo].[ManagerBetPoints] WITH NOCHECK
    ADD CONSTRAINT [FK_ManagerBetPoints_BetPoints_BetPointId1] FOREIGN KEY ([BetPointId1]) REFERENCES [dbo].[BetPoints] ([Id]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_ManagerBetPoints_Managers_ManagerId]...';


GO
ALTER TABLE [dbo].[ManagerBetPoints] WITH NOCHECK
    ADD CONSTRAINT [FK_ManagerBetPoints_Managers_ManagerId] FOREIGN KEY ([ManagerId]) REFERENCES [dbo].[Managers] ([Id]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_ManagerBetPoints_Managers_ManagerId1]...';


GO
ALTER TABLE [dbo].[ManagerBetPoints] WITH NOCHECK
    ADD CONSTRAINT [FK_ManagerBetPoints_Managers_ManagerId1] FOREIGN KEY ([ManagerId1]) REFERENCES [dbo].[Managers] ([Id]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_Managers_Persons_Id]...';


GO
ALTER TABLE [dbo].[Managers] WITH NOCHECK
    ADD CONSTRAINT [FK_Managers_Persons_Id] FOREIGN KEY ([Id]) REFERENCES [dbo].[Persons] ([Id]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_PersonAdditionalAccounts_Persons_ParrentId]...';


GO
ALTER TABLE [dbo].[PersonAdditionalAccounts] WITH NOCHECK
    ADD CONSTRAINT [FK_PersonAdditionalAccounts_Persons_ParrentId] FOREIGN KEY ([ParrentId]) REFERENCES [dbo].[Persons] ([Id]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_TaxAuditCRReports_CRReports_Id]...';


GO
ALTER TABLE [dbo].[TaxAuditCRReports] WITH NOCHECK
    ADD CONSTRAINT [FK_TaxAuditCRReports_CRReports_Id] FOREIGN KEY ([Id]) REFERENCES [doc].[CRReports] ([Id]);


GO
PRINT N'Checking existing data against newly created constraints';

GO
ALTER TABLE [doc].[CashOutOrders] WITH CHECK CHECK CONSTRAINT [FK_CashOutOrders_CashOrders_Id];

ALTER TABLE [doc].[CashInOrders] WITH CHECK CHECK CONSTRAINT [FK_CashInOrders_CashOrders_Id];

ALTER TABLE [doc].[CRReports] WITH CHECK CHECK CONSTRAINT [FK_CRReports_BetWindows_BetWindowId];

ALTER TABLE [doc].[CRReports] WITH CHECK CHECK CONSTRAINT [FK_CRReports_CashRegisters_CashRegisterId];

ALTER TABLE [doc].[CRReports] WITH CHECK CHECK CONSTRAINT [FK_CRReports_DocumentBases_Id];

ALTER TABLE [doc].[CRReports] WITH CHECK CHECK CONSTRAINT [FK_CRReports_Persons_OperatorId];

ALTER TABLE [doc].[CashOrders] WITH CHECK CHECK CONSTRAINT [FK_CashOrders_Accounts_CreditId];

ALTER TABLE [doc].[CashOrders] WITH CHECK CHECK CONSTRAINT [FK_CashOrders_Accounts_DebitId];

ALTER TABLE [doc].[CashOrders] WITH CHECK CHECK CONSTRAINT [FK_CashOrders_BetPoints_BetPointId];

ALTER TABLE [doc].[CashOrders] WITH CHECK CHECK CONSTRAINT [FK_CashOrders_DocumentBases_Id];

ALTER TABLE [doc].[CashOrders] WITH CHECK CHECK CONSTRAINT [FK_CashOrders_Persons_CashierId];

ALTER TABLE [doc].[CashOrders] WITH CHECK CHECK CONSTRAINT [FK_CashOrders_Persons_ChiefAccountantId];

ALTER TABLE [doc].[CashOrders] WITH CHECK CHECK CONSTRAINT [FK_CashOrders_Persons_PersonId];

ALTER TABLE [doc].[DocumentBases] WITH CHECK CHECK CONSTRAINT [FK_DocumentBases_DocumentBases_ParentId];

ALTER TABLE [dbo].[AccountingEntries] WITH CHECK CHECK CONSTRAINT [FK_AccountingEntries_Accounts_CreditId];

ALTER TABLE [dbo].[AccountingEntries] WITH CHECK CHECK CONSTRAINT [FK_AccountingEntries_Accounts_DebitId];

ALTER TABLE [dbo].[AccountingEntries] WITH CHECK CHECK CONSTRAINT [FK_AccountingEntries_DocumentBases_RegistrarId];

ALTER TABLE [dbo].[Accounts] WITH CHECK CHECK CONSTRAINT [FK_Accounts_Accounts_ParentId];

ALTER TABLE [dbo].[Accounts] WITH CHECK CHECK CONSTRAINT [FK_Accounts_Subkonto_Subkonto1Id];

ALTER TABLE [dbo].[BetCities] WITH CHECK CHECK CONSTRAINT [FK_BetCities_BetOffices_BetOfficeId];

ALTER TABLE [dbo].[BetOffices] WITH CHECK CHECK CONSTRAINT [FK_BetOffices_BetRegions_BetRegionId];

ALTER TABLE [dbo].[BetPointBalanceHistories] WITH CHECK CHECK CONSTRAINT [FK_BetPointBalanceHistories_BetPoints_Id];

ALTER TABLE [dbo].[BetPointLimitHistories] WITH CHECK CHECK CONSTRAINT [FK_BetPointLimitHistories_BetPoints_Id];

ALTER TABLE [dbo].[BetPointPageNumbers] WITH CHECK CHECK CONSTRAINT [FK_BetPointPageNumbers_BetPoints_Id];

ALTER TABLE [dbo].[BetPoints] WITH CHECK CHECK CONSTRAINT [FK_BetPoints_BetCities_BetCityId];

ALTER TABLE [dbo].[BetRegions] WITH CHECK CHECK CONSTRAINT [FK_BetRegions_BetDistricts_BetDistrictId];

ALTER TABLE [dbo].[BetWindows] WITH CHECK CHECK CONSTRAINT [FK_BetWindows_BetPoints_BetPointId];

ALTER TABLE [dbo].[ManagerBetPoints] WITH CHECK CHECK CONSTRAINT [FK_ManagerBetPoints_BetPoints_BetPointId];

ALTER TABLE [dbo].[ManagerBetPoints] WITH CHECK CHECK CONSTRAINT [FK_ManagerBetPoints_BetPoints_BetPointId1];

ALTER TABLE [dbo].[ManagerBetPoints] WITH CHECK CHECK CONSTRAINT [FK_ManagerBetPoints_Managers_ManagerId];

ALTER TABLE [dbo].[ManagerBetPoints] WITH CHECK CHECK CONSTRAINT [FK_ManagerBetPoints_Managers_ManagerId1];

ALTER TABLE [dbo].[Managers] WITH CHECK CHECK CONSTRAINT [FK_Managers_Persons_Id];

ALTER TABLE [dbo].[PersonAdditionalAccounts] WITH CHECK CHECK CONSTRAINT [FK_PersonAdditionalAccounts_Persons_ParrentId];

ALTER TABLE [dbo].[TaxAuditCRReports] WITH CHECK CHECK CONSTRAINT [FK_TaxAuditCRReports_CRReports_Id];


GO
PRINT N'Update complete.';


GO
