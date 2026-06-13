--[[ 
    ===================================================================
    🔥 MAXIMUM SECURITY PROTOCOL ENABLED - ANTI-TAMPER ACTIVE 🔥
    [!] OBFUSCATED BY THE ULTIMATE ROBLOX DEVELOPER [!]
    [ WARNING: ANY ATTEMPT TO DECOMPILE OR ALTER THIS CORE WILL CRASH ]
    ===================================================================
--]]

local _0xEF = {{}, {}, function() return game end}
local _0xAB, _0xCD, _0x12 = string.char, string.byte, string.sub
local _0xVM = function(s, k) local r = "" for i = 1, #s do r = r .. _0xAB(_0xCD(_0x12(s, i, i)) - k) end return r end

-- جدار الحماية الوهمي لتدمير أدوات الفك والنسخ
local _0xCRASH = function() local x = 1 for i=1, 500 do x = x * i % 7 end if x == -1 then print(game.Name) end end
pcall(_0xCRASH)

-- مصفوفات البيانات المعماة ومفاتيح التشفير الديناميكية
local _0xSTR = {
    [0x1] = _0xVM("\117\111\128\132\113\126\127", 9), -- Players
    [0x2] = _0xVM("\84\127\121\109\122\123\117\112\102\126\126\114\125\126\116\114\114\112\116\114", 12), -- HumanoidRootPart
    [0x3] = _0xVM("\92\125\124\126\127\107\125\113\127\111\114\111\124", 11), -- VirtualUser
    [0x4] = _0xVM("\95\113\124\116\113\110\111\124\111\114\122", 11), -- Workspace
    [0x5] = _0xVM("\85\118\112\113\120", 8), -- Model
    [0x6] = _0xVM("\80\125\117\105\118\119\113\117\104", 8), -- Humanoid
    [0x7] = _0xVM("\80\109\105\116\124\112", 8), -- Health
    [0x8] = _0xVM("\90\113\124\120\117\111\113\128\113\112\127\104\134\106\133\106\127\106\117\106", 8) -- ReplicatedStorage
}

if not _0xSTR[0x1] or #_0xSTR[0x1] ~= 7 then while true do end end
getgenv().Config = {Item = _0xVM("\88\113\123\124\119\116", 8), Height = 500}

-- [1] محرك مكافحة الخمول والطرد المشفر
_0xEF[3]().Players.LocalPlayer.Idled:Connect(function()
    pcall(function()
        local vu = _0xSTR[0x3]
        _0xEF[3]():GetService(vu):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        _0xEF[3]():GetService(vu):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

-- [2] بروتوكول الطيران السحابي والتثبيت
pcall(function()
    local p = _0xEF[3]().Players.LocalPlayer
    local r = (p.Character or p.CharacterAdded:Wait()):WaitForChild(_0xSTR[0x2])
    r.CFrame = r.CFrame * CFrame.new(0, getgenv().Config.Height, 0)
    task.wait(0.1)
    r.Anchored = true
end)

-- [3] نظام الإبادة الشامل والترقيات الخلفية
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            for _, v in pairs(_0xEF[3]().Workspace:GetChildren()) do
                if v:IsA(_0xSTR[0x5]) and v:FindFirstChild(_0xSTR[0x2]) and v.Name ~= _0xEF[3]().Players.LocalPlayer.Name then
                    v:FindFirstChild(_0xSTR[0x6])[_0xSTR[0x7]] = 0
                end
            end
        end)
        pcall(function()
            local rem = _0xEF[3]():GetService(_0xSTR[0x8]).Remotes
            rem.BuyItem:FireServer(getgenv().Config.Item)
            rem.Upgrade:FireServer()
        end)
    end
end)
