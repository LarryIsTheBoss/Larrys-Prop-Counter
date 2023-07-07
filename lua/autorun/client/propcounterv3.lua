local l_cACCk = cvars.AddChangeCallback
local l_CCCVr = (CLIENT && CreateClientConVar or NULL)

l_CCCVr("lpc_head_r", "#ffffff", true, false, "Set the color using hex code: EX: #FFFFFF (Include the '#')", 0, 255 )
l_CCCVr("lpc_head_g", "#00bfff", true, false, "Set the color using hex code: EX: #FFFFFF (Include the '#')", 0, 255 )
l_CCCVr("lpc_head_b", "#00bfff", true, false, "Set the color using hex code: EX: #FFFFFF (Include the '#')", 0, 255 )
l_CCCVr("lpc_head_a", "#ffffff", true, false, "Set the color using hex code: EX: #FFFFFF (Include the '#')", 0, 255 )
l_CCCVr("lpc_head_r", "#ffffff", true, false, "Set the color using hex code: EX: #FFFFFF (Include the '#')", 0, 255 )
l_CCCVr("lpc_head_g", "#00bfff", true, false, "Set the color using hex code: EX: #FFFFFF (Include the '#')", 0, 255 )
l_CCCVr("lpc_head_b", "#00bfff", true, false, "Set the color using hex code: EX: #FFFFFF (Include the '#')", 0, 255 )
l_CCCVr("lpc_head_a", "#ffffff", true, false, "Set the color using hex code: EX: #FFFFFF (Include the '#')", 0, 255 )
-- Creates Larry's Prop Counter Category
hook.Add( "AddToolMenuCategories", "PropCounterCategory", function()
	spawnmenu.AddToolCategory( "Utilities", "#Larry's Prop Counter", "#Larry's Prop Counter" )
end )
-- Creates Larry's Prop Counter Sub-Category
hook.Add( "PopulateToolMenu", "PropCounterColorSettings", function()
	spawnmenu.AddToolMenuOption( "Utilities", "#Larry's Prop Counter", "PropCounterMenu", "#Prop Counter Color", "", "", function( panel ) 
		panel:ColorPicker("Prop Counter Header Color", "lpc_head_r", "lpc_head_g", "lpc_head_b", "lpc_head_a")
		panel:ColorPicker("Prop Counter Background Color", "lpc_back_r", "lpc_back_g", "lpc_back_b", "lpc_back_a" )
	end )
end )


l_cACCk("lpc_head_r", function(convar_name, value_old, value_new)
	if value_new == value_old then return end
	var_lpc_head_r = value_new
	print(var_lpc_head_r)
  end)
l_cACCk("lpc_head_g", function(convar_name, value_old, value_new)
	if value_new == value_old then return end
	var_lpc_head_g = value_new
	print(var_lpc_head_g)
end)
l_cACCk("lpc_head_b", function(convar_name, value_old, value_new)
	if value_new == value_old then return end
	var_lpc_head_b = value_new
	print(var_lpc_head_b)
end)
l_cACCk("lpc_head_a", function(convar_name, value_old, value_new)
	if value_new == value_old then return end
	var_lpc_head_a = value_new
	print(var_lpc_head_a)
end)
