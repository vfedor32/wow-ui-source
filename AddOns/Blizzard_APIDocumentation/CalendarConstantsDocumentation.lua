local CalendarConstants =
{
	Tables =
	{
		{
			Name = "CalendarCommandType",
			Type = "Enumeration",
			NumValues = 12,
			MinValue = 0,
			MaxValue = 11,
			Fields =
			{
				{ Name = "CalendarCommandCreate", Type = "CalendarCommandType", EnumValue = 0 },
				{ Name = "CalendarCommandInvite", Type = "CalendarCommandType", EnumValue = 1 },
				{ Name = "CalendarCommandRsvp", Type = "CalendarCommandType", EnumValue = 2 },
				{ Name = "CalendarCommandRemoveInvite", Type = "CalendarCommandType", EnumValue = 3 },
				{ Name = "CalendarCommandRemoveEvent", Type = "CalendarCommandType", EnumValue = 4 },
				{ Name = "CalendarCommandStatus", Type = "CalendarCommandType", EnumValue = 5 },
				{ Name = "CalendarCommandModeratorStatus", Type = "CalendarCommandType", EnumValue = 6 },
				{ Name = "CalendarCommandGetCalendar", Type = "CalendarCommandType", EnumValue = 7 },
				{ Name = "CalendarCommandGetEvent", Type = "CalendarCommandType", EnumValue = 8 },
				{ Name = "CalendarCommandUpdateEvent", Type = "CalendarCommandType", EnumValue = 9 },
				{ Name = "CalendarCommandComplain", Type = "CalendarCommandType", EnumValue = 10 },
				{ Name = "CalendarCommandNotes", Type = "CalendarCommandType", EnumValue = 11 },
			},
		},
		{
			Name = "CalendarErrorType",
			Type = "Enumeration",
			NumValues = 51,
			MinValue = 0,
			MaxValue = 50,
			Fields =
			{
				{ Name = "CalendarErrorSuccess", Type = "CalendarErrorType", EnumValue = 0 },
				{ Name = "CalendarErrorCommunityEventsExceeded", Type = "CalendarErrorType", EnumValue = 1 },
				{ Name = "CalendarErrorEventsExceeded", Type = "CalendarErrorType", EnumValue = 2 },
				{ Name = "CalendarErrorSelfInvitesExceeded", Type = "CalendarErrorType", EnumValue = 3 },
				{ Name = "CalendarErrorOtherInvitesExceeded", Type = "CalendarErrorType", EnumValue = 4 },
				{ Name = "CalendarErrorNoPermission", Type = "CalendarErrorType", EnumValue = 5 },
				{ Name = "CalendarErrorEventInvalid", Type = "CalendarErrorType", EnumValue = 6 },
				{ Name = "CalendarErrorNotInvited", Type = "CalendarErrorType", EnumValue = 7 },
				{ Name = "CalendarErrorUnknownError", Type = "CalendarErrorType", EnumValue = 8 },
				{ Name = "CalendarErrorNotInGuild", Type = "CalendarErrorType", EnumValue = 9 },
				{ Name = "CalendarErrorNotInCommunity", Type = "CalendarErrorType", EnumValue = 10 },
				{ Name = "CalendarErrorTargetAlreadyInvited", Type = "CalendarErrorType", EnumValue = 11 },
				{ Name = "CalendarErrorNameNotFound", Type = "CalendarErrorType", EnumValue = 12 },
				{ Name = "CalendarErrorWrongFaction", Type = "CalendarErrorType", EnumValue = 13 },
				{ Name = "CalendarErrorIgnored", Type = "CalendarErrorType", EnumValue = 14 },
				{ Name = "CalendarErrorInvitesExceeded", Type = "CalendarErrorType", EnumValue = 15 },
				{ Name = "CalendarErrorInvalidMaxSize", Type = "CalendarErrorType", EnumValue = 16 },
				{ Name = "CalendarErrorInvalidDate", Type = "CalendarErrorType", EnumValue = 17 },
				{ Name = "CalendarErrorInvalidTime", Type = "CalendarErrorType", EnumValue = 18 },
				{ Name = "CalendarErrorNoInvites", Type = "CalendarErrorType", EnumValue = 19 },
				{ Name = "CalendarErrorNeedsTitle", Type = "CalendarErrorType", EnumValue = 20 },
				{ Name = "CalendarErrorEventPassed", Type = "CalendarErrorType", EnumValue = 21 },
				{ Name = "CalendarErrorEventLocked", Type = "CalendarErrorType", EnumValue = 22 },
				{ Name = "CalendarErrorDeleteCreatorFailed", Type = "CalendarErrorType", EnumValue = 23 },
				{ Name = "CalendarErrorDataAlreadySet", Type = "CalendarErrorType", EnumValue = 24 },
				{ Name = "CalendarErrorCalendarDisabled", Type = "CalendarErrorType", EnumValue = 25 },
				{ Name = "CalendarErrorRestrictedAccount", Type = "CalendarErrorType", EnumValue = 26 },
				{ Name = "CalendarErrorArenaEventsExceeded", Type = "CalendarErrorType", EnumValue = 27 },
				{ Name = "CalendarErrorRestrictedLevel", Type = "CalendarErrorType", EnumValue = 28 },
				{ Name = "CalendarErrorSquelched", Type = "CalendarErrorType", EnumValue = 29 },
				{ Name = "CalendarErrorNoInvite", Type = "CalendarErrorType", EnumValue = 30 },
				{ Name = "CalendarErrorComplaintDisabled", Type = "CalendarErrorType", EnumValue = 31 },
				{ Name = "CalendarErrorComplaintSelf", Type = "CalendarErrorType", EnumValue = 32 },
				{ Name = "CalendarErrorComplaintSameGuild", Type = "CalendarErrorType", EnumValue = 33 },
				{ Name = "CalendarErrorComplaintGm", Type = "CalendarErrorType", EnumValue = 34 },
				{ Name = "CalendarErrorComplaintLimit", Type = "CalendarErrorType", EnumValue = 35 },
				{ Name = "CalendarErrorComplaintNotFound", Type = "CalendarErrorType", EnumValue = 36 },
				{ Name = "CalendarErrorEventWrongServer", Type = "CalendarErrorType", EnumValue = 37 },
				{ Name = "CalendarErrorNoCommunityInvites", Type = "CalendarErrorType", EnumValue = 38 },
				{ Name = "CalendarErrorInvalidSignup", Type = "CalendarErrorType", EnumValue = 39 },
				{ Name = "CalendarErrorNoModerator", Type = "CalendarErrorType", EnumValue = 40 },
				{ Name = "CalendarErrorModeratorRestricted", Type = "CalendarErrorType", EnumValue = 41 },
				{ Name = "CalendarErrorInvalidNotes", Type = "CalendarErrorType", EnumValue = 42 },
				{ Name = "CalendarErrorInvalidTitle", Type = "CalendarErrorType", EnumValue = 43 },
				{ Name = "CalendarErrorInvalidDescription", Type = "CalendarErrorType", EnumValue = 44 },
				{ Name = "CalendarErrorInvalidClub", Type = "CalendarErrorType", EnumValue = 45 },
				{ Name = "CalendarErrorCreatorNotFound", Type = "CalendarErrorType", EnumValue = 46 },
				{ Name = "CalendarErrorEventThrottled", Type = "CalendarErrorType", EnumValue = 47 },
				{ Name = "CalendarErrorInviteThrottled", Type = "CalendarErrorType", EnumValue = 48 },
				{ Name = "CalendarErrorInternal", Type = "CalendarErrorType", EnumValue = 49 },
				{ Name = "CalendarErrorComplaintAdded", Type = "CalendarErrorType", EnumValue = 50 },
			},
		},
		{
			Name = "CalendarEventBits",
			Type = "Enumeration",
			NumValues = 15,
			MinValue = 1,
			MaxValue = 3788,
			Fields =
			{
				{ Name = "CalendarEventBitPlayer", Type = "CalendarEventBits", EnumValue = 1 },
				{ Name = "CalendarEventBitGuildDeprecated", Type = "CalendarEventBits", EnumValue = 2 },
				{ Name = "CalendarEventBitSystem", Type = "CalendarEventBits", EnumValue = 4 },
				{ Name = "CalendarEventBitHoliday", Type = "CalendarEventBits", EnumValue = 8 },
				{ Name = "CalendarEventBitLocked", Type = "CalendarEventBits", EnumValue = 16 },
				{ Name = "CalendarEventBitAutoApprove", Type = "CalendarEventBits", EnumValue = 32 },
				{ Name = "CalendarEventBitCommunityAnnouncement", Type = "CalendarEventBits", EnumValue = 64 },
				{ Name = "CalendarEventBitRaidLockout", Type = "CalendarEventBits", EnumValue = 128 },
				{ Name = "CalendarEventBitArenaDeprecated", Type = "CalendarEventBits", EnumValue = 256 },
				{ Name = "CalendarEventBitRaidResetDeprecated", Type = "CalendarEventBits", EnumValue = 512 },
				{ Name = "CalendarEventBitCommunitySignup", Type = "CalendarEventBits", EnumValue = 1024 },
				{ Name = "CalendarEventBitGuildSignup", Type = "CalendarEventBits", EnumValue = 2048 },
				{ Name = "CommunityWide", Type = "CalendarEventBits", EnumValue = 3136 },
				{ Name = "PlayerCreated", Type = "CalendarEventBits", EnumValue = 3395 },
				{ Name = "CantComplain", Type = "CalendarEventBits", EnumValue = 3788 },
			},
		},
		{
			Name = "CalendarEventRepeatOptions",
			Type = "Enumeration",
			NumValues = 4,
			MinValue = 0,
			MaxValue = 3,
			Fields =
			{
				{ Name = "CalendarRepeatNever", Type = "CalendarEventRepeatOptions", EnumValue = 0 },
				{ Name = "CalendarRepeatWeekly", Type = "CalendarEventRepeatOptions", EnumValue = 1 },
				{ Name = "CalendarRepeatBiweekly", Type = "CalendarEventRepeatOptions", EnumValue = 2 },
				{ Name = "CalendarRepeatMonthly", Type = "CalendarEventRepeatOptions", EnumValue = 3 },
			},
		},
		{
			Name = "CalendarEventType",
			Type = "Enumeration",
			NumValues = 6,
			MinValue = 0,
			MaxValue = 5,
			Fields =
			{
				{ Name = "Raid", Type = "CalendarEventType", EnumValue = 0 },
				{ Name = "Dungeon", Type = "CalendarEventType", EnumValue = 1 },
				{ Name = "Pvp", Type = "CalendarEventType", EnumValue = 2 },
				{ Name = "Meeting", Type = "CalendarEventType", EnumValue = 3 },
				{ Name = "Other", Type = "CalendarEventType", EnumValue = 4 },
				{ Name = "HeroicDeprecated", Type = "CalendarEventType", EnumValue = 5 },
			},
		},
		{
			Name = "CalendarFilterFlags",
			Type = "Enumeration",
			NumValues = 5,
			MinValue = 1,
			MaxValue = 16,
			Fields =
			{
				{ Name = "WeeklyHoliday", Type = "CalendarFilterFlags", EnumValue = 1 },
				{ Name = "Darkmoon", Type = "CalendarFilterFlags", EnumValue = 2 },
				{ Name = "Battleground", Type = "CalendarFilterFlags", EnumValue = 4 },
				{ Name = "RaidLockout", Type = "CalendarFilterFlags", EnumValue = 8 },
				{ Name = "RaidReset", Type = "CalendarFilterFlags", EnumValue = 16 },
			},
		},
		{
			Name = "CalendarGetEventType",
			Type = "Enumeration",
			NumValues = 4,
			MinValue = 0,
			MaxValue = 2,
			Fields =
			{
				{ Name = "Get", Type = "CalendarGetEventType", EnumValue = 0 },
				{ Name = "Add", Type = "CalendarGetEventType", EnumValue = 1 },
				{ Name = "Copy", Type = "CalendarGetEventType", EnumValue = 2 },
				{ Name = "DefaultCalendarGetEventType", Type = "CalendarGetEventType", EnumValue = 0 },
			},
		},
		{
			Name = "CalendarHolidayFilterType",
			Type = "Enumeration",
			NumValues = 3,
			MinValue = 0,
			MaxValue = 2,
			Fields =
			{
				{ Name = "Weekly", Type = "CalendarHolidayFilterType", EnumValue = 0 },
				{ Name = "Darkmoon", Type = "CalendarHolidayFilterType", EnumValue = 1 },
				{ Name = "Battleground", Type = "CalendarHolidayFilterType", EnumValue = 2 },
			},
		},
		{
			Name = "CalendarInviteBits",
			Type = "Enumeration",
			NumValues = 4,
			MinValue = 1,
			MaxValue = 8,
			Fields =
			{
				{ Name = "CalendarInviteBitPendingInvite", Type = "CalendarInviteBits", EnumValue = 1 },
				{ Name = "CalendarInviteBitModerator", Type = "CalendarInviteBits", EnumValue = 2 },
				{ Name = "CalendarInviteBitCreator", Type = "CalendarInviteBits", EnumValue = 4 },
				{ Name = "CalendarInviteBitSignup", Type = "CalendarInviteBits", EnumValue = 8 },
			},
		},
		{
			Name = "CalendarInviteSortType",
			Type = "Enumeration",
			NumValues = 6,
			MinValue = 0,
			MaxValue = 5,
			Fields =
			{
				{ Name = "CalendarInviteSortName", Type = "CalendarInviteSortType", EnumValue = 0 },
				{ Name = "CalendarInviteSortLevel", Type = "CalendarInviteSortType", EnumValue = 1 },
				{ Name = "CalendarInviteSortClass", Type = "CalendarInviteSortType", EnumValue = 2 },
				{ Name = "CalendarInviteSortStatus", Type = "CalendarInviteSortType", EnumValue = 3 },
				{ Name = "CalendarInviteSortParty", Type = "CalendarInviteSortType", EnumValue = 4 },
				{ Name = "CalendarInviteSortNotes", Type = "CalendarInviteSortType", EnumValue = 5 },
			},
		},
		{
			Name = "CalendarInviteType",
			Type = "Enumeration",
			NumValues = 2,
			MinValue = 0,
			MaxValue = 1,
			Fields =
			{
				{ Name = "Normal", Type = "CalendarInviteType", EnumValue = 0 },
				{ Name = "Signup", Type = "CalendarInviteType", EnumValue = 1 },
			},
		},
		{
			Name = "CalendarModeratorStatus",
			Type = "Enumeration",
			NumValues = 3,
			MinValue = 0,
			MaxValue = 2,
			Fields =
			{
				{ Name = "CalendarModeratorNone", Type = "CalendarModeratorStatus", EnumValue = 0 },
				{ Name = "CalendarModeratorModerator", Type = "CalendarModeratorStatus", EnumValue = 1 },
				{ Name = "CalendarModeratorCreator", Type = "CalendarModeratorStatus", EnumValue = 2 },
			},
		},
		{
			Name = "CalendarStatus",
			Type = "Enumeration",
			NumValues = 9,
			MinValue = 0,
			MaxValue = 8,
			Fields =
			{
				{ Name = "Invited", Type = "CalendarStatus", EnumValue = 0 },
				{ Name = "Available", Type = "CalendarStatus", EnumValue = 1 },
				{ Name = "Declined", Type = "CalendarStatus", EnumValue = 2 },
				{ Name = "Confirmed", Type = "CalendarStatus", EnumValue = 3 },
				{ Name = "Out", Type = "CalendarStatus", EnumValue = 4 },
				{ Name = "Standby", Type = "CalendarStatus", EnumValue = 5 },
				{ Name = "Signedup", Type = "CalendarStatus", EnumValue = 6 },
				{ Name = "NotSignedup", Type = "CalendarStatus", EnumValue = 7 },
				{ Name = "Tentative", Type = "CalendarStatus", EnumValue = 8 },
			},
		},
		{
			Name = "CalendarType",
			Type = "Enumeration",
			NumValues = 8,
			MinValue = 0,
			MaxValue = 7,
			Fields =
			{
				{ Name = "Player", Type = "CalendarType", EnumValue = 0 },
				{ Name = "Community", Type = "CalendarType", EnumValue = 1 },
				{ Name = "RaidLockout", Type = "CalendarType", EnumValue = 2 },
				{ Name = "RaidResetDeprecated", Type = "CalendarType", EnumValue = 3 },
				{ Name = "Holiday", Type = "CalendarType", EnumValue = 4 },
				{ Name = "HolidayWeekly", Type = "CalendarType", EnumValue = 5 },
				{ Name = "HolidayDarkmoon", Type = "CalendarType", EnumValue = 6 },
				{ Name = "HolidayBattleground", Type = "CalendarType", EnumValue = 7 },
			},
		},
		{
			Name = "CalendarWebActionType",
			Type = "Enumeration",
			NumValues = 7,
			MinValue = 0,
			MaxValue = 6,
			Fields =
			{
				{ Name = "Accept", Type = "CalendarWebActionType", EnumValue = 0 },
				{ Name = "Decline", Type = "CalendarWebActionType", EnumValue = 1 },
				{ Name = "Remove", Type = "CalendarWebActionType", EnumValue = 2 },
				{ Name = "ReportSpam", Type = "CalendarWebActionType", EnumValue = 3 },
				{ Name = "Signup", Type = "CalendarWebActionType", EnumValue = 4 },
				{ Name = "Tentative", Type = "CalendarWebActionType", EnumValue = 5 },
				{ Name = "TentativeSignup", Type = "CalendarWebActionType", EnumValue = 6 },
			},
		},
		{
			Name = "HolidayCalendarFlags",
			Type = "Enumeration",
			NumValues = 2,
			MinValue = 1,
			MaxValue = 2,
			Fields =
			{
				{ Name = "Alliance", Type = "HolidayCalendarFlags", EnumValue = 1 },
				{ Name = "Horde", Type = "HolidayCalendarFlags", EnumValue = 2 },
			},
		},
		{
			Name = "HolidayFlags",
			Type = "Enumeration",
			NumValues = 4,
			MinValue = 1,
			MaxValue = 8,
			Fields =
			{
				{ Name = "IsRegionwide", Type = "HolidayFlags", EnumValue = 1 },
				{ Name = "DontShowInCalendar", Type = "HolidayFlags", EnumValue = 2 },
				{ Name = "DontDisplayEnd", Type = "HolidayFlags", EnumValue = 4 },
				{ Name = "DontDisplayBanner", Type = "HolidayFlags", EnumValue = 8 },
			},
		},
	},
};

APIDocumentation:AddDocumentationTable(CalendarConstants);