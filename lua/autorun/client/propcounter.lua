local _ScrW = (CLIENT && ScrW or NULL) -- Added CLIENT && / or NULL for consistent formatting.
local _ScrH = (CLIENT && ScrH or NULL)
local _hook_Add = (CLIENT && hook.Add or NULL)
local _CreateClientConVar = (CLIENT && CreateClientConVar or NULL)
local _GetConVar = (CLIENT && GetConVar or NULL)
local _cvars_AddChangeCallback = cvars.AddChangeCallback
local _timer_Create = (CLIENT && timer.Create or NULL)
local _surface_CreateFont = (CLIENT && surface.CreateFont or NULL)
local _LocalPlayer = (CLIENT && LocalPlayer or NULL)
local _draw_RoundedBoxEx = (CLIENT && draw.RoundedBoxEx or NULL)
local _draw_SimpleText = (CLIENT && draw.SimpleText or NULL)
local _Color = (CLIENT && Color or NULL)
-- Client Convars to manipulate the hud.
_CreateClientConVar("propcounter_position", 1, true, false, "The position that the HUD is in.", 1, 8 )
_CreateClientConVar("propcounter_head_r", 0, true, false, "Top UI Bar Red: 0-255", 0, 255 )
_CreateClientConVar("propcounter_head_g", 191, true, false, "Top UI Bar Green: 0-255", 0, 255 )
_CreateClientConVar("propcounter_head_b", 255, true, false, "Top UI Bar Blue: 0-255", 0, 255 )
_CreateClientConVar("propcounter_head_a", 255, true, false, "Top UI Bar Transparency/Opacity: 0-255", 0, 255 )
_CreateClientConVar("propcounter_headtext_r", 255, true, false, "Top UI Text Red: 0-255", 0, 255 )
_CreateClientConVar("propcounter_headtext_g", 255, true, false, "Top UI Text Green: 0-255", 0, 255 )
_CreateClientConVar("propcounter_headtext_b", 255, true, false, "Top UI Text Blue: 0-255", 0, 255 )
_CreateClientConVar("propcounter_headtext_a", 255, true, false, "Top UI Text Transparency/Opacity: 0-255", 0, 255 )
_CreateClientConVar("propcounter_r", 255, true, false, "Main UI Red: 0-255", 0, 255 )
_CreateClientConVar("propcounter_g", 255, true, false, "Main UI Green: 0-255", 0, 255 )
_CreateClientConVar("propcounter_b", 255, true, false, "Main UI Blue: 0-255", 0, 255 )
_CreateClientConVar("propcounter_a", 255, true, false, "Main UI Transparency/Opacity: 0-255", 0, 255 )
_CreateClientConVar("propcounter_text_r", 0, true, false, "Count Text Red: 0-255", 0, 255 )
_CreateClientConVar("propcounter_text_g", 191, true, false, "Count Text Green: 0-255", 0, 255 )
_CreateClientConVar("propcounter_text_b", 255, true, false, "Count Text Blue: 0-255", 0, 255 )
_CreateClientConVar("propcounter_text_a", 255, true, false, "Count Text Transparency/Opacity: 0-255", 0, 255 )
_surface_CreateFont( "PropCounterHeadText", {
  font = "Arial",
  extended = false,
  size = _ScrW() * .010,
  weight = 650,
  antialias = true,
} )
_surface_CreateFont( "PropCounterText", {
  font = "Arial",
  extended = false,
  size = _ScrW() * .020,
  weight = 1000,
  antialias = true,
} )
local rgba_head_red = _GetConVar("propcounter_head_r"):GetInt()
local rgba_head_green = _GetConVar("propcounter_head_g"):GetInt()
local rgba_head_blue = _GetConVar("propcounter_head_b"):GetInt()
local rgba_head_alpha = _GetConVar("propcounter_head_a"):GetInt()
local rgba_headtext_red = _GetConVar("propcounter_headtext_r"):GetInt()
local rgba_headtext_green = _GetConVar("propcounter_headtext_g"):GetInt()
local rgba_headtext_blue = _GetConVar("propcounter_headtext_b"):GetInt()
local rgba_headtext_alpha = _GetConVar("propcounter_headtext_a"):GetInt()
local rgba_red = _GetConVar("propcounter_r"):GetInt()
local rgba_green = _GetConVar("propcounter_g"):GetInt()
local rgba_blue = _GetConVar("propcounter_b"):GetInt()
local rgba_alpha = _GetConVar("propcounter_a"):GetInt()
local rgba_red_text = _GetConVar("propcounter_text_r"):GetInt()
local rgba_green_text = _GetConVar("propcounter_text_g"):GetInt()
local rgba_blue_text = _GetConVar("propcounter_text_b"):GetInt()
local rgba_alpha_text = _GetConVar("propcounter_text_a"):GetInt()
local propCounterHeadHeight = _ScrH() * .020
local propCounterHeadWidth = _ScrW() * .05
local propCounterHeadLocationX = nil
local propCounterHeadLocationY = nil
local propCounterHeight = _ScrH() * .030
local propCounterWidth = propCounterHeadWidth
local propCounterLocationX = nil
local propCounterLocationY = nil
local propCount = 0
local propTextPosChange = 0.064
local PropCountFunction = function()
  -- Special thanks to GlorifiedPig for helping me fix the props counter. http://steamcommunity.com/profiles/76561198073308340
  _timer_Create("propcounter_update_propcount", 0.50, 0, function()
    local propEntsCount = _LocalPlayer():GetCount( "props" )
    propCount = propEntsCount
    if propCount < 10 then
      propTextPosChange = 0.064
    elseif propCount >= 10 && propCount <= 99 then
      propTextPosChange = 0.0635
    elseif propCount >= 100 && propCount <= 999 then
      propTextPosChange = 0.06265
    else
      propTextPosChange = 0.0630
    end
  end)
end
_hook_Add("InitPostEntity", "ClientPropCounterSpawnHook", PropCountFunction())
_hook_Add("HUDPaint", "ClientPropCounterHUDHook", function()
  local hud_position = _GetConVar("propcounter_position"):GetInt()
  if hud_position == 1 then
    propCounterHeadLocationX = _ScrW() * .010
    propCounterHeadLocationY = _ScrH() * .02
    propCounterHeadTextLocationX = _ScrW() * .0345
    propCounterHeadTextLocationY = _ScrH() * .0295
    propCounterLocationX = propCounterHeadLocationX
    if _ScrH() < 1080 && _ScrW() < 1920 then
      propCounterLocationY = _ScrH() * .040
    else
      propCounterLocationY = _ScrH() * .041
    end
    propCounterTextLocationX = _ScrW() * (propTextPosChange - 0.0283)
    propCounterTextLocationY = _ScrH() * 0.0546
  elseif hud_position == 2 then
    propCounterHeadLocationX = _ScrW() * .4755
    propCounterHeadLocationY = _ScrH() * .02
    propCounterLocationX = propCounterHeadLocationX
    if _ScrH() < 1080 && _ScrW() < 1920 then
      propCounterLocationY = _ScrH() * .040
    else
      propCounterLocationY = _ScrH() * .041
    end
    propCounterHeadTextLocationX = _ScrW() * .5008
    propCounterHeadTextLocationY = _ScrH() * .03
    propCounterTextLocationX = _ScrW() * (propTextPosChange + 0.4368)
    propCounterTextLocationY = _ScrH() * 0.0546
  elseif hud_position == 3 then
    propCounterHeadLocationX = _ScrW() * .94
    propCounterHeadLocationY = _ScrH() * .02
    propCounterLocationX = propCounterHeadLocationX
    if _ScrH() < 1080 && _ScrW() < 1920 then
      propCounterLocationY = _ScrH() * .040
    else
      propCounterLocationY = _ScrH() * .041
    end
    propCounterHeadTextLocationX = _ScrW() * .965
    propCounterHeadTextLocationY = _ScrH() * .028
    propCounterTextLocationX = _ScrW() * (propTextPosChange + 0.9022)
    propCounterTextLocationY = _ScrH() * 0.0546
  elseif hud_position == 4 then
    propCounterHeadLocationX = _ScrW() * .010
    propCounterHeadLocationY = _ScrH() * .451
    propCounterLocationX = propCounterHeadLocationX
    propCounterLocationY = _ScrH() * .471
    propCounterHeadTextLocationX = _ScrW() * .0345
    propCounterHeadTextLocationY = _ScrH() * 0.460
    propCounterTextLocationX = _ScrW() * (propTextPosChange - 0.0283)
    propCounterTextLocationY = _ScrH() * 0.486
  elseif hud_position == 5 then
    propCounterHeadLocationX = _ScrW() * .94
    propCounterHeadLocationY = _ScrH() * .451
    propCounterLocationX = propCounterHeadLocationX
    propCounterLocationY = _ScrH() * .471
    propCounterHeadTextLocationX = _ScrW() * .965
    propCounterHeadTextLocationY = _ScrH() * 0.459
    propCounterTextLocationX = _ScrW() * (propTextPosChange + 0.9022)
    propCounterTextLocationY = _ScrH() * 0.486
  elseif hud_position == 6 then
    propCounterHeadLocationX = _ScrW() * .010
    propCounterHeadLocationY = _ScrH() * .8415
    propCounterLocationX = propCounterHeadLocationX
    if _ScrH() < 1080 && _ScrW() < 1920 then
      propCounterLocationY = _ScrH() * .861
    else
      propCounterLocationY = _ScrH() * .862
    end
    propCounterHeadTextLocationX = _ScrW() * .0345
    propCounterHeadTextLocationY = _ScrH() * 0.849
    propCounterTextLocationX = _ScrW() * (propTextPosChange - 0.0283)
    propCounterTextLocationY = _ScrH() * 0.8765
  elseif hud_position == 7 then
    propCounterHeadLocationX = _ScrW() * .4755
    propCounterHeadLocationY = _ScrH() * .92
    propCounterLocationX = propCounterHeadLocationX
    if _ScrH() < 1080 && _ScrW() < 1920 then
      propCounterLocationY = _ScrH() * .940
    else
      propCounterLocationY = _ScrH() * .941
    end
    propCounterHeadTextLocationX = _ScrW() * .5
    propCounterHeadTextLocationY = _ScrH() * 0.93
    propCounterTextLocationX = _ScrW() * (propTextPosChange + 0.4368)
    propCounterTextLocationY = _ScrH() * 0.956
  elseif hud_position == 8 then
    propCounterHeadLocationX = _ScrW() * .94
    propCounterHeadLocationY = _ScrH() * .92
    propCounterLocationX = propCounterHeadLocationX
    if _ScrH() < 1080 && _ScrW() < 1920 then
      propCounterLocationY = _ScrH() * .940
    else
      propCounterLocationY = _ScrH() * .941
    end
    propCounterHeadTextLocationX = _ScrW() * .965
    propCounterHeadTextLocationY = _ScrH() * 0.93
    propCounterTextLocationX = _ScrW() * (propTextPosChange + 0.9023)
    propCounterTextLocationY = _ScrH() * 0.956
  end
  _draw_RoundedBoxEx(3,propCounterHeadLocationX, propCounterHeadLocationY, propCounterHeadWidth, propCounterHeadHeight, _Color( rgba_head_red, rgba_head_green, rgba_head_blue, rgba_head_alpha ), true, true, false, false)
  _draw_RoundedBoxEx(1,propCounterLocationX, propCounterLocationY, propCounterWidth, propCounterHeight, _Color( rgba_red, rgba_green, rgba_blue, rgba_alpha ), false, false, true, true)
  _draw_SimpleText( propCount, "PropCounterText", propCounterTextLocationX, propCounterTextLocationY,_Color( rgba_red_text, rgba_green_text, rgba_blue_text , rgba_alpha_text ), 1, 1)
  _draw_SimpleText( "Prop Count", "PropCounterHeadText", propCounterHeadTextLocationX, propCounterHeadTextLocationY,_Color( rgba_headtext_red, rgba_headtext_green, rgba_headtext_blue , rgba_headtext_alpha ), 1, 1)
end)
_cvars_AddChangeCallback("propcounter_position", function(convar_name, value_old, value_new)
  if value_new == value_old then return end
  hud_position = value_new
end)
_cvars_AddChangeCallback("propcounter_head_r", function(convar_name, value_old, value_new)
  if value_new == value_old then return end
  rgba_head_red = value_new
end)
_cvars_AddChangeCallback("propcounter_head_g", function(convar_name, value_old, value_new)
  if value_new == value_old then return end
  rgba_head_green = value_new
end)
_cvars_AddChangeCallback("propcounter_head_b", function(convar_name, value_old, value_new)
  if value_new == value_old then return end
  rgba_head_blue = value_new
end)
_cvars_AddChangeCallback("propcounter_head_a", function(convar_name, value_old, value_new)
  if value_new == value_old then return end
  rgba_head_alpha = value_new
end)
_cvars_AddChangeCallback("propcounter_headtext_r", function(convar_name, value_old, value_new)
  if value_new == value_old then return end
  rgba_headtext_red = value_new
end)
_cvars_AddChangeCallback("propcounter_headtext_g", function(convar_name, value_old, value_new)
  if value_new == value_old then return end
  rgba_headtext_green = value_new
end)
_cvars_AddChangeCallback("propcounter_headtext_b", function(convar_name, value_old, value_new)
  if value_new == value_old then return end
  rgba_headtext_blue = value_new
end)
_cvars_AddChangeCallback("propcounter_headtext_a", function(convar_name, value_old, value_new)
  if value_new == value_old then return end
  rgba_headtext_alpha = value_new
end)
_cvars_AddChangeCallback("propcounter_r", function(convar_name, value_old, value_new)
  if value_new == value_old then return end
  rgba_red = value_new
end)
_cvars_AddChangeCallback("propcounter_g", function(convar_name, value_old, value_new)
  if value_new == value_old then return end
  rgba_green = value_new
end)
_cvars_AddChangeCallback("propcounter_b", function(convar_name, value_old, value_new)
  if value_new == value_old then return end
  rgba_blue = value_new
end)
_cvars_AddChangeCallback("propcounter_a", function(convar_name, value_old, value_new)
  if value_new == value_old then return end
  rgba_alpha = value_new
end)
_cvars_AddChangeCallback("propcounter_text_r", function(convar_name, value_old, value_new)
  if value_new == value_old then return end
  rgba_red_text = value_new
end)
_cvars_AddChangeCallback("propcounter_text_g", function(convar_name, value_old, value_new)
  if value_new == value_old then return end
  rgba_green_text = value_new
end)
_cvars_AddChangeCallback("propcounter_text_b", function(convar_name, value_old, value_new)
  if value_new == value_old then return end
  rgba_blue_text = value_new
end)
_cvars_AddChangeCallback("propcounter_text_a", function(convar_name, value_old, value_new)
  if value_new == value_old then return end
  rgba_alpha_text = value_new
end)