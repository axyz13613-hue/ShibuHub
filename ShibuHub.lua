--[[
    ShiBu HUB - SINGLE FILE RELEASE
    Upload only this file to GitHub.
    Run it directly with loadstring(game:HttpGet(RAW_URL))()
]]

--[[
    ShiBu HUB v1.6
    GitHub-ready consolidated release
    UI + Rare Egg priority + Event Egg fallback + Map scanner + Anti-AFK

    Brand: ShiBu HUB
    Theme: Dark / Cyan / Mint
    NOTE:
      - Replace LOGO with your uploaded Roblox image/decal asset ID.
      - "Security" here means duplicate-run protection + error handling.
      - This script does NOT bypass anti-cheat systems.
      - Egg detection/pickup is generic. Some games may require exact Workspace/Remote paths.
]]

if getgenv and getgenv().ShiBuHUB_Loaded then
    warn("[ShiBu HUB] Already loaded.")
    return
end

if getgenv then
    getgenv().ShiBuHUB_Loaded = true
end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

--========================================================
-- CONFIG
--========================================================

local CONFIG = {
    Brand = "ShiBu HUB",
    Version = "1.6.0",

    -- Upload your logo to Roblox and replace this:
    LOGO = "rbxassetid://0",

    Theme = {
        BG = Color3.fromRGB(7, 10, 14),
        Panel = Color3.fromRGB(12, 17, 22),
        Card = Color3.fromRGB(16, 23, 29),
        Card2 = Color3.fromRGB(20, 29, 36),

        Accent = Color3.fromRGB(32, 230, 202),
        Accent2 = Color3.fromRGB(75, 240, 145),

        Text = Color3.fromRGB(245, 248, 250),
        SubText = Color3.fromRGB(160, 177, 189),
        Stroke = Color3.fromRGB(35, 73, 84),

        Danger = Color3.fromRGB(255, 94, 111),
    }
}

local T = CONFIG.Theme

--========================================================
-- EGG MODULE
--========================================================

local Egg = {
    Enabled = false,
    AntiAFK = true,
    ReturnAfterPickup = true,
    AutoSaveReturn = true,

    -- Multiple selected Rare egg names, checked in this order.
    SelectedRareEggs = {"Cosmic"},
    SelectedEgg = "Cosmic", -- compatibility / first selected Rare
    ReturnCFrame = nil,

    TeleportDelay = 0.12,
    PickupWait = 0.40,
    ReturnDelay = 0.12,
    SearchDelay = 0.22,

    Busy = false,
    LastStatus = "Idle",
}

-- Event eggs are handled only when no selected rare egg is currently available.
local EventEgg = {
    Enabled = false,
    SelectedEgg = "Event",
    LastStatus = "Idle",
}

local FarmState = {
    Busy = false,
    CurrentType = "Idle",
}

-- Strict Rare priority:
-- Rare eggs spawn randomly and the amount is NOT assumed or capped.
-- ShiBu HUB keeps taking Rare eggs for as long as any selected Rare egg exists.
-- Event eggs are allowed only after several consecutive Rare scans find nothing.
-- After every Event pickup, Rare priority is checked again immediately.
local RarePriority = {
    Misses = 0,
    MissesBeforeEvent = 3, -- consecutive empty Rare scans before Event is allowed
    CollectedSinceEvent = 0,
}

local EggScanner = {
    AutoRescan = false,
    RescanInterval = 3.0,
    LastScan = 0,
    Detected = {},
    LastCount = 0,
}

local function log(...)
    print("[ShiBu HUB]", ...)
end

local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getRoot()
    local char = getCharacter()
    return char:FindFirstChild("HumanoidRootPart")
        or char:WaitForChild("HumanoidRootPart")
end

local function normalize(str)
    str = tostring(str or ""):lower()
    str = str:gsub("%s+", " ")
    return str
end

local function targetMatchesFor(text, wantedName)
    local target = normalize(wantedName)
    local source = normalize(text)

    if target == "" or source == "" then
        return false
    end

    return source:find(target, 1, true) ~= nil
end

local function targetMatches(text)
    return targetMatchesFor(text, Egg.SelectedEgg)
end

local function nearestPart(instance)
    if not instance then
        return nil
    end

    if instance:IsA("BasePart") then
        return instance
    end

    if instance:IsA("Model") then
        return instance.PrimaryPart
            or instance:FindFirstChild("HumanoidRootPart", true)
            or instance:FindFirstChildWhichIsA("BasePart", true)
    end

    local current = instance
    while current and current ~= Workspace do
        if current:IsA("BasePart") then
            return current
        end

        if current:IsA("Model") then
            local p = current.PrimaryPart
                or current:FindFirstChild("HumanoidRootPart", true)
                or current:FindFirstChildWhichIsA("BasePart", true)

            if p then
                return p
            end
        end

        current = current.Parent
    end

    return nil
end

local function findTargetByName(wantedName)
    local best = nil
    local bestScore = -math.huge
    local wanted = normalize(wantedName)

    if wanted == "" then
        return nil
    end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local name = normalize(obj.Name)

            if name:find(wanted, 1, true) then
                local score = 0

                if name == wanted then
                    score += 100
                else
                    score += 60
                end

                if name:find("egg", 1, true) or name:find("ovo", 1, true) then
                    score += 25
                end

                local parentName = normalize(obj.Parent and obj.Parent.Name or "")
                if parentName:find("egg", 1, true) or parentName:find("ovo", 1, true) then
                    score += 10
                end

                local p = nearestPart(obj)
                if p and p:IsDescendantOf(Workspace) and score > bestScore then
                    bestScore = score
                    best = p
                end
            end
        end
    end

    if best then
        return best
    end

    -- Billboard/Text fallback.
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            local ok, uiText = pcall(function()
                return obj.Text
            end)

            if ok and targetMatchesFor(uiText, wantedName) then
                local p = nearestPart(obj)
                if p and p:IsDescendantOf(Workspace) then
                    return p
                end
            end
        end
    end

    return nil
end

local function parseRareList(value)
    local list = {}

    if typeof(value) == "table" then
        for _, name in ipairs(value) do
            name = tostring(name or ""):gsub("^%s+", ""):gsub("%s+$", "")
            if name ~= "" then
                table.insert(list, name)
            end
        end
    else
        for chunk in tostring(value or ""):gmatch("[^,;\n]+") do
            local name = chunk:gsub("^%s+", ""):gsub("%s+$", "")
            if name ~= "" then
                table.insert(list, name)
            end
        end
    end

    if #list == 0 then
        table.insert(list, "Cosmic")
    end

    return list
end

local function findSelectedRareEgg()
    Egg.SelectedRareEggs = parseRareList(Egg.SelectedRareEggs)

    -- The order in SelectedRareEggs is also the priority order.
    for _, rareName in ipairs(Egg.SelectedRareEggs) do
        local target = findTargetByName(rareName)
        if target then
            Egg.SelectedEgg = rareName
            return target, rareName
        end
    end

    return nil, nil
end

local function findEgg()
    local target = findSelectedRareEgg()
    return target
end

local function findEventEgg()
    return findTargetByName(EventEgg.SelectedEgg)
end


local function looksLikeEggName(name)
    local n = normalize(name)
    if n == "" then
        return false
    end

    return n:find("egg", 1, true) ~= nil
        or n:find("ovo", 1, true) ~= nil
        or n:find("trung", 1, true) ~= nil
end

local function cleanDetectedName(name)
    name = tostring(name or "")
    name = name:gsub("^%s+", ""):gsub("%s+$", "")
    name = name:gsub("%s+", " ")
    return name
end

local function scanEggCandidates()
    local found = {}
    local seen = {}

    local function push(name)
        name = cleanDetectedName(name)
        local key = normalize(name)

        if name ~= "" and not seen[key] then
            seen[key] = true
            table.insert(found, name)
        end
    end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if (obj:IsA("Model") or obj:IsA("BasePart")) and looksLikeEggName(obj.Name) then
            push(obj.Name)
        elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
            local ok, uiText = pcall(function()
                return obj.Text
            end)

            if ok and looksLikeEggName(uiText) then
                push(uiText)
            end
        end
    end

    table.sort(found, function(a, b)
        return normalize(a) < normalize(b)
    end)

    EggScanner.Detected = found
    EggScanner.LastCount = #found
    EggScanner.LastScan = os.clock()

    return found
end

local function detectedEggsText(limit)
    limit = limit or 18

    if #EggScanner.Detected == 0 then
        return "No egg-like names detected yet."
    end

    local out = {}
    local maxItems = math.min(#EggScanner.Detected, limit)

    for i = 1, maxItems do
        table.insert(out, "• " .. EggScanner.Detected[i])
    end

    if #EggScanner.Detected > limit then
        table.insert(out, "... +" .. tostring(#EggScanner.Detected - limit) .. " more")
    end

    return table.concat(out, "\\n")
end

local function stopVelocity(root)
    pcall(function()
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end)
end

local function teleport(cf)
    local root = getRoot()
    root.CFrame = cf
    stopVelocity(root)
end

local function saveReturnPosition()
    Egg.ReturnCFrame = getRoot().CFrame
    Egg.LastStatus = "Return position saved"
    log(Egg.LastStatus)
end

local function interact(part)
    if not part or not part:IsDescendantOf(Workspace) then
        return false
    end

    local rootContainer = part.Parent or part

    local prompt = rootContainer:FindFirstChildWhichIsA("ProximityPrompt", true)
    if prompt and fireproximityprompt then
        local ok = pcall(function()
            fireproximityprompt(prompt)
        end)

        if ok then
            return true
        end
    end

    local detector = rootContainer:FindFirstChildWhichIsA("ClickDetector", true)
    if detector and fireclickdetector then
        local ok = pcall(function()
            fireclickdetector(detector)
        end)

        if ok then
            return true
        end
    end

    if firetouchinterest then
        local root = getRoot()

        local ok = pcall(function()
            firetouchinterest(root, part, 0)
            task.wait(0.03)
            firetouchinterest(root, part, 1)
        end)

        if ok then
            return true
        end
    end

    return false
end

local function farmTarget(target, targetName, targetType)
    if not target or not target:IsDescendantOf(Workspace) then
        return false
    end

    FarmState.Busy = true
    Egg.Busy = true
    FarmState.CurrentType = targetType

    local ok, err = pcall(function()
        if not Egg.ReturnCFrame then
            saveReturnPosition()
        end

        local statusText = "Teleporting to " .. targetType .. ": " .. targetName

        if targetType == "Rare Egg" then
            Egg.LastStatus = statusText
        else
            EventEgg.LastStatus = statusText
        end

        teleport(target.CFrame * CFrame.new(0, 2.8, 0))
        task.wait(Egg.TeleportDelay)

        local picked = interact(target)

        if not picked and target:IsDescendantOf(Workspace) then
            teleport(target.CFrame)
        end

        if targetType == "Rare Egg" then
            Egg.LastStatus = "Pickup attempt: " .. targetName
        else
            EventEgg.LastStatus = "Pickup attempt: " .. targetName
        end

        task.wait(Egg.PickupWait)

        if Egg.ReturnAfterPickup and Egg.ReturnCFrame then
            if targetType == "Rare Egg" then
                Egg.LastStatus = "Returning to base"
            else
                EventEgg.LastStatus = "Returning to base"
            end

            task.wait(Egg.ReturnDelay)
            teleport(Egg.ReturnCFrame)
        end

        if targetType == "Rare Egg" then
            Egg.LastStatus = "Rare egg done"
        else
            EventEgg.LastStatus = "Event egg done"
        end
    end)

    if not ok then
        if targetType == "Rare Egg" then
            Egg.LastStatus = "Error"
        else
            EventEgg.LastStatus = "Error"
        end
        warn("[ShiBu HUB] Farm error:", err)
    end

    FarmState.CurrentType = "Idle"
    Egg.Busy = false
    FarmState.Busy = false

    return ok
end

local function priorityFarmStep()
    if FarmState.Busy then
        return
    end

    --====================================================
    -- PRIORITY 1: RARE EGGS ALWAYS COME FIRST
    --====================================================
    if Egg.Enabled then
        local rareTarget, rareName = findSelectedRareEgg()

        if rareTarget then
            RarePriority.Misses = 0
            RarePriority.CollectedSinceEvent += 1

            Egg.LastStatus =
                "Rare priority: taking #"
                .. tostring(RarePriority.CollectedSinceEvent)
                .. " (" .. tostring(rareName) .. ")"

            farmTarget(rareTarget, rareName, "Rare Egg")
            return
        end

        -- Only when NONE of the selected Rare types are currently found
        -- do we count this as an empty Rare scan.
        RarePriority.Misses += 1

        Egg.LastStatus =
            "No selected Rare found "
            .. tostring(RarePriority.Misses)
            .. "/"
            .. tostring(RarePriority.MissesBeforeEvent)
    else
        -- If Rare farming is disabled, Event may run immediately.
        RarePriority.Misses = RarePriority.MissesBeforeEvent
    end

    -- Event is blocked until Rare has been absent for enough consecutive scans.
    if RarePriority.Misses < RarePriority.MissesBeforeEvent then
        return
    end

    --====================================================
    -- PRIORITY 2: EVENT EGGS
    --====================================================
    if EventEgg.Enabled then
        local eventTarget = findEventEgg()

        if eventTarget then
            EventEgg.LastStatus =
                "No Rare currently found -> taking Event egg"

            farmTarget(eventTarget, EventEgg.SelectedEgg, "Event Egg")

            -- Important:
            -- after ONE Event pickup, force Rare priority again.
            -- If a new rare egg appeared while collecting Event,
            -- it will be handled before the next Event egg.
            RarePriority.Misses = 0
            RarePriority.CollectedSinceEvent = 0
            return
        end

        EventEgg.LastStatus =
            "Rare currently clear, searching Event: "
            .. EventEgg.SelectedEgg
    end
end

task.spawn(function()
    while task.wait(Egg.SearchDelay) do
        priorityFarmStep()
    end
end)

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    if not Egg.AntiAFK then
        return
    end

    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

--========================================================
-- GUI HELPERS
--========================================================

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or T.Stroke
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = parent
    return s
end

local function padding(parent, px)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, px)
    p.PaddingBottom = UDim.new(0, px)
    p.PaddingLeft = UDim.new(0, px)
    p.PaddingRight = UDim.new(0, px)
    p.Parent = parent
    return p
end

local function label(parent, text, size, color, font)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or T.Text
    l.Font = font or Enum.Font.Gotham
    l.TextSize = size or 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.Parent = parent
    return l
end

local function button(parent, text)
    local b = Instance.new("TextButton")
    b.AutoButtonColor = false
    b.BackgroundColor3 = T.Card2
    b.Text = text
    b.TextColor3 = T.Text
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 14
    b.Parent = parent
    corner(b, 9)
    stroke(b, T.Stroke, 1, 0.2)

    b.MouseEnter:Connect(function()
        TweenService:Create(
            b,
            TweenInfo.new(0.15),
            {BackgroundColor3 = Color3.fromRGB(25, 42, 49)}
        ):Play()
    end)

    b.MouseLeave:Connect(function()
        TweenService:Create(
            b,
            TweenInfo.new(0.15),
            {BackgroundColor3 = T.Card2}
        ):Play()
    end)

    return b
end

local function createToggle(parent, titleText, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = T.Card
    frame.Size = UDim2.new(1, 0, 0, 54)
    frame.Parent = parent
    corner(frame, 10)
    stroke(frame, T.Stroke, 1, 0.35)

    local title = label(frame, titleText, 14, T.Text, Enum.Font.GothamMedium)
    title.Position = UDim2.new(0, 14, 0, 0)
    title.Size = UDim2.new(1, -90, 1, 0)

    local switch = Instance.new("TextButton")
    switch.AutoButtonColor = false
    switch.Text = ""
    switch.Size = UDim2.fromOffset(48, 26)
    switch.Position = UDim2.new(1, -62, 0.5, -13)
    switch.BackgroundColor3 = defaultState and T.Accent2 or Color3.fromRGB(53, 62, 68)
    switch.Parent = frame
    corner(switch, 99)

    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(20, 20)
    dot.Position = defaultState and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
    dot.BackgroundColor3 = Color3.fromRGB(245, 248, 250)
    dot.Parent = switch
    corner(dot, 99)

    local state = defaultState

    local function render()
        TweenService:Create(
            switch,
            TweenInfo.new(0.16),
            {BackgroundColor3 = state and T.Accent2 or Color3.fromRGB(53, 62, 68)}
        ):Play()

        TweenService:Create(
            dot,
            TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = state and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)}
        ):Play()
    end

    switch.MouseButton1Click:Connect(function()
        state = not state
        render()

        if callback then
            callback(state)
        end
    end)

    return {
        Frame = frame,
        Get = function() return state end,
        Set = function(v)
            state = v == true
            render()
            if callback then callback(state) end
        end,
    }
end

local function createInput(parent, titleText, placeholder, defaultText, callback)
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = T.Card
    frame.Size = UDim2.new(1, 0, 0, 70)
    frame.Parent = parent
    corner(frame, 10)
    stroke(frame, T.Stroke, 1, 0.35)

    local title = label(frame, titleText, 13, T.SubText, Enum.Font.GothamMedium)
    title.Position = UDim2.new(0, 14, 0, 5)
    title.Size = UDim2.new(1, -28, 0, 22)

    local box = Instance.new("TextBox")
    box.BackgroundColor3 = T.Card2
    box.Position = UDim2.new(0, 12, 0, 31)
    box.Size = UDim2.new(1, -24, 0, 28)
    box.PlaceholderText = placeholder
    box.Text = defaultText or ""
    box.TextColor3 = T.Text
    box.PlaceholderColor3 = T.SubText
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.ClearTextOnFocus = false
    box.Parent = frame
    corner(box, 7)
    stroke(box, T.Stroke, 1, 0.45)
    padding(box, 8)

    box.FocusLost:Connect(function()
        if callback then
            callback(box.Text)
        end
    end)

    return box
end

--========================================================
-- ROOT GUI
--========================================================

pcall(function()
    local old = CoreGui:FindFirstChild("ShiBuHUB")
    if old then
        old:Destroy()
    end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "ShiBuHUB"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local parentTarget = CoreGui
if gethui then
    local ok, result = pcall(gethui)
    if ok and result then
        parentTarget = result
    end
end
gui.Parent = parentTarget

local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.fromOffset(760, 470)
main.BackgroundColor3 = T.BG
main.Parent = gui
main.ClipsDescendants = true
corner(main, 18)
stroke(main, T.Accent, 1, 0.45)

-- Shadow
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.fromScale(0.5, 0.5)
shadow.Size = UDim2.new(1, 60, 1, 60)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageTransparency = 0.55
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.ZIndex = 0
shadow.Parent = main

--========================================================
-- TOP BAR
--========================================================

local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 76)
top.BackgroundColor3 = Color3.fromRGB(9, 14, 19)
top.Parent = main
corner(top, 18)

local topMask = Instance.new("Frame")
topMask.Size = UDim2.new(1, 0, 0, 20)
topMask.Position = UDim2.new(0, 0, 1, -20)
topMask.BackgroundColor3 = top.BackgroundColor3
topMask.BorderSizePixel = 0
topMask.Parent = top

local logo = Instance.new("ImageLabel")
logo.BackgroundColor3 = T.Card2
logo.Position = UDim2.fromOffset(18, 12)
logo.Size = UDim2.fromOffset(52, 52)
logo.Image = CONFIG.LOGO
logo.Parent = top
corner(logo, 14)
stroke(logo, T.Accent, 1, 0.25)

local brand = label(top, CONFIG.Brand, 25, T.Text, Enum.Font.GothamBold)
brand.Position = UDim2.fromOffset(84, 13)
brand.Size = UDim2.new(0, 220, 0, 30)

local sub = label(top, "Cloud-tech automation interface", 12, T.SubText, Enum.Font.Gotham)
sub.Position = UDim2.fromOffset(86, 42)
sub.Size = UDim2.new(0, 300, 0, 20)

local version = label(top, "v" .. CONFIG.Version, 11, T.Accent, Enum.Font.GothamMedium)
version.TextXAlignment = Enum.TextXAlignment.Right
version.Position = UDim2.new(1, -210, 0, 15)
version.Size = UDim2.fromOffset(120, 24)

local minimize = button(top, "—")
minimize.Size = UDim2.fromOffset(34, 30)
minimize.Position = UDim2.new(1, -82, 0, 20)

local close = button(top, "×")
close.Size = UDim2.fromOffset(34, 30)
close.Position = UDim2.new(1, -42, 0, 20)

--========================================================
-- SIDEBAR
--========================================================

local sidebar = Instance.new("Frame")
sidebar.Position = UDim2.fromOffset(0, 76)
sidebar.Size = UDim2.new(0, 164, 1, -76)
sidebar.BackgroundColor3 = Color3.fromRGB(9, 14, 18)
sidebar.Parent = main

local sideTitle = label(sidebar, "SHIBU", 10, T.SubText, Enum.Font.GothamBold)
sideTitle.Position = UDim2.fromOffset(16, 13)
sideTitle.Size = UDim2.new(1, -32, 0, 18)

local sideList = Instance.new("Frame")
sideList.BackgroundTransparency = 1
sideList.Position = UDim2.fromOffset(10, 42)
sideList.Size = UDim2.new(1, -20, 0, 302)
sideList.Parent = sidebar

local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, 7)
sideLayout.Parent = sideList

--========================================================
-- CONTENT
--========================================================

local content = Instance.new("Frame")
content.BackgroundTransparency = 1
content.Position = UDim2.fromOffset(164, 76)
content.Size = UDim2.new(1, -164, 1, -76)
content.Parent = main

local pages = {}
local tabs = {}

local function makePage(name, titleText, description)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.BackgroundTransparency = 1
    page.Position = UDim2.fromOffset(18, 14)
    page.Size = UDim2.new(1, -36, 1, -28)
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = T.Accent
    page.CanvasSize = UDim2.new()
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = content

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 10)
    list.Parent = page

    local header = Instance.new("Frame")
    header.BackgroundTransparency = 1
    header.Size = UDim2.new(1, -6, 0, 54)
    header.Parent = page

    local h = label(header, titleText, 22, T.Text, Enum.Font.GothamBold)
    h.Size = UDim2.new(1, 0, 0, 28)

    local d = label(header, description, 12, T.SubText, Enum.Font.Gotham)
    d.Position = UDim2.fromOffset(0, 30)
    d.Size = UDim2.new(1, 0, 0, 20)

    pages[name] = page
    return page
end

local function selectTab(name)
    for tabName, page in pairs(pages) do
        page.Visible = tabName == name
    end

    for tabName, btn in pairs(tabs) do
        local selected = tabName == name
        TweenService:Create(
            btn,
            TweenInfo.new(0.15),
            {
                BackgroundColor3 = selected and Color3.fromRGB(16, 49, 51) or Color3.fromRGB(12, 18, 23),
                TextColor3 = selected and T.Accent or T.SubText,
            }
        ):Play()
    end
end

local function addTab(name, text)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Size = UDim2.new(1, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(12, 18, 23)
    b.Text = "  " .. text
    b.TextColor3 = T.SubText
    b.TextSize = 13
    b.Font = Enum.Font.GothamMedium
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.AutoButtonColor = false
    b.Parent = sideList
    corner(b, 9)

    b.MouseButton1Click:Connect(function()
        selectTab(name)
    end)

    tabs[name] = b
    return b
end

addTab("Autofarm", "⚡  Autofarm")
addTab("Egg",      "🥚  Egg")
addTab("Event",    "★  Event")
addTab("Player",   "◉  Player")
addTab("Shop",     "▣  Shop")
addTab("Misc",     "◇  Misc")
addTab("Settings", "⚙  Settings")

--========================================================
-- AUTOFARM PAGE
--========================================================

local autoPage = makePage(
    "Autofarm",
    "Autofarm",
    "Quick controls for ShiBu HUB."
)

local statusCard = Instance.new("Frame")
statusCard.BackgroundColor3 = T.Card
statusCard.Size = UDim2.new(1, -6, 0, 110)
statusCard.Parent = autoPage
corner(statusCard, 12)
stroke(statusCard, T.Accent, 1, 0.55)

local welcome = label(statusCard, "Welcome to ShiBu HUB", 18, T.Text, Enum.Font.GothamBold)
welcome.Position = UDim2.fromOffset(16, 12)
welcome.Size = UDim2.new(1, -32, 0, 28)

local info = label(
    statusCard,
    "All selected Rare egg types have priority; Event runs only when none of them are currently found.",
    12,
    T.SubText,
    Enum.Font.Gotham
)
info.Position = UDim2.fromOffset(16, 42)
info.Size = UDim2.new(1, -32, 0, 22)

local liveStatus = label(statusCard, "Status: Ready", 13, T.Accent2, Enum.Font.GothamMedium)
liveStatus.Position = UDim2.fromOffset(16, 72)
liveStatus.Size = UDim2.new(1, -32, 0, 22)

createToggle(autoPage, "Anti AFK", Egg.AntiAFK, function(state)
    Egg.AntiAFK = state
end)

createToggle(autoPage, "Auto Rare Egg", Egg.Enabled, function(state)
    Egg.Enabled = state

    if state and Egg.AutoSaveReturn then
        saveReturnPosition()
    end

    liveStatus.Text = state
        and ("Status: Farming " .. Egg.SelectedEgg)
        or "Status: Ready"
end)

--========================================================
-- EGG PAGE
--========================================================

local eggPage = makePage(
    "Egg",
    "Egg Teleport",
    "Scan the map, choose Rare egg names, then ShiBu HUB gives those Rare types strict priority over Event eggs."
)

createInput(
    eggPage,
    "Selected Rare Eggs (comma-separated)",
    "Example: Cosmic, Secret, Mythic",
    table.concat(Egg.SelectedRareEggs, ", "),
    function(text)
        local list = parseRareList(text)
        Egg.SelectedRareEggs = list
        Egg.SelectedEgg = list[1]
        RarePriority.Misses = 0
        Egg.LastStatus = "Rare list updated: " .. table.concat(list, ", ")
    end
)


local detectedCard = Instance.new("Frame")
detectedCard.BackgroundColor3 = T.Card
detectedCard.Size = UDim2.new(1, -6, 0, 152)
detectedCard.Parent = eggPage
corner(detectedCard, 10)
stroke(detectedCard, T.Stroke, 1, 0.35)

local detectedTitle = label(
    detectedCard,
    "Detected Egg Candidates",
    13,
    T.Accent,
    Enum.Font.GothamBold
)
detectedTitle.Position = UDim2.fromOffset(14, 8)
detectedTitle.Size = UDim2.new(1, -28, 0, 22)

local detectedListLabel = label(
    detectedCard,
    "Press Scan Map Eggs to detect egg-like names.",
    11,
    T.SubText,
    Enum.Font.Gotham
)
detectedListLabel.Position = UDim2.fromOffset(14, 31)
detectedListLabel.Size = UDim2.new(1, -28, 0, 78)
detectedListLabel.TextWrapped = true
detectedListLabel.TextYAlignment = Enum.TextYAlignment.Top

local scanMapButton = button(detectedCard, "Scan Map Eggs")
scanMapButton.Size = UDim2.new(0.48, 0, 0, 31)
scanMapButton.Position = UDim2.new(0, 14, 1, -40)

local copyDetectedButton = button(detectedCard, "Use Detected as Rare List")
copyDetectedButton.Size = UDim2.new(0.48, -14, 0, 31)
copyDetectedButton.Position = UDim2.new(0.52, 0, 1, -40)

scanMapButton.MouseButton1Click:Connect(function()
    local items = scanEggCandidates()
    detectedTitle.Text = "Detected Egg Candidates (" .. tostring(#items) .. ")"
    detectedListLabel.Text = detectedEggsText(8)
    Egg.LastStatus = "Map scan found " .. tostring(#items) .. " egg-like names"
end)

copyDetectedButton.MouseButton1Click:Connect(function()
    if #EggScanner.Detected == 0 then
        scanEggCandidates()
    end

    if #EggScanner.Detected > 0 then
        -- This is only a convenience shortcut. The user can still edit the list manually.
        Egg.SelectedRareEggs = parseRareList(EggScanner.Detected)
        Egg.SelectedEgg = Egg.SelectedRareEggs[1]
        RarePriority.Misses = 0
        Egg.LastStatus = "Rare list set from detected candidates"
    else
        Egg.LastStatus = "No detected egg candidates to use"
    end
end)

createToggle(eggPage, "Auto Rescan Egg Names", EggScanner.AutoRescan, function(state)
    EggScanner.AutoRescan = state
    EggScanner.LastScan = 0
end)

createInput(
    eggPage,
    "Auto Rescan Interval (seconds)",
    "Default: 3",
    tostring(EggScanner.RescanInterval),
    function(text)
        local n = tonumber(text)
        if n then
            EggScanner.RescanInterval = math.clamp(n, 1, 30)
        end
    end
)

createToggle(eggPage, "Auto Rare Egg", Egg.Enabled, function(state)
    Egg.Enabled = state

    if state and Egg.AutoSaveReturn then
        saveReturnPosition()
    end
end)

createToggle(eggPage, "Return After Pickup", Egg.ReturnAfterPickup, function(state)
    Egg.ReturnAfterPickup = state
end)

createToggle(eggPage, "Save Base When Starting", Egg.AutoSaveReturn, function(state)
    Egg.AutoSaveReturn = state
end)

local savePos = button(eggPage, "Save Return Position")
savePos.Size = UDim2.new(1, -6, 0, 42)
savePos.MouseButton1Click:Connect(saveReturnPosition)

local searchNow = button(eggPage, "Find Selected Egg Now")
searchNow.Size = UDim2.new(1, -6, 0, 42)
searchNow.MouseButton1Click:Connect(function()
    local found = findEgg()

    if found then
        Egg.LastStatus = "Found: " .. found:GetFullName()
        log(Egg.LastStatus)
    else
        Egg.LastStatus = "No matching egg found"
        log(Egg.LastStatus)
    end
end)

createInput(
    eggPage,
    "Teleport Delay (seconds)",
    "0.12",
    tostring(Egg.TeleportDelay),
    function(text)
        local n = tonumber(text)
        if n then
            Egg.TeleportDelay = math.clamp(n, 0.03, 3)
        end
    end
)

local eggStatusCard = Instance.new("Frame")
eggStatusCard.BackgroundColor3 = T.Card
eggStatusCard.Size = UDim2.new(1, -6, 0, 58)
eggStatusCard.Parent = eggPage
corner(eggStatusCard, 10)
stroke(eggStatusCard, T.Stroke, 1, 0.35)

local eggStatus = label(eggStatusCard, "Status: Idle", 12, T.Accent, Enum.Font.GothamMedium)
eggStatus.Position = UDim2.fromOffset(14, 0)
eggStatus.Size = UDim2.new(1, -28, 1, 0)

task.spawn(function()
    while gui.Parent do
        eggStatus.Text = "Status: " .. Egg.LastStatus
        task.wait(0.25)
    end
end)

--========================================================
-- PLACEHOLDER PAGES
--========================================================

local function makePlaceholder(name, titleText, desc)
    local page = makePage(name, titleText, desc)

    local card = Instance.new("Frame")
    card.BackgroundColor3 = T.Card
    card.Size = UDim2.new(1, -6, 0, 110)
    card.Parent = page
    corner(card, 12)
    stroke(card, T.Stroke, 1, 0.35)

    local t1 = label(card, "ShiBu HUB", 17, T.Text, Enum.Font.GothamBold)
    t1.Position = UDim2.fromOffset(16, 16)
    t1.Size = UDim2.new(1, -32, 0, 24)

    local t2 = label(
        card,
        "This tab is ready for game-specific modules.",
        12,
        T.SubText,
        Enum.Font.Gotham
    )
    t2.Position = UDim2.fromOffset(16, 46)
    t2.Size = UDim2.new(1, -32, 0, 24)

    local t3 = label(
        card,
        "No anti-cheat bypass is included.",
        11,
        T.Accent,
        Enum.Font.GothamMedium
    )
    t3.Position = UDim2.fromOffset(16, 75)
    t3.Size = UDim2.new(1, -32, 0, 20)

    return page
end

--========================================================
-- EVENT PAGE
--========================================================

local eventPage = makePage(
    "Event",
    "Event Eggs",
    "All Rare egg types you selected have strict priority. Event eggs run only after repeated scans find none of those selected Rare types."
)

createInput(
    eventPage,
    "Selected Event Egg",
    "Example: Event, Halloween, Christmas...",
    EventEgg.SelectedEgg,
    function(text)
        text = tostring(text or "")
        if text ~= "" then
            EventEgg.SelectedEgg = text
        end
    end
)

createToggle(eventPage, "Auto Event Egg", EventEgg.Enabled, function(state)
    EventEgg.Enabled = state

    if state and Egg.AutoSaveReturn and not Egg.ReturnCFrame then
        saveReturnPosition()
    end
end)

createInput(
    eventPage,
    "Rare Priority Confirmation Scans",
    "Default: 3",
    tostring(RarePriority.MissesBeforeEvent),
    function(text)
        local n = tonumber(text)
        if n then
            RarePriority.MissesBeforeEvent = math.clamp(math.floor(n), 1, 10)
            RarePriority.Misses = 0
        end
    end
)

local priorityCard = Instance.new("Frame")
priorityCard.BackgroundColor3 = T.Card
priorityCard.Size = UDim2.new(1, -6, 0, 78)
priorityCard.Parent = eventPage
corner(priorityCard, 10)
stroke(priorityCard, T.Accent2, 1, 0.35)

local priorityTitle = label(
    priorityCard,
    "Priority: Rare Eggs → Event Eggs",
    14,
    T.Accent2,
    Enum.Font.GothamBold
)
priorityTitle.Position = UDim2.fromOffset(14, 8)
priorityTitle.Size = UDim2.new(1, -28, 0, 24)

local priorityDesc = label(
    priorityCard,
    "ShiBu HUB keeps collecting every selected Rare type with no quantity limit. Only after consecutive scans find none of them may it take one Event egg, then it immediately rechecks all selected Rare types.",
    11,
    T.SubText,
    Enum.Font.Gotham
)
priorityDesc.Position = UDim2.fromOffset(14, 34)
priorityDesc.Size = UDim2.new(1, -28, 0, 34)
priorityDesc.TextWrapped = true

local eventFind = button(eventPage, "Find Event Egg Now")
eventFind.Size = UDim2.new(1, -6, 0, 42)
eventFind.MouseButton1Click:Connect(function()
    local found = findEventEgg()

    if found then
        EventEgg.LastStatus = "Found: " .. found:GetFullName()
        log(EventEgg.LastStatus)
    else
        EventEgg.LastStatus = "No matching event egg found"
        log(EventEgg.LastStatus)
    end
end)

local eventStatusCard = Instance.new("Frame")
eventStatusCard.BackgroundColor3 = T.Card
eventStatusCard.Size = UDim2.new(1, -6, 0, 58)
eventStatusCard.Parent = eventPage
corner(eventStatusCard, 10)
stroke(eventStatusCard, T.Stroke, 1, 0.35)

local eventStatus = label(eventStatusCard, "Status: Idle", 12, T.Accent, Enum.Font.GothamMedium)
eventStatus.Position = UDim2.fromOffset(14, 0)
eventStatus.Size = UDim2.new(1, -28, 1, 0)

task.spawn(function()
    while gui.Parent do
        eventStatus.Text = "Status: " .. EventEgg.LastStatus
        task.wait(0.25)
    end
end)
makePlaceholder("Shop", "Shop", "Shop helper modules.")

task.spawn(function()
    while gui.Parent do
        if EggScanner.AutoRescan then
            local elapsed = os.clock() - EggScanner.LastScan

            if EggScanner.LastScan == 0 or elapsed >= EggScanner.RescanInterval then
                local items = scanEggCandidates()

                if detectedTitle and detectedTitle.Parent then
                    detectedTitle.Text =
                        "Detected Egg Candidates (" .. tostring(#items) .. ")"
                end

                if detectedListLabel and detectedListLabel.Parent then
                    detectedListLabel.Text = detectedEggsText(8)
                end
            end
        end

        task.wait(0.5)
    end
end)

--========================================================
-- PLAYER PAGE
--========================================================

local playerPage = makePage(
    "Player",
    "Player",
    "Useful player/session actions."
)

local rejoin = button(playerPage, "Rejoin Current Server")
rejoin.Size = UDim2.new(1, -6, 0, 42)
rejoin.MouseButton1Click:Connect(function()
    pcall(function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
end)

local serverHop = button(playerPage, "Server Hop")
serverHop.Size = UDim2.new(1, -6, 0, 42)
serverHop.MouseButton1Click:Connect(function()
    pcall(function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
end)

local reset = button(playerPage, "Reset Character")
reset.Size = UDim2.new(1, -6, 0, 42)
reset.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.Health = 0
    end
end)

--========================================================
-- MISC PAGE
--========================================================

local miscPage = makePage(
    "Misc",
    "Misc",
    "Performance and utility options."
)

local originalSettings = {
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd,
}

local fpsBoostEnabled = false

createToggle(miscPage, "FPS Boost", false, function(state)
    fpsBoostEnabled = state

    if state then
        pcall(function()
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 1e9

            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter")
                    or obj:IsA("Trail")
                    or obj:IsA("Smoke")
                    or obj:IsA("Fire")
                    or obj:IsA("Sparkles") then
                    obj.Enabled = false
                end
            end

            if setfpscap then
                setfpscap(60)
            end
        end)
    else
        pcall(function()
            Lighting.GlobalShadows = originalSettings.GlobalShadows
            Lighting.FogEnd = originalSettings.FogEnd
        end)
    end
end)

--========================================================
-- SETTINGS PAGE
--========================================================

local settingsPage = makePage(
    "Settings",
    "Settings",
    "ShiBu HUB interface settings."
)

createToggle(settingsPage, "Anti AFK", Egg.AntiAFK, function(state)
    Egg.AntiAFK = state
end)

local unload = button(settingsPage, "Unload ShiBu HUB")
unload.Size = UDim2.new(1, -6, 0, 42)
unload.BackgroundColor3 = Color3.fromRGB(48, 20, 25)

unload.MouseButton1Click:Connect(function()
    Egg.Enabled = false

    if getgenv then
        getgenv().ShiBuHUB_Loaded = false
    end

    gui:Destroy()
end)

--========================================================
-- DRAGGING
--========================================================

local dragging = false
local dragStart
local startPos

top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

top.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart

        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

--========================================================
-- MINIMIZE / FLOATING LOGO
--========================================================

local floating = Instance.new("ImageButton")
floating.Name = "FloatingLogo"
floating.Visible = false
floating.Size = UDim2.fromOffset(58, 58)
floating.Position = UDim2.new(0, 18, 0.5, -29)
floating.BackgroundColor3 = T.Card2
floating.Image = CONFIG.LOGO
floating.AutoButtonColor = false
floating.Parent = gui
corner(floating, 16)
stroke(floating, T.Accent, 2, 0.15)

local floatScale = Instance.new("UIScale")
floatScale.Parent = floating

minimize.MouseButton1Click:Connect(function()
    main.Visible = false
    floating.Visible = true

    floatScale.Scale = 0.8
    TweenService:Create(
        floatScale,
        TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Scale = 1}
    ):Play()
end)

floating.MouseButton1Click:Connect(function()
    floating.Visible = false
    main.Visible = true

    main.Size = UDim2.fromOffset(720, 440)
    TweenService:Create(
        main,
        TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.fromOffset(760, 470)}
    ):Play()
end)

close.MouseButton1Click:Connect(function()
    Egg.Enabled = false

    if getgenv then
        getgenv().ShiBuHUB_Loaded = false
    end

    gui:Destroy()
end)

--========================================================
-- MOBILE SCALE
--========================================================

local uiScale = Instance.new("UIScale")
uiScale.Parent = main

local function updateScale()
    local camera = Workspace.CurrentCamera
    if not camera then
        return
    end

    local vp = camera.ViewportSize
    local sx = math.min(1, (vp.X - 20) / 760)
    local sy = math.min(1, (vp.Y - 20) / 470)
    uiScale.Scale = math.max(0.58, math.min(sx, sy))
end

updateScale()

if Workspace.CurrentCamera then
    Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end

-- Initial tab
selectTab("Autofarm")

-- Entrance animation
local finalSize = main.Size
main.Size = UDim2.fromOffset(690, 420)
main.BackgroundTransparency = 0.12

TweenService:Create(
    main,
    TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {
        Size = finalSize,
        BackgroundTransparency = 0,
    }
):Play()

_G.ShiBuHUB = {
    Egg = Egg,
    EventEgg = EventEgg,
    FarmState = FarmState,
    RarePriority = RarePriority,
    EggScanner = EggScanner,

    SaveReturnPosition = saveReturnPosition,
    ScanEggCandidates = scanEggCandidates,

    StartEgg = function(names)
        if names ~= nil then
            local list = parseRareList(names)
            Egg.SelectedRareEggs = list
            Egg.SelectedEgg = list[1]
        end

        RarePriority.Misses = 0

        if Egg.AutoSaveReturn then
            saveReturnPosition()
        end

        Egg.Enabled = true
    end,

    StopEgg = function()
        Egg.Enabled = false
    end,

    FindEgg = findEgg,
    FindSelectedRareEgg = findSelectedRareEgg,
    FindEventEgg = findEventEgg,

    SetRareEggs = function(names)
        local list = parseRareList(names)
        Egg.SelectedRareEggs = list
        Egg.SelectedEgg = list[1]
        RarePriority.Misses = 0
        return list
    end,

    StartEventEgg = function(name)
        if name and tostring(name) ~= "" then
            EventEgg.SelectedEgg = tostring(name)
        end

        if Egg.AutoSaveReturn and not Egg.ReturnCFrame then
            saveReturnPosition()
        end

        EventEgg.Enabled = true
    end,

    StopEventEgg = function()
        EventEgg.Enabled = false
    end,
}

log("ShiBu HUB loaded.")
log("Brand:", CONFIG.Brand, "| Version:", CONFIG.Version)
