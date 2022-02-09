USE [BalancingDb]
GO
--SET IDENTITY_INSERT [balancing].[CardMasks] ON 
--GO
----INSERT [balancing].[CardMasks] ([Id], [Name], [IssuerKey], [CreationTimestamp]) VALUES (1, N'Visa', N'Visa', CAST(N'2022-02-07T10:34:14.0899685' AS DateTime2))
----GO
----INSERT [balancing].[CardMasks] ([Id], [Name], [IssuerKey], [CreationTimestamp]) VALUES (2, N'Mastercard', N'Mastercard', CAST(N'2022-02-07T10:34:14.0899685' AS DateTime2))
----GO
----INSERT [balancing].[CardMasks] ([Id], [Name], [IssuerKey], [CreationTimestamp]) VALUES (3, N'MIR', N'MIR', CAST(N'2022-02-07T10:34:14.0899685' AS DateTime2))
----GO
--INSERT [balancing].[CardMasks] ([Id], [Name], [IssuerKey], [CreationTimestamp]) VALUES (4, N'Maestro', N'Maestro', CAST(N'2022-02-07T10:34:14.0899685' AS DateTime2))
--GO
--SET IDENTITY_INSERT [balancing].[CardMasks] OFF
GO
SET IDENTITY_INSERT [balancing].[IntentItems] ON 
GO
INSERT [balancing].[IntentItems] ([Id], [Intent], [Name], [CreationTimestamp]) VALUES (1, 10, N'PayIN', CAST(N'2022-02-07T10:34:14.3109688' AS DateTime2))
GO
INSERT [balancing].[IntentItems] ([Id], [Intent], [Name], [CreationTimestamp]) VALUES (2, 30, N'PayOUT', CAST(N'2022-02-07T10:34:14.3109688' AS DateTime2))
GO
SET IDENTITY_INSERT [balancing].[IntentItems] OFF
GO
SET IDENTITY_INSERT [balancing].[Journals] ON 
GO
INSERT [balancing].[Journals] ([Id], [Name], [CreationTimestamp]) VALUES (1, N'Zone Com-Site', CAST(N'2022-02-07T10:34:14.3349605' AS DateTime2))
GO
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
SET IDENTITY_INSERT [balancing].[Zones] ON 
GO
INSERT [balancing].[Zones] ([Id], [JournalId], [Enabled], [Name], [Token], [CreationTimestamp]) VALUES (1, 1, 1, N'Com-Site', N'', CAST(N'2022-02-07T10:34:14.3839711' AS DateTime2))
GO
SET IDENTITY_INSERT [balancing].[Zones] OFF
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
SET IDENTITY_INSERT [balancing].[ChannelItems] ON 
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (1, 10, N'WM', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (2, 20, N'Comepay', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (3, 30, N'Contact24', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (4, 40, N'YandexMoney', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (5, 50, N'Card', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (6, 60, N'TerminalElecsnet', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (7, 70, N'SberbankOnline', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (8, 80, N'AlfaClick', CAST(N'2022-02-07T10:34:14.2080868' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (9, 90, N'PromSvyazBank', CAST(N'2022-02-07T10:34:14.2080868' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (10, 100, N'Mobile', CAST(N'2022-02-07T10:34:14.2080868' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (11, 110, N'Neteller', CAST(N'2022-02-07T10:34:14.2080868' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (12, 120, N'EasyPay', CAST(N'2022-02-07T10:34:14.2080868' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (13, 130, N'QiwiWallet', CAST(N'2022-02-07T10:34:14.2080868' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (14, 140, N'Pskb', CAST(N'2022-02-07T10:34:14.2080868' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (15, 150, N'Mts', CAST(N'2022-02-07T10:34:14.2080868' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (16, 160, N'Tele2', CAST(N'2022-02-07T10:34:14.2080868' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (17, 170, N'Beeline', CAST(N'2022-02-07T10:34:14.2080868' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (18, 180, N'Megafon', CAST(N'2022-02-07T10:34:14.2080868' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (19, 190, N'QiwiPush', CAST(N'2022-02-07T10:34:14.2080868' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (20, 199, N'TerminalUnknown', CAST(N'2022-02-07T10:34:14.2080868' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (21, 200, N'TerminalEuroset', CAST(N'2022-02-07T10:34:14.2080868' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (22, 201, N'TerminalPochtaBank', CAST(N'2022-02-07T10:34:14.2080868' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (23, 202, N'TerminalMkb', CAST(N'2022-02-07T10:34:14.2080868' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (24, 203, N'TerminalEuroPlat', CAST(N'2022-02-07T10:34:14.2080868' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (25, 204, N'TerminalBeeline', CAST(N'2022-02-07T10:34:14.2080868' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (26, 205, N'TerminalMts', CAST(N'2022-02-07T10:34:14.2080868' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (27, 210, N'TerminalSvaznoy', CAST(N'2022-02-07T10:34:14.2080868' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (28, 220, N'TerminalContact', CAST(N'2022-02-07T10:34:14.2080868' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (29, 230, N'TerminalMegafon', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (30, 240, N'TerminalNovoplat', CAST(N'2022-02-07T10:34:14.2080868' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (31, 250, N'TerminalComepay', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (32, 260, N'TerminalHandybank', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (33, 270, N'TerminalYandex', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (34, 271, N'TerminalTelepay', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (35, 280, N'Com2Ru', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (36, 290, N'Ru2Com', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (37, 300, N'TerminalPskb', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (38, 310, N'Monetix', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (39, 320, N'Steam', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (40, 330, N'Ecopayz', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (41, 340, N'Jeton', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (42, 350, N'SkinPay', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (43, 360, N'ApplePay', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (44, 370, N'RoyalPayVoucher', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (45, 380, N'VKPay', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (46, 390, N'TerminalVtb', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (47, 400, N'GrataPayVoucher', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (48, 410, N'CardMastercard', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (49, 420, N'Piastrix', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (50, 430, N'Card_Visa_IK', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (51, 440, N'Card_MC_IK', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (52, 450, N'Exbase', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (53, 460, N'Card_IK', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (54, 470, N'Card_Cypix', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (55, 480, N'Card_IK_New', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (56, 490, N'Card_SettlePay', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (57, 500, N'Card_Armax', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (58, 510, N'Card_MoneyM', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (59, 520, N'Card_AliumPay', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
INSERT [balancing].[ChannelItems] ([Id], [Channel], [Name], [CreationTimestamp]) VALUES (60, 530, N'Card_CardPartner', CAST(N'2022-02-07T10:34:14.1439707' AS DateTime2))
GO
SET IDENTITY_INSERT [balancing].[ChannelItems] OFF
GO
SET IDENTITY_INSERT [balancing].[CurrencyItems] ON 
GO
INSERT [balancing].[CurrencyItems] ([Id], [Currency], [Name], [CreationTimestamp]) VALUES (1, 643, N'RUB', CAST(N'2022-02-07T10:34:14.2629602' AS DateTime2))
GO
INSERT [balancing].[CurrencyItems] ([Id], [Currency], [Name], [CreationTimestamp]) VALUES (2, 840, N'USD', CAST(N'2022-02-07T10:34:14.2629602' AS DateTime2))
GO
INSERT [balancing].[CurrencyItems] ([Id], [Currency], [Name], [CreationTimestamp]) VALUES (3, 844, N'AZN', CAST(N'2022-02-07T10:34:14.2629602' AS DateTime2))
GO
INSERT [balancing].[CurrencyItems] ([Id], [Currency], [Name], [CreationTimestamp]) VALUES (4, 860, N'UZS', CAST(N'2022-02-07T10:34:14.2629602' AS DateTime2))
GO
INSERT [balancing].[CurrencyItems] ([Id], [Currency], [Name], [CreationTimestamp]) VALUES (5, 978, N'EUR', CAST(N'2022-02-07T10:34:14.2629602' AS DateTime2))
GO
INSERT [balancing].[CurrencyItems] ([Id], [Currency], [Name], [CreationTimestamp]) VALUES (6, 980, N'UAH', CAST(N'2022-02-07T10:34:14.2629602' AS DateTime2))
GO
SET IDENTITY_INSERT [balancing].[CurrencyItems] OFF
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
