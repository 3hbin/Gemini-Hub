local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local VirtualUser = game:GetService("VirtualUser")
local SocialService = game:GetService("SocialService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

if game.CoreGui:FindFirstChild("GeminiHub") then game.CoreGui.GeminiHub:Destroy() end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "GeminiHub"
ScreenGui.ResetOnSpawn = false

local function createCorner(p, radius) 
    local c = Instance.new("UICorner", p) 
    c.CornerRadius = UDim.new(0, radius or 8) 
    return c 
end

local GuiLocked = false

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if GuiLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if GuiLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if GuiLocked then dragging = false return end
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local ScaleFactor = IsMobile and 0.55 or 1.2 
local BaseWidth = 280
local BaseHeight = IsMobile and 560 or 510
local FrameWidth = math.floor(BaseWidth * ScaleFactor)
local FrameHeight = math.floor(BaseHeight * ScaleFactor)

-- MAIN FRAME
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, IsMobile and 180 or 320, 0, IsMobile and 330 or 550)
MainFrame.Position = UDim2.new(0.5, IsMobile and -90 or -160, 0.5, IsMobile and -165 or -275)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.ClipsDescendants = true
createCorner(MainFrame, 15)
makeDraggable(MainFrame)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(0, 180, 255)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.2

-- LOCK OVERLAY (Dùng để chặn click toàn bộ GUI khi khóa)
local LockOverlay = Instance.new("TextButton", MainFrame)
LockOverlay.Size = UDim2.new(1, 0, 1, IsMobile and -30 or -50)
LockOverlay.Position = UDim2.new(0, 0, 0, IsMobile and 30 or 50)
LockOverlay.BackgroundTransparency = 1
LockOverlay.Text = ""
LockOverlay.ZIndex = 9999
LockOverlay.Visible = false

-- HEADER FRAME
local HeaderFrame = Instance.new("Frame", MainFrame)
HeaderFrame.Size = UDim2.new(1, 0, 0, IsMobile and 30 or 50)
HeaderFrame.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
HeaderFrame.BorderSizePixel = 0
HeaderFrame.Position = UDim2.new(0, 0, 0, 0)
createCorner(HeaderFrame, 15)

local HeaderLabel = Instance.new("TextLabel", HeaderFrame)
HeaderLabel.Position = UDim2.new(0, 10, 0, 0)
HeaderLabel.Size = UDim2.new(1, -90, 1, 0)
HeaderLabel.BackgroundTransparency = 1
HeaderLabel.Text = "🎮 GEMINI HUB"
HeaderLabel.TextColor3 = Color3.new(1, 1, 1)
HeaderLabel.Font = Enum.Font.GothamBold
HeaderLabel.TextSize = IsMobile and 12 or 18
HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
HeaderLabel.TextYAlignment = Enum.TextYAlignment.Center

-- NÚT KHÓA GUI
local LockBtn = Instance.new("TextButton", HeaderFrame)
LockBtn.Size = UDim2.new(0, 35, 1, -10)
LockBtn.Position = UDim2.new(1, -45, 0, 5)
LockBtn.BackgroundTransparency = 0.3
LockBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 160)
LockBtn.Text = "🔓"
LockBtn.TextColor3 = Color3.new(1, 1, 1)
LockBtn.Font = Enum.Font.GothamBold
LockBtn.TextSize = IsMobile and 12 or 16
LockBtn.BorderSizePixel = 0
createCorner(LockBtn, 8)

LockBtn.MouseButton1Click:Connect(function()
    GuiLocked = not GuiLocked
    if GuiLocked then
        LockBtn.Text = "🔒"
        LockBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        LockOverlay.Visible = true
    else
        LockBtn.Text = "🔓"
        LockBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 160)
        LockOverlay.Visible = false
    end
end)

-- TOP FRAME
local TopFrame = Instance.new("Frame", MainFrame)
TopFrame.Size = UDim2.new(1, 0, 0, IsMobile and 140 or 180)
TopFrame.Position = UDim2.new(0, 0, 0, IsMobile and 35 or 50)
TopFrame.BackgroundTransparency = 1

-- KHUNG THÔNG TIN GAME
local GameFrame = Instance.new("Frame", TopFrame)
GameFrame.Size = UDim2.new(1, -16, 0, IsMobile and 85 or 110)
GameFrame.Position = UDim2.new(0, 8, 0, 8)
GameFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
createCorner(GameFrame, 10)

local UIStroke2 = Instance.new("UIStroke", GameFrame)
UIStroke2.Color = Color3.fromRGB(0, 150, 200)
UIStroke2.Thickness = 1
UIStroke2.Transparency = 0.5

local GameNameLabel = Instance.new("TextLabel", GameFrame)
GameNameLabel.Text = "🎮 Đang tải tên game..."
GameNameLabel.Position = UDim2.new(0, 10, 0, 4)
GameNameLabel.Size = UDim2.new(1, -20, 0, IsMobile and 14 or 18)
GameNameLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
GameNameLabel.TextXAlignment = Enum.TextXAlignment.Left
GameNameLabel.Font = Enum.Font.GothamBold
GameNameLabel.TextSize = IsMobile and 10 or 13
GameNameLabel.BackgroundTransparency = 1

local GameIdLabel = Instance.new("TextLabel", GameFrame)
GameIdLabel.Text = "ID: " .. game.PlaceId
GameIdLabel.Position = UDim2.new(0, 10, 0, IsMobile and 19 or 26)
GameIdLabel.Size = UDim2.new(1, -20, 0, 12)
GameIdLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
GameIdLabel.TextXAlignment = Enum.TextXAlignment.Left
GameIdLabel.Font = Enum.Font.Code
GameIdLabel.TextSize = IsMobile and 8 or 9
GameIdLabel.BackgroundTransparency = 1

local CountryLabel = Instance.new("TextLabel", GameFrame)
local countryCode = "Unknown"
pcall(function() 
    countryCode = game:GetService("LocalizationService"):GetCountryRegionForPlayerAsync(LocalPlayer) 
end)
CountryLabel.Text = "📍 Khu vực: " .. string.upper(countryCode)
CountryLabel.Position = UDim2.new(0, 10, 0, IsMobile and 32 or 41)
CountryLabel.Size = UDim2.new(1, -20, 0, 12)
CountryLabel.TextColor3 = Color3.fromRGB(255, 220, 80)
CountryLabel.TextXAlignment = Enum.TextXAlignment.Left
CountryLabel.Font = Enum.Font.GothamSemibold
CountryLabel.TextSize = IsMobile and 8 or 9
CountryLabel.BackgroundTransparency = 1

local IPLabel = Instance.new("TextLabel", GameFrame)
IPLabel.Text = "🌐 IP: Đang kiểm tra..."
IPLabel.Position = UDim2.new(0, 10, 0, IsMobile and 45 or 56)
IPLabel.Size = UDim2.new(1, -20, 0, 12)
IPLabel.TextColor3 = Color3.fromRGB(255, 120, 120)
IPLabel.TextXAlignment = Enum.TextXAlignment.Left
IPLabel.Font = Enum.Font.Code
IPLabel.TextSize = IsMobile and 8 or 9
IPLabel.BackgroundTransparency = 1

local JobIdLabel = Instance.new("TextButton", GameFrame)
JobIdLabel.Text = "🔗 JobId: " .. game.JobId:sub(1, 8) .. "... [TAP]"
JobIdLabel.Position = UDim2.new(0, 10, 0, IsMobile and 58 or 71)
JobIdLabel.Size = UDim2.new(1, -20, 0, IsMobile and 14 or 18)
JobIdLabel.TextColor3 = Color3.fromRGB(150, 180, 255)
JobIdLabel.TextXAlignment = Enum.TextXAlignment.Left
JobIdLabel.BackgroundTransparency = 0.7
JobIdLabel.BackgroundColor3 = Color3.fromRGB(30, 50, 80)
JobIdLabel.Font = Enum.Font.Code
JobIdLabel.TextSize = IsMobile and 8 or 9
createCorner(JobIdLabel, 5)

JobIdLabel.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(game.JobId)
        local oldText = JobIdLabel.Text
        JobIdLabel.Text = "✅ Đã copy!"
        task.wait(2)
        JobIdLabel.Text = oldText
    end
end)

task.spawn(function()
    local ip = "Không thể lấy"
    pcall(function() ip = game:HttpGet("https://api.ipify.org") end)
    IPLabel.Text = "🌐 IP: " .. ip
end)

task.spawn(function()
    pcall(function()
        local info = MarketplaceService:GetProductInfo(game.PlaceId)
        if info then GameNameLabel.Text = "🎮 " .. info.Name end
    end)
end)

-- PROFILE FRAME
local ProfileFrame = Instance.new("Frame", TopFrame)
ProfileFrame.Size = UDim2.new(1, -16, 0, IsMobile and 45 or 55)
ProfileFrame.Position = UDim2.new(0, 8, 0, IsMobile and 100 or 125)
ProfileFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
createCorner(ProfileFrame, 10)

local UIStroke3 = Instance.new("UIStroke", ProfileFrame)
UIStroke3.Color = Color3.fromRGB(0, 150, 200)
UIStroke3.Thickness = 1
UIStroke3.Transparency = 0.5

local ProfileImg = Instance.new("ImageLabel", ProfileFrame)
ProfileImg.Size = UDim2.new(0, IsMobile and 35 or 40, 0, IsMobile and 35 or 40)
ProfileImg.Position = UDim2.new(0, 7, 0.5, IsMobile and -17 or -20)
ProfileImg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
createCorner(ProfileImg, IsMobile and 17 or 20)
pcall(function() ProfileImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100) end)

local NameLabel = Instance.new("TextLabel", ProfileFrame)
NameLabel.Text = LocalPlayer.DisplayName or LocalPlayer.Name
NameLabel.Position = UDim2.new(0, IsMobile and 48 or 56, 0.5, IsMobile and -20 or -22)
NameLabel.Size = UDim2.new(1, IsMobile and -70 or -70, 0, IsMobile and 16 or 18)
NameLabel.TextColor3 = Color3.new(1, 1, 1)
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.Font = Enum.Font.GothamBold
NameLabel.TextSize = IsMobile and 11 or 13
NameLabel.BackgroundTransparency = 1

local StatsLabel = Instance.new("TextLabel", ProfileFrame)
StatsLabel.Position = UDim2.new(0, IsMobile and 48 or 56, 0.5, 0)
StatsLabel.Size = UDim2.new(1, IsMobile and -70 or -70, 0, IsMobile and 16 or 18)
StatsLabel.TextColor3 = Color3.fromRGB(100, 220, 255)
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.Font = Enum.Font.Code
StatsLabel.TextSize = IsMobile and 8 or 10
StatsLabel.BackgroundTransparency = 1

task.spawn(function()
    while task.wait(0.5) do
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local ping = 0
        pcall(function() ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        StatsLabel.Text = "FPS: " .. fps .. " | Ping: " .. ping .. "ms"
    end
end)

-- SPECTATE FRAME
local SpectateFrame = Instance.new("Frame", MainFrame)
SpectateFrame.Size = UDim2.new(1, -16, 0, IsMobile and 45 or 55)
SpectateFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
SpectateFrame.Visible = false
SpectateFrame.Position = UDim2.new(0, 8, 0, IsMobile and 190 or 235)
createCorner(SpectateFrame, 10)

local UIStroke4 = Instance.new("UIStroke", SpectateFrame)
UIStroke4.Color = Color3.fromRGB(0, 150, 200)
UIStroke4.Thickness = 1
UIStroke4.Transparency = 0.5

local SpecAvatar = Instance.new("ImageLabel", SpectateFrame)
SpecAvatar.Size = UDim2.new(0, IsMobile and 33 or 38, 0, IsMobile and 33 or 38)
SpecAvatar.Position = UDim2.new(0, 7, 0.5, IsMobile and -16 or -19)
SpecAvatar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
createCorner(SpecAvatar, IsMobile and 16 or 19)

local SpecName = Instance.new("TextLabel", SpectateFrame)
SpecName.Size = UDim2.new(1, IsMobile and -130 or -120, 0, IsMobile and 33 or 38)
SpecName.Position = UDim2.new(0, IsMobile and 48 or 54, 0.5, IsMobile and -16 or -19)
SpecName.BackgroundTransparency = 1
SpecName.TextColor3 = Color3.new(1, 1, 1)
SpecName.Font = Enum.Font.GothamBold
SpecName.TextSize = IsMobile and 10 or 11
SpecName.TextXAlignment = Enum.TextXAlignment.Left
SpecName.TextYAlignment = Enum.TextYAlignment.Center

local BtnBack = Instance.new("TextButton", SpectateFrame)
BtnBack.Size = UDim2.new(0, 20, 0, 20)
BtnBack.Position = UDim2.new(1, IsMobile and -48 or -58, 0.5, -10)
BtnBack.Text = "◀"
BtnBack.BackgroundColor3 = Color3.fromRGB(0, 100, 180)
BtnBack.TextColor3 = Color3.new(1, 1, 1)
BtnBack.Font = Enum.Font.GothamBold
BtnBack.TextSize = 10
createCorner(BtnBack, 4)

local BtnNext = Instance.new("TextButton", SpectateFrame)
BtnNext.Size = UDim2.new(0, 20, 0, 20)
BtnNext.Position = UDim2.new(1, IsMobile and -22 or -28, 0.5, -10)
BtnNext.Text = "▶"
BtnNext.BackgroundColor3 = Color3.fromRGB(0, 100, 180)
BtnNext.TextColor3 = Color3.new(1, 1, 1)
BtnNext.Font = Enum.Font.GothamBold
BtnNext.TextSize = 10
createCorner(BtnNext, 4)

local playersList = {}
local curSpecIndex = 1
local function updateSpec()
    playersList = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(playersList, p) end
    end
    if #playersList == 0 then return end
    if curSpecIndex > #playersList then curSpecIndex = 1 end
    local p = playersList[curSpecIndex]
    SpecName.Text = p.DisplayName or p.Name
    if p.Character then
        pcall(function() SpecAvatar.Image = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100) end)
        Camera.CameraSubject = p.Character:FindFirstChildOfClass("Humanoid")
    end
end

BtnBack.MouseButton1Click:Connect(function()
    curSpecIndex = curSpecIndex - 1
    if curSpecIndex < 1 then curSpecIndex = #playersList end
    updateSpec()
end)

BtnNext.MouseButton1Click:Connect(function()
    curSpecIndex = curSpecIndex + 1
    if curSpecIndex > #playersList then curSpecIndex = 1 end
    updateSpec()
end)

-- GRID SCROLL FRAME (Sửa lỗi chính tả gốc ở đây)
local GridScrollFrame = Instance.new("ScrollingFrame", MainFrame)
GridScrollFrame.Size = UDim2.new(1, -12, 1, IsMobile and -220 or -305)
GridScrollFrame.Position = UDim2.new(0, 6, 0, IsMobile and 200 or 300)
GridScrollFrame.BackgroundTransparency = 1
GridScrollFrame.ScrollBarThickness = 4
GridScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 200)
GridScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

local Grid = Instance.new("UIGridLayout", GridScrollFrame)
Grid.CellSize = UDim2.new(0.5, IsMobile and -4 or -8, 0, IsMobile and 35 or 50)
Grid.CellPadding = UDim2.new(0, IsMobile and 6 or 10, 0, IsMobile and 6 or 10)
Grid.SortOrder = Enum.SortOrder.LayoutOrder

Grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    GridScrollFrame.CanvasSize = UDim2.new(0, 0, 0, Grid.AbsoluteContentSize.Y + 20)
end)

-- UI Creation Helpers
local function createToggle(text, callback)
    local Btn = Instance.new("TextButton", GridScrollFrame)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
    Btn.Text = text .. "\n[TẮT]"
    Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = IsMobile and 8 or 10
    createCorner(Btn, 8)
    
    local UIStrokeBtn = Instance.new("UIStroke", Btn)
    UIStrokeBtn.Color = Color3.fromRGB(0, 100, 150)
    UIStrokeBtn.Thickness = 1
    UIStrokeBtn.Transparency = 0.5
    
    local isToggled = false
    Btn.MouseButton1Click:Connect(function()
        if GuiLocked then return end
        isToggled = not isToggled
        if isToggled then
            Btn.BackgroundColor3 = Color3.fromRGB(0, 140, 220)
            Btn.Text = text .. "\n[BẬT]"
            Btn.TextColor3 = Color3.new(1, 1, 1)
        else
            Btn.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
            Btn.Text = text .. "\n[TẮT]"
            Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        callback(isToggled)
    end)
    return function(extState) 
        isToggled = extState 
        if isToggled then 
            Btn.BackgroundColor3 = Color3.fromRGB(0, 140, 220) 
            Btn.Text = text .. "\n[BẬT]" 
            Btn.TextColor3 = Color3.new(1, 1, 1) 
        else 
            Btn.BackgroundColor3 = Color3.fromRGB(30, 40, 60) 
            Btn.Text = text .. "\n[TẮT]" 
            Btn.TextColor3 = Color3.fromRGB(180, 180, 180) 
        end 
    end
end

local function createSlider(text, minVal, maxVal, defaultVal, callback)
    local SliderBox = Instance.new("Frame", GridScrollFrame)
    SliderBox.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
    createCorner(SliderBox, 8)
    
    local UIStrokeSlider = Instance.new("UIStroke", SliderBox)
    UIStrokeSlider.Color = Color3.fromRGB(0, 100, 150)
    UIStrokeSlider.Thickness = 1
    UIStrokeSlider.Transparency = 0.5
    
    local Title = Instance.new("TextLabel", SliderBox)
    Title.Size = UDim2.new(1, -10, 0, IsMobile and 15 or 18)
    Title.Position = UDim2.new(0, 5, 0, 2)
    Title.BackgroundTransparency = 1
    Title.Text = text .. ": " .. defaultVal
    Title.TextColor3 = Color3.fromRGB(100, 220, 255)
    Title.Font = Enum.Font.GothamSemibold
    Title.TextSize = IsMobile and 8 or 9
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Track = Instance.new("TextButton", SliderBox)
    Track.Size = UDim2.new(1, -10, 0, 2)
    Track.Position = UDim2.new(0, 5, 1, -10)
    Track.BackgroundColor3 = Color3.fromRGB(50, 60, 80)
    Track.Text = ""
    Track.AutoButtonColor = false
    createCorner(Track, 2)

    local Fill = Instance.new("Frame", Track)
    Fill.Size = UDim2.new((defaultVal - minVal)/(maxVal - minVal), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    createCorner(Fill, 2)

    local Knob = Instance.new("Frame", Track)
    local kDim = 6
    Knob.Size = UDim2.new(0, kDim, 0, kDim)
    Knob.Position = UDim2.new((defaultVal - minVal)/(maxVal - minVal), -kDim/2, 0.5, -kDim/2)
    Knob.BackgroundColor3 = Color3.new(1, 1, 1)
    createCorner(Knob, kDim/2)

    local dragging = false
    local function updateSlider(inputX)
        if GuiLocked then return end
        local percentage = math.clamp((inputX - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local value = math.floor(minVal + (percentage * (maxVal - minVal)))
        Title.Text = text .. ": " .. value
        Fill.Size = UDim2.new(percentage, 0, 1, 0)
        Knob.Position = UDim2.new(percentage, -kDim/2, 0.5, -kDim/2)
        callback(value)
    end

    Track.InputBegan:Connect(function(input)
        if GuiLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true updateSlider(input.Position.X) end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input.Position.X) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

local function createButton(text, color, callback)
    local Btn = Instance.new("TextButton", GridScrollFrame)
    Btn.BackgroundColor3 = color
    Btn.Text = text
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = IsMobile and 8 or 10
    createCorner(Btn, 8)
    
    local UIStrokeBtn = Instance.new("UIStroke", Btn)
    UIStrokeBtn.Color = color
    UIStrokeBtn.Thickness = 1
    UIStrokeBtn.Transparency = 0.3
    
    Btn.MouseButton1Click:Connect(function()
        if GuiLocked then return end
        callback()
    end)
end

-- TOGGLE MENU BUTTON
local ButtonSize = IsMobile and 45 or 65
ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, ButtonSize, 0, ButtonSize)
ToggleBtn.Position = UDim2.new(0, 15, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
ToggleBtn.Text = "📜"
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.TextSize = IsMobile and 24 or 30
createCorner(ToggleBtn, ButtonSize / 2)
makeDraggable(ToggleBtn)

local UIStrokeToggle = Instance.new("UIStroke", ToggleBtn)
UIStrokeToggle.Color = Color3.fromRGB(0, 200, 255)
UIStrokeToggle.Thickness = 2

ToggleBtn.MouseButton1Click:Connect(function()
    if GuiLocked then return end
    MainFrame.Visible = not MainFrame.Visible 
end)

-- ============== CÁC TÍNH NĂNG MỚI & SỬA ĐỔI ==============

-- 1. BAY (FLY MODE)
local Fly_Active = false
local FlySpeed = 60
local FlyConnection

local function StartFly()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local HRP = LocalPlayer.Character.HumanoidRootPart
    local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local BV = Instance.new("BodyVelocity", HRP)
    BV.Name = "FlyVelocity"
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BV.Velocity = Vector3.new(0, 0, 0)
    Humanoid.PlatformStand = true

    FlyConnection = RunService.RenderStepped:Connect(function()
        if Fly_Active and HRP and Humanoid then
            local moveDir = Humanoid.MoveDirection
            if moveDir.Magnitude > 0 then
                local look = Camera.CFrame.LookVector
                local right = Camera.CFrame.RightVector
                local forwardAmount = moveDir:Dot(CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Vector3.new(look.X, 0, look.Z)).LookVector)
                local sideAmount = moveDir:Dot(CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Vector3.new(look.X, 0, look.Z)).RightVector)
                BV.Velocity = (look * forwardAmount * FlySpeed) + (right * sideAmount * FlySpeed)
            else 
                BV.Velocity = Vector3.new(0, 0, 0) 
            end
            HRP.CFrame = CFrame.new(HRP.Position, HRP.Position + Camera.CFrame.LookVector)
        end
    end)
end

local function StopFly()
    Fly_Active = false
    if FlyConnection then FlyConnection:Disconnect() end
    pcall(function() LocalPlayer.Character.HumanoidRootPart.FlyVelocity:Destroy() end)
    pcall(function() LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false end)
end

local setFlyToggle = createToggle("✈️ Bay", function(state)
    Fly_Active = state
    if Fly_Active then StartFly() else StopFly() end
end)

createSlider("Tốc Độ Bay", 20, 300, FlySpeed, function(val) FlySpeed = val end)

-- 2. FLING & FLY FLING (Vật lý văng cao cấp)
local Fling_Active = false
local FlyFling_Active = false
local Fling_Power = 10000

local function GetClosestPlayer()
    local target = nil
    local maxDist = math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if dist < maxDist then
                target = p
                maxDist = dist
            end
        end
    end
    return target
end

-- Vòng lặp Fling
task.spawn(function()
    while true do
        task.wait()
        if (Fling_Active or FlyFling_Active) and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local HRP = LocalPlayer.Character.HumanoidRootPart
            
            -- Ép vận tốc góc xoay cực đại để va chạm mạnh
            local bAV = HRP:FindFirstChild("FlingAngVel") or Instance.new("BodyAngularVelocity", HRP)
            bAV.Name = "FlingAngVel"
            bAV.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bAV.AngularVelocity = Vector3.new(0, Fling_Power, 0)
            
            -- Vận tốc tuyến tính đẩy mục tiêu
            local bV = HRP:FindFirstChild("FlingVel") or Instance.new("BodyVelocity", HRP)
            bV.Name = "FlingVel"
            bV.MaxForce = Vector3.new(math.huge, 0, math.huge)
            
            if Fling_Active then
                local target = GetClosestPlayer()
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    local targetHRP = target.Character.HumanoidRootPart
                    bV.Velocity = (targetHRP.Position - HRP.Position).Unit * 150
                    HRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 0.5) -- Áp sát mục tiêu
                else
                    bV.Velocity = Vector3.new(0, 0, 0)
                end
            elseif FlyFling_Active then
                -- Nếu đang Bay Fling thì chỉ kích hoạt xoay bAV, di chuyển vẫn do Fly Mode kiểm soát
                if not HRP:FindFirstChild("FlyVelocity") then
                    StartFly()
                    Fly_Active = true
                    setFlyToggle(true)
                end
            end
        else
            -- Cleanup khi tắt
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local HRP = LocalPlayer.Character.HumanoidRootPart
                    if HRP:FindFirstChild("FlingAngVel") then HRP.FlingAngVel:Destroy() end
                    if HRP:FindFirstChild("FlingVel") then HRP.FlingVel:Destroy() end
                end
            end)
        end
    end
end)

createToggle("🌀 Fling", function(state) Fling_Active = state end)
createToggle("🚀 Fly Fling", function(state) 
    FlyFling_Active = state 
    if not state then
        StopFly()
        setFlyToggle(false)
    end
end)
createSlider("⚡ Tốc Độ Fling", 1000, 50000, Fling_Power, function(val) Fling_Power = val end)

-- 3. CHỐNG NGÃ (ANTI-RAGDOLL / ANTI-FALL)
local AntiRagdoll_Active = false
task.spawn(function()
    while true do
        task.wait(0.1)
        if AntiRagdoll_Active and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Trip, false)
            if hum:GetState() == Enum.HumanoidStateType.Ragdoll or hum:GetState() == Enum.HumanoidStateType.FallingDown or hum:GetState() == Enum.HumanoidStateType.Trip then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
    end
end)
createToggle("🦵 Chống Ngã", function(state) AntiRagdoll_Active = state end)

-- 4. TRÌNH DUYỆT DANH SÁCH SERVER (SERVER BROWSER)
createButton("🌐 Danh Sách Server", Color3.fromRGB(0, 120, 180), function()
    local ServerGui = Instance.new("ScreenGui", game.CoreGui)
    ServerGui.Name = "ServerBrowser"
    ServerGui.ResetOnSpawn = false
    
    local ServerFrame = Instance.new("Frame", ServerGui)
    ServerFrame.Size = UDim2.new(0, IsMobile and 220 or 400, 0, IsMobile and 300 or 420)
    ServerFrame.Position = UDim2.new(0.5, IsMobile and -110 or -200, 0.5, IsMobile and -150 or -210)
    ServerFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    ServerFrame.BorderSizePixel = 0
    createCorner(ServerFrame, 12)
    makeDraggable(ServerFrame)
    
    local ServerStroke = Instance.new("UIStroke", ServerFrame)
    ServerStroke.Color = Color3.fromRGB(0, 180, 255)
    ServerStroke.Thickness = 2
    
    local ServerHeader = Instance.new("Frame", ServerFrame)
    ServerHeader.Size = UDim2.new(1, 0, 0, 35)
    ServerHeader.BackgroundColor3 = Color3.fromRGB(0, 120, 180)
    ServerHeader.BorderSizePixel = 0
    createCorner(ServerHeader, 12)
    
    local ServerTitle = Instance.new("TextLabel", ServerHeader)
    ServerTitle.Size = UDim2.new(1, -40, 1, 0)
    ServerTitle.Position = UDim2.new(0, 10, 0, 0)
    ServerTitle.BackgroundTransparency = 1
    ServerTitle.Text = "🌍 Danh Sách Server (Small First)"
    ServerTitle.TextColor3 = Color3.new(1, 1, 1)
    ServerTitle.Font = Enum.Font.GothamBold
    ServerTitle.TextSize = 12
    ServerTitle.TextXAlignment = Enum.TextXAlignment.Left
    ServerTitle.TextYAlignment = Enum.TextYAlignment.Center
    
    local CloseServer = Instance.new("TextButton", ServerHeader)
    CloseServer.Size = UDim2.new(0, 30, 1, 0)
    CloseServer.Position = UDim2.new(1, -35, 0, 0)
    CloseServer.BackgroundTransparency = 0.5
    CloseServer.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseServer.Text = "✕"
    CloseServer.TextColor3 = Color3.new(1, 1, 1)
    CloseServer.Font = Enum.Font.GothamBold
    CloseServer.TextSize = 16
    createCorner(CloseServer, 8)
    CloseServer.MouseButton1Click:Connect(function() ServerGui:Destroy() end)
    
    local ListScroll = Instance.new("ScrollingFrame", ServerFrame)
    ListScroll.Size = UDim2.new(1, -10, 1, -45)
    ListScroll.Position = UDim2.new(0, 5, 0, 40)
    ListScroll.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
    ListScroll.ScrollBarThickness = 3
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    createCorner(ListScroll, 8)
    
    local ListLayout = Instance.new("UIListLayout", ListScroll)
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ListScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Load danh sách API và vẽ từng Server Item
    task.spawn(function()
        local api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=25"
        local success, rawData = pcall(function() return game:HttpGet(api) end)
        if not success then return end
        
        local data = HttpService:JSONDecode(rawData)
        local servers = {}
        for _, v in pairs(data.data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                table.insert(servers, v)
            end
        end
        
        -- Sắp xếp Server nhỏ nhất lên đầu (Small Server)
        table.sort(servers, function(a, b) return a.playing < b.playing end)
        
        for i, sv in ipairs(servers) do
            local ItemFrame = Instance.new("Frame", ListScroll)
            ItemFrame.Size = UDim2.new(1, -10, 0, 55)
            ItemFrame.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
            createCorner(ItemFrame, 8)
            
            local InfoLabel = Instance.new("TextLabel", ItemFrame)
            InfoLabel.Size = UDim2.new(0.6, 0, 0.4, 0)
            InfoLabel.Position = UDim2.new(0, 8, 0, 4)
            InfoLabel.BackgroundTransparency = 1
            InfoLabel.TextColor3 = Color3.new(1, 1, 1)
            InfoLabel.Font = Enum.Font.GothamBold
            InfoLabel.TextSize = 10
            InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
            InfoLabel.Text = "👤 " .. sv.playing .. "/" .. sv.maxPlayers .. "  |  🆔: " .. sv.id:sub(1, 8)
            
            -- Vẽ Avatar của người chơi trong Server đó
            local AvatarContainer = Instance.new("Frame", ItemFrame)
            AvatarContainer.Size = UDim2.new(0.6, 0, 0.4, 0)
            AvatarContainer.Position = UDim2.new(0, 8, 0.5, 2)
            AvatarContainer.BackgroundTransparency = 1
            
            local AvatarLayout = Instance.new("UIListLayout", AvatarContainer)
            AvatarLayout.FillDirection = Enum.FillDirection.Horizontal
            AvatarLayout.Padding = UDim.new(0, 4)
            
            if sv.playerTokens then
                for idx, token in ipairs(sv.playerTokens) do
                    if idx > 5 then break end -- Giới hạn hiển thị 5 avatar để tránh lag
                    local Img = Instance.new("ImageLabel", AvatarContainer)
                    Img.Size = UDim2.new(0, 18, 0, 18)
                    Img.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
                    createCorner(Img, 9)
                    
                    task.spawn(function()
                        pcall(function()
                            -- Sử dụng API Web của Roblox để lấy headshot từ playerToken
                            local avatarApi = "https://thumbnails.roblox.com/v1/users/avatar-headshot?size=48x48&format=Png&isCircular=true&playerToken=" .. token
                            local avatarRaw = game:HttpGet(avatarApi)
                            local avatarData = HttpService:JSONDecode(avatarRaw)
                            if avatarData and avatarData.data and avatarData.data[1] then
                                Img.Image = avatarData.data[1].imageUrl
                            end
                        end)
                    end)
                end
            end
            
            local JoinBtn = Instance.new("TextButton", ItemFrame)
            JoinBtn.Size = UDim2.new(0.3, 0, 0.6, 0)
            JoinBtn.Position = UDim2.new(0.7, -8, 0.2, 0)
            JoinBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 220)
            JoinBtn.TextColor3 = Color3.new(1, 1, 1)
            JoinBtn.Font = Enum.Font.GothamBold
            JoinBtn.TextSize = 10
            JoinBtn.Text = "Vào"
            createCorner(JoinBtn, 6)
            
            JoinBtn.MouseButton1Click:Connect(function()
                if syn and syn.queue_on_teleport then
                    syn.queue_on_teleport([[loadstring(game:HttpGet("https://raw.githubusercontent.com/3hbin/Gemini-Hub/refs/heads/main/GeminiHub.lua"))()]])
                elseif queue_on_teleport then
                    queue_on_teleport([[loadstring(game:HttpGet("https://raw.githubusercontent.com/3hbin/Gemini-Hub/refs/heads/main/GeminiHub.lua"))()]])
                end
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, sv.id, LocalPlayer)
            end)
        end
    end)
end)

-- ============== PHẦN CÒN LẠI CỦA SCRIPT GỐC ==============

-- 5. INF HP
local InfHP_Active = false
createToggle("❤️ Vô Hạn HP", function(state)
    InfHP_Active = state
    if state then
        task.spawn(function()
            while InfHP_Active do
                task.wait()
                pcall(function()
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChildOfClass("Humanoid") then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        hum.Health = hum.MaxHealth
                    end
                end)
            end
        end)
    end
end)

-- 6. INF JUMP
local InfJump_Active = false
local JumpConnection
createToggle("⬆️ Nhảy Vô Hạn", function(state)
    InfJump_Active = state
    if InfJump_Active then
        JumpConnection = UserInputService.JumpRequest:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end)
    else
        if JumpConnection then JumpConnection:Disconnect() end
    end
end)

-- 7. AUTO KITE
local AutoKite_Active = false
createToggle("🏃 Tự Lùi", function(state) AutoKite_Active = state end)

-- 8. ESP
local ESP_Active = false
local function updateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            pcall(function() p.Character.ESPHighlight:Destroy() end)
            pcall(function() p.Character.Head:FindFirstChild("ESP_NameTag"):Destroy() end)

            if ESP_Active then
                local hl = Instance.new("Highlight", p.Character)
                hl.Name = "ESPHighlight"
                hl.FillColor = Color3.fromRGB(0, 255, 150)
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

                local bill = Instance.new("BillboardGui", p.Character.Head)
                bill.Name = "ESP_NameTag"
                bill.Size = UDim2.new(0, 200, 0, 50)
                bill.StudsOffset = Vector3.new(0, 2, 0)
                bill.AlwaysOnTop = true

                local name = Instance.new("TextLabel", bill)
                name.Size = UDim2.new(1, 0, 1, 0)
                name.Text = p.DisplayName or p.Name
                name.TextColor3 = Color3.fromRGB(0, 255, 150)
                name.TextStrokeTransparency = 0
                name.BackgroundTransparency = 1
                name.Font = Enum.Font.GothamBold
                name.TextSize = 12
            end
        end
    end
end
createToggle("👁️ ESP", function(state) ESP_Active = state updateESP() end)
Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function() task.wait(1) if ESP_Active then updateESP() end end) end)

-- 9. ANTI KICK
local AntiKick_Active = false
task.spawn(function()
    local oldKick
    pcall(function()
        oldKick = hookfunction(LocalPlayer.Kick, function(self, reason)
            if AntiKick_Active then return nil end
            return oldKick(self, reason)
        end)
    end)
end)
createToggle("🛡️ Chống Kick", function(state) AntiKick_Active = state end)

-- 10. SHIFT LOCK
if IsMobile then
    local ShiftLock_Active = false
    createToggle("📱 Khóa Tâm", function(state) 
        ShiftLock_Active = state 
        if not state then UserInputService.MouseBehavior = Enum.MouseBehavior.Default end 
    end)
    RunService.RenderStepped:Connect(function()
        if ShiftLock_Active and IsMobile and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            local HRP = LocalPlayer.Character.HumanoidRootPart
            HRP.CFrame = CFrame.new(HRP.Position, HRP.Position + Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z))
        end
    end)
end

-- 11. GAME INVITE
createButton("📧 Mời Bạn", Color3.fromRGB(60, 130, 80), function()
    pcall(function() SocialService:PromptGameInvite(LocalPlayer) end)
end)

-- 12. SPECTATE
createToggle("👀 Theo Dõi", function(state)
    SpectateFrame.Visible = state
    if state then updateSpec() else Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end
end)

-- 13. AI BOT
local AI_Active = false
RunService.RenderStepped:Connect(function()
    if AI_Active and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local HRP = LocalPlayer.Character.HumanoidRootPart
        local Humanoid = LocalPlayer.Character.Humanoid
        local nearestPlayer = nil
        local shortestDistance = 300
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (p.Character.HumanoidRootPart.Position - HRP.Position).Magnitude
                if distance < shortestDistance then nearestPlayer = p shortestDistance = distance end
            end
        end
        if nearestPlayer then Humanoid:MoveTo(nearestPlayer.Character.HumanoidRootPart.Position) end
    end
end)
createToggle("🤖 AI Bot", function(state) AI_Active = state end)

-- 14. COPY GAME LINK
createButton("🔗 Copy Link", Color3.fromRGB(100, 70, 150), function()
    if setclipboard then setclipboard("https://www.roblox.com/games/" .. game.PlaceId) end
end)

-- 15. SPIN
local Spin_Active = false
RunService.RenderStepped:Connect(function()
    if Spin_Active and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(45), 0)
    end
end)
createToggle("🌀 Xoay", function(state) Spin_Active = state end)

-- 16. AUTO OBBY
local AutoObby_Active = false
createToggle("🏁 Auto Obby", function(state)
    AutoObby_Active = state
    while AutoObby_Active and task.wait(0.4) do
        pcall(function()
            for _, obj in pairs(workspace:GetDescendants()) do
                if (obj.Name:lower():find("checkpoint") or obj.Name:lower():find("finish")) and obj:IsA("BasePart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(obj.Position + Vector3.new(0, 3, 0))
                    task.wait(0.2)
                end
            end
        end)
    end
end)

-- 17. AUTO FARM
local AutoFarm_Active = false
createToggle("⚔️ Auto Farm", function(state)
    AutoFarm_Active = state
    task.spawn(function()
        while AutoFarm_Active do
            task.wait(0.1)
            pcall(function()
                local target = nil
                local maxDist = 200
                
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                        local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if dist < maxDist then target = p.Character maxDist = dist end
                    end
                end
                
                if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local HRP = LocalPlayer.Character.HumanoidRootPart
                    
                    if AutoKite_Active then
                        HRP.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 6)
                        task.wait(0.05)
                    else
                        HRP.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    end
                    
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool") or LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                    if tool then 
                        if tool.Parent ~= LocalPlayer.Character then tool.Parent = LocalPlayer.Character end
                        tool:Activate() 
                    end
                end
            end)
        end
    end)
end)

-- 18. GHOST HIT
local GhostHit_Active = false
createToggle("👻 Ghost Hit", function(state) 
    GhostHit_Active = state 
    pcall(function()
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool") or LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Handle") then
            if GhostHit_Active then
                tool.Handle.Massless = true
                tool.Handle.Size = Vector3.new(20, 20, 20)
                tool.Handle.CanCollide = false
                tool.Handle.Transparency = 0.7
            else
                tool.Handle.Size = Vector3.new(1, 1, 1)
                tool.Handle.Transparency = 0
            end
        end
    end)
end)

-- 19. NOCLIP
local Noclip_Active = false
RunService.Stepped:Connect(function()
    if (Noclip_Active or Fly_Active) and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)
createToggle("🚫 Noclip", function(state) Noclip_Active = state end)

-- 20. AFK
local AFK_Active = false
LocalPlayer.Idled:Connect(function() if AFK_Active then VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame) task.wait(1) VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame) end end)
createToggle("💤 AFK", function(state) AFK_Active = state end)

-- 21-22. JUMP POWER & WALK SPEED
local JumpPower = 50
createSlider("⬆️ Lực Nhảy", 50, 300, JumpPower, function(val)
    JumpPower = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower = val end
end)

local Speed_Val = 16
createSlider("💨 Tốc Độ", 16, 150, Speed_Val, function(val)
    Speed_Val = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = val end
end)

-- 23. INFINITE YIELD
createButton("📋 Inf Yield", Color3.fromRGB(120, 80, 50), function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

-- 24. CHAT AI
createButton("💬 Chat AI", Color3.fromRGB(100, 50, 150), function()
    local ChatGui = Instance.new("ScreenGui", game.CoreGui)
    ChatGui.Name = "ChatAI"
    ChatGui.ResetOnSpawn = false
    
    local ChatFrame = Instance.new("Frame", ChatGui)
    ChatFrame.Size = UDim2.new(0, IsMobile and 200 or 350, 0, IsMobile and 300 or 400)
    ChatFrame.Position = UDim2.new(0.5, IsMobile and -100 or -175, 0.5, IsMobile and -150 or -200)
    ChatFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    ChatFrame.BorderSizePixel = 0
    createCorner(ChatFrame, 12)
    makeDraggable(ChatFrame)
    
    local ChatStroke = Instance.new("UIStroke", ChatFrame)
    ChatStroke.Color = Color3.fromRGB(100, 200, 255)
    ChatStroke.Thickness = 2
    
    local ChatHeader = Instance.new("Frame", ChatGui)
    ChatHeader.Size = UDim2.new(1, 0, 0, 35)
    ChatHeader.BackgroundColor3 = Color3.fromRGB(0, 100, 180)
    ChatHeader.BorderSizePixel = 0
    createCorner(ChatHeader, 12)
    
    local ChatTitle = Instance.new("TextLabel", ChatHeader)
    ChatTitle.Size = UDim2.new(1, -40, 1, 0)
    ChatTitle.Position = UDim2.new(0, 10, 0, 0)
    ChatTitle.BackgroundTransparency = 1
    ChatTitle.Text = "💬 Chat AI"
    ChatTitle.TextColor3 = Color3.new(1, 1, 1)
    ChatTitle.Font = Enum.Font.GothamBold
    ChatTitle.TextSize = 14
    ChatTitle.TextXAlignment = Enum.TextXAlignment.Left
    ChatTitle.TextYAlignment = Enum.TextYAlignment.Center
    
    local CloseChat = Instance.new("TextButton", ChatHeader)
    CloseChat.Size = UDim2.new(0, 30, 1, 0)
    CloseChat.Position = UDim2.new(1, -35, 0, 0)
    CloseChat.BackgroundTransparency = 0.5
    CloseChat.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseChat.Text = "✕"
    CloseChat.TextColor3 = Color3.new(1, 1, 1)
    CloseChat.Font = Enum.Font.GothamBold
    CloseChat.TextSize = 16
    createCorner(CloseChat, 8)
    CloseChat.MouseButton1Click:Connect(function() ChatGui:Destroy() end)
    
    local MessagesFrame = Instance.new("ScrollingFrame", ChatFrame)
    MessagesFrame.Size = UDim2.new(1, -10, 1, -90)
    MessagesFrame.Position = UDim2.new(0, 5, 0, 40)
    MessagesFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
    MessagesFrame.ScrollBarThickness = 3
    MessagesFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    createCorner(MessagesFrame, 8)
    
    local MessagesLayout = Instance.new("UIListLayout", MessagesFrame)
    MessagesLayout.Padding = UDim.new(0, 5)
    MessagesLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    MessagesLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        MessagesFrame.CanvasSize = UDim2.new(0, 0, 0, MessagesLayout.AbsoluteContentSize.Y + 10)
        MessagesFrame.CanvasPosition = Vector2.new(0, MessagesLayout.AbsoluteContentSize.Y)
    end)
    
    local InputFrame = Instance.new("Frame", ChatFrame)
    InputFrame.Size = UDim2.new(1, -10, 0, 40)
    InputFrame.Position = UDim2.new(0, 5, 1, -45)
    InputFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
    createCorner(InputFrame, 8)
    
    local InputBox = Instance.new("TextBox", InputFrame)
    InputBox.Size = UDim2.new(1, -40, 1, 0)
    InputBox.Position = UDim2.new(0, 5, 0, 0)
    InputBox.BackgroundTransparency = 1
    InputBox.TextColor3 = Color3.new(1, 1, 1)
    InputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    InputBox.PlaceholderText = "Nhập câu hỏi..."
    InputBox.Font = Enum.Font.Code
    InputBox.TextSize = 11
    InputBox.MultiLine = false
    
    local SendBtn = Instance.new("TextButton", InputFrame)
    SendBtn.Size = UDim2.new(0, 35, 1, 0)
    SendBtn.Position = UDim2.new(1, -35, 0, 0)
    SendBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    SendBtn.Text = "▶"
    SendBtn.TextColor3 = Color3.new(1, 1, 1)
    SendBtn.Font = Enum.Font.GothamBold
    SendBtn.TextSize = 14
    createCorner(SendBtn, 6)
    
    local function addMessage(text, isUser)
        local MsgLabel = Instance.new("TextLabel", MessagesFrame)
        MsgLabel.BackgroundColor3 = isUser and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(40, 50, 70)
        MsgLabel.TextColor3 = Color3.new(1, 1, 1)
        MsgLabel.Font = Enum.Font.Code
        MsgLabel.TextSize = 10
        MsgLabel.TextWrapped = true
        MsgLabel.TextXAlignment = Enum.TextXAlignment.Left
        MsgLabel.TextYAlignment = Enum.TextYAlignment.Top
        MsgLabel.Size = UDim2.new(1, -10, 0, 50)
        MsgLabel.Text = (isUser and "You: " or "AI: ") .. text
        createCorner(MsgLabel, 6)
        
        local Padding = Instance.new("UIPadding", MsgLabel)
        Padding.PaddingLeft = UDim.new(0, 8)
        Padding.PaddingTop = UDim.new(0, 5)
    end
    
    SendBtn.MouseButton1Click:Connect(function()
        local userText = InputBox.Text:gsub("^%s+|%s+$", "")
        if userText == "" then return end
        
        addMessage(userText, true)
        InputBox.Text = ""
        
        task.spawn(function()
            task.wait(1)
            local responses = {
                ["xin chào"] = "Xin chào! Mình là AI của Gemini Hub 🤖",
                ["hello"] = "Hello! I'm Gemini Hub AI!",
                ["cách chơi"] = "Bấm các nút toggle để bật/tắt tính năng!",
                ["help"] = "Gõ: Xin chào, Cách chơi, Lua Code",
            }
            
            local lowerText = userText:lower()
            local response = "Tôi không hiểu. Thử hỏi: Xin chào, Help"
            
            for key, value in pairs(responses) do
                if lowerText:find(key) then response = value break end
            end
            
            addMessage(response, false)
        end)
    end)
    
    InputBox.FocusLost:Connect(function(enterPressed) if enterPressed then SendBtn:Fire() end end)
    addMessage("Xin chào! Gõ câu hỏi để bắt đầu! 👋", false)
end)

-- 25. LUA CODE EXECUTOR
createButton("⚙️ Lua Code", Color3.fromRGB(80, 100, 50), function()
    local CodeGui = Instance.new("ScreenGui", game.CoreGui)
    CodeGui.Name = "LuaExecutor"
    CodeGui.ResetOnSpawn = false
    
    local CodeFrame = Instance.new("Frame", CodeGui)
    CodeFrame.Size = UDim2.new(0, IsMobile and 220 or 400, 0, IsMobile and 350 or 450)
    CodeFrame.Position = UDim2.new(0.5, IsMobile and -110 or -200, 0.5, IsMobile and -175 or -225)
    CodeFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    CodeFrame.BorderSizePixel = 0
    createCorner(CodeFrame, 12)
    makeDraggable(CodeFrame)
    
    local CodeStroke = Instance.new("UIStroke", CodeFrame)
    CodeStroke.Color = Color3.fromRGB(150, 180, 50)
    CodeStroke.Thickness = 2
    
    local CodeHeader = Instance.new("Frame", CodeFrame)
    CodeHeader.Size = UDim2.new(1, 0, 0, 35)
    CodeHeader.BackgroundColor3 = Color3.fromRGB(80, 100, 50)
    CodeHeader.BorderSizePixel = 0
    createCorner(CodeHeader, 12)
    
    local CodeTitle = Instance.new("TextLabel", CodeHeader)
    CodeTitle.Size = UDim2.new(1, -40, 1, 0)
    CodeTitle.Position = UDim2.new(0, 10, 0, 0)
    CodeTitle.BackgroundTransparency = 1
    CodeTitle.Text = "⚙️ Lua Code"
    CodeTitle.TextColor3 = Color3.new(1, 1, 1)
    CodeTitle.Font = Enum.Font.GothamBold
    CodeTitle.TextSize = 14
    CodeTitle.TextXAlignment = Enum.TextXAlignment.Left
    CodeTitle.TextYAlignment = Enum.TextYAlignment.Center
    
    local CloseCode = Instance.new("TextButton", CodeHeader)
    CloseCode.Size = UDim2.new(0, 30, 1, 0)
    CloseCode.Position = UDim2.new(1, -35, 0, 0)
    CloseCode.BackgroundTransparency = 0.5
    CloseCode.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseCode.Text = "✕"
    CloseCode.TextColor3 = Color3.new(1, 1, 1)
    CloseCode.Font = Enum.Font.GothamBold
    CloseCode.TextSize = 16
    createCorner(CloseCode, 8)
    CloseCode.MouseButton1Click:Connect(function() CodeGui:Destroy() end)
    
    local CodeInputBox = Instance.new("TextBox", CodeFrame)
    CodeInputBox.Size = UDim2.new(1, -10, 1, -95)
    CodeInputBox.Position = UDim2.new(0, 5, 0, 40)
    CodeInputBox.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
    CodeInputBox.TextColor3 = Color3.fromRGB(100, 255, 150)
    CodeInputBox.PlaceholderColor3 = Color3.fromRGB(80, 80, 80)
    CodeInputBox.PlaceholderText = "print('Hello')\nprint(LocalPlayer.Name)"
    CodeInputBox.Font = Enum.Font.Code
    CodeInputBox.TextSize = 10
    CodeInputBox.MultiLine = true
    CodeInputBox.ClearTextOnFocus = false
    createCorner(CodeInputBox, 8)
    
    local ResultBox = Instance.new("TextLabel", CodeFrame)
    ResultBox.Size = UDim2.new(1, -10, 0, 40)
    ResultBox.Position = UDim2.new(0, 5, 1, -50)
    ResultBox.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
    ResultBox.TextColor3 = Color3.fromRGB(100, 255, 100)
    ResultBox.Font = Enum.Font.Code
    ResultBox.TextSize = 9
    ResultBox.TextWrapped = true
    ResultBox.TextXAlignment = Enum.TextXAlignment.Left
    ResultBox.TextYAlignment = Enum.TextYAlignment.Top
    ResultBox.Text = "✅ Kết quả sẽ hiển thị ở đây..."
    createCorner(ResultBox, 8)
    
    local UIPadding = Instance.new("UIPadding", ResultBox)
    UIPadding.PaddingLeft = UDim.new(0, 8)
    UIPadding.PaddingTop = UDim.new(0, 5)
    
    local ExecuteBtn = Instance.new("TextButton", CodeFrame)
    ExecuteBtn.Size = UDim2.new(0.5, -6, 0, 35)
    ExecuteBtn.Position = UDim2.new(0, 5, 1, -45)
    ExecuteBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    ExecuteBtn.Text = "▶ Execute"
    ExecuteBtn.TextColor3 = Color3.new(1, 1, 1)
    ExecuteBtn.Font = Enum.Font.GothamBold
    ExecuteBtn.TextSize = 12
    createCorner(ExecuteBtn, 6)
    
    local ClearBtn = Instance.new("TextButton", CodeFrame)
    ClearBtn.Size = UDim2.new(0.5, -6, 0, 35)
    ClearBtn.Position = UDim2.new(0.5, 3, 1, -45)
    ClearBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    ClearBtn.Text = "🗑 Clear"
    ClearBtn.TextColor3 = Color3.new(1, 1, 1)
    ClearBtn.Font = Enum.Font.GothamBold
    ClearBtn.TextSize = 12
    createCorner(ClearBtn, 6)
    
    ExecuteBtn.MouseButton1Click:Connect(function()
        local code = CodeInputBox.Text
        if code == "" then ResultBox.Text = "❌ Code trống!" return end
        
        local success, result = pcall(function() return loadstring(code)() end)
        
        if success then
            ResultBox.TextColor3 = Color3.fromRGB(100, 255, 100)
            ResultBox.Text = "✅ Thực thi thành công!\n" .. tostring(result or "nil")
        else
            ResultBox.TextColor3 = Color3.fromRGB(255, 100, 100)
            ResultBox.Text = "❌ Lỗi:\n" .. tostring(result)
        end
    end)
    
    ClearBtn.MouseButton1Click:Connect(function()
        CodeInputBox.Text = ""
        ResultBox.Text = "✅ Kết quả sẽ hiển thị ở đây..."
        ResultBox.TextColor3 = Color3.fromRGB(100, 255, 100)
    end)
end)

-- CLOSE BUTTON
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(1, -12, 0, IsMobile and 25 or 35)
CloseBtn.Position = UDim2.new(0, 6, 1, IsMobile and -33 or -45)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = IsMobile and 9 or 12
CloseBtn.Text = "❌ Ẩn Menu"
createCorner(CloseBtn, 8)

local UIStrokeClose = Instance.new("UIStroke", CloseBtn)
UIStrokeClose.Color = Color3.fromRGB(220, 80, 80)
UIStrokeClose.Thickness = 1

CloseBtn.MouseButton1Click:Connect(function() 
    if GuiLocked then return end
    MainFrame.Visible = false 
end)
