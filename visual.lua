-- Loading Screen | Mystryx
-- Dark Red Themed Terminal Loading with Hexagonal Design + Floating Orbs
-- Roblox Lua Version

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Clean up existing screens
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("MystryxLoading") then
        game:GetService("CoreGui"):FindFirstChild("MystryxLoading"):Destroy()
    end
end)

if LocalPlayer and LocalPlayer.PlayerGui:FindFirstChild("MystryxLoading") then
    LocalPlayer.PlayerGui:FindFirstChild("MystryxLoading"):Destroy()
end

-- ========== SCREENGUI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MystryxLoading"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999999

-- Parent to appropriate GUI
local success, err = pcall(function()
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
end)

if not success then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ========== BACKGROUND ==========
local Background = Instance.new("Frame")
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.fromRGB(8, 0, 0)
Background.BorderSizePixel = 0
Background.ZIndex = 1
Background.Parent = ScreenGui

-- Dark gradient overlay
local GradientOverlay = Instance.new("Frame")
GradientOverlay.Size = UDim2.new(1, 0, 1, 0)
GradientOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
GradientOverlay.BackgroundTransparency = 0.6
GradientOverlay.BorderSizePixel = 0
GradientOverlay.ZIndex = 1
GradientOverlay.Parent = Background

-- ========== FLOATING ORBS ==========
local OrbsContainer = Instance.new("Frame")
OrbsContainer.Size = UDim2.new(1, 0, 1, 0)
OrbsContainer.BackgroundTransparency = 1
OrbsContainer.ZIndex = 2
OrbsContainer.Parent = Background

local orbs = {}

local function createOrb(size, startX, startY, colorIntensity)
    local orb = Instance.new("Frame")
    orb.Size = UDim2.new(0, size, 0, size)
    orb.Position = UDim2.new(0, startX, 0, startY)
    orb.BackgroundColor3 = Color3.fromRGB(255, colorIntensity, colorIntensity)
    orb.BackgroundTransparency = 0.4
    orb.BorderSizePixel = 0
    orb.ZIndex = 2
    orb.Parent = OrbsContainer
    
    -- Add corner for round shape
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = orb
    
    -- Add inner glow effect
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(0.7, 0, 0.7, 0)
    glow.Position = UDim2.new(0.15, 0, 0.15, 0)
    glow.BackgroundColor3 = Color3.fromRGB(255, colorIntensity + 50, colorIntensity + 50)
    glow.BackgroundTransparency = 0.5
    glow.BorderSizePixel = 0
    glow.ZIndex = 3
    glow.Parent = orb
    
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(1, 0)
    glowCorner.Parent = glow
    
    return orb
end

-- Create 3 orbs with different sizes and starting positions
local orbData = {
    {size = 120, startX = 150, startY = 200, intensity = 80, speedX = 0.4, speedY = 0.3, rangeX = 300, rangeY = 200},
    {size = 85, startX = 1200, startY = 500, intensity = 100, speedX = 0.5, speedY = 0.4, rangeX = 350, rangeY = 250},
    {size = 200, startX = 800, startY = 700, intensity = 60, speedX = 0.3, speedY = 0.35, rangeX = 400, rangeY = 300}
}

for i, data in ipairs(orbData) do
    local orb = createOrb(data.size, data.startX, data.startY, data.intensity)
    table.insert(orbs, {
        obj = orb,
        glow = orb:FindFirstChildWhichIsA("Frame"),
        x = data.startX,
        y = data.startY,
        startX = data.startX,
        startY = data.startY,
        size = data.size,
        speedX = data.speedX,
        speedY = data.speedY,
        rangeX = data.rangeX,
        rangeY = data.rangeY,
        angleX = math.random(0, 360),
        angleY = math.random(0, 360),
        pulseTime = math.random(0, 100) / 100,
        intensity = data.intensity
    })
end

-- Animate floating orbs
task.spawn(function()
    local time = 0
    while ScreenGui and ScreenGui.Parent do
        time = time + 0.016
        for _, orb in ipairs(orbs) do
            -- Calculate floating movement
            orb.angleX = orb.angleX + orb.speedX * 0.02
            orb.angleY = orb.angleY + orb.speedY * 0.02
            
            local offsetX = math.sin(orb.angleX) * orb.rangeX * 0.5
            local offsetY = math.cos(orb.angleY) * orb.rangeY * 0.5
            
            local newX = orb.startX + offsetX
            local newY = orb.startY + offsetY
            
            orb.x = newX
            orb.y = newY
            orb.obj.Position = UDim2.new(0, orb.x, 0, orb.y)
            
            -- Pulsing effect
            local pulse = (math.sin(time * 1.5 + orb.pulseTime * 10) + 1) / 2
            local transparency = 0.3 + (pulse * 0.3)
            local intensity = 80 + (pulse * 100)
            orb.obj.BackgroundColor3 = Color3.fromRGB(255, intensity, intensity)
            orb.obj.BackgroundTransparency = transparency
            
            -- Inner glow pulse
            if orb.glow then
                orb.glow.BackgroundColor3 = Color3.fromRGB(255, intensity + 50, intensity + 50)
                orb.glow.BackgroundTransparency = 0.3 + (pulse * 0.3)
            end
            
            -- Scale effect
            local scale = 1 + math.sin(time * 1.2 + orb.pulseTime * 8) * 0.03
            orb.obj.Size = UDim2.new(0, orb.size * scale, 0, orb.size * scale)
        end
        task.wait()
    end
end)

-- ========== HEXAGON GRID EFFECT ==========
local HexGrid = Instance.new("Frame")
HexGrid.Size = UDim2.new(1, 0, 1, 0)
HexGrid.BackgroundTransparency = 1
HexGrid.ZIndex = 2
HexGrid.Parent = Background

local function createHexagon(x, y, size)
    local hex = Instance.new("Frame")
    hex.Size = UDim2.new(0, size, 0, size)
    hex.Position = UDim2.new(0, x, 0, y)
    hex.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    hex.BackgroundTransparency = 0.85
    hex.BorderSizePixel = 1
    hex.BorderColor3 = Color3.fromRGB(255, 70, 70)
    hex.ZIndex = 2
    hex.Parent = HexGrid
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, size * 0.2)
    corner.Parent = hex
    
    return hex
end

-- Create floating hexagons
local hexagons = {}
local hexCount = 35

for i = 1, hexCount do
    local x = math.random(0, 2000)
    local y = math.random(0, 1200)
    local size = math.random(25, 55)
    local hex = createHexagon(x, y, size)
    hex.BackgroundTransparency = math.random(70, 95) / 100
    table.insert(hexagons, {
        obj = hex,
        x = x,
        y = y,
        speedX = (math.random(-30, 30)) / 100,
        speedY = (math.random(-20, 20)) / 100,
        size = size,
        pulse = math.random(0, 100) / 100
    })
end

-- Animate floating hexagons
task.spawn(function()
    local time = 0
    while ScreenGui and ScreenGui.Parent do
        time = time + 0.016
        for _, hex in ipairs(hexagons) do
            local newX = hex.x + hex.speedX
            local newY = hex.y + hex.speedY
            
            if newX > 2000 then newX = -100 end
            if newX < -100 then newX = 2000 end
            if newY > 1200 then newY = -100 end
            if newY < -100 then newY = 1200 end
            
            hex.x = newX
            hex.y = newY
            hex.obj.Position = UDim2.new(0, hex.x, 0, hex.y)
            
            -- Pulsing effect
            local pulse = (math.sin(time * 3 + hex.pulse * 10) + 1) / 2
            local transparency = 0.7 + (pulse * 0.2)
            hex.obj.BackgroundTransparency = transparency
            hex.obj.BorderColor3 = Color3.fromRGB(255, 70 + pulse * 50, 70 + pulse * 50)
            hex.obj.BackgroundColor3 = Color3.fromRGB(255, 70 + pulse * 30, 70 + pulse * 30)
        end
        task.wait()
    end
end)

-- ========== CIRCULAR PROGRESS RING ==========
local CenterRing = Instance.new("Frame")
CenterRing.Size = UDim2.new(0, 220, 0, 220)
CenterRing.Position = UDim2.new(0.5, -110, 0.5, -110)
CenterRing.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
CenterRing.BackgroundTransparency = 0.3
CenterRing.BorderSizePixel = 3
CenterRing.BorderColor3 = Color3.fromRGB(255, 60, 60)
CenterRing.ZIndex = 3
CenterRing.Parent = Background

local RingCorner = Instance.new("UICorner")
RingCorner.CornerRadius = UDim.new(1, 0)
RingCorner.Parent = CenterRing

local RingGlow = Instance.new("Frame")
RingGlow.Size = UDim2.new(1, 10, 1, 10)
RingGlow.Position = UDim2.new(0.5, -5, 0.5, -5)
RingGlow.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
RingGlow.BackgroundTransparency = 0.7
RingGlow.BorderSizePixel = 0
RingGlow.ZIndex = 2
RingGlow.Parent = CenterRing

local RingGlowCorner = Instance.new("UICorner")
RingGlowCorner.CornerRadius = UDim.new(1, 0)
RingGlowCorner.Parent = RingGlow

-- Inner content
local InnerContent = Instance.new("Frame")
InnerContent.Size = UDim2.new(0.85, 0, 0.85, 0)
InnerContent.Position = UDim2.new(0.075, 0, 0.075, 0)
InnerContent.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
InnerContent.BackgroundTransparency = 0.2
InnerContent.BorderSizePixel = 2
InnerContent.BorderColor3 = Color3.fromRGB(255, 70, 70)
InnerContent.ZIndex = 4
InnerContent.Parent = CenterRing

local InnerCorner = Instance.new("UICorner")
InnerCorner.CornerRadius = UDim.new(1, 0)
InnerCorner.Parent = InnerContent

-- Percentage text
local PercentText = Instance.new("TextLabel")
PercentText.Size = UDim2.new(1, 0, 0.4, 0)
PercentText.Position = UDim2.new(0, 0, 0.3, 0)
PercentText.BackgroundTransparency = 1
PercentText.Text = "0%"
PercentText.TextColor3 = Color3.fromRGB(255, 80, 80)
PercentText.TextSize = 28
PercentText.Font = Enum.Font.GothamBold
PercentText.ZIndex = 5
PercentText.Parent = InnerContent

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, 0, 0.25, 0)
StatusText.Position = UDim2.new(0, 0, 0.65, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "INITIALIZING"
StatusText.TextColor3 = Color3.fromRGB(255, 70, 70)
StatusText.TextSize = 10
StatusText.Font = Enum.Font.Gotham
StatusText.ZIndex = 5
StatusText.Parent = InnerContent

-- ========== SIDEBAR TERMINAL ==========
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 320, 1, -40)
Sidebar.Position = UDim2.new(1, -340, 0, 20)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
Sidebar.BackgroundTransparency = 0.15
Sidebar.BorderSizePixel = 2
Sidebar.BorderColor3 = Color3.fromRGB(255, 60, 60)
Sidebar.ZIndex = 3
Sidebar.Parent = Background

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 12)
SidebarCorner.Parent = Sidebar

local SidebarTitle = Instance.new("TextLabel")
SidebarTitle.Size = UDim2.new(1, -20, 0, 32)
SidebarTitle.Position = UDim2.new(0, 10, 0, 10)
SidebarTitle.BackgroundTransparency = 1
SidebarTitle.Text = "> MYSTRYX TERMINAL v2.4.7"
SidebarTitle.TextColor3 = Color3.fromRGB(255, 80, 80)
SidebarTitle.TextSize = 12
SidebarTitle.Font = Enum.Font.GothamBold
SidebarTitle.TextXAlignment = Enum.TextXAlignment.Left
SidebarTitle.ZIndex = 4
SidebarTitle.Parent = Sidebar

-- Bypass text
local BypassText = Instance.new("TextLabel")
BypassText.Size = UDim2.new(0, 120, 0, 32)
BypassText.Position = UDim2.new(0, 15, 0, 45)
BypassText.BackgroundTransparency = 1
BypassText.Text = "> BYPASS MODE"
BypassText.TextColor3 = Color3.fromRGB(255, 70, 70)
BypassText.TextSize = 11
BypassText.Font = Enum.Font.GothamBold
BypassText.TextXAlignment = Enum.TextXAlignment.Left
BypassText.ZIndex = 4
BypassText.Parent = Sidebar

-- Processing text
local ProcessingText = Instance.new("TextLabel")
ProcessingText.Size = UDim2.new(0, 150, 0, 32)
ProcessingText.Position = UDim2.new(1, -165, 0, 45)
ProcessingText.BackgroundTransparency = 1
ProcessingText.Text = "PROCESSING >"
ProcessingText.TextColor3 = Color3.fromRGB(255, 70, 70)
ProcessingText.TextSize = 11
ProcessingText.Font = Enum.Font.GothamBold
ProcessingText.TextXAlignment = Enum.TextXAlignment.Right
ProcessingText.ZIndex = 4
ProcessingText.Parent = Sidebar

-- Blinking effect for BYPASS
task.spawn(function()
    local blink = false
    while ScreenGui and ScreenGui.Parent do
        blink = not blink
        if blink then
            BypassText.Text = "> BYPASS MODE [ACTIVE]"
            BypassText.TextColor3 = Color3.fromRGB(255, 100, 100)
        else
            BypassText.Text = "> BYPASS MODE"
            BypassText.TextColor3 = Color3.fromRGB(180, 50, 50)
        end
        task.wait(0.6)
    end
end)

-- Animated dots for PROCESSING
task.spawn(function()
    local dot = 0
    while ScreenGui and ScreenGui.Parent do
        dot = dot + 1
        if dot > 3 then dot = 1 end
        ProcessingText.Text = "PROCESSING" .. string.rep(".", dot) .. " >"
        task.wait(0.5)
    end
end)

local LogContainer = Instance.new("Frame")
LogContainer.Size = UDim2.new(1, -20, 1, -90)
LogContainer.Position = UDim2.new(0, 10, 0, 82)
LogContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LogContainer.BackgroundTransparency = 0.5
LogContainer.BorderSizePixel = 0
LogContainer.ZIndex = 3
LogContainer.ClipsDescendants = true
LogContainer.Parent = Sidebar

local LogCorner = Instance.new("UICorner")
LogCorner.CornerRadius = UDim.new(0, 6)
LogCorner.Parent = LogContainer

local LogLayout = Instance.new("UIListLayout")
LogLayout.SortOrder = Enum.SortOrder.LayoutOrder
LogLayout.Padding = UDim.new(0, 2)
LogLayout.Parent = LogContainer

-- ========== LEFT PANEL ==========
local LeftPanel = Instance.new("Frame")
LeftPanel.Size = UDim2.new(0, 280, 1, -40)
LeftPanel.Position = UDim2.new(0, 20, 0, 20)
LeftPanel.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
LeftPanel.BackgroundTransparency = 0.2
LeftPanel.BorderSizePixel = 2
LeftPanel.BorderColor3 = Color3.fromRGB(255, 60, 60)
LeftPanel.ZIndex = 3
LeftPanel.Parent = Background

local LeftCorner = Instance.new("UICorner")
LeftCorner.CornerRadius = UDim.new(0, 12)
LeftCorner.Parent = LeftPanel

-- Logo
local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(1, 0, 0, 50)
LogoText.Position = UDim2.new(0, 0, 0, 20)
LogoText.BackgroundTransparency = 1
LogoText.Text = "MYSTRIX"
LogoText.TextColor3 = Color3.fromRGB(255, 80, 80)
LogoText.TextSize = 28
LogoText.Font = Enum.Font.GothamBlack
LogoText.ZIndex = 4
LogoText.Parent = LeftPanel

-- ========== SUBTITLE TEXT DIUBAH ==========
local LogoSub = Instance.new("TextLabel")
LogoSub.Size = UDim2.new(1, 0, 0, 20)
LogoSub.Position = UDim2.new(0, 0, 0, 70)
LogoSub.BackgroundTransparency = 1
LogoSub.Text = "BEST PVP ETFB SCRIPT"  -- Text diubah dari "BEST ETFB SCRIPT" menjadi "BEST PVP ETFB SCRIPT"
LogoSub.TextColor3 = Color3.fromRGB(255, 70, 70)
LogoSub.TextSize = 9
LogoSub.Font = Enum.Font.Gotham
LogoSub.ZIndex = 4
LogoSub.Parent = LeftPanel

local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(0.85, 0, 0, 2)
Divider.Position = UDim2.new(0.075, 0, 0, 100)
Divider.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
Divider.BackgroundTransparency = 0.5
Divider.BorderSizePixel = 0
Divider.ZIndex = 4
Divider.Parent = LeftPanel

-- Stats frame
local StatsFrame = Instance.new("Frame")
StatsFrame.Size = UDim2.new(1, -30, 0, 210)
StatsFrame.Position = UDim2.new(0, 15, 0, 115)
StatsFrame.BackgroundTransparency = 1
StatsFrame.ZIndex = 4
StatsFrame.Parent = LeftPanel

local function addStat(parent, y, label, value)
    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(0.5, -5, 0, 20)
    labelText.Position = UDim2.new(0, 0, 0, y)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.TextColor3 = Color3.fromRGB(200, 60, 60)
    labelText.TextSize = 10
    labelText.Font = Enum.Font.Gotham
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.ZIndex = 4
    labelText.Parent = parent
    
    local valueText = Instance.new("TextLabel")
    valueText.Size = UDim2.new(0.5, -5, 0, 20)
    valueText.Position = UDim2.new(0.5, 5, 0, y)
    valueText.BackgroundTransparency = 1
    valueText.Text = value
    valueText.TextColor3 = Color3.fromRGB(255, 90, 90)
    valueText.TextSize = 10
    valueText.Font = Enum.Font.GothamBold
    valueText.TextXAlignment = Enum.TextXAlignment.Right
    valueText.ZIndex = 4
    valueText.Parent = parent
    
    return valueText
end

local coreVersion = addStat(StatsFrame, 0, "> CORE ENGINE", "v2.4.7")
local encLayer = addStat(StatsFrame, 22, "> ENCRYPTION", "AES-256")
local protocol = addStat(StatsFrame, 44, "> PROTOCOL", "SECURE v3")
local activeNodes = addStat(StatsFrame, 66, "> ACTIVE NODES", "12/12")
local timeStat = addStat(StatsFrame, 88, "> SYSTEM TIME", os.date("%H:%M:%S"))

-- Credit text
local CreditText = Instance.new("TextLabel")
CreditText.Size = UDim2.new(1, -30, 0, 30)
CreditText.Position = UDim2.new(0, 15, 0, 118)
CreditText.BackgroundTransparency = 1
CreditText.Text = "> MADE BY SUMMER SCRIPT"
CreditText.TextColor3 = Color3.fromRGB(255, 70, 70)
CreditText.TextSize = 13
CreditText.Font = Enum.Font.GothamBold
CreditText.TextXAlignment = Enum.TextXAlignment.Left
CreditText.ZIndex = 4
CreditText.Parent = StatsFrame

-- Features text
local FeaturesText = Instance.new("TextLabel")
FeaturesText.Size = UDim2.new(1, -30, 0, 50)
FeaturesText.Position = UDim2.new(0, 15, 0, 152)
FeaturesText.BackgroundTransparency = 1
FeaturesText.Text = "> FEATURES : ESP CANDY, AUTO FARM, AUTO TOWER TRIAL, AUTO ARENA TSUNAMI, ETC."
FeaturesText.TextColor3 = Color3.fromRGB(255, 80, 80)
FeaturesText.TextSize = 10
FeaturesText.Font = Enum.Font.Gotham
FeaturesText.TextXAlignment = Enum.TextXAlignment.Left
FeaturesText.TextWrapped = true
FeaturesText.ZIndex = 4
FeaturesText.Parent = StatsFrame

-- Efek berkedip untuk credit text
task.spawn(function()
    local blinkState = false
    local blinkSpeed = 0.8
    
    while ScreenGui and ScreenGui.Parent do
        blinkState = not blinkState
        
        if blinkState then
            CreditText.TextColor3 = Color3.fromRGB(255, 120, 120)
            CreditText.TextTransparency = 0
            CreditText.TextStrokeTransparency = 0.3
            CreditText.TextStrokeColor3 = Color3.fromRGB(255, 50, 50)
        else
            CreditText.TextColor3 = Color3.fromRGB(180, 60, 60)
            CreditText.TextTransparency = 0.1
            CreditText.TextStrokeTransparency = 0.7
            CreditText.TextStrokeColor3 = Color3.fromRGB(100, 20, 20)
        end
        
        task.wait(blinkSpeed)
    end
end)

-- Efek fade in/out untuk features text
task.spawn(function()
    local pulseTime = 0
    while ScreenGui and ScreenGui.Parent do
        pulseTime = pulseTime + 0.033
        local pulse = (math.sin(pulseTime * 1.5) + 1) / 2
        local intensity = 70 + (pulse * 50)
        FeaturesText.TextColor3 = Color3.fromRGB(255, intensity, intensity)
        task.wait()
    end
end)

-- Divider
local CreditDivider = Instance.new("Frame")
CreditDivider.Size = UDim2.new(0.85, 0, 0, 2)
CreditDivider.Position = UDim2.new(0.075, 0, 0, 113)
CreditDivider.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CreditDivider.BackgroundTransparency = 0.5
CreditDivider.BorderSizePixel = 0
CreditDivider.ZIndex = 4
CreditDivider.Parent = StatsFrame

local FeaturesDivider = Instance.new("Frame")
FeaturesDivider.Size = UDim2.new(0.85, 0, 0, 1)
FeaturesDivider.Position = UDim2.new(0.075, 0, 0, 148)
FeaturesDivider.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
FeaturesDivider.BackgroundTransparency = 0.6
FeaturesDivider.BorderSizePixel = 0
FeaturesDivider.ZIndex = 4
FeaturesDivider.Parent = StatsFrame

-- Update time
task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        timeStat.Text = os.da
