-- ============================================
--  Koop kid btools gui - با ۳ دکمه مجزا
--  سیستم: SyncAPI + Fire All + Decal + Sky
-- ============================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============================================
-- GUI اصلی
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KoopKidBtoolsGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 200)
frame.Position = UDim2.new(0.5, -140, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(200, 0, 0)
stroke.Thickness = 1.5
stroke.Transparency = 0.3

-- ============================================
-- هدر
-- ============================================
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 32)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
header.BorderSizePixel = 0
header.Parent = frame

local corner2 = Instance.new("UICorner")
corner2.CornerRadius = UDim.new(0, 12)
corner2.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 8, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔥 Koop kid btools gui"
title.TextColor3 = Color3.fromRGB(255, 200, 100)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -30, 0.5, -12)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ============================================
-- سیستم درگ
-- ============================================
local dragging = false
local dragStart
local startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- ============================================
-- تابع ساخت دکمه
-- ============================================
local function createButton(text, yPos, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 32)
    btn.Position = UDim2.new(0.075, 0, yPos, 0)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    return btn
end

-- ============================================
-- توابع SyncAPI (از فایل اصلی)
-- ============================================
local function getSyncAPI()
    local tool
    for _, v in pairs(player:GetDescendants()) do
        if v.Name == "SyncAPI" then
            tool = v.Parent
        end
    end
    for _, v in pairs(game.ReplicatedStorage:GetDescendants()) do
        if v.Name == "SyncAPI" then
            tool = v.Parent
        end
    end
    return tool
end

local function invokeRemote(args)
    local tool = getSyncAPI()
    if not tool then return end
    local remote = tool.SyncAPI.ServerEndpoint
    remote:InvokeServer(unpack(args))
end

local function SetLocked(part, boolean)
    invokeRemote({ [1] = "SetLocked", [2] = { [1] = part }, [3] = boolean })
end

local function AddFire(part)
    invokeRemote({
        [1] = "CreateDecorations",
        [2] = {
            [1] = {
                ["Part"] = part,
                ["DecorationType"] = "Fire"
            }
        }
    })
end

local function SpawnDecal(part, side)
    invokeRemote({
        [1] = "CreateTextures",
        [2] = {
            [1] = {
                ["Part"] = part,
                ["Face"] = side,
                ["TextureType"] = "Decal"
            }
        }
    })
end

local function AddDecal(part, asset, side)
    invokeRemote({
        [1] = "SyncTexture",
        [2] = {
            [1] = {
                ["Part"] = part,
                ["Face"] = side,
                ["TextureType"] = "Decal",
                ["Texture"] = "rbxassetid://" .. asset
            }
        }
    })
end

local function SetMesh(part, meshid)
    invokeRemote({
        [1] = "SyncMesh",
        [2] = {
            [1] = {
                ["Part"] = part,
                ["MeshId"] = "rbxassetid://" .. meshid
            }
        }
    })
end

local function SetTexture(part, texid)
    invokeRemote({
        [1] = "SyncMesh",
        [2] = {
            [1] = {
                ["Part"] = part,
                ["TextureId"] = "rbxassetid://" .. texid
            }
        }
    })
end

local function SetName(part, stringg)
    invokeRemote({ [1] = "SetName", [2] = { [1] = part }, [3] = stringg })
end

local function AddMesh(part)
    invokeRemote({
        [1] = "CreateMeshes",
        [2] = {
            [1] = {
                ["Part"] = part
            }
        }
    })
end

local function MeshResize(part, size)
    invokeRemote({
        [1] = "SyncMesh",
        [2] = {
            [1] = {
                ["Part"] = part,
                ["Scale"] = size
            }
        }
    })
end

local function CreatePart(cf, parent)
    invokeRemote({ [1] = "CreatePart", [2] = "Normal", [3] = cf, [4] = parent })
end

-- ============================================
-- تابع Sky
-- ============================================
local function Sky(id)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local e = hrp.CFrame.X
    local f = hrp.CFrame.Y
    local g = hrp.CFrame.Z

    CreatePart(CFrame.new(math.floor(e), math.floor(f), math.floor(g)) + Vector3.new(0, 6, 0), workspace)

    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.CFrame.X == math.floor(e) and v.CFrame.Z == math.floor(g) then
            SetName(v, "Sky")
            AddMesh(v)
            SetMesh(v, "8006679977")
            SetTexture(v, id)
            MeshResize(v, Vector3.new(50, 50, 50))
            SetLocked(v, true)
        end
    end
end

-- ============================================
-- تابع Decal
-- ============================================
local function Decal(id)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            task.spawn(function()
                SetLocked(v, false)
                local sides = {
                    Enum.NormalId.Front,
                    Enum.NormalId.Back,
                    Enum.NormalId.Right,
                    Enum.NormalId.Left,
                    Enum.NormalId.Bottom,
                    Enum.NormalId.Top
                }
                for _, side in ipairs(sides) do
                    SpawnDecal(v, side)
                    AddDecal(v, id, side)
                end
            end)
        end
    end
end

-- ============================================
-- تابع Fire All
-- ============================================
local function FireAll()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            task.spawn(function()
                SetLocked(v, false)
                AddFire(v)
            end)
        end
    end
end

-- ============================================
-- دکمه‌ها
-- ============================================
local fireBtn = createButton("🔥 Fire All", 0.15, Color3.fromRGB(200, 50, 0))
fireBtn.MouseButton1Click:Connect(FireAll)

local decalBtn = createButton("🖼️ Decal", 0.43, Color3.fromRGB(0, 100, 200))
decalBtn.MouseButton1Click:Connect(function()
    Decal("16438486359")
end)

local skyBtn = createButton("🌤️ Sky", 0.71, Color3.fromRGB(0, 150, 100))
skyBtn.MouseButton1Click:Connect(function()
    Sky("16547689152")
end)

print("✅ Koop kid btools gui Loaded!")
