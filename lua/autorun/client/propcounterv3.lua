local l_cACCk = cvars.AddChangeCallback
local l_CCCVr = (CLIENT && CreateClientConVar or NULL)
local l_Cr = (CLIENT && Color or NULL)
local l_sCFt = (CLIENT && surface.CreateFont or NULL)
local l_hAd = (CLIENT && hook.Add or NULL)
local l_GCVr = (CLIENT && GetConVar or NULL)
local l_dRBEx = (CLIENT && draw.RoundedBoxEx or NULL)
local l_dSTt = (CLIENT && draw.SimpleText or NULL)
local l_LP = (CLIENT && LocalPlayer or NULL)
l_CCCVr("lpc_HClr_r", 0, true, false, "", 0, 255 )
l_CCCVr("lpc_HClr_g", 191, true, false, "", 0, 255 )
l_CCCVr("lpc_HClr_b", 255, true, false, "", 0, 255 )
l_CCCVr("lpc_HClr_a", 255, true, false, "", 0, 255 )
l_CCCVr("lpc_BGClr_r", 255, true, false, "", 0, 255 )
l_CCCVr("lpc_BGClr_g", 255, true, false, "", 0, 255 )
l_CCCVr("lpc_BGClr_b", 255, true, false, "", 0, 255 )
l_CCCVr("lpc_BGClr_a", 255, true, false, "", 0, 255 )
l_CCCVr("lpc_HTClr_r", 255, true, false, "", 0, 255 )
l_CCCVr("lpc_HTClr_g", 255, true, false, "", 0, 255 )
l_CCCVr("lpc_HTClr_b", 255, true, false, "", 0, 255 )
l_CCCVr("lpc_HTClr_a", 255, true, false, "", 0, 255 )
l_CCCVr("lpc_BGTClr_r", 0, true, false, "", 0, 255 )
l_CCCVr("lpc_BGTClr_g", 191, true, false, "", 0, 255 )
l_CCCVr("lpc_BGTClr_b", 255, true, false, "", 0, 255 )
l_CCCVr("lpc_BGTClr_a", 255, true, false, "", 0, 255 )
l_CCCVr("lpc_vertical", ScrH() * .02, true, false, "", 10, ScrH()- 10 )
l_CCCVr("lpc_horizontal", ScrW() * .010, true, false, "", 10, ScrW()- 10 )
l_CCCVr("lpc_HH", ScrH() * .020, true, false, "", 10, ScrH()- 10 )
l_CCCVr("lpc_HW", ScrW() * .05, true, false, "", 10, ScrW()- 10 )
l_CCCVr("lpc_BGH", ScrH() * .030, true, false, "", 10, ScrH()- 10 )
l_CCCVr("lpc_BGW", ScrW() * .05, true, false, "", 10, ScrW()- 10 )
--[[
local propCounterHeadHeight = ScrH() * .020
local propCounterHeadWidth = ScrW() * .05
local propCounterHeight = ScrH() * .030
local propCounterWidth = ScrW() * .05
]]
-- Grabs Screen Width and Height and stores as variable.
local ScW = ScrW()
local ScH = ScrH()

local pcLocation = {["v"] = l_GCVr("lpc_vertical"):GetInt(), ["h"] =  l_GCVr("lpc_horizontal"):GetInt()}
local pcSize = {['HH'] = l_GCVr("lpc_HH"):GetInt(),['HW'] = l_GCVr("lpc_HW"):GetInt(),['BGH'] = l_GCVr("lpc_BGH"):GetInt(),['BGW'] = l_GCVr("lpc_BGW"):GetInt()}
local pcHClrT = {['r'] = l_GCVr("lpc_HClr_r"):GetInt(),['g'] = l_GCVr("lpc_HClr_g"):GetInt(),['b'] = l_GCVr("lpc_HClr_b"):GetInt(),['a'] = l_GCVr("lpc_HClr_a"):GetInt()}
local pcHTClrT = {['r'] = l_GCVr("lpc_HTClr_r"):GetInt(),['g'] = l_GCVr("lpc_HTClr_g"):GetInt(),['b'] = l_GCVr("lpc_HTClr_b"):GetInt(),['a'] = l_GCVr("lpc_HTClr_a"):GetInt()}
local pcBGClrT = {['r'] = l_GCVr("lpc_BGClr_r"):GetInt(),['g'] = l_GCVr("lpc_BGClr_g"):GetInt(),['b'] = l_GCVr("lpc_BGClr_b"):GetInt(),['a'] = l_GCVr("lpc_BGClr_a"):GetInt()}
local pcBGTClrT = {['r'] = l_GCVr("lpc_BGTClr_r"):GetInt(),['g'] = l_GCVr("lpc_BGTClr_g"):GetInt(),['b'] = l_GCVr("lpc_BGTClr_b"):GetInt(),['a'] = l_GCVr("lpc_BGTClr_a"):GetInt()}

l_sCFt( "PropCounterHeadText", {
	font = "Arial",
	extended = false,
	size = ScrW() * .010,
	weight = 650,
	antialias = true,
  })
  
  l_sCFt( "PropCounterText", {
	font = "Arial",
	extended = false,
	size = ScrW() * .020,
	weight = 1000,
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
		LPH:NumSlider( "Vertical Location Slider", "lpc_vertical", 10,ScH - (pcSize['HH']+ pcSize['BGH'] + 10), 0 )
		LPH:NumSlider( "Horizontal Location Slider", "lpc_horizontal", 10,ScW - (pcSize['HW'] + 10), 0 )
	end )
end )




l_hAd("HUDPaint", "ClientPropCounterHUDHook", function()
	-- Top Color Bar - Says "Prop Count"
	l_dRBEx(3,pcLocation["h"], pcLocation["v"], pcSize['HW'], pcSize['HH'], l_Cr(pcHClrT["r"],pcHClrT["g"],pcHClrT["b"], pcHClrT["a"] ), true, true, false, false)
	-- Main UI Box
	l_dRBEx(1,pcLocation["h"], pcLocation["v"] + pcSize['HH'], pcSize['BGW'], pcSize['BGH'], l_Cr(pcBGClrT["r"], pcBGClrT["g"], pcBGClrT["b"], pcBGClrT["a"] ), false, false, true, true)
	-- Main Text - The Prop Count
	l_dSTt( l_LP():GetCount( "props" ) or 0, "PropCounterText", ScrW() * 0.035, ScrH() * 0.0546,l_Cr(pcBGTClrT["r"], pcBGTClrT["g"], pcBGTClrT["b"], pcBGTClrT["a"] ), 1, 1,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	-- Header Text - Says "Prop Count"
	l_dSTt( "Prop Count", "PropCounterHeadText", ScrW() * 0.035, ScrH() * .0295,l_Cr(pcHTClrT["r"], pcHTClrT["g"], pcHTClrT["b"], pcHTClrT["a"] ), 1, 1,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
  end)





























l_hAd("OnScreenSizeChanged", "PropCounterAdjustSize",function(ScW,ScH) 
	ScW = ScrW() 
	ScH = ScrH()
end)




-- Prop Counter Header Color R/G/B/A
l_cACCk("lpc_HClr_r", function(convar_name,value_old,value_new) if value_new == value_old then return end pcHClrT["r"] = value_new end)
l_cACCk("lpc_HClr_g", function(convar_name,value_old,value_new) if value_new == value_old then return end pcHClrT["g"] = value_new end)
l_cACCk("lpc_HClr_b", function(convar_name,value_old,value_new) if value_new == value_old then return end pcHClrT["b"] = value_new end)
l_cACCk("lpc_HClr_a", function(convar_name,value_old,value_new) if value_new == value_old then return end pcHClrT["a"] = value_new end)
-- Prop Counter Background Color R/G/B/A
l_cACCk("lpc_BGClr_r", function(convar_name,value_old,value_new) if value_new == value_old then return end pcBGClrT["r"] = value_new end)
l_cACCk("lpc_BGClr_g", function(convar_name,value_old,value_new) if value_new == value_old then return end pcBGClrT["g"] = value_new end)
l_cACCk("lpc_BGClr_b", function(convar_name,value_old,value_new) if value_new == value_old then return end pcBGClrT["b"] = value_new end)
l_cACCk("lpc_BGClr_a", function(convar_name,value_old,value_new) if value_new == value_old then return end pcBGClrT["a"] = value_new end)
-- Prop Counter 'Prop Count' Text Color R/G/B/A
l_cACCk("lpc_HTClr_r", function(convar_name,value_old,value_new) if value_new == value_old then return end pcHTClrT["r"] = value_new end)
l_cACCk("lpc_HTClr_g", function(convar_name,value_old,value_new) if value_new == value_old then return end pcHTClrT["g"] = value_new end)
l_cACCk("lpc_HTClr_b", function(convar_name,value_old,value_new) if value_new == value_old then return end pcHTClrT["b"] = value_new end)
l_cACCk("lpc_HTClr_a", function(convar_name,value_old,value_new) if value_new == value_old then return end pcHTClrT["a"] = value_new end)
-- Prop Counter Count Text Color R/G/B/A
l_cACCk("lpc_BGTClr_r", function(convar_name,value_old,value_new) if value_new == value_old then return end pcBGTClrT["r"] = value_new end)
l_cACCk("lpc_BGTClr_g", function(convar_name,value_old,value_new) if value_new == value_old then return end pcBGTClrT["g"] = value_new end)
l_cACCk("lpc_BGTClr_b", function(convar_name,value_old,value_new) if value_new == value_old then return end pcBGTClrT["b"] = value_new end)
l_cACCk("lpc_BGTClr_a", function(convar_name,value_old,value_new) if value_new == value_old then return end pcBGTClrT["a"] = value_new end)
-- Prop Counter Count Text Color R/G/B/A
l_cACCk("lpc_vertical", function(convar_name,value_old,value_new) if value_new == value_old then return end pcLocation["v"] = value_new end)
l_cACCk("lpc_horizontal", function(convar_name,value_old,value_new) if value_new == value_old then return end pcLocation["h"] = value_new end)