-- ====================================================================
-- HỆ THỐNG LIÊN KẾT SERVER KEY PASTEBIN TRỰC TUYẾN
-- ====================================================================

-- 🔴 HÃY THAY LINK RAW PASTEBIN CỦA BẠN VÀO DƯỚI ĐÂY 🔴
local ServerKeyLink = "https://pastebin.com" 

-- Gửi yêu cầu lên hệ thống để tải Key mới nhất về bộ nhớ đệm
local successFetch, ServerKey = pcall(function()
    return game:HttpGet(ServerKeyLink)
end)

-- Xử lý chuỗi dữ liệu (Xóa khoảng trắng/xuống dòng thừa từ Server)
if successFetch and ServerKey then
    ServerKey = string.gsub(ServerKey, "%s+", "")
else
    ServerKey = "MÁY_CHỦ_BẢO_TRÌ" -- Chặn đăng nhập nếu link Pastebin bị xóa hoặc lỗi mạng
end

-- Khởi chạy giao diện cổng xác thực Key trực tuyến
local Library = loadstring(game:HttpGet("https://githubusercontent.com"))()
local KeyWindow = Library.CreateLib("🌐 XÁC THỰC SERVER KEY ONLINE 🌐", "Midnight")
local KeyTab = KeyWindow:NewTab("Cổng Vào")
local KeySec = KeyTab:NewSection("Kết Nối Dữ Liệu Trực Tuyến")

KeySec:NewTextBox("Nhập Key Hiện Tại:", "Dán mã Key lấy từ máy chủ vào đây", function(text)
    local userInput = string.gsub(text, "%s+", "") -- Xóa khoảng trắng người dùng nhập lỗi
    
    -- Đối chiếu trực tiếp mã nhập vào với mã tải từ Pastebin về
    if userInput == ServerKey and ServerKey ~= "MÁY_CHỦ_BẢO_TRÌ" then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Thành Công!",
            Text = "Key chính xác! Đang kết nối vào Menu...",
            Duration = 3
        })
        
        -- Xóa bảng nhập Key
        pcall(function()
            game:GetService("CoreGui"):FindFirstChild("🌐 XÁC THỰC SERVER KEY ONLINE 🔑" or "🌐 XÁC THỰC SERVER KEY ONLINE 🌐"):Destroy()
        end)
        
        -- ====================================================================
        -- TOÀN BỘ MENU TÍNH NĂNG 5-IN-1 CHỐNG LAG / CHỐNG VĂNG GAME
        -- ====================================================================
        local Window = Library.CreateLib("🔥 MENU VIP SIÊU CẤP ĐA GAME (ANTI-LAG) 🔥", "Midnight")
        local currentPlaceId = game.PlaceId

        local function createESP(object, name, color)
            pcall(function()
                if not object:FindFirstChild("VipHighlight") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "VipHighlight"
                    hl.FillColor = color
                    hl.FillTransparency = 0.4
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.OutlineTransparency = 0.1
                    hl.Parent = object
                    
                    local bbg = Instance.new("BillboardGui", object)bbg.Name = "VipLabel"
                    bbg.AlwaysOnTop = true
                    bbg.Size = UDim2.new(0, 100, 0, 30)
                    bbg.StudsOffset = Vector3.new(0, 3, 0)
                    
                    local tl = Instance.new("TextLabel", bbg)
                    tl.Size = UDim2.new(1, 0, 1, 0)
                    tl.BackgroundTransparency = 1
                    tl.Text = name
                    tl.TextColor3 = color
                    tl.TextSize = 14
                    tl.TextStrokeTransparency = 0
                end
            end)
        end

        local GeneralTab = Window:NewTab("Tiện Ích Chung")
        local GenSec = GeneralTab:NewSection("Hỗ Trợ Di Chuyển & Tầm Nhìn")

        GenSec:NewToggle("Bật/Tắt Chạy Nhanh (Speed 100)", "Bật tăng tốc tối đa, tắt về bình thường", function(state)
            pcall(function()
                local player = game.Players.LocalPlayer
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.WalkSpeed = state and 100 or 16
                end
            end)
        end)

        GenSec:NewSlider("Tự Chỉnh Tốc Độ Chạy", "Kéo thanh để chỉnh vận tốc tùy ý", 150, 16, function(s)
            pcall(function()
                local player = game.Players.LocalPlayer
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.WalkSpeed = s
                end
            end)
        end)

        GenSec:NewSlider("Khoảng Cách Cam Xa", "Kéo xa góc nhìn để bao quát bản đồ", 500, 70, function(v)
            game.Players.LocalPlayer.CameraMaxZoomDistance = v
        end)

        local TeleSec = GeneralTab:NewSection("Dịch Chuyển An Toàn")

        local function getPlayerNames()
            local names = {}
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= game.Players.LocalPlayer then table.insert(names, p.Name) end
            end
            return names
        end

        local PlayerDropdown = TeleSec:NewDropdown("Chọn Người Chơi", "Chọn một người để dịch chuyển", getPlayerNames(), function(selectedPlayerName)
            pcall(function()
                local targetPlayer = game.Players:FindFirstChild(selectedPlayerName)
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local localRoot = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if localRoot then localRoot.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0) end
                end
            end)
        end)

        TeleSec:NewButton("🔄 Làm Mới Danh Sách", "Cập nhật lại danh sách", function()PlayerDropdown:Refresh(getPlayerNames())
        end)

        -- PHÂN PHỐI GAME THEO ID TRỰC TUYẾN
        if currentPlaceId == 6516141723 or game.GameId == 2439162985 then 
            local Tab = Window:NewTab("🚪 DOORS ADVANCED")
            local Sec = Tab:NewSection("Phân Tích Thực Thể & Vật Phẩm")
            _G.DoorsESP = false
            Sec:NewToggle("Bật ESP Phân Loại", "Hiển thị thực thể và đồ quý giá", function(state)
                _G.DoorsESP = state
                task.spawn(function()
                    while _G.DoorsESP do
                        pcall(function()
                            for _, obj in pairs(workspace:GetChildren()) do
                                if obj.Name == "RushMoving" or obj.Name == "AmbushMoving" then createESP(obj, "⚠️ " .. obj.Name, Color3.fromRGB(255, 0, 0))
                                elseif obj:FindFirstChild("Humanoid") and obj.Name == "Seek" then createESP(obj, "👁️ SEEK", Color3.fromRGB(139, 0, 0)) end
                            end
                            local currentRooms = workspace:FindFirstChild("CurrentRooms")
                            if currentRooms then
                                for _, room in pairs(currentRooms:GetChildren()) do
                                    for _, asset in pairs(room:GetDescendants()) do
                                        if asset.Name == "Key" then createESP(asset, "🔑 Chìa Khóa", Color3.fromRGB(255, 215, 0))
                                        elseif asset.Name == "Gold" then createESP(asset, "💰 Vàng/Tiền", Color3.fromRGB(0, 255, 0))
                                        elseif asset.Name == "Lighter" or asset.Name == "Flashlight" then createESP(asset, "🔦 Đồ Sáng", Color3.fromRGB(0, 255, 255)) end
                                    end
                                end
                            end
                        end)
                        task.wait(2.5)
                    end
                end)
            end)

        elseif currentPlaceId == 116495829188952 or string.find(string.lower(game:GetService("MarketplaceService"):GetProductInfo(currentPlaceId).Name), "dead rails") then
            local Tab = Window:NewTab("🚂 DEAD RAILS ADVANCED")
            local Sec = Tab:NewSection("Quét Sinh Tồn")
            _G.DeadRailsESP = false
            Sec:NewToggle("ESP Người - Zombie - Vật Phẩm", "Phân biệt rõ ràng các mục tiêu", function(state)
                _G.DeadRailsESP = state
                task.spawn(function()
                    while _G.DeadRailsESP do
                        pcall(function()
                            for _, obj in pairs(workspace:GetChildren()) do
                                if obj:FindFirstChild("Humanoid") then
                                    if game.Players:GetPlayerFromCharacter(obj) thenif obj.Name ~= game.Players.LocalPlayer.Name then createESP(obj, "👤 Người Chơi", Color3.fromRGB(0, 255, 255)) end
                                    else createESP(obj, "🧟 Zombie", Color3.fromRGB(255, 0, 0)) end
                                end
                            end
                            for _, obj in pairs(workspace:GetDescendants()) do
                                if string.find(string.lower(obj.Name), "scrap") or string.find(string.lower(obj.Name), "supply") then createESP(obj, "📦 Vật Phẩm Quý", Color3.fromRGB(255, 165, 0))
                                elseif string.find(string.lower(obj.Name), "cash") or string.find(string.lower(obj.Name), "safe") then createESP(obj, "💵 Tiền/Két Sắt", Color3.fromRGB(0, 255, 0)) end
                            end
                        end)
                        task.wait(3.5)
                    end
                end)
            end)

        elseif currentPlaceId == 139360679647453 or string.find(string.lower(game:GetService("MarketplaceService"):GetProductInfo(currentPlaceId).Name), "lori") then
            local Tab = Window:NewTab("👁️ ÁC MỘNG LORI")
            local Sec = Tab:NewSection("Dữ Liệu Bản Đồ")
            Sec:NewButton("Xóa Sương Mù (Clear Vision)", "Tối ưu tầm nhìn toàn bản đồ", function()
                pcall(function() game:GetService("Lighting").FogEnd = 999999 game:GetService("Lighting").FogStart = 999999 end)
            end)
