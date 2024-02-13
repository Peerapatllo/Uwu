while not game:GetService("RunService"):IsRunning() do task.wait() end

repeat task.wait() until game:IsLoaded()

repeat task.wait() until game:IsLoaded()
if game.PlaceId == 13775256536 then
    repeat task.wait() until game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name)repeat task.wait() until game.Players.LocalPlayer.PlayerGui:FindFirstChild("collection"):FindFirstChild("grid"):FindFirstChild("List"):FindFirstChild("Outer"):FindFirstChild("UnitFrames")
else
    repeat task.wait() until game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name)
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2Swiftz/UI-Library/main/Libraries/Linoria%20-%20Example.lua"))()
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService('Workspace')
local TeleportService = game:GetService('TeleportService')
local NetworkClient = game:GetService('NetworkClient')
local RunService = game:GetService("RunService")
local Lighting = game:GetService('Lighting')
local VirtualUser = game:GetService('VirtualUser')
local Stats = game:GetService("Stats")
local LocalPlayer = game.Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local Executor = tostring(identifyexecutor())
local x = {
    _MAP_CONFIG = Workspace:FindFirstChild("_MAP_CONFIG"),
    _UNITS_PATH = LocalPlayer.PlayerGui:FindFirstChild('spawn_units'):FindFirstChild('Lives'):FindFirstChild('Frame'):FindFirstChild('Units'),
    _UNITS = Workspace:FindFirstChild('_UNITS'),
    _map = Workspace:FindFirstChild('_map') 
}

local Window = Library:CreateWindow({
    Title = "Luckyware | " .. Executor,
    Center = true,
    AutoShow = true,
    TabPadding = 0
})
local Tabs = {
    Main = Window:AddTab("Main"),
    Farm = Window:AddTab("Farm"),
    Visuals = Window:AddTab('Visuals'),
    Settings = Window:AddTab("Settings"),
}
local Boxes = {
    Main = {
        LeftGroupBox = Tabs.Main:AddLeftGroupbox("Lag Switch"),
        RightGroupBox = Tabs.Main:AddRightGroupbox("Infinite Range")
    },
    Farm = {
        LeftGroupBox = Tabs.Farm:AddLeftGroupbox("Coming Soon..."),
        ["Misc"] = Tabs.Farm:AddRightGroupbox('Misc'),
        ["Cursed Womb"] = Tabs.Farm:AddRightGroupbox('Auto Cursed Womb')
    },
    Settings = {RightGroupBox = Tabs.Settings:AddRightGroupbox("Settings")},
    Visuals = {
        World = Tabs.Visuals:AddLeftGroupbox('World'),
        Player = Tabs.Visuals:AddRightGroupbox('Player')
    },
}

local Settings = {
    Version = "v0.0.3.1",
    ["Lag Switch"] = {
        Impact = 100000,
        Delay = 0.8,
        Loops = 2,
        Threads = 10,
        Cap = 500,
        Ping_Cap = false,
        Keybind = "L"
    },
    ["Infinite Range"] = {
        Keybind = "I",
        ["Follow Player"] = false
    },
    ["Auto Rejoin"] = {
        ["Cursed Womb"] = false,
        ["Map"] = "",
        ["Difficulty"] = "Easy",
        ["Auto Rejoin"] = false,
        ["Auto Infinite Castle"] = false
    },
    ["Misc"] = {
        ["Auto Leave"] = false,
        ["Auto Replay"] = false,
        ["Auto Next Room"] = false,
        ["Auto Next Story"] = false,
        ["Place Anywhere"] = false,
        ["Auto Abilites"] = {
            Erwin = false,
            Wenda = false,
            Leafa = false,
            Homuru = false,
        }
    },
    ["Visuals"] = {
        World = {
            Ambient = false,
            Brightness = false,
            Shadows = false,
            Fog = false,
            Auto_Delete_Map = false,
        },
        Player = {
            Hide_Overhead = false,
            Hide_Level = false,
            Hide_Units = false
        }
    },
    MenuKeybind = "LeftControl"
}

local a = "Luckyware"
local b = LocalPlayer.Name .. "_AA.json"

function saveSettings()
    local folderPath = a .. "/"
    local filePath = folderPath .. b

    if not isfolder(folderPath) then makefolder(folderPath) end

    writefile(filePath, HttpService:JSONEncode(Settings))
end

function ReadSetting()
    local folderPath = a .. "/"
    local filePath = folderPath .. b

    if not isfile(filePath) then
        saveSettings()
        return Settings
    end

    local success, decodedSettings = pcall(function()
        return HttpService:JSONDecode(readfile(filePath))
    end)

    if success and type(decodedSettings) == "table" then
        return decodedSettings
    else
        warn("Error reading settings file. Resetting settings to default.")
        saveSettings()
        return Settings
    end
end

Settings = ReadSetting()

local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60
WatermarkConnection = RunService.RenderStepped:Connect(function()
    FrameCounter = FrameCounter + 1
    if tick() - FrameTimer >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end
    Library:SetWatermark(("Luckyware | %s FPS | %s ms | %s KB/s"):format(
                             math.floor(FPS), math.floor(
                                 Stats.Network.ServerStatsItem["Data Ping"]:GetValue()),
                             math.floor(
                                 Stats.Network.ServerStatsItem["Send kBps"]:GetValue())))
end)

function Inventory(item: string, Path: string)
    local v5 = require(ReplicatedStorage.src.Loader)
    local v19 = v5.load_client_service(script, "ItemInventoryServiceClient")
    local result
    for i, v in next,
                v19["session"]["inventory"]["inventory_profile_data"][Path] do
        if i == item then result = v end
    end
    return result
end

Library:Notify('Loading Script')

function Infinite_Range(v)
            local success, error = pcall(function()
                local Units = OptionsX.Infinite_Range_Unit.Value
                s = v
                while s do
                    if TogglesX.Infinite_Range_Type_Player.Value then
                        MoveUnitsToPlayer(Units)
                    else
                        MoveNonPlayerUnitsToTarget(Units)
                    end
                    task.wait()
                end
            end)
            if not success then
                Library:Notify(error)
                TogglesX.Infinite_Range:SetValue(false)
            end
end
        
function MoveUnitsToPlayer(Units)
            for Units, value in next, Units do
                local unit = x._UNITS:FindFirstChild(Units)
                if unit then
                    unit.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                end
            end
end
        
function MoveNonPlayerUnitsToTarget(Units)
            for _, unit in pairs(x._UNITS:GetChildren()) do
                if unit:FindFirstChild('_stats') and not unit:FindFirstChild('_stats'):FindFirstChild('player').Value then
                    for Units, value in next, Units do
                        local Real = x._UNITS:FindFirstChild(Units)
                        if Real then
                            Real.HumanoidRootPart.CFrame = unit.HumanoidRootPart.CFrame 
                        end
                    end
                end
            end
end

function Worlds()
    local m = require(ReplicatedStorage.src.Data.Worlds)
    local Worlds = {}
    for i, tables in pairs(m) do
        if not tables.legend_stage and not tables.raid_world then
            table.insert(Worlds, tables.name)
        end
    end
    return Worlds
end

function Fetch_Units()
    local Units = {};
    for _, unit in ipairs(x._UNITS_PATH:GetChildren()) do
        if unit:IsA("ImageButton") then
            local worldModel = unit.Main.petimage.WorldModel;
            if worldModel then
                for _, child in ipairs(worldModel:GetChildren()) do
                    table.insert(Units, child.Name);
                end;
            end;
        end;
    end;
    return Units
end

function request_join_lobby(A1, A2)
    ReplicatedStorage.endpoints.client_to_server.request_join_lobby:InvokeServer(A1, A2)
end

function Lag(v)
    s = v
    while s do
        task.wait(OptionsX.Lag_Delay.Value);
        NetworkClient:SetOutgoingKBPSLimit(math.huge);
        local function getmaxvalue(val)
            local mainvalueifonetable = OptionsX.Lag_Impact.Value;
            if type(val) ~= "number" then return nil; end
            local calculateperfectval = mainvalueifonetable / (val + 2);
            return calculateperfectval;
        end
        local function lag(tableincrease, tries)
            local maintable = {};
            local spammedtable = {};
            table.insert(spammedtable, {});
            local z = spammedtable[1];
            for i = 1, tableincrease do
                local tableins = {};
                table.insert(z, tableins);
                z = tableins;
            end
            local calculatemax = getmaxvalue(tableincrease);
            local maximum;
            if calculatemax then
                maximum = calculatemax;
            else
                maximum = OptionsX.Lag_Impact.Value;
            end
            for i = 1, maximum do
                table.insert(maintable, spammedtable);
            end
            for i = 1, tries do
                game.RobloxReplicatedStorage.SetPlayerBlockList:FireServer(
                    maintable);
            end
        end
        lag(OptionsX.Lag_Threads.Value, OptionsX.Lag_Loops.Value);
    end
end

function Ping_Cap(v)
    s = v
    while s do
        if math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) >= OptionsX.Lag_Cap.Value and TogglesX.Lag_Enable.Value then
            TogglesX.Lag_Enable:SetValue(false)
            task.wait(3.5)
            TogglesX.Lag_Enable:SetValue(true)
        end
       task.wait()
    end
end

function use_active_attack(v)
    ReplicatedStorage.endpoints.client_to_server.use_active_attack:InvokeServer(v)
end

function Auto_Erwin(v)
    s = v
    if s and not x._MAP_CONFIG.IsLobby.Value then
        local erwinCount = 0
        local maxErwinCount = 4
        local erwinTable = {}
        while erwinCount ~= maxErwinCount do
            erwinCount = 0
            erwinTable = {}
            for i, unit in pairs(x._UNITS:GetChildren()) do
                local stats = unit:FindFirstChild("_stats")
                if stats and stats.id.Value == "erwin" and stats.player.Value == LocalPlayer then
                    erwinCount = erwinCount + 1
                    table.insert(erwinTable, unit)
                end
            end
            if #erwinTable ~= maxErwinCount then
                task.wait(1)
            end
        end
        while erwinCount == maxErwinCount do
            for i = 1, maxErwinCount do
                use_active_attack(erwinTable[i])
                task.wait(15.4)
            end
        end
    end
end

function Auto_Wenda(v)
    s = v
    if s and not x._MAP_CONFIG.IsLobby.Value then
        local WendaCount = 0
        local MaxWendaCount = 4
        local WendaTable = {}
        while WendaCount ~= MaxWendaCount do
            WendaCount = 0
            WendaTable = {}

            for i, unit in pairs(x._UNITS:GetChildren()) do
                local stats = unit:FindFirstChild("_stats")
                if stats and stats.id.Value == "wendy" and stats.player.Value == LocalPlayer  then
                    WendaCount = WendaCount + 1
                    table.insert(WendaTable, unit)
                end
            end
            if #WendaTable ~= MaxWendaCount then
                task.wait(1)
            end
        end
        while WendaCount == MaxWendaCount do
            for i = 1, MaxWendaCount do
                use_active_attack(WendaTable[i])
                task.wait(15.5)
            end
        end
    end
end

function Auto_Leafy(v)
    s = v
    if s and not x._MAP_CONFIG.IsLobby.Value then
        local LeafyCount = 0
        local maxLeafyCount = 4
        local LeafyTable = {}
        while LeafyCount ~= maxLeafyCount do
        
        for i, unit in pairs(x._UNITS:GetChildren()) do
            local stats = unit:FindFirstChild("_stats")
            if stats and stats.id.Value == "leafy" and stats.player.Value == LocalPlayer  then
                LeafyCount = LeafyCount + 1
                table.insert(LeafyTable, unit)
            end
        end
        if #LeafyTable ~= maxLeafyCount then
            task.wait(1)
        end
    end
            while LeafyCount == maxLeafyCount do
                for i = 1, LeafyCount do
                    use_active_attack(LeafyTable[i])
                    task.wait(16.5)
                end
            end
    end
end

function Auto_Homuru(v)
    s = v
    if s and not x._MAP_CONFIG.IsLobby.Value then
        while s do 
        for i, v in pairs(x._UNITS:GetChildren()) do 
            local stats = v:FindFirstChild("_stats")
            if stats and stats.id.Value == "homura_evolved" and stats.player.Value == game.Players.LocalPlayer then 
                use_active_attack(v)
            end
        end
        task.wait()
    end
    task.wait(5)
    end
end

function Place_Anywhere(v)
    s = v 
    while s and not x._MAP_CONFIG.IsLobby.Value do
        local services = require(game.ReplicatedStorage.src.Loader)
        local placement_service = services.load_client_service(script, "PlacementServiceClient")
        placement_service.can_place = true
        task.wait()
    end
    
end

function Anti_AFK()
    pcall(function()
        print('[Luckyware] Anti-AFK Loaded')
        LocalPlayer.Idled:connect(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame);
            task.wait(1);
            VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame);
        end);
        ReplicatedStorage.endpoints.client_to_server.claim_daily_reward:InvokeServer();
    end);
end;
function Auto_Load()
    pcall(function()
        if Executor == "Synapse X" then
            syn.queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/DistributionError/Luckyware/main/Loader'))()");
        elseif Executor ~= "Synapse X" then
            queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/DistributionError/Luckyware/main/Loader'))()");
        end;
    end);
end;

Anti_AFK()
Auto_Load()


local Menu = {
    Settings = {
        Boxes.Settings.RightGroupBox:AddButton("Unload", function()
            Library:Unload()
            WatermarkConnection:Disconnect()
        end),
        Boxes.Settings.RightGroupBox:AddLabel("Bind")
            :AddKeyPicker("MenuKeybind", {
                Default = Settings.MenuKeybind,
                Text = "Menu Keybind"
            }),
            Boxes.Settings.RightGroupBox:AddLabel('https://discord.gg/wmrgSURuCk')
    },
    Main = {
        ["Lag Switch"] = {
            Boxes.Main.LeftGroupBox:AddSlider("Lag_Impact", {
                Text = "Impact",
                Default = Settings["Lag Switch"].Impact,
                Min = 0,
                Max = 500000,
                Rounding = 0,
                Compact = true
            }), 
                Boxes.Main.LeftGroupBox:AddSlider("Lag_Delay", {
                Text = "Delay",
                Default = Settings["Lag Switch"].Delay,
                Min = 0,
                Max = 5,
                Rounding = 1,
                Compact = true
            }),
                Boxes.Main.LeftGroupBox:AddSlider("Lag_Loops", {
                Text = "Loops",
                Default = Settings["Lag Switch"].Loops,
                Min = 1,
                Max = 6,
                Rounding = 0,
                Compact = true
            }), 
            Boxes.Main.LeftGroupBox:AddSlider("Lag_Threads", {
                Text = "Threads",
                Default = Settings["Lag Switch"].Threads,
                Min = 1,
                Max = 10,
                Rounding = 0,
                Compact = true
            }), 
                Boxes.Main.LeftGroupBox:AddSlider("Lag_Cap", {
                Text = "Ping Cap",
                Default = Settings["Lag Switch"].Cap,
                Min = 0,
                Max = 1000,
                Rounding = 0,
                Compact = true
            }), 
            Boxes.Main.LeftGroupBox:AddToggle("Lag_Cap_Toggle", {
                Text = "Cap",
                Default = Settings["Lag Switch"]["Ping_Cap"],
            }):OnChanged(function(v)
                Settings["Lag Switch"]["Ping_Cap"] = v
                saveSettings()
                if v then
                    Ping_Cap(true)
                else
                    Ping_Cap(false)
                end
            end),
                Boxes.Main.LeftGroupBox:AddToggle("Lag_Enable", {
                Text = "Enable",
                Default = false
            }):OnChanged(function(v)
                if v then
                    Lag(true)
                else
                    Lag(false)
                end
            end),
            TogglesX.Lag_Enable:AddKeyPicker("Lag_Enable_Keybind", {
                Default = Settings["Lag Switch"].Keybind or "L",
                NoUI = true,
                Callback = function(v)
                if v and not TogglesX.Lag_Enable.Value then
                    TogglesX.Lag_Enable:SetValue(true);
                elseif not v and TogglesX.Lag_Enable.Value then
                    TogglesX.Lag_Enable:SetValue(false);
                end;
                end
            }),
        OptionsX.Lag_Impact:OnChanged(function() Settings["Lag Switch"]["Impact"] = tonumber(OptionsX.Lag_Impact.Value) saveSettings() end),
        OptionsX.Lag_Delay:OnChanged(function() Settings["Lag Switch"]["Delay"] = tonumber(OptionsX.Lag_Delay.Value) saveSettings() end),
        OptionsX.Lag_Loops:OnChanged(function()Settings["Lag Switch"]["Loops"] = tonumber(OptionsX.Lag_Loops.Value)saveSettings()end),
        OptionsX.Lag_Threads:OnChanged(function()Settings["Lag Switch"]["Threads"] = tonumber(OptionsX.Lag_Threads.Value)saveSettings()end),
        OptionsX.Lag_Cap:OnChanged(function()Settings["Lag Switch"]["Cap"] = tonumber(OptionsX.Lag_Cap.Value)saveSettings()end)
        },
        ["Infinite Range"] = {
            Boxes["Main"]["RightGroupBox"]:AddDropdown("Infinite_Range_Unit", {
                Values = Fetch_Units(),
                Default = 0,
                Multi = true,
                Text = "Unit(s):",
                Tooltip = false
            }),
            Boxes["Main"]["RightGroupBox"]:AddToggle("Infinite_Range_Type_Player", {
                Text = "Follow Player",
                Default = Settings["Infinite Range"]["Follow Player"],
                Tooltip = false
            }):OnChanged(function(bool)
                Settings["Infinite Range"]["Follow Player"] = bool
                saveSettings()
            end),
            Boxes["Main"]["RightGroupBox"]:AddToggle("Infinite_Range", {
                Text = "Enable",
                Default = false,
                Tooltip = "Enables Infinite Range For Full AOE Unit(s)"
            }):OnChanged(function(v)
                saveSettings()
                if v then
                    Infinite_Range(true)
                else
                    Infinite_Range(false)
                end
            end),
            TogglesX.Infinite_Range:AddKeyPicker("Infinite_Range_Keybind", {
                Default = Settings["Infinite Range"].Keybind,
                NoUI = true,
                Callback = function(v)
                if v and not TogglesX.Infinite_Range.Value then
                    TogglesX.Infinite_Range:SetValue(true);
                elseif not v and TogglesX.Infinite_Range.Value then
                    TogglesX.Infinite_Range:SetValue(false);
                end;
            end
            }),
        },
    },
    Farm = {
        ["Auto Rejoin"] = {
            ["Cursed Womb"] = {
                Boxes.Farm["Cursed Womb"]:AddToggle("Cursed Womb", {
                    Text = "Auto Rejoin",
                    Default = Settings["Auto Rejoin"]["Cursed Womb"]
                }):OnChanged(function(bool)
                    Settings["Auto Rejoin"]["Cursed Womb"] = bool
                    saveSettings()
                    if bool and not x._MAP_CONFIG.IsLobby.Value then
                        if Inventory("key_jjk_finger", "normal_items") ~= 0 then
                            request_join_lobby("_lobbytemplate_event221", {
                                ["selected_key"] = "key_jjk_finger"
                            })
                        else
                            task.wait(5)
                        end
                    end
                end),
            },
            -- Boxes.Farm.LeftGroupBox:AddDropdown("World", {
            --     Values = Worlds(),
            --     Default = Settings["Auto Rejoin"]["Map"],
            --     Multi = false,
            --     AllowNull = true
            -- }), Boxes.Farm.LeftGroupBox:AddDropdown("Difficulty", {
            --     Values = {"Easy", "Hard"},
            --     Default = Settings["Auto Rejoin"]["Difficulty"],
            --     Multi = false,
            --     AllowNull = true
            -- }),
            -- Boxes.Farm.LeftGroupBox:AddToggle('Auto_Rejoin', {
            --     Text = "Auto Rejoin",
            --     Default = Settings["Auto Rejoin"]["Auto Rejoin"]
            -- }):OnChanged(function(bool)
            --     Settings["Auto Rejoin"]["Auto Rejoin"] = bool
            --     saveSettings()
            -- end),
            -- Boxes.Farm.LeftGroupBox:AddToggle('Auto_Rejoin_Infinite_Castle', {
            --     Text = "Auto Infinity Castle",
            --     Default = Settings["Auto Rejoin"]["Auto Infinite Castle"]
            -- }):OnChanged(function(bool)
            --     Settings["Misc"]["Auto Next Room"] = bool
            --     saveSettings()
            -- end),
        },
        ["Misc"] = {
            Boxes.Farm["Misc"]:AddToggle('Auto_Leave', {
                Text = "Auto Leave",
                Default = Settings["Misc"]["Auto Leave"]
            }):OnChanged(function(bool)
                Settings["Misc"]["Auto Leave"] = bool
                saveSettings()
            end),
            Boxes.Farm["Misc"]:AddToggle('Auto_Replay', {
                Text = "Auto Replay",
                Default = Settings["Misc"]["Auto Replay"]
            }):OnChanged(function(bool)
                Settings["Misc"]["Auto Replay"] = bool
                saveSettings()
            end),
            Boxes.Farm["Misc"]:AddDivider(),
            Boxes.Farm["Misc"]:AddToggle('Auto_Next_Room', {
                Text = "Auto Next Room",
                Default = Settings["Misc"]["Auto Next Room"]
            }):OnChanged(function(bool)
                Settings["Misc"]["Auto Next Room"] = bool
                saveSettings()
            end),
            Boxes.Farm["Misc"]:AddToggle('Auto_Next_Story', {
                Text = "Auto Next Story",
                Default = Settings["Misc"]["Auto Next Story"]
            }):OnChanged(function(bool)
                Settings["Misc"]["Auto Next Story"] = bool
                saveSettings()
            end),
            Boxes.Farm["Misc"]:AddDivider(),
            Boxes.Farm["Misc"]:AddToggle('Place_Anywhere', {
                Text = "Place Anywhere",
                Default = Settings["Misc"]["Place Anywhere"]
            }),
            Boxes.Farm["Misc"]:AddDivider(),
            Boxes.Farm["Misc"]:AddToggle('Erwin', {
                Text = "Auto Erwin",
                Default = Settings["Misc"]["Auto Abilites"]["Erwin"],
            }),
            Boxes.Farm["Misc"]:AddToggle('Wenda', {
                Text = "Auto Wenda",
                Default = Settings["Misc"]["Auto Abilites"]["Wenda"],
            }),
            Boxes.Farm["Misc"]:AddToggle('Leafa', {
                Text = "Auto Leafa",
                Default = Settings["Misc"]["Auto Abilites"]["Leafa"],
            }),
            Boxes.Farm["Misc"]:AddToggle('Homuru', {
                Text = "Auto Homuru",
                Default = Settings["Misc"]["Auto Abilites"]["Homuru"],
            }),
        }
    },
    Visuals = {
        ["World"] = {
            Boxes.Visuals.World:AddToggle("", {
                Text = "Ambient",
                Default = Settings.Visuals.World.Ambient,
                Callback = function(v)
                    Settings.Visuals.World.Ambient = v
                    saveSettings()
                    if v then
                        Lighting.Ambient = Color3.fromRGB(255,255,255)
                    else
                        Lighting.Ambient = Color3.fromRGB(0,0,0)
                    end
                end
            }),
            Boxes.Visuals.World:AddToggle("", {
                Text = "Brightness",
                Default = Settings.Visuals.World.Brightness,
                Callback = function(v)
                    Settings.Visuals.World.Brightness = v
                    saveSettings()
                    if v then
                        Lighting.Brightness = 0
                    else
                        Lighting.Brightness = 2
                    end
                end
            }),
            Boxes.Visuals.World:AddToggle("", {
                Text = "Shadows",
                Default = Settings.Visuals.World.Shadows
            }):OnChanged(function(v)
                Settings.Visuals.World.Shadows = v
                saveSettings()
                if v then
                    Lighting.ShadowSoftness = 0
                else
                    Lighting.ShadowSoftness = 0.15
                end
            end),
            Boxes.Visuals.World:AddToggle("", {
                Text = "Fog",
                Default = Settings.Visuals.World.Fog
            }):OnChanged(function(v)
                Settings.Visuals.World.Fog = v
                saveSettings()
                if v then
                    Lighting.FogColor = Color3.fromRGB(0,0,0)
                else
                    Lighting.FogColor = Color3.fromRGB(192,192,192)
                end
            end),
            Boxes.Visuals.World:AddToggle("", {
                Text = "Auto Delete Map",
                Default = Settings.Visuals.World.Auto_Delete_Map
            }):OnChanged(function(v)
                Settings.Visuals.World.Auto_Delete_Map = v
                saveSettings()
                if v and x._map then
                    x._map:Destroy()
                else
                end
            end),
        },
        ["Player"] = {
            Boxes.Visuals.Player:AddToggle("", {
                Text = "Hide Overhead",
                Default = Settings.Visuals.Player.Hide_Overhead
            }):OnChanged(function(v)
                Settings.Visuals.Player.Hide_Overhead = v
                saveSettings()
                local Overhead = game.Players.LocalPlayer.Character.Head:FindFirstChild('_overhead')
                if Overhead then
                    Overhead.Enabled = not v
                end
            end),
            Boxes.Visuals.Player:AddToggle("", {
                Text = "Hide Level",
                Default = Settings.Visuals.Player.Hide_Level
            }):OnChanged(function(v)
                Settings.Visuals.Player.Hide_Level = v
                saveSettings()
                local level = LocalPlayer.PlayerGui.spawn_units.Lives.Main.Desc.Level
                if level then
                    level.Visible = not v
                end
            end),
            Boxes.Visuals.Player:AddToggle("", {
                Text = "Hide Units Bar",
                Default = Settings.Visuals.Player.Hide_Units
            }):OnChanged(function(v)
                Settings.Visuals.Player.Hide_Units = v
                saveSettings()
                if v then
                    PlayerGui:FindFirstChild('spawn_units').Enabled = false
                else
                    PlayerGui:FindFirstChild('spawn_units').Enabled = true
                end
            end)
        }
    }
}

TogglesX.Homuru:OnChanged(function()Settings["Misc"]["Auto Abilites"]["Homuru"] = TogglesX.Homuru.Value saveSettings() if TogglesX.Homuru.Value then Auto_Homuru(true) else Auto_Homuru(false) end end)
TogglesX.Wenda:OnChanged(function()Settings["Misc"]["Auto Abilites"]["Wenda"] = TogglesX.Wenda.Value saveSettings() if TogglesX.Wenda.Value then Auto_Wenda(true) else Auto_Wenda(false)end end)
TogglesX.Erwin:OnChanged(function()Settings["Misc"]["Auto Abilites"]["Erwin"] = TogglesX.Erwin.Value saveSettings() if TogglesX.Erwin.Value then Auto_Erwin(true) else Auto_Erwin(false)end end)
TogglesX.Leafa:OnChanged(function()Settings["Misc"]["Auto Abilites"]["Leafa"] = TogglesX.Leafa.Value saveSettings() if TogglesX.Leafa.Value then Auto_Leafy(true) else Auto_Leafy(false)end end)
TogglesX.Place_Anywhere:OnChanged(function()Settings["Misc"]["Place Anywhere"] = TogglesX.Place_Anywhere.Value saveSettings() if TogglesX.Place_Anywhere.Value then Place_Anywhere(true) else Place_Anywhere(false) end end)

Library:Notify('Loaded Script')
Library:Notify('discord.gg/wmrgSURuCk')

OptionsX.Lag_Enable_Keybind:OnChanged(function()Settings["Lag Switch"].Keybind = OptionsX.Lag_Enable_Keybind.Value saveSettings()end)
OptionsX.MenuKeybind:OnChanged(function()Settings.MenuKeybind = OptionsX.MenuKeybind.Value saveSettings()end)

Library.ToggleKeybind = OptionsX.MenuKeybind
Library:OnUnload(function() Library.Unloaded = true end)

OptionsX.World:OnChanged(function()Settings["Auto Rejoin"]["Map"] = OptionsX.World.Value saveSettings()end)
OptionsX.Difficulty:OnChanged(function()Settings["Auto Rejoin"]["Difficulty"] = OptionsX.Difficulty.Value saveSettings()end)

while task.wait(5) do 
    if x._MAP_CONFIG.IsLobby.Value then
         break
         elseif not x._MAP_CONFIG.IsLobby.Value then 
            task.spawn(function()
                local GameFinished = game:GetService("Workspace"):WaitForChild("_DATA"):WaitForChild("GameFinished")
                GameFinished:GetPropertyChangedSignal("Value"):Connect(function() 
                    if GameFinished.Value then 
                        repeat task.wait() until Players.LocalPlayer.PlayerGui.ResultsUI.Enabled
                        if Settings["Misc"]["Auto Replay"] then
                            ReplicatedStorage.endpoints.client_to_server.set_game_finished_vote:InvokeServer("replay")
                            elseif Settings["Misc"]["Auto Next Room"] then
                                ReplicatedStorage.endpoints.client_to_server.set_game_finished_vote:InvokeServer("NextRetry")
                            elseif Settings["Misc"]["Auto Next Story"] then
                                ReplicatedStorage.endpoints.client_to_server.set_game_finished_vote:InvokeServer("next_story")
                            elseif Settings["Misc"]["Auto Leave"] and not Settings["Misc"]["Auto Replay"] and not Settings["Misc"]["Auto Next Room"] then
                                TeleportService:Teleport(8304191830, LocalPlayer)
                         end
                    end
                end)
            end)
     end
end

