local bigfont = require("bigfont")
local component = require("component")
local sensor = component.sensor
local gpu = component.gpu

local font_size = 5
bigfont.load(font_size)

local args = {...}

local r_x, r_y = gpu.getResolution()
local machine_name = args[1]

local function clear_screen()
    gpu.fill(1, 1, r_x, r_y, " ")
    bigfont.set(r_x / 10, 2, machine_name, font_size)
    --gpu.set(r_x / 4, 2, machine_name)
end

local x, y, z = 1, -2, 0

clear_screen()

local items = {}
local fluids = {}
local previtem_num = -1
local prevfluid_num = -1

while true do
    items = {}
    fluids = {}
    local status = sensor.scan(x, y, z)
    for k,v in pairs(status.data.items) do
        if type(v) == "table" then
            if v.name ~= "minecraft:air" then
                local item = {}
                item.label = v.label
                item.size = v.size
                items[#items + 1] = item
            end
        end
    end
    if status.data.fluid ~= nil then
        for k,v in pairs(status.data.fluid) do
            if type(v) == "table" then
                for k2,v2 in pairs(v) do
                    if type(v2) == "table" then
                        if v2.name ~= nil then
                            local fluid = {}
                            fluid.label = v2.label
                            fluid.amount = v2.amount
                            fluids[#fluids + 1] = fluid
                        end
                    end
                end
            end
        end
    end
    bigfont.set(r_x / 10, 2 + font_size, "Contents:", font_size)
    --gpu.set(r_x / 4, 4, "Contents:")
    if #items ~= previtem_num or #fluids ~= prevfluid_num then
        clear_screen()
        bigfont.set(r_x / 10, 6 + font_size, "  Items:", font_size)
        --gpu.set(r_x / 4, 6, "  Items:")
        for k,v in pairs(items) do
            bigfont.set(r_x / 10, 6 + font_size * k, "    " .. v.label .. " (" .. v.size .. ")", font_size)
            --gpu.set(r_x / 4, 6 + k, "    " .. v.label .. " (" .. v.size .. ")")
        end
        previtem_num = #items

        bigfont.set(r_x / 10, 8 + font_size + #items + 2, "  Fluids:", font_size)
        --gpu.set(r_x / 4, 6 + #items + 2, "  Fluids:")
        for k,v in pairs(fluids) do
            bigfont.set(r_x / 10, 8 + font_size + #items + 2 + k, "    " .. v.label .. " (" .. v.amount .. ")", font_size)
            --gpu.set(r_x / 4, 6 + #items + 2 + k, "    " .. v.label .. " (" .. v.amount .. ")")
        end
        prevfluid_num = #fluids
    end
    os.sleep(1)
end