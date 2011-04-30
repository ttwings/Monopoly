--�������� ������� ������ ����������� �� ������ ������ � ������ ������ (����� ��� ��������)
getplayerxy = function(n, k)
  side = companys._child[n].side
  x, y = get_xy(companys._child[n].pos, side)
  if side == 1 then
    x = x + math.cos(k*math.pi)*14 + 8
    y = y + k*12 - 3
  elseif side == 2 then
    x = x + k*14 - 55
    y = y + math.cos(k*math.pi)*12 + 12
  elseif side == 3 then
    x = x + math.cos(k*math.pi)*12 + 8
    y = y + k*12 - 55
  elseif side == 4 then
    x = x + k*14 -15
    y = y + math.cos(k*math.pi)*12 + 12
  else
    x = x + k*14 -15
    y = y + math.cos(k*math.pi*0.5)*30 + 24
  end
  return x, y
end

__i = 1
double = 1
__max = 5

-- �������� ���������
conversion_monopoly = function(pl, company)
  local oils_bank = {}
  local group  = 0
  local comp = {}
    -- ���� �������� �������� ��� ���� - ������� ���������� ��������
  if company.group == "oil" or company.group == "bank" then
    for k,v in pairs(rules_company) do
    if v.owner == pl and company.group == v.group and v.level > 0 then
	table.insert(oils_bank, v)
      end
    end
    for k,v in pairs(oils_bank) do
      v.level = #oils_bank + 2
    end
   -- ������� ��������� ��� ���� ��������� ��������
    else
      for k,v in pairs(rules_company) do
	if company.group == v.group then
	  group = group + 1
	  if v.owner == pl and v.level > 0 then
	    table.insert(comp, v)
	  end
	end
    end
    -- ���� ��� �������� � ������ - ������ ����� 2 (���� ����� ������ ����)
    if group == #comp then
      for k,v in pairs(comp) do
	if v.level < 2 then
	  v.level = 2
	end
      end
    end
  end
end

-- ������� ��������
buy_company = function(pl, company)
  if not company.owner and company.type == "company" and pl.cash > company.money[1] then 
    player:delay({speed = 0, cb = function() 
      company.owner = pl
      conversion_monopoly(pl, company)
      companys._child[pl.pos]:set({owner_alpha = 0}):delay(0.1):animate({owner_alpha = 90})
    end})
    money_transfer(company.money[1] * (-1), pl)
    return true
  end
end

-- ����� ��������
mortgage_company = function(pl, company, num)
  local comp = {}
  local group = 0
  if company.owner == pl and company.type == "company" and company.level > 0 then
    if company.group == "oil" or company.group == "bank" then
      player:delay({speed = 0, cb = function() company.level = 0 companys._child[num]:animate({mortgage_alpha = 255}) conversion_monopoly(pl, company) end})
      money_transfer(company.money[1]/2, pl)
      return true
    else
      if company.level > 2 then
	player:delay({speed = 0, cb = function() company.level = company.level - 1 conversion_monopoly(pl, company) end})
	money_transfer(rules_group[company.group].upgrade, pl)
	return true
      elseif company.level == 1 then
	player:delay({speed = 0, cb = function() company.level = 0 companys._child[num]:animate({mortgage_alpha = 255}) conversion_monopoly(pl, company) end})
	money_transfer(company.money[1]/2, pl)
	return true
      else
	for k,v in pairs(rules_company) do
	  if company.group == v.group then
	    group = group + 1
	    if v.level == 2 then table.insert(comp, v) end
	  end
	end
	if group == #comp then
	  player:delay({speed = 0, cb = function() company.level = 0 companys._child[num]:animate({mortgage_alpha = 255}) conversion_monopoly(pl, company) 
	    for k,v in pairs(comp) do
	      if v.level > 1 then v.level = 1 end
	    end 
	  end})
	  --print("pledge_company: "..company.name.." cash: "..company.money[1]/2)
	  money_transfer(company.money[1]/2, pl)
	  return true
	end
      end
    end
  end
  return false
end

-- ����� ��������
buyout_company = function(pl, company, num)
  if company.owner == pl and company.type == "company" and company.level == 0 and pl.cash > company.money[1] then
    player:delay({speed = 0, cb = function() 
      company.level = 1 
      conversion_monopoly(pl, company) 
      companys._child[num]:animate({mortgage_alpha = 0, cb = function(s)s.mortgage_alpha=0 end})
    end})
    money_transfer(company.money[1]*(-1), pl)
    return true
  end
  return false
end

-- �������� ��������
buybons_company = function(pl, company)
  if company.owner == pl and company.level >= 2 and company.level < 7 and company.group ~= "oil" and 
	    company.group ~= "bank" and pl.cash > rules_group[company.group].upgrade then
    player:delay({speed = 0, cb = function() company.level = company.level + 1 end})
    money_transfer(rules_group[company.group].upgrade * (-1), pl)
    return true
  end
  return false
end

--[[
-- ����� �� ����
gameout = function(pl)
  for k,v in pairs(rules_company) do
    if v.owner == pl then
      v.owner = nil
      v.level = 1
      companys._child[k].mortgage_alpha = 0
    end
  end
  pl.ingame = false
end

comp = 0
-- ������� ������ �������� ��� AI
mortgage_ai = function(pl)
  if pl.cash < 0 then
    for k,v in pairs(rules_company) do
      mortgage_company(pl, v, k)
      if pl.cash >= 0 then break end
    end
    if pl.cash < 0 then
      print("if")
      player:delay({speed=0, cb = function()
	for k,v in pairs(rules_company) do
	  if v.owner == pl and v.level > 0 then
	    comp = 1
	    break
	  end
	end
	print(comp)
	if comp == 1 then
	  comp = 0
	  mortgage_ai(pl)
	end
      end})
    end
  end
end]]

-- ������������� ���������
ai = function(pl)
-- ���� ����� ������ ���� - ����������� ��������
  if pl.cash < 0 then
    for k,v in pairs(rules_company) do
      if v.owner == pl and v.level == 1 and mortgage_company(pl, v, k) == true then
	player:delay({speed = 0, cb = function() ai(pl) end})
	return
      end
    end
    for k,v in pairs(rules_company) do
      if mortgage_company(pl, v, k) == true then
	player:delay({speed = 0, cb = function() ai(pl) end})
	return
      end
    end
  end

  -- �������� �� ����������� ������ ���������� ��������
  player:delay({speed = 0, cb = function()
    if pl.cash < 0 then
      for k,v in pairs(rules_company) do
	if v.owner == pl then
	  v.owner = nil
	  v.level = 1
	  companys._child[k].mortgage_alpha = 0
	end
      end
      pl.ingame = false
      pl.pos = 1
      local x, y = getplayerxy(1, pl.k)
      pl:stop('main'):animate({x=x,y=y}):stop('blend'):set({blend_alpha = 0})
    end
  end})

--  if rules_company[pl.pos].type == "company" and not rules_company[pl.pos].owner and pl.cash >= (rules_company[pl.pos].money[1] + 200) then
    buy_company(pl, rules_company[pl.pos])
--  end

-- ����� ��������
  for k,v in pairs(rules_company) do
    if rules_company[pl.pos].type == "company" and pl.cash >= (rules_company[pl.pos].money[1] + 200) then
      if buyout_company(pl, v, k) == true then
	player:delay({speed = 0, cb = function() ai(pl) end})
	return
      end
    end
  end

-- �������� ��������
  for k,v in pairs(rules_company) do
    if rules_company[pl.pos].type == "company" and pl.cash >= (rules_group[rules_company[pl.pos].group].upgrade) then
      if buybons_company(pl, v) == true then
	player:delay({speed = 0, cb = function() ai(pl) end})
	return
      end
    end
  end
  player:delay({callback=gogo})
end

--������ �������
roll = function()
  math.randomseed(os.time() + time + math.random(99999))
  ds1 = math.random(1, 6)
  math.randomseed(os.time() + time + math.random(99999))
  ds2 = math.random(1, 6)
end
statistics = {
0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0}

-- ������� ����������� ������ �� ����.
gogo = function(s)
  local buf = s._child[__i]
  if buf.ingame == false then
    __i = __i + 1
    if __i > #player._child then __i = 1 end
    --player:delay({callback=gogo})
    gogo(s)
  else
    buf:animate({blend_alpha = 150}, {loop = true, queue = 'blend'})
    buf:animate({blend_alpha = 0}, {loop = true, queue = 'blend'})
      
    if lquery_fx == true then
      --���� ������
      local i = math.random(1,6)
      sound_dice[i]:setPitch(0.8 + math.random()/3)
      A.play(sound_dice[i])
      local j = i 
      while i == j do j = math.random(1,6) end
      sound_dice[j]:setPitch(0.8 + math.random()/3)
      A.play(sound_dice[j])
      for i = 1, 19 do
	s:delay({queue = 'roll', speed = i/200, callback = roll})
      end
    else
      s:delay({queue = 'roll', speed = 0, callback = roll})
    end

    s:delay({queue = 'roll', speed = 1, callback = function(s)
      if buf.jail > 0 then
	if ds1 == ds2 then
	  buf.jail = 0
	elseif buf.jail > 2 then
	  buf.jail = buf.jail - 1
	elseif buf.jail == 2 then
	  buf.jail = buf.jail - 1
	  money_transfer(-50, buf)
	  buf.cash = buf.cash - 50
	else
	  buf.jail = 0
	end
      end
      local buf = s._child[__i]
      if buf.jail == 0 then
	buf.pos = buf.pos + ds1 + ds2
      end
      local max = field_width*2 + field_height*2 + 4
      local add_money = false
      if buf.pos > max then
	buf.pos = buf.pos - max
	add_money = true
      end
      local x, y = getplayerxy(buf.pos, buf.k)
      buf:stop('main'):animate({x=x,y=y},{callback = function(s)
	if add_money == true then
	  money_transfer(200, buf)
	end
	local cell = rules_company[s.pos]
	if cell.action then cell.action(s) end
	ai(s)
	s:stop('blend'):set({blend_alpha = 0})
	statistics[s.pos] = statistics[s.pos] + 1
      end, speed = 1})
      if ds1 ~= ds2 or buf.pos == 32 then
	__i = __i + 1
  --      if __i > 5 then __i = 1 end
	double = 1
      elseif double < 3 then
	double = double + 1
      else
	buf.pos = 13
	local x, y = getplayerxy(13, buf.k)
	buf:stop('main'):animate({x=x,y=y}):stop('blend'):set({blend_alpha = 0})
	player:delay({callback=gogo})
	double = 1
	buf.jail = 4
	__i = __i + 1
      end
      if __i > #player._child then __i = 1 end
    end})
  end
end

player = E:new(board):delay({callback=gogo})

for k = 1, 5 do
  x, y = getplayerxy(1, k)
  E:new(player)
  :draw(player_draw)
  :set({pos = 1, w = 30, h = 30, k = k, x = x, y = y, jail = 0, ingame = true, blend_alpha = 0, cash = 1500})
end


function love.keyreleased( key, unicode )
   if key == "1" then
      player._child[1].cash = player._child[1].cash - 1000
   end
     if key == "q" then
      player._child[1].cash = player._child[1].cash + 100
   end
   if key == "2" then
      player._child[2].cash = player._child[2].cash - 1000
   end
   if key == "3" then
      player._child[3].cash = player._child[3].cash - 1000
   end
   if key == "f" then 
     if lquery_fx == true then
       lquery_fx = false
     else
       lquery_fx = true
     end
   end
   if key == "escape" then
     gamemenu:toggle()
     board_gui:toggle()
   end
end
