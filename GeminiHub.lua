local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local VirtualUser = game:GetService("VirtualUser")
local SocialService = game:GetService("SocialService")
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

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
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
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
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

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 290, 0, 420)
MainFrame.Position = UDim2.new(0.5, -145, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.ClipsDescendants = true
createCorner(MainFrame, 12)
makeDraggable(MainFrame)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(0, 150, 255)
UIStroke.Thickness = math.max(1, 1.5 * ScaleFactor)
UIStroke.Transparency = 0.3

local TopFrame = Instance.new("Frame", MainFrame)
TopFrame.Size = UDim2.new(1, 0, 0, 180) -- Tăng chiều cao TopFrame để vừa khung game mới
TopFrame.BackgroundTransparency = 1

-- KHUNG CHỨA THÔNG TIN GAME (Tăng chiều cao lên 115 để chứa đủ 5 dòng chữ)
local GameFrame = Instance.new("Frame", TopFrame)
GameFrame.Size = UDim2.new(1, -20, 0, 115)
GameFrame.Position = UDim2.new(0, 10, 0, 10)
GameFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 45)
createCorner(GameFrame, 8)

-- 1. Dòng Tên Game
local GameNameLabel = Instance.new("TextLabel", GameFrame)
GameNameLabel.Text = "🎮 Đang tải tên game..."
GameNameLabel.Position = UDim2.new(0, 10, 0, 5)
GameNameLabel.Size = UDim2.new(1, -20, 0, 20)
GameNameLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
GameNameLabel.TextXAlignment = Enum.TextXAlignment.Left
GameNameLabel.Font = Enum.Font.GothamBold
GameNameLabel.TextSize = 12
GameNameLabel.BackgroundTransparency = 1

-- 2. Dòng ID Game
local GameIdLabel = Instance.new("TextLabel", GameFrame)
GameIdLabel.Text = "ID Game: " .. game.PlaceId
GameIdLabel.Position = UDim2.new(0, 10, 0, 27)
GameIdLabel.Size = UDim2.new(1, -20, 0, 15)
GameIdLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
GameIdLabel.TextXAlignment = Enum.TextXAlignment.Left
GameIdLabel.Font = Enum.Font.Code
GameIdLabel.TextSize = 10
GameIdLabel.BackgroundTransparency = 1

-- 3. Dòng Khu Vực Quốc Gia
local CountryLabel = Instance.new("TextLabel", GameFrame)
local countryCode = "Unknown"
pcall(function() 
    countryCode = game:GetService("LocalizationService"):GetCountryRegionForPlayerAsync(LocalPlayer) 
end)
CountryLabel.Text = "Khu vực: " .. string.upper(countryCode)
CountryLabel.Position = UDim2.new(0, 10, 0, 47)
CountryLabel.Size = UDim2.new(1, -20, 0, 15)
CountryLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
CountryLabel.TextXAlignment = Enum.TextXAlignment.Left
CountryLabel.Font = Enum.Font.GothamBold
CountryLabel.TextSize = 10
CountryLabel.BackgroundTransparency = 1

-- 4. Dòng IP Mạng
local IPLabel = Instance.new("TextLabel", GameFrame)
IPLabel.Text = "IP: Đang kiểm tra..."
IPLabel.Position = UDim2.new(0, 10, 0, 67)
IPLabel.Size = UDim2.new(1, -20, 0, 15)
IPLabel.TextColor3 = Color3.fromRGB(255, 85, 85)
IPLabel.TextXAlignment = Enum.TextXAlignment.Left
IPLabel.Font = Enum.Font.Code
IPLabel.TextSize = 10
IPLabel.BackgroundTransparency = 1

-- 5. Nút Bấm Copy JobId (ĐÃ THÊM LẠI Ở ĐÂY)
local JobIdLabel = Instance.new("TextButton", GameFrame)
JobIdLabel.Text = "JobId: " .. game.JobId:sub(1, 12) .. "..."
JobIdLabel.Position = UDim2.new(0, 10, 0, 87)
JobIdLabel.Size = UDim2.new(1, -20, 0, 20)
JobIdLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
JobIdLabel.TextXAlignment = Enum.TextXAlignment.Left
JobIdLabel.BackgroundTransparency = 1
JobIdLabel.Font = Enum.Font.Code
JobIdLabel.TextSize = 10

JobIdLabel.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(game.JobId)
        local oldText = JobIdLabel.Text
        JobIdLabel.Text = "✅ Đã copy JobID Server!"
        task.wait(2)
        JobIdLabel.Text = oldText
    end
end)

-- Các hàm chạy ngầm tải dữ liệu
task.spawn(function()
    local ip = "Không thể lấy IP"
    pcall(function() ip = game:HttpGet("https://api.ipify.org") end)
    IPLabel.Text = "IP: " .. ip
end)

task.spawn(function()
    pcall(function()
        local info = MarketplaceService:GetProductInfo(game.PlaceId)
        if info then GameNameLabel.Text = "🎮 " .. info.Name end
    end)
end)

local ProfileFrame = Instance.new("Frame", TopFrame)
ProfileFrame.Size = UDim2.new(1, -20, 0, math.floor(65 * ScaleFactor))
ProfileFrame.Position = UDim2.new(0, 10, 0, 135)
ProfileFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
createCorner(ProfileFrame, math.floor(10 * ScaleFactor))

local ProfileImg = Instance.new("ImageLabel", ProfileFrame)
ProfileImg.Size = UDim2.new(0, math.floor(45 * ScaleFactor), 0, math.floor(45 * ScaleFactor))
ProfileImg.Position = UDim2.new(0, 10, 0, math.floor(10 * ScaleFactor))
ProfileImg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
createCorner(ProfileImg, math.floor(22 * ScaleFactor))
pcall(function() ProfileImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100) end)

local NameLabel = Instance.new("TextLabel", ProfileFrame)
NameLabel.Text = LocalPlayer.DisplayName or LocalPlayer.Name
NameLabel.Position = UDim2.new(0, math.floor(65 * ScaleFactor), 0, math.floor(12 * ScaleFactor))
NameLabel.Size = UDim2.new(0, math.floor(170 * ScaleFactor), 0, math.floor(20 * ScaleFactor))
NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.Font = Enum.Font.GothamBold
NameLabel.TextSize = math.floor(13 * ScaleFactor)
NameLabel.BackgroundTransparency = 1

local StatsLabel = Instance.new("TextLabel", ProfileFrame)
StatsLabel.Position = UDim2.new(0, math.floor(65 * ScaleFactor), 0, math.floor(32 * ScaleFactor))
StatsLabel.Size = UDim2.new(0, math.floor(170 * ScaleFactor), 0, math.floor(20 * ScaleFactor))
StatsLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.Font = Enum.Font.Code
StatsLabel.TextSize = math.floor(11 * ScaleFactor)
StatsLabel.BackgroundTransparency = 1

task.spawn(function()
    while task.wait(0.5) do
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local ping = 0
        pcall(function() ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        StatsLabel.Text = "FPS: " .. fps .. " | PING: " .. ping .. "ms"
    end
end)

-- KHUNG THEO DÕI (SPECTATE) - ĐÃ FIX LỖI GIAO DIỆN
local SpectateFrame = Instance.new("Frame", MainFrame)
SpectateFrame.Size = UDim2.new(1, -16, 0, 60) -- Tăng chiều cao để chứa Avatar
SpectateFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
SpectateFrame.Visible = false
SpectateFrame.Position = UDim2.new(0, 8, 0, 75)
createCorner(SpectateFrame, 8)

-- Avatar: Căn giữa theo chiều dọc của khung (0.5, -20)
local SpecAvatar = Instance.new("ImageLabel", SpectateFrame)
SpecAvatar.Size = UDim2.new(0, 40, 0, 40)
SpecAvatar.Position = UDim2.new(0, 10, 0.5, -20)
SpecAvatar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
createCorner(SpecAvatar, 20) -- Hình tròn

-- Tên: Căn giữa theo chiều dọc của khung
local SpecName = Instance.new("TextLabel", SpectateFrame)
SpecName.Size = UDim2.new(1, -120, 0, 40)
SpecName.Position = UDim2.new(0, 60, 0.5, -20) -- Căn cùng hàng với Avatar
SpecName.BackgroundTransparency = 1
SpecName.TextColor3 = Color3.new(1, 1, 1)
SpecName.Font = Enum.Font.GothamBold
SpecName.TextSize = 12
SpecName.TextXAlignment = Enum.TextXAlignment.Left
SpecName.TextYAlignment = Enum.TextYAlignment.Center -- Căn giữa dọc

-- Nút Back/Next: Căn giữa dọc khung
local BtnBack = Instance.new("TextButton", SpectateFrame)
BtnBack.Size = UDim2.new(0, 25, 0, 25)
BtnBack.Position = UDim2.new(1, -60, 0.5, -12) -- Căn phải khung
BtnBack.Text = "<"
BtnBack.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
BtnBack.TextColor3 = Color3.new(1, 1, 1)
createCorner(BtnBack, 4)

local BtnNext = Instance.new("TextButton", SpectateFrame)
BtnNext.Size = UDim2.new(0, 25, 0, 25)
BtnNext.Position = UDim2.new(1, -30, 0.5, -12)
BtnNext.Text = ">"
BtnNext.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
BtnNext.TextColor3 = Color3.new(1, 1, 1)
createCorner(BtnNext, 4)
BtnNext.MouseButton1Click:Connect(function()
    curSpecIndex = curSpecIndex + 1
    if curSpecIndex > #playersList then curSpecIndex = 1 end
    updateSpec()
end)

local GridScrollFrame = Instance.new("ScrollingFrame", MainFrame)
GridScrollFrame.Size = UDim2.new(1, -20, 1, math.floor(-290 * ScaleFactor))
GridScrollFrame.Position = UDim2.new(0, 10, 0, math.floor(235 * ScaleFactor))
GridScrollFrame.BackgroundTransparency = 1
GridScrollFrame.ScrollBarThickness = 4 
GridScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0) 

local Grid = Instance.new("UIGridLayout", GridScrollFrame)
Grid.CellSize = UDim2.new(0.5, -6, 0, math.floor(52 * ScaleFactor))
Grid.CellPadding = UDim2.new(0, 12, 0, 12)
Grid.SortOrder = Enum.SortOrder.LayoutOrder

Grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    GridScrollFrame.CanvasSize = UDim2.new(0, 0, 0, Grid.AbsoluteContentSize.Y + 20)
end)

local function createToggle(text, callback)
    local Btn = Instance.new("TextButton", GridScrollFrame)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Btn.Text = text .. "\n[TẮT]"
    Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = math.floor(11 * ScaleFactor)
    createCorner(Btn, 8)
    
    local isToggled = false
    Btn.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        if isToggled then
            Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            Btn.Text = text .. "\n[BẬT]"
            Btn.TextColor3 = Color3.new(1, 1, 1)
        else
            Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            Btn.Text = text .. "\n[TẮT]"
            Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        callback(isToggled)
    end)
    return function(extState) 
        isToggled = extState 
        if isToggled then 
            Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255) 
            Btn.Text = text .. "\n[BẬT]" 
            Btn.TextColor3 = Color3.new(1, 1, 1) 
        else 
            Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40) 
            Btn.Text = text .. "\n[TẮT]" 
            Btn.TextColor3 = Color3.fromRGB(180, 180, 180) 
        end 
    end
end

local function createSlider(text, minVal, maxVal, defaultVal, callback)
    local SliderBox = Instance.new("Frame", GridScrollFrame)
    SliderBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    createCorner(SliderBox, 8)
    
    local Title = Instance.new("TextLabel", SliderBox)
    Title.Size = UDim2.new(1, -10, 0, math.floor(20 * ScaleFactor))
    Title.Position = UDim2.new(0, 8, 0, 4)
    Title.BackgroundTransparency = 1
    Title.Text = text .. ": " .. defaultVal
    Title.TextColor3 = Color3.fromRGB(0, 220, 255)
    Title.Font = Enum.Font.GothamSemibold
    Title.TextSize = math.floor(10 * ScaleFactor)
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Track = Instance.new("TextButton", SliderBox)
    Track.Size = UDim2.new(1, -16, 0, math.floor(4 * ScaleFactor))
    Track.Position = UDim2.new(0, 8, 1, math.floor(-14 * ScaleFactor))
    Track.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Track.Text = ""
    Track.AutoButtonColor = false
    createCorner(Track, 2)

    local Fill = Instance.new("Frame", Track)
    Fill.Size = UDim2.new((defaultVal - minVal)/(maxVal - minVal), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    createCorner(Fill, 2)

    local Knob = Instance.new("Frame", Track)
    local kDim = math.floor(10 * ScaleFactor)
    Knob.Size = UDim2.new(0, kDim, 0, kDim)
    Knob.Position = UDim2.new((defaultVal - minVal)/(maxVal - minVal), -kDim/2, 0.5, -kDim/2)
    Knob.BackgroundColor3 = Color3.new(1, 1, 1)
    createCorner(Knob, kDim/2)

    local dragging = false
    local function updateSlider(inputX)
        local percentage = math.clamp((inputX - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local value = math.floor(minVal + (percentage * (maxVal - minVal)))
        Title.Text = text .. ": " .. value
        Fill.Size = UDim2.new(percentage, 0, 1, 0)
        Knob.Position = UDim2.new(percentage, -kDim/2, 0.5, -kDim/2)
        callback(value)
    end

    Track.InputBegan:Connect(function(input)
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
    Btn.TextSize = math.floor(11 * ScaleFactor)
    createCorner(Btn, 8)
    Btn.MouseButton1Click:Connect(callback)
end

local ButtonSize = math.floor(70 * ScaleFactor)
local ToggleBtn = Instance.new("ScreenGui"):FindFirstChild("ToggleBtn") or Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, ButtonSize, 0, ButtonSize)
ToggleBtn.Position = UDim2.new(0, 20, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
ToggleBtn.Text = "📜"
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.TextSize = math.floor(32 * ScaleFactor)
createCorner(ToggleBtn, ButtonSize / 2)
makeDraggable(ToggleBtn)
ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

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

local setFlyToggle = createToggle("Chế Độ Bay", function(state)
    Fly_Active = state
    if Fly_Active then StartFly() else StopFly() end
end)

createSlider("Tốc Độ Bay", 20, 300, FlySpeed, function(val) FlySpeed = val end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.E then
        Fly_Active = not Fly_Active
        setFlyToggle(Fly_Active)
        if Fly_Active then StartFly() else StopFly() end
    end
end)

-- 1. NÚT INF HP (BẤT TỬ MÁU CLIENT)
local InfHP_Active = false
createToggle("Vô Hạn Máu (Inf HP)", function(state)
    InfHP_Active = state
    if state then
        task.spawn(function()
            while InfHP_Active do
                task.wait()
                pcall(function()
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChildOfClass("Humanoid") then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        -- Giữ máu luôn ở mức tối đa trên giao diện của bạn
                        hum.Health = hum.MaxHealth
                    end
                end)
            end
        end)
    end
end)

-- 2. NÚT INF JUMP (NHẢY VÔ HẠN)
local InfJump_Active = false
local JumpConnection
createToggle("Nhảy Vô Hạn (Inf Jump)", function(state)
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

-- 3. NÚT TỰ LÙI KHI CHIẾN ĐẤU (HIT & RUN / KITE)
local AutoKite_Active = false
createToggle("Tự Lùi Khi Đánh", function(state)
    AutoKite_Active = state
end)

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
                name.TextColor3 = Color3.fromRGB(255, 255, 255)
                name.TextStrokeTransparency = 0
                name.BackgroundTransparency = 1
                name.Font = Enum.Font.GothamBold
                name.TextSize = 12
            end
        end
    end
end
createToggle("ESP Khung + Tên", function(state) ESP_Active = state updateESP() end)
Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function() task.wait(1) if ESP_Active then updateESP() end end) end)

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
createToggle("Chống Máy Châu Kick", function(state) AntiKick_Active = state end)

if IsMobile then
    local ShiftLock_Active = false
    createToggle("Khóa Tâm Mobile", function(state) 
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

createButton("✉️ Mời Bạn Bè Chơi", Color3.fromRGB(35, 140, 75), function()
    pcall(function() SocialService:PromptGameInvite(LocalPlayer) end)
end)

createToggle("Bật Khung Theo Dõi", function(state)
    SpectateFrame.Visible = state
    if state then updateSpec() else Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end
end)

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
createToggle("Chế Độ AI Bot", function(state) AI_Active = state end)

createButton("🔗 Copy Link Game", Color3.fromRGB(80, 50, 150), function()
    if setclipboard then setclipboard("https://www.roblox.com/games/" .. game.PlaceId) end
end)

local Spin_Active = false
RunService.RenderStepped:Connect(function()
    if Spin_Active and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(45), 0)
    end
end)
createToggle("Xoay Tròn (Spin)", function(state) Spin_Active = state end)

local AutoObby_Active = false
createToggle("Auto Obby (Tự Chơi)", function(state)
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

local AutoFarm_Active = false
createToggle("Auto Farm / Attack", function(state)
    AutoFarm_Active = state
    task.spawn(function()
        while AutoFarm_Active do
            task.wait(0.1)
            pcall(function()
                local target = nil
                local maxDist = 200
                
                -- Tìm kiếm đối thủ gần nhất còn sống
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                        local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if dist < maxDist then target = p.Character maxDist = dist end
                    end
                end
                
                -- Thực hiện di chuyển và tấn công
                if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local HRP = LocalPlayer.Character.HumanoidRootPart
                    
                    if AutoKite_Active then
                        -- Nếu bật Tự Lùi: Giật lùi ra sau lưng đối thủ 6 studs để né chiêu
                        HRP.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 6)
                        task.wait(0.05) -- Khựng lại một nhịp rất ngắn rồi lại lao vào
                    else
                        -- Nếu tắt Tự Lùi: Áp sát mượt mà sau lưng đối thủ 3 studs như cũ
                        HRP.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    end
                    
                    -- Tự động lấy vũ khí ra chém
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

local GhostHit_Active = false
createToggle("Ghost Hit (Sửa Lỗi)", function(state) 
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

local Noclip_Active = false
RunService.Stepped:Connect(function()
    if (Noclip_Active or Fly_Active) and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)
createToggle("Xuyên Tường", function(state) Noclip_Active = state end)

local AFK_Active = false
LocalPlayer.Idled:Connect(function() if AFK_Active then VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame) task.wait(1) VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame) end end)
createToggle("Treo Máy (Anti-AFK)", function(state) AFK_Active = state end)

local JumpPower = 50
createSlider("Chỉnh Lực Nhảy", 50, 300, JumpPower, function(val)
    JumpPower = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower = val end
end)

local Speed_Val = 16
createSlider("Chỉnh Tốc Độ", 16, 150, Speed_Val, function(val)
    Speed_Val = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = val end
end)

createButton("Mở Infinite Yield", Color3.fromRGB(150, 50, 50), function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

createButton("Chuyển Server Khác", Color3.fromRGB(0, 150, 100), function()
    if syn and syn.queue_on_teleport then syn.queue_on_teleport([[loadstring(game:HttpGet("https://raw.githubusercontent.com/3hbin/Gemini-Hub/refs/heads/main/GeminiHub.lua"))()]])
    elseif queue_on_teleport then queue_on_teleport([[loadstring(game:HttpGet("https://raw.githubusercontent.com/3hbin/Gemini-Hub/refs/heads/main/GeminiHub.lua"))()]]) end
    local TPS = game:GetService("TeleportService")
    local api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"
    local data = game:GetService("HttpService"):JSONDecode(game:HttpGet(api))
    for _, v in pairs(data.data) do
        if v.playing < v.maxPlayers and v.id ~= game.JobId then TPS:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer) break end
    end
end)

local CloseBtn = Instance.new("TextButton", MainFram)
CloseBtn.Size = UDim2.new(1, -20, 0, math.floor(35 * ScaleFactor))
CloseBtn.Position = UDim2.new(0, 10, 1, math.floor(-45 * ScaleFactor))
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = math.floor(12 * ScaleFactor)
CloseBtn.Text = "Ẩn Bảng Menu"
createCorner(CloseBtn, 8)
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)
