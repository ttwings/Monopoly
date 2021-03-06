return {
	button = {
		image = cheetah.newImage('data/gfx/menu-button.dds'),
		--font = S.newFont('data/fonts/ru.ttf', 32),
		font_color = {0,0,0,255},
		w = 256, h = 64,
		draw = function(s)
			--~ S.fontSize = s.fontSize or 30 * s.h / ui_style.button.h
			--~ --normal
			if s.disabled == true then 
				cheetah.setColor(255, 255, 255, 128)
			end
			ui_style.button.image:drawq(s.x, s.y, s.w, s.h, 0, 0, 256, 64)
			--hover
			if s.hover_alpha > 0 and s.disabled == false then
				cheetah.setColor(s.r or 255, s.g or 255, s.b or 255, (s.hover_alpha*s.a)/255)
				ui_style.button.image:drawq(s.x, s.y, s.w, s.h, 64, 256, 64)
			end
			if s.text then
				--if ui_style.button.font then S.setFont(ui_style.button.font) end
				-- fnt_big:select()
				-- fnt_big:scale((s.h * 0.75) / 45*0.6)
				cheetah.setColor(255,255,255, s.a*s.a/255/2) 
				-- cheetah.print(s.text, s.x, s.y+s.h*0.17, s.w)
				
				if ui_style.button.font_color then 
					local c = ui_style.button.font_color
					cheetah.setColor(c[1], c[2], c[3], s.a * c[4] / 255)
				end
				-- S.print(s.text, s.x, s.y+s.h*0.17, s.w)
				
			end
			cheetah.setColor(255, 255, 255, 255)
			--~ --S.setColor(255, 255, 255, s.a)
			--~ --S.rectangle('line', s.x+(s.w - ui_style.button.font:getWidth(s.text))/2, s.y+(s.h - ui_style.button.font:getHeight())/2, ui_style.button.font:getWidth(s.text),ui_style.button.font:getHeight())
		end,
		mouseover = function(self)
			self:stop('hover'):animate({hover_alpha=255},{queue='hover'})
		end,
		mouseout = function(self)
			self:stop('hover'):animate({hover_alpha=0},{speed=0.6,queue='hover'})
		end
	},
	list = {
		--font = S.newFont('data/fonts/ru.ttf', 25),
		w = 400, h = 28,
		draw = function(s)
			fnt_big:select()
			--~ if ui_style.list.font then S.setFont(ui_style.list.font) end
			Gprintf(s.text, s.x, s.y)
			if s._vars_names[s._pos] then Gprintf(s._vars_names[s._pos], s.x, s.y, s.w, 'right')
			elseif s._vars[s._pos] then Gprintf(s._vars[s._pos], s.x, s.y, s.w, 'right')
			else
				Gprintf('undefined', s.x, s.y, s.w, 'right')
			end
		end,
		mouseover = function(self)
			self:stop('hover'):animate({b=120},{queue='hover'})
		end,
		mouseout = function(self)
			self:stop('hover'):animate({b=255},{speed=0.6,queue='hover'})
		end
	},
	slider = {
		image = cheetah.newImage('data/gfx/slider-button.png'),
		button = {
			--~ quad = S.newQuad(0, 0, 32, 32, 32, 64),
			w = 32, h=32
		},
		--~ button_l = S.newQuad(0, 32, 10, 32, 32, 64),
		--~ button_c = S.newQuad(10, 32, 12, 32, 32, 64),
		--~ button_r = S.newQuad(22, 32, 10, 32, 32, 64),
		--~ font = S.newFont('data/fonts/ru.ttf', 25),
		w = 400, h = 28,
		draw = function(s)
			--~ if ui_style.list.font then S.setFont(ui_style.list.font) end
			fnt_big:select()
			Gprintf(s.text, s.x, s.y, s.w, 'left')
			--~ Gprint(math.floor(var_by_reference (s._variable)), s.x+400, s.y)
			cheetah.setColor(255, 255, 255, 255)
			ui_style.slider.image:drawq(s.x+248, s.y-2, 0, 10, 32, 0, 32, 10, 32)
			ui_style.slider.image:drawq(s.x+248+10, s.y-2, 0, 132, 32, 10, 32, 12, 32)
			ui_style.slider.image:drawq(s.x+400-10, s.y-2, 0, 10, 32, 22, 32, 10, 32)
		end,
		button_draw = function(s)
			ui_style.slider.image:drawq(s.x, s.y, 0, 32, 32, 0, 0, 32, 32)
		end,
		mouseover = function(self)
			self:stop('hover'):animate({b=120},{queue='hover'})
		end,
		mouseout = function(self)
			self:stop('hover'):animate({b=255},{speed=0.6,queue='hover'})
		end
	},
	menu = {
		margin = 10, --space between items
		start = 120 --top indent
	}
}
