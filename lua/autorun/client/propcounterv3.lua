local Create_CCV = (CLIENT and CreateClientConVar or NILL)
local Get_CV = (CLIENT and GetConVar or NILL)
local hook_A = (CLIENT and hook.Add or NILL)
local cvars_ACC = (CLIENT and cvars.AddChangeCallback or NILL)
local surface_SDC = (CLIENT and surface.SetDrawColor or NILL)
local surface_DR = (CLIENT and surface.DrawRect or NILL)
local surface_STC = (CLIENT and surface.SetTextColor or NILL)
local surface_STP = (CLIENT and surface.SetTextPos or NILL)
local surface_SF = (CLIENT and surface.SetFont or NILL)
local surface_DT = (CLIENT and surface.DrawText or NILL)
Create_CCV("lpc_HClr_r", 0, true, false, "", 0, 255 )
Create_CCV("lpc_HClr_g", 191, true, false, "", 0, 255 )
Create_CCV("lpc_HClr_b", 255, true, false, "", 0, 255 )
Create_CCV("lpc_HClr_a", 255, true, false, "", 0, 255 )
Create_CCV("lpc_BGClr_r", 255, true, false, "", 0, 255 )
Create_CCV("lpc_BGClr_g", 255, true, false, "", 0, 255 )
Create_CCV("lpc_BGClr_b", 255, true, false, "", 0, 255 )
Create_CCV("lpc_BGClr_a", 255, true, false, "", 0, 255 )
Create_CCV("lpc_HTClr_r", 255, true, false, "", 0, 255 )
Create_CCV("lpc_HTClr_g", 255, true, false, "", 0, 255 )
Create_CCV("lpc_HTClr_b", 255, true, false, "", 0, 255 )
Create_CCV("lpc_BGTClr_r", 0, true, false, "", 0, 255 )
Create_CCV("lpc_BGTClr_g", 191, true, false, "", 0, 255 )
Create_CCV("lpc_BGTClr_b", 255, true, false, "", 0, 255 )
Create_CCV("lpc_vertical", 10, true, false, "", 1, ScrH())
Create_CCV("lpc_horizontal", 10, true, false, "", 1, ScrW())
Create_CCV("lpc_scale", 1, true, false, "", 0, 10)
Create_CCV("lpc_enabled", 1, true, false, "", 0, 1)
Create_CCV("lpc_barf", 1, true, false, "", 0, 1)

local rainbowBarf = Get_CV("lpc_barf"):GetBool()
local propScale = Get_CV("lpc_scale"):GetInt()
local ScW, ScH = ScrW(),ScrH()
local vLocation, hLocation = Get_CV("lpc_vertical"):GetInt(),Get_CV("lpc_horizontal"):GetInt()
local hr,hg,hb,ha = Get_CV("lpc_HClr_r"):GetInt(),Get_CV("lpc_HClr_g"):GetInt(),Get_CV("lpc_HClr_b"):GetInt(),Get_CV("lpc_HClr_a"):GetInt()
local htr,htg,htb = Get_CV("lpc_HTClr_r"):GetInt(),Get_CV("lpc_HTClr_g"):GetInt(),Get_CV("lpc_HTClr_b"):GetInt()
local bgr,bgg,bgb,bga = Get_CV("lpc_BGClr_r"):GetInt(),Get_CV("lpc_BGClr_g"):GetInt(),Get_CV("lpc_BGClr_b"):GetInt(),Get_CV("lpc_BGClr_a"):GetInt()
local bgtr,bgtg,bgtb = Get_CV("lpc_BGTClr_r"):GetInt(),Get_CV("lpc_BGTClr_g"):GetInt(),Get_CV("lpc_BGTClr_b"):GetInt()

surface.CreateFont( "LarrysPropCounterText", {
	font = "Arial",
	extended = false,
	size = (ScW *.015) * propScale,
	weight = 600,
	antialias = true,
})

-- Creates Larry's Prop Counter Category
hook_A( "AddToolMenuCategories", "PropCounterCategory", function()
	spawnmenu.AddToolCategory( "Utilities", "#Larry's Prop Counter", "#Larry's Prop Counter" )
end )

-- Creates Larry's Prop Counter Sub-Category
hook_A( "PopulateToolMenu", "PropCounterSettings", function()
	spawnmenu.AddToolMenuOption( "Utilities", "#Larry's Prop Counter", "PCCM", "#Prop Counter Color", "", "", function( ColorWheelPanel ) 
		ColorWheelPanel:ColorPicker("Prop Counter Header Color", "lpc_HClr_r", "lpc_HClr_g", "lpc_HClr_b", "lpc_HClr_a")
		ColorWheelPanel:ColorPicker("Prop Counter Background Color", "lpc_BGClr_r", "lpc_BGClr_g", "lpc_BGClr_b", "lpc_BGClr_a" )
		ColorWheelPanel:ColorPicker("'Prop Count' Text Color", "lpc_HTClr_r", "lpc_HTClr_g", "lpc_HTClr_b", NILL)
		ColorWheelPanel:ColorPicker("Count Text Color", "lpc_BGTClr_r", "lpc_BGTClr_g", "lpc_BGTClr_b", NILL)
	end )
	spawnmenu.AddToolMenuOption( "Utilities", "#Larry's Prop Counter", "PCLM", "#Prop Counter Settings", "", "", function(LPH)
		LPH:NumSlider( "Vertical Location Slider", "lpc_vertical", 1,ScH- 1, 0 )
		LPH:NumSlider( "Horizontal Location Slider", "lpc_horizontal", 1,ScW-1, 0 )
		LPH:NumSlider( "Hud Scale", "lpc_scale", 0,10, 2 )
		LPH:CheckBox( "Toggle Prop Counter", "lpc_enabled" )
		LPH:CheckBox( "Toggle Rainbow Barf", "lpc_barf" )
	end )
end )
local pcHUD = function()
	surface_SF( "LarrysPropCounterText" )
	local pcpropText,count  = "Props: ",LocalPlayer():GetCount("props") or 0
	local tw, th = surface.GetTextSize(pcpropText)
	local ptw, pth = surface.GetTextSize(tostring(count))
	if rainbowBarf then surface_SDC(hr,hg,hb,ha) else surface_SDC(HSVToColor(  ( CurTime() * 400 ) % 360, 1, 1 )) end
	surface_DR(hLocation, vLocation, tw+5, th+3)
	surface_STC(htr,htg,htb)
	surface_STP(hLocation+1, vLocation+1.5)
	surface_DT(pcpropText)
	surface_SDC(bgr, bgg, bgb, bga )
	surface_DR(hLocation+tw, vLocation, ptw+3, pth+3)
	surface_STC(bgtr, bgtg, bgtb)
	surface_STP(hLocation+tw+1, vLocation+2)
	surface_DT(count)
end
-- Calls local HUD function and runs it.
hook_A("HUDPaint", "PropCounterHUDHook2023", function(ScW,ScH) pcHUD() end)
-- Gets new resolution, changes font size, removes and recreates HUD with new Font and HUD dimensions.
hook_A("OnScreenSizeChanged", "PropCounterAdjustSize",function() 
	local oldScW = ScW
	local oldScH = ScH
	ScW = ScrW() 
	ScH = ScrH()
	print("Larry's Prop Counter: Screen size has changed from " .. oldScW .. 'x' .. oldScH .. ' to ' .. ScW .. 'x' .. ScH)
	surface.CreateFont( "LarrysPropCounterText", {
		font = "Arial",
		extended = false,
		size = (ScW *.015) * propScale,
		weight = 500,
		antialias = true,
	})
	hook.Remove( "HUDPaint", "PropCounterHUDHook2023" )
	timer.Simple( 1, function(ScW,ScH)  hook_A("HUDPaint", "PropCounterHUDHook2023", function(ScW,ScH) pcHUD() end) end)
end)

local cvars_ACC = (CLIENT and cvars.AddChangeCallback or NULL)
-- Prop Counter Header Color R/G/B/A
cvars_ACC("lpc_HClr_r", function(convar_name,value_old,value_new) if value_new == value_old then return end hr = value_new end)
cvars_ACC("lpc_HClr_g", function(convar_name,value_old,value_new) if value_new == value_old then return end hg = value_new end)
cvars_ACC("lpc_HClr_b", function(convar_name,value_old,value_new) if value_new == value_old then return end hb = value_new end)
cvars_ACC("lpc_HClr_a", function(convar_name,value_old,value_new) if value_new == value_old then return end ha = value_new end)
-- Prop Counter Background Color R/G/B/A
cvars_ACC("lpc_BGClr_r", function(convar_name,value_old,value_new) if value_new == value_old then return end bgr = value_new end)
cvars_ACC("lpc_BGClr_g", function(convar_name,value_old,value_new) if value_new == value_old then return end bgg = value_new end)
cvars_ACC("lpc_BGClr_b", function(convar_name,value_old,value_new) if value_new == value_old then return end bgb = value_new end)
cvars_ACC("lpc_BGClr_a", function(convar_name,value_old,value_new) if value_new == value_old then return end bga = value_new end)
-- Prop Counter 'Prop Count' Text Color R/G/B/A
cvars_ACC("lpc_HTClr_r", function(convar_name,value_old,value_new) if value_new == value_old then return end htr = value_new end)
cvars_ACC("lpc_HTClr_g", function(convar_name,value_old,value_new) if value_new == value_old then return end htg = value_new end)
cvars_ACC("lpc_HTClr_b", function(convar_name,value_old,value_new) if value_new == value_old then return end htb = value_new end)
-- Prop Counter Count Text Color R/G/B/A
cvars_ACC("lpc_BGTClr_r", function(convar_name,value_old,value_new) if value_new == value_old then return end bgtr = value_new end)
cvars_ACC("lpc_BGTClr_g", function(convar_name,value_old,value_new) if value_new == value_old then return end bgtg = value_new end)
cvars_ACC("lpc_BGTClr_b", function(convar_name,value_old,value_new) if value_new == value_old then return end bgtb = value_new end)
-- Prop Counter Count Text Color R/G/B/A
cvars_ACC("lpc_vertical", function(convar_name,value_old,value_new) if value_new == value_old then return end vLocation = value_new end)
cvars_ACC("lpc_horizontal", function(convar_name,value_old,value_new) if value_new == value_old then return end hLocation = value_new end)
cvars_ACC("lpc_scale", function(convar_name,value_old,value_new) if value_new == value_old then return end propScale = value_new 
	surface.CreateFont( "LarrysPropCounterText", {font = "Arial",extended = false,size = (ScW *.015) * propScale,weight = 600,antialias = true,})
	hook.Remove( "HUDPaint", "PropCounterHUDHook2023" )
	timer.Simple( 1, function(ScW,ScH) hook_A("HUDPaint", "PropCounterHUDHook2023", function(ScW,ScH)pcHUD()end)end)--]]
end)
cvars_ACC("lpc_enabled", function(convar_name,value_old,value_new)  
	if value_new == value_old then return end
	if value_new == '1' then timer.Simple( 1, function(ScW,ScH) hook_A("HUDPaint", "PropCounterHUDHook2023", function(ScW,ScH)pcHUD()end)end)
	elseif value_new == '0' then hook.Remove( "HUDPaint", "PropCounterHUDHook2023" )
	end
end)
cvars_ACC("lpc_barf", function(convar_name,value_old,value_new) if value_new == value_old then return end if value_new == '1' then rainbowBarf = true else rainbowBarf = false end end)