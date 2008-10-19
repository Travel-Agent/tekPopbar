
local _, _, _, enabled = GetAddOnInfo("tekPopBar")
if not enabled then return end

local factory = tekPopBar_MakeButton
tekPopBar_MakeButton = nil


local _, class = UnitClass("player")

local usebars = {4, 10}
if class ~= "DRUID" and class ~= "PRIEST" then table.insert(usebars, 7) end
if class ~= "DRUID" then table.insert(usebars, 8) end
if class ~= "DRUID" then table.insert(usebars, 9) end


local gap = -6


local anch1 = MultiBarRightButton1
for actionID=36,25,-1 do
	local mainbtn = factory("tekPopbar"..actionID, UIParent, "ActionBarButtonTemplate,SecureHandlerEnterLeaveTemplate")
	mainbtn:SetPoint("BOTTOM", anch1, "TOP", 0, -gap)
	mainbtn:SetAttribute("*type*", "action")
	mainbtn:SetAttribute("*action*", actionID)

	mainbtn:SetAttribute("_onenter", [[
		control:ChildUpdate("doshow")
		control:SetAnimating(false)
	]])
	mainbtn:SetAttribute("_onleave", [[
		elap = 0
		control:SetAnimating(true)
	]])
	mainbtn:SetAttribute("_onupdate", [[
		if self:IsUnderMouse(true) then
			elap = 0
		else
			elap = elap + elapsed
			if elap >= 2 then
				control:ChildUpdate("dohide")
				control:SetAnimating(false)
			end
		end
	]])

	local anch2 = mainbtn
	for _,bar in ipairs(usebars) do
		local btnID = actionID - 36 + bar*12
		local btn = factory("tekPopbar"..btnID, mainbtn, "ActionBarButtonTemplate")
		btn:SetAttribute("*type*", "action")
		btn:SetAttribute("*action*", btnID)
		btn:SetPoint("RIGHT", anch2, "LEFT", gap, 0)

		btn:Hide()

		mainbtn:SetAttribute("_adopt", btn)
		btn:SetAttribute("_childupdate-doshow", [[ self:Show() ]])
		btn:SetAttribute("_childupdate-dohide", [[ self:Hide() ]])

		anch2 = btn
	end

	anch1 = mainbtn
end


tekPopbar36:ClearAllPoints()
tekPopbar36:SetPoint("BOTTOMRIGHT", WorldFrame, "BOTTOMRIGHT", 0, -gap)

local function movetracker()
	QuestWatchFrame:ClearAllPoints()
	QuestWatchFrame:SetPoint("TOP", MinimapCluster, "BOTTOM", 0, 0)
	QuestWatchFrame:SetPoint("RIGHT", tekPopbar25, "LEFT", -6, 0)

	AchievementWatchFrame:ClearAllPoints()
	AchievementWatchFrame:SetPoint("TOPRIGHT", tekPopbar30, "TOPLEFT", -6, 0)
end

hooksecurefunc("UIParent_ManageFramePositions", movetracker)
movetracker()
