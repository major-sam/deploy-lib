USE BaltBetM
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;

GO

IF SCHEMA_ID(N'ActivityService') IS NULL EXEC(N'CREATE SCHEMA [ActivityService];');

GO

CREATE TABLE [ActivityService].[Activities] (
    [ActivityRequestId] nvarchar(32) NOT NULL,
    [ActivityTypeName] nvarchar(418) NOT NULL,
    [ActivityJson] nvarchar(max) NOT NULL,
    [DataJson] nvarchar(max) NULL,
    [DataVersion] tinyint NOT NULL,
    [AttemptedCount] int NOT NULL,
    [CreatedDateUtc] datetime2 NOT NULL,
    [NextAttemptDateUtc] datetime2 NULL,
    [LastAttemptDateUtc] datetime2 NULL,
    [LastAttemptError] nvarchar(max) NULL,
    [Interval] nvarchar(64) NOT NULL,
    [DueDateUtc] datetime2 NULL,
    CONSTRAINT [PK_Activities] PRIMARY KEY ([ActivityRequestId], [ActivityTypeName])
);

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20200324075735_Initial', N'3.1.2');

GO
