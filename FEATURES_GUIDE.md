# 🎮 GeminiHub - Hướng Dẫn Tính Năng Mới

## 1️⃣ **TÍNH NĂNG: Tàng Hình & Ẩn Tên (Ghost Mode)**

### 📝 Mô tả
Làm nhân vật của bạn tàng hình (mờ 80%) và ẩn tên hiển thị, sau đó khôi phục khi tắt.

### 💻 Code

```lua
-- GHOST MODE - Tàng Hình & Ẩn Tên
local GhostMode_Active = false
local originalTransparency = {} -- Lưu giá trị transparency gốc

local function toggleGhostMode(state)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then 
        return 
    end
    
    local char = LocalPlayer.Character
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    
    if state then
        -- BẬT - Làm mờ nhân vật
        pcall(function()
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    -- Lưu transparency gốc
                    if not originalTransparency[part] then
                        originalTransparency[part] = part.Transparency
                    end
                    -- HumanoidRootPart hoàn toàn ẩn
                    if part.Name == "HumanoidRootPart" then
                        part.Transparency = 1
                    else
                        part.Transparency = 0.8 -- Mờ 80%
                    end
                elseif part:IsA("Decal") then
                    if not originalTransparency[part] then
                        originalTransparency[part] = part.Transparency
                    end
                    part.Transparency = 0.8
                end
            end
            
            -- Ẩn tên nhân vật
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        end)
    else
        -- TẮT - Khôi phục trạng thái cũ
        pcall(function()
            for part, oldTransparency in pairs(originalTransparency) do
                if part and part.Parent then
                    part.Transparency = oldTransparency
                end
            end
            originalTransparency = {} -- Reset
            
            -- Hiển thị lại tên
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Nameplate
        end)
    end
end

-- Gắn vào UI Toggle
createToggle("👻 Ghost Mode", function(state)
    GhostMode_Active = state
    toggleGhostMode(GhostMode_Active)
end)
```

### 🔍 Giải thích
- `GetDescendants()`: Lấy tất cả đối tượng con của nhân vật
- `originalTransparency`: Dictionary lưu giá trị cũ để khôi phục
- `HumanoidRootPart.Transparency = 1`: Ẩn hoàn toàn part vô hình
- `DisplayDistanceType.None`: Ẩn nameplate (tên) của nhân vật

---

## 2️⃣ **TÍNH NĂNG: Small Server & Auto-Reboot**

### 📝 Mô tả
Tìm server có ít người nhất, dịch chuyển qua đó và tự động khởi chạy lại script.

### 💻 Code

```lua
-- SMALL SERVER & AUTO REBOOT
local function findAndTeleportSmallServer()
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    
    -- Gửi request lấy danh sách server
    local success, rawData = pcall(function()
        local api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"
        return game:HttpGet(api)
    end)
    
    if not success then
        print("❌ Lỗi kết nối API: " .. tostring(rawData))
        return
    end
    
    local data = pcall(function() return HttpService:JSONDecode(rawData) end)
    if not data then
        print("❌ Lỗi decode JSON")
        return
    end
    
    -- Lọc server
    local servers = {}
    pcall(function()
        for _, server in pairs(rawData.data or {}) do
            if server.id ~= game.JobId and server.playing < server.maxPlayers then
                table.insert(servers, server)
            end
        end
    end)
    
    if #servers == 0 then
        print("❌ Không tìm thấy server nào")
        return
    end
    
    -- Sắp xếp - server ít người nhất lên đầu
    table.sort(servers, function(a, b) return a.playing < b.playing end)
    local targetServer = servers[1]
    
    print("✅ Tìm thấy server nhỏ: " .. targetServer.playing .. "/" .. targetServer.maxPlayers)
    
    -- Queue script để khởi động lại
    local scriptUrl = "https://raw.githubusercontent.com/3hbin/Gemini-Hub/refs/heads/main/GeminiHub.lua"
    if syn and syn.queue_on_teleport then
        syn.queue_on_teleport('loadstring(game:HttpGet("' .. scriptUrl .. '"))()')
    elseif queue_on_teleport then
        queue_on_teleport('loadstring(game:HttpGet("' .. scriptUrl .. '"))()')
    end
    
    -- Dịch chuyển
    print("🚀 Dịch chuyển đến server...")
    TeleportService:TeleportToPlaceInstance(game.PlaceId, targetServer.id, LocalPlayer)
end

-- Gắn vào nút bấm
createButton("🌐 Small Server", Color3.fromRGB(0, 150, 200), function()
    findAndTeleportSmallServer()
end)
```

### 🔍 Giải thích
- `game:HttpGet()`: Lấy dữ liệu từ API Roblox
- `JSONDecode()`: Chuyển JSON string thành table Lua
- `table.sort()`: Sắp xếp server theo số lượng người chơi
- `queue_on_teleport()`: Chạy script tự động sau khi dịch chuyển
- `TeleportToPlaceInstance()`: Dịch chuyển đến server cụ thể

---

## 3️⃣ **TÍNH NĂNG: Thay Đổi Áo Avatar Bằng ID**

### 📝 Mô tả
Thay đổi áo của nhân vật bằng cách nhập ID từ Roblox Catalog.

### 💻 Code

```lua
-- SHIRT CHANGER - Thay đổi áo bằng ID
local function changeShirt(shirtId)
    if not LocalPlayer.Character then
        print("❌ Nhân vật chưa load")
        return false
    end
    
    pcall(function()
        local char = LocalPlayer.Character
        local shirt = char:FindFirstChild("Shirt")
        
        -- Nếu không có áo, tạo mới
        if not shirt then
            shirt = Instance.new("Shirt")
            shirt.Parent = char
        end
        
        -- Thay đổi template áo
        shirt.ShirtTemplate = "rbxassetid://" .. tostring(shirtId)
        print("✅ Áo thay đổi thành: rbxassetid://" .. shirtId)
        return true
    end)
    
    return false
end

-- ĐỀ XUẤT: Tạo UI input để người chơi nhập ID
local function createShirtChangerUI()
    -- Tạo một ScreenGui đơn giản với TextBox để nhập ID
    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.Name = "ShirtChanger"
    gui.ResetOnSpawn = false
    
    local inputBox = Instance.new("TextBox", gui)
    inputBox.Size = UDim2.new(0, 300, 0, 50)
    inputBox.Position = UDim2.new(0.5, -150, 0.5, -100)
    inputBox.PlaceholderText = "Nhập ID áo (chỉ số)"
    inputBox.TextColor3 = Color3.new(1, 1, 1)
    inputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    inputBox.Font = Enum.Font.Code
    inputBox.TextSize = 14
    
    local changeBtn = Instance.new("TextButton", gui)
    changeBtn.Size = UDim2.new(0, 300, 0, 40)
    changeBtn.Position = UDim2.new(0.5, -150, 0.5, -30)
    changeBtn.Text = "👕 Thay Áo"
    changeBtn.TextColor3 = Color3.new(1, 1, 1)
    changeBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    changeBtn.Font = Enum.Font.GothamBold
    changeBtn.TextSize = 14
    
    changeBtn.MouseButton1Click:Connect(function()
        local shirtId = tonumber(inputBox.Text)
        if shirtId then
            changeShirt(shirtId)
        else
            print("❌ ID không hợp lệ")
        end
    end)
end

-- Gắn vào nút bấm trên menu
createButton("👕 Thay Áo", Color3.fromRGB(100, 70, 150), function()
    createShirtChangerUI()
end)

-- Hoặc dùng trực tiếp:
-- changeShirt(12345) -- Thay áo bằng ID 12345
```

### 🔍 Giải thích
- `FindFirstChild("Shirt")`: Tìm áo hiện tại
- `Instance.new("Shirt")`: Tạo áo mới nếu chưa có
- `ShirtTemplate`: Template của áo, format: `rbxassetid://` + ID
- `tonumber()`: Chuyển string thành số để kiểm tra hợp lệ
- `TextBox`: Input field để người chơi nhập ID

---

## 📦 Cách Integrate Vào GeminiHub

Thêm 3 dòng này vào **phần tính năng trong GeminiHub.lua** (sau line 659):

```lua
-- Thêm Ghost Mode
createToggle("👻 Ghost Mode", function(state)
    GhostMode_Active = state
    toggleGhostMode(GhostMode_Active)
end)

-- Thêm Small Server
createButton("🌐 Small Server", Color3.fromRGB(0, 150, 200), function()
    findAndTeleportSmallServer()
end)

-- Thêm Shirt Changer
createButton("👕 Thay Áo", Color3.fromRGB(100, 70, 150), function()
    createShirtChangerUI()
end)
```

---

## 🚀 Lưu Ý Quan Trọng

| Tính Năng | Yêu Cầu | Chú Ý |
|-----------|---------|--------|
| **Ghost Mode** | LocalScript | Cần khi nhân vật load xong |
| **Small Server** | Executor với `queue_on_teleport` | Cần internet ổn định |
| **Shirt Changer** | ID áo từ Roblox Catalog | Phải là số, không phải tên |

---

**Made with ❤️ by GeminiHub Team**
