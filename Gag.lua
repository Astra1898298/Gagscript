-- KRNL用 Lua Script（Grow a Garden）
-- 読み込み時に特定のペットを収納し、その後植物に水をやり続ける

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- RemoteEvents（※本番ではRemoteの名前をSpy等で確認要）
local storePetEvent = ReplicatedStorage:WaitForChild("StorePet")
local waterPlantEvent = ReplicatedStorage:WaitForChild("WaterPlant")

-- 🌟 対象ペット名一覧（必要に応じて追加・編集可能）
local petNames = {
    "Raccoon",
    "Dragonfly",
    "Disco Bee",
    "Queen Bee",
    "Butterfly",
    "Toucan"
}

-- 🔍 指定された名前のモデルか確認（大小区別なし）
local function isTargetPet(modelName)
    for _, name in ipairs(petNames) do
        if string.lower(modelName) == string.lower(name) then
            return true
        end
    end
    return false
end

-- 📦 ペットを探してインベントリに収納
local function storeAllPets()
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and isTargetPet(obj.Name) then
            -- Remoteで収納実行
            storePetEvent:FireServer(obj)
            wait(0.1)
        end
    end
end

-- 💧 自動で水やり
local function autoWaterPlants()
    while true do
        wait(2)
        for _, plant in pairs(Workspace:GetChildren()) do
            if plant:IsA("Model") and plant:FindFirstChild("NeedsWater") then
                waterPlantEvent:FireServer(plant)
            end
        end
    end
end

-- 🔁 実行開始
storeAllPets()
autoWaterPlants()
