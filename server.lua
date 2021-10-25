ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Config = {}
Config.JobTrigger = {
  {
  name = {"police", "sherif"},  -- This is a list of jobs, which are allowed to use this event
  tname = "esx_policejob:handcuff", -- This is the event name !! IMPORTANT ONLY SERVERSIDE EVENTS !!
  whook = "YOURWEBHOOK",    --!!!! If you don't need a webhook, just keep DEINWEBHOOKHIER !!!!
  },
  {
  name = {"police", "sherif"},
  tname = "esx_policejob:requestarrest",
  whook = "YOURWEBHOOK",
  }
}

Citizen.CreateThread(function()
    local status
    for _, trigger in ipairs(Config.JobTrigger) do
        AddEventHandler(trigger.tname, function()
            local xPlayer = ESX.GetPlayerFromId(source)
            for k, v in ipairs(trigger.name) do
                if xPlayer.job.name ~= v then
                    status = false
                else
                    status = true
                    break
                end
            end
            if not status then
                if trigger.whook ~= "DEINWEBHOOKHIER" then
                    DCLog(trigger.whook, trigger.tname, trigger.tname.." wurde von " .. GetPlayerName(source) .. "[" ..source.. "] ausgelöst")
                end
                -- PLACER YOUR PLAYER-BAN EVENT HERE --
            end
        end)
    end
end)

function DCLog(webhook, eventname, message)
    if webhook ~= nil then
        local connect = {
            {
                ["color"] = 13632027,
                ["footer"] = {
                    ["text"] = os.date("%c")
                },
                ["author"] = {
                    ["name"] = "Trigger-Logger",
                    ["icon_url"] = "https://forum.cfx.re/user_avatar/forum.cfx.re/kattrigerkatta/45/693796_2.png"
                },
                ["fields"] = {
                    {
                        ["name"] = "Info:",
                        ["value"] =  message,
                        ["inline"] = false
                    },
                }
            }
        }
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = 'Event-Logger', embeds = connect}), { ['Content-Type'] = 'application/json' })
    end
end
