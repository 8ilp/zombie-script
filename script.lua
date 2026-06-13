-- تحميل المكتبة الأساسية
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- إنشاء النافذة
local Window = Fluent:CreateWindow({
    Title = "قائمة الأسطورة المحمية 👑",
    SubTitle = "الإصدار المتوافق",
    TabWidth = 160,
    Size = UDim2.fromOffset(400, 400),
    Theme = "Dark"
})

-- إنشاء التبويبات
local MainTab = Window:AddTab({ Title = "الرئيسية", Icon = "home" })
local SpamTab = Window:AddTab({ Title = "أدوات السبام", Icon = "message" })
local ExtraTab = Window:AddTab({ Title = "إضافات", Icon = "unlock" })
local TrackTab = Window:AddTab({ Title = "تتبع وتحكم", Icon = "search" })

-- 1. ميزة الاختراق (Noclip)
ExtraTab:AddToggle("NoclipToggle", { Title = "اختراق الجدران (Noclip)", Default = false, Callback = function(Value)
    getgenv().NoclipActive = Value
    game:GetService("RunService").Stepped:Connect(function()
        if getgenv().NoclipActive then
            local char = game.Players.LocalPlayer.Character
            if char then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
        end
    end)
end})

-- 2. ميزة الاختفاء
ExtraTab:AddToggle("InvisibleToggle", { Title = "تفعيل الاختفاء", Default = false, Callback = function(Value)
    local char = game.Players.LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do if part:IsA("BasePart") then part.Transparency = Value and 1 or 0 end end
    end
end})

-- 3. السبام
local MySpamText = "فعاليات رسم للعرب 🎨"
SpamTab:AddInput("SpamInput", { Title = "نص السبام", Default = MySpamText, Callback = function(Value) MySpamText = Value end })
SpamTab:AddToggle("SpamToggle", { Title = "تفعيل السبام", Callback = function(Value)
    getgenv().SpamActive = Value
    task.spawn(function()
        while getgenv().SpamActive do
            local RS = game:GetService("ReplicatedStorage")
            if RS:FindFirstChild("DefaultChatSystemChatEvents") then
                RS.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(MySpamText, "All")
            end
            task.wait(0.33)
        end
    end)
end})

-- 4. التتبع والتحكم
local TargetInput = ""
TrackTab:AddInput("TrackInput", { Title = "اسم اللاعب (أو جزء منه)", Callback = function(Value) TargetInput = Value end })

local function sendCommand(cmd)
    if TargetInput ~= "" then
        local msg = cmd .. " " .. TargetInput
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
        Fluent:Notify({ Title = "تم الإرسال", Text = "تم تنفيذ: " .. msg, Duration = 3 })
    end
end

TrackTab:AddButton({ Title = "أمر /re [اللاعب]", Callback = function() sendCommand("/re") end })
TrackTab:AddButton({ Title = "أمر /res [اللاعب]", Callback = function() sendCommand("/res") end })
TrackTab:AddButton({ Title = "أمر /logs [اللاعب]", Callback = function() sendCommand("/logs") end })

-- إشعار الدخول
game:GetService("Players").PlayerAdded:Connect(function(plr)
    if TargetInput ~= "" and plr.Name:lower():find(TargetInput:lower()) then
        Fluent:Notify({ Title = "تنبيه تتبع", Text = plr.Name .. " دخل السيرفر!", Duration = 5 })
    end
end)

Fluent:SelectTab(1)
Fluent:Notify({ Title = "نجاح", Text = "القائمة تعمل الآن!", Duration = 3 })
