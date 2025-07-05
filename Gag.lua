-- Grow a Garden GUI Tool by ChatGPT
-- 教育目的のみで使用してください

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Replicated = game:GetService("ReplicatedStorage")
local Garden = workspace:WaitForChild("GardenPlots")

-- UI作成
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "GrowAGardenTool"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 180)
Frame.Position = UDim2.new(0, 50, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 0

local function createButton(text, yPos, callback)
    local Button = Instance.new("TextButton", Frame)
    Button.Size = UDim2.new(0, 230, 0, 40)
    Button.Position = UDim2.new(0, 10, 0, yPos)
    Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 20
    Button.Text = text
    Button.MouseButton1Click:Connect(callback)
    return Button
end

-- 機能のトグル状態
local speedEnabled = false
local autoWaterEnabled = false
local autoWaterLoop

-- 高速移動トグル
createButton("🏃 高速移動 ON/OFF", 10, function()
    speedEnabled = not speedEnabled
    LocalPlayer.Character.Humanoid.WalkSpeed = speedEnabled and 100 or 16
end)

-- 自動水やりトグル
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

-- UI削除・終了
createButton("❌ ツール終了", 110, function()
    if autoWaterLoop then task.cancel(autoWaterLoop) end
    LocalPlayer.Character.Humanoid.WalkSpeed = 16
    ScreenGui:Destroy()
end)
