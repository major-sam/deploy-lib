BEGIN TRANSACTION;
GO

ALTER TABLE [PaymentsAdditionalData] ADD [PaymentPreviewDataJson] nvarchar(max) NULL;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210930100435_2', N'5.0.9');
GO

COMMIT;
GO

