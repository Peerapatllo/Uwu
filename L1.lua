while not game:GetService("RunService"):IsRunning() do task.wait() end

repeat task.wait() until game:IsLoaded()

local Workspace = game:GetService("Workspace")
local NetworkClient = game:GetService("NetworkClient")
local HttpService = game:GetService('HttpService')
local VirtualUser = game:GetService('VirtualUser')
local Stats = game:GetService('Stats')
local RunService = game:GetService('RunService')
local TeleportService = game:GetService('TeleportService')
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local CoreGui = game:GetService('CoreGui')
local LocalPlayer = game.Players.LocalPlayer
local Executor = tostring(identifyexecutor())
local x = {
    _MAP_CONFIG = Workspace:FindFirstChild("_MAP_CONFIG"),
    _UNITS_PATH = LocalPlayer.PlayerGui:FindFirstChild('spawn_units'):FindFirstChild('Lives'):FindFirstChild('Frame'):FindFirstChild('Units'),
    _UNITS = Workspace:FindFirstChild('_UNITS'),
    _map = Workspace:FindFirstChild('_map') 
}

local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/x2Swiftz/UI-Library/main/Libraries/Linoria%20-%20Example.lua'))()

Library:Notify('[Luckyware] Loading Script')
print('[Luckyware] Loading Script')

local Settings = {
    Auto = {
        Leave = false,
        Replay = false,
        ["Next Room"] = false,
        ["Next Story"] = false,
        Abilites = {
            Orwin = false,
            Wenda = false,
            Leafy = false,
            Homuru = false,
        }
    },
    Other = {
        ["Place Anywhere"] = false
    },
    Lag = {
        Impact = 100000,
        Delay = 0.8,
        Loops = 2,
        Threads = 10,
        Keybind = "P",
        ["Ping Cap"] = {
            Cap = 500,
            State = false
        }
    },
    ["Infinite_Range"] = {
        Player = false,
        Keybind = "Y"
    },
    Visuals = {
        Overhead = false,
        Map = false
    },
    MenuKeybind = "LeftControl",
    Webhook = ""
}

local a = "Luckyware"
local b = LocalPlayer.Name .. "_AA.json"

function saveSettings()
    local folderPath = a .. "/"
    local filePath = folderPath .. b

    if not isfolder(folderPath) then makefolder(folderPath) end
    if not isfolder("Luckyware/Macros") then makefolder("Luckyware/Macros") end

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

function Infinite_Range(v)
    local success, error = pcall(function()
        local Units = OptionsX.Unit.Value
        s = v
        while s do
            if TogglesX.Player.Value then
                MoveUnitsToPlayer(Units)
            else
                MoveNonPlayerUnitsToTarget(Units)
            end
            task.wait()
        end
    end)
    if not success then
        Library:Notify(error)
        TogglesX.Inf_Toggle:SetValue(false)
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

function AFK()
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

AFK()

function use_active_attack(v)
    ReplicatedStorage.endpoints.client_to_server.use_active_attack:InvokeServer(v)
end

function Auto_Orwin(v)
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

function Place(v)
    s = v 
    while s and not x._MAP_CONFIG.IsLobby.Value do
        local services = require(game.ReplicatedStorage.src.Loader)
        local placement_service = services.load_client_service(script, "PlacementServiceClient")
        placement_service.can_place = true
        task.wait()
    end
    task.wait()
end

function Lag(v)
    s = v
    while s do
        task.wait(OptionsX.Delay.Value);
        NetworkClient:SetOutgoingKBPSLimit(math.huge);
        local function getmaxvalue(val)
            local mainvalueifonetable = OptionsX.Impact.Value;
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
                game.RobloxReplicatedStorage.SetPlayerBlockList:FireServer(maintable);
            end
        end
        lag(OptionsX.Threads.Value, OptionsX.Loops.Value);
    end
end

function Ping_Cap(v)
    s = v
    while s do
        if math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) >= OptionsX.Cap.Value and TogglesX.Lag_Toggle.Value then
            TogglesX.Lag_Toggle:SetValue(false)
            task.wait(3.5)
            TogglesX.Lag_Toggle:SetValue(true)
        end
       task.wait()
    end
end

function Auto_Load()
    pcall(function()
        if Executor == "Synapse X" then
            syn.queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/DistributionError/Luckyware/main/Loader'))()");
        elseif Executor ~= "Synapse X" then
            queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/DistributionError/Luckyware/main/Loader'))()");
        end;
    end);
end;

local Window = Library:CreateWindow({
    Title = 'Luckyware | ' .. Executor .. " | .gg/wmrgSURuCk",
    Center = true,
    AutoShow = true,
    TabPadding = 1,
    MenuFadeTime = 0.2
})

local Tabs = {
    Main = Window:AddTab('Main'),
    Visuals = Window:AddTab('Visuals'),
    Macro = Window:AddTab('Macro'),
    Settings = Window:AddTab('Settings')
}

local Boxes = {
    Main = {
        Left = Tabs.Main:AddLeftGroupbox('Lag Switch'),
        Right = Tabs.Main:AddRightGroupbox('Misc'),
        LeftTwo = Tabs.Main:AddLeftGroupbox('Infinite Range')
    },
    Macro = {
        Left = Tabs.Macro:AddLeftGroupbox('Left'),
        Right = Tabs.Macro:AddRightGroupbox('Right')
    },
    Settings = {
        Left = Tabs.Settings:AddLeftGroupbox('Settings')
    },
    Visuals = {
        Left = Tabs.Visuals:AddLeftGroupbox('Visuals')
    }
}

--#region Settings
Boxes.Settings.Left:AddButton('Unload', function() Library:Unload() end)
Boxes.Settings.Left:AddLabel('Bind'):AddKeyPicker('MenuKeybind', {
    Default = tostring(Settings.MenuKeybind),
    Mode = 'Toggle',
    NoUI = true,
})
Boxes.Settings.Left:AddLabel('.gg/wmrgSURuCk')
--#endregion

--#region
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
    math.floor(FPS),
    math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()),
    math.floor(Stats.Network.ServerStatsItem["Send kBps"]:GetValue())
))
end)
--#endregion

-- Main Left Panel
Boxes.Main.Left:AddSlider('Impact',{
    Text = "Impact",
    Default = Settings.Lag.Impact,
    Min = 0,
    Max = 1000000,
    Rounding = 0,
    Compact = true
})
Boxes.Main.Left:AddSlider('Delay',{
    Text = "Delay",
    Default = Settings.Lag.Delay,
    Min = 0,
    Max = 5,
    Rounding = 1,
    Compact = true
})
Boxes.Main.Left:AddSlider('Loops',{
    Text = "Loops",
    Default = Settings.Lag.Loops,
    Min = 0,
    Max = 5,
    Rounding = 0,
    Compact = true
})
Boxes.Main.Left:AddSlider('Threads',{
    Text = "Threads",
    Default = Settings.Lag.Threads,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Compact = true
})
Boxes.Main.Left:AddSlider('Ping',{
    Text = "Ping Cap",
    Default = Settings.Lag["Ping Cap"].Cap,
    Min = 1,
    Max = 1000,
    Rounding = 0,
    Compact = true
})
Boxes.Main.Left:AddToggle('Cap', {
    Text = "Cap",
    Default = false
})
Boxes.Main.Left:AddToggle('Lag_Toggle', {
    Text = "Enable",
    Default = false
}):AddKeyPicker("Lag", {
    Default = Settings.Lag["Keybind"],
    Text = "Lag Keybind",
    Callback = function(bool)
        if bool and not TogglesX.Lag_Toggle.Value then
            TogglesX.Lag_Toggle:SetValue(true);
        elseif not bool and TogglesX.Lag_Toggle.Value then
            TogglesX.Lag_Toggle:SetValue(false);
        end;
    end
})
--#endregion

--#region Infinite Range

Boxes.Main.LeftTwo:AddDropdown("Unit", {
    Values = Fetch_Units(),
    Default = 0,
    Multi = true,
    Text = "Unit(s):",
    Tooltip = false
})
Boxes.Main.LeftTwo:AddToggle('Player', {
    Text = "Follow Player",
    Default = Settings.Infinite_Range.Player
})
Boxes.Main.LeftTwo:AddToggle('Inf_Toggle', {
    Text = "Enable",
    Default = false
}):AddKeyPicker("Infinite", {
    Default = Settings.Infinite_Range.Keybind,
    Text = "Infinite Keybind",
    Callback = function(bool)
        if bool and not TogglesX.Inf_Toggle.Value then
            TogglesX.Inf_Toggle:SetValue(true);
        elseif not bool and TogglesX.Inf_Toggle.Value then
            TogglesX.Inf_Toggle:SetValue(false);
        end;
    end
})

--#endregion

-- Main Right Panel

Boxes.Main.Right:AddToggle('Leave', {
    Text = "Auto Leave",
    Default = Settings.Auto.Leave
})
Boxes.Main.Right:AddToggle('Replay', {
    Text = "Auto Replay",
    Default = Settings.Auto.Replay
})
Boxes.Main.Right:AddToggle('Room', {
    Text = "Auto Next Room",
    Default = Settings.Auto["Next Room"]
})
Boxes.Main.Right:AddToggle('Story', {
    Text = "Auto Next Story",
    Default = Settings.Auto["Next Story"]
})
Boxes.Main.Right:AddDivider()
Boxes.Main.Right:AddLabel('Abilities')
Boxes.Main.Right:AddToggle('Orwin', {
    Text = "Auto Orwin",
    Default = Settings.Auto.Abilites.Orwin
})
Boxes.Main.Right:AddToggle('Wenda', {
    Text = "Auto Wenda",
    Default = Settings.Auto.Abilites.Wenda
})
Boxes.Main.Right:AddToggle('Leafy', {
    Text = "Auto Leafy",
    Default = Settings.Auto.Abilites.Leafy
})
Boxes.Main.Right:AddToggle('Homuru', {
    Text = "Auto Homuru",
    Default = Settings.Auto.Abilites.Homuru
})
Boxes.Main.Right:AddDivider()
Boxes.Main.Right:AddLabel('Other')
Boxes.Main.Right:AddToggle('Place', {
    Text = "Place Anywhere",
    Default = false,
})
--

--#region
Boxes.Visuals.Left:AddToggle('Overhead', {
    Text = "Hide Overhead",
    Default = Settings.Visuals.Overhead
})
Boxes.Visuals.Left:AddToggle('Map', {
    Text = "Auto Delete Map",
    Default = Settings.Visuals.Map
})

--#endregion

--#region   Macro

Boxes.Macro.Left:AddInput('Name', {
    Numeric = false,
    Text = "Name:",
})
Boxes.Macro.Left:AddDropdown('Macros', {
    Values = {"Macro.json"},
    Default = 1,
    Text = "Macro:"
})

Boxes.Macro.Left:AddButton('Create', function() writefile("Luckyware/Macros/" .. OptionsX.Name.Value .. ".json") Library:Notify("Created:" .. OptionsX.Name.Value .. ".json") end)
Boxes.Macro.Left:AddButton('Delete', function() end)
Boxes.Macro.Left:AddDivider()
Boxes.Macro.Left:AddToggle('Play', {
    Text = "Play",
    Default = false,
    Callback = function(value) 
    end
})
Boxes.Macro.Left:AddToggle('Record', {
    Text = "Record",
    Default = false,
    Callback = function(value) 
    end
})
Boxes.Macro.Left:AddDivider()
Boxes.Macro.Left:AddLabel('Macro: ' .. "Macro.json")
Boxes.Macro.Left:AddLabel('Status: ' .. "Playing/Recording", true)
Boxes.Macro.Left:AddLabel('Step: ' .. "Spawning Shiny Dio")

--#endregion

Library.ToggleKeybind = OptionsX.MenuKeybind
Library:OnUnload(function() Library.Unloaded = true end)


 --#region
OptionsX.MenuKeybind:OnChanged(function()
    Settings.MenuKeybind = OptionsX.MenuKeybind.Value
    saveSettings()
end)
OptionsX.Impact:OnChanged(function() Settings.Lag.Impact = tonumber(OptionsX.Impact.Value) saveSettings() end)
OptionsX.Delay:OnChanged(function() Settings.Lag.Delay = tonumber(OptionsX.Delay.Value) saveSettings() end)
OptionsX.Loops:OnChanged(function() Settings.Lag.Loops = tonumber(OptionsX.Loops.Value) saveSettings() end)
OptionsX.Threads:OnChanged(function() Settings.Lag.Threads = tonumber(OptionsX.Threads.Value) saveSettings() end)
OptionsX.Ping:OnChanged(function() Settings.Lag["Ping Cap"].Cap = tonumber(OptionsX.Ping.Value) saveSettings() end)
OptionsX.Infinite:OnChanged(function() Settings.Infinite_Range.Keybind = OptionsX.Infinite.Value saveSettings() end)
OptionsX.Lag:OnChanged(function() Settings.Lag.Keybind = OptionsX.Lag.Value saveSettings()end)

TogglesX.Lag_Toggle:OnChanged(function(v)
    if v then Lag(true) else Lag(false) end 
end)

TogglesX.Overhead:OnChanged(function(v)
    Settings.Visuals.Overhead = v
    saveSettings()
    local Overhead = game.Players.LocalPlayer.Character.Head:FindFirstChild('_overhead')
    if Overhead then
        Overhead.Enabled = not v
    else
    end
end)

TogglesX.Map:OnChanged(function(v)
    Settings.Visuals.Map = v
    saveSettings()
    if v and x._map then 
        x._map:Destroy()
     end
end)

TogglesX.Leave:OnChanged(function(v)
    Settings.Auto.Leave = v
    saveSettings()
end)
TogglesX.Inf_Toggle:OnChanged(function(v)
    if v then Infinite_Range(true) else Infinite_Range(false) end    
end)
TogglesX.Leave:OnChanged(function(v)
    Settings.Auto.Leave = v
    saveSettings()
end)
TogglesX.Replay:OnChanged(function(v)
    Settings.Auto.Replay = v
    saveSettings()
end)

TogglesX.Room:OnChanged(function(v)
    Settings.Auto["Next Room"] = v
    saveSettings()
end)
TogglesX.Story:OnChanged(function(v)
    Settings.Auto["Next Story"] = v
    saveSettings()
end)

TogglesX.Orwin:OnChanged(function(v)
    Settings.Auto.Abilites.Orwin = v
    saveSettings()
    if v then Auto_Orwin(true) else Auto_Orwin(false) end
end)

TogglesX.Wenda:OnChanged(function(v)
    Settings.Auto.Abilites.Wenda = v
    saveSettings()
    if v then Auto_Wenda(true) else Auto_Wenda(false) end
end)

TogglesX.Leafy:OnChanged(function(v)
    Settings.Auto.Abilites.Leafy = v
    saveSettings()
    if v then Auto_Leafy(true) else Auto_Leafy(false) end
end)

TogglesX.Homuru:OnChanged(function(v)
    Settings.Auto.Abilites.Homuru = v
    saveSettings()
    if v then Auto_Homuru(true) else Auto_Homuru(false) end
end)

--#endregion

-- Auto_Load()

Library:Notify('[Luckyware] Loaded Successfully')
Library:Notify('Discord.gg/wmrgSURuCk')
print('[Luckyware] Loaded Successfully')

while task.wait(5) do 
    if x._MAP_CONFIG.IsLobby.Value then
         break
         elseif not x._MAP_CONFIG.IsLobby.Value then 
            task.spawn(function()
                local GameFinished = game:GetService("Workspace"):WaitForChild("_DATA"):WaitForChild("GameFinished")
                GameFinished:GetPropertyChangedSignal("Value"):Connect(function() 
                    if GameFinished.Value then 
                        repeat task.wait() until Players.LocalPlayer.PlayerGui.ResultsUI.Enabled
                        if Settings.Auto.Replay then
                            ReplicatedStorage.endpoints.client_to_server.set_game_finished_vote:InvokeServer("replay")
                            elseif Settings.Auto["Next Room"]then
                                ReplicatedStorage.endpoints.client_to_server.set_game_finished_vote:InvokeServer("NextRetry")
                            elseif Settings.Auto["Next Story"]then
                                ReplicatedStorage.endpoints.client_to_server.set_game_finished_vote:InvokeServer("next_story")
                            elseif Settings.Auto.Leave and not Settings.Auto.Replay and not Settings.Auto["Next Room"]then
                                TeleportService:Teleport(8304191830, LocalPlayer)
                         end
                    end
                end)
            end)
     end
end
