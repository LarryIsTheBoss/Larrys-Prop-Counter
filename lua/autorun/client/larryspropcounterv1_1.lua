--[[This addon is created and maintained by QuirkyLarry.
Discord: quirkylarry
Steam: https://steamcommunity.com/id/QuirkyLarry/
Please do not re-upload without permission.
You may contact me for questions, suggestions, or addon requests.]]--
-- LPC = Larry's Prop Counter
-- Clr = Color
local LPC = {
	-- Sets the HUD as enabled or disable by default. 1 = enabled, 0 = disabled.
	["enable"] = 1,
	-- Enables Rainbow barf by default. 1 = enabled, 0 = disabled.
	["rainbow"] = 0,
	-- Sets the default size the HUD should be. 0-10 is allowed, 1 is default.
	["scale"] = 1,
	-- Default Header color. The background behind 'Props:'. - Default: 0,191,255,255
	HeadClr = {['r'] = 0,['g'] = 191,['b'] = 255,['a'] = 255,},
	-- Default Background color. The background behind '0'. - Default: 255,255,255,255
	BgClr = {['r'] = 255,['g'] = 255,['b'] = 255,['a'] = 255,},
	-- Default Header text color. The text 'Props:' color. - Default: 0,191,255
	HeadTextClr = {['r'] = 255,['g'] = 255,['b'] = 255,},
	-- Default Count text color. The text '0' color. - Default: 0,191,255
	BgTextClr = {['r'] = 0,['g'] = 191,['b'] = 255,},
	-- Default location the hud starts at on the y/vertical-axis. UP/DOWN - Default: 10
	["VerticalLocation"] = 10,
	-- Default location the hud starts at on the x/horizontal-axis. Left/Right - Default: 10
	["HorizontalLocation"] = 10,
}

local Create_ClientConVar = CreateClientConVar
local Get_ConVar = GetConVar
local hook_Add = hook.Add
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local surface_SetTextColor = surface.SetTextColor
local surface_SetTextPos = surface.SetTextPos
local surface_SetFont = surface.SetFont
local surface_DrawText = surface.DrawText
local _ScrW, _ScrH = ScrW(),ScrH()

Create_ClientConVar("LPC_enabled", LPC["enable"], true, false, "", 0, 1)
Create_ClientConVar("LPC_rainbow", LPC["rainbow"], true, false, "", 0, 1)
Create_ClientConVar("LPC_scale", LPC["scale"], true, false, "", 0, 10)
Create_ClientConVar("LPC_verticallocation", LPC["VerticalLocation"], true, false, "", 1, ScrH())
Create_ClientConVar("LPC_horizontallocation", LPC["HorizontalLocation"], true, false, "", 1, ScrW())
Create_ClientConVar("LPC_headercolor_r", LPC.HeadClr['r'], true, false, "", 0, 255 )
Create_ClientConVar("LPC_headercolor_g", LPC.HeadClr['g'], true, false, "", 0, 255 )
Create_ClientConVar("LPC_headercolor_b", LPC.HeadClr['b'], true, false, "", 0, 255 )
Create_ClientConVar("LPC_headercolor_a", LPC.HeadClr['a'], true, false, "", 0, 255 )
Create_ClientConVar("LPC_backgroundcolor_r", LPC.BgClr['r'], true, false, "", 0, 255 )
Create_ClientConVar("LPC_backgroundcolor_g", LPC.BgClr['g'], true, false, "", 0, 255 )
Create_ClientConVar("LPC_backgroundcolor_b", LPC.BgClr['b'], true, false, "", 0, 255 )
Create_ClientConVar("LPC_backgroundcolor_a", LPC.BgClr['a'], true, false, "", 0, 255 )
Create_ClientConVar("LPC_headertextcolor_r", LPC.HeadTextClr['r'], true, false, "", 0, 255 )
Create_ClientConVar("LPC_headertextcolor_g", LPC.HeadTextClr['g'], true, false, "", 0, 255 )
Create_ClientConVar("LPC_headertextcolor_b", LPC.HeadTextClr['b'], true, false, "", 0, 255 )
Create_ClientConVar("LPC_backgroundtextcolor_r", LPC.BgTextClr['r'], true, false, "", 0, 255 )
Create_ClientConVar("LPC_backgroundtextcolor_g", LPC.BgTextClr['g'], true, false, "", 0, 255 )
Create_ClientConVar("LPC_backgroundtextcolor_b", LPC.BgTextClr['b'], true, false, "", 0, 255 )

local enabled, rainbow, LPC_Scale = Get_ConVar("LPC_enabled"):GetBool(), Get_ConVar("LPC_rainbow"):GetBool(), Get_ConVar("LPC_scale"):GetFloat()
local vLocation, hLocation = Get_ConVar("LPC_verticallocation"):GetInt(), Get_ConVar("LPC_horizontallocation"):GetInt()
local hr,hg,hb,ha = Get_ConVar("LPC_headercolor_r"):GetInt(), Get_ConVar("LPC_headercolor_g"):GetInt(), Get_ConVar("LPC_headercolor_b"):GetInt(), Get_ConVar("LPC_headercolor_a"):GetInt()
local htr,htg,htb = Get_ConVar("LPC_headertextcolor_r"):GetInt(), Get_ConVar("LPC_headertextcolor_g"):GetInt(), Get_ConVar("LPC_headertextcolor_b"):GetInt()
local bgr,bgg,bgb,bga = Get_ConVar("LPC_backgroundcolor_r"):GetInt(), Get_ConVar("LPC_backgroundcolor_g"):GetInt(), Get_ConVar("LPC_backgroundcolor_b"):GetInt(), Get_ConVar("LPC_backgroundcolor_a"):GetInt()
local bgtr,bgtg,bgtb = Get_ConVar("LPC_backgroundtextcolor_r"):GetInt(), Get_ConVar("LPC_backgroundtextcolor_g"):GetInt(), Get_ConVar("LPC_backgroundtextcolor_b"):GetInt()

local fonts = {
	["LarrysPropCounterText"] = {
		font = "Arial",
		extended = false,
		sizeFunc = function()
			return (_ScrW * .015) * LPC_Scale
		end,
		weight = 600,
		antialias = true,
	}
}

local function generateFonts()
	for k, v in pairs( fonts ) do
		if isfunction(v.sizeFunc) then
			v.size = v.sizeFunc()
		end

		surface.CreateFont( k, v )
	end
end

generateFonts()

local function pcHUD()
	if not enabled then return end
	surface_SetFont( "LarrysPropCounterText" )
	local pcpropText,count  = "Props: ", LocalPlayer():GetCount("props") or 0
	local tw, th = surface.GetTextSize(pcpropText)
	local ptw, pth = surface.GetTextSize(tostring(count))
	if not rainbow then surface_SetDrawColor(hr,hg,hb,ha) elseif rainbow then surface_SetDrawColor(HSVToColor(  ( CurTime() * 400 ) % 360, 1, 1 )) end
	surface_DrawRect(hLocation, vLocation, tw, th + 3)
	surface_SetTextColor(htr,htg,htb)
	surface_SetTextPos(hLocation + 1, vLocation + 1.5)
	surface_DrawText(pcpropText)
	surface_SetDrawColor(bgr, bgg, bgb, bga )
	surface_DrawRect(hLocation + tw, vLocation, ptw + 3, pth + 3)
	surface_SetTextColor(bgtr, bgtg, bgtb)
	surface_SetTextPos(hLocation + tw + 2, vLocation + 2)
	surface_DrawText(count)
end

-- Calls local HUD function and runs it.
hook_Add("HUDPaint", "PropCounterHUDHook2023", function()	pcHUD()	end)

-- Gets new resolution, changes font size, removes and recreates HUD with new Font and HUD dimensions.
hook_Add("OnScreenSizeChanged", "PropCounterAdjustSize",function()
	_ScrW, _ScrH = ScrW(),ScrH()
	generateFonts()
	hook.Remove( "HUDPaint", "PropCounterHUDHook2023" )
	hook_Add("HUDPaint", "PropCounterHUDHook2023", function() pcHUD() end)
end)

-- Creates Larry's Prop Counter Category
hook_Add( "AddToolMenuCategories", "PropCounterCategory", function()
	spawnmenu.AddToolCategory( "Utilities", "#Larry's Prop Counter", "#Larry's Prop Counter" )
end )

-- Creates Larry's Prop Counter Sub-Category
hook_Add( "PopulateToolMenu", "PropCounterSettings", function()
	-- Adds prop counter color q-menu.
	spawnmenu.AddToolMenuOption( "Utilities", "#Larry's Prop Counter", "PCCM", "#Prop Counter Color", "", "", function(ClrWheelPanel)
		local Header = vgui.Create("DColorMixer")
		Header:Dock(FILL)
		Header:SetLabel("The header(s) background color. EX: 'Props:'")
		Header:SetColor(Color(hr,hg,hb,ha))
		Header:SetPalette(false)
		Header:SetAlphaBar(true)
		Header:SetWangs(true)
		Header.ValueChanged = function()
			timer.Simple(0.1, function()
				local color = Header:GetColor()
				hr,hg,hb,ha = color['r'],color['g'],color['b'],color['a']
				-- Updates convar so value can be saved.
				Get_ConVar("LPC_headercolor_r"):SetInt(hr)
				Get_ConVar("LPC_headercolor_g"):SetInt(hg)
				Get_ConVar("LPC_headercolor_b"):SetInt(hb)
				Get_ConVar("LPC_headercolor_a"):SetInt(ha)
			end)
		end
		ClrWheelPanel:AddItem(Header)
		local Background = vgui.Create("DColorMixer")
		Background:Dock(FILL)
		Background:SetLabel("The prop count background color. EX: '0'")
		Background:SetPalette(false)
		Background:SetAlphaBar(true)
		Background:SetWangs(true)
		Background:SetColor(Color(bgr,bgg,bgb,bga))
		Background.ValueChanged = function(value)
			timer.Simple(0.1, function()
				local color = Background:GetColor()
				-- Change HUD color values.
				bgr,bgg,bgb,bga = color['r'],color['g'],color['b'],color['a']
				-- Updates convar so value can be saved.
				Get_ConVar("LPC_backgroundcolor_r"):SetInt(bgr)
				Get_ConVar("LPC_backgroundcolor_g"):SetInt(bgg)
				Get_ConVar("LPC_backgroundcolor_b"):SetInt(bgb)
				Get_ConVar("LPC_backgroundcolor_a"):SetInt(bga)
			end)
		end
		ClrWheelPanel:AddItem(Background)
		local HeaderText = vgui.Create("DColorMixer")
		HeaderText:Dock(FILL)
		HeaderText:SetLabel("The 'Props:' text color. EX: 'Props:'")
		HeaderText:SetPalette(false)
		HeaderText:SetAlphaBar(false)
		HeaderText:SetWangs(true)
		HeaderText:SetColor(Color(htr,htg,htb))
		HeaderText.ValueChanged = function(value)
			timer.Simple(0.1, function()
				local color = HeaderText:GetColor()
				htr,htg,htb = color['r'],color['g'],color['b']
				-- Updates convar so value can be saved.
				Get_ConVar("LPC_headertextcolor_r"):SetInt(htr)
				Get_ConVar("LPC_headertextcolor_g"):SetInt(htg)
				Get_ConVar("LPC_headertextcolor_b"):SetInt(htb)
			end)
		end
		ClrWheelPanel:AddItem(HeaderText)
		local BackgroundText = vgui.Create("DColorMixer")
		BackgroundText:Dock(FILL)
		BackgroundText:SetLabel("The '0' text color. EX: '0'")
		BackgroundText:SetPalette(false)
		BackgroundText:SetAlphaBar(false)
		BackgroundText:SetWangs(true)
		BackgroundText:SetColor(Color(bgtr,bgtg,bgtb))
		BackgroundText.ValueChanged = function(value)
			timer.Simple(0.1, function()
				local color = BackgroundText:GetColor()
				-- Change HUD color values.
				bgtr,bgtg,bgtb = color['r'],color['g'],color['b']
				-- Updates convar so value can be saved.
				Get_ConVar("LPC_backgroundtextcolor_r"):SetInt(bgtr)
				Get_ConVar("LPC_backgroundtextcolor_g"):SetInt(bgtg)
				Get_ConVar("LPC_backgroundtextcolor_b"):SetInt(bgtb)
			end)
		end
		ClrWheelPanel:AddItem(BackgroundText)
		-- Creates a button that resets clients HUD color settings to config defaults.
		local ResetHUDClr = vgui.Create("DButton")
		ResetHUDClr:SetText("Reset HUD Color to default.")
		ResetHUDClr.DoClick = function()
			-- Resets HUD Header Header color.
			hr,hg,hb,ha = LPC.HeadClr['r'],LPC.HeadClr['g'],LPC.HeadClr['b'],LPC.HeadClr['a']
			-- Resets HUD Header Text color.
			htr,htg,htb = LPC.HeadTextClr['r'],LPC.HeadTextClr['g'],LPC.HeadTextClr['b']
			-- Resets HUD Background color.
			bgr,bgg,bgb,bga = LPC.BgClr['r'],LPC.BgClr['g'],LPC.BgClr['b'],LPC.BgClr['a']
			-- Resets HUD Background Text color.
			bgtr,bgtg,bgtb = LPC.BgTextClr['r'],LPC.BgTextClr['g'],LPC.BgTextClr['b']
			-- Sets the color panel(s) back to default.
			Header:SetColor(Color(hr,hg,hb,ha))
			Background:SetColor(Color(bgr,bgg,bgb,bga))
			HeaderText:SetColor(Color(htr,htg,htb))
			BackgroundText:SetColor(Color(bgtr,bgtg,bgtb))
		end
		ClrWheelPanel:AddItem(ResetHUDClr)
	end )

	-- Adds prop counter settings q-menu.
	spawnmenu.AddToolMenuOption( "Utilities", "#Larry's Prop Counter", "Prop_Counter_Settings", "#Prop Counter Settings", "", "", function(LPCSettings)
		-- Creates a slider that allows you to select the vertical location releative to your screen height.
		local VSlider = vgui.Create("DNumSlider")
			VSlider:SetText("Vertical Location Slider")
			VSlider.Label:SetDark(true)
			VSlider:SetMin( 1 )
			VSlider:SetMax( _ScrH- 1 )
			VSlider:SetDecimals( 0 )
			VSlider:SetValue(vLocation)
			VSlider.OnValueChanged = function(self, value)
				vLocation = value
				GetConVar("LPC_verticallocation"):SetInt(value)
			end
		LPCSettings:AddItem(VSlider)
		-- Creates a slider that allows you to select the horizontal location releative to your screen width.
		local HSlider = vgui.Create("DNumSlider")
			HSlider:SetText("Horizontal Location Slider")
			HSlider.Label:SetDark(true)
			HSlider:SetMin( 1 )
			HSlider:SetMax( _ScrW- 1 )
			HSlider:SetDecimals( 0 )
			HSlider:SetValue(hLocation)
			HSlider.OnValueChanged = function(self, value)
				hLocation = value
				GetConVar("LPC_horizontallocation"):SetInt(value)
			end
		LPCSettings:AddItem(HSlider)
		-- Creates a slider that allows you to change the size of the HUD.
		local SSlider = vgui.Create("DNumSlider")
			SSlider:SetText("Horizontal Location Slider")
			SSlider.Label:SetDark(true)
			SSlider:SetMin( 0.00 )
			SSlider:SetMax( 10 )
			SSlider:SetDecimals( 2 )
			SSlider:SetValue(LPC_Scale)
			SSlider.OnValueChanged = function(self, value)
				LPC_Scale = value
				GetConVar("LPC_scale"):SetFloat(value)
				generateFonts()
				hook.Remove( "HUDPaint", "PropCounterHUDHook2023" )
				hook_Add("HUDPaint", "PropCounterHUDHook2023", function() pcHUD() end)
			end
		LPCSettings:AddItem(SSlider)
		-- Creates a Checkbox that allows you to enable or disable the HUD.
		local EnableCounter = vgui.Create("DCheckBoxLabel")
			EnableCounter:SetText("Enable/Disable Prop Counter")
			EnableCounter.Label:SetDark(true)
			EnableCounter:SetValue(enabled)
			EnableCounter.OnChange = function(self, value)
				enabled = value
				GetConVar("LPC_enabled"):SetBool(value)
			end
		LPCSettings:AddItem(EnableCounter)
		-- Creates a Checkbox that allows you to enable or disable the Rainbow effect.
		local EnableRainbow = vgui.Create("DCheckBoxLabel")
			EnableRainbow:SetText("Enable/Disable Rainbow Barf")
			EnableRainbow.Label:SetDark(true)
			EnableRainbow:SetValue(tobool(rainbow))
			EnableRainbow.OnChange = function(self, value)
				rainbow = tobool(value)
				GetConVar("LPC_rainbow"):SetBool(value)
			end
		LPCSettings:AddItem(EnableRainbow)
		-- Creates a button that resets clients settings to config defaults.
		local ResetSettings = vgui.Create("DButton")
			ResetSettings:SetText("Reset Settings to default.")
			ResetSettings.DoClick = function(self, value)
				enabled, rainbow, LPC_Scale = tobool(LPC["enable"]),tobool(LPC["rainbow"]),LPC["scale"]
				Get_ConVar("LPC_enabled"):SetBool(tobool(LPC["enable"]))
				Get_ConVar("LPC_rainbow"):SetBool(tobool(LPC["rainbow"]))
				Get_ConVar("LPC_scale"):SetFloat(LPC["scale"])
				vLocation, hLocation = LPC["VerticalLocation"],LPC["HorizontalLocation"]
				Get_ConVar("LPC_verticallocation"):SetInt(LPC["VerticalLocation"])
				Get_ConVar("LPC_horizontallocation"):SetInt(LPC["HorizontalLocation"])
				generateFonts()
				hook.Remove( "HUDPaint", "PropCounterHUDHook2023" )
				hook_Add("HUDPaint", "PropCounterHUDHook2023", function() pcHUD() end)
				VSlider:SetValue(vLocation)
				HSlider:SetValue(hLocation)
				SSlider:SetValue(LPC_Scale)
				EnableCounter:SetValue(enabled)
				EnableRainbow:SetValue(tobool(rainbow))
			end
		LPCSettings:AddItem(ResetSettings)
	end )
end )