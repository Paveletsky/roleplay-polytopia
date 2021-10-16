local net = net
local ErrorNoHalt = ErrorNoHalt
local pairs = pairs
local pcall = pcall
local type = type
local util = util
local _player = player
netstream = netstream or {}

local stored = netstream.stored or {}
netstream.stored = stored

local cache = netstream.cache or {}
netstream.cache = cache

if (DBugR) then
	DBugR.Profilers.Netstream = table.Copy(DBugR.SP)
	DBugR.Profilers.Netstream.CChan = ''
	DBugR.Profilers.Netstream.Name = 'Netstream'
	DBugR.Profilers.Netstream.Type = SERVICE_PROVIDER_TYPE_NET

	DBugR.Profilers.NetstreamPerf = table.Copy(DBugR.SP)
	DBugR.Profilers.NetstreamPerf.Name = 'Netstream'
	DBugR.Profilers.NetstreamPerf.Type = SERVICE_PROVIDER_TYPE_CPU
end

-- A function to split data for a data stream.
function netstream.Split(data)
	local index = 1
	local result = {}
	local buffer = {}

	for i = 0, string.len(data) do
		buffer[#buffer + 1] = string.sub(data, i, i)

		if (#buffer == 32768) then
			result[#result + 1] = table.concat(buffer)
				index = index + 1
			buffer = {}
		end
	end

	result[#result + 1] = table.concat(buffer)

	return result
end

--[[
	@codebase Shared
	@details A function to hook a data stream.
	@param String A unique identifier.
	@param Function The datastream callback.
--]]
function netstream.Hook(name, Callback)
	stored[name] = Callback
end

if (DBugR) then
	local oldDS = netstream.Hook

	for name, func in pairs(stored) do
		stored[name] = nil

		oldDS(name, DBugR.Util.Func.AttachProfiler(func, function(time)
			DBugR.Profilers.NetstreamPerf:AddPerformanceData(tostring(name), time, func)
		end))
	end

	netstream.Hook = DBugR.Util.Func.AddDetourM(netstream.Hook, function(name, func, ...)
		func = DBugR.Util.Func.AttachProfiler(func, function(time)
			DBugR.Profilers.NetstreamPerf:AddPerformanceData(tostring(name), time, func)
		end)

		return name, func, ...
	end)
end

if (SERVER) then
	util.AddNetworkString('NetStreamDS')
	util.AddNetworkString('NetStreamHeavy')

	-- A function to start a net stream.
	function netstream.Start(player, name, ...)
		local recipients = {}
		local bShouldSend = false

		if (type(player) ~= 'table') then
			if not player then
				player = _player.GetAll()
			else
				player = {player}
			end
		end

		for _, v in ipairs(player) do
			if (type(v) == 'Player') then
				recipients[#recipients + 1] = v

				bShouldSend = true
			end
		end

		local encodedData = pon.encode({...})

		if (encodedData and #encodedData > 0 and bShouldSend) then
			net.Start('NetStreamDS')
				net.WriteString(name)
				net.WriteUInt(#encodedData, 32)
				net.WriteData(encodedData, #encodedData)
			net.Send(recipients)
		end
	end

	function netstream.StartPVS(pos, name, ...)
		local rf = RecipientFilter()
		rf:AddPVS(pos)
		netstream.Start(rf:GetPlayers(), name, ...)
	end

	if (DBugR) then
		netstream.Start = DBugR.Util.Func.AddDetour(netstream.Start, function(_, name, ...)
			local encodedData = pon.encode({...})

			DBugR.Profilers.Netstream:AddNetData(name, #encodedData)
		end)
	end

	-- A function to start a > 64KB net stream.
	local queue, nextSend = {}, 0
	timer.Create('NetStreamHeavy', 0.05, 0, function()
		if nextSend > CurTime() or #queue < 1 then return end

		local msg = table.remove(queue, 1)
		net.Start('NetStreamHeavy')
			net.WriteString(msg[1])
			net.WriteUInt(#msg[4], 32)
			net.WriteData(msg[4], #msg[4])
			net.WriteUInt(msg[3], 8)
			net.WriteUInt(msg[2], 8)
		net.Send(msg[5])

		nextSend = CurTime() + 0.2
	end)

	function netstream.Heavy(player, name, ...)
		local recipients = {}
		local bShouldSend = false

		if type(player) ~= 'table' then
			if not player then
				player = _player.GetAll()
			else
				player = {player}
			end
		end

		for _, v in ipairs(player) do
			if (type(v) == 'Player') then
				recipients[#recipients + 1] = v

				bShouldSend = true
			end
		end

		local encodedData = pon.encode({...})
		local split = netstream.Split(encodedData)

		if (encodedData and #encodedData > 0 and bShouldSend) then
			for k, v in ipairs(split) do
				queue[#queue + 1] = {name, #split, k, v, recipients}
			end
		end
	end


	net.Receive('NetStreamDS', function(_, player)
		local NS_DS_NAME = net.ReadString()
		local NS_DS_LENGTH = net.ReadUInt(32)
		local NS_DS_DATA = net.ReadData(NS_DS_LENGTH)

		if (NS_DS_NAME and NS_DS_DATA and NS_DS_LENGTH) then
			player.nsDataStreamName = NS_DS_NAME
			player.nsDataStreamData = ''

			if (player.nsDataStreamName and player.nsDataStreamData) then
				player.nsDataStreamData = NS_DS_DATA

				if (stored[player.nsDataStreamName]) then
					local bStatus, value = pcall(pon.decode, player.nsDataStreamData)

					if (bStatus) then
						stored[player.nsDataStreamName](player, unpack(value))
					else
						ErrorNoHalt('NetStream: ' .. NS_DS_NAME .. '\n' .. value .. '\n')
					end
				end

				player.nsDataStreamName = nil
				player.nsDataStreamData = nil
			end
		end

		NS_DS_NAME, NS_DS_DATA, NS_DS_LENGTH = nil, nil, nil
	end)

	net.Receive('NetStreamHeavy', function(_, player)
		local NS_DS_NAME = net.ReadString()
		local NS_DS_LENGTH = net.ReadUInt(32)
		local NS_DS_DATA = net.ReadData(NS_DS_LENGTH)
		local NS_DS_PIECE = net.ReadUInt(8)
		local NS_DS_TOTAL = net.ReadUInt(8)

		if (NS_DS_NAME and NS_DS_DATA and NS_DS_LENGTH) then
			player.nsDataStreamName = NS_DS_NAME
			player.nsDataStreamData = ''

			if not cache[player.nsDataStreamName] then
				cache[player.nsDataStreamName] = ''
			end

			if (player.nsDataStreamName and player.nsDataStreamData) then
				player.nsDataStreamData = NS_DS_DATA

				if (NS_DS_PIECE < NS_DS_TOTAL) then
					if (NS_DS_PIECE == 1) then
						cache[player.nsDataStreamName] = ''
					end

					cache[player.nsDataStreamName] = cache[player.nsDataStreamName] .. player.nsDataStreamData
				else
					cache[player.nsDataStreamName] = cache[player.nsDataStreamName] .. player.nsDataStreamData

					if (stored[player.nsDataStreamName]) then
						local bStatus, value = pcall(pon.decode, cache[player.nsDataStreamName])

						if (bStatus) then
							stored[player.nsDataStreamName](player, unpack(value))
						else
							ErrorNoHalt('NetStream: ' .. NS_DS_NAME .. '\n' .. value .. '\n')
						end
					end

					cache[player.nsDataStreamName] = nil
					player.nsDataStreamName = nil
					player.nsDataStreamData = nil
				end
			end
		end

		NS_DS_NAME, NS_DS_DATA, NS_DS_LENGTH, NS_DS_PIECE, NS_DS_TOTAL = nil, nil, nil, nil, nil
	end)
else
	-- A function to start a net stream.
	function netstream.Start(name, ...)
		local encodedData = pon.encode({...})

		if (encodedData and #encodedData > 0) then
			net.Start('NetStreamDS')
				net.WriteString(name)
				net.WriteUInt(#encodedData, 32)
				net.WriteData(encodedData, #encodedData)
			net.SendToServer()
		end
	end

	if (DBugR) then
		netstream.Start = DBugR.Util.Func.AddDetour(netstream.Start, function(name, ...)
			local encodedData = pon.encode({...})

			DBugR.Profilers.Netstream:AddNetData(name, #encodedData)
		end)
	end

	-- A function to start a net stream.
	local queue, nextSend = {}, 0
	timer.Create('NetStreamHeavy', 0.05, 0, function()
		if nextSend > CurTime() or #queue < 1 then return end

		local msg = table.remove(queue, 1)
		net.Start('NetStreamHeavy')
			net.WriteString(msg[1])
			net.WriteUInt(#msg[4], 32)
			net.WriteData(msg[4], #msg[4])
			net.WriteUInt(msg[3], 8)
			net.WriteUInt(msg[2], 8)
		net.SendToServer()

		nextSend = CurTime() + 0.2
	end)

	function netstream.Heavy(name, ...)
		local dataTable = {...}
		local encodedData = pon.encode(dataTable)
		local split = netstream.Split(encodedData)

		if (encodedData and #encodedData > 0) then
			for k, v in ipairs(split) do
				queue[#queue + 1] = {name, #split, k, v}
			end
		end
	end

	net.Receive('NetStreamDS', function(_)
		local NS_DS_NAME = net.ReadString()
		local NS_DS_LENGTH = net.ReadUInt(32)
		local NS_DS_DATA = net.ReadData(NS_DS_LENGTH)

		if NS_DS_NAME and NS_DS_DATA and NS_DS_LENGTH and stored[NS_DS_NAME] then
			local bStatus, value = pcall(pon.decode, NS_DS_DATA)

			if (bStatus) then
				stored[NS_DS_NAME](unpack(value))
			else
				ErrorNoHalt('NetStream: ' .. NS_DS_NAME .. '\n' .. value .. '\n')
			end
		end

		NS_DS_NAME, NS_DS_DATA, NS_DS_LENGTH = nil, nil, nil
	end)

	net.Receive('NetStreamHeavy', function(_)
		local NS_DS_NAME = net.ReadString()
		local NS_DS_LENGTH = net.ReadUInt(32)
		local NS_DS_DATA = net.ReadData(NS_DS_LENGTH)
		local NS_DS_PIECE = net.ReadUInt(8)
		local NS_DS_TOTAL = net.ReadUInt(8)

		if not cache[NS_DS_NAME] then
			cache[NS_DS_NAME] = ''
		end

		if (NS_DS_NAME and NS_DS_DATA and NS_DS_LENGTH) then
			if (NS_DS_PIECE < NS_DS_TOTAL) then
				if (NS_DS_PIECE == 1) then
					cache[NS_DS_NAME] = ''
				end

				cache[NS_DS_NAME] = cache[NS_DS_NAME] .. NS_DS_DATA
			else
				cache[NS_DS_NAME] = cache[NS_DS_NAME] .. NS_DS_DATA

				if (stored[NS_DS_NAME]) then
					local bStatus, value = pcall(pon.decode, cache[NS_DS_NAME])

					if (bStatus) then
						stored[NS_DS_NAME](unpack(value))
					else
						ErrorNoHalt('NetStream Heavy: ' .. NS_DS_NAME .. '\n' .. value .. '\n')
					end

					cache[NS_DS_NAME] = nil
				end
			end
		end

		NS_DS_NAME, NS_DS_DATA, NS_DS_LENGTH, NS_DS_PIECE, NS_DS_TOTAL = nil, nil, nil, nil, nil
	end)
end

netstream.requestTimeout = 15
netstream.requestCallbacks = netstream.requestCallbacks or {}
netstream.nextReqID = netstream.nextReqID or 0

local function msgNameFromReqID(reqID)
	return 'nsr-' .. reqID
end

-- replies support only one return value! use tables
function netstream.Listen(name, callback)
	netstream.requestCallbacks[name] = callback
end

if SERVER then
	netstream.Hook('nsr', function(ply, name, reqID, ...)
		local callback = netstream.requestCallbacks[name]
		if not callback then return end

		local reply = function(...)
			netstream.Start(ply, msgNameFromReqID(reqID), ...)
		end

		callback(reply, ply, ...)
	end)

	function netstream.Request(ply, name, ...)
		local args = {...}
		return util.Promise(function(res, rej)
			local reqID = netstream.nextReqID
			netstream.nextReqID = netstream.nextReqID + 1

			local msgName = msgNameFromReqID(reqID)
			netstream.Hook(msgName, function(_, data)
				netstream.Hook(msgName, nil)
				res(data)
			end)
			netstream.Start(ply, 'nsr', name, reqID, unpack(args))

			timer.Create(msgName, netstream.requestTimeout, 1, function()
				rej('timeout')
				timer.Remove(msgName)
			end)
		end)
	end
else
	netstream.Hook('nsr', function(name, reqID, ...)
		local callback = netstream.requestCallbacks[name]
		if not callback then return end

		local reply = function(...)
			netstream.Start(msgNameFromReqID(reqID), ...)
		end

		callback(reply, ...)
	end)

	function netstream.Request(name, ...)
		local args = {...}
		return util.Promise(function(res, rej)
			local reqID = netstream.nextReqID
			netstream.nextReqID = netstream.nextReqID + 1

			local msgName = msgNameFromReqID(reqID)
			netstream.Hook(msgName, function(data)
				netstream.Hook(msgName, nil)
				res(data)
			end)
			netstream.Start('nsr', name, reqID, unpack(args))

			timer.Create(msgName, netstream.requestTimeout, 1, function()
				rej('timeout')
				netstream.Hook(msgName, nil)
				timer.Remove(msgName)
			end)
		end)
	end
end
