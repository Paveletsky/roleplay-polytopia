if CLIENT then

	local surface = surface
	local Color = Color

	local SKIN = {}
	SKIN.PrintName = 'PolytopiaGM Skin'
	SKIN.Author = 'Lasexille'

	SKIN.fontFrame = ''
	SKIN.fontTab = 'Trebuchet24'
	SKIN.fontCategoryHeader = 'Trebuchet24'

	SKIN.GwenTexture = Material('gwenskin/GModDefault.png')
	SKIN.Shadow = GWEN.CreateTextureBorder(448, 0, 31, 31, 8, 8, 8, 8)

	SKIN.bg_color					= Color(101, 100, 105, 255)
	SKIN.bg_color_sleep				= Color(70, 70, 70, 255)
	SKIN.bg_color_dark				= Color(55, 57, 61, 255)
	SKIN.bg_color_bright			= Color(220, 220, 220, 255)
	SKIN.frame_border				= Color(50, 50, 50, 255)

	SKIN.control_color				= Color(120, 120, 120, 255)
	SKIN.control_color_highlight	= Color(150, 150, 150, 255)
	SKIN.control_color_active		= Color(110, 150, 250, 255)
	SKIN.control_color_bright		= Color(255, 200, 100, 255)
	SKIN.control_color_dark			= Color(100, 100, 100, 255)

	SKIN.bg_alt1					= Color(50, 50, 50, 255)
	SKIN.bg_alt2					= Color(55, 55, 55, 255)

	SKIN.listview_hover				= Color(70, 70, 70, 255)
	SKIN.listview_selected			= Color(100, 170, 220, 255)
	SKIN.combobox_selected			= SKIN.listview_selected

	SKIN.text_bright				= Color(255, 255, 255, 255)
	SKIN.text_normal				= Color(180, 180, 180, 255)
	SKIN.text_dark					= Color(255, 255, 255, 255)
	SKIN.text_highlight				= Color(255, 20, 20, 255)

	SKIN.panel_transback			= Color(255, 255, 255, 50)
	SKIN.tooltip					= Color(255, 245, 175, 255)
	SKIN.colPropertySheet			= Color(170, 170, 170, 255)

	SKIN.colTab						= SKIN.colPropertySheet
	SKIN.colTabInactive				= Color(140, 140, 140, 255)
	SKIN.colTabShadow				= Color(0, 0, 0, 170)
	SKIN.colTabText					= Color(255, 255, 255, 255)
	SKIN.colTabTextInactive			= Color(0, 0, 0, 200)

	SKIN.colCollapsibleCategory		= Color(255, 255, 255, 20)

	SKIN.colCategoryText			= Color(255, 255, 255, 255)
	SKIN.colCategoryTextInactive	= Color(200, 200, 200, 255)

	SKIN.colNumberWangBG			= Color( 255, 240, 150, 255 )
	SKIN.colTextEntryBG				= Color( 240, 240, 240, 255 )
	SKIN.colTextEntryBorder			= Color( 20, 20, 20, 255 )
	SKIN.colTextEntryText			= Color( 20, 20, 20, 255 )
	SKIN.colTextEntryTextHighlight	= Color( 20, 200, 250, 255 )
	SKIN.colTextEntryTextCursor		= Color( 0, 0, 100, 255 )
	SKIN.colTextEntryTextPlaceholder= Color( 128, 128, 128, 255 )

	SKIN.colMenuBG					= Color( 255, 255, 255, 200 )
	SKIN.colMenuBorder				= Color( 0, 0, 0, 200 )

	SKIN.colButtonText				= Color(255, 255, 255, 255)
	SKIN.colButtonTextDisabled		= Color(255, 255, 255, 55)
	SKIN.colButtonBorder			= Color(20, 20, 20, 255)
	SKIN.colButtonBorderHighlight	= Color(255, 255, 255, 50)
	SKIN.colButtonBorderShadow		= Color(0, 0, 0, 100)

	SKIN.Colours = {}

	SKIN.Colours.Button = {}
	SKIN.Colours.Button.Disabled = Color(0,0,0,100)
	SKIN.Colours.Button.Down = Color(180,180,180,255)
	SKIN.Colours.Button.Hover = Color(255,255,255,255)
	SKIN.Colours.Button.Normal = Color(255,255,255,255)

	SKIN.Colours.Category = {}
	SKIN.Colours.Category.Header = Color(255,255,255,255)
	SKIN.Colours.Category.Header_Closed = Color(255,255,255,150)
	SKIN.Colours.Category.Line = {}
	SKIN.Colours.Category.Line.Button = Color(255,255,255,0)
	SKIN.Colours.Category.Line.Button_Hover = Color(0,0,0,8)
	SKIN.Colours.Category.Line.Button_Selected = Color(255,216,0,255)
	SKIN.Colours.Category.Line.Text = Color(200,200,200,255)
	SKIN.Colours.Category.Line.Text_Hover = Color(255,255,255,255)
	SKIN.Colours.Category.Line.Text_Selected = Color(255,255,255,255)
	SKIN.Colours.Category.LineAlt = {}
	SKIN.Colours.Category.LineAlt.Button = Color(0,0,0,26)
	SKIN.Colours.Category.LineAlt.Button_Hover = Color(0,0,0,32)
	SKIN.Colours.Category.LineAlt.Button_Selected = Color(255,216,0,255)
	SKIN.Colours.Category.LineAlt.Text = Color(200,200,200,255)
	SKIN.Colours.Category.LineAlt.Text_Hover = Color(255,255,255,255)
	SKIN.Colours.Category.LineAlt.Text_Selected = Color(255,255,255,255)

	SKIN.Colours.Label = {}
	SKIN.Colours.Label.Bright = Color(255,255,255,255)
	SKIN.Colours.Label.Dark = Color(255,255,255,255)
	SKIN.Colours.Label.Default = Color(255,255,255,255)
	SKIN.Colours.Label.Highlight = Color(255,0,0,255)

	SKIN.Colours.Properties = {}
	SKIN.Colours.Properties.Border = Color(102,170,170, 255)
	SKIN.Colours.Properties.Column_Hover = Color(118,199,255,59)
	SKIN.Colours.Properties.Column_Normal = Color(255,255,255,0)
	SKIN.Colours.Properties.Column_Selected = Color(118,199,255,255)
	SKIN.Colours.Properties.Label_Hover = Color(50,50,50,255)
	SKIN.Colours.Properties.Label_Normal = Color(0,0,0,255)
	SKIN.Colours.Properties.Label_Selected = Color(0,0,0,255)
	SKIN.Colours.Properties.Line_Hover = Color(156,156,156,255)
	SKIN.Colours.Properties.Line_Normal = Color(156,156,156,255)
	SKIN.Colours.Properties.Line_Selected = Color(156,156,156,255)
	SKIN.Colours.Properties.Title = Color(255,255,255,255)

	SKIN.Colours.Tab = {}
	SKIN.Colours.Tab.Active = {}
	SKIN.Colours.Tab.Active.Disabled = Color(233,233,233,204)
	SKIN.Colours.Tab.Active.Down = Color(255,255,255,255)
	SKIN.Colours.Tab.Active.Hover = Color(255,255,255,255)
	SKIN.Colours.Tab.Active.Normal = Color(255,255,255,255)
	SKIN.Colours.Tab.Inactive = {}
	SKIN.Colours.Tab.Inactive.Disabled = Color(210,210,210,204)
	SKIN.Colours.Tab.Inactive.Down = Color(255,255,255,255)
	SKIN.Colours.Tab.Inactive.Hover = Color(249,249,249,153)
	SKIN.Colours.Tab.Inactive.Normal = Color(255,255,255,102)

	SKIN.Colours.TooltipText = Color(255,255,255,255)

	SKIN.Colours.Tree = {}
	SKIN.Colours.Tree.Hover = Color(5,170,170, 255)
	SKIN.Colours.Tree.Normal = color_white
	SKIN.Colours.Tree.Lines = Color(255,255,255, 35)
	SKIN.Colours.Tree.Selected = color_white

	SKIN.Colours.Window = {}
	SKIN.Colours.Window.TitleActive = Color(255,255,255,204)
	SKIN.Colours.Window.TitleInactive = Color(255,255,255,92)

	SKIN.Colours.TooltipText = Color(255,255,255,255)

	function SKIN:PaintFrame(pnl, w, h)

		-- if pnl.m_bPaintShadow then
			DisableClipping( true )
			DisableClipping( false )
		-- end

		draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 255))
		draw.RoundedBoxEx(1, 0, 0, w, 23, Color(250, 160, 0, 170), true, true, false, false)

	end


	function SKIN:PaintButton(pnl, w, h)

		if not pnl.m_bBackground then return end

		local off = h > 20 and 2 or 1

		draw.RoundedBox(5, 0, 1, w, h, Color(0, 0, 0, 155))
		draw.RoundedBox(5, 0, 1, w, h - off, Color(184, 53, 64, 255))
		if pnl.Disabled then
			draw.RoundedBox(5, 0, 1, w, h, Color(25,25,25, 255))
		elseif pnl.Hovered then
			draw.RoundedBox(5, 0, 1, w, h - off, Color(184, 53, 64, 255))
		end

	end


	function SKIN:PaintListView( pnl, w, h )

		if not pnl.m_bBackground then return end
		draw.RoundedBox(4, 0, 0, w, h, Color(25, 25, 25, 255))

	end

	function SKIN:PaintListViewLine( pnl, w, h )

		if ( pnl:IsSelected() ) then
			draw.RoundedBox(6, 0, 0, w, h, Color(235, 130, 19, 120))
		elseif ( pnl.Hovered ) then
			draw.RoundedBox(4, 0, 0, w, h, Color(0,0,0, 35))
		elseif ( pnl.m_bAlt ) then
			draw.RoundedBox(4, 0, 0, w, h, Color(0,0,0, 35))
		end

	end

	function SKIN:PaintCategoryList( panel, w, h )

		-- self.tex.CategoryList.Outer( 0, 0, w, h )

	end

	function SKIN:PaintCategoryButton( panel, w, h )

		if ( panel.AltLine ) then

			if ( panel.Depressed or panel.m_bSelected ) then draw.RoundedBox(4, 0, 0, w, h, Color(171, 0, 14, 255))
			elseif ( panel.Hovered ) then draw.RoundedBox(4, 0, 0, w, h, Color(171, 0, 14, 255))
			else draw.RoundedBox(4, 0, 0, w, h, Color(255,255,255, 1)) end

		else

			if ( panel.Depressed or panel.m_bSelected ) then draw.RoundedBox(4, 0, 0, w, h, Color(171, 0, 14, 255))
			elseif ( panel.Hovered ) then draw.RoundedBox(4, 0, 0, w, h, Color(171, 0, 14, 255))
			end

		end

	end
	

	function SKIN:PaintWindowCloseButton(pnl, w, h)

		if pnl.Disabled then return end

		if pnl.Depressed then
			draw.RoundedBox(4, w/2-8, h/2-7, 16, 16, Color(171, 0, 14, 255))
			if pnl.Hovered then
				draw.SimpleText( 'X', 'Trebuchet24', w / 2, h / 2, Color(0,0,0, 120), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		else
			draw.RoundedBox(4, w / 4, h/2-9, 19, 18, Color(171, 0, 14, 255))
			if pnl.Hovered then
				draw.SimpleText( 'X', 'Trebuchet24', w / 2 + 2.2, h / 2, Color(0,0,0, 120), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end

	end

function SKIN:PaintPanel(pnl, w, h)

	if not pnl.m_bBackground then return end

	draw.RoundedBox(9, 0, 0, w, h, Color(0,0,0, 255))
	draw.RoundedBox(9, 1, 1, w-2, h-2, Color(20,20,20, 255))

end

function SKIN:PaintPropertySheet(pnl, w, h)

	draw.RoundedBox(4, 0, 2, w, h-2, Color(25,25,25, 240))
	draw.RoundedBoxEx(4, 0, 2, w, 18, Color(0,0,0, 240), true, true, false, false)

end

function SKIN:PaintProgress(pnl, w, h)

	local y = h / 2 - 9
	draw.RoundedBox(7, 0, y, w, 18, Color( 184, 53, 64, 20 ))
	local fr = pnl:GetFraction()
	if fr > 0 then
		draw.RoundedBox(7, 1, y + 1, (w-18) * fr + 16, 16, Color(250, 160, 0, 170) )
	end
	if fr > 0.70 then
		draw.RoundedBox(7, 1, y + 1, (w-18) * fr + 16, 16, Color(184, 53, 64, 240) )
	end

end

function SKIN:PaintTooltip( pnl, w, h )

	surface.DisableClipping(true)

	draw.RoundedBox(4, -3, 0, w + 6, h, Color(0,0,0, 240))
	draw.NoTexture()
	surface.DrawPoly({
		{x = w/5 - 5, y = h},
		{x = w/5 + 15, y = h},
		{x = w/2, y = h + 25},
	})

	surface.DisableClipping(false)

end

function SKIN:PaintVScrollBar( panel, w, h )

	draw.RoundedBox(4, w/2-2, w+3, 4, h-6 - w*2, Color(255,255,255, 25))

end

function SKIN:PaintScrollBarGrip( panel, w, h )

	draw.RoundedBox(4, w/2-4, 0, 8, h, Color(255,255,255, 25))

	if ( panel:GetDisabled() ) then
		return draw.RoundedBox(4, w/2-4, 0, 8, h, Color(255,255,255, 25))
	end

	if ( panel.Depressed ) then
		return draw.RoundedBox(4, w/2-4, 0, 8, h, Color(255,255,255, 25))
	end

	if ( panel.Hovered ) then
		return draw.RoundedBox(4, w/2-4, 0, 8, h, Color(255,255,255, 25))
	end

end

function SKIN:PaintCategoryList( panel, w, h )

	-- self.tex.CategoryList.Outer( 0, 0, w, h )
	
end

function SKIN:PaintMenuSpacer( pnl, w, h )

	surface.SetDrawColor(Color(235, 130, 19, 155))
	surface.DrawRect(0, 0, w, h)

end

function SKIN:PaintCollapsibleCategory(pnl, w, h)

	draw.RoundedBox(4, 0, 5, w, h, Color(25, 25, 25, 255))
	draw.RoundedBox(4, 0, 0, w, 20, Color(235, 130, 19, 255))

end

function SKIN:PaintMenu( pnl, w, h )

	surface.DisableClipping(true)
	surface.DisableClipping(false)

	draw.RoundedBox(2, 0, 0, w, h, Color(20, 20, 20, 255))
	draw.RoundedBox(2, 0, -h + 1, w, h, Color(235, 130, 19, 255))

end

function SKIN:PaintMenuBar( pnl, w, h )

	draw.RoundedBox(0, 0, 0, w, h, Color(235, 130, 19, 255))

end

function SKIN:PaintSelection( pnl, w, h )

	draw.RoundedBox(4, 0, 0, w, h, Color(25, 25, 25, 255))

end

function SKIN:PaintTextEntry(pnl, w, h)

	if pnl.m_bBackground then
		if pnl.PaintOffset then
			surface.DisableClipping(true)
			if pnl:GetDisabled() then
				draw.RoundedBox(4, -pnl.PaintOffset, -pnl.PaintOffset, w + pnl.PaintOffset*2, h + pnl.PaintOffset*2, Color(255,255,255, 100))
			elseif pnl:HasFocus() then
				draw.RoundedBox(4, -pnl.PaintOffset, -pnl.PaintOffset, w + pnl.PaintOffset*2, h + pnl.PaintOffset*2, cols.y)
			else
				draw.RoundedBox(4, -pnl.PaintOffset, -pnl.PaintOffset, w + pnl.PaintOffset*2, h + pnl.PaintOffset*2, color_white)
			end
			surface.DisableClipping(false)
		else
			if pnl:GetDisabled() then
				draw.RoundedBox(4, 0, 0, w, h, Color(255,255,255, 100))
			elseif pnl:HasFocus() then
				draw.RoundedBox(4, 0, 0, w, h, Color(240,202,77, 255))
			else
				draw.RoundedBox(4, 0, 0, w, h, color_white)
			end
		end
	end

	if (pnl.GetPlaceholderText and pnl.GetPlaceholderColor and pnl:GetPlaceholderText() and pnl:GetPlaceholderText():Trim() ~= "" and pnl:GetPlaceholderColor() and (not pnl:GetText() or pnl:GetText() == "")) then
		local oldText = pnl:GetText()
		local str = pnl:GetPlaceholderText()
		if str:StartWith("#") then str = language.GetPhrase(str:sub(2)) end

		pnl:SetText(str)
		pnl:DrawTextEntryText(pnl:GetPlaceholderColor(), pnl:GetHighlightColor(), pnl:GetCursorColor())
		pnl:SetText(oldText)

		return
	end

	pnl:DrawTextEntryText(pnl:GetTextColor(), pnl:GetHighlightColor(), pnl:GetCursorColor())

end

function SKIN:PaintTab(pnl, w, h)

	if pnl:IsActive() then
		draw.RoundedBoxEx(6, 2, 0, w-5, h -6, Color(235, 130, 19, 225), true, true, false, false)
	else
		draw.RoundedBoxEx(15, 2, 0, w-5, h, Color(235, 130, 19, 255), true, true, false, false)
	end

end

function SKIN:PaintComboBox( pnl, w, h )

	if pnl:GetDisabled() then
		draw.RoundedBox(8, 0, 0, w, h, Color(255,255,255, 255))
	elseif pnl:HasFocus() then
		draw.RoundedBox(8, 0, 0, w, h, Color(171, 0, 14, 255))
	elseif pnl.Depressed or pnl:IsMenuOpen() then
		draw.RoundedBox(15, 0, 0, w, h, Color(255, 255, 255, 255))
	else
		draw.RoundedBox(15, 0, 1, w, h-2, color_white)
	end

	if not pnl.m_TextColorSet then
		pnl:SetTextColor(Color(30,30,30))
		pnl.m_TextColorSet = true
	end

end

function SKIN:PaintMenuOption( pnl, w, h )

	if pnl.m_bBackground and (pnl.Hovered or pnl.Highlight) then
		draw.RoundedBox(4, 0, 0, w, h, Color(171, 0, 14, 255))
	end

	if pnl:GetChecked() then
		draw.SimpleText(utf8.char(0xf00c), 'Trebuchet24', 16, h/2, Color(255,255,255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		-- draw.RoundedBox(4, 0, 0, w, h, cols.o)
	end

	if not pnl.m_TextColorSet then
		pnl:SetTextColor(Color(255,255,255))
		pnl.m_TextColorSet = true
	end

end

function SKIN:PaintTree( pnl, w, h )

	if not pnl.m_bBackground then return end

	draw.RoundedBox(4, 0, 0, w, h, Color(0,0,0, 80))
	draw.RoundedBox(4, 1, 1, w-2, h-2, Color(20, 20, 20, 255))

end

function SKIN:PaintSelection( pnl, w, h )

	draw.RoundedBox(4, 0, 0, w, h, cols.o)

end

function SKIN:PaintTreeNodeButton( pnl, w, h )

	if not pnl.m_bSelected then return end

	local w, _ = pnl:GetTextSize()
	draw.RoundedBox(4, 38, 2, w + 6, h-3, Color(171, 0, 14, 255))

end

function SKIN:PaintTreeNode( pnl, w, h )

	if not pnl.m_bDrawLines then return end

	surface.SetDrawColor( self.Colours.Tree.Lines )
	if ( pnl.m_bLastChild ) then
		surface.DrawRect( 9, 0, 1, 8 )
		surface.DrawRect( 10, 7, 8, 1 )
	else
		surface.DrawRect( 9, 0, 1, h )
		surface.DrawRect( 10, 7, 8, 1 )
	end

end

derma.DefineSkin( "Polytopia", "Стиль", SKIN )


hook.Add('ForceDermaSkin', 'library.forceSkin', function()

	return 'Polytopia'

end)


-- for k,v in pairs(derma.GetSkinTable()) do print(k) end -- Prints all defined skins

end