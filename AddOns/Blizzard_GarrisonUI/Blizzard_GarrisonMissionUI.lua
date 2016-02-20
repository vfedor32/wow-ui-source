GARRISON_MISSION_COMPLETE_BANNER_WIDTH = 300;
GARRISON_MODEL_PRELOAD_TIME = 20;
GARRISON_LONG_MISSION_TIME = 8 * 60 * 60;	-- 8 hours
GARRISON_LONG_MISSION_TIME_FORMAT = "|cffff7d1a%s|r";

---------------------------------------------------------------------------------
--- Garrison Follower Mission  Mixin Functions                                ---
---------------------------------------------------------------------------------

GarrisonFollowerMission = {};

function GarrisonFollowerMission:SetupMissionList()
	self.MissionTab.MissionList.listScroll.update = function() self.MissionTab.MissionList:Update(); end;
	HybridScrollFrame_CreateButtons(self.MissionTab.MissionList.listScroll, "GarrisonMissionListButtonTemplate", 13, -8, nil, nil, nil, -4);
	self.MissionTab.MissionList:Update();
	
	GarrisonMissionListTab_SetTab(self.MissionTab.MissionList.Tab1);
end

function GarrisonFollowerMission:OnLoadMainFrame()
	GarrisonMission.OnLoadMainFrame(self);

	self.TitleText:SetText(GARRISON_MISSIONS_TITLE);
	self.FollowerTab.ItemWeapon.Name:SetText(WEAPON);
	self.FollowerTab.ItemArmor.Name:SetText(ARMOR);

	self:UpdateCurrency();
	
	self:SetupMissionList();
	
	local factionGroup = UnitFactionGroup("player");
	if ( factionGroup == "Horde" ) then
		self.MissionTab.MissionPage.RewardsFrame.Chest:SetAtlas("GarrMission-HordeChest");
		self.MissionTab.MissionPage.EmptyFollowerModel.Texture:SetAtlas("GarrMission_Silhouettes-1Horde");
	end
	if (self.MissionTab.MissionList) then
	    if ( factionGroup == "Horde" ) then
		    local dialogBorderFrame = self.MissionTab.MissionList.CompleteDialog.BorderFrame;
		    dialogBorderFrame.Model:SetDisplayInfo(59175);
		    dialogBorderFrame.Model:SetPosition(0.2, 1.15, -0.7);
		    dialogBorderFrame.Stage.LocBack:SetAtlas("_GarrMissionLocation-FrostfireRidge-Back", true);
		    dialogBorderFrame.Stage.LocMid:SetAtlas ("_GarrMissionLocation-FrostfireRidge-Mid", true);
		    dialogBorderFrame.Stage.LocFore:SetAtlas("_GarrMissionLocation-FrostfireRidge-Fore", true);
		    dialogBorderFrame.Stage.LocBack:SetTexCoord(0, 0.485, 0, 1);
		    dialogBorderFrame.Stage.LocMid:SetTexCoord(0, 0.485, 0, 1);
		    dialogBorderFrame.Stage.LocFore:SetTexCoord(0, 0.485, 0, 1);
	    else
		    local dialogBorderFrame = self.MissionTab.MissionList.CompleteDialog.BorderFrame;
		    dialogBorderFrame.Model:SetDisplayInfo(58063);
		    dialogBorderFrame.Model:SetPosition(0.2, .75, -0.7);
		    dialogBorderFrame.Stage.LocBack:SetAtlas("_GarrMissionLocation-ShadowmoonValley-Back", true);
		    dialogBorderFrame.Stage.LocMid:SetAtlas ("_GarrMissionLocation-ShadowmoonValley-Mid", true);
		    dialogBorderFrame.Stage.LocFore:SetAtlas("_GarrMissionLocation-ShadowmoonValley-Fore", true);
		    dialogBorderFrame.Stage.LocBack:SetTexCoord(0.2, 0.685, 0, 1);
		    dialogBorderFrame.Stage.LocMid:SetTexCoord(0.2, 0.685, 0, 1);
		    dialogBorderFrame.Stage.LocFore:SetTexCoord(0.2, 0.685, 0, 1);
	    end
	end

	self:RegisterEvent("GARRISON_MISSION_LIST_UPDATE");
	self:RegisterEvent("CURRENCY_DISPLAY_UPDATE");
	self:RegisterEvent("GARRISON_MISSION_STARTED");
	self:RegisterEvent("GARRISON_MISSION_FINISHED");
	self:RegisterEvent("GET_ITEM_INFO_RECEIVED");
	self:RegisterEvent("GARRISON_RANDOM_MISSION_ADDED");
	self:RegisterEvent("CURRENT_SPELL_CAST_CHANGED");
	self:RegisterEvent("GARRISON_FOLLOWER_XP_CHANGED");
end

function GarrisonFollowerMission:OnEventMainFrame(event, ...)
	if (event == "GARRISON_MISSION_LIST_UPDATE") then
		local followerTypeID = ...;
		if (followerTypeID == self.followerTypeID) then
			GarrisonMissionList_UpdateMissions();
		end
	elseif (event == "GARRISON_FOLLOWER_XP_CHANGED" and self.MissionTab.MissionPage:IsShown() and self.MissionTab.MissionPage.missionInfo ) then
		-- follower could have leveled at mission page, need to recheck counters
		local followerTypeID = ...;
		if (followerTypeID == self.followerTypeID) then
			self.followerCounters = C_Garrison.GetBuffedFollowersForMission(self.MissionTab.MissionPage.missionInfo.missionID);
			self.followerTraits = C_Garrison.GetFollowersTraitsForMission(self.MissionTab.MissionPage.missionInfo.missionID);	
		end
	elseif (event == "CURRENCY_DISPLAY_UPDATE") then
		self:UpdateCurrency();
	elseif (event == "GARRISON_MISSION_STARTED") then
		local followerTypeID = ...;
		if (followerTypeID == self.followerTypeID) then
			if (self.MissionTab.MissionList) then
				local anim = self.MissionTab.MissionList.Tab2.MissionStartAnim;
				if (anim:IsPlaying()) then
					anim:Stop();
				end
				anim:Play();
			end
		end
	elseif (event == "GARRISON_MISSION_FINISHED") then
		local followerTypeID = ...;
		if (followerTypeID == self.followerTypeID) then
			self:CheckCompleteMissions();
		end
	elseif ( event == "GET_ITEM_INFO_RECEIVED" ) then
		self:UpdateRewards(...);
	elseif ( event == "GARRISON_RANDOM_MISSION_ADDED" ) then
		GarrisonMissionFrame_RandomMissionAdded(self, ...);
	elseif ( event == "CURRENT_SPELL_CAST_CHANGED" ) then
		if ( SpellCanTargetGarrisonFollower() ) then
			self.isTargettingGarrisonFollower = true;
			self:GetMissionPage():UpdatePortraitPulse();
		elseif ( self.isTargettingGarrisonFollower ) then
			self.isTargettingGarrisonFollower = false;
			self:GetMissionPage():UpdatePortraitPulse();
		end
	end
end

function GarrisonFollowerMission:OnShowMainFrame()
	GarrisonMission.OnShowMainFrame(self);
	if (self.FollowerList.followerType ~= self.followerTypeID) then
		self.FollowerList:Initialize(self.followerTypeID);
	end
	self:CheckCompleteMissions(true);
	GarrisonThreatCountersFrame:SetParent(self.FollowerTab);
	GarrisonThreatCountersFrame:SetPoint("TOPRIGHT", -12, 30);
	PlaySound("UI_Garrison_CommandTable_Open");
end

function GarrisonFollowerMission:OnHideMainFrame()
	if ( self:GetMissionPage().missionInfo ) then
		self:CloseMission();
	end
	GarrisonMissionFrame_ClearMouse();
	C_Garrison.CloseMissionNPC();
	HelpPlate_Hide();
	self:HideCompleteMissions(true);
	MissionCompletePreload_Cancel(self);
	PlaySound("UI_Garrison_CommandTable_Close");
	StaticPopup_Hide("DEACTIVATE_FOLLOWER");
	StaticPopup_Hide("ACTIVATE_FOLLOWER");
	StaticPopup_Hide("CONFIRM_FOLLOWER_TEMPORARY_ABILITY");
	StaticPopup_Hide("CONFIRM_FOLLOWER_UPGRADE");
	StaticPopup_Hide("CONFIRM_FOLLOWER_ABILITY_UPGRADE");

	if (self.MissionTab.MissionList) then
		self.MissionTab.MissionList.newMissionIDs = { };
		self.MissionTab.MissionList:Update();
	end
end

function GarrisonFollowerMission:UpdateCurrency()
	local currencyName, amount, currencyTexture = GetCurrencyInfo(GARRISON_CURRENCY);
	self.materialAmount = amount;
	amount = BreakUpLargeNumbers(amount)
	self.MissionTab.MissionList.MaterialFrame.Materials:SetText(amount);
	self.FollowerList.MaterialFrame.Materials:SetText(amount);
end

function GarrisonFollowerMission:SelectTab(id)
	GarrisonMission.SelectTab(self, id);
	if (id == 1) then
		self.TitleText:SetText(GARRISON_MISSIONS_TITLE);
	else
		self.TitleText:SetText(GARRISON_FOLLOWERS_TITLE);
	end
	if ( UIDropDownMenu_GetCurrentDropDown() == GetMissionFrame().OptionDropDown ) then
		CloseDropDownMenus();
	end
end

function GarrisonFollowerMission:OnClickMission(missionInfo)
	if (not GarrisonMission.OnClickMission(self, missionInfo)) then
		return;
	end

	if (self.MissionTab.MissionList) then
		self.MissionTab.MissionList:Update();
		self.MissionTab.MissionList:Hide();
	end
	self:GetMissionPage():Show();
	
	self:ShowMission(missionInfo);
	
	self.FollowerList:UpdateFollowers();
end

function GarrisonFollowerMission:ShowMissionStage(missionInfo)
	local missionPage = self:GetMissionPage();

	missionPage.Stage.Level:SetText(missionInfo.level);
	missionPage.Stage.Location:SetText(missionInfo.location);
	missionPage.Stage.MissionDescription:SetText(missionInfo.description);
end

function GarrisonFollowerMission:ShowMission(missionInfo)
	GarrisonMission.ShowMission(self, missionInfo);

	self:ShowMissionStage(missionInfo);	
	self:CheckTutorials();
end

function GarrisonFollowerMission:SetPartySize(frame, size, numEnemies)
	GarrisonMission.SetPartySize(self, frame, size, numEnemies);
	
	frame.EmptyString:ClearAllPoints();
	frame.FollowerModel:Hide();
	if ( size == 1 ) then
		frame.EmptyString:SetText(GARRISON_PARTY_INSTRUCTIONS_SINGLE);
		frame.EmptyFollowerModel:Show();
		if ( numEnemies == 1 ) then
			frame.Followers[1]:SetPoint("TOPLEFT", 82, -274);
			frame.EmptyString:SetPoint("TOPLEFT", 98, -255);
		else
			frame.Followers[1]:SetPoint("TOPLEFT", 22, -274);
			frame.EmptyString:SetPoint("TOPLEFT", 28, -255);
		end
		frame.BuffsFrame:ClearAllPoints();
		frame.BuffsFrame:SetPoint("BOTTOMLEFT", 80, 198);
	else
		frame.EmptyString:SetText(GARRISON_PARTY_INSTRUCTIONS_MANY);
		frame.EmptyString:SetPoint("TOP", 0, -255);
		frame.EmptyFollowerModel:Hide();
		if ( size == 2 ) then
			frame.Followers[1]:SetPoint("TOPLEFT", 108, -274);
		else
			frame.Followers[1]:SetPoint("TOPLEFT", 22, -274);
		end
		frame.BuffsFrame:ClearAllPoints();
		frame.BuffsFrame:SetPoint("BOTTOM", 0, 198);
	end
end

function GarrisonFollowerMission:SetEnemies(frame, enemies, numFollowers, mechanicYOffset)
	local numVisibleEnemies = GarrisonMission.SetEnemies(self, frame, enemies, numFollowers, mechanicYOffset or -16, self.followerTypeID);
	
	if ( numVisibleEnemies == 1 ) then
		if ( numFollowers == 1 ) then
			frame.Enemy1:SetPoint("TOPLEFT", 143, -164);
		else
			frame.Enemy1:SetPoint("TOPLEFT", 251, -164);
		end
	elseif ( numVisibleEnemies == 2 ) then
		if ( numFollowers == 1 ) then
			frame.Enemy1:SetPoint("TOPLEFT", 78, -164);
		else
			frame.Enemy1:SetPoint("TOPLEFT", 165, -164);
		end	
	else
		frame.Enemy1:SetPoint("TOPLEFT", 78, -164);
	end
end

function GarrisonFollowerMission:UpdateMissionData(missionPage)
	GarrisonMission.UpdateMissionData(self, missionPage);
	
	-- Followers - TODO move GarrisonMissionPage_UpdatePortraitPulse() into common file when shipyard has followers?
	missionPage:UpdatePortraitPulse();
	missionPage:UpdateEmptyString();
end

function GarrisonFollowerMission:SetEnemyName(portraitFrame, name)
	portraitFrame.Name:SetText(name);
end

function GarrisonFollowerMission:SetEnemyPortrait(portraitFrame, enemy, eliteFrame, numMechs)
	GarrisonEnemyPortait_Set(portraitFrame.Portrait, enemy.portraitFileDataID);
	
	if ( numMechs > 1 ) then
		eliteFrame:Show();
	else
		eliteFrame:Hide();
	end
end

function GarrisonFollowerMission:SetFollowerPortrait(followerFrame, followerInfo, forMissionPage)
	local frame = followerFrame;
	if (followerFrame.PortraitFrame) then
		frame = followerFrame.PortraitFrame;
	end
	GarrisonMissionPortrait_SetFollowerPortrait(frame, followerInfo, forMissionPage and self:GetMissionPage() or nil);
end

function GarrisonFollowerMission:ClearParty()
	GarrisonMission.ClearParty(self);
	if (self:GetMissionPage().FollowerModel) then
		self:GetMissionPage().FollowerModel:Hide();
	end
	self:GetMissionPage():UpdateEmptyString();
end

function GarrisonFollowerMission:OnClickStartMissionButton()
	if (not GarrisonMission.OnClickStartMissionButton(self)) then
		return;
	end
	PlaySound("UI_Garrison_CommandTable_MissionStart");
	if (not GetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_GARRISON_LANDING)) then
		GarrisonLandingPageTutorialBox:Show();
	end
end

function GarrisonFollowerMission:AssignFollowerToMission(frame, info)
	if (not GarrisonMission.AssignFollowerToMission(self, frame, info)) then
		return;
	end

	PlaySound("UI_Garrison_CommandTable_AssignFollower");
	frame.Name:Show();
	frame.Name:SetText(info.name);
	if (frame.Class) then
		frame.Class:Show();
		frame.Class:SetAtlas(info.classAtlas);
	end
	frame.PortraitFrame.Empty:Hide();

	self:GetMissionPage():UpdateFollowerModel(info);
end

function GarrisonFollowerMission:RemoveFollowerFromMission(frame, updateValues)
	GarrisonMission.RemoveFollowerFromMission(self, frame, updateValues);
	
	local followerID = frame.info and frame.info.followerID or nil;
	frame.info = nil;
	frame.Name:Hide();
	if (frame.Class) then
		frame.Class:Hide();
	end
	frame.PortraitFrame.Empty:Show();
	frame.PortraitFrame:SetLevel("");
	frame.PortraitFrame.Caution:Hide();

	if (followerID and self:GetMissionPage().missionInfo.numFollowers == 1 ) then
		self:GetMissionPage().FollowerModel:ClearModel();
		self:GetMissionPage().FollowerModel:Hide();
		self:GetMissionPage().EmptyFollowerModel:Show();
	end
end

function GarrisonFollowerMission:UpdateMissionParty(followers)
	GarrisonMission.UpdateMissionParty(self, followers, "GarrisonMissionAbilityLargeCounterTemplate");
end

function GarrisonFollowerMission:ClearMouse()
	GarrisonMissionFrame_ClearMouse();
end

function GarrisonFollowerMission:OnDragStartFollowerButton(placer, frame, yOffset)
	GarrisonMission.OnDragStartFollowerButton(self, placer, frame, yOffset);
	CloseDropDownMenus();
end

function GarrisonFollowerMission:OnMouseUpMissionFollower(frame, button)
	if ( button == "LeftButton" ) then
		if ( frame.info and SpellCanTargetGarrisonFollower() and C_Garrison.TargetSpellHasFollowerTemporaryAbility() ) then
			GarrisonFollower_DisplayUpgradeConfirmation(frame.info.followerID);
		end
	else
		GarrisonMission.OnMouseUpMissionFollower(self, frame, button);
	end
end

function GarrisonFollowerMission:UpdateMissions()
	GarrisonMissionList_UpdateMissions();
end

function GarrisonFollowerMission:CheckCompleteMissions(onShow)
	if (not GarrisonMission.CheckCompleteMissions(self, onShow)) then
		return;
	end

	-- preload all follower and enemy models
	MissionCompletePreload_LoadMission(self, self.MissionComplete.completeMissions[1].missionID);

	-- go to the right tab if window is being open
	if ( onShow ) then
		self:SelectTab(1);
	end
	GarrisonMissionListTab_SetTab(self.MissionTab.MissionList.Tab1);
end

function GarrisonFollowerMission:MissionCompleteInitialize(missionList, index)
	if (not GarrisonMission.MissionCompleteInitialize(self, missionList, index)) then
		return;
	end
	
	local mission = missionList[index];
	local frame = self.MissionComplete;
	local stage = frame.Stage;
	stage.MissionInfo.Level:SetText(mission.level);
	stage.MissionInfo.Location:SetText(mission.location);

	-- max level
	if ( mission.level == self.followerMaxLevel and mission.iLevel > 0 ) then
		stage.MissionInfo.Level:SetPoint("CENTER", stage.MissionInfo, "TOPLEFT", 30, -28);
		stage.MissionInfo.ItemLevel:Show();
		stage.MissionInfo.ItemLevel:SetFormattedText(NUMBER_IN_PARENTHESES, mission.iLevel);
		stage.ItemLevelHitboxFrame:Show();
	else
		stage.MissionInfo.Level:SetPoint("CENTER", stage.MissionInfo, "TOPLEFT", 30, -36);
		stage.MissionInfo.ItemLevel:Hide();
		stage.ItemLevelHitboxFrame:Hide();
	end
end

function GarrisonFollowerMission:ResetMissionCompleteEncounter(encounter)
	encounter:Show();
	encounter.CheckFrame.SuccessAnim:Stop();
	encounter.CheckFrame.FailureAnim:Stop();
	encounter.CheckFrame.CrossLeft:SetAlpha(0);
	encounter.CheckFrame.CrossRight:SetAlpha(0);
	encounter.CheckFrame.CheckMark:SetAlpha(0);
	encounter.CheckFrame.CheckMarkGlow:SetAlpha(0);
	encounter.CheckFrame.CheckMarkLeft:SetAlpha(0);
	encounter.CheckFrame.CheckMarkRight:SetAlpha(0);
	encounter.CheckFrame.CheckSmoke:SetAlpha(0);
	encounter.Name:Hide();
	encounter.GlowFrame.OnAnim:Stop();
	encounter.GlowFrame.OffAnim:Stop();
	encounter.GlowFrame.SpikeyGlow:SetAlpha(0);
	encounter.GlowFrame.EncounterGlow:SetAlpha(0);
end


---------------------------------------------------------------------------------
--- Garrison Mission Frame                                                    ---
---------------------------------------------------------------------------------

StaticPopupDialogs["DEACTIVATE_FOLLOWER"] = {
	text = "",
	button1 = YES,
	button2 = NO,
	OnAccept = function(self)
		C_Garrison.SetFollowerInactive(self.data, true);
	end,
	OnShow = function(self)
		local quality = C_Garrison.GetFollowerQuality(self.data);
		local name = ITEM_QUALITY_COLORS[quality].hex..C_Garrison.GetFollowerName(self.data)..FONT_COLOR_CODE_CLOSE;
		local cost = GetMoneyString(C_Garrison.GetFollowerActivationCost());
		local uses = C_Garrison.GetNumFollowerDailyActivations();
		self.text:SetFormattedText(GARRISON_DEACTIVATE_FOLLOWER_CONFIRMATION, name, cost, uses);
	end,
	showAlert = 1,
	timeout = 0,
	exclusive = 1,
	hideOnEscape = 1
};

StaticPopupDialogs["ACTIVATE_FOLLOWER"] = {
	text = "",
	button1 = YES,
	button2 = NO,
	OnAccept = function(self)
		C_Garrison.SetFollowerInactive(self.data, false);
	end,
	OnShow = function(self)
		local quality = C_Garrison.GetFollowerQuality(self.data);
		local name = ITEM_QUALITY_COLORS[quality].hex..C_Garrison.GetFollowerName(self.data)..FONT_COLOR_CODE_CLOSE;
		local uses = C_Garrison.GetNumFollowerActivationsRemaining();
		self.text:SetFormattedText(GARRISON_ACTIVATE_FOLLOWER_CONFIRMATION, name, uses);
		MoneyFrame_Update(self.moneyFrame, C_Garrison.GetFollowerActivationCost());
	end,	
	showAlert = 1,
	timeout = 0,
	exclusive = 1,
	hasMoneyFrame = 1,
	hideOnEscape = 1
};
	
local tutorials = {
	[1] = { text1 = GARRISON_MISSION_TUTORIAL1, xOffset = 240, yOffset = -150, parent = "MissionList" },
	[2] = { text1 = GARRISON_MISSION_TUTORIAL2, xOffset = 752, yOffset = -150, parent = "MissionList" },
	[3] = { text1 = GARRISON_MISSION_TUTORIAL3, specialAnchor = "threat", xOffset = 0, yOffset = -16, parent = "MissionPage" },
	[4] = { text1 = GARRISON_MISSION_TUTORIAL4, xOffset = 194, yOffset = -104, parent = "MissionPage" },
	[5] = { text1 = GARRISON_MISSION_TUTORIAL5, specialAnchor = "follower", xOffset = 0, yOffset = -20, parent = "MissionPage" },
	[6] = { text1 = GARRISON_MISSION_TUTORIAL6, specialAnchor = "threat", xOffset = 0, yOffset = -16, parent = "MissionPage" },
	[7] = { text1 = GARRISON_MISSION_TUTORIAL7, xOffset = 368, yOffset = -304, downArrow = true, parent = "MissionPage" },
	[8] = { text1 = GARRISON_MISSION_TUTORIAL9, xOffset = 536, yOffset = -474, downArrow = true, parent = "MissionPage" },	
}


-- TODO: Move these GarrisonMissionFrame_ functions to the GarrisonFollowerMission mixin
function GarrisonFollowerMission:OnClickMissionTutorialButton()
	PlaySound("igMainMenuOptionCheckBoxOn");
	self:CheckTutorials(true);
end

function GarrisonFollowerMission:CheckTutorials(advance)
	local lastTutorial = tonumber(GetCVar("lastGarrisonMissionTutorial"));
	if ( lastTutorial ) then
		if ( advance ) then
			lastTutorial = lastTutorial + 1;
			SetCVar("lastGarrisonMissionTutorial", lastTutorial);
		end
		local tutorialFrame = GarrisonMissionTutorialFrame;
		tutorialFrame.GlowBox.Button:SetScript("OnClick", function() self.OnClickMissionTutorialButton() end);
		if ( lastTutorial >= #tutorials ) then
			tutorialFrame:Hide();
		else
			local tutorial = tutorials[lastTutorial + 1];
			-- parent frame
			tutorialFrame:SetParent(GarrisonMissionFrame.MissionTab[tutorial.parent]);
			tutorialFrame:SetFrameStrata("DIALOG");
			tutorialFrame:SetPoint("TOPLEFT", GarrisonMissionFrame, 0, -21);
			tutorialFrame:SetPoint("BOTTOMRIGHT", GarrisonMissionFrame);

			local height = 58;	-- button height + top and bottom padding + spacing between text and button
			local glowBox = tutorialFrame.GlowBox;
			glowBox.BigText:SetText(tutorial.text1);
			height = height + glowBox.BigText:GetHeight();
			if ( tutorial.text2 ) then
				glowBox.SmallText:SetText(tutorial.text2);
				height = height + 12 + glowBox.SmallText:GetHeight();
				glowBox.SmallText:Show();
			else
				glowBox.SmallText:Hide();
			end
			glowBox:SetHeight(height);
			glowBox:ClearAllPoints();
			if ( tutorial.specialAnchor == "threat" ) then
				glowBox:SetPoint("TOP", self:GetMissionPage().Enemy1.Mechanics[1], "BOTTOM", tutorial.xOffset, tutorial.yOffset);
			elseif ( tutorial.specialAnchor == "follower" ) then
				local followerFrame = self:GetMissionPage().Follower1;
				glowBox:SetPoint("TOP", followerFrame.PortraitFrame, "BOTTOM", tutorial.xOffset, tutorial.yOffset);
			else
				glowBox:SetPoint("TOPLEFT", tutorial.xOffset, tutorial.yOffset);
			end
			if ( tutorial.downArrow ) then
				glowBox.ArrowUp:Hide();
				glowBox.ArrowGlowUp:Hide();
				glowBox.ArrowDown:Show();
				glowBox.ArrowGlowDown:Show();
			else
				glowBox.ArrowUp:Show();
				glowBox.ArrowGlowUp:Show();
				glowBox.ArrowDown:Hide();
				glowBox.ArrowGlowDown:Hide();
			end
			tutorialFrame:Show();
		end
	end
end

function GarrisonMissionFrame_ToggleFrame()
	if (not GarrisonMissionFrame:IsShown()) then
		ShowUIPanel(GarrisonMissionFrame);
	else
		HideUIPanel(GarrisonMissionFrame);
	end
end

function GarrisonMissionFrame_ClearMouse()
	if ( GarrisonFollowerPlacer.info ) then
		GarrisonFollowerPlacer:Hide();
		GarrisonFollowerPlacerFrame:Hide();
		GarrisonFollowerPlacer.info = nil;
		return true;
	end
	return false;
end

function GarrisonMissionPortrait_SetFollowerPortrait(portraitFrame, followerInfo, missionPage)
	portraitFrame:SetQuality(followerInfo.quality);
	if ( missionPage ) then
		local boosted = false;
		local followerLevel = followerInfo.level;
		if ( missionPage.mentorLevel and missionPage.mentorLevel > followerLevel ) then
			followerLevel = missionPage.mentorLevel;
			boosted = true;
		end
		if ( followerInfo.isTroop ) then
			portraitFrame:SetNoLevel();
		elseif ( (missionPage.showItemLevel and followerLevel == GarrisonMissionFrame.followerMaxLevel ) or GarrisonFollowerOptions[followerInfo.followerTypeID].showILevelOnFollower) then
			local followerItemLevel = followerInfo.iLevel;
			if ( missionPage.mentorItemLevel and missionPage.mentorItemLevel > followerItemLevel ) then
				followerItemLevel = missionPage.mentorItemLevel;
				boosted = true;
			end
			portraitFrame:SetILevel(followerItemLevel);
		else
			portraitFrame:SetLevel(followerLevel);
		end
		local followerBias = C_Garrison.GetFollowerBiasForMission(missionPage.missionInfo.missionID, followerInfo.followerID);
		if ( followerBias == -1 ) then
			portraitFrame.Level:SetTextColor(1, 0.1, 0.1);
		elseif ( followerBias < 0 ) then
			portraitFrame.Level:SetTextColor(1, 0.5, 0.25);
		elseif ( boosted ) then
			portraitFrame.Level:SetTextColor(0.1, 1, 0.1);
		else
			portraitFrame.Level:SetTextColor(1, 1, 1);
		end
		portraitFrame.Caution:SetShown(followerBias < 0);
		portraitFrame:SetPortraitIcon(followerInfo.portraitIconID);
	else
		portraitFrame:SetupPortrait(followerInfo);
	end
end

function GarrisonFollowerMission:UpdateRewards(itemID)
	-- mission list
	if (self.MissionTab.MissionList) then
		local missionButtons = self.MissionTab.MissionList.listScroll.buttons;
		for i = 1, #missionButtons do
			self:CheckRewardButtons(missionButtons[i].Rewards, itemID);
		end
	end
	-- mission page
	self:CheckRewardButtons(self:GetMissionPage().RewardsFrame.Rewards, itemID);
	-- mission complete
	self:CheckRewardButtons(self.MissionComplete.BonusRewards.Rewards, itemID);
end

function GarrisonMissionFrame_RandomMissionAdded(self, followerTypeID, missionID)
	if (followerTypeID == self.followerTypeID) then
		self.MissionTab.MissionList.newMissionIDs[missionID] = true;
		self.MissionTab.MissionList:Update();
	end
end

function GarrisonFollowerMission:CheckRewardButtons(rewardButtons, itemID)
	for i = 1, #rewardButtons do
		local frame = rewardButtons[i];
		if ( frame.itemID == itemID ) then
			GarrisonMissionFrame_SetItemRewardDetails(frame);
		end
	end
end

---------------------------------------------------------------------------------
--- Follower Dropdown                                                         ---
---------------------------------------------------------------------------------
function GarrisonFollowerOptionDropDown_Initialize(self)
	local info = UIDropDownMenu_CreateInfo();
	info.notCheckable = true;
	local missionFrame = self:GetParent():GetParent();
	local missionPage;
	if (missionFrame.MissionTab) then
		missionPage = missionFrame:GetMissionPage();
	end

	local follower = self.followerID and C_Garrison.GetFollowerInfo(self.followerID);
	if ( follower ) then
		if ( missionPage and missionPage:IsVisible() and missionPage.missionInfo ) then
			info.text = GARRISON_MISSION_ADD_FOLLOWER;
			info.func = function()
				missionPage:AddFollower(self.followerID);
			end
			if ( C_Garrison.GetNumFollowersOnMission(missionPage.missionInfo.missionID) >= missionPage.missionInfo.numFollowers or C_Garrison.GetFollowerStatus(self.followerID)) then		
				info.disabled = 1;
			end
			UIDropDownMenu_AddButton(info);
		end
		
		local followerStatus = C_Garrison.GetFollowerStatus(self.followerID);
		if ( followerStatus == GARRISON_FOLLOWER_INACTIVE ) then
			info.text = GARRISON_ACTIVATE_FOLLOWER;
			if ( C_Garrison.GetNumFollowerActivationsRemaining() == 0 ) then
				info.disabled = 1;
				info.tooltipWhileDisabled = 1;
				info.tooltipTitle = GARRISON_ACTIVATE_FOLLOWER;
				info.tooltipText = GARRISON_NO_MORE_FOLLOWER_ACTIVATIONS;
				info.tooltipOnButton = 1;
			elseif ( C_Garrison.GetFollowerActivationCost() > GetMoney() ) then
				info.tooltipWhileDisabled = 1;
				info.tooltipTitle = GARRISON_ACTIVATE_FOLLOWER;
				info.tooltipText = format(GARRISON_CANNOT_AFFORD_FOLLOWER_ACTIVATION, GetMoneyString(GarrisonMissionFrame.followerTypeID));
				info.tooltipOnButton = 1;			
				info.disabled = 1;
			else
				info.disabled = nil;
				info.func = function()
					StaticPopup_Show("ACTIVATE_FOLLOWER", follower.name, nil, self.followerID);
				end
			end
		else
			info.text = GARRISON_DEACTIVATE_FOLLOWER;
			info.func = function()
				StaticPopup_Show("DEACTIVATE_FOLLOWER", follower.name, nil, self.followerID);
			end
			if ( followerStatus == GARRISON_FOLLOWER_ON_MISSION ) then
				info.disabled = 1;
				info.tooltipWhileDisabled = 1;
				info.tooltipTitle = GARRISON_DEACTIVATE_FOLLOWER;
				info.tooltipText = GARRISON_FOLLOWER_CANNOT_DEACTIVATE_ON_MISSION;
				info.tooltipOnButton = 1;
			elseif ( not C_Garrison.IsAboveFollowerSoftCap(GetMissionFrame().followerTypeID) ) then
				info.disabled = 1;
			else
				info.disabled = nil;
			end
		end
		UIDropDownMenu_AddButton(info);
	end

	info.text = CANCEL;
	info.tooltipTitle = nil;
	info.func = nil;
	info.disabled = nil;
	UIDropDownMenu_AddButton(info);	
end

---------------------------------------------------------------------------------
--- Mission List                                                              ---
---------------------------------------------------------------------------------

GarrisonMissionListMixin = { }

function GarrisonMissionListMixin:OnLoad()
	self.inProgressMissions = {};
	self.availableMissions = {};
	self.newMissionIDs = {};
	
	self.listScroll:SetScript("OnMouseWheel", function(self, ...) HybridScrollFrame_OnMouseWheel(self, ...); GarrisonMissionList_UpdateMouseOverTooltip(self); end);
end

function GarrisonMissionListMixin:OnShow()
	GarrisonMissionList_UpdateMissions();
	GarrisonMissionFrame.FollowerList:Hide();
	self:GetParent():CheckTutorials();
end

function GarrisonMissionListMixin:OnHide()
	self.missions = nil;
	GarrisonFollowerPlacer:SetScript("OnUpdate", nil);
end

function GarrisonMissionListTab_OnClick(self, button)
	PlaySound("UI_Garrison_Nav_Tabs");
	GarrisonMissionListTab_SetTab(self);
end

function GarrisonMissionListTab_SetTab(self)
	local list = self:GetParent();
	if (self:GetID() == 1) then
		list.showInProgress = false;
		GarrisonMissonListTab_SetSelected(list.Tab2, false);
	else
		list.showInProgress = true;
		GarrisonMissonListTab_SetSelected(list.Tab1, false);
	end
	GarrisonMissonListTab_SetSelected(self, true);
	GarrisonMissionList_UpdateMissions();
end

function GarrisonMissonListTab_SetSelected(tab, isSelected)
	tab.SelectedLeft:SetShown(isSelected);
	tab.SelectedRight:SetShown(isSelected);
	tab.SelectedMid:SetShown(isSelected);
end

function GarrisonMissionList_UpdateMissions()
	local self = GarrisonMissionFrame.MissionTab.MissionList;
	C_Garrison.GetInProgressMissions(self.inProgressMissions, GarrisonMissionFrame.followerTypeID);
	C_Garrison.GetAvailableMissions(self.availableMissions, GarrisonMissionFrame.followerTypeID);
	Garrison_SortMissions(self.availableMissions);
	self.Tab1:SetText(AVAILABLE.." - "..#self.availableMissions)
	self.Tab2:SetText(WINTERGRASP_IN_PROGRESS.." - "..#self.inProgressMissions)
	if ( #self.inProgressMissions > 0 ) then
		self.Tab2.Left:SetDesaturated(false);
		self.Tab2.Right:SetDesaturated(false);
		self.Tab2.Middle:SetDesaturated(false);
		self.Tab2.Text:SetTextColor(1, 1, 1);
		self.Tab2:SetEnabled(true);	
	else
		self.Tab2.Left:SetDesaturated(true);
		self.Tab2.Right:SetDesaturated(true);
		self.Tab2.Middle:SetDesaturated(true);
		self.Tab2.Text:SetTextColor(0.5, 0.5, 0.5);
		self.Tab2:SetEnabled(false);
	end
	self:Update();
end

function GarrisonMissionListMixin:Update()
	local missions;
	if (self.showInProgress) then
		missions = self.inProgressMissions;
	else
		missions = self.availableMissions;
	end
	local numMissions = #missions;
	local scrollFrame = self.listScroll;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
	local buttons = scrollFrame.buttons;
	local numButtons = #buttons;

	if (numMissions == 0) then
		self.EmptyListString:Show();
	else
		self.EmptyListString:Hide();
	end
	
	for i = 1, numButtons do
		local button = buttons[i];
		local index = offset + i; -- adjust index
		if ( index <= numMissions) then
			local mission = missions[index];
			button.id = index;
			button.info = mission;
			button.Title:SetWidth(0);
			button.Title:SetText(mission.name);
			button.Level:SetText(mission.level);
			if ( mission.durationSeconds >= GARRISON_LONG_MISSION_TIME ) then
				local duration = format(GARRISON_LONG_MISSION_TIME_FORMAT, mission.duration);
				button.Summary:SetFormattedText(PARENS_TEMPLATE, duration);
			else
				button.Summary:SetFormattedText(PARENS_TEMPLATE, mission.duration);
			end
			if ( mission.locPrefix ) then
				button.LocBG:Show();
				button.LocBG:SetAtlas(mission.locPrefix.."-List");
			else
				button.LocBG:Hide();
			end
			if (mission.isRare) then
				button.RareOverlay:Show();
				button.RareText:Show();
				button.IconBG:SetVertexColor(0, 0.012, 0.291, 0.4)
			else
				button.RareOverlay:Hide();
				button.RareText:Hide();
				button.IconBG:SetVertexColor(0, 0, 0, 0.4)
			end
			local showingItemLevel = false;
			if ( mission.isMaxLevel and mission.iLevel > 0 ) then
				button.ItemLevel:SetFormattedText(NUMBER_IN_PARENTHESES, mission.iLevel);
				button.ItemLevel:Show();
				showingItemLevel = true;
			else
				button.ItemLevel:Hide();
			end
			if ( showingItemLevel and mission.isRare ) then
				button.Level:SetPoint("CENTER", button, "TOPLEFT", 40, -22);
			else
				button.Level:SetPoint("CENTER", button, "TOPLEFT", 40, -36);
			end

			button:Enable();
			if (mission.inProgress) then
				button.Overlay:Show();
				button.Summary:SetText(mission.timeLeft.." "..RED_FONT_COLOR_CODE..GARRISON_MISSION_IN_PROGRESS..FONT_COLOR_CODE_CLOSE);
			else
				button.Overlay:Hide();
			end
			if ( button.Title:GetWidth() + button.Summary:GetWidth() + 8 < 655 - mission.numRewards * 65 ) then
				button.Title:SetPoint("LEFT", 165, 0);
				button.Summary:ClearAllPoints();
				button.Summary:SetPoint("BOTTOMLEFT", button.Title, "BOTTOMRIGHT", 8, 0);
			else
				button.Title:SetPoint("LEFT", 165, 10);
				button.Title:SetWidth(655 - mission.numRewards * 65);
				button.Summary:ClearAllPoints();
				button.Summary:SetPoint("TOPLEFT", button.Title, "BOTTOMLEFT", 0, -4);	
			end			
			button.MissionType:SetAtlas(mission.typeAtlas);
			GarrisonMissionButton_SetRewards(button, mission.rewards, mission.numRewards);
			button:Show();

			local isNewMission = self.newMissionIDs[mission.missionID];
			if (isNewMission) then
				if (not button.NewHighlight) then
					button.NewHighlight = CreateFrame("Frame", nil, button, "GarrisonMissionListButtonNewHighlightTemplate");
					button.NewHighlight:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0);
					button.NewHighlight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0);
				end
				button.NewHighlight:Show();
			else
				if (button.NewHighlight) then
					button.NewHighlight:Hide();
				end
			end
		else
			button:Hide();
			button.info = nil;
		end
	end
	
	local totalHeight = numMissions * scrollFrame.buttonHeight;
	local displayedHeight = numButtons * scrollFrame.buttonHeight;
	HybridScrollFrame_Update(scrollFrame, totalHeight, displayedHeight);
end

function GarrisonMissionList_UpdateMouseOverTooltip(self)
	local buttons = self.buttons;
	for i = 1, #buttons do
		if ( buttons[i]:IsMouseOver() ) then
			GarrisonMissionButton_OnEnter(buttons[i]);
			break;
		end
	end
end

function GarrisonMissionButton_SetRewards(self, rewards, numRewards)
	if (numRewards > 0) then
		local currencyMultipliers = nil;
		local goldMultiplier = nil;
		if (self.info.inProgress) then
			currencyMultipliers, goldMultiplier = select(8, C_Garrison.GetPartyMissionInfo(self.info.missionID));
		else
			currencyMultipliers = {};
		end

		local index = 1;
		for id, reward in pairs(rewards) do
			if (not self.Rewards[index]) then
				self.Rewards[index] = CreateFrame("Frame", nil, self, "GarrisonMissionListButtonRewardTemplate");
				self.Rewards[index]:SetPoint("RIGHT", self.Rewards[index-1], "LEFT", 0, 0);
			end
			local Reward = self.Rewards[index];
			Reward.Quantity:Hide();
			Reward.itemID = nil;
			Reward.currencyID = nil;
			Reward.tooltip = nil;
			if (reward.itemID) then
				Reward.itemID = reward.itemID;
				GarrisonMissionFrame_SetItemRewardDetails(Reward);
				if ( reward.quantity > 1 ) then
					Reward.Quantity:SetText(reward.quantity);
					Reward.Quantity:Show();
				end
			else
				Reward.Icon:SetTexture(reward.icon);
				Reward.title = reward.title
				if (reward.currencyID and reward.quantity) then
					local quantity = reward.quantity;
					if (reward.currencyID == 0) then
						if (goldMultiplier ~= nil) then
							quantity = quantity * goldMultiplier;
						end
						Reward.tooltip = GetMoneyString(quantity);
						Reward.Quantity:SetText(BreakUpLargeNumbers(floor(quantity / COPPER_PER_GOLD)));
						Reward.Quantity:Show();
					else
						if (currencyMultipliers[reward.currencyID] ~= nil) then
							quantity = quantity * currencyMultipliers[reward.currencyID];
						end
						Reward.currencyID = reward.currencyID;
						Reward.Quantity:SetText(quantity);
						Reward.Quantity:Show();
					end
				else
					Reward.tooltip = reward.tooltip;
					if ( reward.followerXP ) then
						Reward.Quantity:SetText(BreakUpLargeNumbers(reward.followerXP));
						Reward.Quantity:Show();
					end
				end
			end
			Reward:Show();
			index = index + 1;
		end
	end
	
	for i = (numRewards + 1), #self.Rewards do
		self.Rewards[i]:Hide();
	end
end

function GarrisonMissionButton_OnClick(self, button)
	local missionFrame = self:GetParent():GetParent():GetParent():GetParent():GetParent();
	missionFrame:OnClickMission(self.info);
end

function GarrisonMissionButton_OnEnter(self, button)
	if (self.info == nil) then
		return;
	end

	GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT");

	if(self.info.inProgress) then
		GarrisonMissionButton_SetInProgressTooltip(self.info);
	else
		GameTooltip:SetText(self.info.name);
		GameTooltip:AddLine(string.format(GARRISON_MISSION_TOOLTIP_NUM_REQUIRED_FOLLOWERS, self.info.numFollowers), 1, 1, 1);
		GarrisonMissionButton_AddThreatsToTooltip(self.info.missionID, GarrisonMissionFrame.followerTypeID);
		if (self.info.isRare) then
			GameTooltip:AddLine(GARRISON_MISSION_AVAILABILITY);
			GameTooltip:AddLine(self.info.offerTimeRemaining, 1, 1, 1);
		end
		if not C_Garrison.IsOnGarrisonMap() then
			GameTooltip:AddLine(" ");
			GameTooltip:AddLine(GARRISON_MISSION_TOOLTIP_RETURN_TO_START, nil, nil, nil, 1);
		end
	end

	GameTooltip:Show();

	GarrisonMissionFrame.MissionTab.MissionList.newMissionIDs[self.info.missionID] = nil;
	GarrisonMissionFrame.MissionTab.MissionList:Update();
end

function GarrisonMissionButton_SetInProgressTooltip(missionInfo, showRewards)
	GameTooltip:SetText(missionInfo.name);
	-- level
	if ( missionInfo.isMaxLevel and missionInfo.iLevel > 0 ) then
		GameTooltip:AddLine(format(GARRISON_MISSION_LEVEL_ITEMLEVEL_TOOLTIP, missionInfo.level, missionInfo.iLevel), 1, 1, 1);
	else
		GameTooltip:AddLine(format(GARRISON_MISSION_LEVEL_TOOLTIP, missionInfo.level), 1, 1, 1);
	end
	-- completed?
	if(missionInfo.isComplete) then
		GameTooltip:AddLine(COMPLETE, 1, 1, 1);
	end
	-- success chance
	local successChance = C_Garrison.GetMissionSuccessChance(missionInfo.missionID);
	if ( successChance ) then
		GameTooltip:AddLine(format(GARRISON_MISSION_PERCENT_CHANCE, successChance), 1, 1, 1);
	end

	if ( showRewards ) then
		GameTooltip:AddLine(" ");
		GameTooltip:AddLine(REWARDS);
		for id, reward in pairs(missionInfo.rewards) do
			if (reward.quality) then
				GameTooltip:AddLine(ITEM_QUALITY_COLORS[reward.quality + 1].hex..reward.title..FONT_COLOR_CODE_CLOSE);
			elseif (reward.itemID) then 
				local itemName, _, itemRarity, _, _, _, _, _, _, itemTexture = GetItemInfo(reward.itemID);
				if itemName then
					GameTooltip:AddLine(ITEM_QUALITY_COLORS[itemRarity].hex..itemName..FONT_COLOR_CODE_CLOSE);
				end
			elseif (reward.followerXP) then
				GameTooltip:AddLine(reward.title, 1, 1, 1);
			else
				GameTooltip:AddLine(reward.title, 1, 1, 1);
			end
		end
	end

	if (missionInfo.followers ~= nil) then
		GameTooltip:AddLine(" ");
		GameTooltip:AddLine(GARRISON_FOLLOWERS);
		for i=1, #(missionInfo.followers) do
			GameTooltip:AddLine(C_Garrison.GetFollowerName(missionInfo.followers[i]), 1, 1, 1);
		end
	end
end

function GarrisonMissionPageFollowerFrame_OnMouseUp(self, button)
	local mainFrame = self:GetParent():GetParent():GetParent();
	mainFrame:OnMouseUpMissionFollower(self, button);
end


---------------------------------------------------------------------------------
--- Mission Page                                                              ---
---------------------------------------------------------------------------------
GarrisonMissionPageMixin = { }

function GarrisonMissionPage_OnLoad(self)
	self:RegisterEvent("GARRISON_FOLLOWER_LIST_UPDATE");
	self:RegisterEvent("GARRISON_FOLLOWER_XP_CHANGED");
	if (self.BuffsFrame and self.FollowerModel) then
		self.BuffsFrame:SetFrameLevel(self.FollowerModel:GetFrameLevel() + 1);
	end
	self:RegisterForClicks("RightButtonUp");
end

function GarrisonMissionPage_OnEvent(self, event, ...)
	local mainFrame = self:GetParent():GetParent();
	if ( event == "GARRISON_FOLLOWER_LIST_UPDATE" or event == "GARRISON_FOLLOWER_XP_CHANGED" ) then
		local followerTypeID = ...;
		if (followerTypeID == mainFrame.followerTypeID) then
			if ( self.missionInfo ) then
				local mentorLevel, mentorItemLevel = C_Garrison.GetPartyMentorLevels(self.missionInfo.missionID);
				self.mentorLevel = mentorLevel;
				self.mentorItemLevel = mentorItemLevel;
				mainFrame.followerCounters = C_Garrison.GetBuffedFollowersForMission(self.missionInfo.missionID)
				mainFrame.followerTraits = C_Garrison.GetFollowersTraitsForMission(self.missionInfo.missionID);			
			else
				self.mentorLevel = nil;
				self.mentorItemLevel = nil;
			end
			mainFrame:UpdateMissionParty(self.Followers);

			if ( self.missionInfo ) then
				local missionID = self.missionInfo.missionID;
				mainFrame.FollowerList:UpdateFollowers();
				mainFrame:UpdateMissionData(self);
				if (self.followers and self.Enemies) then
					GarrisonMissionPage_SetCounters(self.Followers, self.Enemies, self.missionInfo.missionID);
				end
				return;
			end
		end
	end
	mainFrame:UpdateStartButton(self);
end

function GarrisonMissionPage_OnShow(self)
	local mainFrame = self:GetParent():GetParent();
	mainFrame.FollowerList.showUncollected = false;
	mainFrame.FollowerList.showCounters = true;
	mainFrame.FollowerList.canExpand = true;
	mainFrame.FollowerList:Show();
	mainFrame:UpdateStartButton(self);
end

function GarrisonMissionPage_OnHide(self)
	local mainFrame = self:GetParent():GetParent();
	mainFrame.FollowerList.showCounters = false;
	mainFrame.FollowerList.canExpand = false;
	mainFrame.FollowerList.showUncollected = true;

	self.lastUpdate = nil;
end

function GarrisonMissionPage_OnUpdate(self)
	if ( self.missionInfo.offerEndTime and self.missionInfo.offerEndTime <= GetTime() ) then
		-- mission expired
		GarrisonMissionFrame_ClearMouse();
		self.CloseButton:Click();
	end
end

function GarrisonMissionPageEnvironment_OnEnter(self)
	local missionPage = self:GetParent():GetParent();
	local _, _, environment, environmentDesc = C_Garrison.GetMissionInfo(missionPage.missionInfo.missionID);
	if ( environment ) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		GameTooltip:SetText(environment);
		GameTooltip:AddLine(environmentDesc, 1, 1, 1, 1);
		GameTooltip:Show();
	end
end

function GarrisonMissionPageMixin:UpdateFollowerModel(info)
	if ( self.missionInfo.numFollowers == 1 ) then
		local model = self.FollowerModel;
		model:Show();
		model:SetTargetDistance(0);
		GarrisonMission_SetFollowerModel(model, info.followerID, info.displayID);
		model:SetHeightFactor(info.height or 1);
		model:InitializeCamera(info.scale or 1);
		model:SetFacing(-.2);
		self.EmptyFollowerModel:Hide();
	end
end

function GarrisonMissionPageMixin:UpdateEmptyString()
	if ( C_Garrison.GetNumFollowersOnMission(self.missionInfo.missionID) == 0 ) then
		self.EmptyString:Show();
	else
		self.EmptyString:Hide();
	end
end

function GarrisonMissionPageMixin:GetFollowerFrameFromID(followerID)
	for i = 1, #self.Followers do
		local followerFrame = self.Followers[i];
		if (followerFrame.info and followerFrame.info.followerID == followerID) then
			return followerFrame;
		end
	end
	return nil;
end

function GarrisonMissionPageMixin:UpdatePortraitPulse()
	-- only pulse the first available slot
	local pulsed = false;
	for i = 1, #self.Followers do
		local followerFrame = self.Followers[i];
		if ( followerFrame.info ) then
			followerFrame.PortraitFrame.PulseAnim:Stop();

			if ( C_Garrison.CanSpellTargetFollowerIDWithAddAbility(followerFrame.info.followerID) ) then
				followerFrame.PortraitFrame.SpellTargetHighlight:Show();
			else
				followerFrame.PortraitFrame.SpellTargetHighlight:Hide();
			end
		else
			followerFrame.PortraitFrame.SpellTargetHighlight:Hide();

			if ( pulsed ) then
				followerFrame.PortraitFrame.PulseAnim:Stop();
			else
				followerFrame.PortraitFrame.PulseAnim:Play();
				pulsed = true;
			end			
		end
	end
end

function GarrisonMissionPageMixin:AddFollower(followerID)
	local missionFrame = self:GetParent():GetParent();
	for i = 1, #self.Followers do
		local followerFrame = self.Followers[i];
		if ( not followerFrame.info ) then
			local followerInfo = C_Garrison.GetFollowerInfo(followerID);
			missionFrame:AssignFollowerToMission(followerFrame, followerInfo);
			break;
		end
	end
end

---------------------------------------------------------------------------------
--- Mission Page: Placing Followers/Starting Mission                          ---
---------------------------------------------------------------------------------
function GarrisonFollowerListButton_OnDragStart(self, button)
	local mainFrame = self:GetFollowerList():GetParent();
	if (mainFrame.OnDragStartFollowerButton) then
		mainFrame:OnDragStartFollowerButton(GarrisonFollowerPlacer, self, 24);
	end
end

function GarrisonFollowerListButton_OnDragStop(self)
	local mainFrame = self:GetFollowerList():GetParent();
	if (mainFrame.OnDragStopFollowerButton) then
		mainFrame:OnDragStopFollowerButton(GarrisonFollowerPlacer);
	end
end

function GarrisonMissionPageFollowerFrame_OnDragStart(self)
	local mainFrame = self:GetParent():GetParent():GetParent();
	mainFrame:OnDragStartMissionFollower(GarrisonFollowerPlacer, self, 24);
end

function GarrisonMissionPageFollowerFrame_OnDragStop(self)
	local mainFrame = self:GetParent():GetParent():GetParent();
	mainFrame:OnDragStopMissionFollower(GarrisonFollowerPlacer);
end

function GarrisonMissionPageFollowerFrame_OnReceiveDrag(self)
	local mainFrame = self:GetParent():GetParent():GetParent();
	mainFrame:OnReceiveDragMissionFollower(GarrisonFollowerPlacer, self);
end

function GarrisonMissionPageFollowerFrame_OnEnter(self)
	local missionPage = self:GetParent();
	if not self.info then 
		return;
	end

	GarrisonFollowerTooltip:ClearAllPoints();
	GarrisonFollowerTooltip:SetPoint("TOPLEFT", self, "BOTTOMRIGHT");	
	GarrisonFollowerTooltip_Show(self.info.garrFollowerID, 
		self.info.isCollected,
		C_Garrison.GetFollowerQuality(self.info.followerID),
		C_Garrison.GetFollowerLevel(self.info.followerID), 
		C_Garrison.GetFollowerXP(self.info.followerID),
		C_Garrison.GetFollowerLevelXP(self.info.followerID),
		C_Garrison.GetFollowerItemLevelAverage(self.info.followerID), 
		C_Garrison.GetFollowerAbilityAtIndex(self.info.followerID, 1),
		C_Garrison.GetFollowerAbilityAtIndex(self.info.followerID, 2),
		C_Garrison.GetFollowerAbilityAtIndex(self.info.followerID, 3),
		C_Garrison.GetFollowerAbilityAtIndex(self.info.followerID, 4),
		C_Garrison.GetFollowerTraitAtIndex(self.info.followerID, 1),
		C_Garrison.GetFollowerTraitAtIndex(self.info.followerID, 2),
		C_Garrison.GetFollowerTraitAtIndex(self.info.followerID, 3),
		C_Garrison.GetFollowerTraitAtIndex(self.info.followerID, 4),
		true,
		C_Garrison.GetFollowerBiasForMission(missionPage.missionInfo.missionID, self.info.followerID) < 0.0
		);
end

function GarrisonMissionPageFollowerFrame_OnLeave(self)
	GarrisonFollowerTooltip:Hide();
end


---------------------------------------------------------------------------------
--- Garrison Follower Mission Complete Mixin Functions                        ---
---------------------------------------------------------------------------------

GarrisonFollowerMissionComplete = {};

function GarrisonFollowerMissionComplete:AnimLine(entry)
	self:SetEncounterModels(self.encounterIndex);
	entry.duration = 0.5;

	local encountersFrame = self.Stage.EncountersFrame;
	local mechanicsFrame = self.Stage.EncountersFrame.MechanicsFrame;
	local numMechs, playCounteredSound = self:ShowEncounterMechanics(encountersFrame, mechanicsFrame, self.encounterIndex);
	if ( playCounteredSound ) then
		PlaySound("UI_Garrison_Mission_Threat_Countered");
	end
	mechanicsFrame:SetParent(encountersFrame.Encounters[self.encounterIndex]);
	mechanicsFrame:SetPoint("BOTTOM", encountersFrame.Encounters[self.encounterIndex], (numMechs - 1) * -16, -5);
	encountersFrame.Encounters[self.encounterIndex].CheckFrame:SetFrameLevel(mechanicsFrame:GetFrameLevel() + 1);
	encountersFrame.Encounters[self.encounterIndex].Name:Show();
	encountersFrame.Encounters[self.encounterIndex].GlowFrame.OnAnim:Play();
	if ( self.encounterIndex > 1 ) then
		encountersFrame.Encounters[self.encounterIndex - 1].Name:Hide();
		encountersFrame.Encounters[self.encounterIndex - 1].GlowFrame.OffAnim:Play();
	end
end

function GarrisonFollowerMissionComplete:AnimModels(entry)
	local currentAnim = self.animInfo[self.encounterIndex];
	GarrisonMissionComplete.AnimModels(self, entry, LE_PAN_NONE_RANGED, currentAnim.movementType or LE_PAN_NONE);
end

function GarrisonFollowerMissionComplete:AnimPortrait(entry)
	local encounter = self.Stage.EncountersFrame.Encounters[self.encounterIndex];
	if ( self.currentMission.succeeded ) then
		encounter.CheckFrame.SuccessAnim:Play();
	else
		if ( self.currentMission.failedEncounter == self.encounterIndex ) then
			encounter.CheckFrame.FailureAnim:Play();
			PlaySound("UI_Garrison_Mission_Complete_Encounter_Fail");
		else
			encounter.CheckFrame.SuccessAnim:Play();
			PlaySound("UI_Garrison_Mission_Complete_Mission_Success");
		end
	end
	entry.duration = 0.5;
end

function GarrisonFollowerMissionComplete:AnimCheckEncounters(entry)
	self.encounterIndex = self.encounterIndex + 1;
	if ( self.animInfo[self.encounterIndex] and (not self.currentMission.failedEncounter or self.encounterIndex <= self.currentMission.failedEncounter) ) then
		-- restart for new encounter
		self.animIndex = 0;
		entry.duration = 0.25;
	else
		self.Stage.EncountersFrame.FadeOut:Play();	-- has OnFinished to hide
		entry.duration = 0;
	end
end

function GarrisonFollowerMissionComplete:SetNumFollowers(size)
	local followersFrame = self.Stage.FollowersFrame;
	followersFrame:Show();
	if (size == 1) then
		followersFrame.Follower2:Hide();
		followersFrame.Follower3:Hide();
		followersFrame.Follower1:SetPoint("LEFT", followersFrame, "BOTTOMLEFT", 200, -4);
	elseif (size == 2) then
		followersFrame.Follower2:Show();
		followersFrame.Follower3:Hide();
		followersFrame.Follower1:SetPoint("LEFT", followersFrame, "BOTTOMLEFT", 75, -4);
		followersFrame.Follower2:SetPoint("LEFT", followersFrame.Follower1, "RIGHT", 75, 0);
	else
		followersFrame.Follower2:Show();
		followersFrame.Follower3:Show();
		followersFrame.Follower1:SetPoint("LEFT", followersFrame, "BOTTOMLEFT", 25, -4);
		followersFrame.Follower2:SetPoint("LEFT", followersFrame.Follower1, "RIGHT", 0, 0);
	end
end

function GarrisonFollowerMissionComplete:AnimFollowersIn(entry)
	local missionList = self.completeMissions;
	local missionIndex = self.currentIndex;
	local mission = missionList[missionIndex];

	local numFollowers = #mission.followers;
	self:SetNumFollowers(numFollowers);
	self:SetupEnding(numFollowers);
	local stage = self.Stage;
	if (stage.ModelLeft:IsShown()) then
		if ( self.skipAnimations ) then
			stage.ModelLeft:SetAlpha(1);
		else
			stage.ModelLeft.FadeIn:Play();		-- no OnFinished
		end
	end
	if (stage.ModelRight:IsShown()) then
		if ( self.skipAnimations ) then
			stage.ModelRight:SetAlpha(1);
		else	
			stage.ModelRight.FadeIn:Play();		-- no OnFinished
		end
	end
	if (stage.ModelMiddle:IsShown()) then
		if ( self.skipAnimations ) then
			stage.ModelMiddle:SetAlpha(1);
		else	
			stage.ModelMiddle.FadeIn:Play();	-- no OnFinished
		end
	end
	for i = 1, numFollowers do
		local followerFrame = stage.FollowersFrame.Followers[i];
		followerFrame.XPGain:SetAlpha(0);
		followerFrame.LevelUpFrame:Hide();
	end
	stage.FollowersFrame.FadeIn:Stop();
	if ( self.skipAnimations ) then
		stage.FollowersFrame:SetAlpha(1);
	else
		stage.FollowersFrame.FadeIn:Play();
	end
	-- preload next set
	local nextIndex = self.currentIndex + 1;
	if ( missionList[nextIndex] ) then
		MissionCompletePreload_LoadMission(self:GetParent(), missionList[nextIndex].missionID);
	end
	
	if ( entry ) then
		if ( self.skipAnimations ) then
			entry.duration = 0;
		else
			entry.duration = 0.5;
		end
	end
end

-- if duration is nil it will be set in the onStart function
-- duration is irrelevant for the last entry
-- WARNING: If you're going to alter this, make sure OnSkipKeyPressed still works
local ANIMATION_CONTROL = {
	[1] = { duration = nil,		onStartFunc = GarrisonFollowerMissionComplete.AnimLine },			-- line between encounters
	[2] = { duration = nil,		onStartFunc = GarrisonMissionComplete.AnimCheckModels },			-- check that models are loaded
	[3] = { duration = nil,		onStartFunc = GarrisonFollowerMissionComplete.AnimModels },					-- model fight
	[4] = { duration = nil,		onStartFunc = GarrisonMissionComplete.AnimPlayImpactSound },		-- impact sound when follower hits
	[5] = { duration = 0.45,	onStartFunc = GarrisonFollowerMissionComplete.AnimPortrait },		-- X over portrait
	[6] = { duration = nil,		onStartFunc = GarrisonFollowerMissionComplete.AnimCheckEncounters },		-- evaluate whether to do next encounter or move on
	[7] = { duration = 0.75,	onStartFunc = GarrisonMissionComplete.AnimRewards },				-- reward panel
	[8] = { duration = 0,		onStartFunc = GarrisonMissionComplete.AnimLockBurst },				-- explode the lock if mission successful		
	[9] = { duration = 0,		onStartFunc = GarrisonMissionComplete.AnimCleanUp },				-- clean up any model anims
	[10] = { duration = nil,	onStartFunc = GarrisonFollowerMissionComplete.AnimFollowersIn },	-- show all the mission followers
	[11] = { duration = 0,		onStartFunc = GarrisonMissionComplete.AnimXP },						-- follower xp
	[12] = { duration = nil,	onStartFunc = GarrisonMissionComplete.AnimSkipWait },				-- wait if we're in skip mode
	[13] = { duration = 0,		onStartFunc = GarrisonMissionComplete.AnimSkipNext },				-- click Next button if we're in skip mode
};

function GarrisonFollowerMissionComplete:SetAnimationControl()
	self.animationControl = ANIMATION_CONTROL;
end

function GarrisonFollowerMissionComplete:BeginAnims(animIndex)
	GarrisonMissionComplete.BeginAnims(self, animIndex);
	self.encounterIndex = 1;
end

function GarrisonFollowerMissionComplete:SetFollowerData(follower, name, className, classAtlas, portraitIconID)
	follower.PortraitFrame:SetPortraitIcon(portraitIconID);
	follower.Name:SetText(name);
	follower.Class:SetAtlas(classAtlas);
end

function GarrisonFollowerMissionComplete:SetFollowerLevel(followerFrame, level, quality, currXP, maxXP)
	local maxLevel = self:GetParent().followerMaxLevel;
	level = min(level, maxLevel);
	if ( maxXP and maxXP > 0 ) then
		followerFrame.XP:SetMinMaxValues(0, maxXP);
		followerFrame.XP:SetValue(currXP);
		followerFrame.XP:Show();
		followerFrame.Name:ClearAllPoints();
		followerFrame.Name:SetPoint("LEFT", 58, 6);
	else
		followerFrame.XP:Hide();
		followerFrame.Name:ClearAllPoints();		
		followerFrame.Name:SetPoint("LEFT", 58, 0);
	end
	followerFrame.XP.level = level;
	followerFrame.XP.quality = quality;
	followerFrame.PortraitFrame:SetLevel(level);
	followerFrame.PortraitFrame:SetQuality(quality);
end

function GarrisonFollowerMissionComplete:DetermineFailedEncounter(missionID, succeeded)
	if ( succeeded ) then
		self.currentMission.failedEncounter = nil;
	else
		-- pick an encounter to fail
		local uncounteredMechanics = self.Stage.EncountersFrame.uncounteredMechanics;
		local failedEncounters = { };
		for i = 1, #uncounteredMechanics do
			if ( #uncounteredMechanics[i] > 0 ) then
				tinsert(failedEncounters, i);
			end
		end
		-- It's possible that there are no encounters with uncountered mechanics on a failed mission because of lower-level followers
		if ( #failedEncounters > 0 ) then
			local rnd = random(1, #failedEncounters);
			self.currentMission.failedEncounter = failedEncounters[rnd];
		elseif ( #self.animInfo > 0 ) then
			self.currentMission.failedEncounter = random(1, #self.animInfo);
		else
			self.currentMission.failedEncounter = 1;
		end
	end
end


---------------------------------------------------------------------------------
--- Enemy Portrait                                                            ---
---------------------------------------------------------------------------------

function GarrisonEnemyPortait_Set(portrait, portraitFileDataID)
	if (portraitFileDataID == nil or portraitFileDataID == 0) then
		-- unknown icon file ID; use the default silhouette portrait
		portrait:SetTexture("Interface\\Garrison\\Portraits\\FollowerPortrait_NoPortrait");
	else
		portrait:SetTexture(portraitFileDataID);
	end
end
