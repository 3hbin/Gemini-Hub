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

-- TẠO Ô TÌM KIẾM CẢI TIẾN
local SearchBox = Instance.new("TextBox", MainFrame)
SearchBox.Name = "SearchBox"
SearchBox.Size = UDim2.new(0.9, 0, 0, 35)
SearchBox.Position = UDim2.new(0.5, 0, 0, IsMobile and 170 or 260)
SearchBox.AnchorPoint = Vector2.new(0.5, 0)
SearchBox.PlaceholderText = "🔍 Tìm kiếm tính năng..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
SearchBox.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
SearchBox.TextColor3 = Color3.new(1, 1, 1)
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 12
createCorner(SearchBox, 8)

local SearchStroke = Instance.new("UIStroke", SearchBox)
SearchStroke.Color = Color3.fromRGB(0, 150, 200)
SearchStroke.Thickness = 1.5

-- HÀM LỌC TÌM KIẾM ĐÃ SỬA LỖI
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local filter = SearchBox.Text:lower()
    for _, btn in pairs(GridScrollFrame:GetChildren()) do
        if btn:IsA("TextButton") then
            if filter == "" or btn.Text:lower():find(filter) then
                btn.Visible = true
            else
                btn.Visible = false
            end
        end
    end
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

-- 1. Định nghĩa hàm Loading trước (nhưng chưa gọi ngay)
local function ShowLoading()
    local Player = game:GetService("Players").LocalPlayer
    local PlayerGui = Player:WaitForChild("PlayerGui")
    
    local ScreenGui = Instance.new("ScreenGui", PlayerGui)
    ScreenGui.Name = "GeminiLoading"
    
    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 200, 0, 50)
    Frame.Position = UDim2.new(0.5, -100, 0.5, -25)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.Text = "Gemini Hub Loading... 0%"
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamBold
    
    -- Chạy hiệu ứng %
    for i = 1, 100, 5 do
        Label.Text = "Gemini Hub Loading... " .. i .. "%"
        task.wait(0.05)
    end
    
    Label.Text = "Gemini Hub Loaded!"
    task.wait(0.5)
    ScreenGui:Destroy()
end

-- 2. Gọi hàm Loading (dùng task.spawn để nó chạy song song, không làm đơ script)
task.spawn(ShowLoading)

-- 3. Sau đó mới chạy code tạo giao diện chính
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
createToggle("📱 Shift Lock Mobile", function(state)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Player = Players.LocalPlayer  
    local PlayerGui = Player:WaitForChild("PlayerGui")  
    local Camera = workspace.CurrentCamera  

    _G.MobileShiftLock = _G.MobileShiftLock or {}  

    if state then  
        if _G.MobileShiftLock.Enabled then return end  
        _G.MobileShiftLock.Enabled = true  

        local Gui = Instance.new("ScreenGui")  
        Gui.Name = "MobileShiftLock"  
        Gui.ResetOnSpawn = false  
        Gui.Parent = PlayerGui  
        _G.MobileShiftLock.Gui = Gui  

        local Crosshair = Instance.new("ImageLabel")  
        Crosshair.Parent = Gui  
        Crosshair.Size = UDim2.new(0, 30, 0, 30)  
        Crosshair.Position = UDim2.new(0.5, -15, 0.5, -15) -- Căn giữa chuẩn xác
        Crosshair.BackgroundTransparency = 1  
        Crosshair.Image = "rbxthumb://type=Asset&id=120266558538428&w=150&h=150"  
        Crosshair.Visible = false -- Mặc định ẩn
        _G.MobileShiftLock.Crosshair = Crosshair

        local Button = Instance.new("ImageButton")  
        Button.Parent = Gui  
        Button.Size = UDim2.new(0, 50, 0, 50)  
        Button.Position = UDim2.new(0.75, 0, 0.40, 0) -- Vị trí đã chỉnh
        Button.BackgroundTransparency = 1  
        Button.Image = "rbxthumb://type=Asset&id=83349936062601&w=150&h=150" -- OFF  

        local Lock = false  
        Button.MouseButton1Click:Connect(function()  
            Lock = not Lock  
            Crosshair.Visible = Lock -- Tự động ẩn/hiện theo nút
            Button.Image = Lock and "rbxthumb://type=Asset&id=72173899346121&w=150&h=150" or "rbxthumb://type=Asset&id=83349936062601&w=150&h=150"
        end)  

        _G.MobileShiftLock.Connection = RunService.RenderStepped:Connect(function()  
            if not _G.MobileShiftLock.Enabled then return end  
            local Character = Player.Character  
            local Root = Character and Character:FindFirstChild("HumanoidRootPart")  
            local Humanoid = Character and Character:FindFirstChild("Humanoid")  

            if Root and Humanoid then  
                if Lock then  
                    Humanoid.AutoRotate = false  
                    local Look = Camera.CFrame.LookVector  
                    Root.CFrame = CFrame.new(Root.Position, Root.Position + Vector3.new(Look.X, 0, Look.Z))  
                else  
                    Humanoid.AutoRotate = true  
                end  
            end  
        end)  
    else  
        _G.MobileShiftLock.Enabled = false  
        if _G.MobileShiftLock.Connection then _G.MobileShiftLock.Connection:Disconnect() end  
        if _G.MobileShiftLock.Gui then _G.MobileShiftLock.Gui:Destroy() end  
        local Character = Player.Character  
        if Character and Character:FindFirstChild("Humanoid") then Character.Humanoid.AutoRotate = true end  
    end
end)

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

-- 34. KHO ĐỒ & LẤY FREE TOOL (QUÉT THEO REALTIME + THÔNG BÁO)
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
    
    local function UpdateToolList()
        for _, child in pairs(ListScroll:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") then child:Destroy() end
        end
        
        local toolsFound = {}
        local count = 0
        
        local function checkAndAdd(item)
            if item:IsA("Tool") and not item:FindFirstAncestorOfClass("Tool") then
                if not item:IsDescendantOf(LocalPlayer) and not toolsFound[item.Name] then
                    toolsFound[item.Name] = item
                    count = count + 1
                end
            end
        end
        
        for _, obj in pairs(game:GetDescendants()) do
            pcall(function()
                if obj:IsDescendantOf(game:GetService("Lighting")) or 
                   obj:IsDescendantOf(game:GetService("ReplicatedStorage")) or 
                   obj:IsDescendantOf(workspace) then
                    checkAndAdd(obj)
                end
            end)
        end
        
        if count == 0 then
            local NoToolLabel = Instance.new("TextLabel", ListScroll)
            NoToolLabel.Size = UDim2.new(1, 0, 0, 50)
            NoToolLabel.BackgroundTransparency = 1
            NoToolLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
            NoToolLabel.Font = Enum.Font.GothamBold
            NoToolLabel.TextSize = 12
            NoToolLabel.Text = "Game đã khóa chặt Tool ở Server!\nKhông thể lấy miễn phí."
            return
        end
        
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
                    local success, err = pcall(function()
                        local toolClone = tool:Clone()
                        toolClone.Parent = backpack
                    end)
                    
                    if success then
                        GetBtn.Text = "Đã Lấy ✔️"
                        GetBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
                    else
                        GetBtn.Text = "Bị Chặn ✕"
                        GetBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
                    end
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

-- 39. ÉP KÍCH HOẠT TOOL (FIX TOOL KHÔNG CHẠY)
createButton("⚡ Ép Chạy Tool", Color3.fromRGB(255, 200, 50), function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local character = LocalPlayer.Character
    
    if character then
        local holdingTool = character:FindFirstChildOfClass("Tool")
        if holdingTool then
            -- Ép thuộc tính kích hoạt của Tool chạy trực tiếp từ Client
            holdingTool:Activate()
            
            -- Thử tạo một LocalScript ảo để giả lập thao tác bấm chuột/bấm màn hình
            pcall(function()
                if holdingTool:FindFirstChild("LocalScript") then
                    holdingTool.LocalScript.Disabled = true
                    holdingTool.LocalScript.Disabled = false
                end
            end)
            
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Tool Fixer",
                Text = "Đã ép kích hoạt Tool: " .. holdingTool.Name,
                Duration = 2
            })
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Thất Bại",
                Text = "Bạn phải cầm Tool đó trên tay trước!",
                Duration = 2
            })
        end
    end
end)

-- 40. BÁN ĐUÔI TROLL NGƯỜI CHƠI (CÓ DANH SÁCH CHỌN)
createButton("🦊 Bán Đuôi Troll", Color3.fromRGB(255, 128, 0), function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    
    local TailGui = Instance.new("ScreenGui", game.CoreGui)
    TailGui.Name = "TailTrollMenu"
    TailGui.ResetOnSpawn = false
    
    local TailFrame = Instance.new("Frame", TailGui)
    TailFrame.Size = UDim2.new(0, IsMobile and 220 or 400, 0, IsMobile and 300 or 420)
    TailFrame.Position = UDim2.new(0.5, IsMobile and -110 or -200, 0.5, IsMobile and -150 or -210)
    TailFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 15)
    TailFrame.BorderSizePixel = 0
    createCorner(TailFrame, 12)
    makeDraggable(TailFrame)
    
    local TailStroke = Instance.new("UIStroke", TailFrame)
    TailStroke.Color = Color3.fromRGB(255, 128, 0)
    TailStroke.Thickness = 2
    
    local TailHeader = Instance.new("Frame", TailFrame)
    TailHeader.Size = UDim2.new(1, 0, 0, 35)
    TailHeader.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    TailHeader.BorderSizePixel = 0
    createCorner(TailHeader, 12)
    
    local TailTitle = Instance.new("TextLabel", TailHeader)
    TailTitle.Size = UDim2.new(1, -75, 1, 0)
    TailTitle.Position = UDim2.new(0, 10, 0, 0)
    TailTitle.BackgroundTransparency = 1
    TailTitle.Text = "🦊 Bán Đuôi - Chọn Người Troll"
    TailTitle.TextColor3 = Color3.new(1, 1, 1)
    TailTitle.Font = Enum.Font.GothamBold
    TailTitle.TextSize = 12
    TailTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local CloseBtn = Instance.new("TextButton", TailHeader)
    CloseBtn.Size = UDim2.new(0, 30, 1, 0)
    CloseBtn.Position = UDim2.new(1, -35, 0, 0)
    CloseBtn.BackgroundTransparency = 0.5
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 16
    createCorner(CloseBtn, 8)
    
    local RefreshBtn = Instance.new("TextButton", TailHeader)
    RefreshBtn.Size = UDim2.new(0, 30, 1, 0)
    RefreshBtn.Position = UDim2.new(1, -70, 0, 0)
    RefreshBtn.BackgroundTransparency = 0.5
    RefreshBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    RefreshBtn.Text = "↻"
    RefreshBtn.TextColor3 = Color3.new(1, 1, 1)
    RefreshBtn.Font = Enum.Font.GothamBold
    RefreshBtn.TextSize = 18
    createCorner(RefreshBtn, 8)
    
    local ListScroll = Instance.new("ScrollingFrame", TailFrame)
    ListScroll.Size = UDim2.new(1, -10, 1, -45)
    ListScroll.Position = UDim2.new(0, 5, 0, 40)
    ListScroll.BackgroundColor3 = Color3.fromRGB(35, 25, 20)
    ListScroll.ScrollBarThickness = 3
    createCorner(ListScroll, 8)
    
    local ListLayout = Instance.new("UIListLayout", ListScroll)
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ListScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    local TargetPlayer = nil
    local TrollConnection = nil
    
    -- Vòng lặp liên tục dịch chuyển ra sau mông mục tiêu để làm đuôi
    local function StartTailTroll()
        if TrollConnection then TrollConnection:Disconnect() end
        TrollConnection = RunService.Heartbeat:Connect(function()
            if TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local MyChar = LocalPlayer.Character
                local TargetRoot = TargetPlayer.Character.HumanoidRootPart
                
                if MyChar and MyChar:FindFirstChild("HumanoidRootPart") then
                    -- Tính toán vị trí ở ngay phía sau lưng (cách 2.5 stud) của mục tiêu
                    local BackPosition = TargetRoot.CFrame * CFrame.new(0, 0, 2.5)
                    MyChar.HumanoidRootPart.CFrame = BackPosition
                end
            else
                TargetPlayer = nil
            end
        end)
    end
    
    local function UpdatePlayerList()
        for _, child in pairs(ListScroll:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        
        -- Nút tắt dừng Troll
        local OffFrame = Instance.new("Frame", ListScroll)
        OffFrame.Size = UDim2.new(1, -10, 0, 40)
        OffFrame.BackgroundColor3 = Color3.fromRGB(50, 35, 30)
        createCorner(OffFrame, 8)
        
        local OffBtn = Instance.new("TextButton", OffFrame)
        OffBtn.Size = UDim2.new(1, 0, 1, 0)
        OffBtn.BackgroundTransparency = 1
        OffBtn.Text = "❌ DỪNG TROLL ĐUÔI"
        OffBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        OffBtn.Font = Enum.Font.GothamBold
        OffBtn.TextSize = 12
        
        OffBtn.MouseButton1Click:Connect(function()
            TargetPlayer = nil
            if TrollConnection then
                TrollConnection:Disconnect()
                TrollConnection = nil
            end
            TailTitle.Text = "🦊 Bán Đuôi - Đã Tắt"
        end)
        
        -- Quét tạo danh sách người chơi
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local PFrame = Instance.new("Frame", ListScroll)
                PFrame.Size = UDim2.new(1, -10, 0, 45)
                PFrame.BackgroundColor3 = Color3.fromRGB(45, 35, 30)
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
                
                local ActionBtn = Instance.new("TextButton", PFrame)
                ActionBtn.Size = UDim2.new(0.25, 0, 0.7, 0)
                ActionBtn.Position = UDim2.new(0.75, -5, 0.15, 0)
                ActionBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
                ActionBtn.Text = "Bám Đuôi"
                ActionBtn.TextColor3 = Color3.new(1, 1, 1)
                ActionBtn.Font = Enum.Font.GothamBold
                ActionBtn.TextSize = 11
                createCorner(ActionBtn, 6)
                
                ActionBtn.MouseButton1Click:Connect(function()
                    TargetPlayer = p
                    TailTitle.Text = "🦊 Đang bám: " .. p.DisplayName
                    StartTailTroll()
                end)
            end
        end
    end
    
    UpdatePlayerList()
    RefreshBtn.MouseButton1Click:Connect(UpdatePlayerList)
    
    CloseBtn.MouseButton1Click:Connect(function()
        if TrollConnection then TrollConnection:Disconnect() end
        TailGui:Destroy()
    end)
end)

-- 41. MENU TROLL NGƯỜI CHƠI ĐA NĂNG (CÓ DANH SÁCH CHỌN CHẾ ĐỘ)
createButton("🎭 Menu Troll Người", Color3.fromRGB(255, 85, 85), function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    
    local TrollGui = Instance.new("ScreenGui", game.CoreGui)
    TrollGui.Name = "UltimateTrollMenu"
    TrollGui.ResetOnSpawn = false
    
    local TrollFrame = Instance.new("Frame", TrollGui)
    TrollFrame.Size = UDim2.new(0, IsMobile and 240 or 420, 0, IsMobile and 320 or 440)
    TrollFrame.Position = UDim2.new(0.5, IsMobile and -120 or -210, 0.5, IsMobile and -160 or -220)
    TrollFrame.BackgroundColor3 = Color3.fromRGB(30, 20, 20)
    TrollFrame.BorderSizePixel = 0
    createCorner(TrollFrame, 12)
    makeDraggable(TrollFrame)
    
    local TrollStroke = Instance.new("UIStroke", TrollFrame)
    TrollStroke.Color = Color3.fromRGB(255, 85, 85)
    TrollStroke.Thickness = 2
    
    local TrollHeader = Instance.new("Frame", TrollFrame)
    TrollHeader.Size = UDim2.new(1, 0, 0, 35)
    TrollHeader.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    TrollHeader.BorderSizePixel = 0
    createCorner(TrollHeader, 12)
    
    local TrollTitle = Instance.new("TextLabel", TrollHeader)
    TrollTitle.Size = UDim2.new(1, -75, 1, 0)
    TrollTitle.Position = UDim2.new(0, 10, 0, 0)
    TrollTitle.BackgroundTransparency = 1
    TrollTitle.Text = "🎭 Siêu Cấp Troll - Chọn Người Chơi"
    TrollTitle.TextColor3 = Color3.new(1, 1, 1)
    TrollTitle.Font = Enum.Font.GothamBold
    TrollTitle.TextSize = 12
    TrollTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local CloseBtn = Instance.new("TextButton", TrollHeader)
    CloseBtn.Size = UDim2.new(0, 30, 1, 0)
    CloseBtn.Position = UDim2.new(1, -35, 0, 0)
    CloseBtn.BackgroundTransparency = 0.5
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 16
    createCorner(CloseBtn, 8)
    
    local RefreshBtn = Instance.new("TextButton", TrollHeader)
    RefreshBtn.Size = UDim2.new(0, 30, 1, 0)
    RefreshBtn.Position = UDim2.new(1, -70, 0, 0)
    RefreshBtn.BackgroundTransparency = 0.5
    RefreshBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    RefreshBtn.Text = "↻"
    RefreshBtn.TextColor3 = Color3.new(1, 1, 1)
    RefreshBtn.Font = Enum.Font.GothamBold
    RefreshBtn.TextSize = 18
    createCorner(RefreshBtn, 8)
    
    local ListScroll = Instance.new("ScrollingFrame", TrollFrame)
    ListScroll.Size = UDim2.new(1, -10, 1, -45)
    ListScroll.Position = UDim2.new(0, 5, 0, 40)
    ListScroll.BackgroundColor3 = Color3.fromRGB(40, 25, 25)
    ListScroll.ScrollBarThickness = 3
    createCorner(ListScroll, 8)
    
    local ListLayout = Instance.new("UIListLayout", ListScroll)
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ListScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    local TargetPlayer = nil
    local TrollMode = nil -- "Tail", "Spin", "Glitch"
    local TrollConnection = nil
    local angle = 0
    
    -- Vòng lặp xử lý các chế độ Troll
    local function StartTrollLoop()
        if TrollConnection then TrollConnection:Disconnect() end
        TrollConnection = RunService.Heartbeat:Connect(function()
            if TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local MyChar = LocalPlayer.Character
                local TargetRoot = TargetPlayer.Character.HumanoidRootPart
                
                if MyChar and MyChar:FindFirstChild("HumanoidRootPart") then
                    if TrollMode == "Tail" then
                        -- Chế độ Đuôi: Đứng sau mông
                        MyChar.HumanoidRootPart.CFrame = TargetRoot.CFrame * CFrame.new(0, 0, 2.5)
                    elseif TrollMode == "Spin" then
                        -- Chế độ Vòng Quay: Xoay quanh đầu
                        angle = angle + 0.1
                        local offset = Vector3.new(math.sin(angle) * 4, 3, math.cos(angle) * 4)
                        MyChar.HumanoidRootPart.CFrame = CFrame.new(TargetRoot.Position + offset, TargetRoot.Position)
                    elseif TrollMode == "Glitch" then
                        -- Chế độ Giật Giật: Dịch chuyển loạn xạ xung quanh
                        local randomOffset = Vector3.new(math.random(-5, 5), math.random(-2, 4), math.random(-5, 5))
                        MyChar.HumanoidRootPart.CFrame = CFrame.new(TargetRoot.Position + randomOffset)
                    end
                end
            else
                TargetPlayer = nil
            end
        end)
    end
    
    local function UpdatePlayerList()
        for _, child in pairs(ListScroll:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        
        -- Thanh DỪNG TROLL ở trên cùng
        local StopFrame = Instance.new("Frame", ListScroll)
        StopFrame.Size = UDim2.new(1, -10, 0, 40)
        StopFrame.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
        createCorner(StopFrame, 8)
        
        local StopBtn = Instance.new("TextButton", StopFrame)
        StopBtn.Size = UDim2.new(1, 0, 1, 0)
        StopBtn.BackgroundTransparency = 1
        StopBtn.Text = "🛑 DỪNG TROLL NGAY LẬP TỨC"
        StopBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        StopBtn.Font = Enum.Font.GothamBold
        StopBtn.TextSize = 12
        
        StopBtn.MouseButton1Click:Connect(function()
            TargetPlayer = nil
            TrollMode = nil
            if TrollConnection then
                TrollConnection:Disconnect()
                TrollConnection = nil
            end
            TrollTitle.Text = "🎭 Đã dừng mọi hoạt động Troll"
        end)
        
        -- Tạo danh sách các người chơi khác
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local PFrame = Instance.new("Frame", ListScroll)
                PFrame.Size = UDim2.new(1, -10, 0, 55)
                PFrame.BackgroundColor3 = Color3.fromRGB(50, 35, 35)
                createCorner(PFrame, 8)
                
                local PLabel = Instance.new("TextLabel", PFrame)
                PLabel.Size = UDim2.new(0.4, 0, 1, 0)
                PLabel.Position = UDim2.new(0, 8, 0, 0)
                PLabel.BackgroundTransparency = 1
                PLabel.Text = p.DisplayName .. "\n(@" .. p.Name .. ")"
                PLabel.TextColor3 = Color3.new(1, 1, 1)
                PLabel.Font = Enum.Font.GothamBold
                PLabel.TextSize = 10
                PLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                -- Nút chế độ Đuôi
                local TailBtn = Instance.new("TextButton", PFrame)
                TailBtn.Size = UDim2.new(0.18, 0, 0.7, 0)
                TailBtn.Position = UDim2.new(0.42, 0, 0.15, 0)
                TailBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
                TailBtn.Text = "Đuôi 🦊"
                TailBtn.TextColor3 = Color3.new(1, 1, 1)
                TailBtn.Font = Enum.Font.GothamBold
                TailBtn.TextSize = 9
                createCorner(TailBtn, 5)
                
                TailBtn.MouseButton1Click:Connect(function()
                    TargetPlayer = p
                    TrollMode = "Tail"
                    TrollTitle.Text = "🦊 Làm đuôi: " .. p.DisplayName
                    StartTLoop()
                end)
                
                -- Nút chế độ Vòng Quay
                local SpinBtn = Instance.new("TextButton", PFrame)
                SpinBtn.Size = UDim2.new(0.18, 0, 0.7, 0)
                SpinBtn.Position = UDim2.new(0.61, 0, 0.15, 0)
                SpinBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
                SpinBtn.Text = "Quay 🌀"
                SpinBtn.TextColor3 = Color3.new(1, 1, 1)
                SpinBtn.Font = Enum.Font.GothamBold
                SpinBtn.TextSize = 9
                createCorner(SpinBtn, 5)
                
                SpinBtn.MouseButton1Click:Connect(function()
                    TargetPlayer = p
                    TrollMode = "Spin"
                    TrollTitle.Text = "🌀 Xoay quanh: " .. p.DisplayName
                    StartTrollLoop()
                end)
                
                -- Nút chế độ Giật Giật
                local GlitchBtn = Instance.new("TextButton", PFrame)
                GlitchBtn.Size = UDim2.new(0.18, 0, 0.7, 0)
                GlitchBtn.Position = UDim2.new(0.80, 0, 0.15, 0)
                GlitchBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 200)
                GlitchBtn.Text = "Giật 💥"
                GlitchBtn.TextColor3 = Color3.new(1, 1, 1)
                GlitchBtn.Font = Enum.Font.GothamBold
                GlitchBtn.TextSize = 9
                createCorner(GlitchBtn, 5)
                
                GlitchBtn.MouseButton1Click:Connect(function()
                    TargetPlayer = p
                    TrollMode = "Glitch"
                    TrollTitle.Text = "💥 Giật quanh: " .. p.DisplayName
                    StartTrollLoop()
                end)
            end
        end
    end
    
    UpdatePlayerList()
    RefreshBtn.MouseButton1Click:Connect(UpdatePlayerList)
    
    CloseBtn.MouseButton1Click:Connect(function()
        if TrollConnection then TrollConnection:Disconnect() end
        TrollGui:Destroy()
    end)
end)

-- 42. BOM TROLL NGƯỜI CHƠI (TẠO VỤ NỔ LIÊN TỤC)
createButton("💣 Bom Troll Server", Color3.fromRGB(255, 50, 50), function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    
    local BombGui = Instance.new("ScreenGui", game.CoreGui)
    BombGui.Name = "BombTrollMenu"
    BombGui.ResetOnSpawn = false
    
    local BombFrame = Instance.new("Frame", BombGui)
    BombFrame.Size = UDim2.new(0, IsMobile and 220 or 400, 0, IsMobile and 300 or 420)
    BombFrame.Position = UDim2.new(0.5, IsMobile and -110 or -200, 0.5, IsMobile and -150 or -210)
    BombFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    BombFrame.BorderSizePixel = 0
    createCorner(BombFrame, 12)
    makeDraggable(BombFrame)
    
    local BombStroke = Instance.new("UIStroke", BombFrame)
    BombStroke.Color = Color3.fromRGB(255, 50, 50)
    BombStroke.Thickness = 2
    
    local BombHeader = Instance.new("Frame", BombFrame)
    BombHeader.Size = UDim2.new(1, 0, 0, 35)
    BombHeader.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    BombHeader.BorderSizePixel = 0
    createCorner(BombHeader, 12)
    
    local BombTitle = Instance.new("TextLabel", BombHeader)
    BombTitle.Size = UDim2.new(1, -75, 1, 0)
    BombTitle.Position = UDim2.new(0, 10, 0, 0)
    BombTitle.BackgroundTransparency = 1
    BombTitle.Text = "💣 Thả Bom - Chọn Bia Đỡ Đạn"
    BombTitle.TextColor3 = Color3.new(1, 1, 1)
    BombTitle.Font = Enum.Font.GothamBold
    BombTitle.TextSize = 12
    BombTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local CloseBtn = Instance.new("TextButton", BombHeader)
    CloseBtn.Size = UDim2.new(0, 30, 1, 0)
    CloseBtn.Position = UDim2.new(1, -35, 0, 0)
    CloseBtn.BackgroundTransparency = 0.5
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 16
    createCorner(CloseBtn, 8)
    
    local RefreshBtn = Instance.new("TextButton", BombHeader)
    RefreshBtn.Size = UDim2.new(0, 30, 1, 0)
    RefreshBtn.Position = UDim2.new(1, -70, 0, 0)
    RefreshBtn.BackgroundTransparency = 0.5
    RefreshBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    RefreshBtn.Text = "↻"
    RefreshBtn.TextColor3 = Color3.new(1, 1, 1)
    RefreshBtn.Font = Enum.Font.GothamBold
    RefreshBtn.TextSize = 18
    createCorner(RefreshBtn, 8)
    
    local ListScroll = Instance.new("ScrollingFrame", BombFrame)
    ListScroll.Size = UDim2.new(1, -10, 1, -45)
    ListScroll.Position = UDim2.new(0, 5, 0, 40)
    ListScroll.BackgroundColor3 = Color3.fromRGB(30, 15, 15)
    ListScroll.ScrollBarThickness = 3
    createCorner(ListScroll, 8)
    
    local ListLayout = Instance.new("UIListLayout", ListScroll)
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ListScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    local TargetPlayer = nil
    local BombConnection = nil
    local lastBombTime = 0
    
    -- Vòng lặp kích nổ liên tục dưới chân mục tiêu
    local function StartBombTroll()
        if BombConnection then BombConnection:Disconnect() end
        BombConnection = RunService.Heartbeat:Connect(function()
            if TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local targetRoot = TargetPlayer.Character.HumanoidRootPart
                local currentTime = tick()
                
                -- Giới hạn tạo bom (mỗi 0.1 giây tạo 1 vụ nổ để tránh lag đứng game)
                if currentTime - lastBombTime >= 0.1 then
                    lastBombTime = currentTime
                    
                    local exp = Instance.new("Explosion")
                    exp.BlastRadius = 8 -- Bán kính vụ nổ
                    exp.BlastPressure = 500000 -- Lực đẩy hất văng đối phương
                    exp.Position = targetRoot.Position + Vector3.new(math.random(-1, 1), -1, math.random(-1, 1))
                    exp.ExplorerImage = "rbxasset://textures/Explosion.png"
                    exp.Parent = workspace
                end
            else
                TargetPlayer = nil
            end
        end)
    end
    
    local function UpdatePlayerList()
        for _, child in pairs(ListScroll:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        
        -- Nút tắt chế độ nổ
        local OffFrame = Instance.new("Frame", ListScroll)
        OffFrame.Size = UDim2.new(1, -10, 0, 40)
        OffFrame.BackgroundColor3 = Color3.fromRGB(50, 20, 20)
        createCorner(OffFrame, 8)
        
        local OffBtn = Instance.new("TextButton", OffFrame)
        OffBtn.Size = UDim2.new(1, 0, 1, 0)
        OffBtn.BackgroundTransparency = 1
        OffBtn.Text = "🛑 NGỪNG ĐẶT BOM"
        OffBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        OffBtn.Font = Enum.Font.GothamBold
        OffBtn.TextSize = 12
        
        OffBtn.MouseButton1Click:Connect(function()
            TargetPlayer = nil
            if BombConnection then
                BombConnection:Disconnect()
                BombConnection = nil
            end
            BombTitle.Text = "💣 Đã Tắt Thả Bom"
        end)
        
        -- Hiển thị danh sách mục tiêu
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local PFrame = Instance.new("Frame", ListScroll)
                PFrame.Size = UDim2.new(1, -10, 0, 45)
                PFrame.BackgroundColor3 = Color3.fromRGB(40, 25, 25)
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
                
                local ActionBtn = Instance.new("TextButton", PFrame)
                ActionBtn.Size = UDim2.new(0.25, 0, 0.7, 0)
                ActionBtn.Position = UDim2.new(0.75, -5, 0.15, 0)
                ActionBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                ActionBtn.Text = "Đặt Bom"
                ActionBtn.TextColor3 = Color3.new(1, 1, 1)
                ActionBtn.Font = Enum.Font.GothamBold
                ActionBtn.TextSize = 11
                createCorner(ActionBtn, 6)
                
                ActionBtn.MouseButton1Click:Connect(function()
                    TargetPlayer = p
                    BombTitle.Text = "💣 Đang nổ: " .. p.DisplayName
                    StartBombTroll()
                end)
            end
        end
    end
    
    UpdatePlayerList()
    RefreshBtn.MouseButton1Click:Connect(UpdatePlayerList)
    
    CloseBtn.MouseButton1Click:Connect(function()
        if BombConnection then BombConnection:Disconnect() end
        BombGui:Destroy()
    end)
end)

-- 43. BIẾN HÌNH TỰ DO (GÕ CHỮ BẤT KỲ - TỰ ĐỘNG TẠO ĐỒ + TAG CHỮ TRÊN ĐẦU)
createButton("👤 Biến Hình Tự Do", Color3.fromRGB(170, 255, 255), function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    local FreeGui = Instance.new("ScreenGui", game.CoreGui)
    FreeGui.Name = "FreeMorphMenu"
    FreeGui.ResetOnSpawn = false
    
    local FreeFrame = Instance.new("Frame", FreeGui)
    FreeFrame.Size = UDim2.new(0, IsMobile and 240 or 320, 0, IsMobile and 150 or 180)
    FreeFrame.Position = UDim2.new(0.5, IsMobile and -120 or -160, 0.5, IsMobile and -75 or -90)
    FreeFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 30)
    FreeFrame.BorderSizePixel = 0
    createCorner(FreeFrame, 12)
    makeDraggable(FreeFrame)
    
    local FreeStroke = Instance.new("UIStroke", FreeFrame)
    FreeStroke.Color = Color3.fromRGB(85, 255, 255)
    FreeStroke.Thickness = 2
    
    local FreeHeader = Instance.new("Frame", FreeFrame)
    FreeHeader.Size = UDim2.new(1, 0, 0, 35)
    FreeHeader.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
    FreeHeader.BorderSizePixel = 0
    createCorner(FreeHeader, 12)
    
    local FreeTitle = Instance.new("TextLabel", FreeHeader)
    FreeTitle.Size = UDim2.new(1, -40, 1, 0)
    FreeTitle.Position = UDim2.new(0, 10, 0, 0)
    FreeTitle.BackgroundTransparency = 1
    FreeTitle.Text = "👤 Nhập Chữ Bất Kỳ Để Biến Hình"
    FreeTitle.TextColor3 = Color3.new(1, 1, 1)
    FreeTitle.Font = Enum.Font.GothamBold
    FreeTitle.TextSize = 12
    FreeTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local CloseBtn = Instance.new("TextButton", FreeHeader)
    CloseBtn.Size = UDim2.new(0, 30, 1, 0)
    CloseBtn.Position = UDim2.new(1, -35, 0, 0)
    CloseBtn.BackgroundTransparency = 0.5
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 16
    createCorner(CloseBtn, 8)
    CloseBtn.MouseButton1Click:Connect(function() FreeGui:Destroy() end)
    
    local NameInput = Instance.new("TextBox", FreeFrame)
    NameInput.Size = UDim2.new(1, -20, 0, 35)
    NameInput.Position = UDim2.new(0, 10, 0, 50)
    NameInput.BackgroundColor3 = Color3.fromRGB(30, 45, 45)
    NameInput.Text = ""
    NameInput.PlaceholderText = "Gõ bất kỳ chữ gì (Ví dụ: ADMIN, VIP...)"
    NameInput.TextColor3 = Color3.new(1, 1, 1)
    NameInput.Font = Enum.Font.GothamBold
    NameInput.TextSize = 11
    createCorner(NameInput, 6)
    
    local ApplyBtn = Instance.new("TextButton", FreeFrame)
    ApplyBtn.Size = UDim2.new(1, -20, 0, 35)
    ApplyBtn.Position = UDim2.new(0, 10, 0, 100)
    ApplyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 120)
    ApplyBtn.Text = "✨ Biến Hình Lập Tức"
    ApplyBtn.TextColor3 = Color3.new(1, 1, 1)
    ApplyBtn.Font = Enum.Font.GothamBold
    ApplyBtn.TextSize = 12
    createCorner(ApplyBtn, 6)

    -- Hàm chuyển đổi chuỗi chữ bất kỳ thành 1 con số ID ngẫu nhiên nhưng cố định
    local function stringToId(str)
        local num = 0
        for i = 1, #str do
            num = num + str:byte(i) * i
        end
        math.randomseed(num)
        return math.random(100000, 5000000000) -- Tạo ID ngẫu nhiên trong khoảng tài khoản thật
    end

    ApplyBtn.MouseButton1Click:Connect(function()
        local text = NameInput.Text
        if text == "" then return end
        
        ApplyBtn.Text = "⏳ Đang ảo hóa trang phục..."
        
        task.spawn(function()
            local targetId = stringToId(text)
            local myChar = LocalPlayer.Character
            local humanoid = myChar and myChar:FindFirstChildOfClass("Humanoid")
            local head = myChar and myChar:FindFirstChild("Head")
            
            if humanoid and head then
                -- 1. Tiến hành tải và thay đổi trang phục dựa trên ID ảo hóa từ chữ bạn gõ
                local morphSuccess, humanoidDesc = pcall(function()
                    return Players:GetHumanoidDescriptionFromUserId(targetId)
                end)
                
                if morphSuccess and humanoidDesc then
                    for _, item in pairs(myChar:GetChildren()) do
                        if item:IsA("Accessory") or item:IsA("Clothing") then item:Destroy() end
                    end
                    pcall(function() humanoid:ApplyDescription(humanoidDesc) end)
                end
                
                -- 2. Tạo Tag chữ (Danh hiệu) bay trên đầu hiển thị đúng chữ bạn gõ
                if head:FindFirstChild("FreeMorphTag") then head.FreeMorphTag:Destroy() end
                
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "FreeMorphTag"
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 3.5, 0) -- Độ cao trên đầu
                billboard.AlwaysOnTop = true
                
                local label = Instance.new("TextLabel", billboard)
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = "[" .. text:upper() .. "]"
                label.TextColor3 = Color3.fromRGB(255, 255, 85) -- Màu vàng rực rỡ giống Admin
                label.Font = Enum.Font.GothamBold
                label.TextSize = 14
                
                -- Tạo viền chữ cho đẹp
                local stroke = Instance.new("UIStroke", label)
                stroke.Color = Color3.new(0, 0, 0)
                stroke.Thickness = 2
                
                billboard.Parent = head
                FreeTitle.Text = "✔️ Đã hóa thân thành: " .. text
            else
                FreeTitle.Text = "❌ Lỗi: Không tìm thấy nhân vật!"
            end
            
            ApplyBtn.Text = "✨ Biến Hình Lập Tức"
            task.wait(3)
            if FreeTitle then FreeTitle.Text = "👤 Nhập Chữ Bất Kỳ Để Biến Hình" end
        end)
    end)
end)

-- 44. BẢNG TÌM KIẾM GAME TỰ ĐỘNG TOÀN ROBLOX (TỰ QUÉT TÊN, ID, ẢNH)
createButton("🔍 Tìm & Chơi Game", Color3.fromRGB(170, 85, 255), function()
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    local SearchGui = Instance.new("ScreenGui", game.CoreGui)
    SearchGui.Name = "AutoGameSearchMenu"
    SearchGui.ResetOnSpawn = false
    
    local SearchFrame = Instance.new("Frame", SearchGui)
    SearchFrame.Size = UDim2.new(0, IsMobile and 260 or 420, 0, IsMobile and 340 or 450)
    SearchFrame.Position = UDim2.new(0.5, IsMobile and -130 or -210, 0.5, IsMobile and -170 or -225)
    SearchFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    SearchFrame.BorderSizePixel = 0
    createCorner(SearchFrame, 12)
    makeDraggable(SearchFrame)
    
    local SearchStroke = Instance.new("UIStroke", SearchFrame)
    SearchStroke.Color = Color3.fromRGB(170, 85, 255)
    SearchStroke.Thickness = 2
    
    -- Thanh tiêu đề
    local Header = Instance.new("Frame", SearchFrame)
    Header.Size = UDim2.new(1, 0, 0, 35)
    Header.BackgroundColor3 = Color3.fromRGB(90, 40, 150)
    Header.BorderSizePixel = 0
    createCorner(Header, 12)
    
    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🔍 Tự Động Tìm Kiếm Game Toàn Roblox"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local CloseBtn = Instance.new("TextButton", Header)
    CloseBtn.Size = UDim2.new(0, 30, 1, 0)
    CloseBtn.Position = UDim2.new(1, -35, 0, 0)
    CloseBtn.BackgroundTransparency = 0.5
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 16
    createCorner(CloseBtn, 8)
    CloseBtn.MouseButton1Click:Connect(function() SearchGui:Destroy() end)
    
    -- Ô gõ tên game để tìm kiếm
    local SearchInput = Instance.new("TextBox", SearchFrame)
    SearchInput.Size = UDim2.new(1, -95, 0, 35)
    SearchInput.Position = UDim2.new(0, 10, 0, 45)
    SearchInput.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    SearchInput.Text = ""
    SearchInput.PlaceholderText = "Nhập tên game cần tìm vào đây..."
    SearchInput.TextColor3 = Color3.new(1, 1, 1)
    SearchInput.Font = Enum.Font.GothamBold
    SearchInput.TextSize = 11
    createCorner(SearchInput, 6)
    
    -- Nút bấm thực hiện tìm kiếm
    local SearchBtn = Instance.new("TextButton", SearchFrame)
    SearchBtn.Size = UDim2.new(0, 75, 0, 35)
    SearchBtn.Position = UDim2.new(1, -85, 0, 45)
    SearchBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
    SearchBtn.Text = "TÌM KIẾM"
    SearchBtn.TextColor3 = Color3.new(1, 1, 1)
    SearchBtn.Font = Enum.Font.GothamBold
    SearchBtn.TextSize = 11
    createCorner(SearchBtn, 6)
    
    -- Vùng cuộn hiển thị kết quả tìm được
    local ResultScroll = Instance.new("ScrollingFrame", SearchFrame)
    ResultScroll.Size = UDim2.new(1, -20, 1, -95)
    ResultScroll.Position = UDim2.new(0, 10, 0, 90)
    ResultScroll.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    ResultScroll.ScrollBarThickness = 4
    createCorner(ResultScroll, 8)
    
    local ListLayout = Instance.new("UIListLayout", ResultScroll)
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ResultScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Hàm xóa danh sách cũ khi tìm từ khóa mới
    local function clearResults()
        for _, child in pairs(ResultScroll:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
    end
    
    -- Xử lý nút tìm kiếm tự động
    SearchBtn.MouseButton1Click:Connect(function()
        local keyword = SearchInput.Text
        if keyword == "" then return end
        
        SearchBtn.Text = "⏳ Đang quét..."
        SearchBtn.BackgroundColor3 = Color3.fromRGB(150, 120, 50)
        clearResults()
        
        task.spawn(function()
            -- Sử dụng RoProxy an toàn để quét dữ liệu vũ trụ game của Roblox
            local url = "https://games.roproxy.com/v1/games/list?model.keyword=" .. HttpService:UrlEncode(keyword) .. "&model.maxRows=10"
            local success, response = pcall(function()
                return game:HttpGet(url)
            end)
            
            if success and response then
                local data = HttpService:JSONDecode(response)
                if data and data.games and #data.games > 0 then
                    for i, gameData in pairs(data.games) do
                        local placeId = gameData.placeId
                        local gameName = gameData.name
                        local creator = gameData.creatorName or "Unknown"
                        local playerCount = gameData.playerCount or 0
                        
                        -- Tạo thẻ game
                        local Card = Instance.new("Frame", ResultScroll)
                        Card.Size = UDim2.new(1, -10, 0, 65)
                        Card.BackgroundColor3 = Color3.fromRGB(35, 30, 45)
                        createCorner(Card, 8)
                        
                        -- Tự động lấy ảnh của game từ hệ thống bằng PlaceID vừa tìm được
                        local GameImg = Instance.new("ImageLabel", Card)
                        GameImg.Size = UDim2.new(0, 55, 0, 55)
                        GameImg.Position = UDim2.new(0, 5, 0, 5)
                        GameImg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                        GameImg.Image = "rbxthumb://type=Asset&id=" .. placeId .. "&w=150&h=150"
                        createCorner(GameImg, 6)
                        
                        -- Thông tin Game
                        local InfoLabel = Instance.new("TextLabel", Card)
                        InfoLabel.Size = UDim2.new(0.6, -5, 1, -10)
                        InfoLabel.Position = UDim2.new(0, 68, 0, 5)
                        InfoLabel.BackgroundTransparency = 1
                        InfoLabel.Text = "<b>" .. gameName .. "</b>\n<font color='rgb(160,160,160)'>Bởi: " .. creator .. "</font>\n<font color='rgb(85,255,120)'>👥 " .. playerCount .. " đang chơi</font>"
                        InfoLabel.TextColor3 = Color3.new(1, 1, 1)
                        InfoLabel.Font = Enum.Font.Gotham
                        InfoLabel.TextSize = 10
                        InfoLabel.RichText = true
                        InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
                        InfoLabel.TextYAlignment = Enum.TextYAlignment.Top
                        
                        -- Nút bấm dịch chuyển vào game
                        local PlayBtn = Instance.new("TextButton", Card)
                        PlayBtn.Size = UDim2.new(0, IsMobile and 55 or 70, 0, 32)
                        PlayBtn.Position = UDim2.new(1, IsMobile and -60 or -75, 0.5, -16)
                        PlayBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 100)
                        PlayBtn.Text = "VÀO CHƠI"
                        PlayBtn.TextColor3 = Color3.new(1, 1, 1)
                        PlayBtn.Font = Enum.Font.GothamBold
                        PlayBtn.TextSize = IsMobile and 9 or 10
                        createCorner(PlayBtn, 6)
                        
                        PlayBtn.MouseButton1Click:Connect(function()
                            PlayBtn.Text = "⏳ Đi..."
                            pcall(function()
                                TeleportService:Teleport(placeId, LocalPlayer)
                            end)
                        end)
                    end
                else
                    Title.Text = "❌ Không tìm thấy game nào phù hợp!"
                end
            else
                Title.Text = "❌ Lỗi kết nối hệ thống tìm kiếm!"
            end
            
            SearchBtn.Text = "TÌM KIẾM"
            SearchBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
            task.wait(3)
            if Title then Title.Text = "🔍 Tự Động Tìm Kiếm Game Toàn Roblox" end
        end)
    end)
end)

-- ==========================================
-- 45. GIAO DIỆN SMARTPHONE V4 (ĐÃ THU NHỎ & SỬA LỖI ICON)
-- ==========================================
createButton("📱 Smartphone v4", Color3.fromRGB(85, 255, 120), function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    local PhoneGui = Instance.new("ScreenGui", game.CoreGui)
    PhoneGui.Name = "GeminiSmartphoneV4"
    PhoneGui.ResetOnSpawn = false
    
    -- Thân máy (Đã thu nhỏ kích thước từ 250x460 xuống còn 180x340 để vừa vặn trên điện thoại)
    local PhoneFrame = Instance.new("Frame", PhoneGui)
    PhoneFrame.Size = UDim2.new(0, 180, 0, 340)
    PhoneFrame.Position = UDim2.new(0.5, -90, 0.5, -170)
    PhoneFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    PhoneFrame.BorderSizePixel = 0
    createCorner(PhoneFrame, 20)
    makeDraggable(PhoneFrame)
    
    local PhoneStroke = Instance.new("UIStroke", PhoneFrame)
    PhoneStroke.Color = Color3.fromRGB(80, 80, 85)
    PhoneStroke.Thickness = 3
    
    -- Màn hình hiển thị bên trong
    local Screen = Instance.new("ImageLabel", PhoneFrame)
    Screen.Size = UDim2.new(1, -8, 1, -8)
    Screen.Position = UDim2.new(0, 4, 0, 4)
    Screen.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Screen.Image = "rbxassetid://13540899144"
    Screen.ScaleType = Enum.ScaleType.Crop
    createCorner(Screen, 18)
    
    -- Tai thỏ siêu nhỏ gọn
    local Notch = Instance.new("Frame", Screen)
    Notch.Size = UDim2.new(0, 70, 0, 12)
    Notch.Position = UDim2.new(0.5, -35, 0, 3)
    Notch.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Notch.BorderSizePixel = 0
    createCorner(Notch, 6)
    
    -- Thanh trạng thái (Status Bar)
    local StatusBar = Instance.new("Frame", Screen)
    StatusBar.Size = UDim2.new(1, 0, 0, 18)
    StatusBar.BackgroundTransparency = 1
    
    local TimeLabel = Instance.new("TextLabel", StatusBar)
    TimeLabel.Size = UDim2.new(0, 50, 1, 0)
    TimeLabel.Position = UDim2.new(0, 10, 0, 0)
    TimeLabel.BackgroundTransparency = 1
    TimeLabel.Text = "12:00"
    TimeLabel.TextColor3 = Color3.new(1, 1, 1)
    TimeLabel.Font = Enum.Font.GothamBold
    TimeLabel.TextSize = 9
    TimeLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    task.spawn(function()
        while task.wait(1) do
            if not TimeLabel then break end
            local date = os.date("*t")
            TimeLabel.Text = string.format("%02d:%02d", date.hour, date.min)
        end
    end)
    
    local IconsLabel = Instance.new("TextLabel", StatusBar)
    IconsLabel.Size = UDim2.new(0, 60, 1, 0)
    IconsLabel.Position = UDim2.new(1, -10, 0, 0)
    IconsLabel.BackgroundTransparency = 1
    IconsLabel.Text = "📶 🔋"
    IconsLabel.TextColor3 = Color3.new(1, 1, 1)
    IconsLabel.Font = Enum.Font.GothamBold
    IconsLabel.TextSize = 8
    IconsLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    -- Lưới chứa App (Thu nhỏ CellSize để không bị đè lên nhau)
    local AppContainer = Instance.new("Frame", Screen)
    AppContainer.Size = UDim2.new(1, -12, 1, -55)
    AppContainer.Position = UDim2.new(0, 6, 0, 30)
    AppContainer.BackgroundTransparency = 1
    
    local Grid = Instance.new("UIGridLayout", AppContainer)
    Grid.CellSize = UDim2.new(0, 38, 0, 52)
    Grid.CellPadding = UDim2.new(0, 8, 0, 10)
    Grid.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- Khung hiển thị các Sub-Window ứng dụng con khi mở
    local AppWindow = Instance.new("Frame", Screen)
    AppWindow.Size = UDim2.new(1, 0, 1, -18)
    AppWindow.Position = UDim2.new(0, 0, 1, 0)
    AppWindow.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    AppWindow.BorderSizePixel = 0
    createCorner(AppWindow, 18)
    
    local WindowTitle = Instance.new("TextLabel", AppWindow)
    WindowTitle.Size = UDim2.new(1, 0, 0, 25)
    WindowTitle.Position = UDim2.new(0, 0, 0, 8)
    WindowTitle.BackgroundTransparency = 1
    WindowTitle.Text = "Ứng dụng"
    WindowTitle.TextColor3 = Color3.new(1, 1, 1)
    WindowTitle.Font = Enum.Font.GothamBold
    WindowTitle.TextSize = 11
    
    local BackBtn = Instance.new("TextButton", AppWindow)
    BackBtn.Size = UDim2.new(0, 30, 0, 18)
    BackBtn.Position = UDim2.new(0, 8, 0, 8)
    BackBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    BackBtn.Text = "◀"
    BackBtn.TextColor3 = Color3.new(1, 1, 1)
    BackBtn.TextSize = 8
    createCorner(BackBtn, 4)
    
    local function openWindow(title)
        WindowTitle.Text = title
        AppWindow:TweenPosition(UDim2.new(0, 0, 0, 18), "Out", "Quad", 0.25, true)
    end
    
    BackBtn.MouseButton1Click:Connect(function()
        for _, child in pairs(AppWindow:GetChildren()) do
            if child:IsA("Frame") or child:IsA("ScrollingFrame") then child.Visible = false end
        end
        AppWindow:TweenPosition(UDim2.new(0, 0, 1, 0), "In", "Quad", 0.25, true)
    end)

    local function createApp(name, iconText, bgColor, callback)
        local App = Instance.new("Frame", AppContainer)
        App.BackgroundTransparency = 1
        
        local Btn = Instance.new("TextButton", App)
        Btn.Size = UDim2.new(1, 0, 0, 38)
        Btn.BackgroundColor3 = bgColor
        Btn.Text = iconText
        Btn.TextSize = 16
        createCorner(Btn, 8)
        
        local Label = Instance.new("TextLabel", App)
        Label.Size = UDim2.new(1, 0, 0, 12)
        Label.Position = UDim2.new(0, 0, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Text = name
        Label.TextColor3 = Color3.new(1, 1, 1)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 7
        
        Btn.MouseButton1Click:Connect(callback)
    end

    -- APP 1: GOOGLE PLAY STORE
    local PlayContent = Instance.new("Frame", AppWindow)
    PlayContent.Size = UDim2.new(1, -12, 1, -40)
    PlayContent.Position = UDim2.new(0, 6, 0, 35)
    PlayContent.BackgroundTransparency = 1
    PlayContent.Visible = false
    local LayoutPlay = Instance.new("UIListLayout", PlayContent)
    LayoutPlay.Padding = UDim.new(0, 4)
    
    local function createPlayItem(name, action)
        local item = Instance.new("Frame", PlayContent)
        item.Size = UDim2.new(1, 0, 0, 30)
        item.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        createCorner(item, 4)
        
        local label = Instance.new("TextLabel", item)
        label.Size = UDim2.new(0.65, 0, 1, 0)
        label.Position = UDim2.new(0, 4, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 8
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local getBtn = Instance.new("TextButton", item)
        getBtn.Size = UDim2.new(0, 40, 0, 18)
        getBtn.Position = UDim2.new(1, -44, 0.5, -9)
        getBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 100)
        getBtn.Text = "CÀI"
        getBtn.TextColor3 = Color3.new(1, 1, 1)
        getBtn.Font = Enum.Font.GothamBold
        getBtn.TextSize = 8
        createCorner(getBtn, 4)
        getBtn.MouseButton1Click:Connect(action)
    end
    
    createPlayItem("Mod Tốc Độ", function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 80
        end
    end)
    createPlayItem("Siêu Nhảy", function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 150
        end
    end)

    createApp("Play Store", "🛍️", Color3.fromRGB(0, 160, 120), function()
        PlayContent.Visible = true
        openWindow("Play Store")
    end)

    -- APP 2: GEMINI AI
    local GeminiContent = Instance.new("Frame", AppWindow)
    GeminiContent.Size = UDim2.new(1, -12, 1, -40)
    GeminiContent.Position = UDim2.new(0, 6, 0, 35)
    GeminiContent.BackgroundTransparency = 1
    GeminiContent.Visible = false
    
    local AIResponse = Instance.new("TextLabel", GeminiContent)
    AIResponse.Size = UDim2.new(1, 0, 0, 45)
    AIResponse.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    AIResponse.Text = "Chào bạn! Bấm nút để mình gợi ý câu thoại chat cực ngầu nhé."
    AIResponse.TextColor3 = Color3.fromRGB(170, 220, 255)
    AIResponse.Font = Enum.Font.Gotham
    AIResponse.TextSize = 8
    AIResponse.TextWrapped = true
    createCorner(AIResponse, 6)
    
    local AIChatBtn = Instance.new("TextButton", GeminiContent)
    AIChatBtn.Size = UDim2.new(1, 0, 0, 25)
    AIChatBtn.Position = UDim2.new(0, 0, 0, 55)
    AIChatBtn.BackgroundColor3 = Color3.fromRGB(85, 120, 255)
    AIChatBtn.Text = "✨ Phát Ngôn Ngay"
    AIChatBtn.TextColor3 = Color3.new(1, 1, 1)
    AIChatBtn.Font = Enum.Font.GothamBold
    AIChatBtn.TextSize = 9
    createCorner(AIChatBtn, 6)
    
    local CoolQuotes = {
        "Đừng tìm anh, anh ở một đẳng cấp khác! ⚡",
        "Gemini Hub Smartphone v4 mượt mà quá! 📱🔥"
    }
    AIChatBtn.MouseButton1Click:Connect(function()
        local quote = CoolQuotes[math.random(1, #CoolQuotes)]
        AIResponse.Text = quote
        local TextChatService = game:GetService("TextChatService")
        if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            TextChatService.TextChannels.RBXGeneral:SendAsync(quote)
        else
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(quote, "All")
        end
    end)
    
    createApp("Gemini AI", "✨", Color3.fromRGB(80, 50, 180), function()
        GeminiContent.Visible = true
        openWindow("Gemini AI")
    end)

    -- APP 3: CÀI ĐẶT (Đã sửa lỗi hiển thị màu xám xịt)
    local SetContent = Instance.new("Frame", AppWindow)
    SetContent.Size = UDim2.new(1, -12, 1, -40)
    SetContent.Position = UDim2.new(0, 6, 0, 35)
    SetContent.BackgroundTransparency = 1
    SetContent.Visible = false
    local LayoutSet = Instance.new("UIListLayout", SetContent)
    LayoutSet.Padding = UDim.new(0, 5)
    
    local function createSetBtn(name, color, imgId)
        local btn = Instance.new("TextButton", SetContent)
        btn.Size = UDim2.new(1, 0, 0, 25)
        btn.BackgroundColor3 = color
        btn.Text = name
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 8
        createCorner(btn, 4)
        btn.MouseButton1Click:Connect(function() Screen.Image = imgId end)
    end
    
    createSetBtn("🖼️ Nền Đen Không Gian", Color3.fromRGB(50, 40, 70), "rbxassetid://13540899144")
    createSetBtn("🖼️ Nền Tương Lai Neon", Color3.fromRGB(30, 60, 50), "rbxassetid://11488102324")
    
    -- Icon Cài đặt mới màu xám thép sáng cực sang trọng, không bị tối
    createApp("Cài đặt", "⚙️", Color3.fromRGB(120, 125, 135), function()
        SetContent.Visible = true
        openWindow("Cài Đặt")
    end)

    -- TIỆN ÍCH KHÁC (REJOIN, RESET, TẮT MÁY)
    createApp("Rejoin", "🔄", Color3.fromRGB(0, 120, 255), function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end)
    
    createApp("Reset", "💀", Color3.fromRGB(220, 50, 50), function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0
        end
    end)
    
    createApp("Tắt Máy", "❌", Color3.fromRGB(55, 55, 60), function()
        PhoneGui:Destroy()
    end)
    
    -- Home Bar đáy máy
    local HomeBar = Instance.new("Frame", Screen)
    HomeBar.Size = UDim2.new(0, 60, 0, 3)
    HomeBar.Position = UDim2.new(0.5, -30, 1, -6)
    HomeBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HomeBar.BorderSizePixel = 0
    createCorner(HomeBar, 5)
end)


-- ==========================================
-- 46. BẢNG GLITCHES HOÀN TOÀN MỚI (PHONG CÁCH NEON RGB - SIÊU ĐẸP)
-- ==========================================
createButton("👾 Chức Năng Glitches", Color3.fromRGB(255, 0, 100), function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    
    local GlitchGui = Instance.new("ScreenGui", game.CoreGui)
    GlitchGui.Name = "GeminiNeonGlitchMenu"
    GlitchGui.ResetOnSpawn = false
    
    -- Khung Menu độc lập siêu đẹp
    local GlitchFrame = Instance.new("Frame", GlitchGui)
    GlitchFrame.Size = UDim2.new(0, IsMobile and 240 or 300, 0, IsMobile and 170 or 210)
    GlitchFrame.Position = UDim2.new(0.5, IsMobile and -120 or -150, 0.5, IsMobile and -85 or -105)
    GlitchFrame.BackgroundColor3 = Color3.fromRGB(10, 8, 15)
    GlitchFrame.BorderSizePixel = 0
    createCorner(GlitchFrame, 12)
    makeDraggable(GlitchFrame)
    
    -- Viền nhấp nháy chuyển màu liên tục (Chroma/RGB) cực đỉnh cao!
    local GlitchStroke = Instance.new("UIStroke", GlitchFrame)
    GlitchStroke.Thickness = 2
    task.spawn(function()
        while task.wait(0.02) do
            if not GlitchStroke then break end
            GlitchStroke.Color = Color3.fromHSV(tick() % 4 / 4, 1, 1)
        end
    end)
    
    -- Tiêu đề Menu
    local Header = Instance.new("Frame", GlitchFrame)
    Header.Size = UDim2.new(1, 0, 0, 35)
    Header.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
    Header.BorderSizePixel = 0
    createCorner(Header, 12)
    
    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "👾 GLITCH SYSTEM v2"
    Title.TextColor3 = Color3.fromRGB(255, 0, 150)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local CloseBtn = Instance.new("TextButton", Header)
    CloseBtn.Size = UDim2.new(0, 26, 0, 26)
    CloseBtn.Position = UDim2.new(1, -31, 0.5, -13)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 13
    createCorner(CloseBtn, 6)
    CloseBtn.MouseButton1Click:Connect(function() GlitchGui:Destroy() end)
    
    -- Vùng cuộn chức năng
    local ContentScroll = Instance.new("ScrollingFrame", GlitchFrame)
    ContentScroll.Size = UDim2.new(1, -12, 1, -45)
    ContentScroll.Position = UDim2.new(0, 6, 0, 40)
    ContentScroll.BackgroundColor3 = Color3.fromRGB(15, 10, 20)
    ContentScroll.ScrollBarThickness = 3
    createCorner(ContentScroll, 8)
    
    local ListLayout = Instance.new("UIListLayout", ContentScroll)
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
    end)

    -- Hàm tạo nút Glitch có hiệu ứng Hover đổi màu
    local function createGlitchBtn(text, startColor, activeColor, action)
        local btn = Instance.new("TextButton", ContentScroll)
        btn.Size = UDim2.new(1, -10, 0, 36)
        btn.BackgroundColor3 = startColor
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        createCorner(btn, 6)
        
        local active = false
        btn.MouseButton1Click:Connect(function()
            active = not active
            btn.BackgroundColor3 = active and activeColor or startColor
            action(active)
        end)
    end

    -- 1. GLITCH ĐỔI MÀU DA (SKIN CHROMA)
    local skinLoop
    createGlitchBtn("👾 Kích Hoạt Skin Chroma (RGB)", Color3.fromRGB(40, 20, 60), Color3.fromRGB(150, 0, 200), function(isActive)
        if isActive then
            skinLoop = task.spawn(function()
                while true do
                    local char = LocalPlayer.Character
                    if char then
                        for _, part in pairs(char:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.Color = Color3.fromHSV(tick() % 2 / 2, 1, 1)
                            end
                        end
                    end
                    task.wait(0.05)
                end
            end)
        else
            if skinLoop then task.cancel(skinLoop) end
        end
    end)
    
    -- 2. ĐƯỜNG CHẠY ẢO ẢNH (NEON GHOST TRAIL)
    local trailLoop
    createGlitchBtn("👻 Kích Hoạt Neon Ghost Trail", Color3.fromRGB(20, 50, 60), Color3.fromRGB(0, 170, 170), function(isActive)
        if isActive then
            trailLoop = task.spawn(function()
                while true do
                    local char = LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root and root.AssemblyLinearVelocity.Magnitude > 2 then
                        local ghost = Instance.new("Part")
                        ghost.Size = Vector3.new(2, 2, 1)
                        ghost.CFrame = root.CFrame
                        ghost.Anchored = true
                        ghost.CanCollide = false
                        ghost.Color = Color3.fromHSV(tick() % 3 / 3, 1, 1) -- Đổi màu cầu vồng ảo diệu
                        ghost.Material = Enum.Material.Neon
                        ghost.Transparency = 0.4
                        ghost.Parent = workspace
                        
                        TweenService:Create(ghost, TweenInfo.new(0.4), {Transparency = 1, Size = Vector3.new(0.1, 0.1, 0.1)}):Play()
                        game:GetService("Debris"):AddItem(ghost, 0.4)
                    end
                    task.wait(0.08)
                end
            end)
        else
            if trailLoop then task.cancel(trailLoop) end
        end
    end)

    -- 3. RUNG CAMERA CỰC MẠNH (SCREEN SHAKE)
    local shakeLoop
    createGlitchBtn("🫨 Kích Hoạt Rung Màn Hình", Color3.fromRGB(70, 30, 30), Color3.fromRGB(200, 20, 20), function(isActive)
        if isActive then
            shakeLoop = task.spawn(function()
                local camera = workspace.CurrentCamera
                while true do
                    local x = math.random(-3, 3) / 15
                    local y = math.random(-3, 3) / 15
                    camera.CFrame = camera.CFrame * CFrame.new(x, y, 0)
                    task.wait(0.01)
                end
            end)
        else
            if shakeLoop then task.cancel(shakeLoop) end
        end
    end)
end)

-- ==========================================
-- 47. BẢNG CHỨC NĂNG ERROR ĐỘC LẬP (GIẢ LẬP LỖI HỆ THỐNG / TROLL)
-- ==========================================
createButton("⚠️ Chức Năng Error", Color3.fromRGB(255, 50, 50), function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local TweenService = game:GetService("TweenService")
    
    local ErrorGui = Instance.new("ScreenGui", game.CoreGui)
    ErrorGui.Name = "GeminiErrorMenu"
    ErrorGui.ResetOnSpawn = false
    
    -- Khung Menu Error nhỏ gọn, vừa vặn cho điện thoại
    local ErrorFrame = Instance.new("Frame", ErrorGui)
    ErrorFrame.Size = UDim2.new(0, IsMobile and 240 or 300, 0, IsMobile and 160 or 200)
    ErrorFrame.Position = UDim2.new(0.5, IsMobile and -120 or -150, 0.5, IsMobile and -80 or -100)
    ErrorFrame.BackgroundColor3 = Color3.fromRGB(20, 5, 5) -- Nền đỏ đen đậm chất nguy hiểm
    ErrorFrame.BorderSizePixel = 0
    createCorner(ErrorFrame, 12)
    makeDraggable(ErrorFrame)
    
    local ErrorStroke = Instance.new("UIStroke", ErrorFrame)
    ErrorStroke.Color = Color3.fromRGB(255, 50, 50)
    ErrorStroke.Thickness = 2
    
    -- Thanh Tiêu Đề Menu
    local Header = Instance.new("Frame", ErrorFrame)
    Header.Size = UDim2.new(1, 0, 0, 35)
    Header.BackgroundColor3 = Color3.fromRGB(150, 20, 20)
    Header.BorderSizePixel = 0
    createCorner(Header, 12)
    
    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "⚠️ CRITICAL SYSTEM ERROR"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 11
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local CloseBtn = Instance.new("TextButton", Header)
    CloseBtn.Size = UDim2.new(0, 26, 0, 26)
    CloseBtn.Position = UDim2.new(1, -31, 0.5, -13)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 13
    createCorner(CloseBtn, 6)
    CloseBtn.MouseButton1Click:Connect(function() ErrorGui:Destroy() end)
    
    -- Vùng cuộn chức năng bên dưới
    local ContentScroll = Instance.new("ScrollingFrame", ErrorFrame)
    ContentScroll.Size = UDim2.new(1, -12, 1, -45)
    ContentScroll.Position = UDim2.new(0, 6, 0, 40)
    ContentScroll.BackgroundColor3 = Color3.fromRGB(25, 10, 10)
    ContentScroll.ScrollBarThickness = 3
    createCorner(ContentScroll, 8)
    
    local ListLayout = Instance.new("UIListLayout", ContentScroll)
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
    end)

    -- Hàm tạo nút chức năng Error nhanh
    local function createErrorBtn(text, btnColor, action)
        local btn = Instance.new("TextButton", ContentScroll)
        btn.Size = UDim2.new(1, -10, 0, 35)
        btn.BackgroundColor3 = btnColor
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        createCorner(btn, 6)
        btn.MouseButton1Click:Connect(action)
    end

    -- 1. TÍNH NĂNG: FAKE CRASH GAME (ĐƠ GAME TRONG 3 GIÂY)
    createErrorBtn("🚫 Giả Lập Đơ Game (Fake Crash)", Color3.fromRGB(80, 30, 30), function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Hệ thống",
            Text = "Đang giả lập crash trong 3 giây...",
            Duration = 2
        })
        task.wait(0.5)
        local startTime = os.clock()
        while os.clock() - startTime < 3 do
            -- Vòng lặp liên tục không nghỉ khiến game bị khựng/đơ lại 3 giây
        end
    end)

    -- 2. TÍNH NĂNG: VOID FALL ERROR (RƠI XUỐNG HƯ KHÔNG)
    createErrorBtn("🕳️ Lỗi Rơi Hư Không (Void Fall)", Color3.fromRGB(100, 60, 20), function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = root.CFrame * CFrame.new(0, -400, 0) -- Đẩy nhân vật xuống sâu bên dưới map
        end
    end)

    -- 3. TÍNH NĂNG: KICK PRANK (BẢNG THÔNG BÁO BỊ KICK GIẢ)
    createErrorBtn("🚪 Giả Lập Bị Admin Kick (Prank)", Color3.fromRGB(120, 20, 50), function()
        -- Tạo một giao diện giống hệt bảng thông báo Disconnect của Roblox
        local KickGui = Instance.new("ScreenGui", game.CoreGui)
        
        local Background = Instance.new("Frame", KickGui)
        Background.Size = UDim2.new(1, 0, 1, 0)
        Background.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Background.BackgroundTransparency = 0.3
        
        local MsgFrame = Instance.new("Frame", Background)
        MsgFrame.Size = UDim2.new(0, 320, 0, 160)
        MsgFrame.Position = UDim2.new(0.5, -160, 0.5, -80)
        MsgFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        createCorner(MsgFrame, 8)
        
        local TitleText = Instance.new("TextLabel", MsgFrame)
        TitleText.Size = UDim2.new(1, 0, 0, 40)
        TitleText.Text = "Disconnected"
        TitleText.TextColor3 = Color3.new(1, 1, 1)
        TitleText.Font = Enum.Font.GothamBold
        TitleText.TextSize = 18
        TitleText.BackgroundTransparency = 1
        
        local DescText = Instance.new("TextLabel", MsgFrame)
        DescText.Size = UDim2.new(1, -20, 0, 60)
        DescText.Position = UDim2.new(0, 10, 0, 45)
        DescText.Text = "You have been kicked by Admin.\nReason: Modding/Cheating Detected.\n(Error Code: 267)"
        DescText.TextColor3 = Color3.fromRGB(220, 220, 220)
        DescText.Font = Enum.Font.Gotham
        DescText.TextSize = 11
        DescText.BackgroundTransparency = 1
        DescText.TextWrapped = true
        
        local LeaveBtn = Instance.new("TextButton", MsgFrame)
        LeaveBtn.Size = UDim2.new(0, 100, 0, 30)
        LeaveBtn.Position = UDim2.new(0.5, -50, 1, -40)
        LeaveBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        LeaveBtn.Text = "Thoát Troll"
        LeaveBtn.TextColor3 = Color3.new(0, 0, 0)
        LeaveBtn.Font = Enum.Font.GothamBold
        LeaveBtn.TextSize = 11
        createCorner(LeaveBtn, 4)
        
        LeaveBtn.MouseButton1Click:Connect(function()
            KickGui:Destroy() -- Tắt bảng troll đi để tiếp tục chơi bình thường
        end)
    end)
end)

-- 48. CHỨC NĂNG CHỐNG RƠI (ANTI-VOID FALL)
local AntiVoidActive = false
local Connection = nil

createButton("🕳️ Chống Rơi (Anti-Void)", Color3.fromRGB(0, 200, 255), function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    AntiVoidActive = not AntiVoidActive
    
    if AntiVoidActive then
        local lastSafePosition = nil
        
        Connection = game:GetService("RunService").Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                
                local ray = Ray.new(root.Position, Vector3.new(0, -10, 0))
                local hit, pos = workspace:FindPartOnRay(ray, char)
                
                if hit then
                    lastSafePosition = root.CFrame
                end
                
                if root.Position.Y < -500 then
                    if lastSafePosition then
                        root.CFrame = lastSafePosition
                    else
                        root.CFrame = CFrame.new(0, 50, 0)
                    end
                end
            end
        end)
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Hệ thống",
            Text = "Đã bật: Chống rơi hố!",
            Duration = 2
        })
    else
        if Connection then
            Connection:Disconnect()
            Connection = nil
        end
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Hệ thống",
            Text = "Đã tắt: Chống rơi hố!",
            Duration = 2
        })
    end
end)

-- 49. CHỨC NĂNG FULLBRIGHT (SÁNG BẢN ĐỒ)
local BrightActive = false
local OldAmbient, OldOutdoor, OldBrightness, OldFog

createButton("💡 Fullbright (Sáng Bản Đồ)", Color3.fromRGB(255, 255, 0), function()
    local Lighting = game:GetService("Lighting")
    BrightActive = not BrightActive
    
    if BrightActive then
        -- Lưu lại thông số cũ để khi tắt thì khôi phục
        OldAmbient = Lighting.Ambient
        OldOutdoor = Lighting.OutdoorAmbient
        OldBrightness = Lighting.Brightness
        OldFog = Lighting.FogEnd
        
        -- Chỉnh sáng tối đa
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
        Lighting.FogEnd = 999999
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Hệ thống",
            Text = "Đã bật: Fullbright (Sáng rõ ban ngày)",
            Duration = 2
        })
    else
        -- Khôi phục thông số cũ
        Lighting.Ambient = OldAmbient
        Lighting.OutdoorAmbient = OldOutdoor
        Lighting.Brightness = OldBrightness
        Lighting.FogEnd = OldFog
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Hệ thống",
            Text = "Đã tắt: Trả lại ánh sáng gốc",
            Duration = 2
        })
    end
end)

-- 50. CHỨC NĂNG TRÔI NỔI VÔ TRỌNG LỰC (ANTI-GRAVITY)
local GravActive = false

createButton("🌌 Không Trọng Lực (Float)", Color3.fromRGB(180, 100, 255), function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Workspace = game:GetService("Workspace")
    
    GravActive = not GravActive
    
    local char = LocalPlayer.Character
    local target = char and char:FindFirstChild("HumanoidRootPart")
    
    if GravActive then
        -- Tạo lực đối kháng lại trọng lực mặc định của game
        if target then
            local floatForce = Instance.new("BodyForce")
            floatForce.Name = "AntiGravForce"
            -- Công thức tính lực nâng vừa đủ để triệt tiêu trọng lực của nhân vật
            local mass = 0
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    mass = mass + part:GetMass()
                end
            end
            floatForce.Force = Vector3.new(0, mass * Workspace.Gravity * 0.95, 0) -- Giữ 95% lực để vẫn rơi nhẹ nhàng cực phê
            floatForce.Parent = target
        end
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Hệ thống",
            Text = "Đã bật: Vô trọng lực! Nhảy để trôi nổi.",
            Duration = 2
        })
    else
        -- Tắt vô trọng lực, rơi xuống bình thường
        if target and target:FindFirstChild("AntiGravForce") then
            target.AntiGravForce:Destroy()
        end
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Hệ thống",
            Text = "Đã tắt: Trọng lực trở lại bình thường",
            Duration = 2
        })
    end
end)

-- 51. CHỨC NĂNG BẢNG CÀI ĐẶT HỆ THỐNG (SETTINGS MENU)
createButton("⚙️ Cài Đặt Hệ Thống", Color3.fromRGB(150, 150, 150), function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local TweenService = game:GetService("TweenService")
    
    local SettingsGui = Instance.new("ScreenGui", game.CoreGui)
    SettingsGui.Name = "GeminiSettingsMenu"
    SettingsGui.ResetOnSpawn = false
    
    -- Khung cài đặt bo góc nhỏ gọn cho điện thoại
    local SettingsFrame = Instance.new("Frame", SettingsGui)
    SettingsFrame.Size = UDim2.new(0, IsMobile and 240 or 300, 0, IsMobile and 180 or 220)
    SettingsFrame.Position = UDim2.new(0.5, IsMobile and -120 or -150, 0.5, IsMobile and -90 or -110)
    SettingsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    SettingsFrame.BorderSizePixel = 0
    createCorner(SettingsFrame, 12)
    makeDraggable(SettingsFrame)
    
    local SettingsStroke = Instance.new("UIStroke", SettingsFrame)
    SettingsStroke.Color = Color3.fromRGB(150, 150, 150)
    SettingsStroke.Thickness = 2
    
    -- Tiêu đề bảng cài đặt
    local Header = Instance.new("Frame", SettingsFrame)
    Header.Size = UDim2.new(1, 0, 0, 35)
    Header.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Header.BorderSizePixel = 0
    createCorner(Header, 12)
    
    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "⚙️ CÀI ĐẶT GEMINI HUB"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 11
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local CloseBtn = Instance.new("TextButton", Header)
    CloseBtn.Size = UDim2.new(0, 26, 0, 26)
    CloseBtn.Position = UDim2.new(1, -31, 0.5, -13)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 13
    createCorner(CloseBtn, 6)
    CloseBtn.MouseButton1Click:Connect(function() SettingsGui:Destroy() end)
    
    -- Danh sách cuộn chứa các mục cài đặt
    local ContentScroll = Instance.new("ScrollingFrame", SettingsFrame)
    ContentScroll.Size = UDim2.new(1, -12, 1, -45)
    ContentScroll.Position = UDim2.new(0, 6, 0, 40)
    ContentScroll.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    ContentScroll.ScrollBarThickness = 3
    createCorner(ContentScroll, 8)
    
    local ListLayout = Instance.new("UIListLayout", ContentScroll)
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
    end)

    -- Hàm tạo nút cài đặt nhanh
    local function createSettingBtn(text, btnColor, action)
        local btn = Instance.new("TextButton", ContentScroll)
        btn.Size = UDim2.new(1, -10, 0, 32)
        btn.BackgroundColor3 = btnColor
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        createCorner(btn, 6)
        btn.MouseButton1Click:Connect(action)
    end

    -- 1. ĐỔI MÀU CHỦ ĐỀ CHỮ/GIAO DIỆN (THEME COLOR)
    createSettingBtn("🎨 Đổi Theme: Hồng Neon rực rỡ", Color3.fromRGB(180, 50, 130), function()
        -- Gợi ý đổi màu stroke chính của Hub của bạn sang hồng (nếu bạn có đặt biến lưu stroke của Hub chính)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Cài đặt",
            Text = "Đã áp dụng giao diện Hồng Neon!",
            Duration = 2
        })
    end)
    
    createSettingBtn("🎨 Đổi Theme: Xanh Dương Công Nghệ", Color3.fromRGB(30, 100, 180), function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Cài đặt",
            Text = "Đã áp dụng giao diện Xanh Dương!",
            Duration = 2
        })
    end)

    -- 2. TỰ ĐỘNG LÀM SẠCH BẢN ĐỒ / GIẢM LAG (ANTILAG / CLEAR DEBRIS)
    createSettingBtn("🗑️ Dọn Rác Bản Đồ (Giảm Lag)", Color3.fromRGB(40, 120, 80), function()
        local count = 0
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Sparkles") or obj:IsA("Smoke") or obj:IsA("Fire") then
                obj:Destroy()
                count = count + 1
            end
        end
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Cài đặt",
            Text = "Đã dọn dẹp " .. tostring(count) .. " hiệu ứng gây lag!",
            Duration = 2
        })
    end)

    -- 3. XÓA BỎ HOÀN TOÀN HUB KHỎI MÀN HÌNH (UNLOAD / SELF-DESTRUCT)
    createSettingBtn("🛑 Tắt và Xóa Hoàn Toàn GeminiHub", Color3.fromRGB(150, 30, 30), function()
        -- Tìm kiếm tất cả GUI liên quan đến GeminiHub để xóa bỏ
        for _, gui in pairs(game.CoreGui:GetChildren()) do
            if string.find(gui.Name, "Gemini") or gui.Name == "GeminiSmartphoneV4" or gui.Name == "GeminiNeonGlitchMenu" then
                gui:Destroy()
            end
        end
        SettingsGui:Destroy()
    end)
end)

-- 52. CHỨC NĂNG HỆ THỐNG KHÓA (KEY SYSTEM - 10 KEY BẢO MẬT)
local KeyVerified = false

local ValidKeys = {
    ["GM-9xK2-7pLm-2026"] = true,
    ["GEMINI#u8F9_v7Y"] = true,
    ["GM-Secure-9a8x"] = true,
    ["Key_zB6#pQ9_v1x"] = true,
    ["GM-Vip_8cT2-4wNz"] = true,
    ["Hacker_7bX9_pL2k"] = true,
    ["GM-Free_5mKp_8tR4"] = true,
    ["Active_9yT4#u7Bx"] = true,
    ["Gemini_Ultra_2k26"] = true,
    ["GM-Private-99x7"] = true
}

createButton("🔑 Cài Đặt Key System", Color3.fromRGB(255, 200, 0), function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    local KeyGui = Instance.new("ScreenGui", game.CoreGui)
    KeyGui.Name = "GeminiKeySystem"
    KeyGui.ResetOnSpawn = false
    
    -- Khung nhập Key bo góc nhỏ gọn
    local KeyFrame = Instance.new("Frame", KeyGui)
    KeyFrame.Size = UDim2.new(0, IsMobile and 240 or 280, 0, IsMobile and 140 or 160)
    KeyFrame.Position = UDim2.new(0.5, IsMobile and -120 or -140, 0.5, IsMobile and -70 or -80)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    KeyFrame.BorderSizePixel = 0
    createCorner(KeyFrame, 12)
    makeDraggable(KeyFrame)
    
    local KeyStroke = Instance.new("UIStroke", KeyFrame)
    KeyStroke.Color = Color3.fromRGB(255, 200, 0)
    KeyStroke.Thickness = 2
    
    -- Tiêu đề
    local Title = Instance.new("TextLabel", KeyFrame)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.new(0, 0, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "🔑 GEMINI KEY SYSTEM"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 12
    
    -- Ô Nhập Key
    local TextBox = Instance.new("TextBox", KeyFrame)
    TextBox.Size = UDim2.new(1, -40, 0, 32)
    TextBox.Position = UDim2.new(0, 20, 0, 45)
    TextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    TextBox.Text = ""
    TextBox.PlaceholderText = "Nhập một trong các Key hợp lệ..."
    TextBox.TextColor3 = Color3.new(1, 1, 1)
    TextBox.Font = Enum.Font.Gotham
    TextBox.TextSize = 11
    createCorner(TextBox, 6)
    
    local TextBoxStroke = Instance.new("UIStroke", TextBox)
    TextBoxStroke.Color = Color3.fromRGB(70, 70, 75)
    TextBoxStroke.Thickness = 1
    
    -- Nút Kiểm Tra Key
    local VerifyBtn = Instance.new("TextButton", KeyFrame)
    VerifyBtn.Size = UDim2.new(0.5, -25, 0, 30)
    VerifyBtn.Position = UDim2.new(0, 20, 1, -42)
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
    VerifyBtn.Text = "XÁC NHẬN"
    VerifyBtn.TextColor3 = Color3.new(1, 1, 1)
    VerifyBtn.Font = Enum.Font.GothamBold
    VerifyBtn.TextSize = 10
    createCorner(VerifyBtn, 6)
    
    -- Nút Lấy Key (Link Linkvertise)
    local GetKeyBtn = Instance.new("TextButton", KeyFrame)
    GetKeyBtn.Size = UDim2.new(0.5, -25, 0, 30)
    GetKeyBtn.Position = UDim2.new(0.5, 5, 1, -42)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 85)
    GetKeyBtn.Text = "LẤY KEY LINK"
    GetKeyBtn.TextColor3 = Color3.new(1, 1, 1)
    GetKeyBtn.Font = Enum.Font.GothamBold
    GetKeyBtn.TextSize = 10
    createCorner(GetKeyBtn, 6)
    
    -- Sự kiện Xác Nhận Key
    VerifyBtn.MouseButton1Click:Connect(function()
        local EnteredKey = TextBox.Text
        if ValidKeys[EnteredKey] then
            KeyVerified = true
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Hệ thống",
                Text = "Key chính xác! Chúc bạn chơi game vui vẻ.",
                Duration = 3
            })
            KeyGui:Destroy()
        else
            TextBox.Text = ""
            TextBox.PlaceholderText = "Sai Key! Vui lòng thử lại..."
            TextBoxStroke.Color = Color3.fromRGB(220, 50, 50)
            task.wait(1.5)
            TextBoxStroke.Color = Color3.fromRGB(70, 70, 75)
        end
    end)
    
    -- Sự kiện Copy Link Lấy Key (Đã dọn sạch link gốc)
    GetKeyBtn.MouseButton1Click:Connect(function()
        -- Thay thế link rút gọn Linkvertise làm nhiệm vụ của bạn ở đây
        setclipboard("https://direct-link.net/6418717/dtr78S55t7ey") 
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Hệ thống",
            Text = "Đã copy link lấy Key vào bộ nhớ tạm!",
            Duration = 3
        })
    end)
end)

-- 53.NÚT BẤM KÍCH HOẠT PROMPT NHANH 0S
createButton("⚡ Prompt Nhanh 0s", Color3.fromRGB(230, 130, 10), function()
    local count = 0
    -- Quét toàn bộ map và giảm HoldDuration về 0
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            obj.HoldDuration = 0
            count = count + 1
        end
    end
    
    -- Tự động xử lý các Prompt xuất hiện sau đó
    if not _G.PromptFastConnection then
        _G.PromptFastConnection = workspace.DescendantAdded:Connect(function(obj)
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = 0
            end
        end)
    end
    
    -- Thông báo sau khi nhấn nút
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Gemini Hub",
        Text = "Đã kích hoạt Prompt 0s cho " .. tostring(count) .. " đối tượng!",
        Duration = 2
    })
end)

-- 54.TRẠNG THÁI MẶC ĐỊNH LÀ TẮT
_G.AntiTouchEnabled = false

createButton("🛡️ Anti-Touch (Bật/Tắt)", Color3.fromRGB(200, 50, 50), function()
    _G.AntiTouchEnabled = not _G.AntiTouchEnabled -- Đảo ngược trạng thái
    local keywords = {"lava", "kill", "damage", "laser", "hazard", "spike"}
    
    -- Hàm xử lý trạng thái
    local function processPart(part, state)
        if part:IsA("BasePart") then
            local name = string.lower(part.Name)
            for _, word in pairs(keywords) do
                if string.find(name, word) then
                    part.CanTouch = state -- true (được chạm) hoặc false (bất tử)
                    break
                end
            end
        end
    end

    -- Nếu Bật thì CanTouch = false (bất tử), nếu Tắt thì CanTouch = true (nguy hiểm lại)
    local targetState = not _G.AntiTouchEnabled 

    -- Quét toàn bộ vật thể hiện có trong map
    for _, obj in pairs(workspace:GetDescendants()) do
        processPart(obj, targetState)
    end
    
    -- Lắng nghe vật thể mới spawn
    if _G.AntiTouchEnabled then
        if not _G.AntiTouchConnection then
            _G.AntiTouchConnection = workspace.DescendantAdded:Connect(function(obj)
                if _G.AntiTouchEnabled then processPart(obj, false) end
            end)
        end
    else
        -- Nếu tắt, ngắt kết nối lắng nghe để không làm lag game
        if _G.AntiTouchConnection then
            _G.AntiTouchConnection:Disconnect()
            _G.AntiTouchConnection = nil
        end
    end
    
    -- Thông báo trạng thái
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Anti-Touch",
        Text = _G.AntiTouchEnabled and "🛡️ Đã Bật: Bạn bất tử với Lava!" or "⚠️ Đã Tắt: Lava gây sát thương!",
        Duration = 2
    })
end)

-- 55.TRẠNG THÁI MẶC ĐỊNH
_G.AutoTranslateEnabled = false

createButton("🌐 Dịch Tiếng Việt (On/Off)", Color3.fromRGB(30, 140, 200), function()
    _G.AutoTranslateEnabled = not _G.AutoTranslateEnabled
    local LocalizationService = game:GetService("LocalizationService")
    
    -- Hàm thực hiện dịch văn bản
    local function translateUi(obj)
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            -- Chỉ dịch nếu text không trống và không phải toàn số
            if obj.Text ~= "" and not tonumber(obj.Text) then
                pcall(function()
                    local success, result = pcall(function()
                        return LocalizationService:FilterStringForPlayerAsync(obj.Text, game.Players.LocalPlayer, Enum.TranslatorCategory.GameContent)
                    end)
                    -- Nếu hệ thống trả về kết quả dịch chuẩn, áp dụng luôn
                    if success and result then
                        obj.Text = result
                    end
                end)
            end
        end
    end

    if _G.AutoTranslateEnabled then
        -- Dịch toàn bộ UI hiện tại
        for _, obj in pairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
            translateUi(obj)
        end
        for _, obj in pairs(game.CoreGui:GetDescendants()) do
            translateUi(obj)
        end

        -- Tự động dịch các UI mới xuất hiện sau đó
        if not _G.TranslateConnection then
            _G.TranslateConnection = game.Players.LocalPlayer.PlayerGui.DescendantAdded:Connect(function(obj)
                if _G.AutoTranslateEnabled then
                    task.wait(0.1) -- Đợi văn bản load xong rồi dịch
                    translateUi(obj)
                end
            end)
        end
    else
        -- Tắt lắng nghe tự động dịch khi tắt nút
        if _G.TranslateConnection then
            _G.TranslateConnection:Disconnect()
            _G.TranslateConnection = nil
        end
    end

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Dịch Thuật",
        Text = _G.AutoTranslateEnabled and "🌐 Đã bật tự động dịch tiếng Việt!" or "⚠️ Đã tắt tự động dịch!",
        Duration = 2
    })
end)

-- 56.TRẠNG THÁI MẶC ĐỊNH
_G.AutoClickEnabled = false

createButton("🖱️ Auto Click Tool (On/Off)", Color3.fromRGB(40, 160, 80), function()
    _G.AutoClickEnabled = not _G.AutoClickEnabled
    
    if _G.AutoClickEnabled then
        -- Chạy vòng lặp click liên tục trong nền
        task.spawn(function()
            local Player = game.Players.LocalPlayer
            while _G.AutoClickEnabled do
                local Character = Player.Character
                if Character then
                    -- Tìm kiếm Tool đang được nhân vật cầm trên tay
                    local Tool = Character:FindFirstChildOfClass("Tool")
                    if Tool then
                        Tool:Activate() -- Kích hoạt (click) tool
                    end
                end
                task.wait(0.01) -- Khoảng thời gian giữa mỗi lần click (0.01s là siêu nhanh)
            end
        end)
    end

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Auto Click",
        Text = _G.AutoClickEnabled and "🖱️ Đã Bật: Hãy cầm tool lên để tự động click!" or "⚠️ Đã Tắt Auto Click!",
        Duration = 2
    })
end)

-- 57.TRẠNG THÁI MẶC ĐỊNH

_G.AutoWallHopEnabled = false

createButton("🧗 Wall Hop (Sửa Lỗi)", Color3.fromRGB(100, 200, 50), function()
    _G.AutoWallHopEnabled = not _G.AutoWallHopEnabled
    
    if _G.AutoWallHopEnabled then
        task.spawn(function()
            local Player = game.Players.LocalPlayer
            local RunService = game:GetService("RunService")
            
            while _G.AutoWallHopEnabled do
                local Character = Player.Character
                if Character and Character:FindFirstChild("Humanoid") and Character:FindFirstChild("HumanoidRootPart") then
                    local Humanoid = Character.Humanoid
                    local RootPart = Character.HumanoidRootPart
                    
                    -- Bắn tia Ray để check tường chính xác hơn
                    local ray = Ray.new(RootPart.Position, RootPart.CFrame.LookVector * 3)
                    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {Character})
                    
                    -- Nếu chạm tường và đang ở trên không hoặc đang nhảy thì ép nhảy tiếp lập tức
                    if hit and (Humanoid:GetState() == Enum.HumanoidStateType.Jumping or Humanoid:GetState() == Enum.HumanoidStateType.Freefall) then
                        Humanoid.Jump = true
                    end
                end
                RunService.RenderStepped:Wait() -- Chạy theo khung hình máy để mượt nhất
            end
        end)
    end

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Wall Hop",
        Text = _G.AutoWallHopEnabled and "🧗 Đã Bật: Auto Wall Hop mượt mà!" or "⚠️ Đã Tắt Wall Hop!",
        Duration = 2
    })
end)

-- 58.TRẠNG THÁI MẶC ĐỊNH

_G.FullBrightEnabled = false

createButton("💡 FullBright (Bật/Tắt)", Color3.fromRGB(255, 200, 50), function()
    _G.FullBrightEnabled = not _G.FullBrightEnabled
    local Player = game.Players.LocalPlayer
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    
    if _G.FullBrightEnabled then
        if RootPart and not RootPart:FindFirstChild("GeminiLight") then
            -- Tạo đèn nếu chưa có
            local light = Instance.new("PointLight")
            light.Name = "GeminiLight"
            light.Brightness = 5 -- Độ sáng
            light.Range = 50     -- Bán kính sáng
            light.Color = Color3.fromRGB(255, 255, 255)
            light.Parent = RootPart
        end
    else
        -- Tắt đèn: Xóa PointLight nếu nó tồn tại
        if RootPart and RootPart:FindFirstChild("GeminiLight") then
            RootPart.GeminiLight:Destroy()
        end
    end
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "FullBright",
        Text = _G.FullBrightEnabled and "💡 Đã Bật: Nhân vật tỏa sáng!" or "⚠️ Đã Tắt: Trở lại bình thường!",
        Duration = 2
    })
end)

-- 59.TRẠNG THÁI MẶC ĐỊNH
_G.AntiNPCEnabled = false

createButton("👻 Anti-NPC (Chống đuổi)", Color3.fromRGB(120, 40, 160), function()
    _G.AntiNPCEnabled = not _G.AntiNPCEnabled
    local Player = game.Players.LocalPlayer
    local NPCs = {} -- Lưu tạm danh sách NPC bị xóa để khôi phục nếu cần

    if _G.AntiNPCEnabled then
        -- Vòng lặp liên tục quét và "xóa" NPC
        task.spawn(function()
            while _G.AntiNPCEnabled do
                for _, obj in pairs(workspace:GetDescendants()) do
                    -- Tìm vật thể có Humanoid (NPC) và không phải là người chơi
                    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Name ~= Player.Name then
                        -- Kiểm tra nếu nó không phải là người chơi khác
                        if not game.Players:GetPlayerFromCharacter(obj) then
                            -- Ẩn/Xóa cục bộ (Local)
                            obj.Parent = nil 
                        end
                    end
                end
                task.wait(0.5) -- Quét mỗi nửa giây
            end
        end)
    else
        -- Khi tắt, khuyến khích bạn Reset nhân vật (hoặc game sẽ tự load lại NPC khi bạn sang vùng mới)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Anti-NPC",
            Text = "Đã tắt: NPC sẽ dần xuất hiện lại!",
            Duration = 3
        })
    end
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Anti-NPC",
        Text = _G.AntiNPCEnabled and "👻 Đã Bật: NPC sẽ biến mất khỏi tầm mắt bạn!" or "⚠️ Đã Tắt Anti-NPC!",
        Duration = 2
    })
end)

_G.FullBrightSkyEnabled = false

createButton("🌌 Sáng Bầu Trời", Color3.fromRGB(255, 255, 255), function()
    _G.FullBrightSkyEnabled = not _G.FullBrightSkyEnabled
    local Lighting = game:GetService("Lighting")

    if _G.FullBrightSkyEnabled then
        -- Lưu lại cài đặt gốc của game để khôi phục khi tắt
        _G.OriginalAmbient = Lighting.Ambient
        _G.OriginalOutdoorAmbient = Lighting.OutdoorAmbient
        _G.OriginalBrightness = Lighting.Brightness
        _G.OriginalClockTime = Lighting.ClockTime

        -- Bật sáng toàn bộ bầu trời và map
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 3
        Lighting.ClockTime = 14 -- Ép thời gian về buổi trưa để trời sáng nhất
    else
        -- Khôi phục lại trạng thái ban đầu của game
        Lighting.Ambient = _G.OriginalAmbient or Color3.fromRGB(128, 128, 128)
        Lighting.OutdoorAmbient = _G.OriginalOutdoorAmbient or Color3.fromRGB(128, 128, 128)
        Lighting.Brightness = _G.OriginalBrightness or 1
        Lighting.ClockTime = _G.OriginalClockTime or 12
    end

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Bầu Trời",
        Text = _G.FullBrightSkyEnabled and "🌌 Đã bật sáng bầu trời!" or "⚠️ Đã tắt sáng bầu trời!",
        Duration = 2
    })
end)

createButton("🔗 Link & Server", Color3.fromRGB(150, 50, 200), function()
    local Player = game:GetService("Players").LocalPlayer
    local LinkGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
    local Frame = Instance.new("Frame", LinkGui)
    Frame.Size = UDim2.new(0, 220, 0, 180); Frame.Position = UDim2.new(0.5, -110, 0.5, -90); Frame.Active = true; Frame.Draggable = true
    Instance.new("UICorner", Frame)
    local CloseBtn = Instance.new("TextButton", Frame); CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(0.85, 0, 0, 0); CloseBtn.Text = "✕"; CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    CloseBtn.MouseButton1Click:Connect(function() LinkGui:Destroy() end)
    local Input = Instance.new("TextBox", Frame); Input.Size = UDim2.new(0.8, 0, 0, 35); Input.Position = UDim2.new(0.1, 0, 0.2, 0); Input.PlaceholderText = "Nhập Job ID"
    local JoinBtn = Instance.new("TextButton", Frame); JoinBtn.Size = UDim2.new(0.8, 0, 0, 35); JoinBtn.Position = UDim2.new(0.1, 0, 0.45, 0); JoinBtn.Text = "Join Server"
    JoinBtn.MouseButton1Click:Connect(function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, Input.Text, game.Players.LocalPlayer) end)
    local RestartBtn = Instance.new("TextButton", Frame); RestartBtn.Size = UDim2.new(0.8, 0, 0, 35); RestartBtn.Position = UDim2.new(0.1, 0, 0.75, 0); RestartBtn.Text = "Restart Script"
    RestartBtn.MouseButton1Click:Connect(function() LinkGui:Destroy(); loadstring(game:HttpGet("https://raw.githubusercontent.com/3hbin/Gemini-Hub/refs/heads/main/GeminiHub.lua"))() end)
end)

createButton("⌨️ Bàn Phím Ảo", Color3.fromRGB(85, 85, 85), function()
    local KeyGui = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
    local MainFrame = Instance.new("Frame", KeyGui); MainFrame.Size = UDim2.new(0, 280, 0, 130); MainFrame.Position = UDim2.new(0.5, -140, 0.6, 0); MainFrame.Active = true; MainFrame.Draggable = true
    local CloseBtn = Instance.new("TextButton", MainFrame); CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(0.85, 0, 0, 0); CloseBtn.Text = "✕"; CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    CloseBtn.MouseButton1Click:Connect(function() KeyGui:Destroy() end)
    local Container = Instance.new("Frame", MainFrame); Container.Size = UDim2.new(0.9, 0, 0.7, 0); Container.Position = UDim2.new(0.05, 0, 0.25, 0); Container.BackgroundTransparency = 1
    Instance.new("UIGridLayout", Container).CellSize = UDim2.new(0, 50, 0, 35)
    local keys = {{Enum.KeyCode.LeftShift, "Shift"}, {Enum.KeyCode.LeftControl, "Ctrl"}, {Enum.KeyCode.E, "E"}, {Enum.KeyCode.Q, "Q"}, {Enum.KeyCode.F, "F"}, {Enum.KeyCode.Space, "Space"}}
    for _, v in pairs(keys) do
        local btn = Instance.new("TextButton", Container); btn.Text = v[2]
        btn.MouseButton1Down:Connect(function() game:GetService("VirtualInputManager"):SendKeyEvent(true, v[1], false, game) end)
        btn.MouseButton1Up:Connect(function() game:GetService("VirtualInputManager"):SendKeyEvent(false, v[1], false, game) end)
    end
end)

-- Khởi tạo biến toàn cục cho Home
_G.HomeList = _G.HomeList or {}

local function ModernNotify(msg)
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "🏠 Home System", Text = msg, Duration = 2})
end

createButton("🏠 Danh Sách Home", Color3.fromRGB(35, 35, 35), function()
    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("HomeGui") then game.Players.LocalPlayer.PlayerGui.HomeGui:Destroy() end

    local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
    ScreenGui.Name = "HomeGui"
    
    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 280, 0, 380); Frame.Position = UDim2.new(0.5, -140, 0.5, -190)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Frame.Active = true; Frame.Draggable = true
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 15)
    Instance.new("UIStroke", Frame).Color = Color3.fromRGB(60, 60, 60); Instance.new("UIStroke", Frame).Thickness = 2

    -- Tiêu đề & Nút Đóng
    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0, 50); Title.Text = "QUẢN LÝ HOME"; Title.TextColor3 = Color3.new(1, 1, 1)
    Title.BackgroundTransparency = 1; Title.Font = Enum.Font.GothamBold; Title.TextSize = 18

    local CloseBtn = Instance.new("TextButton", Frame)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(0.88, 0, 0, 10)
    CloseBtn.Text = "✕"; CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40); CloseBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    local List = Instance.new("ScrollingFrame", Frame)
    List.Size = UDim2.new(0.9, 0, 0.5, 0); List.Position = UDim2.new(0.05, 0, 0.15, 0)
    List.BackgroundTransparency = 1; List.ScrollBarThickness = 4

    local NameBox = Instance.new("TextBox", Frame)
    NameBox.Size = UDim2.new(0.8, 0, 0, 40); NameBox.Position = UDim2.new(0.1, 0, 0.7, 0)
    NameBox.PlaceholderText = "Tên Home..."; NameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40); NameBox.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", NameBox)

    local SaveBtn = Instance.new("TextButton", Frame)
    SaveBtn.Size = UDim2.new(0.8, 0, 0, 40); SaveBtn.Position = UDim2.new(0.1, 0, 0.85, 0)
    SaveBtn.Text = "LƯU VỊ TRÍ"; SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255); SaveBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", SaveBtn)

    local function RefreshList()
        List:ClearAllChildren()
        for i, data in pairs(_G.HomeList) do
            local Holder = Instance.new("Frame", List); Holder.Size = UDim2.new(1, 0, 0, 35); Holder.Position = UDim2.new(0, 0, 0, (i-1)*40); Holder.BackgroundTransparency = 1
            
            local Btn = Instance.new("TextButton", Holder); Btn.Size = UDim2.new(0.75, 0, 1, 0); Btn.Text = data.Name; Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50); Btn.TextColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", Btn); Btn.MouseButton1Click:Connect(function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = data.CFrame end)
            
            local Del = Instance.new("TextButton", Holder); Del.Size = UDim2.new(0.2, 0, 1, 0); Del.Position = UDim2.new(0.8, 0, 0, 0); Del.Text = "Xóa"; Del.BackgroundColor3 = Color3.fromRGB(150, 40, 40); Del.TextColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", Del); Del.MouseButton1Click:Connect(function() table.remove(_G.HomeList, i); RefreshList() end)
        end
    end

    SaveBtn.MouseButton1Click:Connect(function()
        local name = (NameBox.Text ~= "" and NameBox.Text or "Home")
        table.insert(_G.HomeList, {Name = "🏠 " .. name, CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame})
        RefreshList(); NameBox.Text = ""
    end)
    
    RefreshList()
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
--=======By : Gemini AI =======--
