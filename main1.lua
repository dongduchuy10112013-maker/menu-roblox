
-- ====================================================================
-- Há»† THá»NG LIÃŠN Káº¾T SERVER KEY PASTEBIN TRá»°C TUYáº¾N
-- ====================================================================
local ServerKeyLink = "https://pastebin.com" -- Thay link RAW Pastebin cá»§a báº¡n vÃ o Ä‘Ã¢y

local successFetch, ServerKey = pcall(function()
    return game:HttpGet(ServerKeyLink)
end)

if successFetch and ServerKey then
    ServerKey = string.gsub(ServerKey, "%s+", "")
else
    ServerKey = "MÃY_CHá»¦_Báº¢O_TRÃŒ"
end

local Library = loadstring(game:HttpGet("https://githubusercontent.com"))()
local KeyWindow = Library.CreateLib("ðŸŒ XÃC THá»°C SERVER KEY ONLINE ðŸŒ", "Midnight")
local KeyTab = KeyWindow:NewTab("Cá»•ng VÃ o")
local KeySec = KeyTab:NewSection("Káº¿t Ná»‘i Dá»¯ Liá»‡u Trá»±c Tuyáº¿n")

KeySec:NewTextBox("Nháº­p Key Hiá»‡n Táº¡i:", "DÃ¡n mÃ£ Key láº¥y tá»« mÃ¡y chá»§ vÃ o Ä‘Ã¢y", function(text)
    local userInput = string.gsub(text, "%s+", "")
    
    if userInput == ServerKey and ServerKey ~= "MÃY_CHá»¦_Báº¢O_TRÃŒ" then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "ThÃ nh CÃ´ng!",
            Text = "Key chÃ­nh xÃ¡c! Äang káº¿t ná»‘i vÃ o Menu...",
            Duration = 3
        })
        
        pcall(function()
            if game:GetService("CoreGui"):FindFirstChild("ðŸŒ XÃC THá»°C SERVER KEY ONLINE ðŸŒ") then
                game:GetService("CoreGui"):FindFirstChild("ðŸŒ XÃC THá»°C SERVER KEY ONLINE ðŸŒ"):Destroy()
            end
        end)
        
        -- ====================================================================
        -- TOÃ€N Bá»˜ MENU TÃNH NÄ‚NG 5-IN-1 CHá»NG LAG / CHá»NG VÄ‚NG GAME
        -- ====================================================================
        local Window = Library.CreateLib("ðŸ”¥ MENU VIP SIÃŠU Cáº¤P ÄA GAME (ANTI-LAG) ðŸ”¥", "Midnight")
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
                    
                    local bbg = Instance.new("BillboardGui", object)
                    bbg.Name = "VipLabel"
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

        local GeneralTab = Window:NewTab("Tiá»‡n Ãch Chung")
        local GenSec = GeneralTab:NewSection("Há»— Trá»£ Di Chuyá»ƒn & Táº§m NhÃ¬n")

        GenSec:NewToggle("Báº­t/Táº¯t Cháº¡y Nhanh (Speed 100)", "Báº­t tÄƒng tá»‘c tá»‘i Ä‘a, táº¯t vá» bÃ¬nh thÆ°á»ng", function(state)
            pcall(function()
                local player = game.Players.LocalPlayer
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.WalkSpeed = state and 100 or 16
                end
            end)
        end)

        GenSec:NewSlider("Tá»± Chá»‰nh Tá»‘c Äá»™ Cháº¡y", "KÃ©o thanh Ä‘á»ƒ chá»‰nh váº­n tá»‘c tÃ¹y Ã½", 150, 16, function(s)
            pcall(function()
                local player = game.Players.LocalPlayer
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.WalkSpeed = s
                end
            end)
        end)

        GenSec:NewSlider("Khoáº£ng CÃ¡ch Cam Xa", "KÃ©o xa gÃ³c nhÃ¬n Ä‘á»ƒ bao quÃ¡t báº£n Ä‘á»“", 500, 70, function(v)
            game.Players.LocalPlayer.CameraMaxZoomDistance = v
        end)

        local TeleSec = GeneralTab:NewSection("Dá»‹ch Chuyá»ƒn An ToÃ n")

        local function getPlayerNames()
            local names = {}
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= game.Players.LocalPlayer then table.insert(names, p.Name) end
            end
            return names
        end

        local PlayerDropdown = TeleSec:NewDropdown("Chá»n NgÆ°á»i ChÆ¡i", "Chá»n má»™t ngÆ°á»i Ä‘á»ƒ dá»‹ch chuyá»ƒn", getPlayerNames(), function(selectedPlayerName)
            pcall(function()
                local targetPlayer = game.Players:FindFirstChild(selectedPlayerName)
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local localRoot = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if localRoot then localRoot.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0) end
                end
            end)
        end)

        TeleSec:NewButton("ðŸ”„ LÃ m Má»›i Danh SÃ¡ch", "Cáº­p nháº­t láº¡i danh sÃ¡ch", function()
            PlayerDropdown:Refresh(getPlayerNames())
        end)

        -- PHÃ‚N PHá»I GAME THEO ID TRá»°C TUYáº¾N
        if currentPlaceId == 6516141723 or game.GameId == 2439162985 then 
            local Tab = Window:NewTab("ðŸšª DOORS ADVANCED")
            local Sec = Tab:NewSection("PhÃ¢n TÃ­ch Thá»±c Thá»ƒ & Váº­t Pháº©m")
            _G.DoorsESP = false
            Sec:NewToggle("Báº­t ESP PhÃ¢n Loáº¡i", "Hiá»ƒn thá»‹ thá»±c thá»ƒ vÃ  Ä‘á»“ quÃ½ giÃ¡", function(state)
                _G.DoorsESP = state
                task.spawn(function()
                    while _G.DoorsESP do
                        pcall(function()
                            for _, obj in pairs(workspace:GetChildren()) do
                                if obj.Name == "RushMoving" or obj.Name == "AmbushMoving" then createESP(obj, "âš ï¸ " .. obj.Name, Color3.fromRGB(255, 0, 0))
                                elseif obj:FindFirstChild("Humanoid") and obj.Name == "Seek" then createESP(obj, "ðŸ‘ï¸ SEEK", Color3.fromRGB(139, 0, 0)) end
                            end
                            local currentRooms = workspace:FindFirstChild("CurrentRooms")
                            if currentRooms then
                                for _, room in pairs(currentRooms:GetChildren()) do
                                    for _, asset in pairs(room:GetDescendants()) do
                                        if asset.Name == "Key" then createESP(asset, "ðŸ”‘ ChÃ¬a KhÃ³a", Color3.fromRGB(255, 215, 0))
                                        elseif asset.Name == "Gold" then createESP(asset, "ðŸ’° VÃ ng/Tiá»n", Color3.fromRGB(0, 255, 0))
                                        elseif asset.Name == "Lighter" or asset.Name == "Flashlight" then createESP(asset, "ðŸ”¦ Äá»“ SÃ¡ng", Color3.fromRGB(0, 255, 255)) end
                                    end
                                end
                            end
                        end)
                        task.wait(2.5)
                    end
                end)
            end)

        elseif currentPlaceId == 116495829188952 or string.find(string.lower(game:GetService("MarketplaceService"):GetProductInfo(currentPlaceId).Name), "dead rails") then
            local Tab = Window:NewTab("ðŸš‚ DEAD RAILS ADVANCED")
            local Sec = Tab:NewSection("QuÃ©t Sinh Tá»“n")
            _G.DeadRailsESP = false
            Sec:NewToggle("ESP NgÆ°á»i - Zombie - Váº­t Pháº©m", "PhÃ¢n biá»‡t rÃµ rÃ ng cÃ¡c má»¥c tiÃªu", function(state)
                _G.DeadRailsESP = state
                task.spawn(function()
                    while _G.DeadRailsESP do
                        pcall(function()
                            for _, obj in pairs(workspace:GetChildren()) do
                                if obj:FindFirstChild("Humanoid") then
                                    if game.Players:GetPlayerFromCharacter(obj) then
                                        if obj.Name ~= game.Players.LocalPlayer.Name then createESP(obj, "ðŸ‘¤ NgÆ°á»i ChÆ¡i", Color3.fromRGB(0, 255, 255)) end
                                    else createESP(obj, "ðŸ§Ÿ Zombie", Color3.fromRGB(255, 0, 0)) end
                                end
                            end
                            for _, obj in pairs(workspace:GetDescendants()) do
                                if string.find(string.lower(obj.Name), "scrap") or string.find(string.lower(obj.Name), "supply") then 
                                    createESP(obj, "ðŸ“¦ Váº­t Pháº©m QuÃ½", Color3.fromRGB(255, 165, 0))
                                elseif string.find(string.lower(obj.Name), "cash") or string.find(string.lower(obj.Name), "safe") then 
                                    createESP(obj, "ðŸ’µ Tiá»n/KÃ©t Sáº¯t", Color3.fromRGB(0, 255, 0)) 
                                end
                            end
                        end)
                        task.wait(3.5)
                    end
                end)
            end)

        elseif currentPlaceId == 139360679647453 or string.find(string.lower(game:GetService("MarketplaceService"):GetProductInfo(currentPlaceId).Name), "lori") then
            local Tab = Window:NewTab("ðŸ‘ï¸ ÃC Má»˜NG LORI")
            local Sec = Tab:NewSection("Dá»¯ Liá»‡u Báº£n Äá»“")
            Sec:NewButton("XÃ³a SÆ°Æ¡ng MÃ¹ (Clear Vision)", "Tá»‘i Æ°u táº§m nhÃ¬n toÃ n báº£n 
