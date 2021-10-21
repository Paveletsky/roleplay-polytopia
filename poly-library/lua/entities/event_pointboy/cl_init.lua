include('shared.lua')
AddCSLuaFile( 'core/funcs' )

function ENT:Draw()
	self:DrawModel()
end

function library.toKeys(tbl)

	local out = {}
	for i, v in ipairs(tbl) do
		out[v] = true
	end

	return out

end

categoriesList = library.toKeys({
	'Гражданские',
	'Правительство',
	'Криминальные',
	'Другое',
})

choicePicker = {
	['Криминал'] = 'Криминал - серьезный шаг, вы точно приняли решение выбрать данную сторону вашего персонажа?',
	['Гражданские'] = 'Обычные, но не совсем стандартные для Политопии будни простого рабочего. На данном этапе вам предлагается бесплатная еда, место жительства и защита. Вы действительно хотите стать мирным гражданским и выживать в городе под защитой правительства?',
	['Правительство'] = 'Правительство - выбор тех, кто понял, что анархия не привела ни к чему хорошему, вы решились помочь этому городу и его жителям, вы обязуетесь бороться с криминальным миром, а также помогать гражданскому населению там, где те нуждаются!',
	['Другое'] = 'Так значит ты решил помочь серверу? =)',
}

netstream.Hook( 'entlib.createJobMenu', function( c, a ) 

	local fr = vgui.Create 'DFrame'

	fr:SetSize( 500, 300 )
	fr:MakePopup()
	fr:Center()

	fr:SetTitle( 'Доска' )

	local adm = fr:Add 'DComboBox'

	adm:Dock( TOP )
	adm:DockMargin( 45, -28, 270, 0 )

	local admbut = fr:Add 'DButton'

	admbut:Dock( TOP )
	admbut:DockMargin( 220, -22, 100, 0 )
	admbut:SetText( 'Принять настройки' )
	if !c:IsAdmin() then
		adm:SetVisible( true ) admbut:SetVisible( true )
	end

	function admbut:DoClick()
		local admG = adm:GetValue()
		local En = c:GetEyeTrace().Entity

		netstream.Start( 'entlib.jobsCategory', tostring( admG ), En )

	end

	for key, data in pairs( categoriesList ) do
		adm:AddChoice( key, data, true )
	end

	function adm:OnSelect( data )
	
		local lst = fr:Add 'DListView'

		lst:Dock( FILL )
		lst:SetMultiSelect( false )
		lst:AddColumn( 'Айди' )
		lst:AddColumn( 'Род занятости' )
		lst:AddColumn( 'Описание' )
		lst.Columns[1]:SetFixedWidth( 0 )
		lst.Columns[2]:SetFixedWidth( 150 )			
		for id, job in pairs( RPExtraTeams ) do

			if job.category == adm:GetValue() then lst:AddLine( id, job.name, job.description ) end 
		
			function lst:DoDoubleClick( lineID, line )
				Derma_Query( choicePicker[adm:GetValue()], 'Выбор - ' .. line:GetValue(2), 'Я готов к этой роли!', 
				
				function() 
					netstream.Start( 'entlib.becomeJob', line:GetValue(1) ) 
				end, 'Я еще подумаю.', 
				
				function() 
					fr:Close()

				end)						
	
			end
	
		end
	
	end

end)
