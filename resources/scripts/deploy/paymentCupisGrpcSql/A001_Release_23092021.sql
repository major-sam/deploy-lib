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

CREATE TABLE [PaymentRequests] (
    [Id] bigint NOT NULL IDENTITY,
    [RequestId] nvarchar(128) NOT NULL,
    [CreateDateUtc] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
    [Amount] decimal(18,2) NOT NULL,
    [CurrencyCode] int NOT NULL,
    [Intent] int NOT NULL,
    [ChannelId] int NOT NULL,
    [State] int NOT NULL,
    [FinishDateUtc] datetime2 NULL,
    CONSTRAINT [PK_PaymentRequests] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [KernelPaymentInfos] (
    [Id] bigint NOT NULL IDENTITY,
    [PaymentRequestId] bigint NOT NULL,
    [ExchangeId] bigint NOT NULL,
    [ExchangeUid] uniqueidentifier NOT NULL,
    CONSTRAINT [PK_KernelPaymentInfos] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_KernelPaymentInfos_PaymentRequests_PaymentRequestId] FOREIGN KEY ([PaymentRequestId]) REFERENCES [PaymentRequests] ([Id]) ON DELETE NO ACTION
);
GO

CREATE TABLE [PaymentsAdditionalData] (
    [Id] bigint NOT NULL IDENTITY,
    [PaymentRequestId] bigint NOT NULL,
    [InitialRequestDataJson] nvarchar(max) NOT NULL,
    CONSTRAINT [PK_PaymentsAdditionalData] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_PaymentsAdditionalData_PaymentRequests_PaymentRequestId] FOREIGN KEY ([PaymentRequestId]) REFERENCES [PaymentRequests] ([Id]) ON DELETE NO ACTION
);
GO

CREATE UNIQUE INDEX [IX_KernelPaymentInfos_ExchangeId] ON [KernelPaymentInfos] ([ExchangeId]);
GO

CREATE INDEX [IX_KernelPaymentInfos_ExchangeUid] ON [KernelPaymentInfos] ([ExchangeUid]);
GO

CREATE UNIQUE INDEX [IX_KernelPaymentInfos_PaymentRequestId] ON [KernelPaymentInfos] ([PaymentRequestId]);
GO

CREATE INDEX [IX_PaymentRequests_ChannelId] ON [PaymentRequests] ([ChannelId]);
GO

CREATE INDEX [IX_PaymentRequests_CreateDateUtc] ON [PaymentRequests] ([CreateDateUtc]);
GO

CREATE INDEX [IX_PaymentRequests_Intent] ON [PaymentRequests] ([Intent]);
GO

CREATE UNIQUE INDEX [IX_PaymentRequests_RequestId] ON [PaymentRequests] ([RequestId]);
GO

CREATE INDEX [IX_PaymentRequests_State] ON [PaymentRequests] ([State]);
GO

CREATE UNIQUE INDEX [IX_PaymentsAdditionalData_PaymentRequestId] ON [PaymentsAdditionalData] ([PaymentRequestId]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210921134927_1', N'5.0.9');
GO

COMMIT;
GO

