local Core = Mek91_ML.Core
local StringPrefix = "Mek91ML: "

Citizen.CreateThread(function()
    if Mek91_ML.AddItem then Mek91_ML.AddItem() end

    for key, Add in pairs(Mek91_ML.Fields) do
        Mek91_ML.AddJob(Add.Job, Add.JobName, Add.JobLabel, Add.Payment)
    end
end)

RegisterServerEvent("Mek91ML:Client:OpenML", function()
    PlayerId = source
    TriggerClientEvent("Mek91ML:Client:OpenMoneyLaunderMenu", PlayerId, PlayerId)
end)

RegisterServerEvent("Mek91ML:Server:GiveMoney", function(Job, Percent, MoneytoReceive, LaunderedMoney)
    local PlayerId = source

    Mek91_ML.DeletePlayerBlackMoney(PlayerId, LaunderedMoney, Core)
    Mek91_ML.GiveMoney(PlayerId, MoneytoReceive, Core)
    Mek91_ML.SendNotification(PlayerId, Mek91_ML.Language.YourMoneyPaid, "SV", Core)
    Mek91MLWebhookSender(PlayerId, Job, Percent, LaunderedMoney, MoneytoReceive)
end)

function Mek91MLWebhookSender(PlayerId, Job, Percent, LaunderedMoney, MoneyReceived)
    local Identifiers = Mek91MLPlayerInfo(PlayerId)

    if Identifiers.name == nil and Identifiers.steam == nil and Identifiers.discord == nil and Identifiers.license == nil and Identifiers.xbl == nil and Identifiers.live == nil and Identifiers.ip == nil then
        return
    end
    
    local msg = {
        {
            ["color"] = Mek91_ML.DiscordColor,
            ["title"] = StringPrefix ..Mek91_ML.Language.Title,
            ["url"] = "https://youtube.com/@mek91",
            ['author'] = {
                ['name'] = 'Mek91 Money Laundering', 
                ['icon_url'] = 'https://cdn.discordapp.com/attachments/1084868011871183008/1084868083233075240/mekMiniLogo.png'
            },
            ["fields"] = {
                {["name"] = Mek91_ML.Language.BlackMoneyInfo, ["value"] = "", ["inline"] = false},
                {["name"] = Mek91_ML.Language.Job, ["value"] = Job, ["inline"] = false},
                {["name"] = Mek91_ML.Language.Percent, ["value"] = "%"..Percent * 100, ["inline"] = false},
                {["name"] = Mek91_ML.Language.LaunderedMoney, ["value"] = LaunderedMoney.."$", ["inline"] = false},
                {["name"] = Mek91_ML.Language.MoneyReceived, ["value"] = MoneyReceived.."$", ["inline"] = false},
                {["name"] = Mek91_ML.Language.PlayerInfo, ["value"] = "", ["inline"] = false},
                {["name"] = Mek91_ML.Language.PlayerId, ["value"] = PlayerId, ["inline"] = false},
                {["name"] = Mek91_ML.Language.Name, ["value"] = Identifiers.name or "N/A", ["inline"] = false},
                {["name"] = Mek91_ML.Language.Steam, ["value"] = Identifiers.steam or "N/A", ["inline"] = false},
                {["name"] = Mek91_ML.Language.Discord, ["value"] = Identifiers.discord and ("<@!"..Identifiers.discord:gsub("discord:", "")..">\n" .. Identifiers.discord:gsub("discord:", "")) or "N/A", ["inline"] = false},
                {["name"] = Mek91_ML.Language.License, ["value"] = Identifiers.license or "N/A", ["inline"] = false},
                {["name"] = Mek91_ML.Language.Xbox, ["value"] = Identifiers.xbl or "N/A", ["inline"] = false},
                {["name"] = Mek91_ML.Language.Live, ["value"] = Identifiers.live or "N/A", ["inline"] = false},
                {["name"] = Mek91_ML.Language.Ip, ["value"] = Identifiers.ip or "N/A", ["inline"] = false},
            },
            ["footer"] = {["text"] = "dev. 'Mek91#9959 | youtube.com/@mek91"},
            ['timestamp'] = os.date('!%Y-%m-%dT%H:%M:%SZ')
        }}
    PerformHttpRequest(Mek91_ML.DiscordWebhook, function(err, text, headers) end, 'POST', json.encode({username = Mek91_ML.DiscordWebhookName, avatar_url = Mek91_ML.DiscordWebhookAvatarUrl, embeds = msg}), { ['Content-Type'] = 'application/json' })
end

function Mek91MLPlayerInfo(PlayerId)
    local Identifiers = {}

    for i = 0, GetNumPlayerIdentifiers(PlayerId) - 1 do
        local id = GetPlayerIdentifier(PlayerId, i)

        if string.find(id, "steam") then
            Identifiers['steam'] = id
        elseif string.find(id, "discord") then
            Identifiers['discord'] = id
        elseif string.find(id, "license") then
            Identifiers['license'] = id
        elseif string.find(id, "xbl") then
            Identifiers['xbl'] = id
        elseif string.find(id, "live") then
            Identifiers['live'] = id
        end
    end

    local playerName = GetPlayerName(PlayerId)
    if playerName ~= nil then
        Identifiers['name'] = playerName
    end

    local ip = GetPlayerEndpoint(PlayerId)
    if ip ~= nil then
        Identifiers['ip'] = ip
    end

    return Identifiers
end