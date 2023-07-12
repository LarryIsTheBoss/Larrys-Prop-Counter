local Create_ClientConVar = CreateClientConVar
local Get_ConVar = GetConVar
local hook_Add = hook.Add
local cvars_AddChangeCallback = cvars.AddChangeCallback
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local surface_SetTextColor = surface.SetTextColor
local surface_SetTextPos = surface.SetTextPos
local surface_SetFont = surface.SetFont
local surface_DrawText = surface.DrawText
local _ScrW, _ScrH = ScrW(),ScrH()

Create_ClientConVar("lpc_headercolor_r", 0, true, false, "", 0, 255 )
Create_ClientConVar("lpc_headercolor_g", 191, true, false, "", 0, 255 )
Create_ClientConVar("lpc_headercolor_b", 255, true, false, "", 0, 255 )
Create_ClientConVar("lpc_headercolor_a", 255, true, false, "", 0, 255 )
Create_ClientConVar("lpc_backgroundcolor_r", 255, true, false, "", 0, 255 )
Create_ClientConVar("lpc_backgroundcolor_g", 255, true, false, "", 0, 255 )
Create_ClientConVar("lpc_backgroundcolor_b", 255, true, false, "", 0, 255 )
Create_ClientConVar("lpc_backgroundcolor_a", 255, true, false, "", 0, 255 )
Create_ClientConVar("lpc_headertextcolor_r", 255, true, false, "", 0, 255 )
Create_ClientConVar("lpc_headertextcolor_g", 255, true, false, "", 0, 255 )
Create_ClientConVar("lpc_headertextcolor_b", 255, true, false, "", 0, 255 )
Create_ClientConVar("lpc_backgroundtextcolor_r", 0, true, false, "", 0, 255 )
Create_ClientConVar("lpc_backgroundtextcolor_g", 191, true, false, "", 0, 255 )
Create_ClientConVar("lpc_backgroundtextcolor_b", 255, true, false, "", 0, 255 )
Create_ClientConVar("lpc_verticallocation", 10, true, false, "", 1, ScrH())
Create_ClientConVar("lpc_horizontallocation", 10, true, false, "", 1, ScrW())
Create_ClientConVar("lpc_scale", 1, true, false, "", 0, 10)
Create_ClientConVar("lpc_hudenabled", 1, true, false, "", 0, 1)
Create_ClientConVar("lpc_rainbowbarf", 0, true, false, "", 0, 1)

local rainbowBarf = Get_ConVar("lpc_rainbowbarf"):GetBool()
local propScale = Get_ConVar("lpc_scale"):GetInt()
local vLocation, hLocation = Get_ConVar("lpc_verticallocation"):GetInt(),Get_ConVar("lpc_horizontallocation"):GetInt()
local hr,hg,hb,ha = Get_ConVar("lpc_headercolor_r"):GetInt(),Get_ConVar("lpc_headercolor_g"):GetInt(),Get_ConVar("lpc_headercolor_b"):GetInt(),Get_ConVar("lpc_headercolor_a"):GetInt()
local htr,htg,htb = Get_ConVar("lpc_headertextcolor_r"):GetInt(),Get_ConVar("lpc_headertextcolor_g"):GetInt(),Get_ConVar("lpc_headertextcolor_b"):GetInt()
local bgr,bgg,bgb,bga = Get_ConVar("lpc_backgroundcolor_r"):GetInt(),Get_ConVar("lpc_backgroundcolor_g"):GetInt(),Get_ConVar("lpc_backgroundcolor_b"):GetInt(),Get_ConVar("lpc_backgroundcolor_a"):GetInt()
local bgtr,bgtg,bgtb = Get_ConVar("lpc_backgroundtextcolor_r"):GetInt(),Get_ConVar("lpc_backgroundtextcolor_g"):GetInt(),Get_ConVar("lpc_backgroundtextcolor_b"):GetInt()

local fonts = {
	["LarrysPropCounterText"] = {
		font = "Arial",
		extended = false,
		size = function()
			return (_ScrW * .015) * propScale
		end,
		weight = 600,
		antialias = true,
	}
}
local function generateFonts()
	for k, v in pairs( fonts ) do
		if isfunction(v.size) then
			v.size = v.size()
		end
		surface.CreateFont( k, v )
	end
end

generateFonts()

-- Creates Larry's Prop Counter Category
hook_Add( "AddToolMenuCategories", "PropCounterCategory", function()
	spawnmenu.AddToolCategory( "Utilities", "#Larry's Prop Counter", "#Larry's Prop Counter" )
end )

-- Creates Larry's Prop Counter Sub-Category
hook_Add( "PopulateToolMenu", "PropCounterSettings", function()
	spawnmenu.AddToolMenuOption( "Utilities", "#Larry's Prop Counter", "PCCM", "#Prop Counter Color", "", "", function(ColorWheelPanel)
		ColorWheelPanel:SizeToContents()
		ColorWheelPanel:ColorPicker("Prop Counter Header Color", "lpc_headercolor_r", "lpc_headercolor_g", "lpc_headercolor_b", "lpc_headercolor_a")
		ColorWheelPanel:ColorPicker("Prop Counter Background Color", "lpc_backgroundcolor_r", "lpc_backgroundcolor_g", "lpc_backgroundcolor_b", "lpc_backgroundcolor_a" )
		ColorWheelPanel:ColorPicker("'Prop Count' Text Color", "lpc_headertextcolor_r", "lpc_headertextcolor_g", "lpc_headertextcolor_b")
		ColorWheelPanel:ColorPicker("Count Text Color", "lpc_backgroundtextcolor_r", "lpc_backgroundtextcolor_g", "lpc_backgroundtextcolor_b")
	end )
	spawnmenu.AddToolMenuOption( "Utilities", "#Larry's Prop Counter", "Prop_Counter_Settings", "#Prop Counter Settings", "", "", function(LarrysPropCounterSettings)
		LarrysPropCounterSettings:NumSlider( "Vertical Location Slider", "lpc_verticallocation", 1,_ScrH- 1, 0 )
		LarrysPropCounterSettings:NumSlider( "Horizontal Location Slider", "lpc_horizontallocation", 1,_ScrW-1, 0 )
		LarrysPropCounterSettings:NumSlider( "Hud Scale", "lpc_scale", 0,10, 2 )
		LarrysPropCounterSettings:CheckBox( "Enable/Disable Prop Counter", "lpc_hudenabled" )
		LarrysPropCounterSettings:CheckBox( "Enable/Disable Rainbow Barf", "lpc_rainbowbarf" )
	end )
end )

local function pcHUD()
	surface_SetFont( "LarrysPropCounterText" )
	local pcpropText,count  = "Props: ",LocalPlayer():GetCount("props") or 0
	local tw, th = surface.GetTextSize(pcpropText)
	local ptw, pth = surface.GetTextSize(tostring(count))
	if not rainbowBarf then surface_SetDrawColor(hr,hg,hb,ha) else surface_SetDrawColor(HSVToColor(  ( CurTime() * 400 ) % 360, 1, 1 )) end
	surface_DrawRect(hLocation, vLocation, tw + 5, th + 3)
	surface_SetTextColor(htr,htg,htb)
	surface_SetTextPos(hLocation + 1, vLocation + 1.5)
	surface_DrawText(pcpropText)
	surface_SetDrawColor(bgr, bgg, bgb, bga )
	surface_DrawRect(hLocation + tw, vLocation, ptw + 3, pth + 3)
	surface_SetTextColor(bgtr, bgtg, bgtb)
	surface_SetTextPos(hLocation + tw + 1, vLocation + 2)
	surface_DrawText(count)
end

-- Calls local HUD function and runs it.
hook_Add("HUDPaint", "PropCounterHUDHook2023", function()
	pcHUD()
end)

-- Gets new resolution, changes font size, removes and recreates HUD with new Font and HUD dimensions.
hook_Add("OnScreenSizeChanged", "PropCounterAdjustSize",function()
	local old_ScrW = _ScrW
	local old_ScrH = _ScrH
	_ScrW, _fScrW = ScrW(),ScrW()
	_ScrH = ScrH()
	print("Larry's Prop Counter: Screen size has changed from " .. old_ScrW .. 'x' .. old_ScrH .. ' to ' .. _ScrW .. 'x' .. _ScrH)
	fonts["LarrysPropCounterText"].size = (_ScrW * .015) * propScale
	generateFonts()
	hook.Remove( "HUDPaint", "PropCounterHUDHook2023" )
	timer.Simple( 1, function()  hook_Add("HUDPaint", "PropCounterHUDHook2023", function() pcHUD() end) end)
end)

-- Prop Counter Header Color R/G/B/A
cvars_AddChangeCallback("lpc_headercolor_r", function(convar_name,value_old,value_new) if value_new == value_old then return end hr = value_new end)
cvars_AddChangeCallback("lpc_headercolor_g", function(convar_name,value_old,value_new) if value_new == value_old then return end hg = value_new end)
cvars_AddChangeCallback("lpc_headercolor_b", function(convar_name,value_old,value_new) if value_new == value_old then return end hb = value_new end)
cvars_AddChangeCallback("lpc_headercolor_a", function(convar_name,value_old,value_new) if value_new == value_old then return end ha = value_new end)
-- Prop Counter Background Color R/G/B/A
cvars_AddChangeCallback("lpc_backgroundcolor_r", function(convar_name,value_old,value_new) if value_new == value_old then return end bgr = value_new end)
cvars_AddChangeCallback("lpc_backgroundcolor_g", function(convar_name,value_old,value_new) if value_new == value_old then return end bgg = value_new end)
cvars_AddChangeCallback("lpc_backgroundcolor_b", function(convar_name,value_old,value_new) if value_new == value_old then return end bgb = value_new end)
cvars_AddChangeCallback("lpc_backgroundcolor_a", function(convar_name,value_old,value_new) if value_new == value_old then return end bga = value_new end)
-- Prop Counter 'Prop Count' Text Color R/G/B/A
cvars_AddChangeCallback("lpc_headertextcolor_r", function(convar_name,value_old,value_new) if value_new == value_old then return end htr = value_new end)
cvars_AddChangeCallback("lpc_headertextcolor_g", function(convar_name,value_old,value_new) if value_new == value_old then return end htg = value_new end)
cvars_AddChangeCallback("lpc_headertextcolor_b", function(convar_name,value_old,value_new) if value_new == value_old then return end htb = value_new end)
-- Prop Counter Count Text Color R/G/B/A
cvars_AddChangeCallback("lpc_backgroundtextcolor_r", function(convar_name,value_old,value_new) if value_new == value_old then return end bgtr = value_new end)
cvars_AddChangeCallback("lpc_backgroundtextcolor_g", function(convar_name,value_old,value_new) if value_new == value_old then return end bgtg = value_new end)
cvars_AddChangeCallback("lpc_backgroundtextcolor_b", function(convar_name,value_old,value_new) if value_new == value_old then return end bgtb = value_new end)
-- Prop Counter Count Text Color R/G/B/A
cvars_AddChangeCallback("lpc_verticallocation", function(convar_name,value_old,value_new) if value_new == value_old then return end vLocation = value_new end)
cvars_AddChangeCallback("lpc_horizontallocation", function(convar_name,value_old,value_new) if value_new == value_old then return end hLocation = value_new end)
cvars_AddChangeCallback("lpc_scale", function(convar_name,value_old,value_new) if value_new == value_old then return end propScale = value_new
	fonts["LarrysPropCounterText"].size = (_ScrW * .015) * propScale
	generateFonts()
	hook.Remove( "HUDPaint", "PropCounterHUDHook2023" )
	timer.Simple( 1, function() hook_Add("HUDPaint", "PropCounterHUDHook2023", function() pcHUD() end) end) --]]
end)
cvars_AddChangeCallback("lpc_hudenabled", function(convar_name,value_old,value_new)
	if value_new == value_old then return end
	if value_new == '1' then timer.Simple( 1, function() hook_Add("HUDPaint", "PropCounterHUDHook2023", function() pcHUD() end) end)
	elseif value_new == '0' then hook.Remove( "HUDPaint", "PropCounterHUDHook2023" )
	end
end)
cvars_AddChangeCallback("lpc_rainbowbarf", function(convar_name,value_old,value_new) if value_new == value_old then return end if value_new == '1' then rainbowBarf = true else rainbowBarf = false end end)