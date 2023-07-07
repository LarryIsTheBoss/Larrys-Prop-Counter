-- Added CLIENT && / or NULL for consistent formatting and micro-optimizations.
local l_hAd = (CLIENT && hook.Add or NULL)
local l_CCCVr = (CLIENT && CreateClientConVar or NULL)
local l_GCVr = (CLIENT && GetConVar or NULL)
local l_cACCk = cvars.AddChangeCallback
local l_sCFt = (CLIENT && surface.CreateFont or NULL)
local l_LP = (CLIENT && LocalPlayer or NULL)
local l_dRBEx = (CLIENT && draw.RoundedBoxEx or NULL)
local l_dSTt = (CLIENT && draw.SimpleText or NULL)
local l_Cr = (CLIENT && Color or NULL)
local l_tnr = (CLIENT && tonumber or NULL)
local l_sgb = (CLIENT && string.gsub or NULL)

-- Client Convars to manipulate the hud.
l_CCCVr("propcounter_position", 1, true, false, "The position that the HUD is in.", 1, 8 )
l_CCCVr("propcounter_hud_head_alpha", 255, true, false, "Top UI Bar Transparency/Opacity: 0-255", 0, 255 )
l_CCCVr("propcounter_hud_head_textalpha", 255, true, false, "Top UI Text Transparency/Opacity: 0-255", 0, 255 )
l_CCCVr("propcounter_hud_alpha", 255, true, false, "Main UI Transparency/Opacity: 0-255", 0, 255 )
l_CCCVr("propcounter_hud_textalpha", 255, true, false, "Count Text Transparency/Opacity: 0-255", 0, 255 )
l_CCCVr("propcounter_hudcolor_main", "#ffffff", true, false, "Set the color using hex code: EX: #FFFFFF (Include the '#')", 0, 255 )
l_CCCVr("propcounter_hudcolor_maintext", "#00bfff", true, false, "Set the color using hex code: EX: #FFFFFF (Include the '#')", 0, 255 )
l_CCCVr("propcounter_hudcolor_head", "#00bfff", true, false, "Set the color using hex code: EX: #FFFFFF (Include the '#')", 0, 255 )
l_CCCVr("propcounter_hudcolor_headtext", "#ffffff", true, false, "Set the color using hex code: EX: #FFFFFF (Include the '#')", 0, 255 )

local rgba_head_alpha = l_GCVr("propcounter_hud_head_alpha"):GetInt()
local rgba_headtext_alpha = l_GCVr("propcounter_hud_head_textalpha"):GetInt()
local rgba_alpha = l_GCVr("propcounter_hud_alpha"):GetInt()
local rgba_alpha_text = l_GCVr("propcounter_hud_textalpha"):GetInt()

-- Converts the HEX code to RGB format.
-- Thank to https://gist.github.com/fernandohenriques/12661bf250c8c2d8047188222cab7e28
-- I modified it to work properly, the one at the above URL didn't work at all.
local function hex2rgb(hex)
    local hex = hex:gsub("#","")
    if hex:len() == 3 then
        local color_r = l_tnr("0x" .. hex:sub(1,1)) * 17
        local color_g = l_tnr("0x" .. hex:sub(2,2)) * 17
        local color_b = l_tnr("0x" .. hex:sub(3,3)) * 17
        l_sgb(color_r," ")
        l_sgb(color_g," ")
        l_sgb(color_b," ")
        local rgbTable = {[r] = color_r,[g] = color_g,[b] = color_b}
      return rgbTable
    else
        local color_r = l_tnr("0x" .. hex:sub(1,2))
        local color_g = l_tnr("0x" .. hex:sub(3,4))
        local color_b = l_tnr("0x" .. hex:sub(5,6))
        l_sgb(color_r," ","")
        l_sgb(color_g," ","")
        l_sgb(color_b," ","")
        local rgbTable = {}
        rgbTable["r"] = color_r
        rgbTable["g"] = color_g
        rgbTable["b"] = color_b
      return rgbTable
    end
end

local propCounterHeadHeight = ScrH() * .020
local propCounterHeadWidth = ScrW() * .05
local propCounterHeight = ScrH() * .030
local propCounterWidth = ScrW() * .05

l_hAd("OnScreenSizeChanged", "PropCounterAdjustSize",function()
  local l_ScW = ScrW
  local l_ScH = ScrH
  propCounterHeadHeight = l_ScH() * .020
  propCounterHeadWidth = l_ScW() * .05
  propCounterHeight = l_ScH() * .030
  propCounterWidth = l_ScW() * .05
end)

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

-- Default Colors Using HEX to RGB Conversion
local propcounter_hudcolor_main = l_GCVr("propcounter_hudcolor_main"):GetString() or "#ffffff"
local propcounter_hudcolor_maintext = l_GCVr("propcounter_hudcolor_maintext"):GetString() or "#00bfff"
local propcounter_hudcolor_head = l_GCVr("propcounter_hudcolor_head"):GetString() or "#00bfff"
local propcounter_hudcolor_headtext = l_GCVr("propcounter_hudcolor_headtext"):GetString() or "#ffffff"

-- Adjusts the huds position when it changes.
local SetPropCounterHudPos = function(hud_position)
  local l_ScW = ScrW
  local l_ScrH = ScrH
  if hud_position == 1 then
    local hudLCFG = {}
    hudLCFG["propCHLX"] = l_ScW() * .010
    hudLCFG["propCHLY"] = l_ScrH() * .02
    hudLCFG["propCHTLX"] = l_ScW() * 0.035
    hudLCFG["propCHTLY"] = l_ScrH() * .0295
    hudLCFG["propCLX"] = hudLCFG["propCHLX"]
    hudLCFG["propCLY"] = l_ScrH() * .0390000
    hudLCFG["propCTLX"] = l_ScW() * 0.035
    hudLCFG["propCTLY"] = l_ScrH() * 0.0546
    return hudLCFG
  elseif hud_position == 2 then
    local hudLCFG = {}
    hudLCFG["propCHLX"] = l_ScW() * .4755
    hudLCFG["propCHLY"] = l_ScrH() * .02
    hudLCFG["propCHTLX"] = l_ScW() * .5008
    hudLCFG["propCHTLY"] = l_ScrH() * .0295
    hudLCFG["propCLX"] = hudLCFG["propCHLX"]
    hudLCFG["propCLY"] = l_ScrH() * .0390000
    hudLCFG["propCTLX"] = l_ScW() * .5008
    hudLCFG["propCTLY"] = l_ScrH() * 0.0546
    return hudLCFG
  elseif hud_position == 3 then
    local hudLCFG = {}
    hudLCFG["propCHLX"] = l_ScW() * .94
    hudLCFG["propCHLY"] = l_ScrH() * .02
    hudLCFG["propCHTLX"] = l_ScW() * .965
    hudLCFG["propCHTLY"] = l_ScrH() * .0295
    hudLCFG["propCLX"] = hudLCFG["propCHLX"]
    hudLCFG["propCLY"] = l_ScrH() * .0390000
    hudLCFG["propCTLX"] = l_ScW() * 0.965
    hudLCFG["propCTLY"] = l_ScrH() * 0.0546
    return hudLCFG
  elseif hud_position == 4 then
    local hudLCFG = {}
    hudLCFG["propCHLX"] = l_ScW() * .010
    hudLCFG["propCHLY"] = l_ScrH() * .451
    hudLCFG["propCHTLX"] = l_ScW() * 0.035
    hudLCFG["propCHTLY"] = l_ScrH() * 0.460
    hudLCFG["propCLX"] = hudLCFG["propCHLX"]
    hudLCFG["propCLY"] = l_ScrH() * .471
    hudLCFG["propCTLX"] = l_ScW() * 0.035
    hudLCFG["propCTLY"] = l_ScrH() * 0.486
    return hudLCFG
  elseif hud_position == 5 then
    local hudLCFG = {}
    hudLCFG["propCHLX"] = l_ScW() * .94
    hudLCFG["propCHLY"] = l_ScrH() * .451
    hudLCFG["propCHTLX"] = l_ScW() * .965
    hudLCFG["propCHTLY"] = l_ScrH() * 0.4605
    hudLCFG["propCLX"] = hudLCFG["propCHLX"]
    hudLCFG["propCLY"] = l_ScrH() * .471
    hudLCFG["propCTLX"] = l_ScW() * 0.965
    hudLCFG["propCTLY"] = l_ScrH() * 0.486
    return hudLCFG
  elseif hud_position == 6 then
    local hudLCFG = {}
    hudLCFG["propCHLX"] = l_ScW() * .010
    hudLCFG["propCHLY"] = l_ScrH() * .8415
    hudLCFG["propCHTLX"] = l_ScW() * 0.035
    hudLCFG["propCHTLY"] = l_ScrH() * 0.852
    hudLCFG["propCLX"] = hudLCFG["propCHLX"]
    hudLCFG["propCLY"] = l_ScrH() * .862
    hudLCFG["propCTLX"] = l_ScW() * 0.035
    hudLCFG["propCTLY"] = l_ScrH() * 0.8765
    return hudLCFG
  elseif hud_position == 7 then
    local hudLCFG = {}
    hudLCFG["propCHLX"] = l_ScW() * .4755
    hudLCFG["propCHLY"] = l_ScrH() * .92
    hudLCFG["propCHTLX"] = l_ScW() * .5008
    hudLCFG["propCHTLY"] = l_ScrH() * 0.93
    hudLCFG["propCLX"] = hudLCFG["propCHLX"]
    hudLCFG["propCLY"] = l_ScrH() * .941
    hudLCFG["propCTLX"] = l_ScW() * .5008
    hudLCFG["propCTLY"] = l_ScrH() * 0.956
    return hudLCFG
  elseif hud_position == 8 then
    local hudLCFG = {}
    hudLCFG["propCHLX"] = l_ScW() * .94
    hudLCFG["propCHLY"] = l_ScrH() * .92
    hudLCFG["propCHTLX"] = l_ScW() * .965
    hudLCFG["propCHTLY"] = l_ScrH() * 0.93
    hudLCFG["propCLX"] = hudLCFG["propCHLX"]
    hudLCFG["propCLY"] = l_ScrH() * .941
    hudLCFG["propCTLX"] = l_ScW() * 0.965
    hudLCFG["propCTLY"] = l_ScrH() * 0.956
    return hudLCFG
  end
end

l_hAd("HUDPaint", "ClientPropCounterHUDHook", function()
  local AdjustHUDPos = SetPropCounterHudPos(l_GCVr("propcounter_position"):GetInt())
  local mainHUDColor = hex2rgb(propcounter_hudcolor_main)
  local mainHUDTextColor = hex2rgb(propcounter_hudcolor_maintext)
  local headHUDColor = hex2rgb(propcounter_hudcolor_head)
  local headHUDTextColor = hex2rgb(propcounter_hudcolor_headtext)
  -- Top Color Bar - Says "Prop Count"
  l_dRBEx(3,AdjustHUDPos["propCHLX"], AdjustHUDPos["propCHLY"], propCounterHeadWidth, propCounterHeadHeight, l_Cr(headHUDColor["r"],headHUDColor["g"],headHUDColor["b"], rgba_head_alpha ), true, true, false, false)
  -- Main UI Box
  l_dRBEx(1,AdjustHUDPos["propCLX"], AdjustHUDPos["propCLY"], propCounterWidth, propCounterHeight, l_Cr(mainHUDColor["r"], mainHUDColor["g"], mainHUDColor["b"], rgba_alpha ), false, false, true, true)
  -- Main Text - The Prop Count
  l_dSTt( l_LP():GetCount( "props" ) or 0, "PropCounterText", AdjustHUDPos["propCTLX"], AdjustHUDPos["propCTLY"],l_Cr(mainHUDTextColor["r"], mainHUDTextColor["g"], mainHUDTextColor["b"], rgba_alpha_text ), 1, 1,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
  -- Header Text - Says "Prop Count"
  l_dSTt( "Prop Count", "PropCounterHeadText", AdjustHUDPos["propCHTLX"], AdjustHUDPos["propCHTLY"],l_Cr(headHUDTextColor["r"], headHUDTextColor["g"], headHUDTextColor["b"], rgba_headtext_alpha ), 1, 1,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end)
l_cACCk("propcounter_position", function(convar_name, value_old, value_new)
  if value_new == value_old then return end
  hud_position = value_new
end)
l_cACCk("propcounter_hud_head_alpha", function(convar_name, value_old, value_new)
  if value_new == value_old then return end
  rgba_head_alpha = value_new
end)
l_cACCk("propcounter_hud_head_textalpha", function(convar_name, value_old, value_new)
  if value_new == value_old then return end
  rgba_headtext_alpha = value_new
end)
l_cACCk("propcounter_hud_alpha", function(convar_name, value_old, value_new)
  if value_new == value_old then return end
  rgba_alpha = value_new
end)
l_cACCk("propcounter_hud_textalpha", function(convar_name, value_old, value_new)
  if value_new == value_old then return end
  rgba_alpha_text = value_new
end)
l_cACCk("propcounter_hudcolor_main", function(convar_name, value_old, value_new)
  if value_new == value_old then return end
  propcounter_hudcolor_main = value_new
end)
l_cACCk("propcounter_hudcolor_head", function(convar_name, value_old, value_new)
  if value_new == value_old then return end
  propcounter_hudcolor_head = value_new
end)
l_cACCk("propcounter_hudcolor_maintext", function(convar_name, value_old, value_new)
  if value_new == value_old then return end
  propcounter_hudcolor_maintext = value_new
end)
l_cACCk("propcounter_hudcolor_headtext", function(convar_name, value_old, value_new)
  if value_new == value_old then return end
  propcounter_hudcolor_headtext = value_new
end)