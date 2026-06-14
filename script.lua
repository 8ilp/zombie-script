--[[
    8ilp ALL-IN-ONE PROTECTION SYSTEM
    Architect Engine 2099
    ارفع هذا الملف فقط على GitHub
    الاستدعاء: loadstring(game:HttpGet("URL"))()
--]]

-- ============================================
-- 🔐 CRYPTO ENGINE
-- ============================================
local function xor_encrypt(data, key)
    local r = ""
    for i = 1, #data do
        local d = string.byte(data, i)
        local k = string.byte(key, ((i-1) % #key) + 1)
        r = r .. string.char(bit32.bxor(d, k))
    end
    return r
end

local function b64_encode(data)
    local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local result = {}
    for i = 1, #data, 3 do
        local a, b, c = string.byte(data, i, i+2)
        b, c = b or 0, c or 0
        local n = a * 65536 + b * 256 + c
        table.insert(result, string.sub(chars, math.floor(n/262144)%64+1, math.floor(n/262144)%64+1))
        table.insert(result, string.sub(chars, math.floor(n/4096)%64+1, math.floor(n/4096)%64+1))
        table.insert(result, string.sub(chars, math.floor(n/64)%64+1, math.floor(n/64)%64+1))
        table.insert(result, string.sub(chars, n%64+1, n%64+1))
    end
    if #data % 3 == 1 then result[#result-1], result[#result] = "=", "="
    elseif #data % 3 == 2 then result[#result] = "=" end
    return table.concat(result)
end

local function b64_decode(data)
    local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..chars..'=]', '')
    local result = {}
    for i = 1, #data, 4 do
        local a, b, c, d = string.byte(data, i, i+3)
        a = (string.find(chars, string.char(a))-1) or 0
        b = (string.find(chars, string.char(b))-1) or 0
        c = (string.find(chars, string.char(c))-1) or 0
        d = (string.find(chars, string.char(d))-1) or 0
        local n = a * 262144 + b * 4096 + c * 64 + d
        table.insert(result, string.char(math.floor(n/65536)))
        if c ~= 0 then table.insert(result, string.char(math.floor((n%65536)/256))) end
        if d ~= 0 then table.insert(result, string.char(n%256)) end
    end
    return table.concat(result)
end

-- ============================================
-- 🛡️ ANTI-TAMPER
-- ============================================
local function anti_debug()
    if getgenv().detected then return false end
    local bad = {"dex", "dump", "inject", "hookfunction", "getsenv", "hookmetamethod"}
    for _, s in ipairs(bad) do
        if getgenv()[s] then
            getgenv().detected = true
            return false
        end
    end
    return true
end

-- ============================================
-- 🧩 MAIN FRAMEWORK
-- ============================================
local Framework = {}
local Services = setmetatable({}, {__index = function(t, k) local s = game:GetService(k); t[k] = s; return s end})
local Player = Services.Players.LocalPlayer

function Framework:CreateGUI(title)
    local sg = Instance.new("ScreenGui")
    sg.Parent = Services.CoreGui
    sg.ResetOnSpawn = false
    local mf = Instance.new("Frame")
    mf.Size = UDim2.new(0, 550, 0, 380)
    mf.Position = UDim2.new(0.5, -275, 0.5, -190)
    mf.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mf.BorderSizePixel = 0
    mf.Parent = sg
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 0, 30)
    bar.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    bar.BorderSizePixel = 0
    bar.Parent = mf
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -30, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Text = title or "8ilp HUB"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.Parent = bar
    return sg, mf
end

function Framework:CreateButton(parent, text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 32)
    btn.Position = UDim2.new(0, 10, 0, y or 40)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.Parent = parent
    btn.MouseButton1Click:Connect(callback)
    return btn
end

function Framework:ESP(target, color)
    local h = Instance.new("Highlight")
    h.Parent = target
    h.FillColor = color or Color3.fromRGB(255, 50, 50)
    h.FillTransparency = 0.4
    h.OutlineColor = Color3.fromRGB(255, 255, 255)
    h.OutlineTransparency = 0
    h.Enabled = true
    return h
end

function Framework:PlayerESP()
    for _, plr in pairs(Services.Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            self:ESP(plr.Character)
        end
    end
    Services.Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(function(c)
            task.wait(0.5)
            self:ESP(c)
        end)
    end)
end

function Framework:AutoFarm(range)
    range = range or 100
    task.spawn(function()
        while task.wait(0.1) do
            local char = Player.Character
            if not char then continue end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end
            for _, obj in ipairs(Services.Workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                    if obj.Humanoid.Health > 0 and (obj.HumanoidRootPart.Position - hrp.Position).Magnitude <= range then
                        hrp.CFrame = obj.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2.5)
                        task.wait(0.2)
                    end
                end
            end
        end
    end)
end

function Framework:Teleport(pos)
    local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = typeof(pos) == "Vector3" and CFrame.new(pos) or pos
    end
end

function Framework:SpeedHack(speed)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = speed
    end
end

function Framework:JumpPower(power)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.JumpPower = power
    end
end

function Framework:Fly(speed)
    speed = speed or 60
    local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local bg = Instance.new("BodyGyro")
    bg.P = 9e4
    bg.Parent = hrp
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Parent = hrp
    local conn
    conn = Services.RunService.RenderStepped:Connect(function()
        if bg and bv and Player.Character then
            bg.CFrame = workspace.CurrentCamera.CFrame
            bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * speed
        else
            conn:Disconnect()
            bg:Destroy()
            bv:Destroy()
        end
    end)
end

function Framework:Noclip(state)
    if state then
        Services.RunService.Stepped:Connect(function()
            if Player.Character then
                for _, v in ipairs(Player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end
end

function Framework:Notify(text, dur)
    local sg = Instance.new("ScreenGui")
    sg.Parent = Services.CoreGui
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, 280, 0, 45)
    f.Position = UDim2.new(0.5, -140, 0, 15)
    f.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    f.BorderSizePixel = 0
    f.Parent = sg
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 4, 1, 0)
    bar.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    bar.BorderSizePixel = 0
    bar.Parent = f
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -14, 1, 0)
    l.Position = UDim2.new(0, 14, 0, 0)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.fromRGB(255, 255, 255)
    l.Text = text
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    task.delay(dur or 3, function() sg:Destroy() end)
end

-- ============================================
-- 🚀 AUTO-INIT HUB
-- ============================================
local function initHub()
    if not anti_debug() then return end
    
    local gui, frame = Framework:CreateGUI("8ilp HUB")
    
    local buttons = {
        {"ESP PLAYERS", 40, function()
            Framework:PlayerESP()
            Framework:Notify("ESP Activated", 2)
        end},
        {"AUTO FARM", 78, function()
            Framework:AutoFarm(200)
            Framework:Notify("Auto Farm Started", 2)
        end},
        {"SPEED HACK [100]", 116, function()
            Framework:SpeedHack(100)
            Framework:Notify("Speed Set to 100", 2)
        end},
        {"JUMP POWER [150]", 154, function()
            Framework:JumpPower(150)
            Framework:Notify("Jump Power Set to 150", 2)
        end},
        {"FLY [V]", 192, function()
            Framework:Fly(60)
            Framework:Notify("Fly Activated", 2)
        end},
        {"NOCLIP", 230, function()
            Framework:Noclip(true)
            Framework:Notify("Noclip Activated", 2)
        end},
        {"RESET SPEED", 268, function()
            Framework:SpeedHack(16)
            Framework:Notify("Speed Reset", 2)
        end},
        {"RESET JUMP", 306, function()
            Framework:JumpPower(50)
            Framework:Notify("Jump Reset", 2)
        end},
    }
    
    for _, btn in ipairs(buttons) do
        Framework:CreateButton(frame, btn[1], btn[2], btn[3])
    end
    
    Framework:Notify("8ilp HUB Loaded!", 3)
end

-- ============================================
-- 🛡️ PROTECTION WRAPPER
-- ============================================
local MASTER_KEY = "8ilp_X9kL2mN7pQ4rT8vY1wB6zA3dF5hJ0cE!_ULTRA"

local function protect(code, key)
    local k = key or MASTER_KEY
    local xored = xor_encrypt(code, k)
    return b64_encode(xored)
end

local function unprotect(data, key)
    local k = key or MASTER_KEY
    local decoded = b64_decode(data)
    return xor_encrypt(decoded, k)  -- xor again = decrypt
end

-- ============================================
-- 🎯 EXECUTE: يشتغل تلقائي عند الاستدعاء
-- ============================================
initHub()

-- ============================================
-- 📤 دوال جاهزة للتصدير
-- ============================================
return {
    Framework = Framework,
    protect = protect,
    unprotect = unprotect,
    MASTER_KEY = MASTER_KEY,
    
    -- تشفير سكربت خارجي
    EncryptScript = function(scriptCode, key)
        return protect(scriptCode, key or MASTER_KEY)
    end,
    
    -- تشغيل سكربت مشفر
    RunEncrypted = function(encryptedCode, key)
        local decrypted = unprotect(encryptedCode, key or MASTER_KEY)
        loadstring(decrypted)()
    end,
}
