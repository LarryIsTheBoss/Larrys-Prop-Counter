-- Prop Counter
-- Made by: LionDaDev
-- Maintained by QuirkyLarry
-- Discord: QuirkyLarry
-- Steam: https://steamcommunity.com/id/QuirkyLarry/

-- Tried to make the code simple to understand, not even including server files
-- This litteraly prevents this from being a backdoor
local LionSettings = {
	-- Sets the HUD as enabled or disable by default. 1 = enabled, 0 = disabled.
	["HUDEnable"] = 1,
	-- Sets the default size the HUD should be. 0-10 is allowed, 1 is default.
	["Scale"] = 1,
	-- Default Header color. The background behind 'Props:'. - Default: 0,191,255,255
	HeaderColor = {
		['r'] = 25,
		['g'] = 25,
		['b'] = 25,
		['a'] = 255,
	},
	-- Default Header text color. The text 'Props:' color. - Default: 0,191,255
	HeaderTextColor = {
		['r'] = 255,
		['g'] = 255,
		['b'] = 255,
	},
	-- Default location the hud starts at on the y/vertical-axis. UP/DOWN - Default: 10
	["VerticalLocation"] = 10,
	-- Default location the hud starts at on the x/horizontal-axis. Left/Right - Default: 10
	["HorizontalLocation"] = 10,
}

local _ScrW, _ScrH = ScrW(),ScrH()
local p = 0
CreateClientConVar("lion_hudenabled", LionSettings["HUDEnable"], true, false, "", 0, 1)
CreateClientConVar("lion_scale", LionSettings["Scale"], true, false, "", 0, 10)
CreateClientConVar("lion_verticallocation", LionSettings["VerticalLocation"], true, false, "", 1, _ScrH)
CreateClientConVar("lion_horizontallocation", LionSettings["HorizontalLocation"], true, false, "", 1, _ScrW)
CreateClientConVar("lion_headercolor_r", LionSettings.HeaderColor['r'], true, false, "", 0, 255 )
CreateClientConVar("lion_headercolor_g", LionSettings.HeaderColor['g'], true, false, "", 0, 255 )
CreateClientConVar("lion_headercolor_b", LionSettings.HeaderColor['b'], true, false, "", 0, 255 )
CreateClientConVar("lion_headercolor_a", LionSettings.HeaderColor['a'], true, false, "", 0, 255 )
CreateClientConVar("lion_headertextcolor_r", LionSettings.HeaderTextColor['r'], true, false, "", 0, 255 )
CreateClientConVar("lion_headertextcolor_g", LionSettings.HeaderTextColor['g'], true, false, "", 0, 255 )
CreateClientConVar("lion_headertextcolor_b", LionSettings.HeaderTextColor['b'], true, false, "", 0, 255 )

local hudenabled, lionScale = GetConVar("lion_hudenabled"):GetBool(), GetConVar("lion_scale"):GetFloat()
local vLocation, hLocation = GetConVar("lion_verticallocation"):GetInt(), GetConVar("lion_horizontallocation"):GetInt()
local header_red,header_green,header_blue,header_alpha = GetConVar("lion_headercolor_r"):GetInt(), GetConVar("lion_headercolor_g"):GetInt(), GetConVar("lion_headercolor_b"):GetInt(), GetConVar("lion_headercolor_a"):GetInt()
local headertext_red,headertext_green,headertext_blue = GetConVar("lion_headertextcolor_r"):GetInt(), GetConVar("lion_headertextcolor_g"):GetInt(), GetConVar("lion_headertextcolor_b"):GetInt()

local fonts = {
	["propcount_font"] = {
		font = "Montserrat Medium",
		extended = false,
		sizeFunc = function()
			return (_ScrW * .015) * lionScale
		end,
		weight = 25,
	}
}

local function generateCounterFonts()
	for k, v in pairs( fonts ) do
		if isfunction(v.sizeFunc) then
			v.size = v.sizeFunc()
		end

		surface.CreateFont( k, v )
	end
end

generateCounterFonts()

local function PropCounter()
	if not hudenabled then return end
	p = "Prop Count: " .. LocalPlayer():GetCount("props")

	surface.SetFont("propcount_font")
	local ww, wh = surface.GetTextSize(tostring(p))
	draw.RoundedBox(6, vLocation, hLocation, ww * 1.1, wh * 1.05, Color(header_red, header_green, header_blue,header_alpha))
	draw.SimpleText(tostring(p), "propcount_font", vLocation, hLocation, Color(headertext_red, headertext_green, headertext_blue), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end

-- Hook function to create HUD.
hook.Add("HUDPaint", "lion_propcount_count", function() PropCounter() end)
-- Hook function to re-create HUD and font on screensize changed.
hook.Add("OnScreenSizeChanged", "LionCounterAdjustSize",function()
	_ScrW, _ScrH = ScrW(),ScrH()
	generateCounterFonts()
	hook.Remove( "HUDPaint", "lion_propcount_count" )
	hook.Add("HUDPaint", "lion_propcount_count", function() PropCounter() end)
end)

-- Creates Lion's Prop Counter Category
hook.Add( "AddToolMenuCategories", "PropCounterCategory", function() spawnmenu.AddToolCategory( "Utilities", "#Lion's Prop Counter", "#Lion's Prop Counter" ) end )

-- Creates Lion's Prop Counter Sub-Category
hook.Add( "PopulateToolMenu", "PropCounterSettings", function()
	-- Adds prop counter color q-menu.
	spawnmenu.AddToolMenuOption( "Utilities", "#Lion's Prop Counter", "LionColorMixer", "#Prop Counter Color", "", "", function(ColorWheelPanel)
		local HeaderColor = vgui.Create("DColorMixer")
			HeaderColor:Dock(FILL)
			HeaderColor:SetLabel("Changes the background behind the text color.")
			HeaderColor:SetPalette(false)
			HeaderColor:SetAlphaBar(true)
			HeaderColor:SetWangs(true)
			HeaderColor:SetColor(Color(header_red,header_green,header_blue,header_alpha))
			HeaderColor.ValueChanged = function(value)
			local color = HeaderColor:GetColor()
			-- Change HUD color values.
			header_red,header_green,header_blue,header_alpha = color['r'],color['g'],color['b'],color['a']
			-- Updates convar so value can be saved.
			GetConVar("lion_headercolor_r"):SetInt(header_red)
			GetConVar("lion_headercolor_g"):SetInt(header_green)
			GetConVar("lion_headercolor_b"):SetInt(header_blue)
			GetConVar("lion_headercolor_a"):SetInt(header_alpha)
		end
		ColorWheelPanel:AddItem(HeaderColor)

		local HeaderTextColor = vgui.Create("DColorMixer")
			HeaderTextColor:Dock(FILL)
			HeaderTextColor:SetLabel("Changes the text color.")
			HeaderTextColor:SetPalette(false)
			HeaderTextColor:SetAlphaBar(false)
			HeaderTextColor:SetWangs(true)
			HeaderTextColor:SetColor(Color(headertext_red,headertext_green,headertext_blue))
			HeaderTextColor.ValueChanged = function(value)
			local color = HeaderTextColor:GetColor()
			-- Change HUD color values.
			headertext_red,headertext_green,headertext_blue = color['r'],color['g'],color['b']
			-- Updates convar so value can be saved.
			GetConVar("lion_headertextcolor_r"):SetInt(headertext_red)
			GetConVar("lion_headertextcolor_g"):SetInt(headertext_green)
			GetConVar("lion_headertextcolor_b"):SetInt(headertext_blue)
		end
		ColorWheelPanel:AddItem(HeaderTextColor)
	end )
	-- Adds prop counter settings q-menu.
	spawnmenu.AddToolMenuOption( "Utilities", "#Lion's Prop Counter", "Prop_Counter_Settings", "#Prop Counter Settings", "", "", function(LionsPropCounter)
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
				GetConVar("lion_verticallocation"):SetInt(value)
			end
		LionsPropCounter:AddItem(VerticalSlider)
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
				GetConVar("lion_horizontallocation"):SetInt(value)
			end
		LionsPropCounter:AddItem(HorizontalSlider)
		-- Creates a slider that allows you to change the size of the HUD.
		local ScaleSlider = vgui.Create("DNumSlider")
			ScaleSlider:SetText("Scale Slider")
			ScaleSlider.Label:SetDark(true)
			ScaleSlider:SetMin( 0.00 )
			ScaleSlider:SetMax( 10 )
			ScaleSlider:SetDecimals( 2 )
			ScaleSlider:SetValue(lionScale)
			ScaleSlider.OnValueChanged = function(self, value)
				lionScale = value
				GetConVar("lion_scale"):SetFloat(value)
				generateCounterFonts()
				hook.Remove( "HUDPaint", "lion_propcount_count" )
				hook.Add("HUDPaint", "lion_propcount_count", function() PropCounter() end)
			end
		LionsPropCounter:AddItem(ScaleSlider)
		-- Creates a Checkbox that allows you to enable or disable the HUD.
		local EnablePropCounterButton = vgui.Create("DCheckBoxLabel")
			EnablePropCounterButton:SetText("Enable/Disable Prop Counter")
			EnablePropCounterButton.Label:SetDark(true)
			EnablePropCounterButton:SetValue(hudenabled)
			EnablePropCounterButton.OnChange = function(self, value)
				hudenabled = value
				GetConVar("lion_hudenabled"):SetBool(value)
			end
		LionsPropCounter:AddItem(EnablePropCounterButton)
		-- Creates a button that resets clients settings to config defaults.
		local ResetLionSettings = vgui.Create("DButton")
			ResetLionSettings:SetText("Reset Settings to default.")
			ResetLionSettings.DoClick = function(self, value)
				hudenabled, lionScale = tobool(LionSettings["HUDEnable"]),LionSettings["Scale"]
				GetConVar("lion_hudenabled"):SetBool(tobool(LionSettings["HUDEnable"]))
				GetConVar("lion_scale"):SetFloat(LionSettings["Scale"])
				vLocation, hLocation = LionSettings["VerticalLocation"],LionSettings["HorizontalLocation"]
				GetConVar("lion_verticallocation"):SetInt(LionSettings["VerticalLocation"]); GetConVar("lion_horizontallocation"):SetInt(LionSettings["HorizontalLocation"])
				generateCounterFonts()
				hook.Remove( "HUDPaint", "lion_propcount_count" )
				hook.Add("HUDPaint", "lion_propcount_count", function() PropCounter() end)
			end
		LionsPropCounter:AddItem(ResetLionSettings)
		-- Creates a button that resets clients HUD color settings to config defaults.
		local ResetHUDColorSettings = vgui.Create("DButton")
			ResetHUDColorSettings:SetText("Reset HUD Color Settings to default.")
			ResetHUDColorSettings.DoClick = function(self, value)
				-- Resets HUD Header Header color.
				header_red,header_green,header_blue,header_alpha = LionSettings.HeaderColor['r'],LionSettings.HeaderColor['g'],LionSettings.HeaderColor['b'],LionSettings.HeaderColor['a']
				GetConVar("lion_headercolor_r"):SetInt(LionSettings.HeaderColor['r'])
				GetConVar("lion_headercolor_g"):SetInt(LionSettings.HeaderColor['g'])
				GetConVar("lion_headercolor_b"):SetInt(LionSettings.HeaderColor['b'])
				GetConVar("lion_headercolor_a"):SetInt(LionSettings.HeaderColor['a'])
				-- Resets HUD Header Text color.
				headertext_red,headertext_green,headertext_blue = LionSettings.HeaderTextColor['r'],LionSettings.HeaderTextColor['g'],LionSettings.HeaderTextColor['b']
				GetConVar("lion_headertextcolor_r"):SetInt(LionSettings.HeaderTextColor['r'])
				GetConVar("lion_headertextcolor_g"):SetInt(LionSettings.HeaderTextColor['g'])
				GetConVar("lion_headertextcolor_b"):SetInt(LionSettings.HeaderTextColor['b'])
			end
		LionsPropCounter:AddItem(ResetHUDColorSettings)
	end )
end )