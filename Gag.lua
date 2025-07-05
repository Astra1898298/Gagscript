-- Grow a Garden GUI Tool by ChatGPT
-- 教育目的のみで使用してください

-- GUI削除済みチェック
if game.CoreGui:FindFirstChild("GrowAGardenTool") then
    game.CoreGui:FindFirstChild("GrowAGardenTool"):Destroy()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Replicated = game:GetService("ReplicatedStorage")
local Garden = workspace:FindFirstChild("GardenPlots") or workspace:WaitForChild("GardenPlots")

-- GUI作成
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GrowAGardenTool"
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 180)
Frame.Position = UDim2.new(0, 50, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local function createButton(text, yPos, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 230, 0, 40)
    Button.Position = UDim2.new(0, 10, 0, yPos)
    Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 20
    Button.Text = text
    Button.Parent = Frame
    Button.MouseButton1Click:Connect(callback)
    return Button
end

-- 機能状態
local speedEnabled = false
local autoWaterEnabled = false
local autoWaterLoop = nil

-- 高速移動ボタン
createButton("🏃 高速移動 ON/OFF", 10, function()
    speedEnabled = not speedEnabled
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speedEnabled and 100 or 16
    end
end)

-- 自動水やりボタン
createButton("💧 自動水やり ON/OFF", 60, function()
    autoWaterEnabled = not autoWaterEnabled
    if autoWaterEnabled then
        autoWaterLoop = task.spawn(function()
            while autoWaterEnabled do
                for _, plot in pairs(Garden:GetChildren()) do
                    if plot:FindFirstChild("NeedsWater") and plot.NeedsWater.Value == true then
                        Replicated:WaitForChild("RemoteEvents"):WaitForChild("WaterPlant"):FireServer(plot)
                    end
                end
                wait(2)
            end
        end)
    else
        if autoWaterLoop then
            task.cancel(autoWaterLoop)
        end
    end
end)

-- 終了ボタン
createButton("❌ ツール終了", 110, function()
    if autoWaterLoop then
        task.cancel(autoWaterLoop)
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
    ScreenGui:Destroy()
end)

-- 通知
pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Grow Tool 起動",
        Text = "Grow a Garden ツールを有効化しました！",
        Duration = 5
    })
end)
