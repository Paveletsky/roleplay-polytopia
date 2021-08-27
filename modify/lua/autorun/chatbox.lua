local Tag = "ChatAddText"

	util.AddNetworkString(Tag)


if SERVER then
	

	local PLAYER = FindMetaTable("Player")

	

	function PLAYER:ChatAddText(...)

		net.Start(Tag)

			net.WriteTable({...})

		net.Send(self)

	end

	

	function ChatAddText(...)

		net.Start(Tag)

			net.WriteTable({...})

		net.Broadcast()

	end

end



if CLIENT then

	local function receive()

		local data = net.ReadTable()

		if not istable(data) then return end

		

		chat.AddText(unpack(data))

	end

	

	net.Receive(Tag, receive)

end