USE [BalancingDb]

GO
SET IDENTITY_INSERT [balancing].[Journals] ON 

INSERT [balancing].[Journals] ([Id], [Name], [CreationTimestamp]) VALUES (2, NULL, CAST(N'2022-02-07T10:49:04.8657397' AS DateTime2))
GO
INSERT [balancing].[Journals] ([Id], [Name], [CreationTimestamp]) VALUES (3, NULL, CAST(N'2022-02-07T10:49:23.7942038' AS DateTime2))
GO
INSERT [balancing].[Journals] ([Id], [Name], [CreationTimestamp]) VALUES (4, NULL, CAST(N'2022-02-07T10:49:30.8619976' AS DateTime2))
GO
INSERT [balancing].[Journals] ([Id], [Name], [CreationTimestamp]) VALUES (5, NULL, CAST(N'2022-02-07T10:49:30.8619976' AS DateTime2))
GO
INSERT [balancing].[Journals] ([Id], [Name], [CreationTimestamp]) VALUES (6, NULL, CAST(N'2022-02-07T10:49:30.8619976' AS DateTime2))
GO
INSERT [balancing].[Journals] ([Id], [Name], [CreationTimestamp]) VALUES (7, NULL, CAST(N'2022-02-07T10:49:30.8619976' AS DateTime2))
GO
INSERT [balancing].[Journals] ([Id], [Name], [CreationTimestamp]) VALUES (8, NULL, CAST(N'2022-02-07T10:49:30.8619976' AS DateTime2))
GO
INSERT [balancing].[Journals] ([Id], [Name], [CreationTimestamp]) VALUES (9, NULL, CAST(N'2022-02-07T10:49:30.8619976' AS DateTime2))
GO
INSERT [balancing].[Journals] ([Id], [Name], [CreationTimestamp]) VALUES (10, NULL, CAST(N'2022-02-07T10:49:30.8619976' AS DateTime2))
GO
INSERT [balancing].[Journals] ([Id], [Name], [CreationTimestamp]) VALUES (11, NULL, CAST(N'2022-02-07T10:49:30.8619976' AS DateTime2))
GO
INSERT [balancing].[Journals] ([Id], [Name], [CreationTimestamp]) VALUES (12, NULL, CAST(N'2022-02-07T10:49:30.8619976' AS DateTime2))
GO
INSERT [balancing].[Journals] ([Id], [Name], [CreationTimestamp]) VALUES (13, NULL, CAST(N'2022-02-07T10:49:30.8619976' AS DateTime2))
GO
INSERT [balancing].[Journals] ([Id], [Name], [CreationTimestamp]) VALUES (14, NULL, CAST(N'2022-02-07T10:50:19.0351782' AS DateTime2))
GO
INSERT [balancing].[Journals] ([Id], [Name], [CreationTimestamp]) VALUES (15, NULL, CAST(N'2022-02-07T10:50:19.0351782' AS DateTime2))
GO
INSERT [balancing].[Journals] ([Id], [Name], [CreationTimestamp]) VALUES (16, NULL, CAST(N'2022-02-07T10:50:19.0351782' AS DateTime2))
GO
INSERT [balancing].[Journals] ([Id], [Name], [CreationTimestamp]) VALUES (17, NULL, CAST(N'2022-02-07T10:50:19.0351782' AS DateTime2))
GO
INSERT [balancing].[Journals] ([Id], [Name], [CreationTimestamp]) VALUES (18, NULL, CAST(N'2022-02-07T10:50:19.0351782' AS DateTime2))
GO
INSERT [balancing].[Journals] ([Id], [Name], [CreationTimestamp]) VALUES (19, NULL, CAST(N'2022-02-07T10:50:19.0351782' AS DateTime2))
GO
INSERT [balancing].[Journals] ([Id], [Name], [CreationTimestamp]) VALUES (20, NULL, CAST(N'2022-02-07T10:50:19.0351782' AS DateTime2))
GO
INSERT [balancing].[Journals] ([Id], [Name], [CreationTimestamp]) VALUES (21, NULL, CAST(N'2022-02-07T10:50:19.0351782' AS DateTime2))
GO
INSERT [balancing].[Journals] ([Id], [Name], [CreationTimestamp]) VALUES (22, NULL, CAST(N'2022-02-07T10:50:19.0351782' AS DateTime2))
GO
INSERT [balancing].[Journals] ([Id], [Name], [CreationTimestamp]) VALUES (23, NULL, CAST(N'2022-02-07T10:50:19.0351782' AS DateTime2))
GO
SET IDENTITY_INSERT [balancing].[Journals] OFF
GO
SET IDENTITY_INSERT [balancing].[Providers] ON 
GO
INSERT [balancing].[Providers] ([Id], [ZoneId], [JournalId], [Enabled], [Name], [ExternalClientId], [IntentItemId], [CreationTimestamp]) VALUES (1, 1, 2, 1, N'PaymentPlanet (885)', 885, 1, CAST(N'2022-02-07T10:49:04.9077213' AS DateTime2))
GO
INSERT [balancing].[Providers] ([Id], [ZoneId], [JournalId], [Enabled], [Name], [ExternalClientId], [IntentItemId], [CreationTimestamp]) VALUES (2, 1, 3, 1, N'PaymentPlanet2 (886)', 886, 2, CAST(N'2022-02-07T10:49:23.7971966' AS DateTime2))
GO
SET IDENTITY_INSERT [balancing].[Providers] OFF
GO
INSERT [balancing].[ProviderCardMasks] ([ProviderId], [CardMaskId]) VALUES (2, 1)
GO
INSERT [balancing].[ProviderCardMasks] ([ProviderId], [CardMaskId]) VALUES (2, 2)
GO
INSERT [balancing].[ProviderCardMasks] ([ProviderId], [CardMaskId]) VALUES (2, 3)
GO
INSERT [balancing].[ProviderCardMasks] ([ProviderId], [CardMaskId]) VALUES (2, 4)
GO
SET IDENTITY_INSERT [balancing].[BalancingSets] ON 
GO
INSERT [balancing].[BalancingSets] ([Id], [ZoneId], [CurrencyId], [IntentId], [ChannelId], [JournalId], [Enabled], [CreationTimestamp]) VALUES (1, 1, 1, 1, 5, 4, 1, CAST(N'2022-02-07T10:49:30.8880112' AS DateTime2))
GO
INSERT [balancing].[BalancingSets] ([Id], [ZoneId], [CurrencyId], [IntentId], [ChannelId], [JournalId], [Enabled], [CreationTimestamp]) VALUES (2, 1, 1, 2, 5, 14, 1, CAST(N'2022-02-07T10:50:19.0422301' AS DateTime2))
GO
SET IDENTITY_INSERT [balancing].[BalancingSets] OFF
GO
INSERT [balancing].[ProviderChannels] ([ChannelItemId], [ProviderId], [CreationTimestamp]) VALUES (5, 1, CAST(N'2022-02-07T10:49:04.9297549' AS DateTime2))
GO
INSERT [balancing].[ProviderChannels] ([ChannelItemId], [ProviderId], [CreationTimestamp]) VALUES (5, 2, CAST(N'2022-02-07T10:49:23.8231914' AS DateTime2))
GO
SET IDENTITY_INSERT [balancing].[BalancingLevels] ON 
GO
INSERT [balancing].[BalancingLevels] ([Id], [BalancingSetId], [JournalId], [Level], [Enabled], [CreationTimestamp]) VALUES (1, 1, 5, 1, 1, CAST(N'2022-02-07T10:49:30.9120146' AS DateTime2))
GO
INSERT [balancing].[BalancingLevels] ([Id], [BalancingSetId], [JournalId], [Level], [Enabled], [CreationTimestamp]) VALUES (2, 1, 8, 2, 1, CAST(N'2022-02-07T10:49:30.9210049' AS DateTime2))
GO
INSERT [balancing].[BalancingLevels] ([Id], [BalancingSetId], [JournalId], [Level], [Enabled], [CreationTimestamp]) VALUES (3, 1, 11, 3, 1, CAST(N'2022-02-07T10:49:30.9229899' AS DateTime2))
GO
INSERT [balancing].[BalancingLevels] ([Id], [BalancingSetId], [JournalId], [Level], [Enabled], [CreationTimestamp]) VALUES (4, 2, 15, 1, 1, CAST(N'2022-02-07T10:50:19.0441772' AS DateTime2))
GO
INSERT [balancing].[BalancingLevels] ([Id], [BalancingSetId], [JournalId], [Level], [Enabled], [CreationTimestamp]) VALUES (5, 2, 18, 2, 1, CAST(N'2022-02-07T10:50:19.0451973' AS DateTime2))
GO
INSERT [balancing].[BalancingLevels] ([Id], [BalancingSetId], [JournalId], [Level], [Enabled], [CreationTimestamp]) VALUES (6, 2, 21, 3, 1, CAST(N'2022-02-07T10:50:19.0471975' AS DateTime2))
GO
SET IDENTITY_INSERT [balancing].[BalancingLevels] OFF
GO
SET IDENTITY_INSERT [balancing].[BalancingTimeIntervals] ON 
GO
INSERT [balancing].[BalancingTimeIntervals] ([Id], [BalancingSetId], [BalancingLevelId], [JournalId], [From], [To], [CreationTimestamp]) VALUES (1, 1, 1, 7, CAST(N'2022-02-07T00:00:00.0000000' AS DateTime2), NULL, CAST(N'2022-02-07T10:49:30.9451620' AS DateTime2))
GO
INSERT [balancing].[BalancingTimeIntervals] ([Id], [BalancingSetId], [BalancingLevelId], [JournalId], [From], [To], [CreationTimestamp]) VALUES (2, 1, 2, 10, CAST(N'2022-02-07T00:00:00.0000000' AS DateTime2), NULL, CAST(N'2022-02-07T10:49:30.9550616' AS DateTime2))
GO
INSERT [balancing].[BalancingTimeIntervals] ([Id], [BalancingSetId], [BalancingLevelId], [JournalId], [From], [To], [CreationTimestamp]) VALUES (3, 1, 3, 13, CAST(N'2022-02-07T00:00:00.0000000' AS DateTime2), NULL, CAST(N'2022-02-07T10:49:30.9569900' AS DateTime2))
GO
INSERT [balancing].[BalancingTimeIntervals] ([Id], [BalancingSetId], [BalancingLevelId], [JournalId], [From], [To], [CreationTimestamp]) VALUES (4, 2, 4, 17, CAST(N'2022-02-07T00:00:00.0000000' AS DateTime2), NULL, CAST(N'2022-02-07T10:50:19.0482058' AS DateTime2))
GO
INSERT [balancing].[BalancingTimeIntervals] ([Id], [BalancingSetId], [BalancingLevelId], [JournalId], [From], [To], [CreationTimestamp]) VALUES (5, 2, 5, 20, CAST(N'2022-02-07T00:00:00.0000000' AS DateTime2), NULL, CAST(N'2022-02-07T10:50:19.0491759' AS DateTime2))
GO
INSERT [balancing].[BalancingTimeIntervals] ([Id], [BalancingSetId], [BalancingLevelId], [JournalId], [From], [To], [CreationTimestamp]) VALUES (6, 2, 6, 23, CAST(N'2022-02-07T00:00:00.0000000' AS DateTime2), NULL, CAST(N'2022-02-07T10:50:19.0502381' AS DateTime2))
GO
SET IDENTITY_INSERT [balancing].[BalancingTimeIntervals] OFF
GO
SET IDENTITY_INSERT [balancing].[BalancingAmountIntervals] ON 
GO
INSERT [balancing].[BalancingAmountIntervals] ([Id], [BalancingSetId], [TimeIntervalId], [JournalId], [From], [To], [CreationTimestamp]) VALUES (1, 1, 1, 6, 0, NULL, CAST(N'2022-02-07T10:49:30.9759972' AS DateTime2))
GO
INSERT [balancing].[BalancingAmountIntervals] ([Id], [BalancingSetId], [TimeIntervalId], [JournalId], [From], [To], [CreationTimestamp]) VALUES (2, 1, 2, 9, 0, NULL, CAST(N'2022-02-07T10:49:30.9840081' AS DateTime2))
GO
INSERT [balancing].[BalancingAmountIntervals] ([Id], [BalancingSetId], [TimeIntervalId], [JournalId], [From], [To], [CreationTimestamp]) VALUES (3, 1, 3, 12, 0, NULL, CAST(N'2022-02-07T10:49:30.9859920' AS DateTime2))
GO
INSERT [balancing].[BalancingAmountIntervals] ([Id], [BalancingSetId], [TimeIntervalId], [JournalId], [From], [To], [CreationTimestamp]) VALUES (4, 2, 4, 16, 0, NULL, CAST(N'2022-02-07T10:50:19.0521881' AS DateTime2))
GO
INSERT [balancing].[BalancingAmountIntervals] ([Id], [BalancingSetId], [TimeIntervalId], [JournalId], [From], [To], [CreationTimestamp]) VALUES (5, 2, 5, 19, 0, NULL, CAST(N'2022-02-07T10:50:19.0531770' AS DateTime2))
GO
INSERT [balancing].[BalancingAmountIntervals] ([Id], [BalancingSetId], [TimeIntervalId], [JournalId], [From], [To], [CreationTimestamp]) VALUES (6, 2, 6, 22, 0, NULL, CAST(N'2022-02-07T10:50:19.0541760' AS DateTime2))
GO
SET IDENTITY_INSERT [balancing].[BalancingAmountIntervals] OFF
GO
INSERT [balancing].[BalancingProviders] ([BalancingSetId], [ProviderId], [CreationTimestamp]) VALUES (1, 1, CAST(N'2022-02-07T10:49:36.8588506' AS DateTime2))
GO
INSERT [balancing].[BalancingProviders] ([BalancingSetId], [ProviderId], [CreationTimestamp]) VALUES (2, 2, CAST(N'2022-02-07T10:50:22.8940830' AS DateTime2))
GO
SET IDENTITY_INSERT [balancing].[BalancingWeights] ON 
GO
INSERT [balancing].[BalancingWeights] ([Id], [BalancingSetId], [AmountIntervalId], [ProviderId], [Weight], [Locked], [CreationTimestamp]) VALUES (1, 1, 1, 1, 100, 0, CAST(N'2022-02-07T10:49:36.8798412' AS DateTime2))
GO
INSERT [balancing].[BalancingWeights] ([Id], [BalancingSetId], [AmountIntervalId], [ProviderId], [Weight], [Locked], [CreationTimestamp]) VALUES (2, 1, 2, 1, 100, 0, CAST(N'2022-02-07T10:49:36.8798412' AS DateTime2))
GO
INSERT [balancing].[BalancingWeights] ([Id], [BalancingSetId], [AmountIntervalId], [ProviderId], [Weight], [Locked], [CreationTimestamp]) VALUES (3, 1, 3, 1, 100, 0, CAST(N'2022-02-07T10:49:36.8798412' AS DateTime2))
GO
INSERT [balancing].[BalancingWeights] ([Id], [BalancingSetId], [AmountIntervalId], [ProviderId], [Weight], [Locked], [CreationTimestamp]) VALUES (4, 2, 4, 2, 100, 0, CAST(N'2022-02-07T10:50:22.8940830' AS DateTime2))
GO
INSERT [balancing].[BalancingWeights] ([Id], [BalancingSetId], [AmountIntervalId], [ProviderId], [Weight], [Locked], [CreationTimestamp]) VALUES (5, 2, 5, 2, 100, 0, CAST(N'2022-02-07T10:50:22.8940830' AS DateTime2))
GO
INSERT [balancing].[BalancingWeights] ([Id], [BalancingSetId], [AmountIntervalId], [ProviderId], [Weight], [Locked], [CreationTimestamp]) VALUES (6, 2, 6, 2, 100, 0, CAST(N'2022-02-07T10:50:22.8940830' AS DateTime2))
GO
SET IDENTITY_INSERT [balancing].[BalancingWeights] OFF
GO
