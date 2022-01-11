USE [BaltbetM]
GO

/**** Object: View [dbo].[Results_View] Script Date: 12.11.2020 10:34:53 ****/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[Results_View] AS
SELECT
Events.LineID AS EventId,
Events.EventName AS EventTitle,
Events.Live AS IsLive,
Events.ClientShow AS ClientShow,
CASE Events.Live WHEN 1 THEN Events.EventCreationTime ELSE Events.EventStartTime END AS StartTime,
Events.EventResultText AS ResultText,
EventComments.ResultCommentRus AS ResultComment,
Events.LineMemberId AS LeagueId,
GlobalTranslate.Rus AS LeagueTitle,
Events.EventTypeGroupID AS SportId,
Sports.SportTypeID AS SportTypeId,
Events.TopEvent AS TopEvent,
BetRadarEvents.BetRadarID AS BetRadarId,
CASE WHEN P3.LineMemberText IS NOT NULL THEN P1.LineMemberText + ' / ' + P2.LineMemberText ELSE P1.LineMemberText END as Player1,
CASE WHEN P3.LineMemberText IS NOT NULL THEN P3.LineMemberText + ' / ' + P4.LineMemberText ELSE P2.LineMemberText END as Player2
FROM dbo.Events
INNER JOIN dbo.LineMembers AS Leagues ON Events.LineMemberId = Leagues.LineMemberId
INNER JOIN dbo.GlobalTranslate ON Leagues.TranslateID = GlobalTranslate.ID
LEFT OUTER JOIN dbo.EventComments ON Events.LineId = EventComments.EventId
LEFT OUTER JOIN dbo.LineMembers AS Sports ON Events.EventTypeGroupID = Sports.LineMemberId
LEFT OUTER JOIN dbo.BetRadarEvents ON Events.LineID = BetRadarEvents.EventID
LEFT OUTER JOIN dbo.LineMembers P1 ON P1.LineMemberId = dbo.Events.PlayerId1
LEFT OUTER JOIN dbo.LineMembers P2 ON P2.LineMemberId = dbo.Events.PlayerId2
LEFT OUTER JOIN dbo.LineMembers P3 ON P3.LineMemberId = dbo.Events.PlayerId3
LEFT OUTER JOIN dbo.LineMembers P4 ON P4.LineMemberId = dbo.Events.PlayerId4
WHERE Events.EventStartTime < GETDATE()
AND LEN(Events.EventResultText) > 0

GO