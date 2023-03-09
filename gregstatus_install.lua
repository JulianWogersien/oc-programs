local os = require("os")

os.execute("wget https://raw.githubusercontent.com/coolian1337/oc-programs/main/gregstatus/gregstatus.lua")
os.execute('gregstatus.lua >> /home/.shrc')
