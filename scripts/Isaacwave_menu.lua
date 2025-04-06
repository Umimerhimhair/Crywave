local IWC = Isaac.GetChallengeIdByName("Isaacwave!")

local IsaacWaveMenuX = 3.75
local IsaacWaveMenuY = IsaacWaveMenuX
local MENU_CHANGE_NOW = 0.05
local MENU_SCALE_ADD_PER_TICK = 0.2
local MENU_SCALE_REMOVE_PER_TICK = -0.05

local BUTTON_SELECT_COOLDOWN = 5

local BETWEEN_SCREEN_LENGTH = 5

local CHALLENGE1_COMPLETION_TIME = 30 * 4

local font = Font()

local function postGameStarted()
    if Isaac.GetChallenge() == IWC then
        local player = Isaac.GetPlayer()
        local data = player:GetData()
        Game():GetLevel():SetStage(2, 0)
        data.IsaacwaveMenu = true
        data.SelectedMenuButton = 1
        data.ShouldBeVisible = false
        Game():GetHUD():SetVisible(false)
    end
end
Isaacwave:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, postGameStarted)

local function onRender()
    local player = Isaac.GetPlayer()
    local data = player:GetData()

    if data.IsaacwaveMenu then
        local YRenderPos = Isaac.GetScreenHeight()/20

        local menuIsaacwaveString = "Isaacwave!"
        local menuStartString = "Start"
        local menuOptionsString = "Options"
        local menuStatsString = "Stats"

        font:Load("font/pftempestasevencondensed.fnt")
        
        local menuButtonTranslation = {
            [1] = "start",
            [2] = "options",
            [3] = "stats"
        }
        
        font:DrawStringScaled(menuIsaacwaveString, Isaac.GetScreenWidth()/2, YRenderPos * 0.5, IsaacWaveMenuX, IsaacWaveMenuY, KColor(255, 255, 255, 255), 1, true)
        
        if menuButtonTranslation[data.SelectedMenuButton] ~= "start" then
            font:DrawStringScaled(menuStartString, Isaac.GetScreenWidth()/2, YRenderPos * 6, 1, 1, KColor(255, 255 , 255, 255), 1, true)
        else
            font:DrawStringScaled(menuStartString, Isaac.GetScreenWidth()/2, YRenderPos * 6, 1, 1, KColor(255, 255 , 0, 255), 1, true)
        end
        
        if menuButtonTranslation[data.SelectedMenuButton] ~= "options" then
            font:DrawStringScaled(menuOptionsString, Isaac.GetScreenWidth()/2, YRenderPos * 7.5, 1, 1, KColor(255, 255 , 255, 255), 1, true)
        else
            font:DrawStringScaled(menuOptionsString, Isaac.GetScreenWidth()/2, YRenderPos * 7.5, 1, 1, KColor(255, 255 , 0, 255), 1, true)
        end
        
        if menuButtonTranslation[data.SelectedMenuButton] ~= "stats" then
            font:DrawStringScaled(menuStatsString, Isaac.GetScreenWidth()/2, YRenderPos * 9, 1, 1, KColor(255, 255 , 255, 255), 1, true)
        else
            font:DrawStringScaled(menuStatsString, Isaac.GetScreenWidth()/2, YRenderPos * 9, 1, 1, KColor(255, 255 , 0, 255), 1, true)
        end
    end

    if data.Minigame then
        if data.Minigame.BetweenScreen then
            data.Hearts.Heart1.Sprite:Load("gfx/effect_005_fire.anm2", true)
            data.Hearts.Heart2.Sprite:Load("gfx/effect_005_fire.anm2", true)
            data.Hearts.Heart3.Sprite:Load("gfx/effect_005_fire.anm2", true)
            data.Hearts.Heart4.Sprite:Load("gfx/effect_005_fire.anm2", true)

            if data.Hearts.Heart1.Sprite:GetAnimation() ~= "Idle" then
                data.Hearts.Heart1.Sprite:Play("Idle", true)
            end
            if data.Hearts.Heart2.Sprite:GetAnimation() ~= "Idle" then
                data.Hearts.Heart2.Sprite:Play("Idle", true)
            end
            if data.Hearts.Heart3.Sprite:GetAnimation() ~= "Idle" then
                data.Hearts.Heart3.Sprite:Play("Idle", true)
            end
            if data.Hearts.Heart4.Sprite:GetAnimation() ~= "Idle" then
                data.Hearts.Heart4.Sprite:Play("Idle", true)
            end
            data.Hearts.Heart1.Sprite:Render(Vector(Isaac.GetScreenWidth()/5 * 1, Isaac.GetScreenHeight()/20 * 15))
            data.Hearts.Heart2.Sprite:Render(Vector(Isaac.GetScreenWidth()/5 * 2, Isaac.GetScreenHeight()/20 * 15))
            data.Hearts.Heart3.Sprite:Render(Vector(Isaac.GetScreenWidth()/5 * 3, Isaac.GetScreenHeight()/20 * 15))
            data.Hearts.Heart4.Sprite:Render(Vector(Isaac.GetScreenWidth()/5 * 4, Isaac.GetScreenHeight()/20 * 15))
        end

        if data.Minigame.CompletionTime then
            font:DrawString(data.Minigame.CompletionTime, Isaac.GetScreenWidth()/2, Isaac.GetScreenHeight()/40, KColor(255, 255, 255, 255), 1, true)
        end
    end
end
Isaacwave:AddCallback(ModCallbacks.MC_POST_RENDER, onRender)

local function onUpdate()
    local player = Isaac.GetPlayer()
    local data = player:GetData()
    if player:IsVisible() ~= data.ShouldBeVisible then
        player.Visible = data.ShouldBeVisible
    end
    if not player:IsVisible() then
        player:AddControlsCooldown(2)
    end
    if Isaac.GetChallenge() == IWC then
        Game():Darken(0, 1)
    end
    if data.IsaacwaveMenu then
        if not data.ButtonSelectCooldown then
            data.ButtonSelectCooldown = 0
        end

        Game():GetRoom():SetBackdropType(BackdropType.LIBRARY, 1)

        for i = 0, 8 do
            Game():GetRoom():RemoveDoor(i)
        end

        IsaacWaveMenuX = IsaacWaveMenuX + MENU_CHANGE_NOW
        if IsaacWaveMenuX >=  4.25 then
            MENU_CHANGE_NOW = MENU_SCALE_REMOVE_PER_TICK
        end
        if IsaacWaveMenuX <= 3.75 then
            MENU_CHANGE_NOW = MENU_SCALE_ADD_PER_TICK
        end
        IsaacWaveMenuY = IsaacWaveMenuX

        if not data.SelectedMenuButton then
            data.SelectedMenuButton = 1
        end

        if data.ButtonSelectCooldown > 0 then
            data.ButtonSelectCooldown = data.ButtonSelectCooldown - 1
        end

        if Input.IsActionPressed(ButtonAction.ACTION_DOWN, player.Index) and data.ButtonSelectCooldown == 0 then
            data.ButtonSelectCooldown = BUTTON_SELECT_COOLDOWN
            data.SelectedMenuButton = data.SelectedMenuButton + 1
        end
        if data.SelectedMenuButton < 1 then
            data.SelectedMenuButton = 1
        end
        if Input.IsActionPressed(ButtonAction.ACTION_UP, player.Index) and data.ButtonSelectCooldown == 0 then
            data.ButtonSelectCooldown = BUTTON_SELECT_COOLDOWN
            data.SelectedMenuButton = data.SelectedMenuButton - 1
        end
        if data.SelectedMenuButton > 3 then
            data.SelectedMenuButton = 3
        end
        
        local menuButtonTranslation = {
            [1] = "start",
            [2] = "options",
            [3] = "stats"
        }

        if Input.IsActionPressed(ButtonAction.ACTION_ITEM, player.Index) then
            if menuButtonTranslation[data.SelectedMenuButton] == "start" then
                data.IsaacwaveMenu = false
                data.Minigame = {}
                data.Minigame.BetweenScreen = true
            end

            if menuButtonTranslation[data.SelectedMenuButton] == "options" then
                
            end

            if menuButtonTranslation[data.SelectedMenuButton] == "stats" then
                
            end
        end

    end

    if data.Minigame then
        if data.Minigame.BetweenScreen then
            data.ShouldBeVisible = false
            if not data.Minigame.BetweenScreenTimer then
                data.Minigame.BetweenScreenTimer = 30 * BETWEEN_SCREEN_LENGTH
            end
            if data.Minigame.BetweenScreenTimer > 0 then
                data.Minigame.BetweenScreenTimer = data.Minigame.BetweenScreenTimer - 1
            end

            if data.Minigame.BetweenScreenTimer == 0 then
                data.Minigame.BetweenScreen = false
                data.Minigame.BetweenScreenTimer = nil
                data.Minigame.Waving = true
            end

            if not data.Hearts then
                data.Hearts = {}
                data.Hearts.Heart1 = {}
                data.Hearts.Heart2 = {}
                data.Hearts.Heart3 = {}
                data.Hearts.Heart4 = {}

                data.Hearts.Heart1.Sprite = Sprite()
                data.Hearts.Heart2.Sprite = Sprite()
                data.Hearts.Heart3.Sprite = Sprite()
                data.Hearts.Heart4.Sprite = Sprite()
            end
        end

        if data.Minigame.Waving then
            data.ShouldBeVisible = true
            if data.Minigame.Challenge == 0 then
                data.Minigame.ChallengeStarted = false
            end

            if not data.Minigame.WavingChallengeSelected then
                data.Minigame.WavingChallengeSelected = math.random(1, 1)
            end

            data.Minigame.Challenge = data.Minigame.WavingChallengeSelected

            if data.Minigame.Challenge then
                if not data.Minigame.ChallengeStarted then
                    data.Minigame.ChallangeFailed = true
                end

                if data.Minigame.CompletionTime then
                    if data.Minigame.CompletionTime > 0 then
                        data.Minigame.CompletionTime = data.Minigame.CompletionTime - 1
                    end
                    
                    if data.Minigame.CompletionTime == 0 then
                        for _, entity in ipairs(Isaac.GetRoomEntities()) do
                            if entity.Type ~= EntityType.ENTITY_PLAYER then
                                entity:Remove()
                            end
                        end
                        data.Minigame.Waving = false
                        data.Minigame.BetweenScreen = true
                    end
                end

                if not data.Minigame.ChallengeStarted then
                    if data.Minigame.Challenge == 1 then
                        data.Minigame.CompletionTime = CHALLENGE1_COMPLETION_TIME
                        player.Position = Game():GetRoom():GetCenterPos()
                        Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Vector(player.Position.X + 100, player.Position.Y), Vector.Zero, nil, CoinSubType.COIN_PENNY, player.InitSeed)
                        Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Vector(player.Position.X - 100, player.Position.Y), Vector.Zero, nil, CoinSubType.COIN_DIME, player.InitSeed)
                        Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, Vector(player.Position.X, player.Position.Y + 100), Vector.Zero, nil, BombSubType.BOMB_GOLDEN, player.InitSeed)
                        Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, Vector(player.Position.X, player.Position.Y - 100), Vector.Zero, nil, KeySubType.KEY_GOLDEN, player.InitSeed)
                    end
                    data.Minigame.ChallengeStarted = true
                end
            end
        end
    end
end
Isaacwave:AddCallback(ModCallbacks.MC_POST_UPDATE, onUpdate)

---@param pickup EntityPickup
---@param collider Entity
local function Challenge1(_, pickup, collider)
    local player = Isaac.GetPlayer()
    local data = player:GetData()
    if data.Minigame then
        if data.Minigame.Challenge then
            if data.Minigame.Challenge == 1 then
                if pickup.Variant == PickupVariant.PICKUP_COIN and pickup.SubType == CoinSubType.COIN_PENNY and collider.Type == EntityType.ENTITY_PLAYER and data.Minigame.CompletionTime > 0 then
                    data.Minigame.ChallangeFailed = false
                end
            end
        end
    end
end
Isaacwave:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, Challenge1)