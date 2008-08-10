
-- Bars:
-- cat = 7, moon/tree = 8, bear = 9
-- battle = 7, def = 8, berz = 9
-- stealth = 7
-- shadow = 6

local factory = tekPopBar_MakeButton


local _G = _G
local _, class = UnitClass("player")
local usebars = {2,5,6}
local gap = 5


local function PermaHide(frame)
	frame:Hide()
	frame.Show = frame.Hide
end


-----------------------------------
--      Create mah buttons!      --
-----------------------------------

local anch1 = ChatFrame1

--~ local driver = CreateFrame("Frame", nil, UIParent)
--~ local driver = CreateFrame("Frame", nil, UIParent, "SecureStateHeaderTemplate")
--~ RegisterStateDriver(driver, "state", "[bonusbar:1]1;[bonusbar:2]2;[bonusbar:3]3;[bonusbar:4]4;[bonusbar:5]5;0") -- See http://www.wowwiki.com/API_GetBonusBarOffset for details
--~ driver:SetAttribute("statemap-state", "$input")
--~ driver:SetAttribute("statebutton", "1:won;2:tew;3:twee;4:foah;5:fyve")

local possbar = {
	132,      121,      124, -- nil            attack          action1
	122, 131, 125, 126, 127, -- follow nil     action2 action3 action4
	123, 128, 129, 130,      -- stay   aggro   defen   passive
}
for actionID=1,12 do
	local mainbtn = factory("tekPopbar"..actionID, UIParent, "ActionBarButtonTemplate,SecureHandlerEnterLeaveTemplate")
	mainbtn:SetPoint("LEFT", anch1, "RIGHT", (actionID == 4 or actionID == 9) and gap * 2.5 or gap, 0)
--~ 	driver:SetAttribute('addchild', mainbtn)
--~ 	mainbtn:SetAttribute('useparent-statebutton', 'true')
--~ 	mainbtn:SetAttribute("*childraise-OnEnter", true)
--~ 	mainbtn:SetAttribute("*childstate-OnEnter", "enter")
--~ 	mainbtn:SetAttribute("*childstate-OnLeave", "leave")
--~ 	mainbtn:SetAttribute("*action-won", 6*12 + actionID)
--~ 	mainbtn:SetAttribute("*action-tew", 7*12 + actionID)
--~ 	mainbtn:SetAttribute("*action-twee", 8*12 + actionID)
--~ 	mainbtn:SetAttribute("*action-foah", 9*12 + actionID)
--~ 	mainbtn:SetAttribute("*action-fyve", possbar[actionID])
	mainbtn:SetAttribute("*action*", actionID)
	mainbtn.action = actionID

	mainbtn:RegisterEvent("UPDATE_BINDINGS")

	mainbtn:SetAttribute("_execute", [[buttons = newtable()]])
	mainbtn:SetAttribute("_onenter", [[for _,button in pairs(buttons) do button:Show() end]])
	mainbtn:SetAttribute("_onleave", [[
		elap = 0
		return nil, nil, true
	]])
	mainbtn:SetAttribute("_onupdate", [[
		if self:IsUnderMouse(true) then return nil, nil, true end

		elap = elap + elapsed
		if elap >= 2 then
			for _,button in pairs(buttons) do button:Hide() end
			return
		end
		return nil, nil, true
	]])


--~ 	local hdr = CreateFrame("Frame", "tekPopbarHdr"..actionID, mainbtn, "SecureStateHeaderTemplate")
	local hdr = CreateFrame("Frame", "tekPopbarHdr"..actionID, mainbtn)
	hdr:SetPoint("CENTER") hdr:SetWidth(2) hdr:SetHeight(2)
	hdr:SetAttribute("statemap-anchor-enter", "1")
	hdr:SetAttribute("statemap-anchor-leave", ";")
	hdr:SetAttribute("delaystatemap-anchor-leave", "1:0")
	hdr:SetAttribute("delaytimemap-anchor-leave",  "1:1")
	hdr:SetAttribute("delayhovermap-anchor-leave", "1:true")
	mainbtn:SetAttribute("anchorchild", hdr)

	local anch2 = mainbtn
	for _,bar in ipairs(usebars) do
		local btnID = actionID - 12 + bar*12
		local btn = factory("tekPopbar"..btnID, mainbtn, "ActionBarButtonTemplate")
		btn:SetAttribute("type", "action")
		btn:SetAttribute("*action*", btnID)
		btn:SetPoint("BOTTOM", anch2, "TOP", 0, gap)
		anch2 = btn

		btn:Hide()

		mainbtn:SetAttribute("_adopt", btn)
		mainbtn:SetAttribute("_frame-kid", btn)
		mainbtn:SetAttribute("_execute", "buttons["..bar.."] = self:GetAttribute('frameref-kid')")
	end

	mainbtn:SetUpdater()

	anch1 = mainbtn
end


tekPopbar1:ClearAllPoints()
tekPopbar1:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", 0, 10)


MainMenuBar:Hide()


--------------------------------
--      Bonus Action Bar      --
--------------------------------

local f = CreateFrame("Frame", "BonusActionBarParent", UIParent)
f:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, -100) f:SetWidth(1) f:SetHeight(1)
BonusActionBarFrame:SetParent(f)


--~ ---------------------------
--~ --      Possess Bar      --
--~ ---------------------------

PossessBarFrame:SetParent(UIParent)
PossessButton1:SetNormalTexture("")
PossessButton2:SetNormalTexture("")
PossessButton1:ClearAllPoints()
PossessButton1:SetPoint("BOTTOMLEFT", tekPopbar1, "TOPRIGHT", gap, gap)
--~ PermaHide(PossessBarLeft)
--~ PermaHide(PossessBarRight)


