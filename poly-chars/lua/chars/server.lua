require ("mysqloo")

polychars = polychars or {}

local DATABASE_HOST = "127.0.0.1"
local DATABASE_PORT = 3306
local DATABASE_NAME = "polytopia" 
local DATABASE_USERNAME = "root"
local DATABASE_PASSWORD = "root"   

function polychars.connectdb()

    databaseObject = mysqloo.connect(DATABASE_HOST, DATABASE_USERNAME, DATABASE_PASSWORD, DATABASE_NAME, DATABASE_PORT)
    // databaseObject.onConnected = function() print("Database linked!") end
    databaseObject.onConnectionFailed = function() print("Failed to connect to the database.") end
    databaseObject:connect()

end

polychars.connectdb()