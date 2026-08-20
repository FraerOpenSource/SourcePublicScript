local CG = gethui and gethui() or game:GetService("CoreGui")
local TS, UIS, RS = game:GetService("TweenService"), game:GetService("UserInputService"), game:GetService("RunService")
local Players, Lighting = game:GetService("Players"), game:GetService("Lighting")
local LP, Cam = Players.LocalPlayer, workspace.CurrentCamera

if CG:FindFirstChild("DeltaEvoUI") then CG.DeltaEvoUI:Destroy() end

local GB, GS, GM, G = Enum.Font.GothamBold, Enum.Font.GothamSemibold, Enum.Font.GothamMedium, Enum.Font.Gotham
local EBack, EQuart = Enum.EasingStyle.Back, Enum.EasingStyle.Quart
local EIn, EOut = Enum.EasingDirection.In, Enum.EasingDirection.Out

local C_BG, C_EL, C_PR = Color3.fromRGB(12,12,16), Color3.fromRGB(22,22,28), Color3.fromRGB(138,43,226)
local C_TX, C_GR, C_On, C_Off = Color3.fromRGB(240,240,240), Color3.fromRGB(150,150,150), Color3.fromRGB(46,204,113), Color3.fromRGB(45,45,55)
local IsRainbow, RainbowHue = false, 0

local ThemeElements = {
    Fills = {},
    Texts = {},
    Strokes = {}
}

local function RegisterElement(type, inst)
    table.insert(ThemeElements[type], inst)
end

local function UpdateThemeColor(newColor)
    for _, fill in ipairs(ThemeElements.Fills) do
        if fill and fill.Parent then fill.BackgroundColor3 = newColor end
    end
    for _, txt in ipairs(ThemeElements.Texts) do
        if txt and txt.Parent then txt.TextColor3 = newColor end
    end
    for _, str in ipairs(ThemeElements.Strokes) do
        if str and str.Parent then str.Color = newColor end
    end
end

local function Make(cls, props)
    local inst = Instance.new(cls)
    for k, v in next, props do if k ~= "Parent" then inst[k] = v end end
    if props.Parent then inst.Parent = props.Parent end
    return inst
end

local function GetGradient(color)
    local h, s, v = Color3.toHSV(color)
    local dark = Color3.fromHSV(h, s, math.clamp(v-0.5, 0, 1))
    return ColorSequence.new{ColorSequenceKeypoint.new(0, color), ColorSequenceKeypoint.new(0.5, dark), ColorSequenceKeypoint.new(1, color)}
end

local function MakeDrag(handle, target)
    local drag, dStart, sPos
    handle.InputBegan:Connect(function(i) if i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch") then drag, dStart, sPos = true, i.Position, target.Position end end)
    UIS.InputChanged:Connect(function(i) if drag and (i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch")) then local d = i.Position - dStart; target.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch") then drag = false end end)
end

local GUI = Make("ScreenGui", {Name = "DeltaEvoUI", ResetOnSpawn = false, IgnoreGuiInset = true, Parent = CG})
local ESPFolder = Make("Folder", {Name = "ESPFolder", Parent = GUI})

local FOVFrame = Make("Frame", {AnchorPoint = Vector2.new(0.5,0.5), BackgroundTransparency = 1, Visible = false, Parent = GUI})
local FOVStroke = Make("UIStroke", {Color = C_PR, Thickness = 1.5, Parent = FOVFrame})
RegisterElement("Strokes", FOVStroke)
Make("UICorner", {CornerRadius = UDim.new(1,0), Parent = FOVFrame})

local Main = Make("Frame", {Size = UDim2.new(0,350,0,280), Position = UDim2.new(0.5,0,0.5,0), AnchorPoint = Vector2.new(0.5,0.5), BackgroundColor3 = C_BG, ClipsDescendants = false, Parent = GUI})
Make("UICorner", {CornerRadius = UDim.new(0,10), Parent = Main})
local M_Stroke = Make("UIStroke", {Thickness = 2.5, Color = Color3.new(1,1,1), Parent = Main})
local Grad = Make("UIGradient", {Color = GetGradient(C_PR), Parent = M_Stroke})

local ColorBg = Make("Frame", {Size = UDim2.new(0,165,0,28), Position = UDim2.new(0,0,0,-36), BackgroundColor3 = Color3.fromRGB(18,18,24), Parent = Main})
Make("UICorner", {CornerRadius = UDim.new(0,8), Parent = ColorBg})
local C_Stroke = Make("UIStroke", {Thickness = 2.5, Color = Color3.new(1,1,1), Parent = ColorBg})
local C_Grad = Make("UIGradient", {Color = GetGradient(C_PR), Parent = C_Stroke})

local ColorPanel = Make("Frame", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Parent = ColorBg})
Make("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0,8), HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center, Parent = ColorPanel})

local Top = Make("Frame", {Size = UDim2.new(1,0,0,40), BackgroundColor3 = Color3.fromRGB(18,18,24), Active = true, Parent = Main})
Make("UICorner", {CornerRadius = UDim.new(0,10), Parent = Top})
local Title = Make("TextLabel", {Size = UDim2.new(1,-80,1,0), Position = UDim2.new(0,15,0,0), BackgroundTransparency = 1, Text = "NaziDLC", TextColor3 = C_PR, Font = GB, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, Parent = Top})
RegisterElement("Texts", Title)

local ColorBtn = Make("TextButton", {Size = UDim2.new(0,30,1,0), Position = UDim2.new(1,-70,0,0), BackgroundTransparency = 1, Text = "🎨", TextColor3 = C_TX, Font = GB, TextSize = 14, ZIndex = 5, Parent = Top})
local MinBtn = Make("TextButton", {Size = UDim2.new(0,40,1,0), Position = UDim2.new(1,-40,0,0), BackgroundTransparency = 1, Text = "—", TextColor3 = C_TX, Font = GB, TextSize = 16, ZIndex = 5, Parent = Top})

local Scroll = Make("ScrollingFrame", {Size = UDim2.new(1,-20,1,-55), Position = UDim2.new(0,10,0,45), BackgroundTransparency = 1, ScrollBarThickness = 0, Parent = Main})
local List = Make("UIListLayout", {Padding = UDim.new(0,8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Scroll})

local Float = Make("TextButton", {Size = UDim2.new(0,50,0,50), Position = UDim2.new(0.5,0,0.1,0), AnchorPoint = Vector2.new(0.5,0.5), BackgroundColor3 = Color3.fromRGB(20,20,20), Text = "N", TextColor3 = C_PR, Font = GM, TextSize = 22, Visible = false, Active = true, Parent = GUI})
RegisterElement("Texts", Float)
Make("UICorner", {CornerRadius = UDim.new(1,0), Parent = Float})
Make("UIStroke", {Thickness = 1, Color = Color3.new(1,1,1), Transparency = 0.85, Parent = Float})

local TPMenu = Make("Frame", {
    Size = UDim2.new(0, 170, 0, 190),
    Position = UDim2.new(0.7, 0, 0.35, 0),
    BackgroundColor3 = C_BG,
    Visible = false,
    Active = true,
    Parent = GUI
})
Make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = TPMenu})
local TP_Stroke = Make("UIStroke", {Thickness = 2, Color = Color3.new(1,1,1), Parent = TPMenu})
local TP_Grad = Make("UIGradient", {Color = GetGradient(C_PR), Parent = TP_Stroke})

local TPTop = Make("Frame", {Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Color3.fromRGB(18,18,24), Active = true, Parent = TPMenu})
Make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = TPTop})

local TPTitle = Make("TextLabel", {
    Size = UDim2.new(1, -35, 1, 0), Position = UDim2.new(0, 8, 0, 0),
    BackgroundTransparency = 1, Text = "TP Player", TextColor3 = C_PR,
    Font = GB, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = TPTop
})
RegisterElement("Texts", TPTitle)

local TPCloseBtn = Make("TextButton", {
    Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(1, -28, 0.5, -13),
    BackgroundTransparency = 1, Text = "X", TextColor3 = Color3.fromRGB(255, 75, 75),
    Font = GB, TextSize = 13, Parent = TPTop
})

local TPScroll = Make("ScrollingFrame", {
    Size = UDim2.new(1, -10, 1, -36), Position = UDim2.new(0, 5, 0, 32),
    BackgroundTransparency = 1, ScrollBarThickness = 0, Parent = TPMenu
})
local TPList = Make("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = TPScroll})

TPList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TPScroll.CanvasSize = UDim2.new(0, 0, 0, TPList.AbsoluteContentSize.Y + 4)
end)

MakeDrag(TPTop, TPMenu)

local function UpdateTPList()
    for _, child in ipairs(TPScroll:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("Frame") then child:Destroy() end
    end
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            local card = Make("TextButton", {
                Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = C_EL,
                Text = "", AutoButtonColor = true, Parent = TPScroll
            })
            Make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = card})
            
            local img = Make("ImageLabel", {
                Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(0, 4, 0.5, -11),
                BackgroundTransparency = 1, Parent = card
            })
            Make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = img})
            
            task.spawn(function()
                local content = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
                img.Image = content
            end)
            
            Make("TextLabel", {
                Size = UDim2.new(1, -32, 0, 12), Position = UDim2.new(0, 30, 0, 3),
                BackgroundTransparency = 1, Text = p.DisplayName, TextColor3 = C_TX,
                Font = GB, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = card
            })
            Make("TextLabel", {
                Size = UDim2.new(1, -32, 0, 10), Position = UDim2.new(0, 30, 0, 16),
                BackgroundTransparency = 1, Text = "@" .. string.lower(p.Name), TextColor3 = C_GR,
                Font = G, TextSize = 8, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = card
            })
            
            card.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                    LP.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    pcall(function() game.StarterGui:SetCore("SendNotification", {Title = "NaziDLC - Teleport", Text = "Телепортирован к " .. p.DisplayName, Duration = 2}) end)
                end
            end)
        end
    end
end

Players.PlayerAdded:Connect(UpdateTPList)
Players.PlayerRemoving:Connect(UpdateTPList)

local function ToggleTPMenu(state)
    if state then
        UpdateTPList()
        TPMenu.Visible = true
        TPMenu.Size = UDim2.new(0, 0, 0, 0)
        TS:Create(TPMenu, TweenInfo.new(0.3, EBack, EOut), {Size = UDim2.new(0, 170, 0, 190)}):Play()
    else
        local anim = TS:Create(TPMenu, TweenInfo.new(0.2, EBack, EIn), {Size = UDim2.new(0, 0, 0, 0)})
        anim:Play()
        anim.Completed:Wait()
        TPMenu.Visible = false
    end
end

TPCloseBtn.MouseButton1Click:Connect(function()
    ToggleTPMenu(false)
end)

local colorsOpen = true
local isColorAnim = false
ColorBtn.MouseButton1Click:Connect(function()
    if isColorAnim then return end; isColorAnim = true
    colorsOpen = not colorsOpen
    TS:Create(ColorBtn, TweenInfo.new(0.3), {Rotation = colorsOpen and 0 or -180}):Play()
    if colorsOpen then
        ColorBg.Visible = true
        local t1 = TS:Create(ColorBg, TweenInfo.new(0.3, EQuart, EOut), {Position = UDim2.new(0,0,0,-36), BackgroundTransparency = 0})
        local t2 = TS:Create(C_Stroke, TweenInfo.new(0.3), {Transparency = 0})
        t1:Play(); t2:Play()
        t1.Completed:Wait()
    else
        local t1 = TS:Create(ColorBg, TweenInfo.new(0.3, EQuart, EIn), {Position = UDim2.new(0,0,0,-10), BackgroundTransparency = 1})
        local t2 = TS:Create(C_Stroke, TweenInfo.new(0.3), {Transparency = 1})
        t1:Play(); t2:Play()
        t1.Completed:Wait()
        ColorBg.Visible = false
    end
    isColorAnim = false
end)

local ThemeColors = {Color3.fromRGB(138,43,226), Color3.fromRGB(255,40,40), Color3.fromRGB(40,200,255), Color3.fromRGB(40,255,100), Color3.fromRGB(255,180,40)}
for _, col in ipairs(ThemeColors) do
    local btn = Make("TextButton", {Size = UDim2.new(0,18,0,18), BackgroundColor3 = col, Text = "", Parent = ColorPanel})
    Make("UICorner", {CornerRadius = UDim.new(1,0), Parent = btn})
    btn.MouseButton1Click:Connect(function() 
        IsRainbow = false
        C_PR = col
        Grad.Color = GetGradient(col)
        C_Grad.Color = GetGradient(col)
        TP_Grad.Color = GetGradient(col)
        UpdateThemeColor(col)
    end)
end
local RbwBtn = Make("TextButton", {Size = UDim2.new(0,18,0,18), BackgroundColor3 = Color3.new(1,1,1), Text = "", Parent = ColorPanel})
Make("UICorner", {CornerRadius = UDim.new(1,0), Parent = RbwBtn})
local RbwBtnStroke = Make("UIStroke", {Thickness = 1.5, Color = Color3.new(1,1,1), Parent = RbwBtn})
RbwBtn.MouseButton1Click:Connect(function() IsRainbow = true end)

RS.RenderStepped:Connect(function(dt)
    local btnHue = (tick() * 0.5) % 1
    RbwBtn.BackgroundColor3 = Color3.fromHSV(btnHue, 0.9, 1)
    RbwBtnStroke.Color = Color3.fromHSV((btnHue + 0.5) % 1, 0.9, 1)
    if IsRainbow then
        RainbowHue = (RainbowHue + dt * 0.3) % 1
        C_PR = Color3.fromHSV(RainbowHue, 0.9, 1)
        Grad.Color = GetGradient(C_PR)
        C_Grad.Color = GetGradient(C_PR)
        TP_Grad.Color = GetGradient(C_PR)
        UpdateThemeColor(C_PR)
    end
    Grad.Rotation = (Grad.Rotation + 80 * dt) % 360
    C_Grad.Rotation = Grad.Rotation
    TP_Grad.Rotation = Grad.Rotation
    if FOVFrame.Visible then FOVFrame.Position = UDim2.new(0, Cam.ViewportSize.X/2, 0, Cam.ViewportSize.Y/2) end
end)

MakeDrag(Top, Main); MakeDrag(Float, Float)

local isAnim = false
MinBtn.MouseButton1Click:Connect(function()
    if isAnim then return end; isAnim = true
    local s = TS:Create(Main, TweenInfo.new(0.25, EBack, EIn), {Size = UDim2.new(0,0,0,0)})
    s:Play(); s.Completed:Wait(); Main.Visible = false; Float.Size = UDim2.new(0,0,0,0); Float.Visible = true
    local e = TS:Create(Float, TweenInfo.new(0.3, EBack, EOut), {Size = UDim2.new(0,50,0,50)})
    e:Play(); e.Completed:Wait(); isAnim = false
end)
Float.MouseButton1Click:Connect(function()
    if isAnim then return end; isAnim = true
    local s = TS:Create(Float, TweenInfo.new(0.2, EBack, EIn), {Size = UDim2.new(0,0,0,0)})
    s:Play(); s.Completed:Wait(); Float.Visible = false; Main.Size = UDim2.new(0,0,0,0); Main.Visible = true
    local e = TS:Create(Main, TweenInfo.new(0.35, EBack, EOut), {Size = UDim2.new(0,350,0,280)})
    e:Play(); e.Completed:Wait(); isAnim = false
end)

List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Scroll.CanvasSize = UDim2.new(0, 0, 0, List.AbsoluteContentSize.Y + 10) end)

local function CreateSwitch(parent, state, cb)
    local Btn = Make("TextButton", {Size = UDim2.new(0,42,0,22), Position = UDim2.new(1,-52,0.5,-11), BackgroundColor3 = state and C_On or C_Off, Text = "", Parent = parent})
    Make("UICorner", {CornerRadius = UDim.new(1,0), Parent = Btn})
    local Knob = Make("Frame", {Size = UDim2.new(0,18,0,18), Position = state and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9), BackgroundColor3 = Color3.new(1,1,1), Parent = Btn})
    Make("UICorner", {CornerRadius = UDim.new(1,0), Parent = Knob})
    Btn.MouseButton1Click:Connect(function()
        state = not state
        TS:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = state and C_On or C_Off}):Play()
        TS:Create(Knob, TweenInfo.new(0.2), {Position = state and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)}):Play()
        cb(state)
    end)
    return Btn
end

local Elements = {}
function Elements:Feature(txt, cb)
    local open = false
    local Cont = Make("Frame", {Size = UDim2.new(1,0,0,38), BackgroundColor3 = C_EL, ClipsDescendants = true, Parent = Scroll})
    Make("UICorner", {CornerRadius = UDim.new(0,6), Parent = Cont})
    local SList = Make("UIListLayout", {Padding = UDim.new(0,4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Cont})
    local TopRow = Make("Frame", {Size = UDim2.new(1,0,0,38), BackgroundTransparency = 1, Parent = Cont})
    Make("TextLabel", {Size = UDim2.new(1,-80,1,0), Position = UDim2.new(0,10,0,0), BackgroundTransparency = 1, Text = txt, TextColor3 = C_TX, Font = GS, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = TopRow})
    
    CreateSwitch(TopRow, false, cb)

    local Gear = Make("TextButton", {Size = UDim2.new(0,30,0,38), Position = UDim2.new(1,-82,0,0), BackgroundTransparency = 1, Text = "⚙", TextColor3 = C_GR, Font = GB, TextSize = 15, Parent = TopRow})
    Gear.MouseButton1Click:Connect(function()
        open = not open
        TS:Create(Gear, TweenInfo.new(0.3), {Rotation = open and 90 or 0}):Play()
        TS:Create(Cont, TweenInfo.new(0.3, EQuart, EOut), {Size = UDim2.new(1,0,0,open and SList.AbsoluteContentSize.Y or 38)}):Play()
    end)
    SList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() if open then Cont.Size = UDim2.new(1,0,0,SList.AbsoluteContentSize.Y) end end)

    local Settings = {}
    function Settings:Button(name, bcb)
        local S = Make("Frame", {Size = UDim2.new(1,0,0,38), BackgroundTransparency = 1, Parent = Cont})
        local Btn = Make("TextButton", {Size = UDim2.new(1,-20,0,26), Position = UDim2.new(0,10,0.5,-13), BackgroundColor3 = C_BG, Text = name, TextColor3 = C_TX, Font = GB, TextSize = 12, Parent = S})
        Make("UICorner", {CornerRadius = UDim.new(0,6), Parent = Btn})
        local btnStroke = Make("UIStroke", {Thickness = 1, Color = C_PR, Parent = Btn})
        RegisterElement("Strokes", btnStroke)
        Btn.MouseButton1Click:Connect(bcb)
    end
    function Settings:Slider(name, min, max, def, scb)
        local S = Make("Frame", {Size = UDim2.new(1,0,0,45), BackgroundTransparency = 1, Parent = Cont})
        Make("TextLabel", {Size = UDim2.new(1,-20,0,20), Position = UDim2.new(0,10,0,0), BackgroundTransparency = 1, Text = name, TextColor3 = C_GR, Font = G, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = S})
        local V = Make("TextBox", {Size = UDim2.new(1,-20,0,20), Position = UDim2.new(0,10,0,0), BackgroundTransparency = 1, Text = tostring(def), TextColor3 = C_PR, Font = GB, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, ClearTextOnFocus = false, Parent = S})
        RegisterElement("Texts", V)
        
        local Bg = Make("Frame", {Size = UDim2.new(1,-20,0,4), Position = UDim2.new(0,10,0,25), BackgroundColor3 = C_BG, Parent = S}); Make("UICorner", {CornerRadius = UDim.new(1,0), Parent = Bg})
        local Fill = Make("Frame", {Size = UDim2.new((def-min)/(max-min),0,1,0), BackgroundColor3 = C_PR, Parent = Bg}); Make("UICorner", {CornerRadius = UDim.new(1,0), Parent = Fill})
        RegisterElement("Fills", Fill)
        
        local drag, cur = false, def
        local function upd(inp)
            local pos = math.clamp((inp.Position.X - Bg.AbsolutePosition.X) / Bg.AbsoluteSize.X, 0, 1)
            cur = math.floor(min + ((max-min)*pos))
            Fill.Size = UDim2.new(pos,0,1,0); V.Text = tostring(cur); scb(cur)
        end
        V.FocusLost:Connect(function()
            local num = tonumber(V.Text)
            if num then cur = math.clamp(math.floor(num), min, max); Fill.Size = UDim2.new((cur-min)/(max-min),0,1,0); scb(cur) end
            V.Text = tostring(cur)
        end)
        S.InputBegan:Connect(function(i) if i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch") then drag = true; upd(i) end end)
        UIS.InputChanged:Connect(function(i) if drag and (i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch")) then upd(i) end end)
        UIS.InputEnded:Connect(function(i) if i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch") then drag = false end end)
        scb(def)
    end
    function Settings:Toggle(name, def, tcb)
        local S = Make("Frame", {Size = UDim2.new(1,0,0,32), BackgroundTransparency = 1, Parent = Cont})
        Make("TextLabel", {Size = UDim2.new(1,-60,1,0), Position = UDim2.new(0,10,0,0), BackgroundTransparency = 1, Text = name, TextColor3 = C_GR, Font = G, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = S})
        CreateSwitch(S, def, tcb)
    end
    return Settings
end

local SD = {On = false, SavedCF = nil, AutoJump = false}
local Aim = {On = false, ShowFOV = false, FOV = 100, Smooth = 0.5, Wall = false, Dist = 500}
local WB = {On = false, Trans = 0.5, Orig = {}}
local ESP = {Master = false, Box = true, Name = true, Dist = true, HP = true, Tracers = false, Chams = false}
local CharMods = {Fly = false, FlySpd = 50, SpdHack = false, WalkSpd = 16, JmpHack = false, JmpPwr = 50, InfJmp = false, Noclip = false, Fling = false}

local BABFT = {
    Farming = false,
    FlyAutoFarm = false,
    FlySpeed = 150,
    TimeToTeleport = 4,
    RespawnToCase = false,
    WaypointsTP = {
        Vector3.new(-54.8, 16.7, 272.0),
        Vector3.new(-57.5, 41.9, 1501.6),
        Vector3.new(-57.4, 66.3, 2359.7),
        Vector3.new(-61.3, 51.7, 3165.5),
        Vector3.new(-78.5, 57.6, 3870.3),
        Vector3.new(-47.1, 49.2, 4625.2),
        Vector3.new(-51.3, 39.9, 5360.5),
        Vector3.new(-50.0, 30.4, 6172.8),
        Vector3.new(-67.1, 40.6, 7087.8),
        Vector3.new(-62.1, 63.8, 7923.0),
        Vector3.new(-55.0, -356.8, 9484.1)
    },
    WaypointsFly = {
        Vector3.new(-54.8, 120.0, 272.0),
        Vector3.new(-57.5, 120.0, 1501.6),
        Vector3.new(-57.4, 120.0, 2359.7),
        Vector3.new(-61.3, 120.0, 3165.5),
        Vector3.new(-78.5, 120.0, 3870.3),
        Vector3.new(-47.1, 120.0, 4625.2),
        Vector3.new(-51.3, 120.0, 5360.5),
        Vector3.new(-50.0, 120.0, 6172.8),
        Vector3.new(-67.1, 120.0, 7087.8),
        Vector3.new(-62.1, 120.0, 7923.0),
        Vector3.new(-58.0, 100.0, 8700.0),
        Vector3.new(-55.0, -356.8, 9484.1)
    }
}

local function setFloat(character, state)
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 5)
    if not hrp then return end
    
    local bv = hrp:FindFirstChild("FarmFloat")
    if state then
        if not bv then
            bv = Instance.new("BodyVelocity")
            bv.Name = "FarmFloat"
            bv.MaxForce = Vector3.new(0, math.huge, 0)
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.Parent = hrp
        end
    else
        if bv then
            bv:Destroy()
        end
    end
end

local function CleanFarm()
    if LP.Character then
        setFloat(LP.Character, false)
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Freefall)
        end
    end
end

local function waitFarm(seconds)
    local t = 0
    while t < seconds and BABFT.Farming do
        task.wait(0.1)
        t = t + 0.1
    end
    return BABFT.Farming
end

local function startFarmCycle()
    local char = LP.Character or LP.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart", 10)
    local humanoid = char:WaitForChild("Humanoid", 10)
    
    if not hrp or not humanoid or not BABFT.Farming then return end
    
    setFloat(char, true)
    
    local activeWaypoints = BABFT.FlyAutoFarm and BABFT.WaypointsFly or BABFT.WaypointsTP
    
    for index, pos in ipairs(activeWaypoints) do
        if not BABFT.Farming or not char or not char.Parent or humanoid.Health <= 0 then break end
        
        local targetCF = CFrame.new(pos)
        
        if BABFT.FlyAutoFarm then
            local distance = (hrp.Position - pos).Magnitude
            local flyTime = distance / math.max(BABFT.FlySpeed, 10)
            
            local tweenInfo = TweenInfo.new(flyTime, Enum.EasingStyle.Linear)
            local tween = TS:Create(hrp, tweenInfo, {CFrame = targetCF})
            tween:Play()
            
            local elapsed = 0
            while elapsed < flyTime and BABFT.Farming and humanoid.Health > 0 do
                task.wait(0.1)
                elapsed = elapsed + 0.1
            end
            
            if not BABFT.Farming then
                tween:Cancel()
                break
            end
        else
            hrp.CFrame = targetCF
            
            if index == #activeWaypoints then
                if BABFT.RespawnToCase then
                    if not waitFarm(4.5) then break end
                    if char and humanoid and humanoid.Health > 0 and BABFT.Farming then
                        humanoid.Health = 0
                    end
                else
                    local oldChar = char
                    repeat 
                        if not task.wait(0.5) then break end 
                    until not BABFT.Farming or LP.Character ~= oldChar or (oldChar:FindFirstChild("Humanoid") and oldChar.Humanoid.Health <= 0)
                end
            else
                if not waitFarm(BABFT.TimeToTeleport) then break end
            end
        end
    end
    
    if BABFT.Farming and BABFT.FlyAutoFarm and BABFT.RespawnToCase then
        if waitFarm(4.5) and char and humanoid and humanoid.Health > 0 then
            humanoid.Health = 0
        end
    end
    
    if not BABFT.Farming then
        CleanFarm()
    end
end

LP.CharacterAdded:Connect(function(newChar)
    if BABFT.Farming then
        task.wait(1.5)
        if BABFT.Farming then
            task.spawn(startFarmCycle)
        end
    end
end)

local BABFT_Feature = Elements:Feature("BABFT AutoFarm", function(s)
    BABFT.Farming = s
    if s then
        pcall(function() game.StarterGui:SetCore("SendNotification", {Title = "NaziDLC - AutoFarm", Text = "Автофарм запущен!", Duration = 3}) end)
        task.spawn(startFarmCycle)
    else
        pcall(function() game.StarterGui:SetCore("SendNotification", {Title = "NaziDLC - AutoFarm", Text = "Автофарм остановлен.", Duration = 3}) end)
        CleanFarm()
    end
end)

BABFT_Feature:Slider("Time to teleport", 1, 10, 4, function(v)
    BABFT.TimeToTeleport = v
end)

BABFT_Feature:Toggle("Fly AutoFarm", false, function(s)
    BABFT.FlyAutoFarm = s
end)

BABFT_Feature:Slider("Fly Speed", 50, 500, 150, function(v)
    BABFT.FlySpeed = v
end)

BABFT_Feature:Toggle("Respawn to Case", false, function(s)
    BABFT.RespawnToCase = s
end)

local SDF = Elements:Feature("Spawn Debugger", function(s)
    SD.On = s
    if s and SD.SavedCF == nil and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        SD.SavedCF = LP.Character.HumanoidRootPart.CFrame
        local pos = SD.SavedCF.Position
        pcall(function() game.StarterGui:SetCore("SendNotification", {Title = "NaziDLC - Debugger", Text = string.format("Точка авто-сохранена!\nX: %.1f, Y: %.1f, Z: %.1f", pos.X, pos.Y, pos.Z), Duration = 3}) end)
    end
end)
SDF:Button("Сохранить текущую позицию", function()
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        SD.SavedCF = LP.Character.HumanoidRootPart.CFrame
        local pos = SD.SavedCF.Position
        pcall(function() game.StarterGui:SetCore("SendNotification", {Title = "NaziDLC - Точка сохранена", Text = string.format("Координаты:\nX: %.1f\nY: %.1f\nZ: %.1f", pos.X, pos.Y, pos.Z), Duration = 5}) end)
    end
end)
SDF:Toggle("Auto Jump (Авто Фарм)", false, function(s) SD.AutoJump = s end)

local function GetBestTargetPart(char)
    local head = char:FindFirstChild("Head")
    local torso = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    local function checkVis(part)
        if not part then return false end
        if not Aim.Wall then return true end
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {LP.Character, char}
        params.FilterType = Enum.RaycastFilterType.Exclude
        return workspace:Raycast(Cam.CFrame.Position, part.Position - Cam.CFrame.Position, params) == nil
    end
    if checkVis(head) then return head end
    if checkVis(torso) then return torso end
    if not Aim.Wall then return head end
    return nil
end

local function GetTarget()
    if not Aim.On then return nil end
    local cDist, tgt, cCenter, cPos = Aim.FOV, nil, Cam.ViewportSize/2, Cam.CFrame.Position
    for _, p in next, Players:GetPlayers() do
        if p ~= LP and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local bestPart = GetBestTargetPart(p.Character)
            if bestPart and (bestPart.Position - cPos).Magnitude <= Aim.Dist then
                local pos, vis = Cam:WorldToViewportPoint(bestPart.Position)
                if vis then
                    local dist = (Vector2.new(pos.X, pos.Y) - cCenter).Magnitude
                    if dist < cDist then cDist, tgt = dist, bestPart end
                end
            end
        end
    end
    return tgt
end

local AimF = Elements:Feature("Aimbot", function(s)
    Aim.On = s
    FOVFrame.Visible = s and Aim.ShowFOV or false
end)
AimF:Toggle("Показывать круг FOV", false, function(s)
    Aim.ShowFOV = s
    FOVFrame.Visible = Aim.On and s or false
end)
AimF:Toggle("No Aim to wall", false, function(s) Aim.Wall = s end)
AimF:Slider("Размер FOV", 30, 400, 100, function(v) Aim.FOV = v; FOVFrame.Size = UDim2.new(0, v*2, 0, v*2) end)
AimF:Slider("Плавность", 1, 100, 50, function(v) Aim.Smooth = v/100 end)
AimF:Slider("Дистанция захвата", 50, 3000, 500, function(v) Aim.Dist = v end)

local TPF = Elements:Feature("TP Player (Телепорт)", function(s)
    ToggleTPMenu(s)
end)
TPF:Button("Открыть окно TP (👥)", function()
    ToggleTPMenu(true)
end)

local fbLoop
Elements:Feature("FullBright (Освещение)", function(s)
    if s then
        fbLoop = RS.RenderStepped:Connect(function() Lighting.Ambient = Color3.new(1,1,1); Lighting.Brightness = 2; Lighting.GlobalShadows = false end)
    else
        if fbLoop then fbLoop:Disconnect(); fbLoop = nil end
        Lighting.Ambient = Color3.fromRGB(127,127,127); Lighting.Brightness = 1; Lighting.GlobalShadows = true
    end
end)

local WBF = Elements:Feature("WallBright", function(s)
    WB.On = s
    task.spawn(function()
        if s then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Transparency < 1 and not v.Parent:FindFirstChild("Humanoid") then
                    if not WB.Orig[v] then WB.Orig[v] = {v.Transparency, v.Material} end
                    v.Transparency = WB.Trans; v.Material = Enum.Material.SmoothPlastic
                end
            end
        else
            for v, data in pairs(WB.Orig) do if v and v.Parent then v.Transparency = data[1]; v.Material = data[2] end end
            WB.Orig = {}
        end
    end)
end)
WBF:Slider("Прозрачность стен", 0, 100, 50, function(v) WB.Trans = v/100; if WB.On then for p, _ in pairs(WB.Orig) do if p and p.Parent then p.Transparency = WB.Trans end end end end)

local DW = {}
local function ApplyChamsToChar(char)
    if not char then return end
    local hl = char:FindFirstChild("EvoChams")
    if not hl then
        hl = Instance.new("Highlight")
        hl.Name = "EvoChams"; hl.FillColor = C_PR; hl.OutlineColor = Color3.new(1,1,1); hl.FillTransparency = 0.5; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent = char
    end
    hl.Enabled = ESP.Chams
end

local function CreateUIESP(p)
    if p == LP then return end
    local mainFrame = Make("Frame", {BackgroundTransparency = 1, Visible = false, Parent = ESPFolder})
    local box = Make("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), Visible = true, Parent = mainFrame})
    local stroke = Make("UIStroke", {Color = C_PR, Thickness = 1.5, Parent = box})
    RegisterElement("Strokes", stroke)
    
    local name = Make("TextLabel", {Size = UDim2.new(1,0,0,15), Position = UDim2.new(0,0,0,-16), BackgroundTransparency = 1, Text = p.Name, TextColor3 = C_PR, Font = GB, TextSize = 11, Parent = mainFrame})
    RegisterElement("Texts", name)
    
    local dist = Make("TextLabel", {Size = UDim2.new(1,0,0,15), Position = UDim2.new(0,0,1,2), BackgroundTransparency = 1, TextColor3 = C_PR, Font = G, TextSize = 10, Parent = mainFrame})
    RegisterElement("Texts", dist)
    
    local hpBg = Make("Frame", {Size = UDim2.new(0,3,1,0), Position = UDim2.new(0,-6,0,0), BackgroundColor3 = Color3.new(0,0,0), BorderSizePixel = 0, Parent = mainFrame})
    local hpBar = Make("Frame", {Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.new(0,1,0), BorderSizePixel = 0, Parent = hpBg})
    local tracer = Make("Frame", {AnchorPoint = Vector2.new(0.5,0.5), BackgroundColor3 = C_PR, BorderSizePixel = 0, Visible = false, Parent = ESPFolder})
    RegisterElement("Fills", tracer)
    
    DW[p] = {Frame = mainFrame, BoxFrame = box, BoxStroke = stroke, Name = name, Dist = dist, HpBg = hpBg, HpBar = hpBar, Tracer = tracer}
    if p.Character then task.wait(0.2); ApplyChamsToChar(p.Character) end
    p.CharacterAdded:Connect(function(c) task.wait(0.2); ApplyChamsToChar(c) end)
end

for _, p in next, Players:GetPlayers() do CreateUIESP(p) end
Players.PlayerAdded:Connect(CreateUIESP)
Players.PlayerRemoving:Connect(function(p) if DW[p] then DW[p].Frame:Destroy(); DW[p].Tracer:Destroy(); DW[p] = nil end end)

local EspF = Elements:Feature("ESP (Визуалы)", function(s) ESP.Master = s end)
EspF:Toggle("Boxes (Обводка)", true, function(s) ESP.Box = s end)
EspF:Toggle("Names (Имена)", true, function(s) ESP.Name = s end)
EspF:Toggle("Distance (Дистанция)", true, function(s) ESP.Dist = s end)
EspF:Toggle("Health Bar (Здоровье)", true, function(s) ESP.HP = s end)
EspF:Toggle("Tracers (Линии)", false, function(s) ESP.Tracers = s end)
EspF:Toggle("Chams (Подсветка)", false, function(s)
    ESP.Chams = s
    for _, p in next, Players:GetPlayers() do if p ~= LP and p.Character then local hl = p.Character:FindFirstChild("EvoChams"); if hl then hl.Enabled = s else if s then ApplyChamsToChar(p.Character) end end end end
end)

RS.RenderStepped:Connect(function()
    if Aim.On then local tgt = GetTarget(); if tgt then Cam.CFrame = Cam.CFrame:Lerp(CFrame.new(Cam.CFrame.Position, tgt.Position), Aim.Smooth) end end
    for _, p in next, Players:GetPlayers() do
        if p ~= LP then
            local d = DW[p]; if not d then continue end
            local char, show = p.Character, false
            if char then local hl = char:FindFirstChild("EvoChams"); if hl then hl.Enabled = ESP.Chams; if ESP.Chams then hl.FillColor = C_PR end end end
            if (ESP.Master or ESP.Tracers) and char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local hrp, head, hum = char.HumanoidRootPart, char.Head, char.Humanoid
                local topPos, topVis = Cam:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0))
                local bottomPos, bottomVis = Cam:WorldToViewportPoint(hrp.Position - Vector3.new(0,3,0))
                local hrpPos, hrpVis = Cam:WorldToViewportPoint(hrp.Position)
                if topVis and bottomVis then
                    show = true
                    local height = bottomPos.Y - topPos.Y; local width = height / 1.5
                    if ESP.Master then
                        d.Frame.Position = UDim2.new(0, topPos.X - width/2, 0, topPos.Y); d.Frame.Size = UDim2.new(0, width, 0, height)
                        d.BoxFrame.Visible = ESP.Box; d.BoxStroke.Color = C_PR
                        d.Name.Visible = ESP.Name; d.Name.TextColor3 = C_PR; d.Name.Text = string.lower(p.Name)
                        if ESP.Dist and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                            d.Dist.Text = tostring(math.floor((LP.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)) .. "m"
                            d.Dist.TextColor3 = C_PR; d.Dist.Visible = true
                        else d.Dist.Visible = false end
                        d.HpBg.Visible = ESP.HP
                        local hpRatio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        d.HpBar.Size = UDim2.new(1, 0, hpRatio, 0); d.HpBar.Position = UDim2.new(0, 0, 1 - hpRatio, 0); d.HpBar.BackgroundColor3 = Color3.fromHSV(hpRatio * 0.3, 1, 1)
                        d.Frame.Visible = true
                    else d.Frame.Visible = false end
                    if ESP.Tracers and hrpVis then
                        local startPos, targetPos = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y), Vector2.new(hrpPos.X, hrpPos.Y)
                        d.Tracer.Size = UDim2.new(0, (targetPos - startPos).Magnitude, 0, 1.5)
                        d.Tracer.Position = UDim2.new(0, (startPos.X + targetPos.X)/2, 0, (startPos.Y + targetPos.Y)/2)
                        d.Tracer.Rotation = math.deg(math.atan2(targetPos.Y - startPos.Y, targetPos.X - startPos.X))
                        d.Tracer.BackgroundColor3 = C_PR; d.Tracer.Visible = true
                    else d.Tracer.Visible = false end
                end
            end
            if not show then d.Frame.Visible = false; d.Tracer.Visible = false end
        end
    end
end)

RS.Heartbeat:Connect(function()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hum then
        if CharMods.SpdHack then hum.WalkSpeed = CharMods.WalkSpeed end
        if CharMods.JmpHack then hum.UseJumpPower = true; hum.JumpPower = CharMods.JmpPwr end
        if SD.AutoJump then
            local s = hum:GetState()
            if s ~= Enum.HumanoidStateType.Jumping and s ~= Enum.HumanoidStateType.Freefall then hum:ChangeState(Enum.HumanoidStateType.Jumping); hum.Jump = true end
        end
    end
    if SD.On and SD.SavedCF and hrp and (hrp.Position - SD.SavedCF.Position).Magnitude > 25 then hrp.CFrame = SD.SavedCF end
end)

local FlyConn, FlyAttach, FlyVel, FlyGyro
local function CleanFly()
    if FlyConn then FlyConn:Disconnect(); FlyConn = nil end
    if FlyAttach then FlyAttach:Destroy(); FlyAttach = nil end
    if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        hum.PlatformStand = false; hum:ChangeState(Enum.HumanoidStateType.Freefall)
    end
end

local FlyF = Elements:Feature("Fly (Полет)", function(s)
    CharMods.Fly = s
    local char = LP.Character; local hum = char and char:FindFirstChildOfClass("Humanoid"); local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if s and hum and hrp then
        CleanFly(); hum.PlatformStand = true
        FlyAttach = Make("Attachment", {Parent = hrp})
        FlyVel = Make("LinearVelocity", {Attachment0 = FlyAttach, MaxForce = math.huge, VectorVelocity = Vector3.zero, RelativeTo = Enum.ActuatorRelativeTo.World, Parent = FlyAttach})
        FlyGyro = Make("AlignOrientation", {Attachment0 = FlyAttach, Mode = Enum.OrientationAlignmentMode.OneAttachment, MaxTorque = math.huge, MaxAngularVelocity = math.huge, Responsiveness = 200, CFrame = hrp.CFrame, Parent = FlyAttach})
        FlyConn = RS.RenderStepped:Connect(function()
            if not char or not hum or not hrp or hum.Health <= 0 then CleanFly(); return end
            local camCF, dir = workspace.CurrentCamera.CFrame, hum.MoveDirection
            if dir.Magnitude > 0 then
                local flatLook = (camCF.LookVector * Vector3.new(1,0,1)).Unit
                local flatRight = (camCF.RightVector * Vector3.new(1,0,1)).Unit
                local move3D = (camCF.LookVector * dir:Dot(flatLook)) + (camCF.RightVector * dir:Dot(flatRight))
                FlyVel.VectorVelocity = move3D.Magnitude > 0 and move3D.Unit * CharMods.FlySpd or Vector3.zero
            else FlyVel.VectorVelocity = Vector3.zero end
            FlyGyro.CFrame = CFrame.lookAt(Vector3.zero, camCF.LookVector)
        end)
    else CleanFly() end
end)
FlyF:Slider("Скорость полета", 10, 2000, 50, function(v) CharMods.FlySpd = v end)

local NoclipConn
Elements:Feature("Noclip (Сквозь стены)", function(s)
    CharMods.Noclip = s
    if s then
        if NoclipConn then NoclipConn:Disconnect() end
        NoclipConn = RS.Stepped:Connect(function() if CharMods.Noclip and LP.Character then for _, part in ipairs(LP.Character:GetDescendants()) do if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end end end end)
    else
        if NoclipConn then NoclipConn:Disconnect(); NoclipConn = nil end
        if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Freefall) end
    end
end)

local FlingVars = {Active = false, Loop = nil, Gyro = nil, BAV = nil, BV = nil}

local function StopRealFling()
    FlingVars.Active = false
    if FlingVars.Loop then FlingVars.Loop:Disconnect(); FlingVars.Loop = nil end
    if FlingVars.Gyro then FlingVars.Gyro:Destroy(); FlingVars.Gyro = nil end
    if FlingVars.BAV then FlingVars.BAV:Destroy(); FlingVars.BAV = nil end
    if FlingVars.BV then FlingVars.BV:Destroy(); FlingVars.BV = nil end
    
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.AutoRotate = true
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Massless = false
                part.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5, 1, 1)
            end
        end
    end
end

local function StartRealFling()
    StopRealFling()
    FlingVars.Active = true
    
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    hum.AutoRotate = false 
    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)

    FlingVars.Gyro = Instance.new("BodyGyro")
    FlingVars.Gyro.Name = "PostureCheck"
    FlingVars.Gyro.MaxTorque = Vector3.new(math.huge, 0, math.huge)
    FlingVars.Gyro.P = 100000
    FlingVars.Gyro.CFrame = CFrame.new() 
    FlingVars.Gyro.Parent = hrp

    FlingVars.BAV = Instance.new("BodyAngularVelocity")
    FlingVars.BAV.Name = "Spin"
    FlingVars.BAV.MaxTorque = Vector3.new(0, math.huge, 0)
    FlingVars.BAV.AngularVelocity = Vector3.new(0, 15000, 0)
    FlingVars.BAV.Parent = hrp

    FlingVars.BV = Instance.new("BodyVelocity")
    FlingVars.BV.Name = "WalkForce"
    FlingVars.BV.MaxForce = Vector3.new(math.huge, 0, math.huge)
    FlingVars.BV.Velocity = Vector3.zero
    FlingVars.BV.Parent = hrp

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0, 0, 1, 1) 
            if part.Name ~= "HumanoidRootPart" then
                part.Massless = true
            end
        end
    end

    FlingVars.Loop = RS.Heartbeat:Connect(function()
        if not FlingVars.Active or not hum or not hrp then return end
        
        FlingVars.BV.Velocity = hum.MoveDirection * hum.WalkSpeed
        FlingVars.BAV.AngularVelocity = Vector3.new(0, 15000, 0)
        
        hrp.RotVelocity = Vector3.new(0, 15000, 0)
        hrp.AssemblyAngularVelocity = Vector3.new(0, 15000, 0)
        
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end)
end

Elements:Feature("Fling (Смертельное торнадо)", function(s)
    CharMods.Fling = s
    if s then
        StartRealFling()
        pcall(function() game.StarterGui:SetCore("SendNotification", {Title = "NaziDLC - Fling", Text = "- ПИЗДА ВСЕМУ СЕРВЕРУ НАХУЙ РАЗНОСИ ПИДОРОВ", Duration = 5}) end)
    else
        StopRealFling()
        pcall(function() game.StarterGui:SetCore("SendNotification", {Title = "NaziDLC - Fling", Text = "Fling ВЫКЛЮЧЕН", Duration = 3}) end)
    end
end)

local SpdF = Elements:Feature("SpeedHack", function(s) CharMods.SpdHack = s; if not s and LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then LP.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16 end end)
SpdF:Slider("Скорость бега", 16, 2000, 16, function(v) CharMods.WalkSpeed = v end)

local JmpF = Elements:Feature("JumpHack", function(s) CharMods.JmpHack = s; if not s and LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then local hum = LP.Character:FindFirstChildOfClass("Humanoid"); hum.UseJumpPower = true; hum.JumpPower = 50 end end)
JmpF:Slider("Сила прыжка", 50, 1000, 50, function(v) CharMods.JmpPwr = v end)

Elements:Feature("Infinite Jump", function(s) CharMods.InfJmp = s end)
UIS.JumpRequest:Connect(function() if CharMods.InfJmp and LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping) end end)

LP.CharacterAdded:Connect(function() 
    task.wait(0.7)
    if CharMods.Fly then CharMods.Fly = false; task.wait(0.1); CharMods.Fly = true end
    if CharMods.Fling then CharMods.Fling = false; StopRealFling() end 
end)
