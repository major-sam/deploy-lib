# Временное решение
# Выполняется скрипт переноса настроек из UniRu в UniAdministration
# Удалить после обновления бэкапа UniRu и создания бэкапа UniAdministration

Import-module '.\scripts\sideFunctions.psm1'

$Dbname =  "UniRu"
$q_unicom218 = "
PRINT N'Migrating data from UniRu to UniAdministration';
GO

/*----FAQ----*/
PRINT N'Move DATA [content].[Categories]';
GO

SET IDENTITY_INSERT [UniAdministration].[content].[AccountCategories] ON
INSERT INTO [UniAdministration].[content].[AccountCategories](Id, Text, Value)
SELECT Id, Text, Value FROM [content].[AccountCategories];
SET IDENTITY_INSERT [UniAdministration].[content].[AccountCategories] OFF
GO

SET IDENTITY_INSERT [UniAdministration].[content].[WidgetTemplates] ON
INSERT INTO [UniAdministration].[content].[WidgetTemplates](Id, Template)
SELECT Id, Template FROM [content].[WidgetTemplates];
SET IDENTITY_INSERT [UniAdministration].[content].[WidgetTemplates] OFF
GO

PRINT N'Move DATA [content].[Categories]';
GO

SET IDENTITY_INSERT [UniAdministration].[content].[Categories] ON
INSERT INTO [UniAdministration].[content].[Categories](Id, CreatedOn, CreatedBy, Path, HelpVisible, HelpOrder, CanDeleted, SiteVisibility)
SELECT Id, CreatedOn, CreatedBy, Path, HelpVisible, HelpOrder, CanDeleted, 1 as SiteVisibility FROM [content].[Categories];
SET IDENTITY_INSERT [UniAdministration].[content].[Categories] OFF
GO

PRINT N'Move DATA [content].[CategoryLocalizations]';
GO
INSERT INTO [UniAdministration].[content].[CategoryLocalizations](Id, LanguageId, Title)
SELECT [Id], 1 as [LanguageId], [Title] FROM [content].[Categories];
GO

PRINT N'Move DATA [content].[Faqs]';
GO
SET IDENTITY_INSERT [UniAdministration].[content].[Faqs] ON
INSERT INTO [UniAdministration].[content].[Faqs](Id, CreatedOn, CreatedBy, HelpVisible, HelpOrder, CategoryId)
SELECT Id, CreatedOn, CreatedBy, HelpVisible, HelpOrder, CategoryId FROM [content].[Faqs];
SET IDENTITY_INSERT [UniAdministration].[content].[Faqs] OFF
GO

PRINT N'Move DATA [content].[FaqVersions]';
GO
INSERT INTO [UniAdministration].[content].[FaqVersions]([Id]
      ,[Version]
      ,[AccountCategoryId]
      ,[ActiveVersion]
      ,[Alias]
      ,[Top]
      ,[WidgetImage]
      ,[TemplateId]
      ,[MetaDescription]
      ,[MetaKeywords]
      ,[CreatedOn]
      ,[CreatedBy]
      ,[ModifiedOn]
      ,[ModifiedBy]
      ,[PublishOn]
      ,[PublishBy]
      ,[HideOn]
      ,[HideBy]
      ,[ViewTabs]
      ,[ShowOn]
      ,[SiteVisibility])
SELECT [Id]
      ,[Version]
      ,[AccountCategoryId]
      ,[ActiveVersion]
      ,[Alias]
      ,[Top]
      ,[WidgetImage]
      ,[TemplateId]
      ,[MetaDescription]
      ,[MetaKeywords]
      ,[CreatedOn]
      ,[CreatedBy]
      ,[ModifiedOn]
      ,[ModifiedBy]
      ,[PublishOn]
      ,[PublishBy]
      ,[HideOn]
      ,[HideBy]
      ,[ViewTabs]
      ,[ShowOn]
      ,[SiteVisibilityId] FROM [content].[FaqVersions]
      WHERE ActiveVersion = 1;
GO

UPDATE [UniAdministration].[content].[FaqVersions] SET [SiteVisibility] = 7 WHERE [SiteVisibility] = 2;
GO

PRINT N'Move DATA [content].[FaqLocalizations]';
GO
INSERT INTO [UniAdministration].[content].[FaqLocalizations]
SELECT 
	c.Id, 
	c.Version, 
	1 as [LanguageId], 
	Title, 
	Body, 
	BodyRaw, 
	WidgetBody, 
	WidgetText 
FROM [content].[FaqVersions] c
INNER JOIN (
	SELECT Id, MAX(Version) as Version 
	FROM content.FaqVersions 
	WHERE ActiveVersion = 1 
	GROUP BY Id, Version) v 
ON c.Id = v.Id AND c.Version = v.Version
GO

/*----NEWS----*/
PRINT N'Move DATA [News]';
GO
SET IDENTITY_INSERT [UniAdministration].[content].[News] ON
INSERT INTO [UniAdministration].[content].[News](Id, CreatedOn, CreatedBy)
SELECT Id, CreatedOn, CreatedBy FROM [content].[News];
SET IDENTITY_INSERT [UniAdministration].[content].[News] OFF
GO

PRINT N'Move DATA [content].[NewsVersions]';
GO
INSERT INTO [UniAdministration].[content].[NewsVersions]([Id]
      ,[Version]
      ,[AccountCategoryId]
      ,[ActiveVersion]
      ,[Alias]
      ,[MetaDescription]
      ,[MetaKeywords]
      ,[CreatedOn]
      ,[CreatedBy]
      ,[ModifiedOn]
      ,[ModifiedBy]
      ,[PublishOn]
      ,[PublishBy]
      ,[HideOn]
      ,[HideBy]
      ,[ShowOn]
      ,[SiteVisibility])
SELECT [Id]
      ,[Version]
      ,[AccountCategoryId]
      ,[ActiveVersion]
      ,[Alias]
      ,[MetaDescription]
      ,[MetaKeywords]
      ,[CreatedOn]
      ,[CreatedBy]
      ,[ModifiedOn]
      ,[ModifiedBy]
      ,[PublishOn]
      ,[PublishBy]
      ,[HideOn]
      ,[HideBy]
      ,[ShowOn]
      ,[SiteVisibilityId] FROM [content].[NewsVersions]
      WHERE ActiveVersion = 1;
GO

UPDATE [UniAdministration].[content].[NewsVersions] SET [SiteVisibility] = 7 WHERE [SiteVisibility] = 2;
GO

PRINT N'Move DATA [content].[NewsLocalizations]';
GO
INSERT INTO [UniAdministration].[content].[NewsLocalizations]
SELECT 
	c.Id, 
	c.Version, 
	1 as [LanguageId], 
	Title, 
	Body, 
	BodyRaw
FROM [content].[NewsVersions] c
INNER JOIN (
	SELECT Id, MAX(Version) as Version 
	FROM content.NewsVersions 
	WHERE ActiveVersion = 1 
	GROUP BY Id, Version) v 
ON c.Id = v.Id AND c.Version = v.Version
GO

/*-----PROMOTIONS------*/
PRINT N'Move DATA [Promotions]';
GO
SET IDENTITY_INSERT [UniAdministration].[content].[Promotions] ON
INSERT INTO [UniAdministration].[content].[Promotions](Id, CreatedOn)
SELECT Id, CreatedOn FROM [content].[Promotions];
SET IDENTITY_INSERT [UniAdministration].[content].[Promotions] OFF
GO

PRINT N'Move DATA [content].[PromotionsVersions]';
GO
INSERT INTO [UniAdministration].[content].[PromotionsVersions]([Id]
      ,[Version]
      ,[ActiveVersion]
      ,[Title]
      ,[Alias]
      ,[MetaDescription]
      ,[MetaKeywords]
      ,[CreatedOn]
      ,[CreatedBy]
      ,[ModifiedOn]
      ,[ModifiedBy]
      ,[PublishOn]
      ,[PublishBy]
      ,[HideOn]
      ,[HideBy]
      ,[ShowOn]
      ,[UniqueUTMMark]
      ,[IsDefault]
      ,[EventId]
      ,[IsActive]
      ,[SiteVisibility])
SELECT [Id]
      ,[Version]
      ,[ActiveVersion]
      ,[Title]
      ,[Alias]
      ,[MetaDescription]
      ,[MetaKeywords]
      ,[CreatedOn]
      ,[CreatedBy]
      ,[ModifiedOn]
      ,[ModifiedBy]
      ,[PublishOn]
      ,[PublishBy]
      ,[HideOn]
      ,[HideBy]
      ,[ShowOn]
      ,[UniqueUTMMark]
      ,[IsDefault]
      ,[EventId]
      ,[IsActive]
      ,[SiteVisibilityId] FROM [content].[PromotionsVersions]
      WHERE ActiveVersion = 1;
GO

UPDATE [UniAdministration].[content].[PromotionsVersions] SET [SiteVisibility] = 7 WHERE [SiteVisibility] = 2;
GO

PRINT N'Move DATA [content].[PromotionPromocodes]';
GO
INSERT INTO [UniAdministration].[content].[PromotionPromocodes]
SELECT [PromotionsVersionId]
      ,[PromotionsVersion]
      ,[PromocodeId]
      ,[Promocode]
      ,[BackgroundImage]
      ,[Pictogram]
FROM [content].[PromotionPromocodes] c
INNER JOIN (select Id, max(Version) as Version 
	from content.[PromotionsVersions] 
	where ActiveVersion = 1 
	group by Id, Version) v 
on c.[PromotionsVersionId] = v.Id and c.[PromotionsVersion] = v.Version
GO


PRINT N'Move DATA [content].[PromotionPromocodeLocalizations]';
GO
INSERT INTO [UniAdministration].[content].[PromotionPromocodeLocalizations]
SELECT [PromotionsVersionId]
      ,[PromotionsVersion]
      ,[PromocodeId]
      ,1 as [LanguageId]
      ,[Title]
      ,[BodyRawAdaptive]
      ,[BodyRaw]
FROM [content].[PromotionPromocodes] c
INNER JOIN (select Id, max(Version) as Version 
	from content.[PromotionsVersions] 
	where ActiveVersion = 1 
	group by Id, Version) v 
on c.[PromotionsVersionId] = v.Id and c.[PromotionsVersion] = v.Version
GO

/*-----SETTINGS----*/
PRINT N'Move DATA [Settings].[SiteOptionsGroups]';
GO
SET IDENTITY_INSERT [UniAdministration].[Settings].[SiteOptionsGroups] ON
INSERT INTO [UniAdministration].[Settings].[SiteOptionsGroups]([Id],[Instance],[ParentId])
SELECT * FROM [Settings].[SiteOptionsGroups]
SET IDENTITY_INSERT [UniAdministration].[Settings].[SiteOptionsGroups] OFF
GO

PRINT N'Move DATA [Settings].[SiteOptions]';
GO
SET IDENTITY_INSERT [UniAdministration].[Settings].[SiteOptions] ON
INSERT INTO [UniAdministration].[Settings].[SiteOptions]([Id],[GroupId],[Name],[Value],[IsInherited])
SELECT * FROM [Settings].[SiteOptions]
SET IDENTITY_INSERT [UniAdministration].[Settings].[SiteOptions] OFF
GO

PRINT N'Data migration completed.';
GO

DROP TABLE content.FaqVersions;
DROP TABLE content.Faqs;
DROP TABLE content.NewsVersions;
DROP TABLE content.News;
DROP TABLE content.PromotionPromocodes;
DROP TABLE content.PromotionsVersions
DROP TABLE content.Promotions;
DROP TABLE content.SiteVisibilities;
DROP TABLE content.WidgetTemplates;
DROP TABLE content.Categories;
DROP TABLE content.AccountCategories;
DROP TABLE Settings.SiteOptions;
DROP TABLE Settings.SiteOptionsGroups;
DROP SCHEMA content;
DROP SCHEMA Settings;

/* Add Russian as default localization language. */
PRINT N'Add Russian as default localization language.';
GO

INSERT INTO [UniAdministration].[Settings].[SiteOptions]([GroupId], [Name], [Value], [IsInherited]) VALUES(1, N'Global.Localization.Languages[0].Language', N'Russian', 0);
INSERT INTO [UniAdministration].[Settings].[SiteOptions]([GroupId], [Name], [Value], [IsInherited]) VALUES(1, N'Global.Localization.Languages[0].Name', N'Russian', 0);
INSERT INTO [UniAdministration].[Settings].[SiteOptions]([GroupId], [Name], [Value], [IsInherited]) VALUES(1, N'Global.Localization.Languages[0].KernelId', N'1', 0);
INSERT INTO [UniAdministration].[Settings].[SiteOptions]([GroupId], [Name], [Value], [IsInherited]) VALUES(1, N'Global.Localization.Languages[0].ShortName', N'ru', 0);
INSERT INTO [UniAdministration].[Settings].[SiteOptions]([GroupId], [Name], [Value], [IsInherited]) VALUES(1, N'Global.Localization.Languages[0].IsDefault', N'true', 0);
"

Invoke-Sqlcmd -verbose -QueryTimeout 720 -ServerInstance $env:COMPUTERNAME -Database $Dbname -Query $q_unicom218 -ErrorAction continue