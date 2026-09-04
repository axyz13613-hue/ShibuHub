--[[
    ShiBu HUB - SINGLE FILE RELEASE
    Upload only this file to GitHub.
    Run it directly with loadstring(game:HttpGet(RAW_URL))()
]]

--[[
    ShiBu HUB v2.5
    GitHub-ready consolidated release
    UI + Rare/Event priority + Map scanner + Anti-AFK + Pathfinding movement

    Brand: ShiBu HUB
    Theme: Dark / Cyan / Mint
    NOTE:
      - Replace LOGO with your uploaded Roblox image/decal asset ID.
      - "Security" here means duplicate-run protection + error handling.
      - This script does NOT bypass anti-cheat systems.
      - Direct CFrame teleport has been removed; movement uses Humanoid/PathfindingService.
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
local PathfindingService = game:GetService("PathfindingService")
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
    Version = "2.5.0",

    -- Upload your logo to Roblox and replace this:
    -- Logo ảnh ShiBu đã được nhúng trực tiếp bên dưới.
    -- Có thể để "0". Nếu sau này có Roblox asset ID thật, điền vào để ưu tiên asset Roblox.
    LOGO_ASSET_ID = "0",
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

--========================================================
-- EMBEDDED SHIBU LOGO
-- Logo này được nhúng trực tiếp từ ảnh người dùng cung cấp.
-- Ưu tiên Roblox asset ID nếu bạn điền ID thật.
-- Nếu ID vẫn là 0, script sẽ thử dùng writefile + getcustomasset/getsynasset.
--========================================================

local SHIBU_LOGO_BASE64 = [[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]]

local function shibuBase64Decode(data)
    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    data = tostring(data or ""):gsub("[^" .. alphabet .. "=]", "")

    return (data:gsub(".", function(x)
        if x == "=" then
            return ""
        end

        local index = alphabet:find(x, 1, true)
        if not index then
            return ""
        end

        local value = index - 1
        local bits = ""

        for i = 6, 1, -1 do
            bits = bits .. ((value % 2^i - value % 2^(i - 1) > 0) and "1" or "0")
        end

        return bits
    end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(bits)
        if #bits ~= 8 then
            return ""
        end

        local value = 0

        for i = 1, 8 do
            if bits:sub(i, i) == "1" then
                value = value + 2^(8 - i)
            end
        end

        return string.char(value)
    end))
end

local function loadEmbeddedShiBuLogo()
    local configuredId = tostring(CONFIG.LOGO_ASSET_ID or "0")

    -- Roblox-hosted asset remains the most portable option when supplied.
    if configuredId ~= "" and configuredId ~= "0" then
        CONFIG.LOGO = "rbxassetid://" .. configuredId
        return true
    end

    local customAssetFn = getcustomasset or getsynasset

    if not writefile or not customAssetFn then
        return false
    end

    local fileName = "ShiBu_HUB_Embedded_Logo.jpg"

    local ok = pcall(function()
        local bytes = shibuBase64Decode(SHIBU_LOGO_BASE64)
        writefile(fileName, bytes)
        CONFIG.LOGO = customAssetFn(fileName)
    end)

    return ok and tostring(CONFIG.LOGO or "") ~= ""
end

loadEmbeddedShiBuLogo()

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
    SelectedRareEggs = {"Divine", "Eternal", "Secret"},
    SelectedEgg = "Divine", -- compatibility / first selected Rare
    TargetPriority = "Rarity",
    ReturnTarget = "Plot Spawn",
    ReturnCFrame = nil,

    TeleportDelay = 0.12, -- kept for compatibility; now used as arrival pause
    PickupWait = 0.40,
    ReturnDelay = 0.12,
    SearchDelay = 0.22,

    -- Video-like steal flow:
    ApproachDistance = 3.0,
    InteractRetries = 3,
    RetryDelay = 0.12,
    ReturnOnlyAfterInteract = true,

    -- 0 keeps the game's current WalkSpeed.
    MoveSpeedOverride = 0,

    -- Video-like filter controls.
    AutoStealInfested = false,
    ShelterFromDragonWave = false,
    AreaFilter = "",
    CategoryFilter = "",
    MutationFilter = "",

    Busy = false,
    LastStatus = "Idle",
}

-- Event eggs are handled only when no selected rare egg is currently available.
local EventEgg = {
    Enabled = false,
    SelectedEgg = "Infested",
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

local RarityFilter = {
    Divine = true,
    Eternal = true,
    Secret = true,
}

local function rebuildRarityList()
    local ordered = {"Divine", "Eternal", "Secret"}
    local list = {}

    for _, rarity in ipairs(ordered) do
        if RarityFilter[rarity] then
            table.insert(list, rarity)
        end
    end

    if #list == 0 then
        RarityFilter.Divine = true
        table.insert(list, "Divine")
    end

    Egg.SelectedRareEggs = list
    Egg.SelectedEgg = list[1]
    RarePriority.Misses = 0
end

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


local function instanceContextText(instance)
    local parts = {}
    local current = instance
    local depth = 0

    while current and current ~= Workspace and depth < 8 do
        table.insert(parts, tostring(current.Name or ""))
        current = current.Parent
        depth += 1
    end

    return normalize(table.concat(parts, " "))
end

local function optionalFilterMatches(instance, filterText)
    filterText = tostring(filterText or ""):gsub("^%s+", ""):gsub("%s+$", "")

    if filterText == "" or filterText == "*" then
        return true
    end

    local context = instanceContextText(instance)

    for token in filterText:gmatch("[^,;\n]+") do
        token = normalize(token:gsub("^%s+", ""):gsub("%s+$", ""))

        if token ~= "" and context:find(token, 1, true) then
            return true
        end
    end

    return false
end

local function passesVideoFilters(instance)
    return optionalFilterMatches(instance, Egg.AreaFilter)
        and optionalFilterMatches(instance, Egg.CategoryFilter)
        and optionalFilterMatches(instance, Egg.MutationFilter)
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
                if p
                    and p:IsDescendantOf(Workspace)
                    and passesVideoFilters(obj)
                    and score > bestScore then
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

local function waitForMove(humanoid, timeout)
    local finished = false
    local reached = false

    local connection
    connection = humanoid.MoveToFinished:Connect(function(ok)
        reached = ok == true
        finished = true
    end)

    local started = os.clock()

    while not finished and (os.clock() - started) < timeout do
        task.wait(0.05)
    end

    if connection then
        connection:Disconnect()
    end

    return reached
end

local function moveCharacterTo(cf)
    local root = getRoot()
    local character = getCharacter()
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if not humanoid or humanoid.Health <= 0 then
        return false
    end

    if Egg.MoveSpeedOverride and Egg.MoveSpeedOverride > 0 then
        pcall(function()
            humanoid.WalkSpeed = Egg.MoveSpeedOverride
        end)
    end

    local destination = cf.Position
    local distance = (root.Position - destination).Magnitude

    if distance <= 4 then
        humanoid:MoveTo(destination)
        waitForMove(humanoid, 2.5)
        return true
    end

    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        WaypointSpacing = 4,
    })

    local ok = pcall(function()
        path:ComputeAsync(root.Position, destination)
    end)

    if not ok or path.Status ~= Enum.PathStatus.Success then
        humanoid:MoveTo(destination)
        return waitForMove(humanoid, math.clamp(distance / 10 + 2, 3, 12))
    end

    for _, waypoint in ipairs(path:GetWaypoints()) do
        if not character.Parent or humanoid.Health <= 0 then
            return false
        end

        if waypoint.Action == Enum.PathWaypointAction.Jump then
            humanoid.Jump = true
        end

        humanoid:MoveTo(waypoint.Position)

        local stepDistance = (root.Position - waypoint.Position).Magnitude
        local timeout = math.clamp(stepDistance / 8 + 1.5, 2, 6)

        if not waitForMove(humanoid, timeout) then
            return false
        end
    end

    return (root.Position - destination).Magnitude <= 7
end

local function saveReturnPosition()
    Egg.ReturnCFrame = getRoot().CFrame
    Egg.LastStatus = "Plot Spawn saved"
    log(Egg.LastStatus)
end

local function interactOnce(part)
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

local function interact(part)
    for attempt = 1, Egg.InteractRetries do
        if not part or not part:IsDescendantOf(Workspace) then
            return false
        end

        if interactOnce(part) then
            return true
        end

        task.wait(Egg.RetryDelay)
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

    local success = false
    local ok, err = pcall(function()
        if not Egg.ReturnCFrame then
            saveReturnPosition()
        end

        local statusText = "Approaching " .. targetType .. ": " .. targetName

        if targetType == "Rare Egg" then
            Egg.LastStatus = statusText
        else
            EventEgg.LastStatus = statusText
        end

        -- Move close to the egg first, similar to the video flow.
        local targetCF = target.CFrame
        local look = targetCF.LookVector
        local approachPos = targetCF.Position - (look * Egg.ApproachDistance)
        local approachCF = CFrame.new(approachPos, targetCF.Position)

        local moved = moveCharacterTo(approachCF)

        if not moved and target:IsDescendantOf(Workspace) then
            -- Fallback: try to walk directly to the egg's position.
            moved = moveCharacterTo(target.CFrame)
        end

        if not moved then
            error("Could not reach target")
        end

        task.wait(Egg.TeleportDelay)

        if targetType == "Rare Egg" then
            Egg.LastStatus = "Stealing Rare: " .. targetName
        else
            EventEgg.LastStatus = "Collecting Event: " .. targetName
        end

        local interacted = interact(target)

        -- Touch-based pickup fallback: step into target using normal movement.
        if not interacted and target:IsDescendantOf(Workspace) then
            moveCharacterTo(target.CFrame)
            task.wait(0.08)
            interacted = interact(target)
        end

        task.wait(Egg.PickupWait)

        success = interacted

        if Egg.ReturnAfterPickup and Egg.ReturnCFrame then
            if (not Egg.ReturnOnlyAfterInteract) or interacted then
                if targetType == "Rare Egg" then
                    Egg.LastStatus = "Returning after Rare"
                else
                    EventEgg.LastStatus = "Returning after Event"
                end

                task.wait(Egg.ReturnDelay)
                moveCharacterTo(Egg.ReturnCFrame)
            end
        end

        if targetType == "Rare Egg" then
            Egg.LastStatus = interacted and "Rare pickup complete" or "Rare pickup not confirmed"
        else
            EventEgg.LastStatus = interacted and "Event pickup complete" or "Event pickup not confirmed"
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

    return ok and success
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
    if Egg.AutoStealInfested then
        EventEgg.Enabled = true
        EventEgg.SelectedEgg = "Infested"
    end

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
    corner(b, 7)
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
    frame.Size = UDim2.new(1, 0, 0, 46)
    frame.Parent = parent
    corner(frame, 10)
    stroke(frame, T.Stroke, 1, 0.35)

    local title = label(frame, titleText, 13, T.Text, Enum.Font.GothamMedium)
    title.Position = UDim2.new(0, 14, 0, 0)
    title.Size = UDim2.new(1, -90, 1, 0)

    local switch = Instance.new("TextButton")
    switch.AutoButtonColor = false
    switch.Text = ""
    switch.Size = UDim2.fromOffset(44, 24)
    switch.Position = UDim2.new(1, -57, 0.5, -12)
    switch.BackgroundColor3 = defaultState and T.Accent2 or Color3.fromRGB(53, 62, 68)
    switch.Parent = frame
    corner(switch, 99)

    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(18, 18)
    dot.Position = defaultState and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
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
            {Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)}
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
    frame.Size = UDim2.new(1, 0, 0, 62)
    frame.Parent = parent
    corner(frame, 10)
    stroke(frame, T.Stroke, 1, 0.35)

    local title = label(frame, titleText, 13, T.SubText, Enum.Font.GothamMedium)
    title.Position = UDim2.new(0, 14, 0, 5)
    title.Size = UDim2.new(1, -28, 0, 22)

    local box = Instance.new("TextBox")
    box.BackgroundColor3 = T.Card2
    box.Position = UDim2.new(0, 12, 0, 29)
    box.Size = UDim2.new(1, -24, 0, 25)
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
main.Size = UDim2.fromOffset(900, 520)
main.BackgroundColor3 = T.BG
main.Parent = gui
main.ClipsDescendants = true
corner(main, 12)
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
top.Size = UDim2.new(1, 0, 0, 52)
top.BackgroundColor3 = Color3.fromRGB(9, 14, 19)
top.Parent = main
corner(top, 12)

local topMask = Instance.new("Frame")
topMask.Size = UDim2.new(1, 0, 0, 20)
topMask.Position = UDim2.new(0, 0, 1, -20)
topMask.BackgroundColor3 = top.BackgroundColor3
topMask.BorderSizePixel = 0
topMask.Parent = top

local logo = Instance.new("ImageLabel")
logo.BackgroundColor3 = T.Card2
logo.Position = UDim2.fromOffset(12, 8)
logo.Size = UDim2.fromOffset(36, 36)
logo.Image = CONFIG.LOGO
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = top
corner(logo, 10)
stroke(logo, T.Accent, 1, 0.25)

local hasRealLogo = tostring(CONFIG.LOGO or "") ~= ""
    and tostring(CONFIG.LOGO) ~= "rbxassetid://0"
    and tostring(CONFIG.LOGO) ~= "0"

logo.ImageTransparency = hasRealLogo and 0 or 1

local logoFallback = label(logo, "SH", 12, T.Accent, Enum.Font.GothamBold)
logoFallback.Size = UDim2.fromScale(1, 1)
logoFallback.TextXAlignment = Enum.TextXAlignment.Center
logoFallback.Visible = not hasRealLogo
logoFallback.ZIndex = logo.ZIndex + 1

local brand = label(top, CONFIG.Brand, 20, T.Text, Enum.Font.GothamBold)
brand.Position = UDim2.fromOffset(58, 7)
brand.Size = UDim2.new(0, 220, 0, 24)

local sub = label(top, "Cloud-tech automation interface", 12, T.SubText, Enum.Font.Gotham)
sub.Position = UDim2.fromOffset(59, 28)
sub.Size = UDim2.new(0, 300, 0, 16)

local version = label(top, "v" .. CONFIG.Version, 11, T.Accent, Enum.Font.GothamMedium)
version.TextXAlignment = Enum.TextXAlignment.Right
version.Position = UDim2.new(1, -190, 0, 13)
version.Size = UDim2.fromOffset(105, 24)

local minimize = button(top, "—")
minimize.Size = UDim2.fromOffset(34, 30)
minimize.Position = UDim2.new(1, -78, 0, 11)

local close = button(top, "×")
close.Size = UDim2.fromOffset(34, 30)
close.Position = UDim2.new(1, -40, 0, 11)

--========================================================
-- SIDEBAR
--========================================================

local sidebar = Instance.new("Frame")
sidebar.Position = UDim2.fromOffset(0, 52)
sidebar.Size = UDim2.new(0, 180, 1, -80)
sidebar.BackgroundColor3 = Color3.fromRGB(9, 14, 18)
sidebar.Parent = main

local sideTitle = label(sidebar, "SHIBU", 10, T.SubText, Enum.Font.GothamBold)
sideTitle.Position = UDim2.fromOffset(16, 13)
sideTitle.Size = UDim2.new(1, -32, 0, 18)

local sideList = Instance.new("Frame")
sideList.BackgroundTransparency = 1
sideList.Position = UDim2.fromOffset(10, 36)
sideList.Size = UDim2.new(1, -20, 1, -48)
sideList.Parent = sidebar

local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, 4)
sideLayout.Parent = sideList

--========================================================
-- CONTENT
--========================================================

local content = Instance.new("Frame")
content.BackgroundTransparency = 1
content.Position = UDim2.fromOffset(180, 52)
content.Size = UDim2.new(1, -180, 1, -80)
content.Parent = main

local pages = {}
local tabs = {}

local function makePage(name, titleText, description)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.BackgroundTransparency = 1
    page.Position = UDim2.fromOffset(12, 10)
    page.Size = UDim2.new(1, -24, 1, -20)
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = T.Accent
    page.CanvasSize = UDim2.new()
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = content

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 8)
    list.Parent = page

    local header = Instance.new("Frame")
    header.Name = "PageHeader"
    header.BackgroundColor3 = T.Card
    header.Size = UDim2.new(1, -6, 0, 52)
    header.Parent = page
    corner(header, 9)
    stroke(header, T.Stroke, 1, 0.45)

    local h = label(header, titleText, 15, T.Text, Enum.Font.GothamBold)
    h.Position = UDim2.fromOffset(12, 2)
    h.Size = UDim2.new(1, -24, 0, 24)

    local d = label(header, description, 10, T.SubText, Enum.Font.Gotham)
    d.Position = UDim2.fromOffset(12, 24)
    d.Size = UDim2.new(1, -24, 0, 22)
    d.TextWrapped = true
    d.TextTruncate = Enum.TextTruncate.AtEnd

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
                BackgroundColor3 = selected and Color3.fromRGB(13, 38, 42) or Color3.fromRGB(11, 16, 20),
                TextColor3 = selected and T.Accent or T.SubText,
            }
        ):Play()
    end
end

local function addTab(name, text)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Size = UDim2.new(1, 0, 0, 34)
    b.BackgroundColor3 = Color3.fromRGB(12, 18, 23)
    b.Text = "  " .. text
    b.TextColor3 = T.SubText
    b.TextSize = 12
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
statusCard.Size = UDim2.new(1, -6, 0, 128)
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
info.Position = UDim2.fromOffset(16, 40)
info.Size = UDim2.new(1, -32, 0, 44)
info.TextWrapped = true
info.TextYAlignment = Enum.TextYAlignment.Top

local liveStatus = label(statusCard, "Status: Ready", 13, T.Accent2, Enum.Font.GothamMedium)
liveStatus.Position = UDim2.fromOffset(16, 92)
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
    "Auto Steal Eggs",
    "ShiBu layout inspired by the video: rarity priority, filters, Return To Plot, and normal movement."
)


local videoSettingsCard = Instance.new("Frame")
videoSettingsCard.BackgroundColor3 = T.Card
videoSettingsCard.Size = UDim2.new(1, -6, 0, 184)
videoSettingsCard.Parent = eggPage
corner(videoSettingsCard, 10)
stroke(videoSettingsCard, T.Accent, 1, 0.45)

local vTitle = label(videoSettingsCard, "AUTO STEAL", 14, T.Accent, Enum.Font.GothamBold)
vTitle.Position = UDim2.fromOffset(14, 9)
vTitle.Size = UDim2.new(1, -28, 0, 20)

local vFree = label(videoSettingsCard, "SCRIPT IS FREE • ShiBu HUB", 11, T.SubText, Enum.Font.Gotham)
vFree.Position = UDim2.fromOffset(14, 31)
vFree.Size = UDim2.new(1, -28, 0, 18)
vFree.TextTruncate = Enum.TextTruncate.AtEnd

local vLine1 = label(videoSettingsCard, "Target Priority", 11, T.SubText, Enum.Font.Gotham)
vLine1.Position = UDim2.fromOffset(14, 56)
vLine1.Size = UDim2.new(0.42, 0, 0, 18)
vLine1.TextTruncate = Enum.TextTruncate.AtEnd

local vPriority = label(videoSettingsCard, "Rarity", 12, T.Text, Enum.Font.GothamMedium)
vPriority.Position = UDim2.new(0.46, 0, 0, 54)
vPriority.Size = UDim2.new(0.50, -14, 0, 22)
vPriority.TextTruncate = Enum.TextTruncate.AtEnd
vPriority.TextXAlignment = Enum.TextXAlignment.Right

local vLine2 = label(videoSettingsCard, "Return To Plot", 11, T.SubText, Enum.Font.Gotham)
vLine2.Position = UDim2.fromOffset(14, 82)
vLine2.Size = UDim2.new(0.42, 0, 0, 18)
vLine2.TextTruncate = Enum.TextTruncate.AtEnd

local vReturn = label(videoSettingsCard, "ON", 12, T.Accent2, Enum.Font.GothamBold)
vReturn.Position = UDim2.new(0.46, 0, 0, 80)
vReturn.Size = UDim2.new(0.50, -14, 0, 22)
vReturn.TextTruncate = Enum.TextTruncate.AtEnd
vReturn.TextXAlignment = Enum.TextXAlignment.Right

local vLine3 = label(videoSettingsCard, "Return To", 11, T.SubText, Enum.Font.Gotham)
vLine3.Position = UDim2.fromOffset(14, 108)
vLine3.Size = UDim2.new(0.42, 0, 0, 18)
vLine3.TextTruncate = Enum.TextTruncate.AtEnd

local vPlot = label(videoSettingsCard, "Plot Spawn", 12, T.Text, Enum.Font.GothamMedium)
vPlot.Position = UDim2.new(0.46, 0, 0, 106)
vPlot.Size = UDim2.new(0.50, -14, 0, 22)
vPlot.TextTruncate = Enum.TextTruncate.AtEnd
vPlot.TextXAlignment = Enum.TextXAlignment.Right

local vLine4 = label(videoSettingsCard, "Rarities", 11, T.SubText, Enum.Font.Gotham)
vLine4.Position = UDim2.fromOffset(14, 134)
vLine4.Size = UDim2.new(0.42, 0, 0, 18)
vLine4.TextTruncate = Enum.TextTruncate.AtEnd

local vRarities = label(videoSettingsCard, "Divine, Eternal, Secret", 12, T.Text, Enum.Font.GothamMedium)
vRarities.Position = UDim2.new(0.34, 0, 0, 132)
vRarities.Size = UDim2.new(0.62, -14, 0, 22)
vRarities.TextTruncate = Enum.TextTruncate.AtEnd
vRarities.TextXAlignment = Enum.TextXAlignment.Right

local vMove = label(videoSettingsCard, "Movement: Humanoid / Pathfinding", 10, T.SubText, Enum.Font.Gotham)
vMove.Position = UDim2.fromOffset(14, 158)
vMove.Size = UDim2.new(1, -28, 0, 18)
vMove.TextTruncate = Enum.TextTruncate.AtEnd

createToggle(eggPage, "Rarity: Divine", RarityFilter.Divine, function(state)
    RarityFilter.Divine = state
    rebuildRarityList()
end)

createToggle(eggPage, "Rarity: Eternal", RarityFilter.Eternal, function(state)
    RarityFilter.Eternal = state
    rebuildRarityList()
end)

createToggle(eggPage, "Rarity: Secret", RarityFilter.Secret, function(state)
    RarityFilter.Secret = state
    rebuildRarityList()
end)


createInput(
    eggPage,
    "Areas",
    "Blank = all areas",
    Egg.AreaFilter,
    function(value)
        Egg.AreaFilter = tostring(value or "")
    end
)

createInput(
    eggPage,
    "Categories",
    "Blank = all categories",
    Egg.CategoryFilter,
    function(value)
        Egg.CategoryFilter = tostring(value or "")
    end
)

createInput(
    eggPage,
    "Mutations",
    "Blank = all mutations",
    Egg.MutationFilter,
    function(value)
        Egg.MutationFilter = tostring(value or "")
    end
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

createToggle(eggPage, "Auto Steal Eggs", Egg.Enabled, function(state)
    Egg.Enabled = state

    if state and Egg.AutoSaveReturn then
        saveReturnPosition()
    end
end)


createToggle(eggPage, "Auto Steal Infested Eggs", Egg.AutoStealInfested, function(state)
    Egg.AutoStealInfested = state
    EventEgg.Enabled = state
    EventEgg.SelectedEgg = "Infested"
end)

createToggle(eggPage, "Shelter From Dragon Wave", Egg.ShelterFromDragonWave, function(state)
    Egg.ShelterFromDragonWave = state
    if state then
        Egg.LastStatus = "Shelter enabled; exact safe-zone path not configured"
    end
end)

createToggle(eggPage, "Return To Plot", Egg.ReturnAfterPickup, function(state)
    Egg.ReturnAfterPickup = state
end)

createToggle(eggPage, "Save Base When Starting", Egg.AutoSaveReturn, function(state)
    Egg.AutoSaveReturn = state
end)

local savePos = button(eggPage, "Save Plot Spawn")
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
    "Arrival Pause (seconds)",
    "0.12",
    tostring(Egg.TeleportDelay),
    function(text)
        local n = tonumber(text)
        if n then
            Egg.TeleportDelay = math.clamp(n, 0.03, 3)
        end
    end
)

createInput(
    eggPage,
    "Movement Speed",
    "0 = game default",
    tostring(Egg.MoveSpeedOverride),
    function(text)
        local n = tonumber(text)
        if n then
            Egg.MoveSpeedOverride = math.clamp(n, 0, 32)
        end
    end
)


createInput(
    eggPage,
    "Approach Distance",
    "Default: 3",
    tostring(Egg.ApproachDistance),
    function(text)
        local n = tonumber(text)
        if n then
            Egg.ApproachDistance = math.clamp(n, 1, 8)
        end
    end
)

createInput(
    eggPage,
    "Interact Retries",
    "Default: 3",
    tostring(Egg.InteractRetries),
    function(text)
        local n = tonumber(text)
        if n then
            Egg.InteractRetries = math.clamp(math.floor(n), 1, 6)
        end
    end
)

createToggle(
    eggPage,
    "Return Only After Successful Interaction",
    Egg.ReturnOnlyAfterInteract,
    function(state)
        Egg.ReturnOnlyAfterInteract = state
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
-- BF-STYLE TWO-COLUMN PAGE LAYOUT (UI ONLY)
--========================================================

local function applyTwoColumnLayout(page)
    if not page or not page:IsA("ScrollingFrame") then
        return
    end

    local header = page:FindFirstChild("PageHeader")
    if not header then
        return
    end

    local controls = {}

    for _, child in ipairs(page:GetChildren()) do
        if child:IsA("GuiObject")
            and child ~= header
            and child.Name ~= "BFColumns" then
            table.insert(controls, child)
        end
    end

    if #controls == 0 then
        return
    end

    -- Let the original UIListLayout calculate positions before moving controls.
    RunService.Heartbeat:Wait()

    table.sort(controls, function(a, b)
        if a.AbsolutePosition.Y == b.AbsolutePosition.Y then
            return a.AbsolutePosition.X < b.AbsolutePosition.X
        end
        return a.AbsolutePosition.Y < b.AbsolutePosition.Y
    end)

    local columns = Instance.new("Frame")
    columns.Name = "BFColumns"
    columns.BackgroundTransparency = 1
    columns.Size = UDim2.new(1, -6, 0, 100)
    columns.Parent = page

    local left = Instance.new("Frame")
    left.Name = "Left"
    left.BackgroundTransparency = 1
    left.Position = UDim2.fromOffset(0, 0)
    left.Size = UDim2.new(0.5, -5, 0, 100)
    left.Parent = columns

    local right = Instance.new("Frame")
    right.Name = "Right"
    right.BackgroundTransparency = 1
    right.Position = UDim2.new(0.5, 5, 0, 0)
    right.Size = UDim2.new(0.5, -5, 0, 100)
    right.Parent = columns

    local leftLayout = Instance.new("UIListLayout")
    leftLayout.Padding = UDim.new(0, 8)
    leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
    leftLayout.Parent = left

    local rightLayout = Instance.new("UIListLayout")
    rightLayout.Padding = UDim.new(0, 8)
    rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
    rightLayout.Parent = right

    local leftHeight = 0
    local rightHeight = 0

    for index, child in ipairs(controls) do
        local h = math.max(34, child.Size.Y.Offset)

        -- Greedy balancing keeps tall cards distributed like the BF two-panel layout.
        if leftHeight <= rightHeight then
            child.Parent = left
            child.LayoutOrder = index
            child.Size = UDim2.new(1, 0, 0, h)
            leftHeight += h + 8
        else
            child.Parent = right
            child.LayoutOrder = index
            child.Size = UDim2.new(1, 0, 0, h)
            rightHeight += h + 8
        end
    end

    local function refreshHeight()
        local height = math.max(
            leftLayout.AbsoluteContentSize.Y,
            rightLayout.AbsoluteContentSize.Y
        )

        columns.Size = UDim2.new(1, -6, 0, math.max(100, height))
        left.Size = UDim2.new(0.5, -5, 0, math.max(100, height))
        right.Size = UDim2.new(0.5, -5, 0, math.max(100, height))
    end

    leftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshHeight)
    rightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshHeight)

    task.defer(refreshHeight)
end

for _, page in pairs(pages) do
    applyTwoColumnLayout(page)
end

-- BF-style footer/version strip.
local footer = Instance.new("Frame")
footer.Name = "Footer"
footer.Position = UDim2.new(0, 0, 1, -28)
footer.Size = UDim2.new(1, 0, 0, 28)
footer.BackgroundColor3 = Color3.fromRGB(8, 12, 16)
footer.Parent = main
footer.ZIndex = 20

local footerLine = Instance.new("Frame")
footerLine.Size = UDim2.new(1, 0, 0, 1)
footerLine.BackgroundColor3 = T.Stroke
footerLine.BorderSizePixel = 0
footerLine.Parent = footer

local footerLeft = label(footer, "ShiBu HUB • Steal an Egg", 10, T.SubText, Enum.Font.GothamMedium)
footerLeft.Position = UDim2.fromOffset(12, 3)
footerLeft.Size = UDim2.new(0.7, 0, 1, -4)
footerLeft.ZIndex = 21

local footerRight = label(footer, "v" .. CONFIG.Version .. " / Free", 10, T.Accent, Enum.Font.GothamBold)
footerRight.TextXAlignment = Enum.TextXAlignment.Right
footerRight.Position = UDim2.new(0.7, 0, 0, 3)
footerRight.Size = UDim2.new(0.3, -12, 1, -4)
footerRight.ZIndex = 21


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
floating.ScaleType = Enum.ScaleType.Fit
floating.ImageTransparency = hasRealLogo and 0 or 1
floating.AutoButtonColor = false
floating.Parent = gui
corner(floating, 99)
stroke(floating, T.Accent, 2, 0.15)

local floatText = label(floating, "SH", 14, T.Accent, Enum.Font.GothamBold)
floatText.Size = UDim2.fromScale(1, 1)
floatText.TextXAlignment = Enum.TextXAlignment.Center
floatText.Visible = not hasRealLogo
floatText.ZIndex = floating.ZIndex + 1

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

    main.Size = UDim2.fromOffset(820, 474)
    TweenService:Create(
        main,
        TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.fromOffset(900, 520)}
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
    local sx = math.min(1, (vp.X - 20) / 900)
    local sy = math.min(1, (vp.Y - 20) / 520)
    uiScale.Scale = math.max(0.48, math.min(sx, sy))
end

updateScale()

if Workspace.CurrentCamera then
    Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end

-- Initial tab
selectTab("Autofarm")

-- Entrance animation
local finalSize = main.Size
main.Size = UDim2.fromOffset(810, 468)
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
    RarityFilter = RarityFilter,
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

    StealSelectedRareNow = function()
        local target, name = findSelectedRareEgg()
        if not target then
            return false, "No selected Rare egg found"
        end
        return farmTarget(target, name, "Rare Egg")
    end,

    SetRareEggs = function(names)
        local list = parseRareList(names)
        Egg.SelectedRareEggs = list
        Egg.SelectedEgg = list[1]
        RarePriority.Misses = 0
        return list
    end,

    SetRarityFilter = function(divine, eternal, secret)
        if divine ~= nil then RarityFilter.Divine = divine == true end
        if eternal ~= nil then RarityFilter.Eternal = eternal == true end
        if secret ~= nil then RarityFilter.Secret = secret == true end
        rebuildRarityList()
        return Egg.SelectedRareEggs
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
rebuildRarityList()

log("Brand:", CONFIG.Brand, "| Version:", CONFIG.Version)
