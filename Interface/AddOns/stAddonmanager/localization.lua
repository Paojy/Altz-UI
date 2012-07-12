local ADDON_NAME = ...

local ns = select(2, ...)

local L = {}
local Locale = GetLocale()

L.Search = "Search"
L.ReloadUI = "Reload UI"
L.Profiles = "Profiles"
L.New_Profile = "New Profile"
L.Enable_All = "Enable All"
L.Disable_All = "Disable All"
L.Profile_Name = "Profile Name"
L.Set_To = "Set To.."
L.Add_To = "Add To.."
L.Remove_From = "Remove From.."
L.Delete_Profile = "Delete Profile.."
L.Confirm_Delete = "Are you sure you want to delete this profile? Hold down shift and click again if you are."

if Locale == "zhCN" then
	L.Search = " 搜索"
	L.ReloadUI = "重载插件"
	L.Profiles = "配置文件"
	L.New_Profile = "新配置文件"
	L.Enable_All = "启用全部"
	L.Disable_All = "禁用全部"
	L.Profile_Name = "配置文件名字"
	L.Set_To = "设置到.."
	L.Add_To = "增加到.."
	L.Remove_From = "移除自.."
	L.Delete_Profile = "删除配置文件.."
	L.Confirm_Delete = "你是否真的想要删除这个配置文件? 如果确定请按住 Shift 并点击."
end

if Locale == "zhTW" then
	L.Search = "搜索"
	L.ReloadUI = "重載插件"
	L.Profiles = "配置文件"
	L.New_Profile = "新配置文件"
	L.Enable_All = "啟用全部"
	L.Disable_All = "禁用全部"
	L.Profile_Name = "配置文件名字"
	L.Set_To = "設置到.."
	L.Add_To = "增加到.."
	L.Remove_From = "移除自.."
	L.Delete_Profile = "刪除配置文件.."
	L.Confirm_Delete = "妳是否真的想要刪除這個配置文件? 如果確定請按住 Shift 並點擊."
end

ns.L = L