local Core = Mek91_ML.Core
local StringPrefix = "Mek91ML: "
local Event = "Mek91ML:Client:OpenML"
local Type = "server"
local PlayerId = 0

Citizen.CreateThread(function()
    for key, Field in pairs(Mek91_ML.Fields) do
        Mek91_ML.SetTarget(Field.Job, Field.TargetLocation, Field.TargetLabel, Event, Type, Field.Icon, Field.TargetMinZ, Field.TargetMaxZ)
    
        if Field.Blip then
            Mek91MLAddBlip(Field.BlipLocation, Field.BlipId, Field.BlipColorId, Field.BlipName, Field.BlipDisplay, Field.BlipScale)
        end
    end
end)

RegisterNetEvent("Mek91ML:Client:OpenMoneyLaunderMenu", function(PlyrId)
    PlayerId = PlyrId
    local PlayerJob = Mek91_ML.GetPlayerJob(PlayerId, Core)
    local PlayerBlackMoney = Mek91_ML.GetPlayerBlackMoney(PlayerId, Core)
    
    if Mek91MLGetJob(PlayerJob) then
        if PlayerBlackMoney == 0 then
            Mek91_ML.SendNotification(PlayerId, Mek91_ML.Language.BlackMoneyNotFound, "CL", Core)
            return
        end

        local PlayerPercent = Mek91MLGetPercent(PlayerJob)
        local MoneytoReceive = math.floor(tonumber(PlayerBlackMoney) * tonumber(PlayerPercent))

        Mek91_ML.OpenMenu(MoneytoReceive)
    else
        Mek91_ML.SendNotification(PlayerId, Mek91_ML.Language.JobNotFound, "CL", Core)
    end
end)

RegisterNetEvent("Mek91ML:Client:OpenBlackMoneySelectorMenu", function()
    local PlayerBlackMoney = Mek91_ML.GetPlayerBlackMoney(PlayerId, Core)

    Mek91_ML.OpenInput(PlayerId, PlayerBlackMoney, Core)
end)

RegisterNetEvent("Mek91ML:Client:SelectBlackMoney", function(SelectBlackMoney)
    local PlayerJob = Mek91_ML.GetPlayerJob(PlayerId, Core)
    local PlayerPercent = Mek91MLGetPercent(PlayerJob)
    local MoneytoReceive = math.floor(tonumber(SelectBlackMoney) * tonumber(PlayerPercent))

    TriggerServerEvent("Mek91ML:Server:GiveMoney", PlayerJob, PlayerPercent, MoneytoReceive, SelectBlackMoney)
end)

RegisterNetEvent("Mek91ML:Client:AllBlackMoney", function()
    local PlayerJob = Mek91_ML.GetPlayerJob(PlayerId, Core)
    local PlayerBlackMoney = Mek91_ML.GetPlayerBlackMoney(PlayerId, Core)
    local PlayerPercent = Mek91MLGetPercent(PlayerJob)
    local MoneytoReceive = math.floor(tonumber(PlayerBlackMoney) * tonumber(PlayerPercent))

    TriggerServerEvent("Mek91ML:Server:GiveMoney", PlayerJob, PlayerPercent, MoneytoReceive, PlayerBlackMoney)
end)

function Mek91MLGetJob(Job)
    local JobOkay = false

    for key, Percents in pairs(Mek91_ML.Fields) do
        if Percents.Job == Job then
            JobOkay = true
            break
        end
    end

    return JobOkay
end

function Mek91MLGetPercent(Job)
    local Percent = 0.0

    for key, Percents in pairs(Mek91_ML.Fields) do
        if Percents.Job == Job then
            Percent = Percents.Percent
            break
        end
    end
    
    return Percent
end

function Mek91MLAddBlip(BlipLocation, BlipId, BlipColorId, BlipName, BlipDisplay, BlipScale)
    local blip = AddBlipForCoord(BlipLocation.x, BlipLocation.y, 0.0)
    SetBlipSprite(blip, BlipId)
    SetBlipColour(blip, BlipColorId)
    SetBlipDisplay(blip, BlipDisplay)
    SetBlipScale(blip, BlipScale)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(BlipName)
    EndTextCommandSetBlipName(blip)
end