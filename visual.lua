-- Loading Screen | Blazehubscript
-- Infinite loading with terminal logs (Galaxy Style)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Remove old if exists
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("LoadingScreen") then
        game:GetService("CoreGui"):FindFirstChild("LoadingScreen"):Destroy()
    end
end)
if LocalPlayer.PlayerGui:FindFirstChild("LoadingScreen") then
    LocalPlayer.PlayerGui:FindFirstChild("LoadingScreen"):Destroy()
end

-- ========== SCREENGUI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LoadingScreen"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999999

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game:GetService("CoreGui")
elseif gethui then
    ScreenGui.Parent = gethui()
elseif get_hidden_gui then
    ScreenGui.Parent = get_hidden_gui()
else
    ScreenGui.Parent = game:GetService("CoreGui")
end

-- ========== BACKGROUND (Galaxy Theme) ==========
local Background = Instance.new("Frame")
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.fromRGB(5, 3, 15) -- Deep cosmic purple
Background.BorderSizePixel = 0
Background.ZIndex = 1
Background.Parent = ScreenGui

-- Starfield effect (twinkling stars)
local Starfield = Instance.new("Frame")
Starfield.Size = UDim2.new(1, 0, 1, 0)
Starfield.BackgroundTransparency = 1
Starfield.ZIndex = 2
Starfield.Parent = Background

local function createStarfield()
    local stars = {}
    local starCount = 80 -- Reduced for performance
    
    for i = 1, starCount do
        local star = Instance.new("TextLabel")
        star.Size = UDim2.new(0, 2, 0, 2)
        star.Position = UDim2.new(math.random(), 0, math.random(), 0)
        star.BackgroundTransparency = 1
        star.Text = "•"
        star.TextColor3 = Color3.fromRGB(255, 255, 255)
        star.TextSize = math.random(8, 14)
        star.Font = Enum.Font.Arial
        star.TextTransparency = math.random(30, 80) / 100
        star.ZIndex = 2
        star.Parent = Starfield
        
        table.insert(stars, {
            label = star,
            speed = math.random(10, 30) / 100,
            transparency = star.TextTransparency
        })
    end
    
    -- Twinkling effect
    task.spawn(function()
        while ScreenGui.Parent do
            for _, star in ipairs(stars) do
                local newTrans = star.transparency + (math.random(-15, 15) / 100)
                newTrans = math.clamp(newTrans, 0.2, 0.9)
                star.transparency = newTrans
                star.label.TextTransparency = newTrans
            end
            task.wait(0.5)
        end
    end)
end

task.spawn(createStarfield)

-- Nebula effect (subtle color shifting)
local Nebula = Instance.new("Frame")
Nebula.Size = UDim2.new(1, 0, 1, 0)
Nebula.BackgroundColor3 = Color3.fromRGB(25, 10, 45)
Nebula.BackgroundTransparency = 0.7
Nebula.ZIndex = 1
Nebula.Parent = Background

-- ========== 8-BIT ROCKET ANIMATION (Left Side) ==========
local RocketLeft = Instance.new("TextLabel")
RocketLeft.Size = UDim2.new(0, 40, 0, 40)
RocketLeft.Position = UDim2.new(0, 30, 1, -100)
RocketLeft.BackgroundTransparency = 1
RocketLeft.Text = "🚀"
RocketLeft.TextColor3 = Color3.fromRGB(255, 100, 100)
RocketLeft.TextSize = 32
RocketLeft.Font = Enum.Font.Arial
RocketLeft.ZIndex = 5
RocketLeft.Parent = Background

-- ========== 8-BIT ROCKET ANIMATION (Right Side) ==========
local RocketRight = Instance.new("TextLabel")
RocketRight.Size = UDim2.new(0, 40, 0, 40)
RocketRight.Position = UDim2.new(1, -70, 1, -100)
RocketRight.BackgroundTransparency = 1
RocketRight.Text = "🚀"
RocketRight.TextColor3 = Color3.fromRGB(255, 100, 100)
RocketRight.TextSize = 32
RocketRight.Font = Enum.Font.Arial
RocketRight.ZIndex = 5
RocketRight.Parent = Background

-- Rocket animation function
local function animateRocket(rocket, startX, startY, endY, duration)
    local startPos = rocket.Position
    local endPos = UDim2.new(startX, 0, endY, 0)
    
    -- Create tween for upward movement
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local tween = TweenService:Create(rocket, tweenInfo, {Position = endPos})
    
    -- Add flame effect (small flickering)
    local flame = Instance.new("TextLabel")
    flame.Size = UDim2.new(0, 20, 0, 15)
    flame.Position = UDim2.new(0, 10, 1, 0)
    flame.BackgroundTransparency = 1
    flame.Text = "🔥"
    flame.TextColor3 = Color3.fromRGB(255, 100, 0)
    flame.TextSize = 20
    flame.Font = Enum.Font.Arial
    flame.ZIndex = 5
    flame.Parent = rocket
    
    -- Flame flicker effect
    local flicker = task.spawn(function()
        while rocket.Parent and rocket.Position.Y.Scale > 0.05 do
            local randomScale = math.random(8, 14)
            flame.TextSize = randomScale
            flame.TextTransparency = math.random(20, 60) / 100
            task.wait(0.05)
        end
    end)
    
    tween:Play()
    tween.Completed:Wait()
    
    -- Reset position to bottom and restart
    rocket.Position = UDim2.new(startX, 0, 1, -100)
    
    -- Remove flame
    flame:Destroy()
    task.cancel(flicker)
    
    -- Small delay before next launch
    task.wait(math.random(1, 3))
    animateRocket(rocket, startX, startY, endY, duration)
end

-- Start left rocket animation
task.spawn(function()
    while ScreenGui.Parent do
        animateRocket(RocketLeft, 0, 30, 0.05, math.random(2, 4))
    end
end)

-- Start right rocket animation
task.spawn(function()
    while ScreenGui.Parent do
        animateRocket(RocketRight, 1, -70, 0.05, math.random(2, 4))
    end
end)

-- ========== BYPASS (Left Screen - Raised) ==========
local BypassText = Instance.new("TextLabel")
BypassText.Size = UDim2.new(0, 120, 0, 40)
BypassText.Position = UDim2.new(0, 20, 0.35, -20)
BypassText.BackgroundTransparency = 1
BypassText.Text = "> BYPASS"
BypassText.TextColor3 = Color3.fromRGB(180, 130, 255) -- Galaxy purple
BypassText.TextSize = 22
BypassText.Font = Enum.Font.GothamBold
BypassText.TextXAlignment = Enum.TextXAlignment.Left
BypassText.ZIndex = 3
BypassText.Parent = Background

-- Blinking effect for BYPASS
task.spawn(function()
    local blink = false
    while ScreenGui.Parent do
        blink = not blink
        if blink then
            BypassText.Text = "> BYPASS"
            BypassText.TextColor3 = Color3.fromRGB(180, 130, 255)
        else
            BypassText.Text = "> BYPASS"
            BypassText.TextColor3 = Color3.fromRGB(80, 60, 120)
        end
        task.wait(0.8)
    end
end)

-- ========== PROCESSING (Right Screen - Raised) ==========
local ProcessingText = Instance.new("TextLabel")
ProcessingText.Size = UDim2.new(0, 150, 0, 40)
ProcessingText.Position = UDim2.new(1, -170, 0.35, -20)
ProcessingText.BackgroundTransparency = 1
ProcessingText.Text = "PROCESSING >"
ProcessingText.TextColor3 = Color3.fromRGB(180, 130, 255)
ProcessingText.TextSize = 22
ProcessingText.Font = Enum.Font.GothamBold
ProcessingText.TextXAlignment = Enum.TextXAlignment.Right
ProcessingText.ZIndex = 3
ProcessingText.Parent = Background

-- Blinking effect for PROCESSING
task.spawn(function()
    local dot = 0
    while ScreenGui.Parent do
        dot = dot + 1
        if dot > 3 then dot = 1 end
        ProcessingText.Text = "PROCESSING" .. string.rep(".", dot) .. " >"
        task.wait(0.5)
    end
end)

-- Click blocker
local Blocker = Instance.new("TextButton")
Blocker.Size = UDim2.new(1, 0, 1, 0)
Blocker.BackgroundTransparency = 1
Blocker.Text = ""
Blocker.ZIndex = 0
Blocker.Parent = ScreenGui

-- ========== CARD (Resized) ==========
local Card = Instance.new("Frame")
Card.Size = UDim2.new(0, 360, 0, 420)
Card.Position = UDim2.new(0.5, -180, 0.5, -210)
Card.BackgroundColor3 = Color3.fromRGB(8, 5, 20) -- Deep cosmic
Card.BackgroundTransparency = 0.1
Card.BorderSizePixel = 0
Card.ZIndex = 2
Card.Parent = Background

local CardCorner = Instance.new("UICorner", Card)
CardCorner.CornerRadius = UDim.new(0, 15)

local CardStroke = Instance.new("UIStroke", Card)
CardStroke.Color = Color3.fromRGB(180, 130, 255)
CardStroke.Thickness = 1.5
CardStroke.Transparency = 0.3

-- ========== HEADER ==========
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -25, 0, 28)
Title.Position = UDim2.new(0, 12, 0, 12)
Title.BackgroundTransparency = 1
Title.Text = "> BLAZEHUBSCRIPT LOADING _"
Title.TextColor3 = Color3.fromRGB(180, 130, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.ZIndex = 3
Title.Parent = Card

-- Blinking cursor effect
task.spawn(function()
    local cursor = false
    while ScreenGui.Parent do
        cursor = not cursor
        if cursor then
            Title.Text = "> BLAZEHUBSCRIPT LOADING _"
        else
            Title.Text = "> BLAZEHUBSCRIPT LOADING"
        end
        task.wait(0.5)
    end
end)

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -25, 0, 16)
SubTitle.Position = UDim2.new(0, 12, 0, 42)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = ">> INITIALIZING GALAXY CORE <<"
SubTitle.TextColor3 = Color3.fromRGB(140, 100, 200)
SubTitle.TextSize = 9
SubTitle.Font = Enum.Font.GothamBold
SubTitle.ZIndex = 3
SubTitle.Parent = Card

local EstTime = Instance.new("TextLabel")
EstTime.Size = UDim2.new(1, -25, 0, 12)
EstTime.Position = UDim2.new(0, 12, 0, 60)
EstTime.BackgroundTransparency = 1
EstTime.Text = "> TIME: " .. os.date("%H:%M:%S") .. " | NEBULA ACTIVE"
EstTime.TextColor3 = Color3.fromRGB(100, 80, 150)
EstTime.TextSize = 8
EstTime.Font = Enum.Font.GothamBold
EstTime.ZIndex = 3
EstTime.Parent = Card

-- Update time
task.spawn(function()
    while ScreenGui.Parent do
        EstTime.Text = "> TIME: " .. os.date("%H:%M:%S") .. " | NEBULA ACTIVE"
        task.wait(1)
    end
end)

-- ========== LOGS (Resized) ==========
local LogFrame = Instance.new("Frame")
LogFrame.Size = UDim2.new(1, -25, 0, 185)
LogFrame.Position = UDim2.new(0, 12, 0, 78)
LogFrame.BackgroundColor3 = Color3.fromRGB(5, 3, 15)
LogFrame.BackgroundTransparency = 0.4
LogFrame.BorderSizePixel = 0
LogFrame.ZIndex = 3
LogFrame.ClipsDescendants = true
LogFrame.Parent = Card

Instance.new("UICorner", LogFrame).CornerRadius = UDim.new(0, 4)

local LogLayout = Instance.new("UIListLayout", LogFrame)
LogLayout.SortOrder = Enum.SortOrder.LayoutOrder
LogLayout.Padding = UDim.new(0, 1)

local logLines = {}
local logIndex = 0

local logMessages = {
    {txt = "> [SUCCESS] Blazehub module initialized.",          color = Color3.fromRGB(180, 130, 255)},
    {txt = "> Establishing secure connection...",                color = Color3.fromRGB(140, 100, 200)},
    {txt = "> Verifying game integrity...",                      color = Color3.fromRGB(120, 80, 180)},
    {txt = "> Injecting execution environment...",               color = Color3.fromRGB(120, 80, 180)},
    {txt = "> Patching anti-tamper routines...",                 color = Color3.fromRGB(120, 80, 180)},
    {txt = "> [SUCCESS] Core engine loaded.",                    color = Color3.fromRGB(180, 130, 255)},
    {txt = "> Resolving remote endpoints...",                    color = Color3.fromRGB(120, 80, 180)},
    {txt = "> Decrypting payload data...",                       color = Color3.fromRGB(140, 100, 200)},
    {txt = "> Allocating memory buffer...",                      color = Color3.fromRGB(120, 80, 180)},
    {txt = "> [SUCCESS] Trade module verified.",                 color = Color3.fromRGB(180, 130, 255)},
    {txt = "> Synchronizing with game server...",                color = Color3.fromRGB(140, 100, 200)},
    {txt = "> Bypassing detection layer 2...",                   color = Color3.fromRGB(120, 80, 180)},
    {txt = "> Rewriting function pointers...",                   color = Color3.fromRGB(120, 80, 180)},
    {txt = "> [SUCCESS] Auto module verified.",                  color = Color3.fromRGB(180, 130, 255)},
    {txt = "> Finalizing injection...",                          color = Color3.fromRGB(120, 80, 180)},
    {txt = "> Stack trace cleared.",                             color = Color3.fromRGB(120, 80, 180)},
}

local function addLog(msg, color)
    logIndex += 1
    local line = Instance.new("TextLabel")
    line.Size = UDim2.new(1, 0, 0, 12)
    line.BackgroundTransparency = 1
    line.Text = msg
    line.TextColor3 = color or Color3.fromRGB(120, 80, 180)
    line.TextSize = 9
    line.Font = Enum.Font.Code
    line.TextXAlignment = Enum.TextXAlignment.Left
    line.LayoutOrder = logIndex
    line.ZIndex = 4
    line.Parent = LogFrame

    table.insert(logLines, line)

    if #logLines > 12 then
        local old = table.remove(logLines, 1)
        old:Destroy()
    end
end

-- ========== PROGRESS BAR ==========
local ProgressTrack = Instance.new("Frame")
ProgressTrack.Size = UDim2.new(1, -25, 0, 4)
ProgressTrack.Position = UDim2.new(0, 12, 0, 275)
ProgressTrack.BackgroundColor3 = Color3.fromRGB(20, 10, 35)
ProgressTrack.BorderSizePixel = 0
ProgressTrack.ZIndex = 3
ProgressTrack.Parent = Card
Instance.new("UICorner", ProgressTrack).CornerRadius = UDim.new(1, 0)

local ProgressFill = Instance.new("Frame")
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BackgroundColor3 = Color3.fromRGB(180, 130, 255)
ProgressFill.BorderSizePixel = 0
ProgressFill.ZIndex = 4
ProgressFill.Parent = ProgressTrack
Instance.new("UICorner", ProgressFill).CornerRadius = UDim.new(1, 0)

local ProgressPct = Instance.new("TextLabel")
ProgressPct.Size = UDim2.new(1, -25, 0, 18)
ProgressPct.Position = UDim2.new(0, 12, 0, 284)
ProgressPct.BackgroundTransparency = 1
ProgressPct.Text = "0%"
ProgressPct.TextColor3 = Color3.fromRGB(180, 130, 255)
ProgressPct.TextSize = 12
ProgressPct.Font = Enum.Font.GothamBold
ProgressPct.ZIndex = 3
ProgressPct.Parent = Card

-- ========== FOOTER ==========
local FooterLine = Instance.new("Frame")
FooterLine.Size = UDim2.new(1, -25, 0, 1)
FooterLine.Position = UDim2.new(0, 12, 0, 360)
FooterLine.BackgroundColor3 = Color3.fromRGB(180, 130, 255)
FooterLine.BackgroundTransparency = 0.7
FooterLine.BorderSizePixel = 0
FooterLine.ZIndex = 3
FooterLine.Parent = Card

local Footer1 = Instance.new("TextLabel")
Footer1.Size = UDim2.new(1, -25, 0, 14)
Footer1.Position = UDim2.new(0, 12, 0, 368)
Footer1.BackgroundTransparency = 1
Footer1.Text = "> WARNING: Do not disconnect"
Footer1.TextColor3 = Color3.fromRGB(100, 80, 150)
Footer1.TextSize = 8
Footer1.Font = Enum.Font.Gotham
Footer1.ZIndex = 3
Footer1.Parent = Card

local Footer2 = Instance.new("TextLabel")
Footer2.Size = UDim2.new(1, -25, 0, 14)
Footer2.Position = UDim2.new(0, 12, 0, 382)
Footer2.BackgroundTransparency = 1
Footer2.Text = "> SYNCING WITH NEBULA..."
Footer2.TextColor3 = Color3.fromRGB(140, 100, 200)
Footer2.TextSize = 8
Footer2.Font = Enum.Font.Gotham
Footer2.ZIndex = 3
Footer2.Parent = Card

-- Blinking footer effect
task.spawn(function()
    local dot = 1
    while ScreenGui.Parent do
        dot = dot + 1
        if dot > 3 then dot = 1 end
        Footer2.Text = "> SYNCING WITH NEBULA" .. string.rep(".", dot)
        task.wait(0.5)
    end
end)

-- ========== APPEARANCE ANIMATION ==========
Background.BackgroundTransparency = 1
Card.BackgroundTransparency = 0.1
TweenService:Create(Background, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
TweenService:Create(Card, TweenInfo.new(0.4), {BackgroundTransparency = 0.1}):Play()
task.wait(0.15)

-- ========== LOGS ==========
task.spawn(function()
    for _, log in ipairs(logMessages) do
        task.wait(math.random(3, 7) * 0.1)
        addLog(log.txt, log.color)
    end
    while ScreenGui.Parent do
        for _, log in ipairs(logMessages) do
            task.wait(math.random(4, 9) * 0.1)
            addLog(log.txt, log.color)
        end
    end
end)

-- ========== PROGRESS — Stops at 96.2% ==========
local progress = 0

local steps = {
    {target = 8,    speed = 0.8},
    {target = 18,   speed = 1.0},
    {target = 29,   speed = 1.2},
    {target = 41,   speed = 1.4},
    {target = 55,   speed = 1.6},
    {target = 67,   speed = 1.4},
    {target = 76,   speed = 1.8},
    {target = 84,   speed = 2.0},
    {target = 91,   speed = 1.8},
    {target = 96.2, speed = 2.5},
}

for _, step in ipairs(steps) do
    while progress < step.target do
        progress = math.min(progress + 0.3, step.target)
        TweenService:Create(ProgressFill, TweenInfo.new(0.1), {
            Size = UDim2.new(progress / 100, 0, 1, 0)
        }):Play()
        ProgressPct.Text = string.format("%.1f%%", progress)
        task.wait(step.speed * 0.15)
    end
    task.wait(step.speed)
end

-- Stuck at 96.2% forever
ProgressPct.Text = "96.2%"
print("[Blazehubscript] Loading stuck at 96.2%")
