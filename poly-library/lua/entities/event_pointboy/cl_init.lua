include('shared.lua')

function ENT:Draw()
	self:DrawModel()
end

netstream.Hook( 'entlib.createJobMenu', function( c, a ) 

	local fr = vgui.Create 'DFrame'

	fr:SetSize( 500, 300 )
	fr:MakePopup()
	fr:Center()

	fr:SetTitle( 'Доска' )

	local adm = fr:Add 'DComboBox'

	adm:Dock( TOP )
	adm:DockMargin( 45, -28, 270, 0 )
	if c:IsAdmin() then
		adm:SetVisible( true ) else adm:SetVisible( false )
	end

		for key, data in pairs( DarkRP.getCategories().jobs ) do
			adm:AddChoice( data.name, data, true )
		end

		function adm:OnSelect( data )
		
			local lst = fr:Add 'DListView'

			lst:Dock( FILL )
			lst:SetMultiSelect( false )
			lst:AddColumn( 'Айди' )
			lst:AddColumn( 'Род занятости' )
			lst.Columns[1]:SetFixedWidth( 0 )
			for id, job in pairs( RPExtraTeams ) do
				if job.category == adm:GetValue() then lst:AddLine( id, job.name ) end 
			
				function lst:DoDoubleClick( lineID, line )
					netstream.Start( 'entlib.becomeJob', line:GetValue(1) )
				end
			end

		end

end)