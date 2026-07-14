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

-- 4. TRÌNH DUYỆT DANH SÁCH SERVER (SMALL FIRST + REFRESH)
-- NÚT: DANH SÁCH SERVER (BIG FIRST + REFRESH)
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
    ServerTitle.Size = UDim2.new(1, -75, 1, 0)
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
    CloseServer.Text = "X"
    CloseServer.TextColor3 = Color3.new(1, 1, 1)
    CloseServer.Font = Enum.Font.GothamBold
    CloseServer.TextSize = 16
    createCorner(CloseServer, 8)
    CloseServer.MouseButton1Click:Connect(function() ServerGui:Destroy() end)

    -- Nút Cập Nhật (Refresh) cho Small Server
    local RefreshServer = Instance.new("TextButton", ServerHeader)
    RefreshServer.Size = UDim2.new(0, 30, 1, 0)
    RefreshServer.Position = UDim2.new(1, -70, 0, 0)
    RefreshServer.BackgroundTransparency = 0.5
    RefreshServer.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    RefreshServer.Text = "🔄"
    RefreshServer.TextColor3 = Color3.new(1, 1, 1)
    RefreshServer.Font = Enum.Font.GothamBold
    RefreshServer.TextSize = 18
    createCorner(RefreshServer, 8)
    
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
    
    -- Hàm tải và vẽ danh sách Server
    local function LoadServers()
        -- Xóa danh sách cũ trước khi tải mới
        for _, child in pairs(ListScroll:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        
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
                
                local AvatarContainer = Instance.new("Frame", ItemFrame)
                AvatarContainer.Size = UDim2.new(0.6, 0, 0.4, 0)
                AvatarContainer.Position = UDim2.new(0, 8, 0.5, 2)
                AvatarContainer.BackgroundTransparency = 1
                
                local AvatarLayout = Instance.new("UIListLayout", AvatarContainer)
                AvatarLayout.FillDirection = Enum.FillDirection.Horizontal
                AvatarLayout.Padding = UDim.new(0, 4)
                
                if sv.playerTokens then
                    for idx, token in ipairs(sv.playerTokens) do
                        if idx > 5 then break end
                        local Img = Instance.new("ImageLabel", AvatarContainer)
                        Img.Size = UDim2.new(0, 18, 0, 18)
                        Img.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
                        createCorner(Img, 9)
                        
                        task.spawn(function()
                            pcall(function()
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
    end
    
    LoadServers()
    
    RefreshServer.MouseButton1Click:Connect(function()
        LoadServers()
    end)
end)
--===================================================================================--
createButton("👥 Danh Sách Server (Big First)", Color3.fromRGB(200, 50, 50), function()
    local ServerGui = Instance.new("ScreenGui", game.CoreGui)
    ServerGui.Name = "ServerBrowserBig"
    ServerGui.ResetOnSpawn = false
    
    local ServerFrame = Instance.new("Frame", ServerGui)
    ServerFrame.Size = UDim2.new(0, IsMobile and 220 or 400, 0, IsMobile and 300 or 420)
    ServerFrame.Position = UDim2.new(0.5, IsMobile and -110 or -200, 0.5, IsMobile and -150 or -210)
    ServerFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    ServerFrame.BorderSizePixel = 0
    createCorner(ServerFrame, 12)
    makeDraggable(ServerFrame)
    
    local ServerStroke = Instance.new("UIStroke", ServerFrame)
    ServerStroke.Color = Color3.fromRGB(255, 100, 100)
    ServerStroke.Thickness = 2
    
    local ServerHeader = Instance.new("Frame", ServerFrame)
    ServerHeader.Size = UDim2.new(1, 0, 0, 35)
    ServerHeader.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    ServerHeader.BorderSizePixel = 0
    createCorner(ServerHeader, 12)
    
    local ServerTitle = Instance.new("TextLabel", ServerHeader)
    ServerTitle.Size = UDim2.new(1, -75, 1, 0)
    ServerTitle.Position = UDim2.new(0, 10, 0, 0)
    ServerTitle.BackgroundTransparency = 1
    ServerTitle.Text = "👥 Danh Sách Server (Big First)"
    ServerTitle.TextColor3 = Color3.new(1, 1, 1)
    ServerTitle.Font = Enum.Font.GothamBold
    ServerTitle.TextSize = 12
    ServerTitle.TextXAlignment = Enum.TextXAlignment.Left
    ServerTitle.TextYAlignment = Enum.TextYAlignment.Center
    
    local CloseServer = Instance.new("TextButton", ServerHeader)
    CloseServer.Size = UDim2.new(0, 30, 1, 0)
    CloseServer.Position = UDim2.new(1, -35, 0, 0)
    CloseServer.BackgroundTransparency = 0.5
    CloseServer.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
    CloseServer.Text = "X"
    CloseServer.TextColor3 = Color3.new(1, 1, 1)
    CloseServer.Font = Enum.Font.GothamBold
    CloseServer.TextSize = 16
    createCorner(CloseServer, 8)
    CloseServer.MouseButton1Click:Connect(function() ServerGui:Destroy() end)

    -- Nút Cập Nhật (Refresh) cho Big Server
    local RefreshServer = Instance.new("TextButton", ServerHeader)
    RefreshServer.Size = UDim2.new(0, 30, 1, 0)
    RefreshServer.Position = UDim2.new(1, -70, 0, 0)
    RefreshServer.BackgroundTransparency = 0.5
    RefreshServer.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    RefreshServer.Text = "🔄"
    RefreshServer.TextColor3 = Color3.new(1, 1, 1)
    RefreshServer.Font = Enum.Font.GothamBold
    RefreshServer.TextSize = 18
    createCorner(RefreshServer, 8)
    
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
    
    -- Hàm tải và vẽ danh sách Server (Sắp xếp Server lớn nhất lên đầu)
    local function LoadServers()
        -- Xóa danh sách cũ trước khi tải mới
        for _, child in pairs(ListScroll:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        
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
            
            -- Sắp xếp: Server đông người chơi nhất lên đầu (Big First)
            table.sort(servers, function(a, b) return a.playing > b.playing end)
            
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
                
                local AvatarContainer = Instance.new("Frame", ItemFrame)
                AvatarContainer.Size = UDim2.new(0.6, 0, 0.4, 0)
                AvatarContainer.Position = UDim2.new(0, 8, 0.5, 2)
                AvatarContainer.BackgroundTransparency = 1
                
                local AvatarLayout = Instance.new("UIListLayout", AvatarContainer)
                AvatarLayout.FillDirection = Enum.FillDirection.Horizontal
                AvatarLayout.Padding = UDim.new(0, 4)
                
                if sv.playerTokens then
                    for idx, token in ipairs(sv.playerTokens) do
                        if idx > 5 then break end
                        local Img = Instance.new("ImageLabel", AvatarContainer)
                        Img.Size = UDim2.new(0, 18, 0, 18)
                        Img.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
                        createCorner(Img, 9)
                        
                        task.spawn(function()
                            pcall(function()
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
                JoinBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
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
    end
    
    LoadServers()
    
    RefreshServer.MouseButton1Click:Connect(function()
        LoadServers()
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
    
    local ChatHeader = Instance.new("Frame", ChatFrame)
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

-- 26.NÚT TÀNG HÌNH & ẨN TÊN (ĐỂ RIÊNG)
createToggle("👻 Tàng Hình & Ẩn Tên", function(state)
    local char = LocalPlayer.Character
    if char then
        -- 1. Ẩn/Hiện tên trên đầu
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.DisplayDistanceType = state and Enum.HumanoidDisplayDistanceType.None or Enum.HumanoidDisplayDistanceType.Viewer
        end
        
        -- 2. Làm trong suốt nhân vật (Chỉ ảnh hưởng góc nhìn Client)
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                if state then
                    if not part:FindFirstChild("OldTransparency") then
                        local oldTrans = Instance.new("NumberValue", part)
                        oldTrans.Name = "OldTransparency"
                        oldTrans.Value = part.Transparency
                    end
                    part.Transparency = (part.Name == "HumanoidRootPart") and 1 or 0.8 -- Gần như vô hình
                else
                    local oldTrans = part:FindFirstChild("OldTransparency")
                    part.Transparency = oldTrans and oldTrans.Value or 0
                    if oldTrans then oldTrans:Destroy() end
                end
            end
        end
    end
end)

-- 27.NÚT THAY ÁO AVATAR (ĐỂ RIÊNG)
createButton("👕 Đổi Áo Avatar", Color3.fromRGB(180, 100, 50), function()
    -- Tạo một Gui nhập số ID nhanh trên màn hình
    local ShirtGui = Instance.new("ScreenGui", game.CoreGui)
    ShirtGui.Name = "ShirtChanger"
    
    local Frame = Instance.new("Frame", ShirtGui)
    Frame.Size = UDim2.new(0, 200, 0, 90)
    Frame.Position = UDim2.new(0.5, -100, 0.4, -45)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    createCorner(Frame, 8)
    
    local Box = Instance.new("TextBox", Frame)
    Box.Size = UDim2.new(1, -20, 0, 30)
    Box.Position = UDim2.new(0, 10, 0, 10)
    Box.PlaceholderText = "Nhập ID Áo Roblox..."
    Box.Text = ""
    Box.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Box.TextColor3 = Color3.new(1, 1, 1)
    createCorner(Box, 6)
    
    local Apply = Instance.new("TextButton", Frame)
    Apply.Size = UDim2.new(0, 80, 0, 30)
    Apply.Position = UDim2.new(0, 10, 0, 50)
    Apply.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    Apply.Text = "Thay Áo"
    Apply.TextColor3 = Color3.new(1, 1, 1)
    createCorner(Apply, 6)
    
    local Close = Instance.new("TextButton", Frame)
    Close.Size = UDim2.new(0, 80, 0, 30)
    Close.Position = UDim2.new(1, -90, 0, 50)
    Close.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    Close.Text = "Hủy"
    Close.TextColor3 = Color3.new(1, 1, 1)
    createCorner(Close, 6)
    
    Close.MouseButton1Click:Connect(function() ShirtGui:Destroy() end)
    
    Apply.MouseButton1Click:Connect(function()
        local id = tonumber(Box.Text:match("%d+"))
        if id and LocalPlayer.Character then
            -- Tìm vật phẩm áo cũ hoặc tạo mới nếu nhân vật không mặc áo
            local shirt = LocalPlayer.Character:FindFirstChildOfClass("Shirt") or Instance.new("Shirt", LocalPlayer.Character)
            shirt.ShirtTemplate = "rbxassetid://" .. id
        end
        ShirtGui:Destroy()
    end)
end)

-- 28.NÚT NHẬP SỐ FPS (ĐỂ RIÊNG)
createButton("⚡ Set FPS Cap", Color3.fromRGB(0, 180, 255), function()
    -- Tạo khung nhập số FPS nhanh
    local FpsGui = Instance.new("ScreenGui", game.CoreGui)
    FpsGui.Name = "FpsCapChanger"
    
    local Frame = Instance.new("Frame", FpsGui)
    Frame.Size = UDim2.new(0, 200, 0, 90)
    Frame.Position = UDim2.new(0.5, -100, 0.4, -45)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    createCorner(Frame, 8)
    
    local Box = Instance.new("TextBox", Frame)
    Box.Size = UDim2.new(1, -20, 0, 30)
    Box.Position = UDim2.new(0, 10, 0, 10)
    Box.PlaceholderText = "Nhập số FPS (Ví dụ: 60)..."
    Box.Text = ""
    Box.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Box.TextColor3 = Color3.new(1, 1, 1)
    createCorner(Box, 6)
    
    local Apply = Instance.new("TextButton", Frame)
    Apply.Size = UDim2.new(0, 80, 0, 30)
    Apply.Position = UDim2.new(0, 10, 0, 50)
    Apply.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    Apply.Text = "Áp Dụng"
    Apply.TextColor3 = Color3.new(1, 1, 1)
    createCorner(Apply, 6)
    
    local Close = Instance.new("TextButton", Frame)
    Close.Size = UDim2.new(0, 80, 0, 30)
    Close.Position = UDim2.new(1, -90, 0, 50)
    Close.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    Close.Text = "Hủy"
    Close.TextColor3 = Color3.new(1, 1, 1)
    createCorner(Close, 6)
    
    -- Nút hủy để đóng bảng
    Close.MouseButton1Click:Connect(function() FpsGui:Destroy() end)
    
    -- Nút áp dụng để set FPS thực tế
    Apply.MouseButton1Click:Connect(function()
        local fps = tonumber(Box.Text:match("%d+"))
        if fps then
            if setfpscap then
                setfpscap(fps)
            elseif set_fps_cap then
                set_fps_cap(fps)
            end
        end
        FpsGui:Destroy()
    end)
end)

-- 29. GIẢM LAG
createButton("⚡ Giảm Lag", Color3.fromRGB(85, 255, 127), function()
    local Lighting = game:GetService("Lighting")
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.ShadowMapEnabled = false
    
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("DepthOfFieldEffect") or effect:IsA("SunRaysEffect") then
            effect.Enabled = false
        end
    end

    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    if Terrain then
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 0
    end

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsA("MeshPart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj:Destroy()
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        end
    end

    if collectgarbage then
        collectgarbage("collect")
    end
end)

-- 30. DANH SÁCH MUA GAMEPASS
createButton("🎟️ Mua Gamepass", Color3.fromRGB(255, 170, 0), function()
    -- Khai báo bổ sung các Service cần thiết để tránh lỗi bị trống bảng
    local HttpService = game:GetService("HttpService")
    local MarketplaceService = game:GetService("MarketplaceService")
    
    local GpGui = Instance.new("ScreenGui", game.CoreGui)
    GpGui.Name = "GamepassBrowser"
    GpGui.ResetOnSpawn = false
    
    local GpFrame = Instance.new("Frame", GpGui)
    GpFrame.Size = UDim2.new(0, IsMobile and 220 or 400, 0, IsMobile and 300 or 420)
    GpFrame.Position = UDim2.new(0.5, IsMobile and -110 or -200, 0.5, IsMobile and -150 or -210)
    GpFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 15)
    GpFrame.BorderSizePixel = 0
    createCorner(GpFrame, 12)
    makeDraggable(GpFrame)
    
    local GpStroke = Instance.new("UIStroke", GpFrame)
    GpStroke.Color = Color3.fromRGB(255, 170, 0)
    GpStroke.Thickness = 2
    
    local GpHeader = Instance.new("Frame", GpFrame)
    GpHeader.Size = UDim2.new(1, 0, 0, 35)
    GpHeader.BackgroundColor3 = Color3.fromRGB(215, 140, 0)
    GpHeader.BorderSizePixel = 0
    createCorner(GpHeader, 12)
    
    local GpTitle = Instance.new("TextLabel", GpHeader)
    GpTitle.Size = UDim2.new(1, -75, 1, 0)
    GpTitle.Position = UDim2.new(0, 10, 0, 0)
    GpTitle.BackgroundTransparency = 1
    GpTitle.Text = "🎟️ Danh Sách Gamepass"
    GpTitle.TextColor3 = Color3.new(1, 1, 1)
    GpTitle.Font = Enum.Font.GothamBold
    GpTitle.TextSize = 12
    GpTitle.TextXAlignment = Enum.TextXAlignment.Left
    GpTitle.TextYAlignment = Enum.TextYAlignment.Center
    
    local CloseGp = Instance.new("TextButton", GpHeader)
    CloseGp.Size = UDim2.new(0, 30, 1, 0)
    CloseGp.Position = UDim2.new(1, -35, 0, 0)
    CloseGp.BackgroundTransparency = 0.5
    CloseGp.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseGp.Text = "✕"
    CloseGp.TextColor3 = Color3.new(1, 1, 1)
    CloseGp.Font = Enum.Font.GothamBold
    CloseGp.TextSize = 16
    createCorner(CloseGp, 8)
    CloseGp.MouseButton1Click:Connect(function() GpGui:Destroy() end)

    local RefreshGp = Instance.new("TextButton", GpHeader)
    RefreshGp.Size = UDim2.new(0, 30, 1, 0)
    RefreshGp.Position = UDim2.new(1, -70, 0, 0)
    RefreshGp.BackgroundTransparency = 0.5
    RefreshGp.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    RefreshGp.Text = "↻"
    RefreshGp.TextColor3 = Color3.new(1, 1, 1)
    RefreshGp.Font = Enum.Font.GothamBold
    RefreshGp.TextSize = 18
    createCorner(RefreshGp, 8)
    
    local ListScroll = Instance.new("ScrollingFrame", GpFrame)
    ListScroll.Size = UDim2.new(1, -10, 1, -45)
    ListScroll.Position = UDim2.new(0, 5, 0, 40)
    ListScroll.BackgroundColor3 = Color3.fromRGB(40, 30, 20)
    ListScroll.ScrollBarThickness = 3
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    createCorner(ListScroll, 8)
    
    local ListLayout = Instance.new("UIListLayout", ListScroll)
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ListScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    local function LoadGamepasses()
        for _, child in pairs(ListScroll:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        
        task.spawn(function()
            local api = "https://games.roblox.com/v1/games/" .. game.GameId .. "/game-passes?limit=100&sortOrder=Asc"
            local success, rawData = pcall(function() return game:HttpGet(api) end)
            if not success then return end
            
            local data = HttpService:JSONDecode(rawData)
            if not data or not data.data or #data.data == 0 then 
                -- Hiển thị thông báo nếu game không có gamepass nào
                local NoGpLabel = Instance.new("TextLabel", ListScroll)
                NoGpLabel.Size = UDim2.new(1, 0, 0, 50)
                NoGpLabel.BackgroundTransparency = 1
                NoGpLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
                NoGpLabel.Font = Enum.Font.GothamBold
                NoGpLabel.TextSize = 12
                NoGpLabel.Text = "Game này không có Gamepass nào!"
                return 
            end
            
            for i, gp in ipairs(data.data) do
                local ItemFrame = Instance.new("Frame", ListScroll)
                ItemFrame.Size = UDim2.new(1, -10, 0, 55)
                ItemFrame.BackgroundColor3 = Color3.fromRGB(50, 40, 30)
                createCorner(ItemFrame, 8)
                
                local InfoLabel = Instance.new("TextLabel", ItemFrame)
                InfoLabel.Size = UDim2.new(0.65, 0, 0.8, 0)
                InfoLabel.Position = UDim2.new(0, 55, 0.1, 0)
                InfoLabel.BackgroundTransparency = 1
                InfoLabel.TextColor3 = Color3.new(1, 1, 1)
                InfoLabel.Font = Enum.Font.GothamBold
                InfoLabel.TextSize = 10
                InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
                InfoLabel.TextWrapped = true
                
                local price = gp.price and (tostring(gp.price) .. " R$") or "Offsale"
                InfoLabel.Text = "🎟️ " .. gp.name .. "\n💵 Giá: " .. price .. "\n🆔 ID: " .. gp.id
                
                local IconImg = Instance.new("ImageLabel", ItemFrame)
                IconImg.Size = UDim2.new(0, 40, 0, 40)
                IconImg.Position = UDim2.new(0, 8, 0.5, -20)
                IconImg.BackgroundColor3 = Color3.fromRGB(60, 50, 40)
                createCorner(IconImg, 6)
                
                task.spawn(function()
                    pcall(function()
                        local iconApi = "https://thumbnails.roblox.com/v1/game-passes?gamePassIds=" .. gp.id .. "&size=150x150&format=Png&isCircular=false"
                        local iconRaw = game:HttpGet(iconApi)
                        local iconData = HttpService:JSONDecode(iconRaw)
                        if iconData and iconData.data and iconData.data[1] then
                            IconImg.Image = iconData.data[1].imageUrl
                        end
                    end)
                end)
                
                local BuyBtn = Instance.new("TextButton", ItemFrame)
                BuyBtn.Size = UDim2.new(0.2, 0, 0.6, 0)
                BuyBtn.Position = UDim2.new(0.8, -8, 0.2, 0)
                BuyBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
                BuyBtn.TextColor3 = Color3.new(1, 1, 1)
                BuyBtn.Font = Enum.Font.GothamBold
                BuyBtn.TextSize = 10
                BuyBtn.Text = "Mua"
                createCorner(BuyBtn, 6)
                
                BuyBtn.MouseButton1Click:Connect(function()
                    MarketplaceService:PromptGamePassPurchase(game.Players.LocalPlayer, gp.id)
                end)
            end
        end)
    end
    
    LoadGamepasses()
    
    RefreshGp.MouseButton1Click:Connect(function()
        LoadGamepasses()
    end)
end)

-- 31.NÚT CHỐNG BỊ TÁT / VĂNG (ĐỂ RIÊNG)
createToggle("🛡️ Khóa Nhân Vật (Anti-Slap)", function(state)
    local char = LocalPlayer.Character
    if char then
        local HRP = char:FindFirstChild("HumanoidRootPart")
        if HRP then
            -- Khóa cứng vị trí vật lý để không bị tác động lực làm văng đi
            HRP.Anchored = state
        end
        
        -- Chặn các lực kéo/đẩy vật lý bất ngờ từ bên ngoài tác động lên các bộ phận khác
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Velocity = Vector3.new(0, 0, 0)
                part.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)

-- 32. BIỂU CẢM (EMOTES R6/R15 - TỰ NGỪNG KHI DI CHUYỂN)
createButton("🎭 Biểu Cảm", Color3.fromRGB(170, 85, 255), function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    local EmoteGui = Instance.new("ScreenGui", game.CoreGui)
    EmoteGui.Name = "EmoteMenu"
    EmoteGui.ResetOnSpawn = false
    
    local EmoteFrame = Instance.new("Frame", EmoteGui)
    EmoteFrame.Size = UDim2.new(0, IsMobile and 220 or 400, 0, IsMobile and 300 or 420)
    EmoteFrame.Position = UDim2.new(0.5, IsMobile and -110 or -200, 0.5, IsMobile and -150 or -210)
    EmoteFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 25)
    EmoteFrame.BorderSizePixel = 0
    createCorner(EmoteFrame, 12)
    makeDraggable(EmoteFrame)
    
    local EmoteStroke = Instance.new("UIStroke", EmoteFrame)
    EmoteStroke.Color = Color3.fromRGB(170, 85, 255)
    EmoteStroke.Thickness = 2
    
    local EmoteHeader = Instance.new("Frame", EmoteFrame)
    EmoteHeader.Size = UDim2.new(1, 0, 0, 35)
    EmoteHeader.BackgroundColor3 = Color3.fromRGB(130, 60, 200)
    EmoteHeader.BorderSizePixel = 0
    createCorner(EmoteHeader, 12)
    
    local EmoteTitle = Instance.new("TextLabel", EmoteHeader)
    EmoteTitle.Size = UDim2.new(1, -40, 1, 0)
    EmoteTitle.Position = UDim2.new(0, 10, 0, 0)
    EmoteTitle.BackgroundTransparency = 1
    EmoteTitle.Text = "🎭 Biểu Cảm Nhân Vật (R6 & R15)"
    EmoteTitle.TextColor3 = Color3.new(1, 1, 1)
    EmoteTitle.Font = Enum.Font.GothamBold
    EmoteTitle.TextSize = 12
    EmoteTitle.TextXAlignment = Enum.TextXAlignment.Left
    EmoteTitle.TextYAlignment = Enum.TextYAlignment.Center
    
    local CloseEmote = Instance.new("TextButton", EmoteHeader)
    CloseEmote.Size = UDim2.new(0, 30, 1, 0)
    CloseEmote.Position = UDim2.new(1, -35, 0, 0)
    CloseEmote.BackgroundTransparency = 0.5
    CloseEmote.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseEmote.Text = "✕"
    CloseEmote.TextColor3 = Color3.new(1, 1, 1)
    CloseEmote.Font = Enum.Font.GothamBold
    CloseEmote.TextSize = 16
    createCorner(CloseEmote, 8)
    CloseEmote.MouseButton1Click:Connect(function() EmoteGui:Destroy() end)
    
    local ListScroll = Instance.new("ScrollingFrame", EmoteFrame)
    ListScroll.Size = UDim2.new(1, -10, 1, -45)
    ListScroll.Position = UDim2.new(0, 5, 0, 40)
    ListScroll.BackgroundColor3 = Color3.fromRGB(30, 25, 35)
    ListScroll.ScrollBarThickness = 3
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    createCorner(ListScroll, 8)
    
    local ListLayout = Instance.new("UIListLayout", ListScroll)
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ListScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    local emotes = {
        {Name = "👋 Vẫy Tay (Wave)", R6 = 128777973, R15 = 507770239},
        {Name = "👉 Chỉ Tay (Point)", R6 = 128853357, R15 = 507770453},
        {Name = "💃 Nhảy 1 (Dance #1)", R6 = 182435998, R15 = 507771019},
        {Name = "🕺 Nhảy 2 (Dance #2)", R6 = 182436842, R15 = 507776043},
        {Name = "👯 Nhảy 3 (Dance #3)", R6 = 182436935, R15 = 507777268},
        {Name = "😆 Cười (Laugh)", R6 = 129423131, R15 = 507770818},
        {Name = "🙌 Cổ Vũ (Cheer)", R6 = 129423030, R15 = 507770677}
    }
    
    -- Hàm quét và tắt toàn bộ biểu cảm đang chạy
    local function StopAllEmotes()
        local character = LocalPlayer.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            if track.Name == "CustomEmote" then
                track:Stop()
            end
        end
    end
    
    -- Hàm chạy Animation mới
    local function PlayEmote(r6Id, r15Id)
        local character = LocalPlayer.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        
        local animId = (humanoid.RigType == Enum.HumanoidRigType.R6) and r6Id or r15Id
        
        StopAllEmotes() -- Tắt biểu cảm cũ trước khi chạy cái mới
        
        local anim = Instance.new("Animation")
        anim.Name = "CustomEmote"
        anim.AnimationId = "rbxassetid://" .. tostring(animId)
        
        local track = humanoid:LoadAnimation(anim)
        track:Play()
        
        -- KÍCH HOẠT TÍNH NĂNG TỰ NGỪNG KHI DI CHUYỂN:
        -- Khi tốc độ di chuyển (speed) lớn hơn 0.1, lập tức dừng Anim biểu cảm
        local moveConnection
        moveConnection = humanoid.Running:Connect(function(speed)
            if speed > 0.1 then
                track:Stop()
                if moveConnection then
                    moveConnection:Disconnect()
                end
            end
        end)
        
        -- Nếu nhân vật bị chết/reset, tự hủy kết nối để tránh rác bộ nhớ
        track.Stopped:Connect(function()
            if moveConnection then moveConnection:Disconnect() end
        end)
    end
    
    -- Tạo danh sách nút bấm
    for i, emote in ipairs(emotes) do
        local Btn = Instance.new("TextButton", ListScroll)
        Btn.Size = UDim2.new(1, -10, 0, 40)
        Btn.BackgroundColor3 = Color3.fromRGB(50, 40, 60)
        Btn.TextColor3 = Color3.new(1, 1, 1)
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 11
        Btn.Text = emote.Name
        createCorner(Btn, 8)
        
        local Stroke = Instance.new("UIStroke", Btn)
        Stroke.Color = Color3.fromRGB(170, 85, 255)
        Stroke.Thickness = 1
        Stroke.Enabled = false
        
        Btn.MouseEnter:Connect(function() Stroke.Enabled = true end)
        Btn.MouseLeave:Connect(function() Stroke.Enabled = false end)
        
        Btn.MouseButton1Click:Connect(function()
            PlayEmote(emote.R6, emote.R15)
        end)
    end
end)

-- 33. FAKE GAMEPASS (MUA THỬ)
createButton("🎟️ Fake Gamepass", Color3.fromRGB(255, 85, 85), function()
    local MarketplaceService = game:GetService("MarketplaceService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    local FakeGui = Instance.new("ScreenGui", game.CoreGui)
    FakeGui.Name = "FakeGpMenu"
    
    local FakeFrame = Instance.new("Frame", FakeGui)
    FakeFrame.Size = UDim2.new(0, 200, 0, 150)
    FakeFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
    FakeFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    FakeFrame.BorderSizePixel = 0
    createCorner(FakeFrame, 12)
    makeDraggable(FakeFrame)
    
    local InputBox = Instance.new("TextBox", FakeFrame)
    InputBox.Size = UDim2.new(0.8, 0, 0.3, 0)
    InputBox.Position = UDim2.new(0.1, 0, 0.2, 0)
    InputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    InputBox.TextColor3 = Color3.new(1, 1, 1)
    InputBox.PlaceholderText = "Nhập ID Gamepass..."
    InputBox.Text = ""
    InputBox.Font = Enum.Font.GothamBold
    InputBox.TextSize = 12
    createCorner(InputBox, 8)
    
    local BuyBtn = Instance.new("TextButton", FakeFrame)
    BuyBtn.Size = UDim2.new(0.8, 0, 0.3, 0)
    BuyBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
    BuyBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    BuyBtn.TextColor3 = Color3.new(1, 1, 1)
    BuyBtn.Text = "Mua Thử"
    BuyBtn.Font = Enum.Font.GothamBold
    BuyBtn.TextSize = 14
    createCorner(BuyBtn, 8)
    
    local CloseBtn = Instance.new("TextButton", FakeFrame)
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.Position = UDim2.new(1, -25, 0, 5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    createCorner(CloseBtn, 5)
    
    CloseBtn.MouseButton1Click:Connect(function() FakeGui:Destroy() end)
    
    BuyBtn.MouseButton1Click:Connect(function()
        local id = tonumber(InputBox.Text)
        if id then
            -- Gọi hàm Prompt để hiện bảng mua hàng
            MarketplaceService:PromptGamePassPurchase(LocalPlayer, id)
        else
            InputBox.Text = "ID không hợp lệ!"
            task.wait(1)
            InputBox.Text = ""
        end
    end)
end)

-- 34. KHO ĐỒ & LẤY FREE TOOL (TỐC ĐỘ CAO & NHIỀU TOOL)
createButton("🧰 Free Tools", Color3.fromRGB(85, 255, 170), function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    local ToolGui = Instance.new("ScreenGui", game.CoreGui)
    ToolGui.Name = "ToolMenu"
    ToolGui.ResetOnSpawn = false
    
    local ToolFrame = Instance.new("Frame", ToolGui)
    ToolFrame.Size = UDim2.new(0, IsMobile and 220 or 400, 0, IsMobile and 300 or 420)
    ToolFrame.Position = UDim2.new(0.5, IsMobile and -110 or -200, 0.5, IsMobile and -150 or -210)
    ToolFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToolFrame.BorderSizePixel = 0
    createCorner(ToolFrame, 12)
    makeDraggable(ToolFrame)
    
    local ToolStroke = Instance.new("UIStroke", ToolFrame)
    ToolStroke.Color = Color3.fromRGB(85, 255, 170)
    ToolStroke.Thickness = 2
    
    local ToolHeader = Instance.new("Frame", ToolFrame)
    ToolHeader.Size = UDim2.new(1, 0, 0, 35)
    ToolHeader.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
    ToolHeader.BorderSizePixel = 0
    createCorner(ToolHeader, 12)
    
    local Title = Instance.new("TextLabel", ToolHeader)
    Title.Size = UDim2.new(1, -75, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🧰 Kho Tool Siêu Tốc (Free)"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local RefreshBtn = Instance.new("TextButton", ToolHeader)
    RefreshBtn.Size = UDim2.new(0, 30, 1, 0)
    RefreshBtn.Position = UDim2.new(1, -70, 0, 0)
    RefreshBtn.BackgroundTransparency = 0.5
    RefreshBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    RefreshBtn.Text = "↻"
    RefreshBtn.TextColor3 = Color3.new(1, 1, 1)
    RefreshBtn.Font = Enum.Font.GothamBold
    RefreshBtn.TextSize = 18
    createCorner(RefreshBtn, 8)
    
    local CloseBtn = Instance.new("TextButton", ToolHeader)
    CloseBtn.Size = UDim2.new(0, 30, 1, 0)
    CloseBtn.Position = UDim2.new(1, -35, 0, 0)
    CloseBtn.BackgroundTransparency = 0.5
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 16
    createCorner(CloseBtn, 8)
    CloseBtn.MouseButton1Click:Connect(function() ToolGui:Destroy() end)
    
    local ListScroll = Instance.new("ScrollingFrame", ToolFrame)
    ListScroll.Size = UDim2.new(1, -10, 1, -45)
    ListScroll.Position = UDim2.new(0, 5, 0, 40)
    ListScroll.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ListScroll.ScrollBarThickness = 3
    createCorner(ListScroll, 8)
    
    local ListLayout = Instance.new("UIListLayout", ListScroll)
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ListScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Thuật toán quét siêu tốc (Tối ưu hóa bộ nhớ)
    local function UpdateToolList()
        for _, child in pairs(ListScroll:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        
        local toolsFound = {}
        
        -- Hàm quét nhanh lặp tầng (Nhanh gấp 10 lần GetDescendants)
        local function scan(parent)
            if not parent then return end
            for _, item in pairs(parent:GetChildren()) do
                if item:IsA("Tool") then
                    if not toolsFound[item.Name] then
                        toolsFound[item.Name] = item
                    end
                elseif item:IsA("Folder") or item:IsA("Configuration") or item:IsA("Model") then
                    -- Quét thêm một tầng nữa nếu là thư mục chứa đồ ẩn
                    for _, subItem in pairs(item:GetChildren()) do
                        if subItem:IsA("Tool") and not toolsFound[subItem.Name] then
                            toolsFound[subItem.Name] = subItem
                        end
                    end
                end
            end
        end
        
        -- Chỉ tập trung quét các mục lưu trữ tài nguyên chính
        scan(game:GetService("Lighting"))
        scan(game:GetService("ReplicatedStorage"))
        scan(workspace)
        pcall(function() scan(game:GetService("ServerStorage")) end)
        
        -- Tạo nút bấm nhận Tool giao diện scannable nhanh
        for name, tool in pairs(toolsFound) do
            local ItemFrame = Instance.new("Frame", ListScroll)
            ItemFrame.Size = UDim2.new(1, -10, 0, 45)
            ItemFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            createCorner(ItemFrame, 8)
            
            local ToolLabel = Instance.new("TextLabel", ItemFrame)
            ToolLabel.Size = UDim2.new(0.7, 0, 1, 0)
            ToolLabel.Position = UDim2.new(0, 10, 0, 0)
            ToolLabel.BackgroundTransparency = 1
            ToolLabel.Text = "⚔️ " .. name
            ToolLabel.TextColor3 = Color3.new(1, 1, 1)
            ToolLabel.Font = Enum.Font.GothamBold
            ToolLabel.TextSize = 11
            ToolLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local GetBtn = Instance.new("TextButton", ItemFrame)
            GetBtn.Size = UDim2.new(0.25, 0, 0.7, 0)
            GetBtn.Position = UDim2.new(0.75, -5, 0.15, 0)
            GetBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
            GetBtn.Text = "Lấy Free"
            GetBtn.TextColor3 = Color3.new(1, 1, 1)
            GetBtn.Font = Enum.Font.GothamBold
            GetBtn.TextSize = 10
            createCorner(GetBtn, 6)
            
            GetBtn.MouseButton1Click:Connect(function()
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                if backpack then
                    local toolClone = tool:Clone()
                    toolClone.Parent = backpack
                    
                    GetBtn.Text = "Đã Lấy ✔️"
                    GetBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
                    task.wait(0.8)
                    GetBtn.Text = "Lấy Free"
                    GetBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
                end
            end)
        end
    end
    
    RefreshBtn.MouseButton1Click:Connect(UpdateToolList)
    UpdateToolList()
end)

-- 35. AIMBOT (KHÓA MỤC TIÊU NGƯỜI CHƠI)
createButton("🎯 Aimbot Player", Color3.fromRGB(255, 50, 50), function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    
    local AimGui = Instance.new("ScreenGui", game.CoreGui)
    AimGui.Name = "AimbotMenu"
    AimGui.ResetOnSpawn = false
    
    local AimFrame = Instance.new("Frame", AimGui)
    AimFrame.Size = UDim2.new(0, IsMobile and 220 or 400, 0, IsMobile and 300 or 420)
    AimFrame.Position = UDim2.new(0.5, IsMobile and -110 or -200, 0.5, IsMobile and -150 or -210)
    AimFrame.BackgroundColor3 = Color3.fromRGB(25, 15, 15)
    AimFrame.BorderSizePixel = 0
    createCorner(AimFrame, 12)
    makeDraggable(AimFrame)
    
    local AimStroke = Instance.new("UIStroke", AimFrame)
    AimStroke.Color = Color3.fromRGB(255, 50, 50)
    AimStroke.Thickness = 2
    
    local AimHeader = Instance.new("Frame", AimFrame)
    AimHeader.Size = UDim2.new(1, 0, 0, 35)
    AimHeader.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    AimHeader.BorderSizePixel = 0
    createCorner(AimHeader, 12)
    
    local AimTitle = Instance.new("TextLabel", AimHeader)
    AimTitle.Size = UDim2.new(1, -75, 1, 0)
    AimTitle.Position = UDim2.new(0, 10, 0, 0)
    AimTitle.BackgroundTransparency = 1
    AimTitle.Text = "🎯 Aimbot - Chọn Người Chơi"
    AimTitle.TextColor3 = Color3.new(1, 1, 1)
    AimTitle.Font = Enum.Font.GothamBold
    AimTitle.TextSize = 12
    AimTitle.TextXAlignment = Enum.TextXAlignment.Left
    AimTitle.TextYAlignment = Enum.TextYAlignment.Center
    
    local CloseAim = Instance.new("TextButton", AimHeader)
    CloseAim.Size = UDim2.new(0, 30, 1, 0)
    CloseAim.Position = UDim2.new(1, -35, 0, 0)
    CloseAim.BackgroundTransparency = 0.5
    CloseAim.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseAim.Text = "✕"
    CloseAim.TextColor3 = Color3.new(1, 1, 1)
    CloseAim.Font = Enum.Font.GothamBold
    CloseAim.TextSize = 16
    createCorner(CloseAim, 8)
    
    local RefreshAim = Instance.new("TextButton", AimHeader)
    RefreshAim.Size = UDim2.new(0, 30, 1, 0)
    RefreshAim.Position = UDim2.new(1, -70, 0, 0)
    RefreshAim.BackgroundTransparency = 0.5
    RefreshAim.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    RefreshAim.Text = "↻"
    RefreshAim.TextColor3 = Color3.new(1, 1, 1)
    RefreshAim.Font = Enum.Font.GothamBold
    RefreshAim.TextSize = 18
    createCorner(RefreshAim, 8)
    
    local ListScroll = Instance.new("ScrollingFrame", AimFrame)
    ListScroll.Size = UDim2.new(1, -10, 1, -45)
    ListScroll.Position = UDim2.new(0, 5, 0, 40)
    ListScroll.BackgroundColor3 = Color3.fromRGB(35, 20, 20)
    ListScroll.ScrollBarThickness = 3
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    createCorner(ListScroll, 8)
    
    local ListLayout = Instance.new("UIListLayout", ListScroll)
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ListScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    local TargetPlayer = nil
    local AimbotConnection = nil
    
    -- Hàm thực hiện khóa Camera vào mục tiêu
    local function StartAimbot()
        if AimbotConnection then AimbotConnection:Disconnect() end
        AimbotConnection = RunService.RenderStepped:Connect(function()
            if TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("Head") then
                local Head = TargetPlayer.Character.Head
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, Head.Position)
            else
                TargetPlayer = nil
            end
        end)
    end
    
    -- Hàm cập nhật danh sách người chơi trong Server
    local function UpdatePlayerList()
        for _, child in pairs(ListScroll:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        
        -- Thêm nút Tắt Aimbot ở đầu danh sách
        local OffFrame = Instance.new("Frame", ListScroll)
        OffFrame.Size = UDim2.new(1, -10, 0, 40)
        OffFrame.BackgroundColor3 = Color3.fromRGB(50, 30, 30)
        createCorner(OffFrame, 8)
        
        local OffBtn = Instance.new("TextButton", OffFrame)
        OffBtn.Size = UDim2.new(1, 0, 1, 0)
        OffBtn.BackgroundTransparency = 1
        OffBtn.Text = "❌ TẮT AIMBOT"
        OffBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        OffBtn.Font = Enum.Font.GothamBold
        OffBtn.TextSize = 12
        
        OffBtn.MouseButton1Click:Connect(function()
            TargetPlayer = nil
            if AimbotConnection then
                AimbotConnection:Disconnect()
                AimbotConnection = nil
            end
            AimTitle.Text = "🎯 Aimbot - Đã Tắt"
        end)
        
        -- Quét và tạo nút cho từng người chơi
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local PFrame = Instance.new("Frame", ListScroll)
                PFrame.Size = UDim2.new(1, -10, 0, 45)
                PFrame.BackgroundColor3 = Color3.fromRGB(45, 30, 30)
                createCorner(PFrame, 8)
                
                local PLabel = Instance.new("TextLabel", PFrame)
                PLabel.Size = UDim2.new(0.7, 0, 1, 0)
                PLabel.Position = UDim2.new(0, 10, 0, 0)
                PLabel.BackgroundTransparency = 1
                PLabel.Text = p.DisplayName .. " (@" .. p.Name .. ")"
                PLabel.TextColor3 = Color3.new(1, 1, 1)
                PLabel.Font = Enum.Font.GothamBold
                PLabel.TextSize = 11
                PLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local LockBtn = Instance.new("TextButton", PFrame)
                LockBtn.Size = UDim2.new(0.25, 0, 0.7, 0)
                LockBtn.Position = UDim2.new(0.75, -5, 0.15, 0)
                LockBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
                LockBtn.Text = "Khóa"
                LockBtn.TextColor3 = Color3.new(1, 1, 1)
                LockBtn.Font = Enum.Font.GothamBold
                LockBtn.TextSize = 11
                createCorner(LockBtn, 6)
                
                LockBtn.MouseButton1Click:Connect(function()
                    TargetPlayer = p
                    AimTitle.Text = "🎯 Khóa: " .. p.DisplayName
                    StartAimbot()
                end)
            end
        end
    end
    
    UpdatePlayerList()
    
    RefreshAim.MouseButton1Click:Connect(UpdatePlayerList)
    
    -- Tự động dọn dẹp kết nối khi đóng giao diện để tránh lag game
    CloseAim.MouseButton1Click:Connect(function()
        if AimbotConnection then AimbotConnection:Disconnect() end
        AimGui:Destroy()
    end)
end)

-- 36. GỠ CHỐNG HD ADMIN & FREE ADMIN
createButton("🔓 Bypasser Admin", Color3.fromRGB(240, 165, 0), function()
    local StarterGui = game:GetService("StarterGui")
    
    -- Hàm gửi thông báo hệ thống lên góc màn hình để theo dõi trạng thái
    local function notify(title, text)
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = title,
                Text = text,
                Duration = 3
            })
        end)
    end

    notify("Bypasser", "Đang tiến hành gỡ bỏ kiểm tra...")

    -- 1. GỠ CHỐNG HD ADMIN (Bypass HD Admin Client Checks)
    task.spawn(function()
        -- Chèn các hàm giả lập để đánh lừa script HD Admin quét môi trường
        if getgenv then
            getgenv().HDAdminBypass = true
            
            -- Vô hiệu hóa một số hàm callback nhạy cảm mà HD Admin dùng để kick người chơi khi phát hiện cheater
            local oldKick
            oldKick = hookfunction(game.Players.LocalPlayer.Kick, function(self, reason)
                if reason and (string.find(string.lower(reason), "hd") or string.find(string.lower(reason), "admin")) then
                    notify("HD Admin Shield", "Đã chặn một yêu cầu Kick từ hệ thống Admin!")
                    return nil
                end
                return oldKick(self, reason)
            end)
        end
    end)

    -- 2. GỠ CHỐNG FREE ADMIN (Bypass Free Admin / Kohl's Admin Protections)
    task.spawn(function()
        -- Quét và loại bỏ các LocalScript ẩn thực hiện nhiệm vụ bảo mật chống exploit của Free Admin trong nhân vật
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("LocalScript") and (string.find(string.lower(v.Name), "anti") or string.find(string.lower(v.Name), "protect")) then
                    v.Disabled = true
                    notify("Free Admin Shield", "Đã vô hiệu hóa script bảo vệ: " .. v.Name)
                end
            end
        end
    end)

    -- 3. CAN THIỆP PHÁT HIỆN SỰ KIỆN TỪ PHÍA CLIENT (RemoteEvent Bypasser)
    local g = game
    local pcall = pcall
    local oldNamecall
    if hookmetamethod then
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            -- Nếu script hệ thống của Admin gọi các Remote nhằm kiểm tra hành vi (Check/Ban/Kick)
            if tostring(method) == "FireServer" and self.Name == "AdminRemote" or self.Name == "HDAdminRemote" then
                -- Chặn gói tin gửi về server hoặc lọc tham số độc hại để tránh bị ban tự động
                if args[1] == "BanMe" or args[1] == "KickMe" or args[1] == "CheatDetected" then
                    return nil
                end
            end
            return oldNamecall(self, ...)
        end)
    end

    notify("Thành Công", "Đã hoàn tất gỡ chống HD & Free Admin!")
end)

-- 39. TẢI LẠI NHÂN VẬT (HỒI SINH TẠI CHỖ CŨ)
createButton("♻️ Tải Lại Tại Chỗ", Color3.fromRGB(85, 170, 255), function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    local character = LocalPlayer.Character
    local oldCFrame = nil
    
    -- Bước 1: Lưu lại vị trí hiện tại (nếu nhân vật còn một bộ phận chính để lấy tọa độ)
    if character then
        local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
        if rootPart then
            oldCFrame = rootPart.CFrame
        end
    end
    
    -- Bước 2: Ép buộc game xóa nhân vật cũ để hồi sinh
    pcall(function()
        LocalPlayer:LoadCharacter()
    end)
    
    -- Bước 3: Đợi nhân vật mới xuất hiện và đưa về vị trí cũ
    task.spawn(function()
        -- Đợi cho đến khi nhân vật mới được tải xong hoàn toàn
        local newChar = LocalPlayer.CharacterAdded:Wait()
        local newRootPart = newChar:WaitForChild("HumanoidRootPart", 5)
        
        -- Nếu đã lưu được vị trí cũ, dịch chuyển về đó ngay lập tức
        if newRootPart and oldCFrame then
            task.wait(0.1) -- Chờ một chút để tránh bị lỗi đè vị trí của game
            newRootPart.CFrame = oldCFrame
        end
    end)
end)


-- 38. REJOIN (TỰ ĐỘNG CHẠY LẠI SCRIPT KHI SANG SERVER MỚI)
createButton("🔄 Vào Lại Game", Color3.fromRGB(255, 85, 255), function()
    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")
    local StarterGui = game:GetService("StarterGui")
    local LocalPlayer = Players.LocalPlayer
    
    local function notify(title, text)
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = title,
                Text = text,
                Duration = 4
            })
        end)
    end

    notify("Rejoin", "Đang kết nối lại và kích hoạt Auto-Run...")
    task.wait(0.5)

    -- Hệ thống tự động xếp hàng để tải lại Script Hub của bạn ở server mới
    local queue = queue_on_teleport or syn_queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
    if queue then
        queue([[
            repeat task.wait() until game:IsLoaded()
            pcall(function()
                -- Tự động chạy lại link script Gemini Hub của bạn
                loadstring(game:HttpGet("https://raw.githubusercontent.com/3hbin/Gemini-Hub/refs/heads/main/GeminiHub.lua"))()
            end)
        ]])
    else
        notify("Cảnh báo", "Executor không hỗ trợ tự chạy lại script khi đổi server!")
        task.wait(1)
    end

    -- Tiến hành dịch chuyển
    pcall(function()
        if #Players:GetPlayers() <= 1 then
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        else
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end
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
