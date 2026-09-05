-- ShiBu FPS Boost
pcall(function()
    if setfpscap then setfpscap(60) end
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

local L = game:GetService("Lighting")
L.GlobalShadows = false
L.FogEnd = 1e9
L.EnvironmentDiffuseScale = 0
L.EnvironmentSpecularScale = 0

local function opt(v)
    pcall(function()
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam")
        or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
            v.Enabled = false
        elseif v:IsA("BasePart") then
            v.CastShadow = false
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        elseif v:IsA("PostEffect") then
            v.Enabled = false
        end
    end)
end

for _,v in ipairs(game:GetDescendants()) do opt(v) end
game.DescendantAdded:Connect(function(v) task.defer(opt,v) end)

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title="ShiBu FPS Boost",
        Text="Đã bật tối ưu FPS | Cap 60",
        Duration=4
    })
end)

print("[ShiBu FPS Boost] Loaded")
