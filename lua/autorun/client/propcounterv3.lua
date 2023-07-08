CreateClientConVar("lpc_HClr_r", 0, true, false, "", 0, 255 )
CreateClientConVar("lpc_HClr_g", 191, true, false, "", 0, 255 )
CreateClientConVar("lpc_HClr_b", 255, true, false, "", 0, 255 )
CreateClientConVar("lpc_HClr_a", 255, true, false, "", 0, 255 )
CreateClientConVar("lpc_BGClr_r", 255, true, false, "", 0, 255 )
CreateClientConVar("lpc_BGClr_g", 255, true, false, "", 0, 255 )
CreateClientConVar("lpc_BGClr_b", 255, true, false, "", 0, 255 )
CreateClientConVar("lpc_BGClr_a", 255, true, false, "", 0, 255 )
CreateClientConVar("lpc_HTClr_r", 255, true, false, "", 0, 255 )
CreateClientConVar("lpc_HTClr_g", 255, true, false, "", 0, 255 )
CreateClientConVar("lpc_HTClr_b", 255, true, false, "", 0, 255 )
CreateClientConVar("lpc_HTClr_a", 255, true, false, "", 0, 255 )
CreateClientConVar("lpc_BGTClr_r", 0, true, false, "", 0, 255 )
CreateClientConVar("lpc_BGTClr_g", 191, true, false, "", 0, 255 )
CreateClientConVar("lpc_BGTClr_b", 255, true, false, "", 0, 255 )
CreateClientConVar("lpc_BGTClr_a", 255, true, false, "", 0, 255 )
CreateClientConVar("lpc_vertical", 10, true, false, "", 1, ScrH())
CreateClientConVar("lpc_horizontal", 10, true, false, "", 1, ScrW())
CreateClientConVar("lpc_scale", 1, true, false, "", 0, 10)
CreateClientConVar("lpc_enabled", 1, true, false, "", 0, 1)
local scale = GetConVar("lpc_scale"):GetInt()
local ScW, ScH = ScrW(),ScrH()
local vLocation, hLocation = GetConVar("lpc_vertical"):GetInt(),GetConVar("lpc_horizontal"):GetInt()
local hr,hg,hb,ha = GetConVar("lpc_HClr_r"):GetInt(),GetConVar("lpc_HClr_g"):GetInt(),GetConVar("lpc_HClr_b"):GetInt(),GetConVar("lpc_HClr_a"):GetInt()
local htr,htg,htb,hta = GetConVar("lpc_HTClr_r"):GetInt(),GetConVar("lpc_HTClr_g"):GetInt(),GetConVar("lpc_HTClr_b"):GetInt(),GetConVar("lpc_HTClr_a"):GetInt()
local bgr,bgg,bgb,bga = GetConVar("lpc_BGClr_r"):GetInt(),GetConVar("lpc_BGClr_g"):GetInt(),GetConVar("lpc_BGClr_b"):GetInt(),GetConVar("lpc_BGClr_a"):GetInt()
local bgtr,bgtg,bgtb,bgta = GetConVar("lpc_BGTClr_r"):GetInt(),GetConVar("lpc_BGTClr_g"):GetInt(),GetConVar("lpc_BGTClr_b"):GetInt(),GetConVar("lpc_BGTClr_a"):GetInt()
local FontSize = (((ScH *.03)+(ScW *.04))/4) * scale

surface.CreateFont( "PropCounterText", {
	font = "Arial",
	extended = false,
	size = (((ScH *.03)+(ScW *.04))/4) * scale,
	weight = 600,
	antialias = true,
})

-- Creates Larry's Prop Counter Category
hook.Add( "AddToolMenuCategories", "PropCounterCategory", function()
	spawnmenu.AddToolCategory( "Utilities", "#Larry's Prop Counter", "#Larry's Prop Counter" )
end )
-- Creates Larry's Prop Counter Sub-Category
hook.Add( "PopulateToolMenu", "PropCounterSettings", function()
	spawnmenu.AddToolMenuOption( "Utilities", "#Larry's Prop Counter", "PCCM", "#Prop Counter Color", "", "", function( ColorWheelPanel ) 
		ColorWheelPanel:ColorPicker("Prop Counter Header Color", "lpc_HClr_r", "lpc_HClr_g", "lpc_HClr_b", "lpc_HClr_a")
		ColorWheelPanel:ColorPicker("Prop Counter Background Color", "lpc_BGClr_r", "lpc_BGClr_g", "lpc_BGClr_b", "lpc_BGClr_a" )
		ColorWheelPanel:ColorPicker("'Prop Count' Text Color", "lpc_HTClr_r", "lpc_HTClr_g", "lpc_HTClr_b", "lpc_HTClr_a" )
		ColorWheelPanel:ColorPicker("Count Text Color", "lpc_BGTClr_r", "lpc_BGTClr_g", "lpc_BGTClr_b", "lpc_BGTClr_a" )
	end )
	spawnmenu.AddToolMenuOption( "Utilities", "#Larry's Prop Counter", "PCLM", "#Prop Counter Settings", "", "", function(LPH)
		LPH:NumSlider( "Vertical Location Slider", "lpc_vertical", 1,ScH- 1, 0 )
		LPH:NumSlider( "Horizontal Location Slider", "lpc_horizontal", 1,ScW-1, 0 )
		LPH:NumSlider( "Hud Scale", "lpc_scale", 0,10, 2 )
		LPH:CheckBox( "Toggle Prop Counter", "lpc_enabled" )
	end )
end )

local pcHUDH = function()
	surface.SetDrawColor(hr,hg,hb,ha)
	surface.DrawRect(hLocation, vLocation, FontSize*3, FontSize)
	surface.SetTextColor(htr,htg,htb)
	surface.SetTextPos(hLocation+(ScH/ScW), vLocation)
	surface.SetFont( "PropCounterText" )
	surface.DrawText( "Props:" )
end

local pcHUDBG = function()
	surface.SetDrawColor(bgr, bgg, bgb, bga )
	surface.DrawRect(hLocation+(FontSize*3), vLocation, FontSize*1.75, FontSize)
	surface.SetTextColor(bgtr, bgtg, bgtb)
	surface.SetTextPos((hLocation+(FontSize*3)), vLocation)
	surface.SetFont( "PropCounterText" )
	surface.DrawText( LocalPlayer():GetCount( "props" ) or 0 )
end

hook.Add("HUDPaint", "ClientPropCounterHUDHook", function(ScW,ScH) pcHUDH() pcHUDBG() end)

hook.Add("OnScreenSizeChanged", "PropCounterAdjustSize",function() 
	local oldScW = ScW
	local oldScH = ScH
	ScW = ScrW() 
	ScH = ScrH()
	print("Larry's Prop Counter: Screen size has changed from " .. oldScW .. 'x' .. oldScH .. ' to ' .. ScW .. 'x' .. ScH)
	FontSize = (((ScH *.03)+(ScW *.04))/4) * scale
	surface.CreateFont( "PropCounterText", {
		font = "Arial",
		extended = false,
		size = (((ScH *.03)+(ScW *.04))/4) * scale,
		weight = 600,
		antialias = true,
	})
	hook.Remove( "HUDPaint", "ClientPropCounterHUDHook" )
	timer.Simple( 1, function(ScW,ScH) 
		hook.Add("HUDPaint", "ClientPropCounterHUDHook", function(ScW,ScH) pcHUDH() pcHUDBG() end)
	end)
end)



local cvars_AddChangeCallback = (CLIENT and cvars.AddChangeCallback or NULL)
-- Prop Counter Header Color R/G/B/A
cvars_AddChangeCallback("lpc_HClr_r", function(convar_name,value_old,value_new) if value_new == value_old then return end hr = value_new end)
cvars_AddChangeCallback("lpc_HClr_g", function(convar_name,value_old,value_new) if value_new == value_old then return end hg = value_new end)
cvars_AddChangeCallback("lpc_HClr_b", function(convar_name,value_old,value_new) if value_new == value_old then return end hb = value_new end)
cvars_AddChangeCallback("lpc_HClr_a", function(convar_name,value_old,value_new) if value_new == value_old then return end ha = value_new end)
-- Prop Counter Background Color R/G/B/A
cvars_AddChangeCallback("lpc_BGClr_r", function(convar_name,value_old,value_new) if value_new == value_old then return end bgr = value_new end)
cvars_AddChangeCallback("lpc_BGClr_g", function(convar_name,value_old,value_new) if value_new == value_old then return end bgg = value_new end)
cvars_AddChangeCallback("lpc_BGClr_b", function(convar_name,value_old,value_new) if value_new == value_old then return end bgb = value_new end)
cvars_AddChangeCallback("lpc_BGClr_a", function(convar_name,value_old,value_new) if value_new == value_old then return end bga = value_new end)
-- Prop Counter 'Prop Count' Text Color R/G/B/A
cvars_AddChangeCallback("lpc_HTClr_r", function(convar_name,value_old,value_new) if value_new == value_old then return end htr = value_new end)
cvars_AddChangeCallback("lpc_HTClr_g", function(convar_name,value_old,value_new) if value_new == value_old then return end htg = value_new end)
cvars_AddChangeCallback("lpc_HTClr_b", function(convar_name,value_old,value_new) if value_new == value_old then return end htb = value_new end)
cvars_AddChangeCallback("lpc_HTClr_a", function(convar_name,value_old,value_new) if value_new == value_old then return end hta = value_new end)
-- Prop Counter Count Text Color R/G/B/A
cvars_AddChangeCallback("lpc_BGTClr_r", function(convar_name,value_old,value_new) if value_new == value_old then return end bgtr = value_new end)
cvars_AddChangeCallback("lpc_BGTClr_g", function(convar_name,value_old,value_new) if value_new == value_old then return end bgtg = value_new end)
cvars_AddChangeCallback("lpc_BGTClr_b", function(convar_name,value_old,value_new) if value_new == value_old then return end bgtb = value_new end)
cvars_AddChangeCallback("lpc_BGTClr_a", function(convar_name,value_old,value_new) if value_new == value_old then return end bgta = value_new end)
-- Prop Counter Count Text Color R/G/B/A
cvars_AddChangeCallback("lpc_vertical", function(convar_name,value_old,value_new) if value_new == value_old then return end vLocation = value_new end)
cvars_AddChangeCallback("lpc_horizontal", function(convar_name,value_old,value_new) if value_new == value_old then return end hLocation = value_new end)
cvars_AddChangeCallback("lpc_scale", function(convar_name,value_old,value_new) if value_new == value_old then return end scale = value_new 
	FontSize = (((ScH *.03)+(ScW *.04))/4) * scale
	surface.CreateFont( "PropCounterText", {font = "Arial",extended = false,size = (((ScH *.03)+(ScW *.04))/4) * scale,weight = 600,antialias = true,})
	hook.Remove( "HUDPaint", "ClientPropCounterHUDHook" )
	timer.Simple( 1, function(ScW,ScH) hook.Add("HUDPaint", "ClientPropCounterHUDHook", function(ScW,ScH)pcHUDH()pcHUDBG()end)end)
end)
cvars_AddChangeCallback("lpc_enabled", function(convar_name,value_old,value_new)  
	if value_new == value_old then return end
	if value_new == '1' then timer.Simple( 1, function(ScW,ScH) hook.Add("HUDPaint", "ClientPropCounterHUDHook", function(ScW,ScH)pcHUDH()pcHUDBG()end)end)
	elseif value_new == '0' then hook.Remove( "HUDPaint", "ClientPropCounterHUDHook" )
	end
end)