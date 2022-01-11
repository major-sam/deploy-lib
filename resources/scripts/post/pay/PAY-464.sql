IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

IF SCHEMA_ID(N'balancing') IS NULL EXEC(N'CREATE SCHEMA [balancing];');
GO

CREATE TABLE [balancing].[ChannelItems] (
    [Id] int NOT NULL IDENTITY,
    [Channel] smallint NOT NULL,
    [Name] nvarchar(max) NULL,
    [PersistedVersion] rowversion NULL,
    [CreationTimestamp] datetime2 NOT NULL DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_ChannelItems] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [balancing].[CurrencyItems] (
    [Id] int NOT NULL IDENTITY,
    [Currency] smallint NOT NULL,
    [Name] nvarchar(max) NULL,
    [PersistedVersion] rowversion NULL,
    [CreationTimestamp] datetime2 NOT NULL DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_CurrencyItems] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [balancing].[IntentItems] (
    [Id] int NOT NULL IDENTITY,
    [Intent] tinyint NOT NULL,
    [Name] nvarchar(max) NULL,
    [PersistedVersion] rowversion NULL,
    [CreationTimestamp] datetime2 NOT NULL DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_IntentItems] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [balancing].[Journals] (
    [Id] int NOT NULL IDENTITY,
    [Name] nvarchar(max) NULL,
    [CreationTimestamp] datetime2 NOT NULL DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_Journals] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [balancing].[JournalItems] (
    [Id] bigint NOT NULL IDENTITY,
    [CreationTimestamp] datetime2 NOT NULL DEFAULT (SYSUTCDATETIME()),
    [JournalId] int NOT NULL,
    [Payload] nvarchar(max) NULL,
    CONSTRAINT [PK_JournalItems] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_JournalItems_Journals_JournalId] FOREIGN KEY ([JournalId]) REFERENCES [balancing].[Journals] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [balancing].[Zones] (
    [Id] int NOT NULL IDENTITY,
    [JournalId] int NULL,
    [Enabled] bit NOT NULL,
    [Name] nvarchar(max) NULL,
    [Token] nvarchar(max) NULL,
    [PersistedVersion] rowversion NULL,
    [CreationTimestamp] datetime2 NOT NULL DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_Zones] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Zones_Journals_JournalId] FOREIGN KEY ([JournalId]) REFERENCES [balancing].[Journals] ([Id]) ON DELETE NO ACTION
);
GO

CREATE TABLE [balancing].[BalancingSets] (
    [Id] int NOT NULL IDENTITY,
    [ZoneId] int NOT NULL,
    [CurrencyId] int NOT NULL,
    [IntentId] int NOT NULL,
    [ChannelId] int NOT NULL,
    [JournalId] int NOT NULL,
    [Enabled] bit NOT NULL,
    [PersistedVersion] rowversion NULL,
    [CreationTimestamp] datetime2 NOT NULL DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_BalancingSets] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_BalancingSets_ChannelItems_ChannelId] FOREIGN KEY ([ChannelId]) REFERENCES [balancing].[ChannelItems] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_BalancingSets_CurrencyItems_CurrencyId] FOREIGN KEY ([CurrencyId]) REFERENCES [balancing].[CurrencyItems] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_BalancingSets_IntentItems_IntentId] FOREIGN KEY ([IntentId]) REFERENCES [balancing].[IntentItems] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_BalancingSets_Journals_JournalId] FOREIGN KEY ([JournalId]) REFERENCES [balancing].[Journals] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_BalancingSets_Zones_ZoneId] FOREIGN KEY ([ZoneId]) REFERENCES [balancing].[Zones] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [balancing].[Providers] (
    [Id] int NOT NULL IDENTITY,
    [ZoneId] int NOT NULL,
    [JournalId] int NOT NULL,
    [Enabled] bit NOT NULL,
    [Name] nvarchar(max) NULL,
    [ExternalClientId] int NOT NULL,
    [IntentItemId] int NOT NULL,
    [PersistedVersion] rowversion NULL,
    [CreationTimestamp] datetime2 NOT NULL DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_Providers] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Providers_IntentItems_IntentItemId] FOREIGN KEY ([IntentItemId]) REFERENCES [balancing].[IntentItems] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_Providers_Journals_JournalId] FOREIGN KEY ([JournalId]) REFERENCES [balancing].[Journals] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Providers_Zones_ZoneId] FOREIGN KEY ([ZoneId]) REFERENCES [balancing].[Zones] ([Id]) ON DELETE NO ACTION
);
GO

CREATE TABLE [balancing].[BalancingLevels] (
    [Id] int NOT NULL IDENTITY,
    [BalancingSetId] int NOT NULL,
    [JournalId] int NOT NULL,
    [Level] int NOT NULL,
    [Enabled] bit NOT NULL,
    [PersistedVersion] rowversion NULL,
    [CreationTimestamp] datetime2 NOT NULL DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_BalancingLevels] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_BalancingLevels_BalancingSets_BalancingSetId] FOREIGN KEY ([BalancingSetId]) REFERENCES [balancing].[BalancingSets] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_BalancingLevels_Journals_JournalId] FOREIGN KEY ([JournalId]) REFERENCES [balancing].[Journals] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [balancing].[BalancingProviders] (
    [BalancingSetId] int NOT NULL,
    [ProviderId] int NOT NULL,
    [CreationTimestamp] datetime2 NOT NULL DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_BalancingProviders] PRIMARY KEY ([BalancingSetId], [ProviderId]),
    CONSTRAINT [FK_BalancingProviders_BalancingSets_BalancingSetId] FOREIGN KEY ([BalancingSetId]) REFERENCES [balancing].[BalancingSets] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_BalancingProviders_Providers_ProviderId] FOREIGN KEY ([ProviderId]) REFERENCES [balancing].[Providers] ([Id]) ON DELETE NO ACTION
);
GO

CREATE TABLE [balancing].[ProviderChannels] (
    [ChannelItemId] int NOT NULL,
    [ProviderId] int NOT NULL,
    [CreationTimestamp] datetime2 NOT NULL DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_ProviderChannels] PRIMARY KEY ([ChannelItemId], [ProviderId]),
    CONSTRAINT [FK_ProviderChannels_ChannelItems_ChannelItemId] FOREIGN KEY ([ChannelItemId]) REFERENCES [balancing].[ChannelItems] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_ProviderChannels_Providers_ProviderId] FOREIGN KEY ([ProviderId]) REFERENCES [balancing].[Providers] ([Id]) ON DELETE NO ACTION
);
GO

CREATE TABLE [balancing].[BalancingTimeIntervals] (
    [Id] int NOT NULL IDENTITY,
    [BalancingSetId] int NOT NULL,
    [BalancingLevelId] int NOT NULL,
    [JournalId] int NOT NULL,
    [From] datetime2 NOT NULL,
    [To] datetime2 NULL,
    [PersistedVersion] rowversion NULL,
    [CreationTimestamp] datetime2 NOT NULL DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_BalancingTimeIntervals] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_BalancingTimeIntervals_BalancingLevels_BalancingLevelId] FOREIGN KEY ([BalancingLevelId]) REFERENCES [balancing].[BalancingLevels] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_BalancingTimeIntervals_BalancingSets_BalancingSetId] FOREIGN KEY ([BalancingSetId]) REFERENCES [balancing].[BalancingSets] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_BalancingTimeIntervals_Journals_JournalId] FOREIGN KEY ([JournalId]) REFERENCES [balancing].[Journals] ([Id]) ON DELETE NO ACTION
);
GO

CREATE TABLE [balancing].[BalancingAmountIntervals] (
    [Id] int NOT NULL IDENTITY,
    [BalancingSetId] int NOT NULL,
    [TimeIntervalId] int NOT NULL,
    [JournalId] int NOT NULL,
    [From] bigint NOT NULL,
    [To] bigint NULL,
    [PersistedVersion] rowversion NULL,
    [CreationTimestamp] datetime2 NOT NULL DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_BalancingAmountIntervals] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_BalancingAmountIntervals_BalancingSets_BalancingSetId] FOREIGN KEY ([BalancingSetId]) REFERENCES [balancing].[BalancingSets] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_BalancingAmountIntervals_BalancingTimeIntervals_TimeIntervalId] FOREIGN KEY ([TimeIntervalId]) REFERENCES [balancing].[BalancingTimeIntervals] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_BalancingAmountIntervals_Journals_JournalId] FOREIGN KEY ([JournalId]) REFERENCES [balancing].[Journals] ([Id]) ON DELETE NO ACTION
);
GO

CREATE TABLE [balancing].[BalancingWeights] (
    [Id] int NOT NULL IDENTITY,
    [BalancingSetId] int NOT NULL,
    [AmountIntervalId] int NOT NULL,
    [ProviderId] int NOT NULL,
    [Weight] int NOT NULL,
    [Locked] bit NOT NULL,
    [PersistedVersion] rowversion NULL,
    [CreationTimestamp] datetime2 NOT NULL DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_BalancingWeights] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_BalancingWeights_BalancingAmountIntervals_AmountIntervalId] FOREIGN KEY ([AmountIntervalId]) REFERENCES [balancing].[BalancingAmountIntervals] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_BalancingWeights_BalancingSets_BalancingSetId] FOREIGN KEY ([BalancingSetId]) REFERENCES [balancing].[BalancingSets] ([Id]) ON DELETE NO ACTION
);
GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Channel', N'Name') AND [object_id] = OBJECT_ID(N'[balancing].[ChannelItems]'))
    SET IDENTITY_INSERT [balancing].[ChannelItems] ON;
INSERT INTO [balancing].[ChannelItems] ([Id], [Channel], [Name])
VALUES (1, CAST(10 AS smallint), N'WM'),
(33, CAST(270 AS smallint), N'TerminalYandex'),
(34, CAST(271 AS smallint), N'TerminalTelepay'),
(36, CAST(290 AS smallint), N'Ru2Com'),
(37, CAST(300 AS smallint), N'TerminalPskb'),
(38, CAST(310 AS smallint), N'Monetix'),
(39, CAST(320 AS smallint), N'Steam'),
(40, CAST(330 AS smallint), N'Ecopayz'),
(41, CAST(340 AS smallint), N'Jeton'),
(42, CAST(350 AS smallint), N'SkinPay'),
(43, CAST(360 AS smallint), N'ApplePay'),
(44, CAST(370 AS smallint), N'RoyalPayVoucher'),
(45, CAST(380 AS smallint), N'VKPay'),
(46, CAST(390 AS smallint), N'TerminalVtb'),
(47, CAST(400 AS smallint), N'GrataPayVoucher'),
(48, CAST(410 AS smallint), N'CardMastercard'),
(49, CAST(420 AS smallint), N'Piastrix'),
(50, CAST(430 AS smallint), N'Card_Visa_IK'),
(51, CAST(440 AS smallint), N'Card_MC_IK'),
(52, CAST(450 AS smallint), N'Exbase'),
(53, CAST(460 AS smallint), N'Card_IK'),
(54, CAST(470 AS smallint), N'Card_Cypix'),
(55, CAST(480 AS smallint), N'Card_IK_New'),
(56, CAST(490 AS smallint), N'Card_SettlePay'),
(57, CAST(500 AS smallint), N'Card_Armax'),
(58, CAST(510 AS smallint), N'Card_MoneyM'),
(59, CAST(520 AS smallint), N'Card_AliumPay'),
(60, CAST(530 AS smallint), N'Card_CardPartner'),
(32, CAST(260 AS smallint), N'TerminalHandybank'),
(31, CAST(250 AS smallint), N'TerminalComepay'),
(35, CAST(280 AS smallint), N'Com2Ru'),
(29, CAST(230 AS smallint), N'TerminalMegafon'),
(2, CAST(20 AS smallint), N'Comepay'),
(3, CAST(30 AS smallint), N'Contact24'),
(4, CAST(40 AS smallint), N'YandexMoney'),
(5, CAST(50 AS smallint), N'Card'),
(6, CAST(60 AS smallint), N'TerminalElecsnet'),
(7, CAST(70 AS smallint), N'SberbankOnline'),
(8, CAST(80 AS smallint), N'AlfaClick'),
(9, CAST(90 AS smallint), N'PromSvyazBank'),
(10, CAST(100 AS smallint), N'Mobile'),
(11, CAST(110 AS smallint), N'Neteller');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Channel', N'Name') AND [object_id] = OBJECT_ID(N'[balancing].[ChannelItems]'))
    SET IDENTITY_INSERT [balancing].[ChannelItems] OFF;
GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Channel', N'Name') AND [object_id] = OBJECT_ID(N'[balancing].[ChannelItems]'))
    SET IDENTITY_INSERT [balancing].[ChannelItems] ON;
INSERT INTO [balancing].[ChannelItems] ([Id], [Channel], [Name])
VALUES (30, CAST(240 AS smallint), N'TerminalNovoplat'),
(13, CAST(130 AS smallint), N'QiwiWallet'),
(14, CAST(140 AS smallint), N'Pskb'),
(15, CAST(150 AS smallint), N'Mts'),
(12, CAST(120 AS smallint), N'EasyPay'),
(17, CAST(170 AS smallint), N'Beeline'),
(28, CAST(220 AS smallint), N'TerminalContact'),
(27, CAST(210 AS smallint), N'TerminalSvaznoy'),
(16, CAST(160 AS smallint), N'Tele2'),
(25, CAST(204 AS smallint), N'TerminalBeeline'),
(24, CAST(203 AS smallint), N'TerminalEuroPlat'),
(26, CAST(205 AS smallint), N'TerminalMts'),
(22, CAST(201 AS smallint), N'TerminalPochtaBank'),
(21, CAST(200 AS smallint), N'TerminalEuroset'),
(20, CAST(199 AS smallint), N'TerminalUnknown'),
(19, CAST(190 AS smallint), N'QiwiPush'),
(18, CAST(180 AS smallint), N'Megafon'),
(23, CAST(202 AS smallint), N'TerminalMkb');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Channel', N'Name') AND [object_id] = OBJECT_ID(N'[balancing].[ChannelItems]'))
    SET IDENTITY_INSERT [balancing].[ChannelItems] OFF;
GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Currency', N'Name') AND [object_id] = OBJECT_ID(N'[balancing].[CurrencyItems]'))
    SET IDENTITY_INSERT [balancing].[CurrencyItems] ON;
INSERT INTO [balancing].[CurrencyItems] ([Id], [Currency], [Name])
VALUES (5, CAST(978 AS smallint), N'EUR'),
(1, CAST(643 AS smallint), N'RUB'),
(2, CAST(840 AS smallint), N'USD'),
(3, CAST(844 AS smallint), N'AZN'),
(4, CAST(860 AS smallint), N'UZS'),
(6, CAST(980 AS smallint), N'UAH');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Currency', N'Name') AND [object_id] = OBJECT_ID(N'[balancing].[CurrencyItems]'))
    SET IDENTITY_INSERT [balancing].[CurrencyItems] OFF;
GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Intent', N'Name') AND [object_id] = OBJECT_ID(N'[balancing].[IntentItems]'))
    SET IDENTITY_INSERT [balancing].[IntentItems] ON;
INSERT INTO [balancing].[IntentItems] ([Id], [Intent], [Name])
VALUES (2, CAST(30 AS tinyint), N'Payout'),
(1, CAST(10 AS tinyint), N'Invoice');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Intent', N'Name') AND [object_id] = OBJECT_ID(N'[balancing].[IntentItems]'))
    SET IDENTITY_INSERT [balancing].[IntentItems] OFF;
GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Name') AND [object_id] = OBJECT_ID(N'[balancing].[Journals]'))
    SET IDENTITY_INSERT [balancing].[Journals] ON;
INSERT INTO [balancing].[Journals] ([Id], [Name])
VALUES (1, N'Zone Com-Site');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Name') AND [object_id] = OBJECT_ID(N'[balancing].[Journals]'))
    SET IDENTITY_INSERT [balancing].[Journals] OFF;
GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Enabled', N'JournalId', N'Name', N'Token') AND [object_id] = OBJECT_ID(N'[balancing].[Zones]'))
    SET IDENTITY_INSERT [balancing].[Zones] ON;
INSERT INTO [balancing].[Zones] ([Id], [Enabled], [JournalId], [Name], [Token])
VALUES (1, CAST(1 AS bit), 1, N'Com-Site', N'');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Enabled', N'JournalId', N'Name', N'Token') AND [object_id] = OBJECT_ID(N'[balancing].[Zones]'))
    SET IDENTITY_INSERT [balancing].[Zones] OFF;
GO

CREATE INDEX [IX_BalancingAmountIntervals_BalancingSetId] ON [balancing].[BalancingAmountIntervals] ([BalancingSetId]);
GO

CREATE INDEX [IX_BalancingAmountIntervals_JournalId] ON [balancing].[BalancingAmountIntervals] ([JournalId]);
GO

CREATE INDEX [IX_BalancingAmountIntervals_TimeIntervalId] ON [balancing].[BalancingAmountIntervals] ([TimeIntervalId]);
GO

CREATE INDEX [IX_BalancingLevels_BalancingSetId] ON [balancing].[BalancingLevels] ([BalancingSetId]);
GO

CREATE INDEX [IX_BalancingLevels_JournalId] ON [balancing].[BalancingLevels] ([JournalId]);
GO

CREATE INDEX [IX_BalancingProviders_ProviderId] ON [balancing].[BalancingProviders] ([ProviderId]);
GO

CREATE INDEX [IX_BalancingSets_ChannelId] ON [balancing].[BalancingSets] ([ChannelId]);
GO

CREATE UNIQUE INDEX [IX_BalancingSets_CurrencyId_IntentId_ChannelId] ON [balancing].[BalancingSets] ([CurrencyId], [IntentId], [ChannelId]);
GO

CREATE INDEX [IX_BalancingSets_IntentId] ON [balancing].[BalancingSets] ([IntentId]);
GO

CREATE INDEX [IX_BalancingSets_JournalId] ON [balancing].[BalancingSets] ([JournalId]);
GO

CREATE INDEX [IX_BalancingSets_ZoneId] ON [balancing].[BalancingSets] ([ZoneId]);
GO

CREATE INDEX [IX_BalancingTimeIntervals_BalancingLevelId] ON [balancing].[BalancingTimeIntervals] ([BalancingLevelId]);
GO

CREATE INDEX [IX_BalancingTimeIntervals_BalancingSetId] ON [balancing].[BalancingTimeIntervals] ([BalancingSetId]);
GO

CREATE INDEX [IX_BalancingTimeIntervals_JournalId] ON [balancing].[BalancingTimeIntervals] ([JournalId]);
GO

CREATE INDEX [IX_BalancingWeights_AmountIntervalId] ON [balancing].[BalancingWeights] ([AmountIntervalId]);
GO

CREATE INDEX [IX_BalancingWeights_BalancingSetId] ON [balancing].[BalancingWeights] ([BalancingSetId]);
GO

CREATE INDEX [IX_JournalItems_JournalId] ON [balancing].[JournalItems] ([JournalId]);
GO

CREATE INDEX [IX_ProviderChannels_ProviderId] ON [balancing].[ProviderChannels] ([ProviderId]);
GO

CREATE INDEX [IX_Providers_IntentItemId] ON [balancing].[Providers] ([IntentItemId]);
GO

CREATE INDEX [IX_Providers_JournalId] ON [balancing].[Providers] ([JournalId]);
GO

CREATE INDEX [IX_Providers_ZoneId] ON [balancing].[Providers] ([ZoneId]);
GO

CREATE INDEX [IX_Zones_JournalId] ON [balancing].[Zones] ([JournalId]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20211118140055_init', N'5.0.8');
GO

COMMIT;
GO

