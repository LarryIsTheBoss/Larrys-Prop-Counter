--[[This addon is created and maintained by QuirkyLarry.
Discord: quirkylarry
Steam: https://steamcommunity.com/id/QuirkyLarry/
Please do not re-upload without permission.
You may contact me for questions, suggestions, or addon requests.]]--

local Settings = {
	-- Sets the HUD as enabled or disable by default. 1 = enabled, 0 = disabled.
	["HUDEnable"] = 1,
	-- Enables Rainbow barf by default. 1 = enabled, 0 = disabled.
	["RainbowEnable"] = 0,
	-- Sets the default size the HUD should be. 0-10 is allowed, 1 is default.
	["DefaultScale"] = 1,
	-- Default Header color. The background behind 'Props:'. - Default: 0,191,255,255
	HeaderColor = {
		['r'] = 0,
		['g'] = 191,
		['b'] = 255,
		['a'] = 255,
	},
	-- Default Background color. The background behind '0'. - Default: 255,255,255,255
	BackgroundColor = {
		['r'] = 255,
		['g'] = 255,
		['b'] = 255,
		['a'] = 255,
	},
	-- Default Header text color. The text 'Props:' color. - Default: 0,191,255
	HeaderTextColor = {
		['r'] = 255,
		['g'] = 255,
		['b'] = 255,
	},
	-- Default Count text color. The text '0' color. - Default: 0,191,255
	BackgroundTextColor = {
		['r'] = 0,
		['g'] = 191,
		['b'] = 255,
	},
	-- Default location the hud starts at on the y/vertical-axis. UP/DOWN - Default: 10
	["DefaultVerticalLocation"] = 10,
	-- Default location the hud starts at on the x/horizontal-axis. Left/Right - Default: 10
	["DefaultHorizontalLocation"] = 10,
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

Create_ClientConVar("propcounter_hudenabled", Settings["HUDEnable"], true, false, "", 0, 1)
Create_ClientConVar("propcounter_rainbowbarf", Settings["RainbowEnable"], true, false, "", 0, 1)
Create_ClientConVar("propcounter_scale", Settings["DefaultScale"], true, false, "", 0, 10)
Create_ClientConVar("propcounter_verticallocation", Settings["DefaultVerticalLocation"], true, false, "", 1, ScrH())
Create_ClientConVar("propcounter_horizontallocation", Settings["DefaultHorizontalLocation"], true, false, "", 1, ScrW())
Create_ClientConVar("propcounter_headercolor_r", Settings.HeaderColor['r'], true, false, "", 0, 255 )
Create_ClientConVar("propcounter_headercolor_g", Settings.HeaderColor['g'], true, false, "", 0, 255 )
Create_ClientConVar("propcounter_headercolor_b", Settings.HeaderColor['b'], true, false, "", 0, 255 )
Create_ClientConVar("propcounter_headercolor_a", Settings.HeaderColor['a'], true, false, "", 0, 255 )
Create_ClientConVar("propcounter_backgroundcolor_r", Settings.BackgroundColor['r'], true, false, "", 0, 255 )
Create_ClientConVar("propcounter_backgroundcolor_g", Settings.BackgroundColor['g'], true, false, "", 0, 255 )
Create_ClientConVar("propcounter_backgroundcolor_b", Settings.BackgroundColor['b'], true, false, "", 0, 255 )
Create_ClientConVar("propcounter_backgroundcolor_a", Settings.BackgroundColor['a'], true, false, "", 0, 255 )
Create_ClientConVar("propcounter_headertextcolor_r", Settings.HeaderTextColor['r'], true, false, "", 0, 255 )
Create_ClientConVar("propcounter_headertextcolor_g", Settings.HeaderTextColor['g'], true, false, "", 0, 255 )
Create_ClientConVar("propcounter_headertextcolor_b", Settings.HeaderTextColor['b'], true, false, "", 0, 255 )
Create_ClientConVar("propcounter_backgroundtextcolor_r", Settings.BackgroundTextColor['r'], true, false, "", 0, 255 )
Create_ClientConVar("propcounter_backgroundtextcolor_g", Settings.BackgroundTextColor['g'], true, false, "", 0, 255 )
Create_ClientConVar("propcounter_backgroundtextcolor_b", Settings.BackgroundTextColor['b'], true, false, "", 0, 255 )

local hudenabled, rainbowBarf, propScale = Get_ConVar("propcounter_hudenabled"):GetBool(), Get_ConVar("propcounter_rainbowbarf"):GetBool(), Get_ConVar("propcounter_scale"):GetFloat()
local vLocation, hLocation = Get_ConVar("propcounter_verticallocation"):GetInt(), Get_ConVar("propcounter_horizontallocation"):GetInt()
local hr,hg,hb,ha = Get_ConVar("propcounter_headercolor_r"):GetInt(), Get_ConVar("propcounter_headercolor_g"):GetInt(), Get_ConVar("propcounter_headercolor_b"):GetInt(), Get_ConVar("propcounter_headercolor_a"):GetInt()
local htr,htg,htb = Get_ConVar("propcounter_headertextcolor_r"):GetInt(), Get_ConVar("propcounter_headertextcolor_g"):GetInt(), Get_ConVar("propcounter_headertextcolor_b"):GetInt()
local bgr,bgg,bgb,bga = Get_ConVar("propcounter_backgroundcolor_r"):GetInt(), Get_ConVar("propcounter_backgroundcolor_g"):GetInt(), Get_ConVar("propcounter_backgroundcolor_b"):GetInt(), Get_ConVar("propcounter_backgroundcolor_a"):GetInt()
local bgtr,bgtg,bgtb = Get_ConVar("propcounter_backgroundtextcolor_r"):GetInt(), Get_ConVar("propcounter_backgroundtextcolor_g"):GetInt(), Get_ConVar("propcounter_backgroundtextcolor_b"):GetInt()

local fonts = {
	["LarrysPropCounterText"] = {
		font = "Arial",
		extended = false,
		sizeFunc = function()
			return (_ScrW * .015) * propScale
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
	if not hudenabled then return end
	surface_SetFont( "LarrysPropCounterText" )
	local pcpropText,count  = "Props: ",LocalPlayer():GetCount("props") or 0
	local tw, th = surface.GetTextSize(pcpropText)
	local ptw, pth = surface.GetTextSize(tostring(count))
	if not rainbowBarf then surface_SetDrawColor(hr,hg,hb,ha) elseif rainbowBarf then surface_SetDrawColor(HSVToColor(  ( CurTime() * 400 ) % 360, 1, 1 )) end
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
hook_Add("HUDPaint", "PropCounterHUDHook2023", function()
	pcHUD()
end)

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
	spawnmenu.AddToolMenuOption( "Utilities", "#Larry's Prop Counter", "PCCM", "#Prop Counter Color", "", "", function(ColorWheelPanel)

		local HeaderColor = vgui.Create("DColorMixer")
			HeaderColor:Dock(FILL)
			HeaderColor:SetLabel("The header(s) background color. EX: 'Props:'")
			HeaderColor:SetPalette(false)
			HeaderColor:SetAlphaBar(true)
			HeaderColor:SetWangs(true)
			HeaderColor:SetColor(Color(hr,hg,hb,ha))
			HeaderColor.ValueChanged = function(value)
			local color = HeaderColor:GetColor()
			-- Change HUD color values.
			hr,hg,hb,ha = color['r'],color['g'],color['b'],color['a']
			-- Updates convar so value can be saved.
			Get_ConVar("propcounter_headercolor_r"):SetInt(hr)
			Get_ConVar("propcounter_headercolor_g"):SetInt(hg)
			Get_ConVar("propcounter_headercolor_b"):SetInt(hb)
			Get_ConVar("propcounter_headercolor_a"):SetInt(ha)
		end
		ColorWheelPanel:AddItem(HeaderColor)

		local BackgroundColor = vgui.Create("DColorMixer")
			BackgroundColor:Dock(FILL)
			BackgroundColor:SetLabel("The prop count background color. EX: '0'")
			BackgroundColor:SetPalette(false)
			BackgroundColor:SetAlphaBar(true)
			BackgroundColor:SetWangs(true)
			BackgroundColor:SetColor(Color(bgr,bgg,bgb,bga))
			BackgroundColor.ValueChanged = function(value)
			local color = BackgroundColor:GetColor()
			-- Change HUD color values.
			bgr,bgg,bgb,bga = color['r'],color['g'],color['b'],color['a']
			-- Updates convar so value can be saved.
			Get_ConVar("propcounter_backgroundcolor_r"):SetInt(bgr)
			Get_ConVar("propcounter_backgroundcolor_g"):SetInt(bgg)
			Get_ConVar("propcounter_backgroundcolor_b"):SetInt(bgb)
			Get_ConVar("propcounter_backgroundcolor_a"):SetInt(bga)
		end
		ColorWheelPanel:AddItem(BackgroundColor)

		local HeaderTextColor = vgui.Create("DColorMixer")
			HeaderTextColor:Dock(FILL)
			HeaderTextColor:SetLabel("The 'Props:' text color. EX: 'Props:'")
			HeaderTextColor:SetPalette(false)
			HeaderTextColor:SetAlphaBar(false)
			HeaderTextColor:SetWangs(true)
			HeaderTextColor:SetColor(Color(htr,htg,htb))
			HeaderTextColor.ValueChanged = function(value)
			local color = HeaderTextColor:GetColor()
			-- Change HUD color values.
			htr,htg,htb = color['r'],color['g'],color['b']
			-- Updates convar so value can be saved.
			Get_ConVar("propcounter_headertextcolor_r"):SetInt(htr)
			Get_ConVar("propcounter_headertextcolor_g"):SetInt(htg)
			Get_ConVar("propcounter_headertextcolor_b"):SetInt(htb)
		end
		ColorWheelPanel:AddItem(HeaderTextColor)

		local BackgroundTextColor = vgui.Create("DColorMixer")
			BackgroundTextColor:Dock(FILL)
			BackgroundTextColor:SetLabel("The '0' text color. EX: '0'")
			BackgroundTextColor:SetPalette(false)
			BackgroundTextColor:SetAlphaBar(false)
			BackgroundTextColor:SetWangs(true)
			BackgroundTextColor:SetColor(Color(bgtr,bgtg,bgtb))
			BackgroundTextColor.ValueChanged = function(value)
			local color = BackgroundTextColor:GetColor()
			-- Change HUD color values.
			bgtr,bgtg,bgtb = color['r'],color['g'],color['b']
			-- Updates convar so value can be saved.
			Get_ConVar("propcounter_backgroundtextcolor_r"):SetInt(htr)
			Get_ConVar("propcounter_backgroundtextcolor_g"):SetInt(htg)
			Get_ConVar("propcounter_backgroundtextcolor_b"):SetInt(htb)
		end
		ColorWheelPanel:AddItem(BackgroundTextColor)
	end )
	-- Adds prop counter settings q-menu.
	spawnmenu.AddToolMenuOption( "Utilities", "#Larry's Prop Counter", "Prop_Counter_Settings", "#Prop Counter Settings", "", "", function(LarrysPropCounterSettings)
		-- Creates a slider that allows you to select the vertical location releative to your screen height.
		local VerticalSlider = vgui.Create("DNumSlider")
			VerticalSlider:SetText("Vertical Location Slider")
			VerticalSlider.Label:SetDark(true)
			VerticalSlider:SetMin( 1 )
			VerticalSlider:SetMax( _ScrH- 1 )
			VerticalSlider:SetDecimals( 0 )
			VerticalSlider:SetValue(vLocation)
			VerticalSlider.OnValueChanged = function(self, value)
				vLocation = value
				GetConVar("propcounter_verticallocation"):SetInt(value)
			end
		LarrysPropCounterSettings:AddItem(VerticalSlider)
		-- Creates a slider that allows you to select the horizontal location releative to your screen width.
		local HorizontalSlider = vgui.Create("DNumSlider")
			HorizontalSlider:SetText("Horizontal Location Slider")
			HorizontalSlider.Label:SetDark(true)
			HorizontalSlider:SetMin( 1 )
			HorizontalSlider:SetMax( _ScrW- 1 )
			HorizontalSlider:SetDecimals( 0 )
			HorizontalSlider:SetValue(hLocation)
			HorizontalSlider.OnValueChanged = function(self, value)
				hLocation = value
				GetConVar("propcounter_horizontallocation"):SetInt(value)
			end
		LarrysPropCounterSettings:AddItem(HorizontalSlider)
		-- Creates a slider that allows you to change the size of the HUD.
		local ScaleSlider = vgui.Create("DNumSlider")
			ScaleSlider:SetText("Horizontal Location Slider")
			ScaleSlider.Label:SetDark(true)
			ScaleSlider:SetMin( 0.00 )
			ScaleSlider:SetMax( 10 )
			ScaleSlider:SetDecimals( 2 )
			ScaleSlider:SetValue(propScale)
			ScaleSlider.OnValueChanged = function(self, value)
				propScale = value
				GetConVar("propcounter_scale"):SetFloat(value)
				generateFonts()
				hook.Remove( "HUDPaint", "PropCounterHUDHook2023" )
				hook_Add("HUDPaint", "PropCounterHUDHook2023", function() pcHUD() end)
			end
		LarrysPropCounterSettings:AddItem(ScaleSlider)
		-- Creates a Checkbox that allows you to enable or disable the HUD.
		local EnablePropCounterButton = vgui.Create("DCheckBoxLabel")
			EnablePropCounterButton:SetText("Enable/Disable Prop Counter")
			EnablePropCounterButton.Label:SetDark(true)
			EnablePropCounterButton:SetValue(hudenabled)
			EnablePropCounterButton.OnChange = function(self, value)
				hudenabled = value
				GetConVar("propcounter_hudenabled"):SetBool(value)
			end
		LarrysPropCounterSettings:AddItem(EnablePropCounterButton)
		-- Creates a Checkbox that allows you to enable or disable the Rainbow effect.
		local EnableRainbowBarfButton = vgui.Create("DCheckBoxLabel")
			EnableRainbowBarfButton:SetText("Enable/Disable Rainbow Barf")
			EnableRainbowBarfButton.Label:SetDark(true)
			EnableRainbowBarfButton:SetValue(tobool(rainbowBarf))
			EnableRainbowBarfButton.OnChange = function(self, value)
				rainbowBarf = tobool(value)
				GetConVar("propcounter_rainbowbarf"):SetBool(value)
			end
		LarrysPropCounterSettings:AddItem(EnableRainbowBarfButton)
		-- Creates a button that resets clients settings to config defaults.
		local ResetSettings = vgui.Create("DButton")
			ResetSettings:SetText("Reset Settings to default.")
			ResetSettings.DoClick = function(self, value)
				hudenabled, rainbowBarf, propScale = tobool(Settings["HUDEnable"]),tobool(Settings["RainbowEnable"]),Settings["DefaultScale"]
				Get_ConVar("propcounter_hudenabled"):SetBool(tobool(Settings["HUDEnable"]))
				Get_ConVar("propcounter_rainbowbarf"):SetBool(tobool(Settings["RainbowEnable"]))
				Get_ConVar("propcounter_scale"):SetFloat(Settings["DefaultScale"])
				vLocation, hLocation = Settings["DefaultVerticalLocation"],Settings["DefaultHorizontalLocation"]
				Get_ConVar("propcounter_verticallocation"):SetInt(Settings["DefaultVerticalLocation"])
				Get_ConVar("propcounter_horizontallocation"):SetInt(Settings["DefaultHorizontalLocation"])
				generateFonts()
				hook.Remove( "HUDPaint", "PropCounterHUDHook2023" )
				hook_Add("HUDPaint", "PropCounterHUDHook2023", function() pcHUD() end)
			end
		LarrysPropCounterSettings:AddItem(ResetSettings)
		-- Creates a button that resets clients HUD color settings to config defaults.
		local ResetHUDColorSettings = vgui.Create("DButton")
			ResetHUDColorSettings:SetText("Reset HUD Color Settings to default.")
			ResetHUDColorSettings.DoClick = function(self, value)
				-- Resets HUD Header Header color.
				hr,hg,hb,ha = Settings.HeaderColor['r'],Settings.HeaderColor['g'],Settings.HeaderColor['b'],Settings.HeaderColor['a']
				Get_ConVar("propcounter_headercolor_r"):SetInt(Settings.HeaderColor['r'])
				Get_ConVar("propcounter_headercolor_g"):SetInt(Settings.HeaderColor['g'])
				Get_ConVar("propcounter_headercolor_b"):SetInt(Settings.HeaderColor['b'])
				Get_ConVar("propcounter_headercolor_a"):SetInt(Settings.HeaderColor['a'])
				-- Resets HUD Header Text color.
				htr,htg,htb = Settings.HeaderTextColor['r'],Settings.HeaderTextColor['g'],Settings.HeaderTextColor['b']
				Get_ConVar("propcounter_headertextcolor_r"):SetInt(Settings.HeaderTextColor['r'])
				Get_ConVar("propcounter_headertextcolor_g"):SetInt(Settings.HeaderTextColor['g'])
				Get_ConVar("propcounter_headertextcolor_b"):SetInt(Settings.HeaderTextColor['b'])
				-- Resets HUD Background color.
				bgr,bgg,bgb,bga = Settings.BackgroundColor['r'],Settings.BackgroundColor['g'],Settings.BackgroundColor['b'],Settings.BackgroundColor['a']
				Get_ConVar("propcounter_backgroundcolor_r"):SetInt(Settings.BackgroundColor['r'])
				Get_ConVar("propcounter_backgroundcolor_g"):SetInt(Settings.BackgroundColor['g'])
				Get_ConVar("propcounter_backgroundcolor_b"):SetInt(Settings.BackgroundColor['b'])
				Get_ConVar("propcounter_backgroundcolor_a"):SetInt(Settings.BackgroundColor['a'])
				-- Resets HUD Background Text color.
				bgtr,bgtg,bgtb = Settings.BackgroundTextColor['r'],Settings.BackgroundTextColor['g'],Settings.BackgroundTextColor['b']
				Get_ConVar("propcounter_backgroundtextcolor_r"):SetInt(Settings.BackgroundTextColor['r'])
				Get_ConVar("propcounter_backgroundtextcolor_g"):SetInt(Settings.BackgroundTextColor['g'])
				Get_ConVar("propcounter_backgroundtextcolor_b"):SetInt(Settings.BackgroundTextColor['b'])
			end
		LarrysPropCounterSettings:AddItem(ResetHUDColorSettings)
	end )
end )