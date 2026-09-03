--[[
    ShiBuHub v2.3.3 COMPILE FIX
    Immediate loading screen -> protected compile/run -> menu.
    If initialization fails, the loading panel shows the exact error instead of silently disappearing.
]]

local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local TweenService=game:GetService("TweenService")
local CoreGui=game:GetService("CoreGui")

local LP=Players.LocalPlayer
local env=getgenv and getgenv() or _G
env.ShiBuHubReady=false

local parent
pcall(function()
    if gethui then parent=gethui() end
end)
parent=parent or LP:WaitForChild("PlayerGui")

local old=parent:FindFirstChild("ShiBuHubLoading")
if old then pcall(function() old:Destroy() end) end

local Loading=Instance.new("ScreenGui")
Loading.Name="ShiBuHubLoading"
Loading.ResetOnSpawn=false
Loading.IgnoreGuiInset=true
Loading.DisplayOrder=2147483000
Loading.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
Loading.Parent=parent

local dim=Instance.new("Frame")
dim.Size=UDim2.fromScale(1,1)
dim.BackgroundColor3=Color3.fromRGB(2,7,12)
dim.BackgroundTransparency=.18
dim.BorderSizePixel=0
dim.ZIndex=5000
dim.Parent=Loading

local card=Instance.new("Frame")
card.AnchorPoint=Vector2.new(.5,.5)
card.Position=UDim2.fromScale(.5,.5)
card.Size=UDim2.new(.76,0,0,210)
card.BackgroundColor3=Color3.fromRGB(6,18,27)
card.BorderSizePixel=0
card.ZIndex=5001
card.Parent=dim
Instance.new("UICorner",card).CornerRadius=UDim.new(0,18)
local st=Instance.new("UIStroke",card)
st.Color=Color3.fromRGB(55,238,232)
st.Thickness=1.5
st.Transparency=.15

local title=Instance.new("TextLabel")
title.BackgroundTransparency=1
title.Position=UDim2.fromOffset(22,18)
title.Size=UDim2.new(1,-44,0,34)
title.Font=Enum.Font.GothamBold
title.TextSize=25
title.TextColor3=Color3.fromRGB(93,255,241)
title.TextXAlignment=Enum.TextXAlignment.Left
title.Text="ShiBuHub"
title.ZIndex=5002
title.Parent=card

local version=Instance.new("TextLabel")
version.BackgroundTransparency=1
version.Position=UDim2.fromOffset(24,52)
version.Size=UDim2.new(1,-48,0,22)
version.Font=Enum.Font.Gotham
version.TextSize=12
version.TextColor3=Color3.fromRGB(142,176,192)
version.TextXAlignment=Enum.TextXAlignment.Left
version.Text="v2.3.3 • Monster Auto Feed"
version.ZIndex=5002
version.Parent=card

local status=Instance.new("TextLabel")
status.BackgroundTransparency=1
status.Position=UDim2.fromOffset(24,86)
status.Size=UDim2.new(1,-48,0,28)
status.Font=Enum.Font.GothamMedium
status.TextSize=14
status.TextColor3=Color3.fromRGB(231,245,250)
status.TextXAlignment=Enum.TextXAlignment.Left
status.Text="Đang khởi tạo..."
status.ZIndex=5002
status.Parent=card

local pct=Instance.new("TextLabel")
pct.BackgroundTransparency=1
pct.AnchorPoint=Vector2.new(1,0)
pct.Position=UDim2.new(1,-24,0,86)
pct.Size=UDim2.fromOffset(70,28)
pct.Font=Enum.Font.GothamBold
pct.TextSize=14
pct.TextColor3=Color3.fromRGB(93,255,241)
pct.TextXAlignment=Enum.TextXAlignment.Right
pct.Text="0%"
pct.ZIndex=5002
pct.Parent=card

local track=Instance.new("Frame")
track.Position=UDim2.fromOffset(24,126)
track.Size=UDim2.new(1,-48,0,12)
track.BackgroundColor3=Color3.fromRGB(15,38,49)
track.BorderSizePixel=0
track.ZIndex=5002
track.Parent=card
Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)

local fill=Instance.new("Frame")
fill.Size=UDim2.new(0,0,1,0)
fill.BackgroundColor3=Color3.fromRGB(53,235,230)
fill.BorderSizePixel=0
fill.ZIndex=5003
fill.Parent=track
Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)

local detail=Instance.new("TextLabel")
detail.BackgroundTransparency=1
detail.Position=UDim2.fromOffset(24,150)
detail.Size=UDim2.new(1,-48,0,36)
detail.Font=Enum.Font.Gotham
detail.TextSize=11
detail.TextColor3=Color3.fromRGB(121,154,171)
detail.TextXAlignment=Enum.TextXAlignment.Left
detail.TextYAlignment=Enum.TextYAlignment.Top
detail.TextWrapped=true
detail.Text="Chuẩn bị giao diện và các module..."
detail.ZIndex=5002
detail.Parent=card

local function progress(n,msg,sub)
    n=math.clamp(math.floor(n),0,100)
    pct.Text=tostring(n).."%"
    if msg then status.Text=msg end
    if sub then detail.Text=sub end
    TweenService:Create(fill,TweenInfo.new(.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{
        Size=UDim2.new(n/100,0,1,0)
    }):Play()
end

-- Give Roblox one frame to render the loader before heavy script initialization.
progress(5,"Đang mở ShiBuHub...","Loading screen đã sẵn sàng.")
RunService.RenderStepped:Wait()
task.wait(.03)

local SOURCE = [======[
--[[
    ShiBuHub v2.3.3 • TREADMILL + MONSTER AUTO FEED
    Steal An Egg • Delta X Mobile
    - Embedded ShiBuHub logo
    - Cyan/teal cloud-tech UI
    - Real EggWorld snapshot/carry engine
    - Hungry Monster status page

    NOTE: Hungry Monster AskFeed() with no arguments has been confirmed by runtime test.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local G = _G
G.ShiBuHubRunId = tostring(os.clock()) .. tostring(math.random(1000,9999))
local RUN_ID = G.ShiBuHubRunId

--====================================================
-- BRAND ASSET - embedded logo
--====================================================

local LOGO_B64 = [[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]]
local LOGO_FILE = "ShiBuHub_logo.jpg"

local function b64decode(data)
    local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = data:gsub('[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if x == '=' then return '' end
        local r,f='',(b:find(x,1,true)-1)
        for i=6,1,-1 do
            r = r .. (f % 2^i - f % 2^(i-1) > 0 and '1' or '0')
        end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if #x ~= 8 then return '' end
        local c=0
        for i=1,8 do
            c = c + (x:sub(i,i)=='1' and 2^(8-i) or 0)
        end
        return string.char(c)
    end))
end

local function getLogoAsset()
    local custom = getcustomasset or getsynasset
    if not custom or not writefile then return nil end
    pcall(function()
        if not isfile or not isfile(LOGO_FILE) then
            writefile(LOGO_FILE, b64decode(LOGO_B64))
        end
    end)
    local ok, asset = pcall(custom, LOGO_FILE)
    if ok then return asset end
    return nil
end

local LOGO_ASSET = nil

--====================================================
-- THEME
--====================================================

local C = {
    BG = Color3.fromRGB(5, 12, 20),
    PANEL = Color3.fromRGB(7, 20, 31),
    PANEL2 = Color3.fromRGB(9, 28, 42),
    CARD = Color3.fromRGB(10, 34, 48),
    CARD2 = Color3.fromRGB(12, 43, 57),
    CYAN = Color3.fromRGB(52, 236, 239),
    CYAN2 = Color3.fromRGB(0, 184, 230),
    TEAL = Color3.fromRGB(66, 255, 221),
    WHITE = Color3.fromRGB(240, 248, 255),
    MUTED = Color3.fromRGB(142, 172, 190),
    GREEN = Color3.fromRGB(88, 255, 169),
    RED = Color3.fromRGB(255, 102, 129),
    GOLD = Color3.fromRGB(255, 208, 77),
    PURPLE = Color3.fromRGB(184, 108, 255),
}

local function corner(obj, r)
    local x = Instance.new("UICorner")
    x.CornerRadius = UDim.new(0, r or 10)
    x.Parent = obj
end

local function stroke(obj, color, thickness, transparency)
    local x = Instance.new("UIStroke")
    x.Color = color or C.CYAN2
    x.Thickness = thickness or 1
    x.Transparency = transparency or 0.25
    x.Parent = obj
    return x
end

local function textLabel(parent, text, size, bold)
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Text = text or ""
    t.TextColor3 = C.WHITE
    t.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    t.TextSize = size or 14
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextYAlignment = Enum.TextYAlignment.Center
    t.Parent = parent
    return t
end

local function button(parent, text)
    local b = Instance.new("TextButton")
    b.AutoButtonColor = false
    b.BackgroundColor3 = C.CARD
    b.Text = text or ""
    b.TextColor3 = C.WHITE
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.Parent = parent
    corner(b, 11)
    stroke(b, C.CYAN2, 1, .55)
    return b
end

--====================================================
-- GUI ROOT
--====================================================

local guiParent = LocalPlayer:WaitForChild("PlayerGui")
do
    local old = guiParent:FindFirstChild("ShiBuHub")
    if old then pcall(function() old:Destroy() end) end
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "ShiBuHub"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = false
Gui.DisplayOrder = 999999
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = guiParent

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(.86, 0, .74, 0)
Main.Position = UDim2.new(.07, 0, .13, 0)
Main.BackgroundColor3 = C.BG
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = Gui
corner(Main, 18)
stroke(Main, C.CYAN, 2, .12)

local topGlow = Instance.new("Frame")
topGlow.Size = UDim2.new(1,0,0,3)
topGlow.BackgroundColor3 = C.CYAN
topGlow.BorderSizePixel = 0
topGlow.Parent = Main

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,74)
Header.BackgroundColor3 = Color3.fromRGB(5,18,29)
Header.BorderSizePixel = 0
Header.Parent = Main

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.fromOffset(58,58)
logo.Position = UDim2.fromOffset(12,8)
logo.BackgroundColor3 = C.PANEL2
logo.BorderSizePixel = 0
logo.Image = LOGO_ASSET or ""
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = Header
corner(logo, 13)
stroke(logo, C.CYAN, 1.5, .12)

if not LOGO_ASSET then
    local fallback = textLabel(logo, "S", 28, true)
    fallback.Size = UDim2.fromScale(1,1)
    fallback.TextXAlignment = Enum.TextXAlignment.Center
end

local brand = textLabel(Header, "ShiBuHub", 27, true)
brand.Position = UDim2.fromOffset(82,10)
brand.Size = UDim2.new(0,260,0,34)
brand.TextColor3 = C.WHITE

local sub = textLabel(Header, "Steal An Egg  •  Delta X Android", 12, false)
sub.Position = UDim2.fromOffset(84,42)
sub.Size = UDim2.new(0,360,0,20)
sub.TextColor3 = C.MUTED

local minimizeBtn = button(Header, "—")
minimizeBtn.Size = UDim2.fromOffset(42,36)
minimizeBtn.Position = UDim2.new(1,-96,0,18)
minimizeBtn.TextSize = 19

local closeBtn = button(Header, "X")
closeBtn.Size = UDim2.fromOffset(42,36)
closeBtn.Position = UDim2.new(1,-48,0,18)
closeBtn.BackgroundColor3 = Color3.fromRGB(54,26,38)
stroke(closeBtn, C.RED, 1, .45)

-- Sidebar
local Side = Instance.new("Frame")
Side.Size = UDim2.new(0,154,1,-86)
Side.Position = UDim2.fromOffset(10,78)
Side.BackgroundColor3 = C.PANEL
Side.BorderSizePixel = 0
Side.Parent = Main
corner(Side, 13)
stroke(Side, C.CYAN2, 1, .72)

local miniLogo = Instance.new("ImageLabel")
miniLogo.Size = UDim2.fromOffset(70,70)
miniLogo.Position = UDim2.new(.5,-35,0,10)
miniLogo.BackgroundTransparency = 1
miniLogo.Image = LOGO_ASSET or ""
miniLogo.ScaleType = Enum.ScaleType.Fit
miniLogo.Parent = Side

local Nav = Instance.new("Frame")
Nav.BackgroundTransparency = 1
Nav.Position = UDim2.fromOffset(9,90)
Nav.Size = UDim2.new(1,-18,1,-100)
Nav.Parent = Side

local navLayout = Instance.new("UIListLayout")
navLayout.Padding = UDim.new(0,7)
navLayout.SortOrder = Enum.SortOrder.LayoutOrder
navLayout.Parent = Nav

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,-184,1,-86)
Content.Position = UDim2.fromOffset(174,78)
Content.BackgroundColor3 = C.PANEL
Content.BorderSizePixel = 0
Content.Parent = Main
corner(Content, 13)
stroke(Content, C.CYAN2, 1, .72)

-- Floating logo button
local Bubble = Instance.new("ImageButton")
Bubble.Size = UDim2.fromOffset(62,62)
Bubble.Position = UDim2.new(0,14,.52,0)
Bubble.BackgroundColor3 = C.PANEL2
Bubble.BorderSizePixel = 0
Bubble.Image = LOGO_ASSET or ""
Bubble.ScaleType = Enum.ScaleType.Fit
Bubble.Visible = false
Bubble.Parent = Gui
corner(Bubble, 31)
stroke(Bubble, C.CYAN, 2, .05)
if not LOGO_ASSET then Bubble.Image="" end

-- Passive boot: embedded logo asset I/O is deferred/disabled on startup.
-- The menu still works without writing files or registering a custom asset.

--====================================================
-- PAGES / NAV
--====================================================

local pages = {}
local navButtons = {}
local currentPage

local function makePage(name)
    local p = Instance.new("ScrollingFrame")
    p.Name = name
    p.Size = UDim2.fromScale(1,1)
    p.BackgroundTransparency = 1
    p.BorderSizePixel = 0
    p.ScrollBarThickness = 4
    p.ScrollBarImageColor3 = C.CYAN2
    p.CanvasSize = UDim2.new(0,0,0,0)
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    p.Visible = false
    p.Parent = Content
    pages[name] = p
    return p
end

local function setPage(name)
    for n,p in pairs(pages) do p.Visible = (n==name) end
    for n,b in pairs(navButtons) do
        local on = (n==name)
        b.BackgroundColor3 = on and Color3.fromRGB(8,77,101) or C.CARD
        local s = b:FindFirstChildOfClass("UIStroke")
        if s then s.Color = on and C.CYAN or C.CYAN2; s.Transparency = on and .1 or .7 end
    end
    currentPage = name
end

local function nav(name, icon)
    local b = button(Nav, (icon or "") .. "  " .. name)
    b.Name = name
    b.Size = UDim2.new(1,0,0,44)
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.Text = "   " .. (icon or "") .. "  " .. name
    b.MouseButton1Click:Connect(function() setPage(name) end)
    navButtons[name] = b
    return b
end

nav("HOME", "⌂")
nav("EGGS", "◉")
nav("PROGRESSION", "↑")
nav("EVENT", "✦")
nav("SELL", "$")
nav("WEBHOOK", "⌁")
nav("SETTINGS", "⚙")

local Home = makePage("HOME")
local Eggs = makePage("EGGS")
local Progression = makePage("PROGRESSION")
local Event = makePage("EVENT")
local Sell = makePage("SELL")
local Webhook = makePage("WEBHOOK")
local Settings = makePage("SETTINGS")

local function pageHeader(page, titleText, subtitleText)
    local h = textLabel(page, titleText, 21, true)
    h.Position = UDim2.fromOffset(18,12)
    h.Size = UDim2.new(1,-36,0,30)
    h.TextColor3 = C.CYAN
    local s = textLabel(page, subtitleText or "", 12, false)
    s.Position = UDim2.fromOffset(18,42)
    s.Size = UDim2.new(1,-36,0,22)
    s.TextColor3 = C.MUTED
end

local function card(parent, y, h)
    local f = Instance.new("Frame")
    f.Position = UDim2.fromOffset(16,y)
    f.Size = UDim2.new(1,-32,0,h)
    f.BackgroundColor3 = C.CARD
    f.BorderSizePixel = 0
    f.Parent = parent
    corner(f, 12)
    stroke(f, C.CYAN2, 1, .55)
    return f
end

local function toggleRow(parent, y, titleText, subtitleText, initial, callback)
    local f = card(parent,y,68)
    local t = textLabel(f,titleText,15,true)
    t.Position = UDim2.fromOffset(16,9)
    t.Size = UDim2.new(1,-100,0,24)
    local s = textLabel(f,subtitleText or "",11,false)
    s.Position = UDim2.fromOffset(16,35)
    s.Size = UDim2.new(1,-100,0,20)
    s.TextColor3 = C.MUTED
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(54,30)
    b.Position = UDim2.new(1,-68,.5,-15)
    b.AutoButtonColor = false
    b.Text = ""
    b.BorderSizePixel = 0
    b.Parent = f
    corner(b,15)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(24,24)
    knob.Position = UDim2.fromOffset(3,3)
    knob.BackgroundColor3 = C.WHITE
    knob.BorderSizePixel = 0
    knob.Parent = b
    corner(knob,12)
    local state = initial and true or false
    local function paint()
        b.BackgroundColor3 = state and C.TEAL or Color3.fromRGB(50,65,74)
        knob.Position = state and UDim2.fromOffset(27,3) or UDim2.fromOffset(3,3)
    end
    paint()
    b.MouseButton1Click:Connect(function()
        state = not state
        paint()
        if callback then callback(state) end
    end)
    return f, function(v) state=v; paint() end, function() return state end
end

--====================================================
-- STATE / NETWORK
--====================================================

local Config = {
    AutoSteal = false,
    PersistentSteal = false,
    PreventTraps = false,
    AutoReturnBase = false,
    FastStepSpeed = 0,
    FastStepStopDistance = 5.5,
    EvasiveRun = false,
    AvoidNPCDistance = 26,
    AvoidNPCStrength = 18,
    AntiAFK = false,
    FPSBoost = false,
    AutoRejoin = false,
    EggESP = false,
    AutoHatch = false,
    AutoCollectAway = false,
    AutoWearBest = false,
    AutoRedeemCodex = false,
    AutoTreadmill = false,
    AutoUpgradeTreadmill = false,
    AutoSellSatchel = false,
    PriorityHungryMonster = false,
    AutoFeedMonster = false,
    AutoClaimMonsterChests = false,
    EventReturnBase = false,
    EventFeedTargets = {
        Common=true,
        Uncommon=true,
        Rare=true,
        Epic=true,
        Legendary=true,
        Mythic=false,
        Cosmic=false,
        Secret=false,
        Divine=false,
        Eternal=false,
    },
    ProtectSelectedRarities = false,
    WebhookEnabled = false,
    WebhookUrl = "",
    NotifyTargetFound = false,
    NotifyTargetPicked = true,
    Targets = {
        Common=false,
        Uncommon=false,
        Rare=false,
        Epic=false,
        Legendary=false,
        Mythic=false,
        Cosmic=false,
        Secret=true,
        Divine=true,
        Eternal=true,
    },
}

local Rank = {
    Common=1, Uncommon=2, Rare=3, Epic=4, Legendary=5,
    Mythic=6, Cosmic=7, Secret=8, Eternal=9, Divine=10
}

local RarityOrder = {
    "Divine","Eternal","Secret","Cosmic","Mythic",
    "Legendary","Epic","Rare","Uncommon","Common"
}

local function selectedRarities()
    local out={}
    for _,name in ipairs(RarityOrder) do
        if Config.Targets[name] then table.insert(out,name) end
    end
    return out
end

local function targetSummary()
    local t=selectedRarities()
    if #t==0 then return "None selected" end
    return table.concat(t," > ")
end


local function selectedEventFeedRarities()
    local out={}
    for _,name in ipairs(RarityOrder) do
        if Config.EventFeedTargets and Config.EventFeedTargets[name] then
            table.insert(out,name)
        end
    end
    return out
end

local function eventFeedSummary()
    local t=selectedEventFeedRarities()
    if #t==0 then return "None selected" end
    return table.concat(t," > ")
end

local Network
pcall(function()
    Network = ReplicatedStorage:WaitForChild("Packages",8):WaitForChild("Networking",8)
end)
local function N(name) return Network and Network:FindFirstChild(name) end

local RF_EggSnapshot = N("RF/EggWorld/AskFieldEggSnapshot")
local RF_EggCarry = N("RF/EggWorld/AskFieldEggCarry")
local RF_Doff = N("RF/EggWorld/AskDoffTool")
local RF_MonsterSnapshot = N("RF/MonsterParasite/AskSnapshot")
local RF_MonsterFeed = N("RF/MonsterParasite/AskFeed")
local RF_MonsterChestTake = N("RF/MonsterParasite/AskChestTake")
local RF_MonsterChestReveal = N("RF/MonsterParasite/AskChestRevealComplete")
local RF_MonsterChestClaim = N("RF/MonsterParasite/AskChestClaim")
local RF_SatchelSale = N("RF/Haul/OfferFullSatchelSale")
local RF_EggLive = N("RF/EggWorld/AskLiveSnapshot")
local RF_Hatch = N("RF/EggWorld/AskHatch")
local RF_HatchFinish = N("RF/EggWorld/AskFinishHatch")
local RF_SkipGrowth = N("RF/EggWorld/AskSkipGrowth")
local RF_AwayCollect = N("RF/AwayEarnings/AskCollect")
local RF_AwayPending = N("RF/AwayEarnings/PendingCheck")
local RF_CodexAll = N("RF/Codex/AskRedeemAll")
local RF_WearBest = N("RF/Haul/WearBest")
local RF_PlotState = N("RF/Homestead/AskState")
local RF_TreadRaise = N("RF/Treadmill/AskTierRaise")
local RF_TreadRender = N("RF/Treadmill/AskRenderSnapshot")
local RE_SellEveryPet = N("RE/PetSatchel/SellEveryPet")

local Assets
pcall(function()
    Assets = require(ReplicatedStorage:WaitForChild("Data"):WaitForChild("Assets"))
end)

local TreadmillsData
pcall(function()
    TreadmillsData = require(ReplicatedStorage:WaitForChild("Data"):WaitForChild("Treadmills"))
end)

local SaveModule
pcall(function()
    local shared=ReplicatedStorage:FindFirstChild("Shared")
    local mod=shared and shared:FindFirstChild("Save")
    if mod then SaveModule=require(mod) end
end)


local function invokeRemote(remote, ...)
    if not remote then return false,"remote-not-found" end
    local args={...}
    local ok,res=pcall(function()
        if remote:IsA("RemoteFunction") then
            return remote:InvokeServer(table.unpack(args))
        end
        remote:FireServer(table.unpack(args))
        return true
    end)
    return ok,res
end

local uidShape={}
local function invokeUid(remote, uid)
    if not remote then return false end
    local key=remote.Name
    if uidShape[key]~=2 then
        local ok,res=invokeRemote(remote,{Uid=uid})
        if ok and res~=false then
            uidShape[key]=1
            return true
        end
    end
    local ok,res=invokeRemote(remote,uid)
    if ok and res~=false then
        uidShape[key]=2
        return true
    end
    return false
end

local requestFn =
    (syn and syn.request)
    or http_request
    or request
    or (fluxus and fluxus.request)

local function sendWebhook(title, description)
    if not Config.WebhookEnabled then return false,"disabled" end
    if type(Config.WebhookUrl)~="string" or Config.WebhookUrl=="" then
        return false,"no-url"
    end
    if not requestFn then return false,"request-api-unavailable" end

    local payload=HttpService:JSONEncode({
        username="ShiBuHub",
        embeds={{
            title=tostring(title),
            description=tostring(description),
            footer={text="ShiBuHub v2.3.3"},
            timestamp=DateTime.now():ToIsoDate(),
        }}
    })

    local ok,res=pcall(function()
        return requestFn({
            Url=Config.WebhookUrl,
            Method="POST",
            Headers={["Content-Type"]="application/json"},
            Body=payload,
        })
    end)
    return ok,res
end

local function normalizeRarity(v)
    local s = string.lower(tostring(v or ""))
    for name in pairs(Rank) do
        if s:find(string.lower(name),1,true) then return name end
    end
end

local function rarityOf(rec)
    local r = normalizeRarity(rec.Rarity) or normalizeRarity(rec.RarityName) or normalizeRarity(rec.Tier)
    if r then return r end
    local cat = rec.AssetCategory or rec.Category or rec.AssetId
    if Assets and Assets.Directory and cat and Assets.Directory[cat] then
        local rr = Assets.Directory[cat].Rarity
        if type(rr)=="table" then
            return normalizeRarity(rr.DisplayName) or normalizeRarity(rr.Name) or normalizeRarity(rr._id)
        end
        return normalizeRarity(rr)
    end
end

local function characterRoot()
    local ch = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return ch, ch:WaitForChild("HumanoidRootPart")
end

local BaseCF
local FarmBusy=false
local Scanned = 0
local CurrentTarget = "None"
local LastAction = "Ready"

local function collectRecords(tbl,out,seen,depth)
    depth=depth or 0
    if depth>8 or type(tbl)~="table" then return end
    if tbl.Uid then
        local st=tostring(tbl.State or "")
        if st=="Slot" or st=="Dropped" or st=="" then
            local uid=tostring(tbl.Uid)
            if not seen[uid] then seen[uid]=true; table.insert(out,tbl) end
        end
    end
    for _,v in pairs(tbl) do
        if type(v)=="table" then collectRecords(v,out,seen,depth+1) end
    end
end

local function readEggs()
    if not RF_EggSnapshot then return {} end
    local ok,snap = pcall(function() return RF_EggSnapshot:InvokeServer() end)
    if not ok or type(snap)~="table" then return {} end
    local out={}
    collectRecords(snap,out,{},0)
    Scanned = Scanned + #out
    return out
end

local function eggObject(uid)
    local folder=workspace:FindFirstChild("AreaEggSlotsClient")
    if not folder then return nil end
    uid=tostring(uid)

    -- Fast path: current game normally renders a child named exactly as the egg Uid.
    local obj=folder:FindFirstChild(uid,true)
    if obj then return obj end

    -- Fallback for builds where the rendered model name changes but the Uid is stored as an attribute/value.
    for _,d in ipairs(folder:GetDescendants()) do
        local okAttr,attr=pcall(function()
            return d:GetAttribute("Uid") or d:GetAttribute("UID") or d:GetAttribute("EggUid")
        end)
        if okAttr and attr~=nil and tostring(attr)==uid then
            return d:IsA("BasePart") and d or (d:FindFirstAncestorOfClass("Model") or d)
        end
        if (d:IsA("StringValue") or d:IsA("IntValue") or d:IsA("NumberValue"))
            and (d.Name=="Uid" or d.Name=="UID" or d.Name=="EggUid")
            and tostring(d.Value)==uid then
            return d:FindFirstAncestorOfClass("Model") or d.Parent
        end
    end
end

local function partFromObject(obj)
    if not obj then return nil end
    if obj:IsA("BasePart") then return obj end
    if obj:IsA("Model") then
        return obj.PrimaryPart or obj:FindFirstChild("Hitbox",true) or obj:FindFirstChildWhichIsA("BasePart",true)
    end
    return obj:FindFirstChildWhichIsA("BasePart",true)
end

local function recordCFrame(rec)
    -- Prefer server snapshot coordinates. This fixes eggs that are announced/spawned
    -- before AreaEggSlotsClient finishes rendering them on low-FPS/cloud phones.
    for _,key in ipairs({"BoundsCFrame","BottomCFrame","CFrame","WorldCFrame","SpawnCFrame"}) do
        local v=rec[key]
        if typeof(v)=="CFrame" then return v end
    end
    for _,key in ipairs({"Position","WorldPosition","Pos"}) do
        local v=rec[key]
        if typeof(v)=="Vector3" then return CFrame.new(v) end
    end

    local obj=eggObject(rec.Uid)
    local part=partFromObject(obj)
    if part then return part.CFrame,part,obj end
    return nil,nil,obj
end

local function isTrap(obj)
    if not obj then return false end
    local model=obj:FindFirstAncestorOfClass("Model") or obj
    local n=string.lower(model.Name)
    if n:find("trap",1,true) or n:find("cage",1,true) or n:find("snare",1,true) then return true end
    if model:FindFirstChild("UnplacePrompt",true) then return true end
    return false
end

local function bestEgg()
    local _,root=characterRoot()
    local list={}
    local seenWanted=0
    local unresolved=0

    for _,rec in ipairs(readEggs()) do
        local rarity=rarityOf(rec)
        if rarity and Config.Targets[rarity] then
            seenWanted += 1
            local cf,part,obj=recordCFrame(rec)
            local trapPart=part or partFromObject(obj)
            if cf and (not Config.PreventTraps or not trapPart or not isTrap(trapPart)) then
                table.insert(list,{
                    Record=rec,
                    Rarity=rarity,
                    Part=part,
                    Object=obj,
                    CFrame=cf,
                    Rank=Rank[rarity] or 0,
                    Distance=(root.Position-cf.Position).Magnitude
                })
            else
                unresolved += 1
            end
        end
    end

    table.sort(list,function(a,b)
        if a.Rank~=b.Rank then return a.Rank>b.Rank end
        return a.Distance<b.Distance
    end)

    if not list[1] and seenWanted>0 then
        LastAction="Found target rarity, waiting render/position ("..tostring(unresolved)..")"
    end
    return list[1]
end


local function monsterSnapshot()
    if not RF_MonsterSnapshot then return nil end
    local ok,s=pcall(function() return RF_MonsterSnapshot:InvokeServer() end)
    return ok and type(s)=="table" and s or nil
end

local function monsterIsActive()
    local s=monsterSnapshot()
    return s and s.Event and s.Event.Active==true or false
end

local function monsterPosition()
    local folder=workspace:FindFirstChild("MonsterParasiteMonsters")
    if not folder then return nil end

    local chosen=nil
    for _,m in ipairs(folder:GetChildren()) do
        if m:IsA("Model") then
            local owner=m:GetAttribute("OwnerUserId")
            if tonumber(owner)==tonumber(LocalPlayer.UserId) then
                chosen=m
                break
            end
            chosen=chosen or m
        end
    end

    if not chosen then return nil end

    local feedPrompt=chosen:FindFirstChild("FeedPrompt",true)
    if feedPrompt and feedPrompt.Parent then
        if feedPrompt.Parent:IsA("BasePart") then
            return feedPrompt.Parent.Position
        end
        local bp=feedPrompt.Parent:FindFirstAncestorWhichIsA("BasePart")
        if bp then return bp.Position end
    end

    if chosen.PrimaryPart then return chosen.PrimaryPart.Position end
    local part=chosen:FindFirstChildWhichIsA("BasePart",true)
    return part and part.Position or nil
end

local function eventBestEgg()
    local _,root=characterRoot()
    local list={}

    for _,rec in ipairs(readEggs()) do
        local rarity=rarityOf(rec)
        local feedOn = rarity and Config.EventFeedTargets and Config.EventFeedTargets[rarity]
        local protected = rarity and Config.ProtectSelectedRarities and Config.Targets[rarity]

        if feedOn and not protected then
            local cf,part,obj=recordCFrame(rec)
            local trapPart=part or partFromObject(obj)
            if cf and (not Config.PreventTraps or not trapPart or not isTrap(trapPart)) then
                table.insert(list,{
                    Record=rec,
                    Rarity=rarity,
                    Part=part,
                    Object=obj,
                    CFrame=cf,
                    Rank=Rank[rarity] or 0,
                    Distance=(root.Position-cf.Position).Magnitude
                })
            end
        end
    end

    table.sort(list,function(a,b)
        if a.Rank~=b.Rank then return a.Rank>b.Rank end
        return a.Distance<b.Distance
    end)
    return list[1]
end

local function fieldStillHas(uid)
    uid=tostring(uid)
    local ok,eggs=pcall(readEggs)
    if not ok then return nil end
    for _,rec in ipairs(eggs) do
        if tostring(rec.Uid)==uid then
            local st=tostring(rec.State or "")
            if st=="Slot" or st=="Dropped" or st=="" then return true end
        end
    end
    return false
end


local function findStealPrompt(target)
    -- First try the rendered egg model.
    local obj = target and target.Object
    if obj then
        for _,d in ipairs(obj:GetDescendants()) do
            if d:IsA("ProximityPrompt") then
                local info = string.lower(
                    tostring(d.Name).." "..tostring(d.ActionText).." "..tostring(d.ObjectText)
                )
                if info:find("steal",1,true) or info:find("carry",1,true) or info:find("egg",1,true) then
                    return d
                end
            end
        end
    end

    -- Current game exposes this smart prompt when standing near an egg.
    local smart = workspace:FindFirstChild("SmartPromptPart")
    if smart then
        local p = smart:FindFirstChild("CarryAreaEgg",true)
        if p and p:IsA("ProximityPrompt") then
            return p
        end
    end

    -- Last fallback: nearby prompt with Steal/Cary/Egg wording.
    local _,root = characterRoot()
    local best,bestDist
    for _,d in ipairs(workspace:GetDescendants()) do
        if d:IsA("ProximityPrompt") then
            local info=string.lower(
                tostring(d.Name).." "..tostring(d.ActionText).." "..tostring(d.ObjectText)
            )
            if info:find("steal",1,true) or info:find("carry",1,true) then
                local holder=d.Parent
                local part = holder and (
                    holder:IsA("BasePart") and holder
                    or holder:FindFirstAncestorWhichIsA("BasePart")
                )
                if part then
                    local dist=(root.Position-part.Position).Magnitude
                    if dist < 18 and (not bestDist or dist<bestDist) then
                        best,bestDist=d,dist
                    end
                end
            end
        end
    end
    return best
end

local function triggerPrompt(prompt)
    if not prompt then return false,"no-prompt" end

    if fireproximityprompt then
        local ok = pcall(function()
            fireproximityprompt(prompt)
        end)
        if ok then return true,"fireproximityprompt" end
    end

    local ok = pcall(function()
        prompt:InputHoldBegin()
        task.wait(math.max(.08, tonumber(prompt.HoldDuration) or 0))
        prompt:InputHoldEnd()
    end)
    return ok, ok and "prompt-hold" or "prompt-failed"
end


local function isPlayerCharacter(model)
    for _,p in ipairs(Players:GetPlayers()) do
        if p.Character == model then
            return true
        end
    end
    return false
end

local function hostilePartsNear(position, radius)
    local found={}
    for _,m in ipairs(workspace:GetDescendants()) do
        if m:IsA("Model") and not isPlayerCharacter(m) then
            local hum=m:FindFirstChildOfClass("Humanoid")
            local root=m:FindFirstChild("HumanoidRootPart")
                or m:FindFirstChild("RootPart")
                or m.PrimaryPart

            if hum and root and hum.Health > 0 then
                local dist=(root.Position-position).Magnitude
                if dist <= radius then
                    table.insert(found,{Model=m,Part=root,Distance=dist})
                end
            end
        end
    end
    return found
end

local function evasiveTarget(rootPos, desired)
    if not Config.EvasiveRun then
        return desired,false
    end

    local threats=hostilePartsNear(rootPos, tonumber(Config.AvoidNPCDistance) or 26)
    if #threats == 0 then
        return desired,false
    end

    local away=Vector3.zero
    for _,t in ipairs(threats) do
        local delta=rootPos-t.Part.Position
        local mag=delta.Magnitude
        if mag > 0.05 then
            local weight=1 / math.max(mag,3)
            away += delta.Unit * weight
        end
    end

    if away.Magnitude < 0.01 then
        return desired,false
    end

    local forward=(desired-rootPos)
    if forward.Magnitude > 0.05 then
        forward=forward.Unit
    else
        forward=Vector3.zero
    end

    -- Keep moving toward the egg/base, but bend the route away from NPCs.
    local steer=(forward*12) + (away.Unit*(tonumber(Config.AvoidNPCStrength) or 18))
    if steer.Magnitude < 0.05 then
        return desired,false
    end

    return rootPos + steer, true
end

local function walkToPosition(destination, stopDistance, timeout)
    local ch,root = characterRoot()
    local hum = ch:FindFirstChildOfClass("Humanoid")
    if not hum then return false,"no-humanoid" end

    stopDistance = stopDistance or Config.FastStepStopDistance or 5.5
    timeout = timeout or 30

    local originalSpeed = hum.WalkSpeed

    -- Feature-parity build keeps the speed supplied by the game/server.
    -- It does not set HumanoidRootPart.CFrame and does not override WalkSpeed.
    local function finish(ok,why)
        return ok,why
    end

    local function closeEnough()
        return (root.Position-destination).Magnitude <= stopDistance
    end

    if closeEnough() then
        return finish(true,"already-there")
    end

    local started=os.clock()
    local repathAt=0
    local waypoints={}
    local wpIndex=1

    local function rebuildPath()
        local path
        local ok=pcall(function()
            path=PathfindingService:CreatePath({
                AgentRadius=2,
                AgentHeight=5,
                AgentCanJump=true,
                WaypointSpacing=4,
            })
            path:ComputeAsync(root.Position,destination)
        end)

        if ok and path and path.Status==Enum.PathStatus.Success then
            waypoints=path:GetWaypoints()
            wpIndex=1
            return true
        end

        waypoints={}
        wpIndex=1
        return false
    end

    rebuildPath()

    while Config.AutoSteal and os.clock()-started < timeout do
        if closeEnough() then
            return finish(true,"fast-step")
        end

        -- Rebuild path every ~1.2 sec so moving/streamed targets stay fresh.
        if os.clock() >= repathAt then
            rebuildPath()
            repathAt=os.clock()+0.55
        end

        local targetPos=destination

        if waypoints[wpIndex] then
            local wp=waypoints[wpIndex]
            targetPos=wp.Position

            if (root.Position-wp.Position).Magnitude < 4 then
                wpIndex += 1
                wp=waypoints[wpIndex]
                if wp then targetPos=wp.Position end
            end

            if wp and wp.Action==Enum.PathWaypointAction.Jump then
                hum.Jump=true
            end
        end

        local steered,dodging=evasiveTarget(root.Position,targetPos)
        targetPos=steered

        if dodging then
            -- Occasional jump helps the character break straight-line pursuit
            -- without teleporting or changing collision rules.
            if math.random() < 0.18 then
                hum.Jump=true
            end
        end

        hum:MoveTo(targetPos)
        task.wait(.04)
    end

    return finish(false, Config.AutoSteal and "timeout" or "stopped")
end

local function walkBackToBase()
    if not (Config.AutoReturnBase and BaseCF) then return true end
    LastAction="Returning to base"
    local ok = walkToPosition(BaseCF.Position,7,45)
    return ok
end

local function carryEgg(target)
    if not target or not target.CFrame then return false end

    local uid=target.Record.Uid
    CurrentTarget = target.Rarity .. " / " .. tostring(uid)
    LastAction = "Running -> "..target.Rarity

    local liveCF=recordCFrame(target.Record) or target.CFrame
    local reached,why = walkToPosition(liveCF.Position,7,45)

    if not reached then
        LastAction="Could not reach "..target.Rarity.." ("..tostring(why)..")"
        return false
    end

    -- Re-resolve once close because SmartPromptPart appears only near the egg.
    task.wait(.18)
    target.Object=eggObject(uid) or target.Object
    local prompt=findStealPrompt(target)

    if not prompt then
        LastAction="At "..target.Rarity.." • no Steal prompt found"
        return false
    end

    LastAction="Stealing "..target.Rarity
    local ok,method=triggerPrompt(prompt)
    if not ok then
        LastAction="Prompt failed"
        return false
    end

    task.wait(.55)

    -- We only use the read snapshot to confirm pickup; no direct carry remote.
    if fieldStillHas(uid)==true then
        -- One second prompt attempt in case the first tap was too early.
        local prompt2=findStealPrompt(target)
        if prompt2 then
            triggerPrompt(prompt2)
            task.wait(.6)
        end
    end

    if fieldStillHas(uid)==true then
        LastAction="Reached "..target.Rarity.." but pickup did not register"
        return false
    end

    LastAction="Picked "..target.Rarity.." ("..tostring(method)..")"

    if Config.NotifyTargetPicked then
        task.spawn(function()
            sendWebhook(
                "Egg picked • "..tostring(target.Rarity),
                "UID: `"..tostring(uid).."`\nPlayer: `"..tostring(LocalPlayer.Name).."`"
            )
        end)
    end

    if Config.AutoReturnBase and BaseCF then
        LastAction="Returning to base with "..target.Rarity
        local backOk,backWhy = walkToPosition(BaseCF.Position,7,45)
        if not backOk then
            LastAction="Picked "..target.Rarity.." • return failed ("..tostring(backWhy)..")"
            return false
        end

        -- Wait briefly at base before scanning the next egg.
        task.wait(.45)
        LastAction="Back at base • ready for next egg"
    else
        LastAction="Picked "..target.Rarity.." • return base disabled"
    end

    return true
end


local function pickupEggForEvent(target)
    if not target or not target.CFrame then return false,"bad-target" end

    local uid=target.Record.Uid
    CurrentTarget="EVENT "..target.Rarity.." / "..tostring(uid)
    LastAction="Event: running to "..target.Rarity

    local liveCF=recordCFrame(target.Record) or target.CFrame
    local reached,why=walkToPosition(liveCF.Position,7,45)
    if not reached then return false,"reach-"..tostring(why) end

    task.wait(.18)
    target.Object=eggObject(uid) or target.Object
    local prompt=findStealPrompt(target)
    if not prompt then return false,"no-steal-prompt" end

    local ok=triggerPrompt(prompt)
    if not ok then return false,"prompt-failed" end
    task.wait(.55)

    if fieldStillHas(uid)==true then
        local p2=findStealPrompt(target)
        if p2 then triggerPrompt(p2); task.wait(.55) end
    end

    if fieldStillHas(uid)==true then
        return false,"pickup-not-confirmed"
    end

    return true,uid
end

local function feedHeldEgg()
    if not RF_MonsterFeed then return false,nil,"AskFeed missing" end

    -- Confirmed from live runtime test:
    -- AskFeed is invoked with NO ARGUMENTS and consumes the currently held egg.
    local ok,res=pcall(function()
        return RF_MonsterFeed:InvokeServer()
    end)

    if not ok then return false,nil,tostring(res) end
    if type(res)=="table" and res.Success==true then
        return true,res,nil
    end
    return false,res,(type(res)=="table" and tostring(res.Message)) or "feed rejected"
end


local function claimOneMonsterChest()
    if not RF_MonsterChestTake or not RF_MonsterChestClaim then
        return false,nil,"Monster chest remote missing"
    end

    -- Runtime-confirmed flow:
    -- AskChestTake() takes no arguments and returns "Monster Chest ready!".
    -- AskChestRevealComplete() without an OpeningId is rejected, so it is not
    -- required for automation. AskChestClaim() succeeds without arguments.
    local okTake,takeRes=pcall(function()
        return RF_MonsterChestTake:InvokeServer()
    end)
    if not okTake then
        return false,nil,"Take error: "..tostring(takeRes)
    end
    if type(takeRes)~="table" or takeRes.Success~=true then
        return false,takeRes,(type(takeRes)=="table" and tostring(takeRes.Message)) or "Take rejected"
    end

    -- Give the server/client chest state time to settle before final claim.
    task.wait(2.15)

    local okClaim,claimRes=pcall(function()
        return RF_MonsterChestClaim:InvokeServer()
    end)
    if not okClaim then
        return false,nil,"Claim error: "..tostring(claimRes)
    end
    if type(claimRes)=="table" and claimRes.Success==true then
        return true,claimRes,nil
    end
    return false,claimRes,(type(claimRes)=="table" and tostring(claimRes.Message)) or "Claim rejected"
end

local function autoClaimMonsterChestCycle()
    if not Config.AutoClaimMonsterChests then return false,"disabled" end

    local snap=monsterSnapshot()
    local state=snap and snap.State
    local pending=state and tonumber(state.PendingChests) or 0
    if pending<=0 then
        LastAction="Monster: no pending chests"
        return false,"none"
    end

    LastAction="Monster: claiming chest • pending "..tostring(pending)

    local ok,res,err=claimOneMonsterChest()
    if not ok then
        LastAction="Monster chest failed • "..tostring(err)
        return false,err
    end

    local reward=res.Reward or {}
    LastAction=string.format(
        "Monster chest ✓ %s • pending %s",
        tostring(reward.DisplayName or reward.Id or res.Message or "Reward"),
        tostring(res.PendingChests)
    )

    if Config.WebhookEnabled then
        task.spawn(function()
            sendWebhook(
                "Hungry Monster Chest",
                tostring(res.Message or "Chest claimed")..
                "\nReward: `"..tostring(reward.DisplayName or reward.Id or "Unknown")..
                "`\nPending Chests: `"..tostring(res.PendingChests or "?").."`"
            )
        end)
    end

    return true,res
end

local function autoFeedCycle()
    if not Config.AutoFeedMonster then return false,"disabled" end

    local snap=monsterSnapshot()
    if not snap or not snap.Event or snap.Event.Active~=true then
        LastAction="Hungry Monster event inactive"
        return false,"inactive"
    end

    local target=eventBestEgg()
    if not target then
        LastAction="Event: searching feed rarities • "..eventFeedSummary()
        return false,"no-target"
    end

    local ok,uidOrWhy=pickupEggForEvent(target)
    if not ok then
        LastAction="Event pickup failed • "..tostring(uidOrWhy)
        return false,uidOrWhy
    end

    local pos=monsterPosition()
    if not pos then
        LastAction="Event: monster position not found"
        return false,"monster-position"
    end

    LastAction="Event: carrying "..target.Rarity.." to Hungry Monster"
    local reached,why=walkToPosition(pos,10,45)
    if not reached then
        LastAction="Event: could not reach monster • "..tostring(why)
        return false,"reach-monster"
    end

    task.wait(.2)
    local fed,res,err=feedHeldEgg()
    if not fed then
        LastAction="Event feed failed • "..tostring(err)
        return false,err
    end

    LastAction=string.format(
        "Fed %s • Charge %s→%s • Chests %s",
        tostring(target.Rarity),
        tostring(res.PreviousCharge),
        tostring(res.Charge),
        tostring(res.PendingChests)
    )

    if Config.WebhookEnabled then
        task.spawn(function()
            sendWebhook(
                "Hungry Monster fed • "..tostring(target.Rarity),
                "Egg UID: `"..tostring(res.EggUid or uidOrWhy).."`\nCharge: `"..tostring(res.PreviousCharge).." → "..tostring(res.Charge).."`\nPending Chests: `"..tostring(res.PendingChests).."`"
            )
        end)
    end

    if Config.EventReturnBase and BaseCF then
        task.wait(.25)
        walkToPosition(BaseCF.Position,7,45)
    end

    return true,res
end

--====================================================
-- HOME PAGE
--====================================================

pageHeader(Home,"ShiBuHub Dashboard","Cloud-tech themed build • branded edition")
homeCard=card(Home,80,180)
hl=textLabel(homeCard,"ShiBuHub v2.3.3",22,true)
hl.Position=UDim2.fromOffset(18,16); hl.Size=UDim2.new(1,-36,0,32); hl.TextColor3=C.CYAN
h2=textLabel(homeCard,"Egg farming engine + Hungry Monster monitor",13,false)
h2.Position=UDim2.fromOffset(18,54); h2.Size=UDim2.new(1,-36,0,24); h2.TextColor3=C.MUTED
h3=textLabel(homeCard,"Rarity picker: choose any rarity from Common to Eternal",14,true)
h3.Position=UDim2.fromOffset(18,92); h3.Size=UDim2.new(1,-36,0,28); h3.TextColor3=C.TEAL
h4=textLabel(homeCard,"Choose rarities, enable Auto Run + Pick + Return, and Evasive Run bends around nearby animals.",12,false)
h4.Position=UDim2.fromOffset(18,132); h4.Size=UDim2.new(1,-36,0,24); h4.TextColor3=C.WHITE

--====================================================
-- EGGS PAGE
--====================================================

pageHeader(Eggs,"EGGS","Configure egg stealing and priority")

StatusCard=card(Eggs,74,102)
statusTitle=textLabel(StatusCard,"STATUS",12,true)
statusTitle.Position=UDim2.fromOffset(14,8); statusTitle.Size=UDim2.new(1,-28,0,20); statusTitle.TextColor3=C.CYAN
statusText=textLabel(StatusCard,"Ready • scanning eggs",15,true)
statusText.Position=UDim2.fromOffset(14,31); statusText.Size=UDim2.new(1,-28,0,24); statusText.TextColor3=C.GREEN
statusMeta=textLabel(StatusCard,"Scanned: 0   •   Target: None",11,false)
statusMeta.Position=UDim2.fromOffset(14,63); statusMeta.Size=UDim2.new(1,-28,0,22); statusMeta.TextColor3=C.MUTED

_,setAuto,getAuto=toggleRow(Eggs,190,"Auto-Steal","Run to selected egg, pick it, then return to base",false,function(v)
    if v and not BaseCF then
        local _,root=characterRoot()
        BaseCF=root.CFrame
        LastAction="Auto-saved current position as base"
    end
    Config.AutoSteal=v
end)
_,setPersistent=toggleRow(Eggs,268,"Persistent Steal","Continue scanning after respawn",true,function(v)
    Config.PersistentSteal=v
end)
_,setTrap=toggleRow(Eggs,346,"Prevent Traps","Skip trap/cage/snare egg models",true,function(v)
    Config.PreventTraps=v
end)
_,setEvasive=toggleRow(Eggs,424,"Evasive Run","Curve away from nearby NPC animals while moving",true,function(v)
    Config.EvasiveRun=v
end)
_,setReturn=toggleRow(Eggs,502,"Auto Return Base","After pickup, automatically run back to saved base",true,function(v)
    Config.AutoReturnBase=v
end)

_,_,getESP=toggleRow(Eggs,580,"Egg ESP","Highlight currently selected egg rarities",false,function(v)
    Config.EggESP=v
end)
_,_,getHatch=toggleRow(Eggs,658,"Auto Hatch","Try to hatch/finish owned eggs automatically",false,function(v)
    Config.AutoHatch=v
end)

priorityCard=card(Eggs,736,112)
pt=textLabel(priorityCard,"RARITY FILTER",12,true)
pt.Position=UDim2.fromOffset(14,8); pt.Size=UDim2.new(1,-28,0,20); pt.TextColor3=C.CYAN

selectedInfo=textLabel(priorityCard,"Selected: "..targetSummary(),11,false)
selectedInfo.Position=UDim2.fromOffset(14,30); selectedInfo.Size=UDim2.new(1,-28,0,20); selectedInfo.TextColor3=C.MUTED
selectedInfo.TextTruncate=Enum.TextTruncate.AtEnd

openRarityBtn=button(priorityCard,"◉  SELECT RARITIES")
openRarityBtn.Size=UDim2.new(1,-28,0,42)
openRarityBtn.Position=UDim2.fromOffset(14,58)
openRarityBtn.BackgroundColor3=Color3.fromRGB(8,68,83)
stroke(openRarityBtn,C.TEAL,1.2,.18)

-- Full rarity picker, similar to Clover's list.
rarityShade=Instance.new("Frame")
rarityShade.Size=UDim2.fromScale(1,1)
rarityShade.BackgroundColor3=Color3.fromRGB(0,0,0)
rarityShade.BackgroundTransparency=.20
rarityShade.BorderSizePixel=0
rarityShade.Visible=false
rarityShade.ZIndex=1000
rarityShade.Parent=Gui

rarityModal=Instance.new("Frame")
rarityModal.AnchorPoint=Vector2.new(.5,.5)
rarityModal.Position=UDim2.fromScale(.5,.5)
rarityModal.Size=UDim2.new(.74,0,.84,0)
rarityModal.BackgroundColor3=Color3.fromRGB(7,18,27)
rarityModal.BorderSizePixel=0
rarityModal.ZIndex=1001
rarityModal.Parent=rarityShade
corner(rarityModal,14)
stroke(rarityModal,C.CYAN,1.5,.18)

rarityTitle=textLabel(rarityModal,"◉  RARITIES",22,true)
rarityTitle.Position=UDim2.fromOffset(22,12)
rarityTitle.Size=UDim2.new(1,-190,0,40)
rarityTitle.TextColor3=C.WHITE
rarityTitle.ZIndex=1002

doneRarity=button(rarityModal,"DONE")
doneRarity.Size=UDim2.fromOffset(150,42)
doneRarity.Position=UDim2.new(1,-166,0,12)
doneRarity.BackgroundColor3=Color3.fromRGB(16,105,125)
doneRarity.ZIndex=1002
stroke(doneRarity,C.TEAL,1,.1)

searchHint=textLabel(rarityModal,"Choose any egg rarity to test Auto Steal",12,false)
searchHint.Position=UDim2.fromOffset(22,58)
searchHint.Size=UDim2.new(1,-44,0,24)
searchHint.TextColor3=C.MUTED
searchHint.ZIndex=1002

allBtn=button(rarityModal,"ALL")
allBtn.Size=UDim2.fromOffset(94,34)
allBtn.Position=UDim2.new(1,-214,0,88)
allBtn.ZIndex=1002

noneBtn=button(rarityModal,"NONE")
noneBtn.Size=UDim2.fromOffset(94,34)
noneBtn.Position=UDim2.new(1,-112,0,88)
noneBtn.ZIndex=1002

rarityList=Instance.new("ScrollingFrame")
rarityList.Position=UDim2.fromOffset(18,130)
rarityList.Size=UDim2.new(1,-36,1,-148)
rarityList.BackgroundColor3=Color3.fromRGB(5,14,22)
rarityList.BorderSizePixel=0
rarityList.ScrollBarThickness=5
rarityList.ScrollBarImageColor3=C.CYAN2
rarityList.AutomaticCanvasSize=Enum.AutomaticSize.Y
rarityList.CanvasSize=UDim2.new()
rarityList.ZIndex=1002
rarityList.Parent=rarityModal
corner(rarityList,10)
stroke(rarityList,C.CYAN2,1,.65)

rarityLayout=Instance.new("UIListLayout")
rarityLayout.Padding=UDim.new(0,6)
rarityLayout.SortOrder=Enum.SortOrder.LayoutOrder
rarityLayout.Parent=rarityList

rarityPadding=Instance.new("UIPadding")
rarityPadding.PaddingTop=UDim.new(0,8)
rarityPadding.PaddingBottom=UDim.new(0,8)
rarityPadding.PaddingLeft=UDim.new(0,8)
rarityPadding.PaddingRight=UDim.new(0,8)
rarityPadding.Parent=rarityList

rarityMeta={
    Eternal={"1 in 100,000,000",Color3.fromRGB(232,64,255)},
    Divine={"1 in 1,000,000,000",Color3.fromRGB(255,235,55)},
    Secret={"1 in 100,000",Color3.fromRGB(165,165,175)},
    Cosmic={"1 in 200",Color3.fromRGB(125,50,255)},
    Mythic={"1 in 100",Color3.fromRGB(255,55,125)},
    Legendary={"1 in 25",Color3.fromRGB(255,150,50)},
    Epic={"",Color3.fromRGB(195,85,255)},
    Rare={"",Color3.fromRGB(70,145,255)},
    Uncommon={"",Color3.fromRGB(75,235,120)},
    Common={"",Color3.fromRGB(225,230,235)},
}

rarityRows={}

function updateRarityUI()
    local chosen=selectedRarities()
    selectedInfo.Text="Selected ("..tostring(#chosen).."): "..targetSummary()
    openRarityBtn.Text="◉  SELECT RARITIES  ["..tostring(#chosen).."]"
    for name,row in pairs(rarityRows) do
        local on=Config.Targets[name] and true or false
        row.Button.BackgroundColor3=on and Color3.fromRGB(30,48,58) or Color3.fromRGB(11,24,33)
        row.Button.TextTransparency=on and 0 or .42
        row.Mark.Text=on and "✓" or ""
        row.Mark.BackgroundColor3=on and C.TEAL or Color3.fromRGB(40,52,60)
        local s=row.Button:FindFirstChildOfClass("UIStroke")
        if s then s.Transparency=on and .08 or .72 end
    end
end

for i,name in ipairs(RarityOrder) do
    local meta=rarityMeta[name] or {"",C.WHITE}
    local row=button(rarityList,"")
    row.Name=name
    row.LayoutOrder=i
    row.Size=UDim2.new(1,0,0,54)
    row.BackgroundColor3=Color3.fromRGB(11,24,33)
    row.ZIndex=1003

    local rowStroke=row:FindFirstChildOfClass("UIStroke")
    if rowStroke then rowStroke.Color=meta[2] end

    local rn=textLabel(row,name,15,true)
    rn.Position=UDim2.fromOffset(16,7)
    rn.Size=UDim2.new(.42,0,0,22)
    rn.TextColor3=meta[2]
    rn.ZIndex=1004

    local chance=textLabel(row,meta[1],12,false)
    chance.Position=UDim2.fromOffset(16,29)
    chance.Size=UDim2.new(.70,0,0,18)
    chance.TextColor3=C.MUTED
    chance.ZIndex=1004

    local mark=textLabel(row,"",18,true)
    mark.Size=UDim2.fromOffset(34,34)
    mark.Position=UDim2.new(1,-44,.5,-17)
    mark.TextXAlignment=Enum.TextXAlignment.Center
    mark.TextColor3=Color3.fromRGB(3,20,25)
    mark.BackgroundColor3=Color3.fromRGB(40,52,60)
    mark.BackgroundTransparency=0
    mark.ZIndex=1004
    corner(mark,8)

    rarityRows[name]={Button=row,Mark=mark}
    row.MouseButton1Click:Connect(function()
        Config.Targets[name]=not Config.Targets[name]
        updateRarityUI()
    end)
end

openRarityBtn.MouseButton1Click:Connect(function()
    updateRarityUI()
    rarityShade.Visible=true
end)

doneRarity.MouseButton1Click:Connect(function()
    rarityShade.Visible=false
end)

allBtn.MouseButton1Click:Connect(function()
    for name in pairs(Config.Targets) do Config.Targets[name]=true end
    updateRarityUI()
end)

noneBtn.MouseButton1Click:Connect(function()
    for name in pairs(Config.Targets) do Config.Targets[name]=false end
    updateRarityUI()
end)

updateRarityUI()

saveBaseBtn=button(Eggs,"⌂  SAVE CURRENT POSITION AS BASE")
saveBaseBtn.Size=UDim2.new(1,-32,0,46)
saveBaseBtn.Position=UDim2.fromOffset(16,864)
saveBaseBtn.BackgroundColor3=Color3.fromRGB(8,68,83)
stroke(saveBaseBtn,C.TEAL,1.2,.18)
saveBaseBtn.MouseButton1Click:Connect(function()
    local _,root=characterRoot()
    BaseCF=root.CFrame
    saveBaseBtn.Text="✓  BASE SAVED"
    LastAction="Base saved"
end)



local function getSaveData()
    if not SaveModule or type(SaveModule.Get)~="function" then return nil end

    local ok,data=pcall(function()
        return SaveModule.Get()
    end)
    if ok and type(data)=="table" then return data end

    ok,data=pcall(function()
        return SaveModule.Get(LocalPlayer)
    end)
    return ok and type(data)=="table" and data or nil
end

local function moneyValue(v)
    if type(v)=="number" then return v end
    if type(v)=="string" then return tonumber(v) end
    if type(v)=="table" then
        return tonumber(v.Amount or v.Value or v.Money or v.Cash)
    end
    return nil
end

local function treadmillUpgradeLevel(id)
    if not TreadmillsData then return nil end
    if type(TreadmillsData.GetUpgradeLevel)=="function" then
        local ok,n=pcall(TreadmillsData.GetUpgradeLevel,id)
        if ok then return tonumber(n) end
    end

    local entry=type(TreadmillsData.Directory)=="table" and TreadmillsData.Directory[id]
    return entry and tonumber(entry.UpgradeLevel or entry.Level or entry.Tier)
end

local function nextTreadmillUpgrade()
    if not TreadmillsData then
        return nil,"Data/Treadmills unavailable"
    end

    local save=getSaveData()
    if not save then
        return nil,"Shared/Save unavailable"
    end

    local current=tonumber(save.TreadmillUpgradeLevel) or 0
    local money=moneyValue(save.Money) or moneyValue(save.Cash) or 0

    -- Preferred current-game API.
    if type(TreadmillsData.GetByUpgradeLevel)=="function" then
        local ok,entry=pcall(TreadmillsData.GetByUpgradeLevel,current+1)
        if ok and type(entry)=="table" then
            local id=entry._id or entry.Id or entry.ID
            local price=tonumber(entry.Price or entry.Cost) or 0
            return {
                Id=id,
                Entry=entry,
                Current=current,
                Next=current+1,
                Price=price,
                Money=money,
                Affordable=money>=price,
            }
        end
    end

    -- Fallback for Directory-based versions of the module.
    local best=nil
    if type(TreadmillsData.Directory)=="table" then
        for id,entry in pairs(TreadmillsData.Directory) do
            if type(entry)=="table" then
                local lvl=treadmillUpgradeLevel(id)
                if lvl and lvl>current and (not best or lvl<best.Next) then
                    local price=tonumber(entry.Price or entry.Cost) or 0
                    best={
                        Id=id,
                        Entry=entry,
                        Current=current,
                        Next=lvl,
                        Price=price,
                        Money=money,
                        Affordable=money>=price,
                    }
                end
            end
        end
    end

    return best,best and nil or "No next treadmill upgrade"
end

local function upgradeTreadmillOnce()
    if not RF_TreadRaise then return false,nil,"AskTierRaise missing" end

    local nextInfo,why=nextTreadmillUpgrade()
    if not nextInfo then return false,nil,why end
    if not nextInfo.Id then return false,nextInfo,"Next treadmill id missing" end
    if not nextInfo.Affordable then
        return false,nextInfo,
            "Need "..tostring(nextInfo.Price).." • have "..tostring(nextInfo.Money)
    end

    -- Confirmed from current public game-module usage:
    -- AskTierRaise expects the treadmill _id string.
    local ok,res=pcall(function()
        return RF_TreadRaise:InvokeServer(nextInfo.Id)
    end)

    if not ok then return false,nextInfo,tostring(res) end

    -- Remote versions differ: some return a response table, some return truthy/nil.
    if res==false then
        return false,nextInfo,"Upgrade rejected"
    end

    return true,res,nextInfo
end

local CachedOwnPlot=nil
local CachedOwnPlotAt=0

local function ownPlot()
    if CachedOwnPlot and CachedOwnPlot.Parent and os.clock()-CachedOwnPlotAt<15 then
        return CachedOwnPlot
    end

    local plots=workspace:FindFirstChild("Plots")
    if not plots then return nil end

    -- First try Homestead state.
    if RF_PlotState then
        local ok,state=pcall(function() return RF_PlotState:InvokeServer() end)
        if ok and type(state)=="table" then
            local map=state.OwnersBySlot or state.SlotOwners or state.Owners or state.Slots
            if type(map)=="table" then
                for slot,owner in pairs(map) do
                    local id=owner
                    if type(owner)=="table" then
                        id=owner.UserId or owner.OwnerUserId or owner.Id
                    end
                    if tonumber(id)==tonumber(LocalPlayer.UserId) then
                        local p=plots:FindFirstChild(tostring(slot))
                        if p then
                            CachedOwnPlot=p
                            CachedOwnPlotAt=os.clock()
                            return p
                        end
                    end
                end
            end
        end
    end

    -- Fallback: plot labels containing the player's name.
    for _,p in ipairs(plots:GetChildren()) do
        for _,d in ipairs(p:GetDescendants()) do
            if d:IsA("TextLabel") or d:IsA("TextButton") then
                local ok,t=pcall(function() return d.Text end)
                if ok and type(t)=="string" and t:find(LocalPlayer.Name,1,true) then
                    CachedOwnPlot=p
                    CachedOwnPlotAt=os.clock()
                    return p
                end
            end
        end
    end

    -- Last fallback: AskRenderSnapshot user ids matched to visible render slot ids.
    if RF_TreadRender then
        local ok,snap=pcall(function() return RF_TreadRender:InvokeServer() end)
        local renders=workspace:FindFirstChild("__ClientTreadmillRenders")
        if ok and type(snap)=="table" and renders then
            local slots={}
            for _,r in ipairs(renders:GetChildren()) do
                local n=tonumber(r.Name:match("TreadmillRender_(%d+)"))
                if n then table.insert(slots,n) end
            end
            table.sort(slots)
            for i,userId in ipairs(snap) do
                if tonumber(userId)==tonumber(LocalPlayer.UserId) and slots[i] then
                    local p=plots:FindFirstChild(tostring(slots[i]))
                    if p then
                        CachedOwnPlot=p
                        CachedOwnPlotAt=os.clock()
                        return p
                    end
                end
            end
        end
    end

    return nil
end

local function ownTreadmillBottom()
    local p=ownPlot()
    if not p then return nil end

    local exact=p:FindFirstChild("TreadmillBottom",true)
    if exact and exact:IsA("BasePart") then return exact end

    for _,d in ipairs(p:GetDescendants()) do
        if d:IsA("BasePart") and d.Name:lower():find("treadmill",1,true) then
            return d
        end
    end
    return nil
end

local TreadmillSide=1
local function autoTreadmillStep()
    local belt=ownTreadmillBottom()
    if not belt then
        return false,"Own treadmill not found"
    end

    local hum,root=characterRoot()
    if not hum or not root then return false,"Character unavailable" end

    if (root.Position-belt.Position).Magnitude>7 then
        local reached,why=walkToPosition(belt.Position,5.5,35)
        if not reached then return false,"Could not reach treadmill: "..tostring(why) end
    end

    -- Stay on the player's own belt using ordinary Humanoid movement.
    -- Alternating a short target keeps the character actively moving on it.
    TreadmillSide=-TreadmillSide
    local offset=belt.CFrame.LookVector*(2.2*TreadmillSide)
    hum:MoveTo(belt.Position+offset)
    return true,"Training on plot "..tostring(ownPlot() and ownPlot().Name or "?")
end

--====================================================
-- PROGRESSION PAGE
--====================================================

pageHeader(Progression,"PROGRESSION","Clover-style account progression")

progCard=card(Progression,80,112)
progTitle=textLabel(progCard,"PROGRESSION TOOLS",16,true)
progTitle.Position=UDim2.fromOffset(16,10); progTitle.Size=UDim2.new(1,-32,0,26); progTitle.TextColor3=C.CYAN
progStatus=textLabel(progCard,"Ready",12,false)
progStatus.Position=UDim2.fromOffset(16,42); progStatus.Size=UDim2.new(1,-32,0,56); progStatus.TextWrapped=true; progStatus.TextColor3=C.MUTED

collectAway=button(Progression,"COLLECT AWAY EARNINGS")
collectAway.Size=UDim2.new(1,-32,0,42); collectAway.Position=UDim2.fromOffset(16,210)
collectAway.MouseButton1Click:Connect(function()
    local ok=invokeRemote(RF_AwayCollect)
    progStatus.Text=ok and "Away earnings request sent." or "Away earnings remote unavailable."
end)

redeemCodex=button(Progression,"REDEEM CODEX ALL")
redeemCodex.Size=UDim2.new(1,-32,0,42); redeemCodex.Position=UDim2.fromOffset(16,262)
redeemCodex.MouseButton1Click:Connect(function()
    local ok=invokeRemote(RF_CodexAll)
    progStatus.Text=ok and "Codex redeem request sent." or "Codex remote unavailable."
end)

wearBest=button(Progression,"WEAR BEST")
wearBest.Size=UDim2.new(1,-32,0,42); wearBest.Position=UDim2.fromOffset(16,314)
wearBest.MouseButton1Click:Connect(function()
    local ok=invokeRemote(RF_WearBest)
    progStatus.Text=ok and "Wear Best request sent." or "Wear Best remote unavailable."
end)

treadState=button(Progression,"READ TREADMILL")
treadState.Size=UDim2.new(.5,-22,0,42); treadState.Position=UDim2.fromOffset(16,366)
treadState.MouseButton1Click:Connect(function()
    local info,why=nextTreadmillUpgrade()
    local plot=ownPlot()
    if info then
        progStatus.Text=string.format(
            "Plot %s • Treadmill Lv.%s → %s • Cost %s • Money %s",
            tostring(plot and plot.Name or "?"),
            tostring(info.Current),
            tostring(info.Next),
            tostring(info.Price),
            tostring(info.Money)
        )
    else
        progStatus.Text="Treadmill: "..tostring(why)
    end
end)

treadRaise=button(Progression,"UPGRADE TREADMILL")
treadRaise.Size=UDim2.new(.5,-22,0,42); treadRaise.Position=UDim2.new(.5,6,0,366)
treadRaise.MouseButton1Click:Connect(function()
    treadRaise.Text="UPGRADING..."
    task.spawn(function()
        local ok,res,infoOrErr=upgradeTreadmillOnce()
        if ok then
            local info=infoOrErr
            progStatus.Text="Treadmill upgraded with id: "..tostring(info and info.Id or "?")
            treadRaise.Text="✓ UPGRADED"
        else
            local err=infoOrErr
            if type(res)=="table" and type(infoOrErr)=="string" then err=infoOrErr end
            progStatus.Text="Upgrade failed: "..tostring(err)
            treadRaise.Text="FAILED"
        end
        task.wait(1.5)
        if treadRaise and treadRaise.Parent then treadRaise.Text="UPGRADE TREADMILL" end
    end)
end)

_,_,getAutoAway=toggleRow(Progression,430,"Auto Collect Away","Collect away earnings periodically",false,function(v)
    Config.AutoCollectAway=v
end)
_,_,getAutoBest=toggleRow(Progression,508,"Auto Wear Best","Periodically request the best haul equipment",false,function(v)
    Config.AutoWearBest=v
end)
_,_,getAutoCodex=toggleRow(Progression,586,"Auto Redeem Codex","Redeem available codex rewards periodically",false,function(v)
    Config.AutoRedeemCodex=v
end)
_,_,getAutoTreadmill=toggleRow(Progression,664,"Auto Treadmill","Walk to your own treadmill and keep training with normal movement",false,function(v)
    Config.AutoTreadmill=v
end)
_,_,getAutoUpgradeTreadmill=toggleRow(Progression,742,"Auto Upgrade Treadmill","Buy the next affordable treadmill tier using its required _id",false,function(v)
    Config.AutoUpgradeTreadmill=v
end)

--====================================================
-- EVENT PAGE
--====================================================

pageHeader(Event,"EVENT","Hungry Monster live status")
monsterCard=card(Event,80,180)
mt=textLabel(monsterCard,"THE HUNGRY MONSTER",17,true)
mt.Position=UDim2.fromOffset(16,12); mt.Size=UDim2.new(1,-32,0,28); mt.TextColor3=C.CYAN
monsterStatus=textLabel(monsterCard,"Reading snapshot...",13,false)
monsterStatus.Position=UDim2.fromOffset(16,52); monsterStatus.Size=UDim2.new(1,-32,0,74); monsterStatus.TextColor3=C.WHITE; monsterStatus.TextWrapped=true
refreshMonster=button(monsterCard,"REFRESH")
refreshMonster.Size=UDim2.new(1,-32,0,36); refreshMonster.Position=UDim2.fromOffset(16,132)

function refreshMonsterState()
    if not RF_MonsterSnapshot then monsterStatus.Text="MonsterParasite/AskSnapshot not found"; return end
    local ok,s=pcall(function() return RF_MonsterSnapshot:InvokeServer() end)
    if not ok or type(s)~="table" then monsterStatus.Text="Snapshot failed"; return end
    local e=s.Event or {}; local st=s.State or {}
    monsterStatus.Text=string.format("Active: %s\nCharge: %s   •   Pending Chests: %s\nTotal Feeds: %s",tostring(e.Active),tostring(st.Charge),tostring(st.PendingChests),tostring(st.TotalFeeds))
end
refreshMonster.MouseButton1Click:Connect(refreshMonsterState)

infoEvent=card(Event,278,108)
ie=textLabel(infoEvent,"AUTO FEED • CONFIRMED",15,true)
ie.Position=UDim2.fromOffset(14,10); ie.Size=UDim2.new(1,-28,0,25); ie.TextColor3=C.GOLD
ie2=textLabel(infoEvent,"AskFeed takes no arguments. The server consumes the currently held egg and returns Charge / PendingChests / EggUid.",12,false)
ie2.Position=UDim2.fromOffset(14,38); ie2.Size=UDim2.new(1,-28,0,55); ie2.TextWrapped=true; ie2.TextColor3=C.MUTED

_,_,getAutoFeedMonster=toggleRow(Event,402,"Auto Feed Hungry Monster","Pick allowed field eggs, carry them to the monster, then feed automatically",false,function(v)
    Config.AutoFeedMonster=v
end)

_,_,getPriorityMonster=toggleRow(Event,480,"Priority Hungry Monster","Pause normal Auto-Steal while event Auto Feed is working",false,function(v)
    Config.PriorityHungryMonster=v
end)

_,_,getProtectEvent=toggleRow(Event,558,"Protect Rarities","Never feed rarities selected in the EGGS rarity picker",false,function(v)
    Config.ProtectSelectedRarities=v
end)

feedCard=card(Event,636,112)
feedTitle=textLabel(feedCard,"FEED RARITIES",12,true)
feedTitle.Position=UDim2.fromOffset(14,8); feedTitle.Size=UDim2.new(1,-28,0,20); feedTitle.TextColor3=C.CYAN
feedInfo=textLabel(feedCard,"Feed: "..eventFeedSummary(),11,false)
feedInfo.Position=UDim2.fromOffset(14,30); feedInfo.Size=UDim2.new(1,-28,0,20); feedInfo.TextColor3=C.MUTED; feedInfo.TextTruncate=Enum.TextTruncate.AtEnd
openFeedRarity=button(feedCard,"✦  SELECT FEED RARITIES")
openFeedRarity.Size=UDim2.new(1,-28,0,42); openFeedRarity.Position=UDim2.fromOffset(14,58)
openFeedRarity.BackgroundColor3=Color3.fromRGB(8,68,83)

manualFeed=button(Event,"FEED CURRENTLY HELD EGG")
manualFeed.Size=UDim2.new(1,-32,0,42); manualFeed.Position=UDim2.fromOffset(16,764)
manualFeed.MouseButton1Click:Connect(function()
    local ok,res,err=feedHeldEgg()
    if ok then
        manualFeed.Text="✓ FED • CHARGE "..tostring(res.Charge)
        refreshMonsterState()
    else
        manualFeed.Text="FAILED • "..tostring(err)
    end
    task.delay(1.5,function() if manualFeed and manualFeed.Parent then manualFeed.Text="FEED CURRENTLY HELD EGG" end end)
end)

_,_,getAutoClaimMonster=toggleRow(Event,820,"Auto Claim Monster Chests","Take and claim pending Hungry Monster rewards one by one",false,function(v)
    Config.AutoClaimMonsterChests=v
end)

manualClaimMonster=button(Event,"CLAIM 1 MONSTER CHEST")
manualClaimMonster.Size=UDim2.new(1,-32,0,42); manualClaimMonster.Position=UDim2.fromOffset(16,898)
manualClaimMonster.MouseButton1Click:Connect(function()
    manualClaimMonster.Text="CLAIMING..."
    task.spawn(function()
        local ok,res,err=claimOneMonsterChest()
        if ok then
            local reward=res.Reward or {}
            manualClaimMonster.Text="✓ "..tostring(reward.DisplayName or reward.Id or "CLAIMED")
            refreshMonsterState()
        else
            manualClaimMonster.Text="FAILED • "..tostring(err)
        end
        task.wait(1.7)
        if manualClaimMonster and manualClaimMonster.Parent then
            manualClaimMonster.Text="CLAIM 1 MONSTER CHEST"
        end
    end)
end)

protectCard=card(Event,954,92)
protectText=textLabel(protectCard,"Protected: "..targetSummary(),12,false)
protectText.Position=UDim2.fromOffset(14,12); protectText.Size=UDim2.new(1,-28,0,64); protectText.TextWrapped=true; protectText.TextColor3=C.MUTED

-- Event feed rarity picker
feedShade=Instance.new("Frame")
feedShade.Size=UDim2.fromScale(1,1)
feedShade.BackgroundColor3=Color3.fromRGB(0,0,0)
feedShade.BackgroundTransparency=.20
feedShade.BorderSizePixel=0
feedShade.Visible=false
feedShade.ZIndex=1100
feedShade.Parent=Gui

feedModal=Instance.new("Frame")
feedModal.AnchorPoint=Vector2.new(.5,.5)
feedModal.Position=UDim2.fromScale(.5,.5)
feedModal.Size=UDim2.new(.74,0,.84,0)
feedModal.BackgroundColor3=Color3.fromRGB(7,18,27)
feedModal.BorderSizePixel=0
feedModal.ZIndex=1101
feedModal.Parent=feedShade
corner(feedModal,14); stroke(feedModal,C.CYAN,1.5,.18)

fmTitle=textLabel(feedModal,"✦  EVENT FEED RARITIES",20,true)
fmTitle.Position=UDim2.fromOffset(22,12); fmTitle.Size=UDim2.new(1,-190,0,40); fmTitle.TextColor3=C.WHITE; fmTitle.ZIndex=1102

fmDone=button(feedModal,"DONE")
fmDone.Size=UDim2.fromOffset(150,42); fmDone.Position=UDim2.new(1,-166,0,12); fmDone.ZIndex=1102

fmAll=button(feedModal,"ALL")
fmAll.Size=UDim2.fromOffset(94,34); fmAll.Position=UDim2.new(1,-214,0,88); fmAll.ZIndex=1102

fmNone=button(feedModal,"NONE")
fmNone.Size=UDim2.fromOffset(94,34); fmNone.Position=UDim2.new(1,-112,0,88); fmNone.ZIndex=1102

fmHint=textLabel(feedModal,"Selected EGGS rarities are still protected when Protect Rarities is ON.",12,false)
fmHint.Position=UDim2.fromOffset(22,58); fmHint.Size=UDim2.new(1,-44,0,24); fmHint.TextColor3=C.MUTED; fmHint.ZIndex=1102

fmList=Instance.new("ScrollingFrame")
fmList.Position=UDim2.fromOffset(18,130); fmList.Size=UDim2.new(1,-36,1,-148)
fmList.BackgroundColor3=Color3.fromRGB(5,14,22); fmList.BorderSizePixel=0
fmList.ScrollBarThickness=5; fmList.AutomaticCanvasSize=Enum.AutomaticSize.Y; fmList.CanvasSize=UDim2.new()
fmList.ZIndex=1102; fmList.Parent=feedModal
corner(fmList,10)

fmLayout=Instance.new("UIListLayout")
fmLayout.Padding=UDim.new(0,6); fmLayout.SortOrder=Enum.SortOrder.LayoutOrder; fmLayout.Parent=fmList
fmPad=Instance.new("UIPadding")
fmPad.PaddingTop=UDim.new(0,8); fmPad.PaddingBottom=UDim.new(0,8); fmPad.PaddingLeft=UDim.new(0,8); fmPad.PaddingRight=UDim.new(0,8); fmPad.Parent=fmList

fmRows={}
function updateFeedRarityUI()
    feedInfo.Text="Feed: "..eventFeedSummary()
    local count=#selectedEventFeedRarities()
    openFeedRarity.Text="✦  SELECT FEED RARITIES  ["..tostring(count).."]"
    for name,row in pairs(fmRows) do
        local on=Config.EventFeedTargets[name]==true
        row.Mark.Text=on and "✓" or ""
        row.Mark.BackgroundColor3=on and C.TEAL or Color3.fromRGB(40,52,60)
        row.Button.BackgroundColor3=on and Color3.fromRGB(30,48,58) or Color3.fromRGB(11,24,33)
    end
end

for i,name in ipairs(RarityOrder) do
    local meta=rarityMeta[name] or {"",C.WHITE}
    local row=button(fmList,"")
    row.LayoutOrder=i; row.Size=UDim2.new(1,0,0,54); row.ZIndex=1103
    local rn=textLabel(row,name,15,true)
    rn.Position=UDim2.fromOffset(16,7); rn.Size=UDim2.new(.5,0,0,22); rn.TextColor3=meta[2]; rn.ZIndex=1104
    local chance=textLabel(row,meta[1],12,false)
    chance.Position=UDim2.fromOffset(16,29); chance.Size=UDim2.new(.7,0,0,18); chance.TextColor3=C.MUTED; chance.ZIndex=1104
    local mark=textLabel(row,"",18,true)
    mark.Size=UDim2.fromOffset(34,34); mark.Position=UDim2.new(1,-44,.5,-17); mark.TextXAlignment=Enum.TextXAlignment.Center
    mark.TextColor3=Color3.fromRGB(3,20,25); mark.ZIndex=1104; corner(mark,8)
    fmRows[name]={Button=row,Mark=mark}
    row.MouseButton1Click:Connect(function()
        Config.EventFeedTargets[name]=not Config.EventFeedTargets[name]
        updateFeedRarityUI()
    end)
end

openFeedRarity.MouseButton1Click:Connect(function() updateFeedRarityUI(); feedShade.Visible=true end)
fmDone.MouseButton1Click:Connect(function() feedShade.Visible=false end)
fmAll.MouseButton1Click:Connect(function()
    for name in pairs(Config.EventFeedTargets) do Config.EventFeedTargets[name]=true end
    updateFeedRarityUI()
end)
fmNone.MouseButton1Click:Connect(function()
    for name in pairs(Config.EventFeedTargets) do Config.EventFeedTargets[name]=false end
    updateFeedRarityUI()
end)
updateFeedRarityUI()

--====================================================
-- SELL PAGE
--====================================================

pageHeader(Sell,"SELL","Quick satchel sale")
sellCard=card(Sell,80,130)
sellInfo=textLabel(sellCard,"Use the game's Haul sale remote for your current satchel.",13,false)
sellInfo.Position=UDim2.fromOffset(16,14); sellInfo.Size=UDim2.new(1,-32,0,38); sellInfo.TextWrapped=true; sellInfo.TextColor3=C.MUTED
sellNow=button(sellCard,"SELL SATCHEL NOW")
sellNow.Size=UDim2.new(1,-32,0,42); sellNow.Position=UDim2.fromOffset(16,70)
sellNow.MouseButton1Click:Connect(function()
    if not RF_SatchelSale then sellNow.Text="REMOTE NOT FOUND"; return end
    local ok=pcall(function() RF_SatchelSale:InvokeServer() end)
    sellNow.Text=ok and "✓ SELL REQUEST SENT" or "SELL FAILED"
end)

_,_,getAutoSell=toggleRow(Sell,228,"Auto Sell Satchel","Offer the current satchel for sale periodically",false,function(v)
    Config.AutoSellSatchel=v
end)

sellPets=button(Sell,"SELL EVERY PET")
sellPets.Size=UDim2.new(1,-32,0,42); sellPets.Position=UDim2.fromOffset(16,314)
sellPets.MouseButton1Click:Connect(function()
    local ok=invokeRemote(RE_SellEveryPet)
    sellPets.Text=ok and "✓ SELL PETS REQUEST SENT" or "PET SELL UNAVAILABLE"
end)

sellProtect=card(Sell,372,104)
sp1=textLabel(sellProtect,"SELL FILTER / PROTECTION",14,true)
sp1.Position=UDim2.fromOffset(14,10); sp1.Size=UDim2.new(1,-28,0,24); sp1.TextColor3=C.CYAN
sp2=textLabel(sellProtect,"Selected rarities: "..targetSummary().."\nUse the EGGS rarity picker as your keep/protect list.",12,false)
sp2.Position=UDim2.fromOffset(14,38); sp2.Size=UDim2.new(1,-28,0,56); sp2.TextWrapped=true; sp2.TextColor3=C.MUTED

--====================================================
-- WEBHOOK PAGE
--====================================================

pageHeader(Webhook,"WEBHOOK","Rare egg notifications")
whCard=card(Webhook,80,184)
whInfo=textLabel(whCard,"Optional Discord webhook for ShiBuHub notifications.",12,false)
whInfo.Position=UDim2.fromOffset(16,12); whInfo.Size=UDim2.new(1,-32,0,34); whInfo.TextWrapped=true; whInfo.TextColor3=C.MUTED
whBox=Instance.new("TextBox")
whBox.Size=UDim2.new(1,-32,0,42); whBox.Position=UDim2.fromOffset(16,54); whBox.BackgroundColor3=C.PANEL2; whBox.TextColor3=C.WHITE; whBox.PlaceholderText="Webhook URL"; whBox.PlaceholderColor3=C.MUTED; whBox.Text=""; whBox.ClearTextOnFocus=false; whBox.Font=Enum.Font.Gotham; whBox.TextSize=12; whBox.Parent=whCard
corner(whBox,9); stroke(whBox,C.CYAN2,1,.55)
whTest=button(whCard,"SAVE + TEST")
whTest.Size=UDim2.new(1,-32,0,42); whTest.Position=UDim2.fromOffset(16,108)
whTest.MouseButton1Click:Connect(function()
    Config.WebhookUrl=whBox.Text
    local ok,why=sendWebhook("ShiBuHub connected","Webhook test from ShiBuHub v2.3.3")
    whTest.Text=ok and "✓ TEST SENT" or ("FAILED • "..tostring(why))
end)

_,_,getWebhook=toggleRow(Webhook,282,"Enable Webhook","Allow notifications to the URL above",false,function(v)
    Config.WebhookUrl=whBox.Text
    Config.WebhookEnabled=v
end)
_,_,getFoundNotify=toggleRow(Webhook,360,"Notify Target Found","Send a notification when a selected target appears",false,function(v)
    Config.NotifyTargetFound=v
end)
_,_,getPickedNotify=toggleRow(Webhook,438,"Notify Target Picked","Send a notification after pickup is confirmed",true,function(v)
    Config.NotifyTargetPicked=v
end)

--====================================================
-- SETTINGS PAGE
--====================================================

pageHeader(Settings,"SETTINGS","Performance and session options")
_,_,getAnti=toggleRow(Settings,80,"Anti AFK (disabled)","VirtualUser/Idled removed",false,function(v) Config.AntiAFK=false end)
_,_,getFPS=toggleRow(Settings,158,"Low FPS Mode","Reduce graphics and cap FPS to 15",false,function(v)
    Config.FPSBoost=v
    if v then
        if setfpscap then pcall(setfpscap,15) end
        pcall(function()
            settings().Rendering.QualityLevel=Enum.QualityLevel.Level01
            game:GetService("Lighting").GlobalShadows=false
        end)
    else
        if setfpscap then pcall(setfpscap,60) end
    end
end)
_,_,getRejoin=toggleRow(Settings,236,"Auto Rejoin","Rejoin after Roblox disconnect prompt",false,function(v) Config.AutoRejoin=v end)

movementCard=card(Settings,314,116)
mv1=textLabel(movementCard,"MOVEMENT",14,true)
mv1.Position=UDim2.fromOffset(14,10); mv1.Size=UDim2.new(1,-28,0,22); mv1.TextColor3=C.CYAN
mv2=textLabel(movementCard,"Pathfinding + Humanoid:MoveTo using the game-provided WalkSpeed. Direct CFrame teleport and WalkSpeed overrides are disabled.",12,false)
mv2.Position=UDim2.fromOffset(14,38); mv2.Size=UDim2.new(1,-28,0,62); mv2.TextWrapped=true; mv2.TextColor3=C.MUTED

--====================================================
-- UI BEHAVIOR
--====================================================

minimizeBtn.MouseButton1Click:Connect(function()
    Main.Visible=false
    Bubble.Visible=true
end)
Bubble.MouseButton1Click:Connect(function()
    Bubble.Visible=false
    Main.Visible=true
end)
closeBtn.MouseButton1Click:Connect(function()
    Config.AutoSteal=false
    if G.ShiBuHubRunId==RUN_ID then G.ShiBuHubRunId="closed" end
    Gui:Destroy()
end)
-- Mobile drag by header
local dragging=false
local dragStart,startPos
Header.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
        dragging=true; dragStart=i.Position; startPos=Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement) then
        local d=i.Position-dragStart
        Main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
end)


local ESPFolder=Instance.new("Folder")
ESPFolder.Name="ShiBuHubESP"
ESPFolder.Parent=Gui

local function clearEggESP()
    for _,v in ipairs(ESPFolder:GetChildren()) do
        v:Destroy()
    end
end

local function rebuildEggESP()
    clearEggESP()
    if not Config.EggESP then return end

    local made=0
    for _,rec in ipairs(readEggs()) do
        if made>=30 then break end
        local rarity=rarityOf(rec)
        if rarity and Config.Targets[rarity] then
            local _,part,obj=recordCFrame(rec)
            part=part or partFromObject(obj)
            if part then
                local h=Instance.new("Highlight")
                h.Name="Egg_"..tostring(rec.Uid)
                h.Adornee=obj or part
                h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
                h.FillTransparency=.72
                h.OutlineTransparency=.1
                h.Parent=ESPFolder

                local bb=Instance.new("BillboardGui")
                bb.Name="Label_"..tostring(rec.Uid)
                bb.Adornee=part
                bb.Size=UDim2.fromOffset(120,32)
                bb.StudsOffset=Vector3.new(0,3,0)
                bb.AlwaysOnTop=true
                bb.Parent=ESPFolder

                local lab=Instance.new("TextLabel")
                lab.Size=UDim2.fromScale(1,1)
                lab.BackgroundTransparency=.25
                lab.BackgroundColor3=C.PANEL2
                lab.TextColor3=C.WHITE
                lab.TextStrokeTransparency=.45
                lab.Text=tostring(rarity)
                lab.Font=Enum.Font.GothamBold
                lab.TextSize=13
                lab.Parent=bb
                corner(lab,7)
                made+=1
            end
        end
    end
end

local function readLiveEggs()
    if not RF_EggLive then return {} end
    local ok,snap=pcall(function() return RF_EggLive:InvokeServer() end)
    if not ok or type(snap)~="table" then return {} end
    local out={}
    local seen={}
    collectRecords(snap,out,seen,0)
    return out
end

--====================================================
-- LOOPS
--====================================================

-- Anti-AFK via VirtualUser/Idled was intentionally removed.

-- Auto rejoin watcher
pcall(function()
    local promptGui=CoreGui:FindFirstChild("RobloxPromptGui")
    local overlay=promptGui and promptGui:FindFirstChild("promptOverlay")
    if overlay then
        overlay.ChildAdded:Connect(function(child)
            if Config.AutoRejoin and G.ShiBuHubRunId==RUN_ID and child.Name=="ErrorPrompt" then
                task.wait(2)
                pcall(function() TeleportService:Teleport(game.PlaceId,LocalPlayer) end)
            end
        end)
    end
end)

-- Status UI loop
task.spawn(function()
    while Gui.Parent and G.ShiBuHubRunId==RUN_ID do
        task.wait(.35)
        local activeAutomation =
            Config.AutoSteal or Config.AutoFeedMonster or Config.AutoClaimMonsterChests
            or Config.AutoTreadmill or Config.AutoUpgradeTreadmill or Config.AutoHatch
            or Config.AutoCollectAway or Config.AutoWearBest or Config.AutoRedeemCodex
            or Config.AutoSellSatchel
        statusText.Text = activeAutomation and ("Queue • "..LastAction) or ("Ready • "..LastAction)
        statusText.TextColor3 = activeAutomation and C.TEAL or C.GREEN
        statusMeta.Text = "Scanned: "..tostring(Scanned).."   •   Target: "..tostring(CurrentTarget)
        if protectText then protectText.Text="Protected: "..targetSummary() end
        if feedInfo then feedInfo.Text="Feed: "..eventFeedSummary() end
        if sp2 then
            sp2.Text="Selected rarities: "..targetSummary().."\nUse the EGGS rarity picker as your keep/protect list."
        end
    end
end)


-- Single gameplay scheduler.
-- All automatic gameplay/server actions run through this dispatcher so
-- Auto-Steal, Hungry Monster, Treadmill, Hatch and progression requests
-- never execute concurrently with each other.
local SchedulerDue={}
local SchedulerMonsterTurn="feed"
local lastFoundUid=nil

local function schedulerDue(name,interval)
    local now=os.clock()
    local at=SchedulerDue[name] or 0
    if now<at then return false end
    SchedulerDue[name]=now+interval
    return true
end

local function schedulerRun(label,fn)
    if FarmBusy then return false,"busy" end
    FarmBusy=true

    local ok,a,b,c=xpcall(fn,function(err)
        if debug and debug.traceback then
            local okTb,tb=pcall(debug.traceback,tostring(err),2)
            if okTb and tb then return tb end
        end
        return tostring(err)
    end)

    FarmBusy=false

    if not ok then
        LastAction=label.." error • "..tostring(a)
        return false,a
    end

    return true,a,b,c
end

local function schedulerHatchOnce()
    local eggs=readLiveEggs()
    if type(eggs)~="table" or #eggs==0 then
        return false,"no eggs"
    end

    -- Small batch: avoid large remote bursts while other automations are active.
    local done=0
    for _,rec in ipairs(eggs) do
        if rec.Uid and done<3 then
            invokeUid(RF_Hatch,rec.Uid)
            task.wait(.12)
            invokeUid(RF_HatchFinish,rec.Uid)
            done+=1
            task.wait(.12)
        end
    end

    if done>0 then
        LastAction="Hatch queue • "..tostring(done).." egg(s)"
        return true,done
    end
    return false,"nothing hatchable"
end

local function schedulerStealOnce()
    local selected=selectedRarities()

    if #selected==0 then
        CurrentTarget="None"
        LastAction="Select at least one rarity"
        return false,"no-rarity"
    end

    local target=bestEgg()

    if target and Config.NotifyTargetFound
        and tostring(target.Record.Uid)~=tostring(lastFoundUid) then

        lastFoundUid=tostring(target.Record.Uid)
        task.spawn(function()
            sendWebhook(
                "Target found • "..tostring(target.Rarity),
                "UID: `"..tostring(target.Record.Uid).."`"
            )
        end)
    end

    if not target then
        CurrentTarget="None"
        LastAction="Searching "..targetSummary()
        return false,"no-target"
    end

    return carryEgg(target)
end

local MonsterActiveCached=false
local MonsterActiveCheckedAt=0

local function schedulerMonsterActive()
    local now=os.clock()
    if now-MonsterActiveCheckedAt<3 then
        return MonsterActiveCached
    end

    MonsterActiveCheckedAt=now
    local snap=monsterSnapshot()
    MonsterActiveCached=snap and snap.Event and snap.Event.Active==true or false
    return MonsterActiveCached
end

task.spawn(function()
    while Gui.Parent and G.ShiBuHubRunId==RUN_ID do
        task.wait(.18)

        -- Clear ESP without a server request when disabled.
        if not Config.EggESP and #ESPFolder:GetChildren()>0 then
            clearEggESP()
        end

        if FarmBusy then
            continue
        end

        local acted=false

        -- Hungry Monster uses one alternating lane when both functions are on.
        if Config.AutoFeedMonster and Config.AutoClaimMonsterChests
            and schedulerDue("monster_combo",1.0) then

            if SchedulerMonsterTurn=="feed" then
                SchedulerMonsterTurn="chest"
                schedulerRun("Hungry Monster feed",autoFeedCycle)
            else
                SchedulerMonsterTurn="feed"
                schedulerRun("Hungry Monster chest",autoClaimMonsterChestCycle)
            end
            acted=true

        elseif Config.AutoFeedMonster and schedulerDue("monster_feed",1.25) then
            schedulerRun("Hungry Monster feed",autoFeedCycle)
            acted=true

        elseif Config.AutoClaimMonsterChests and schedulerDue("monster_chest",3.2) then
            schedulerRun("Hungry Monster chest",autoClaimMonsterChestCycle)
            acted=true
        end

        -- Progression maintenance gets a chance before the long Auto-Steal cycle.
        if not acted and Config.AutoUpgradeTreadmill and schedulerDue("tread_upgrade",5) then
            local info=nextTreadmillUpgrade()
            if info and info.Affordable then
                schedulerRun("Treadmill upgrade",function()
                    local ok,res,detail=upgradeTreadmillOnce()
                    if ok then
                        LastAction="Treadmill upgraded • "..tostring(detail and detail.Id or "?")
                    elseif detail then
                        LastAction="Treadmill upgrade • "..tostring(detail)
                    end
                    return ok,res,detail
                end)
                acted=true
            end
        end

        if not acted and Config.AutoHatch and schedulerDue("hatch",3.25) then
            schedulerRun("Auto Hatch",schedulerHatchOnce)
            acted=true
        end

        if not acted and Config.AutoCollectAway and schedulerDue("away",32) then
            schedulerRun("Away Earnings",function()
                return invokeRemote(RF_AwayCollect)
            end)
            acted=true
        end

        if not acted and Config.AutoWearBest and schedulerDue("wear_best",22) then
            schedulerRun("Wear Best",function()
                return invokeRemote(RF_WearBest)
            end)
            acted=true
        end

        if not acted and Config.AutoRedeemCodex and schedulerDue("codex",47) then
            schedulerRun("Codex",function()
                return invokeRemote(RF_CodexAll)
            end)
            acted=true
        end

        if not acted and Config.AutoSellSatchel and schedulerDue("sell",32) then
            schedulerRun("Sell Satchel",function()
                return invokeRemote(RF_SatchelSale)
            end)
            acted=true
        end

        -- ESP snapshot is also serialized because readEggs() invokes the server.
        if not acted and Config.EggESP and schedulerDue("esp",2.25) then
            schedulerRun("Egg ESP",function()
                rebuildEggESP()
                return true
            end)
            acted=true
        end

        -- Priority event mode pauses normal stealing only while the event is active.
        if not acted and Config.AutoSteal and schedulerDue("steal",.75) then
            local eventPriority=false
            if Config.PriorityHungryMonster
                and (Config.AutoFeedMonster or Config.AutoClaimMonsterChests) then
                eventPriority=schedulerMonsterActive()
            end

            if eventPriority then
                LastAction="Hungry Monster priority • normal steal paused"
            else
                schedulerRun("Auto Steal",schedulerStealOnce)
            end
            acted=true
        end

        -- Treadmill runs only when the longer farming jobs are disabled.
        if not acted and Config.AutoTreadmill
            and not Config.AutoSteal
            and not Config.AutoFeedMonster
            and not Config.AutoClaimMonsterChests
            and schedulerDue("treadmill",1.4) then

            schedulerRun("Treadmill",function()
                local worked,msg=autoTreadmillStep()
                LastAction="Treadmill • "..tostring(msg)
                return worked,msg
            end)
            acted=true
        end

        -- Small gap between dispatched actions. This is for state settling and
        -- to keep independent systems from racing each other.
        if acted then
            task.wait(.22)
        end
    end
end)

setPage("EGGS")
LastAction="Passive boot • VirtualUser/Idled removed"
print("[ShiBuHub] v2.3.3 COMPILE FIX loaded")


pcall(function()
    _G.ShiBuHubReady=true
end)

]======]

local done=false
local runOk=false
local runErr=nil

task.spawn(function()
    progress(18,"Đang kiểm tra script...","Đang compile module chính.")
    task.wait(.03)

    local fn,compileErr=loadstring(SOURCE)
    if not fn then
        runErr="COMPILE ERROR:\n"..tostring(compileErr)
        done=true
        return
    end

    progress(34,"Đang tải giao diện...","Khởi tạo HOME / EGGS / PROGRESSION / EVENT / SELL / WEBHOOK / SETTINGS.")
    task.wait(.03)

    local ok,err=xpcall(fn,function(e)
        local msg=tostring(e)
        if debug and debug.traceback then
            local okTb,tb=pcall(debug.traceback,msg,2)
            if okTb and tb then return tb end
        end
        return msg
    end)

    runOk=ok
    runErr=err
    done=true
end)

-- Smooth loading animation while the inner script initializes.
local simulated=34
while not done do
    simulated=math.min(92,simulated+math.random(1,3))
    local msg="Đang khởi tạo module..."
    local sub="Đang đồng bộ dữ liệu game."
    if simulated>=55 then
        msg="Đang dựng menu..."
        sub="Đang tạo rarity picker và Hungry Monster controls."
    end
    if simulated>=75 then
        msg="Đang hoàn tất..."
        sub="Đang bật Anti-AFK, status loops và event engine."
    end
    progress(simulated,msg,sub)
    task.wait(.12)
end

if runOk and env.ShiBuHubReady==true then
    progress(100,"Hoàn tất ✓","ShiBuHub đã sẵn sàng.")
    task.wait(.45)
    Loading:Destroy()
elseif runOk then
    -- The script returned normally but did not set Ready; still allow the menu.
    progress(100,"Đã tải xong","Menu đã được khởi tạo.")
    task.wait(.45)
    Loading:Destroy()
else
    progress(100,"KHÔNG THỂ MỞ MENU","Nhấn COPY ERROR rồi gửi lỗi cho mình.")
    fill.BackgroundColor3=Color3.fromRGB(255,88,112)
    pct.TextColor3=Color3.fromRGB(255,116,135)

    card.Size=UDim2.new(.82,0,0,310)
    detail.Position=UDim2.fromOffset(24,150)
    detail.Size=UDim2.new(1,-48,0,92)
    detail.TextColor3=Color3.fromRGB(255,188,198)
    detail.TextWrapped=true
    detail.Text=tostring(runErr or "Unknown initialization error")

    local copy=Instance.new("TextButton")
    copy.Position=UDim2.new(0,24,1,-52)
    copy.Size=UDim2.new(.5,-30,0,36)
    copy.BackgroundColor3=Color3.fromRGB(14,48,58)
    copy.BorderSizePixel=0
    copy.Font=Enum.Font.GothamBold
    copy.TextSize=12
    copy.TextColor3=Color3.fromRGB(230,250,248)
    copy.Text="COPY ERROR"
    copy.ZIndex=5004
    copy.Parent=card
    Instance.new("UICorner",copy).CornerRadius=UDim.new(0,9)

    local close=Instance.new("TextButton")
    close.Position=UDim2.new(.5,6,1,-52)
    close.Size=UDim2.new(.5,-30,0,36)
    close.BackgroundColor3=Color3.fromRGB(55,25,36)
    close.BorderSizePixel=0
    close.Font=Enum.Font.GothamBold
    close.TextSize=12
    close.TextColor3=Color3.fromRGB(255,205,215)
    close.Text="CLOSE"
    close.ZIndex=5004
    close.Parent=card
    Instance.new("UICorner",close).CornerRadius=UDim.new(0,9)

    copy.MouseButton1Click:Connect(function()
        local e=tostring(runErr or "Unknown error")
        if setclipboard then
            pcall(setclipboard,e)
            copy.Text="COPIED ✓"
        elseif writefile then
            pcall(writefile,"ShiBuHub_Load_Error.txt",e)
            copy.Text="SAVED ✓"
        else
            copy.Text="NO COPY API"
        end
    end)

    close.MouseButton1Click:Connect(function()
        Loading:Destroy()
    end)
end
