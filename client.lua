local QBCore = exports['qb-core']:GetCoreObject()
local acik = false
local cam = nil
local locale = Config.Locale

local function UpdateCamera()
    if cam then
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local heading = GetEntityHeading(ped)
        local boneIndex = 60309
        local boneCoords = GetPedBoneCoords(ped, boneIndex, -0.6, 0.0, 0.0)
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            if vehicle and vehicle ~= 0 then
                local vehicleCoords = GetEntityCoords(vehicle)
                local minDim, maxDim = GetModelDimensions(GetEntityModel(vehicle))
                local vehicleLength = maxDim.y - minDim.y
                local cameraOffset = vehicleLength * 0.6
                AttachCamToEntity(cam, vehicle, Config.CamRot.x-1.0, cameraOffset, Config.CamRot.z+0.2, true)
                PointCamAtCoord(cam, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z)
            end
        else
            AttachCamToEntity(cam, ped, Config.CamRot.x, Config.CamRot.y, Config.CamRot.z, true)
            PointCamAtCoord(cam, coords.x, coords.y, coords.z)
        end
        local isOnScreen, screenX, screenY = GetScreenCoordFromWorldCoord(boneCoords.x, boneCoords.y, boneCoords.z)
        if isOnScreen then
            SendNUIMessage({
                type = "menu-pos",
                x = screenX,
                y = screenY
            })
        end
    end
end


local function CreateCamera()
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamFov(cam, Config.CamFov)
    SetCamUseShallowDofMode(cam, true)
    SetCamNearDof(cam, 0.1)
    SetCamFarDof(cam, 5.0)
    SetCamDofStrength(cam, 1.0)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, Config.EaseTime, true, true)
    CreateThread(function()
        while DoesCamExist(cam) do
            UpdateCamera()
            SetUseHiDof()
            Wait(0)  
        end
    end)
end

local function CreateCameraVehicle()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if not vehicle or vehicle == 0 then
        print("Araçta değilsiniz!")
        return
    end
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamFov(cam, Config.CamFov)
    local minDim, maxDim = GetModelDimensions(GetEntityModel(vehicle))
    local vehicleLength = maxDim.y - minDim.y
    local cameraOffset = vehicleLength * 0.6
    AttachCamToEntity(cam, vehicle, Config.CamRot.x-1.0, cameraOffset, Config.CamRot.z+0.2, true)
    local vehicleCoords = GetEntityCoords(vehicle)
    PointCamAtCoord(cam, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z)
    SetCamUseShallowDofMode(cam, true)
    SetCamNearDof(cam, 0.1)
    SetCamFarDof(cam, 5.0)
    SetCamDofStrength(cam, 1.0)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, Config.EaseTime, true, true)
    CreateThread(function()
        while DoesCamExist(cam) do
            SetUseHiDof()
            Wait(0)  
        end
    end)
end



local function PauseMenu()
    SetFrontendActive(0)
    local PlayerData = QBCore.Functions.GetPlayerData()
    SetNuiFocus(true, true)
    CreateCamera() 
    Wait(Config.EaseTime)

    local BoneCoords = GetPedBoneCoords(PlayerPedId(), 60309, -0.6, 0.0, 0.0)
    local isOnScreen, screenX, screenY = GetScreenCoordFromWorldCoord(BoneCoords.x, BoneCoords.y, BoneCoords.z) 
    SendNUIMessage({
        type = "pausemenu",
        x = screenX,
        y = screenY,
        locale = locale,
        name = PlayerData.charinfo.firstname.." "..PlayerData.charinfo.lastname
    })
end

local function CloseMenu()
    acik = false
    DestroyCam(cam)
    FreezeEntityPosition(PlayerPedId(), false)
    SetNuiFocus(false, false)
    SetCamActive(cam, false)
    RenderScriptCams(false, true, Config.EaseTime, true, true)
    SendNUIMessage({
        type = "closemenu"
    })
end

CreateThread(function()
    DisableIdleCamera(true)
    while true do 
            SetPauseMenuActive(false)
        if IsControlJustPressed(0, 200) or IsControlJustPressed(0, 199) then 
            if not acik then
                acik = true
                PauseMenu()
            end
        end
        Wait(0)
    end
end)

RegisterNUICallback('continue', function(data, cb)
    CloseMenu()
    cb('ok')
end)

RegisterNUICallback('map', function(data, cb)
    CloseMenu()
    Wait(100)
    ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_MP_PAUSE'), 0, -1)
    Wait(100)
    PauseMenuceptionGoDeeper(0)
    cb('ok')
end)

RegisterNUICallback('settings', function(data, cb)
    CloseMenu()
    ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_LANDING_MENU'),0,-1) 
    cb('ok')
end)

RegisterNUICallback('logout', function(data, cb)
    TriggerServerEvent("ns-pausemenuv2:quit")
    cb('ok')
end)

RegisterCommand(Config.FixMenuCommand, function()
    CloseMenu()
end)
