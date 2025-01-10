local component = require("component")
local interface = component.me_interface
local db = component.database
local os = require("os")

while true do
    for slot = 1, 81 do
        db.clear(slot)
    end
    interface.store({}, db.address, 1)
    for i = 1, 9 do
        interface.setInterfaceConfiguration(i, db.address, i, 64)
    end

    os.sleep(0.2)
end
