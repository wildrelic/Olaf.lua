--Credits to SxcS and Zwei

require("OpenPredict")
require("DamageLib")

local BPChamps =
	{
	["Aatrox"] =		true,
	["Ahri"] =			true,
	["Akali"] =			true,
	["Alistar"] =		true,
	["Amumu"] = 		true,
	["Anivia"] = 		true,
	["Annie"] = 		true,
	["Ashe"] = 			true,
	["Blitzcrank"] =	true,
	["Braum"] =			true,
	["Brand"] =			true,
	["Caitlyn"] =		true,
	["Cassiopeia"] =	true,
	["Chogath"] =		true,
	["Corki"] =			true,
	["Darius"] = 		true,
	["Diana"] =			true,
	["Draven"] =		true,
	["Ezreal"] =		true,
	["Evelynn"] =		true,
	["FiddleSticks"] =	true,
	["Fiora"] =			true,
	["Fizz"] =			true,
	["Gangplank"] =		true,
	["Gnar"] = 			true,
	["Hecarim"] =		true,
	["Illaoi"] = 		true,
	["Irelia"] =		true,
	["Karthus"] =		true,
	["Khazix"] = 		true,
	["KogMaw"] =		true,
	["JarvanIV"] =		true,
	["Jayce"] =			true,
	["Jax"] =			true,
	["Jinx"] =			true,
	["Jhin"] =			true,
	["Karma"] =			true,
	["Kassadin"] =		true,
	["Katarina"] =		true,
	["Kalista"] =		true,
	["Kayle"] =			true,
	["Kennen"] =		true,
	["Leblanc"] =		true,
	["LeeSin"] =		true,
	["Leona"] = 		true,
	["Lissandra"] =		true,
	["Lulu"] =			true,
	["Lux"] = 			true,
	["Malzahar"] =		true,
	["Morgana"] =		true,
	["MissFortune"] =	true,
	["Nami"] =			true,
	["Nasus"]=			true,
	["Nidalee"] =		true,
	["Nocturne"] =		true,
	["Nautilus"] =		true,
	["Olaf"] = 			true,
	["Orianna"] =		true,
	["Pantheon"] =		true,
	["Poppy"] =			true,
	["Quinn"] =			true,
	["Renekton"] =		true,
	["Rumble"] =		true,
	["Rengar"] =		true,
	["Ryze"] = 			true,
	["Sejuani"] =		true,
	["Shen"] = 			true,
	["Sivir"] =			true,
	["Sion"] = 			true,
	["Skarner"] =		true,
	["Soraka"] =		true,
	["Swain"] =			true,
	["Taric"] =			true,
	["Talon"] =			true,
	["Thresh"] =		true,
	["TahmKench"] =		true,
	["Tristana"] =		true,
	["Trundle"] =		true,
	["Tryndamere"] =	true,
	["TwistedFate"] =	true,
	["Twitch"] =		true,
	["Udyr"] =			true,
	["Varus"] =			true,
	["Vayne"] =			true,
	["Warwick"] = 		true,
	["XinZhao"]=		true,
	["Yasuo"] = 		true,
	["Zed"] =			true,
	["Zyra"] =			true,
	["Ziggs"] =			true,
	}

Callback.Add("Load", function()
	if BPChamps[GetObjectName(myHero)] then
		Start()
		_G[GetObjectName(myHero)]()
		PrintChat(GetObjectName(myHero).." Loaded!")
	else
		PrintChat(GetObjectName(myHero).." Is not supported!")
	end
end)

class "Start"

function Start:__init()
	local myName = myHero.charName
	BPAIO = MenuConfig("BPAIO", "BPAIO "..myName)
end

class "Annie"

function Annie:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("Q2", "Cast Q on Min", string.byte("Q"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Slider("pR", "R Pred", 0, 0, 100, 5)

BPAIO:Menu("D", "Draw")
BPAIO.D:Boolean("Q", "Draw Q", true)
BPAIO.D:Boolean("W", "Draw W", true)
BPAIO.D:Boolean("E", "Draw E", true)
BPAIO.D:Boolean("R", "Draw R", true)
BPAIO.D:Boolean("QMin", "Draw Q Minion Dmg", true)
BPAIO.D:Boolean("AA", "Draw AA Minion Dmg", true)

OnTick(function(myHero) self:Tick() end)
OnDraw(function(myHero) self:Draw() end)
end

function Annie:Tick()
local AnnieR = {delay = 0.25, speed = math.huge, width = 200, range = 600}
local target = GetCurrentTarget()
local RPred = GetCircularAOEPrediction(target, AnnieR)

	if not IsDead(target) then
if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 625) then
		CastTargetSpell(target, _Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, 625) then
		CastSkillShot(_W, GetOrigin(target))
	end
	if BPAIO.QWER.E:Value() and Ready(_E) then
		CastSpell(_E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, 600) then
		if RPred and RPred.hitChance >= (BPAIO.QWER.pR:Value()/100) then
			CastSkillShot(_R, RPred.castPos)
		end
	end
	for _, mob in pairs(minionManager.objects) do
		if BPAIO.QWER.Q2:Value() and Ready(_Q) and GetTeam(mob) == MINION_ENEMY and ValidTarget(mob, 625) then
			if GetCurrentHP(mob) + GetDmgShield(mob) <= getdmg("Q", mob, myHero, GetCastLevel(myHero, _Q)) then
				CastTargetSpell(mob, _Q)
			end
		end
	end
end
end

function Annie:Draw()
	if IsObjectAlive(myHero) then
		if BPAIO.D.Q:Value() then
			if Ready(_Q) then
				DrawCircle(GetOrigin(myHero), 625, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 625, 1, 100, ARGB(100, 225, 0, 0))
			end
		end
		if BPAIO.D.W:Value() then
			if Ready(_W) then
				DrawCircle(GetOrigin(myHero), 625, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 625, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.E:Value() then
			if Ready(_E) then
				DrawCircle(GetOrigin(myHero), 50, 1, 50, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 50, 1, 50, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.R:Value() then
			if Ready(_R) then
				DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		for _, mob in pairs(minionManager.objects) do
			if BPAIO.D.QMin:Value() and GetTeam(mob) == MINION_ENEMY and ValidTarget(mob, 3000) and Ready(_Q) then
				if GetCurrentHP(mob) + GetDmgShield(mob) <= getdmg("Q", mob, myHero, GetCastLevel(myHero, _Q)) then
					DrawCircle(GetOrigin(mob), 60, 2, 8, ARGB(200, 255, 115, 0))
				end
			end
			if BPAIO.D.AA:Value() and GetTeam(mob) == MINION_ENEMY and ValidTarget(mob, 3000)then
				if GetCurrentHP(mob) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
					DrawCircle(GetOrigin(mob), 50, 2, 8, ARGB(200, 255, 255, 255))
				end
			end
		end
	end
end

class "Ashe"

function Ashe:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Slider("pW", "W Pred", 0, 0, 100, 5)
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Slider("pR", "R Pred", 0, 0, 100, 5)

BPAIO:Menu("D", "Draw")
BPAIO.D:Boolean("Q", "Draw Q", true)
BPAIO.D:Boolean("W", "Draw W", true)
BPAIO.D:Boolean("E", "Draw E", true)
BPAIO.D:Boolean("R", "Draw R", true)
BPAIO.D:Boolean("AA", "Draw AA Min Dmg", true)

OnTick(function(myHero) self:Tick() end)
OnDraw(function(myHero) self:Draw() end)
end

function Ashe:Tick()
	local target = GetCurrentTarget()
	local AsheW = {delay = 0.25, speed = 2000, range = GetCastRange(myHero, _W), width = 60}
	local AsheR = {delay = 0.25, speed = 1600, range = GetCastRange(myHero, _R), width = 130}
	local WPred = GetPrediction(target, AsheW)
	local RPred = GetPrediction(target, AsheR)

	if not IsDead(target) then
	if BPAIO.QWER.Q:Value() and Ready(_Q) then
		CastSpell(_Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, GetCastRange(myHero, _W)) then
		if WPred and WPred.hitChance >= (BPAIO.QWER.pW:Value()/100) then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		if RPred and RPred.hitChance >= (BPAIO.QWER.pR:Value()/100) then
			CastSkillShot(_R, RPred.castPos)
		end
	end
end
end

function Ashe:Draw()
	if IsObjectAlive(myHero) then
		if BPAIO.D.Q:Value() then
			if Ready(_Q) then
				DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 225, 0, 0))
			end
		end
		if BPAIO.D.W:Value() then
			if Ready(_W) then
				DrawCircle(GetOrigin(myHero), 1200, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 1200, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.E:Value() then
			if Ready(_E) then
				DrawCircle(GetOrigin(myHero), 100, 1, 50, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 100, 1, 50, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.R:Value() then
			if Ready(_R) then
				DrawCircle(GetOrigin(myHero), 200, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 200, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		for _, mob in pairs(minionManager.objects) do
			if BPAIO.D.AA:Value() and GetTeam(mob) == MINION_ENEMY and ValidTarget(mob) then
				if GetCurrentHP(mob) + GetDmgShield(mob) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
					DrawCircle(GetOrigin(mob), 50, 2, 8, ARGB(200, 255, 255, 255))
				end
			end
		end
	end
end

class "Darius"

function Darius:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Boolean("ksR", "Auto R When Low", true)
BPAIO.QWER:Boolean("AIgn", "Auto Ignite", true)

BPAIO:Menu("D", "Draw")
BPAIO.D:Boolean("Q", "Draw Q", true)
BPAIO.D:Boolean("W", "Draw W", true)
BPAIO.D:Boolean("E", "Draw E", true)
BPAIO.D:Boolean("R", "Draw R", true)
BPAIO.D:Boolean("AA", "Draw AA Minion Dmg", true)

OnTick(function(myHero) self:Tick() end)
OnUpdateBuff(function(myHero) self:UpdateBuff() end)
OnRemoveBuff(function(myHero) self:RemoveBuff() end)
OnDraw(function(myHero) self:Draw() end)
end

local rDebuff        = {}

function Darius:UpdateBuff()
  if not unit or not buff then
    return
  end
  if buff.Name:lower() == "dariushemo" and GetTeam(buff) ~= (GetTeam(myHero)) and myHero.type == unit.type then
        rDebuff[unit.networkID] = buff.Count
    end
end

function Darius:RemoveBuff()
  if not unit or not buff then
    return
  end
  if buff.Name:lower() == "dariushemo" and GetTeam(buff) ~= (GetTeam(myHero)) and myHero.type == unit.type then
        rDebuff[unit.networkID] = 0
    end
end

function Darius:Tick()
  local target = GetCurrentTarget()
  if ValidTarget(target, 540) and BPAIO.QWER.E:Value() and not IsInDistance(target, GetRange(myHero)+GetHitBox(myHero)+GetHitBox(target)) and Ready(_E) then
CastSkillShot(_E , GetOrigin(target))
		AttackUnit(target)
      end

	if not IsDead(target) then
	if BPAIO.QWER.Q:Value() and Ready(_Q) then
		CastSpell(_Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
		AttackUnit(target)
	end
	  for _, enemy in pairs(GetEnemyHeroes()) do
    if rDebuff ~= nil then
      local realHP = (GetCurrentHP(enemy) + GetDmgShield(enemy) + (GetHPRegen(enemy) * 0.25))
      local rStacks = rDebuff[enemy.networkID] or 0
      local rDamage = (((GetSpellData(myHero, _R).level * 100) + (GetBonusDmg(myHero) * 0.75)) + (rStacks * ((GetSpellData(myHero, _R).level * 20) + (GetBonusDmg(myHero) * 0.15))))
      if ValidTarget(enemy, 460) and rDamage >= realHP and Ready(_R) and BPAIO.QWER.ksR:Value() then
        CastTargetSpell(enemy, _R)
      end
    end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, 460) then
		CastTargetSpell(target, _R)
	end
	for _,enemy in pairs(GetEnemyHeroes()) do
		if BPAIO.QWER.AIgn:Value() then
			if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
				Ignite = SUMMONER_1
				if ValidTarget(enemy, 600) then
					if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
						CastTargetSpell(enemy, Ignite)
					end
				end
			elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
				Ignite = SUMMONER_2
				if ValidTarget(enemy, 600) then
					if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
						CastTargetSpell(enemy, Ignite)
					end
				end
			end
		end
	end
end
end

function Darius:Draw()
	if IsObjectAlive(myHero) then
		if BPAIO.D.Q:Value() then
			if Ready(_Q) then
				DrawCircle(GetOrigin(myHero), 425, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 425, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.W:Value() then
			if Ready(_W) then
				DrawCircle(GetOrigin(myHero), 200, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 200, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.E:Value() then
			if Ready(_E) then
				DrawCircle(GetOrigin(myHero), 550, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 550, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.R:Value() then
			if Ready(_R) then
				DrawCircle(GetOrigin(myHero), 460, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 460, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		for _, mob in pairs(minionManager.objects) do
			if BPAIO.D.AA:Value() then
				if ValidTarget(mob) and GetTeam(mob) == MINION_ENEMY and ValidTarget(mob) then
					if GetCurrentHP(mob) + GetDmgShield(mob) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
						DrawCircle(GetOrigin(mob), 50, 2, 8, ARGB(200, 255, 255, 255))
					end
				end
			end
		end
	end
end

class "Gnar"

function Gnar:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Mini Gnar Q", string.byte("S"))
BPAIO.QWER:Key("MQ", "Cast Mega Gnar Q", string.byte("S"))
BPAIO.QWER:Slider("pQ", "Gnar Q Pred", 0, 0, 100, 5)
BPAIO.QWER:Key("W", "Cast Mega Gnar W", string.byte("D"))
BPAIO.QWER:Slider("pW", "Gnar W Pred", 0, 0, 100, 5)
BPAIO.QWER:Key("E", "Cast Mini Gnar E", string.byte("F"))
BPAIO.QWER:Key("ME", "Cast Mega Gnar E", string.byte("F"))
BPAIO.QWER:Slider("pE", "Gnar E Pred", 0, 0, 100, 5)
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

BPAIO:Menu("D", "Draw")
BPAIO.D:Boolean("Q", "Draw Q", true)
BPAIO.D:Boolean("W", "Draw W", true)
BPAIO.D:Boolean("E", "Draw E", true)
BPAIO.D:Boolean("R", "Draw R", true)
BPAIO.D:Boolean("MinQ", "Draw Q Minion", true)
BPAIO.D:Boolean("AA", "Draw AA Min", true)

OnTick(function(myHero) self:Tick() end)
OnDraw(function(myHero) slef:Draw() end)
end

function Gnar:Tick()
	local MiniGnarQ = {delay = 0.25, speed = 1225, width = 60, range = 1200}
	local MegaGnarQ = {delay = 0.5, speed = 2100, width = 90, range = 1150}
	local MegaGnarW = {delay = 0.6, speed = math.huge, width = 80, range = 600}
	local MiniGnarE = {delay = 0, speed = 903, width = 150, range = 473}
	local MegaGnarE = {delay = 0.25, speed = 1000, width = 200, range = 475}
	local target = GetCurrentTarget()
	local mQPred = GetLinearAOEPrediction(target, MiniGnarQ)
	local MQPred = GetPrediction(target, MegaGnarQ)
	local WPred = GetLinearAOEPrediction(target, MegaGnarW)
	local mEPred = GetCircularAOEPrediction(target, MiniGnarE)
	local MEPred = GetCircularAOEPrediction(target, MegaGnarE)
	local MiniGnar = (GotBuff(myHero, "gnartransform") == 0 or GotBuff(myHero, "gnarfuryhigh") == 1)
	local MegaGnar = (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1)

	if not IsDead(target) then
	if BPAIO.QWER.Q:Value() and Ready(_Q) and Ready(_Q) and ValidTarget(target, 1200) and GetCastName(myHero, _Q) == "GnarQ" and MiniGnar then
		if mQPred and mQPred.hitChance >= (BPAIO.p.pQ:Value()/100) then
			CastSkillShot(_Q, mQPred.castPos)
		end
	end
	if BPAIO.QWER.MQ:Value() and Ready(_Q) and ValidTarget(target, 1150) and GetCastName(myHero, _Q) == "GnarBigQ" and MegaGnar then
		if MQPred and MQPred.hitChance >= (BPAIO.p.pQ:Value()/100) then
			CastSkillShot(_Q, MQPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, 600) and GetCastName(myHero, _W) == "GnarBigW" and MegaGnar then
		if WPred and WPred.hitChance >= (BPAIO.p.pW:Value()/100) then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and BPAIO(target, 475) and GetCastName(myHero, _E) == "GnarE" and MiniGnar then
		if mEPred and mEPred.hitChance >= (BPAIO.p.mpE:Value()/100) then
			CastSkillShot(_E, mEPred.castPos)
		end
	end
	if BPAIO.QWER.ME:Value() and ValidTarget(target, 475) and GetCastName(myHero, _E) == "GnarBigE" and MegaGnar then
		if MEPred and MEPred.hitChance >= (BPAIO.p.MpE:Value()/100) then
			CastSkillShot(_E, MEPred.castPos)
		end
	end
end
end

function Gnar:Draw()
	local MiniGnar = (GotBuff(myHero, "gnartransform") == 0 or GotBuff(myHero, "gnarfuryhigh") == 1)
	local MegaGnar = (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1)

	if IsObjectAlive(myHero) then
		if BPAIO.D.Q:Value() then
			if Ready(_Q) and GotBuff(myHero, "gnartransform") == 0 then
				DrawCircle(GetOrigin(myHero), 1200, 1, 100, ARGB(100, 0, 255, 0))
			elseif not Ready(_Q) and GotBuff(myHero, "gnartransform") == 0 then
				DrawCircle(GetOrigin(myHero), 1200, 1, 100, ARGB(100, 255, 0, 0))
			elseif Ready (_Q) and (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1) then
				DrawCircle(GetOrigin(myHero), 1150, 1, 100, ARGB(100, 0, 255, 0))
			elseif not Ready(_Q) and (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1) then
				DrawCircle(GetOrigin(myHero), 1150, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.W:Value() then
			if Ready(_W) and GotBuff(myHero, "gnartransform") == 1 then
				DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 255, 0, 0))
			elseif not Ready(_W) and GotBuff(myHero, "gnartransform") == 1 then
				DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 0, 255, 0))
			end
		end
		if BPAIO.D.E:Value() then
			if Ready(_E) and GotBuff(myHero, "gnartransform") == 0 then
				DrawCircle(GetOrigin(myHero), 475, 1, 100, ARGB(100, 0, 255, 0))
			elseif not Ready(_E) and GotBuff(myHero, "gnartransform") == 0 then
				DrawCircle(GetOrigin(myHero), 475, 1, 100, ARGB(100, 255, 0, 0))
			elseif Ready (_E) and (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1) then
				DrawCircle(GetOrigin(myHero), 475, 1, 100, ARGB(100, 0, 255, 0))
			elseif not Ready(_E) and (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1) then
				DrawCircle(GetOrigin(myHero), 475, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.R:Value() then
			if Ready(_R) and GotBuff(myHero, "gnartransform") == 0 then
				DrawCircle(GetOrigin(myHero), 500, 1, 100, ARGB(100, 0, 255, 0))
			elseif not Ready(_R) and GotBuff(myHero, "gnartransform") == 0 then
				DrawCircle(GetOrigin(myHero), 500, 1, 100, ARGB(100, 255, 0, 0))
			elseif Ready (_R) and (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1) then
				DrawCircle(GetOrigin(myHero), 500, 1, 100, ARGB(100, 0, 255, 0))
			elseif not Ready(_R) and (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1) then
				DrawCircle(GetOrigin(myHero), 500, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		for _, mob in pairs(minionManager.objects) do
			if GetTeam(mob) == MINION_ENEMY and ValidTarget(mob, 3000)then
				if BPAIO.D.MinQ:Value() and Ready(_Q) and GetCastName(myHero, _Q) == "GnarQ" and MiniGnar then
					if GetCurrentHP(mob) + GetDmgShield(mob) < CalcDamage(myHero, mob, mQDMG, 0) then
						DrawCircle(GetOrigin(mob), 60, 2, 8, ARGB(200, 255, 115, 0))
					end
				end
				if BPAIO.D.MinQ:Value() and Ready(_Q) and GetCastName(myHero, _Q) == "GnarBigQ" and MegaGnar then
					if GetCurrentHP(mob) + GetDmgShield(mob) < CalcDamage(myHero, mob, MQDMG, 0) then
						DrawCircle(GetOrigin(mob), 60, 2, 8, ARGB(200, 255, 115, 0))
					end
				end
				if BPAIO.D.AA:Value() then
					if GetCurrentHP(mob) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
						DrawCircle(GetOrigin(mob), 50, 2, 8, ARGB(200, 255, 255, 255))
					end
				end
			end
		end
	end
end

class "Ryze"

function Ryze:__init()
BPAIO:Menu("QWER", "Cast QWE")
BPAIO.QWER:Key("Q", "Q Key", string.byte("S"))
BPAIO.QWER:Slider("pQ", "Q Pred", 0, 0, 100, 5)
BPAIO.QWER:Key("W", "W Key", string.byte("D"))
BPAIO.QWER:Key("E", "E Key", string.byte("F"))
BPAIO.QWER:Key("R", "R Key", string.byte("G"))
BPAIO.QWER:Key("aE", "Auto E Minion", string.byte("Z"))
BPAIO.QWER:Key("aQ", "Q Minion", string.byte("Q"))

BPAIO:Menu("D", "Draw")
BPAIO.D:Boolean("Q", "Draw Q", true)
BPAIO.D:Boolean("W", "Draw W", true)
BPAIO.D:Boolean("E", "Draw E", true)
BPAIO.D:Boolean("Flux", "Draw Flux", true)
BPAIO.D:Boolean("R", "Draw R", true)
BPAIO.D:Boolean("MinQ", "Draw Q Minion", true)
BPAIO.D:Boolean("MinE", "Draw E Minion", true)
BPAIO.D:Boolean("AA", "Draw Minion AA", true)

OnTick(function(myHero) self.Tick() end)
OnDraw(function(myHero) self.Draw() end)
end

function Ryze:Tick()
	local RyzeQ = {delay = 0.25, speed = 1700, width = 50, range = 900}
	local target = GetCurrentTarget()
	local QPred = GetPrediction(target, RyzeQ)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 900) then
		if QPred and QPred.hitChance >= (BPAIO.QWER.pQ:Value()/100) then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, 600) then
		CastTargetSpell(target, _W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, 600) then
		CastTargetSpell(target, _E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) then
		CastSkillShot(_R, GetMousePos())
	end
	for _, minion in pairs(minionManager.objects) do
		if GetCurrentHP(minion) + GetDmgShield(minion) < getdmg("E", minion, myHero, GetCastLevel(myHero, _E)) * 0.95 and ValidTarget(minion, 600) and Ready(_E) and BPAIO.QWER.aE:Value() then
			CastTargetSpell(minion, _E)
		end
		if BPAIO.QWER.aQ:Value() and ValidTarget(minion, 900) and Ready(_Q) then
			local QPred2 = GetPrediction(minion, RyzeQ)
			if QPred2 and QPred2.hitChance >= (BPAIO.QWER.pQ:Value()/100) then
				CastSkillShot(_Q, QPred2.castPos)
			end
		end
	end
end

function Ryze:Draw()
	if IsObjectAlive(myHero) then
		if BPAIO.D.Q:Value() then
			if Ready(_Q) then
				DrawCircle(GetOrigin(myHero), 950, 1, 100, ARGB(100, 0, 225, 0))
			else
				DrawCircle(GetOrigin(myHero), 950, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.W:Value() then
			if Ready(_W) then
				DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.E:Value() then
			if Ready(_E) then
				DrawCircle(GetOrigin(myHero), 595, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 595, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.R:Value() then
			if Ready(_R) then
				DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _R), 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _R), 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		for _, mob in pairs(minionManager.objects) do
			if GetTeam(mob) == MINION_ENEMY and ValidTarget(mob, 3000)then
				if BPAIO.D.AA:Value() then
					if GetCurrentHP(mob) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
						DrawCircle(GetOrigin(mob), 50, 2, 8, ARGB(200, 255, 255, 255))
					end
				end
				if BPAIO.D.MinQ:Value() then
					if GetCurrentHP(mob) + GetDmgShield(mob) < getdmg("Q", mob, myHero, GetCastLevel(myHero, _Q)) then
						DrawCircle(GetOrigin(mob), 70, 2, 8, ARGB(200, 0, 0, 255))
					end
				end
				if BPAIO.D.MinE:Value() then
					if GetCurrentHP(mob) + GetDmgShield(mob) < getdmg("E", mob, myHero, GetCastLevel(myHero, _Q)) * 0.925 then
						DrawCircle(GetOrigin(mob), 60, 2, 8, ARGB(200, 200, 0, 255))
					end
				end
			end
		end
	end
end

class "Poppy"

function Poppy:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Slider("pQ", "Q Pred", 0, 0, 100, 5)
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast Q", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Key("R2", "Cast R2", string.byte("Q"))
BPAIO.QWER:Slider("pR", "Cast R", 0, 0, 100, 5)

BPAIO:Menu("D", "Draw")
BPAIO.D:Boolean("Q", "Draw Q", true)
BPAIO.D:Boolean("W", "Draw W", true)
BPAIO.D:Boolean("E", "Draw E", true)
BPAIO.D:Boolean("R", "Draw R", true)
BPAIO.D:Boolean("AA", "Draw AA Min", true)

OnTick(function(myHero) self.Tick() end)
OnDraw(function(myHero) self.Draw() end)
end

function Poppy:Tick()
	local target = GetCurrentTarget()
	local PoppyQ = {delay = 0.5, speed = math.huge, width = 100, range = 430}
	local PoppyR = {delay = 0.25, speed = 1150, width = 100, range = 425}
	local PoppyR2 = {delay = 0.25, speed = 1150, width = 100, range = 1900}
	local QPred = GetPrediction(target, PoppyQ)
	local RPred = GetPrediction(target, PoppyR)
	local RPred2 = GetPrediction(target, PoppyR2)

	if not IsDead(target) then
	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 400) then
		if QPred and QPred.hitChance >= (BPAIO.QWER.pQ:Value()/100) then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, 425) then
		CastTargetSpell(target, _E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, 400) then
		if RPred and RPred.hitChance >= (BPAIO.QWER.pR:Value()/100) then
			CastSkillShot(_R, GetOrigin(myHero))
			DelayAction(function()
				CastSkillShot2(_R, RPred.castPos)
			end, 0.01)
		end
	end
	if BPAIO.QWER.R2:Value() and Ready(_R) and ValidTarget(target, 1900) then
		if RPred2 and RPred2.hitChance >= 0 then
			CastSkillShot2(_R, RPred2.castPos)
		end
	end
end
end

function Poppy:Draw()
	if IsObjectAlive(myHero) then
		if BPAIO.D.Q:Value() then
			if Ready(_Q) then
				DrawCircle(GetOrigin(myHero), 425, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 425, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.W:Value() then
			if Ready(_W) then
				DrawCircle(GetOrigin(myHero), 400, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 400, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.E:Value() then
			if Ready(_E) then
				DrawCircle(GetOrigin(myHero), 420, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 420, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.R:Value() then
			if Ready(_R) then
				DrawCircle(GetOrigin(myHero), 395, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 395, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		for _, mob in pairs(minionManager.objects) do
			if GetTeam(mob) == MINION_ENEMY and ValidTarget(mob, 3000)then
				if BPAIO.D.AA:Value() then
					if GetCurrentHP(mob) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
						DrawCircle(GetOrigin(mob), 50, 2, 8, ARGB(200, 255, 255, 255))
					end
				end
			end
		end
	end
end

class "Katarina"

function Katarina:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("aQ", "Q Minions", string.byte("Q"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Boolean("AIgn", "Auto Ignite", true)

BPAIO:Menu("D", "Draw")
BPAIO.D:Boolean("dQ", "Draw Q", true)
BPAIO.D:Boolean("dW", "Draw W", true)
BPAIO.D:Boolean("dE", "Draw E", true)
BPAIO.D:Boolean("dR", "Draw R", true)
--BPAIO.D:Boolean("Dmg", "Draw Damage", true)

OnTick(function(myHero) self.Tick() end)
OnDraw(function(myHero) self.Draw() end)
end

function Katarina:Tick()
	local target = GetCurrentTarget()

	if not IsDead(target) then
		if BPAIO.QWER.Q:Value() and ValidTarget(target, GetCastRange(myHero, _Q)) and Ready(_Q) then
			CastTargetSpell(target, _Q)
		end
		if BPAIO.QWER.W:Value() and ValidTarget(target, GetCastRange(myHero, _W)) and Ready(_W) then
			CastSpell(_W)
		end
		if BPAIO.QWER.E:Value() and ValidTarget(target, GetCastRange(myHero, _E)) and Ready(_E) then
			CastTargetSpell(target, _E)
		end
		if BPAIO.QWER.R:Value() and Ready(_R) then
			CastSpell(_R)
		end
		for _, minion in pairs(minionManager.objects) do
			if BPAIO.QWER.aQ:Value() and Ready(_Q) and ValidTarget(minion, GetCastRange(myHero, _Q)) and GetTeam(minion) == MINION_ENEMY then
				CastTargetSpell(minion, _Q)
			end
		end
		for _,enemy in pairs(GetEnemyHeroes()) do
		if BPAIO.QWER.AIgn:Value() then
			if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
				Ignite = SUMMONER_1
				if ValidTarget(enemy, 600) then
					if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
						CastTargetSpell(enemy, Ignite)
					end
				end
			elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
				Ignite = SUMMONER_2
				if ValidTarget(enemy, 600) then
					if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
						CastTargetSpell(enemy, Ignite)
					end
				end
			end
		end
	end
end
end

function Katarina:Draw()
	if BPAIO.D.dQ:Value() then
		if Ready(_Q) then
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _Q), 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _Q), 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.dW:Value() then
		if Ready(_W) then
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _W), 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _W), 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.dE:Value() then
		if Ready(_E) then
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _E), 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _E), 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	--if BPAIO.D.Dmg:Value() then
		--for _, enemy in pairs(GetEnemyHeroes()) do
			--if ValidTarget(enemy) then
			--	DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, getdmg("Q", enemy, myHero, GetCastLevel(myHero, _Q)) + getdmg("W", enemy, myHero, GetCastLevel(myHero, _W)) + getdmg("E", enemy, myHero, GetCastLevel(myHero, _E)), GoS.White)
			--end
		--end
	--end
end

class "Nasus"

function Nasus:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q on Champs", string.byte("S"))
BPAIO.QWER:Key("qQ", "Quick Cast Q", string.byte("Q"))
BPAIO.QWER:Key("sQ", "Stack Q Mininon", string.byte("Z"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Slider("pE", "E Pred", 0, 0, 100, 5)
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

BPAIO:Menu("D", "Draw")
BPAIO.D:Boolean("dW", "Draw W", true)
BPAIO.D:Boolean("dE", "Draw E", true)
BPAIO.D:Boolean("AA", "Draw AA Dmg Minion", true)
--BPAIO.D:Boolean("cDmg", "Draw Damage Q Champions", true)
BPAIO.D:Boolean("mDmg", "Draw Damage Q Minions", true)

OnTick(function(myHero) self.Tick() end)
OnDraw(function(myHero) self.Draw() end)
end

function Nasus:Tick()
local target = GetCurrentTarget()
local NasusE = { delay = 0.1, speed = math.huge, width = 400, range = 650 }
local EPred = GetCircularAOEPrediction(target, NasusE)
local qdmg = 10 + 20*GetCastLevel(myHero,_Q) + GetBonusDmg(myHero) + GetBaseDamage(myHero) + GetBuffData(myHero,"nasusqstacks").Stacks - 5 -- thanks zwei

	if not IsDead(target) then
	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 325) then
		CastSpell(_Q)
		AttackUnit(target)
	end
	if BPAIO.QWER.qQ:Value() and Ready(_Q) then
		CastSpell(_Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, 600) then
		CastTargetSpell(target, _W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, 650) then
		if EPred and EPred.hitChance >= (BPAIO.QWER.pE:Value()/100) then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) then
		CastSpell(_R)
	end
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if GetCurrentHP(minion) - GetDamagePrediction(minion, GetWindUp(myHero)) < CalcDamage(myHero, minion, qdmg,0) and ValidTarget(minion, 400) and BPAIO.QWER.sQ:Value() and Ready(_Q) then
				CastSpell(_Q)
				AttackUnit(minion)
			end
		end
	end
end
end

function Nasus:Draw()
local qdmg = 10 + 20*GetCastLevel(myHero,_Q) + GetBonusDmg(myHero) + GetBaseDamage(myHero) + GetBuffData(myHero,"nasusqstacks").Stacks - 5 -- thanks zwei

	if BPAIO.D.dW:Value() then
		if Ready(_W) then
			DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.dE:Value() then
		if Ready(_E) then
			DrawCircle(GetOrigin(myHero), 650, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 650, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	--if BPAIO.D.cDmg:Value() then
		--for _,enemy in pairs(GetEnemyHeroes()) do
			--if ValidTarget(enemy) then
				--DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), qdmg, 0, GoS.White)
			--end
		--end
	--end
	for _,mob in pairs(minionManager.objects) do
		if BPAIO.D.mDmg:Value() then
			if ValidTarget(mob) and GetTeam(mob) == MINION_ENEMY and GetCurrentHP(mob) < qdmg then
				DrawCircle(GetOrigin(mob), 70, 2, 100, ARGB(255, 150, 0, 230))
			end
		end
		if BPAIO.D.AA:Value() then
			if ValidTarget(mob) and GetTeam(mob) == MINION_ENEMY then
				if GetCurrentHP(mob) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
					DrawCircle(GetOrigin(mob), 60, 2, 8, ARGB(200, 255, 255, 255))
				end
			end
		end
	end
end

class "Tristana"

function Tristana:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("W2", "Cast W on Target", string.byte("Q"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Boolean("aR", "Auto Kill R", true)

OnTick(function(myHero) self.Tick() end)
end

function Tristana:Tick()
local target = GetCurrentTarget()
local TrisW = { delay = 0.25, speed = 2100, width = 100, range = 900 }
local WPred = GetPrediction(target, TrisW)

	if BPAIO.QWER.Q:Value() and Ready(_Q) then
		CastSpell(_Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSkillShot(_W, GetMousePos())
	end
	if BPAIO.QWER.W2:Value() and Ready(_W) and ValidTarget(target, 900) then
		if WPred and WPred.hitChance >= 0 then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, 543 + (7 * GetLevel(myHero))) then
		CastTargetSpell(target, _E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, 543 + (7 * GetLevel(myHero))) then
		CastTargetSpell(target, _R)
	end
	for _, enemy in pairs(GetEnemyHeroes()) do
		if BPAIO.QWER.aR:Value() and Ready(_R) and ValidTarget(enemy, 543 + (7 * GetLevel(myHero))) and GetCurrentHP(enemy) < getdmg("R", enemy, myHero, GetCastLevel(myHero, _R)) then
			CastTargetSpell(enemy, _R)
		end
	end
end

class "XinZhao"

function XinZhao:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Slider("eR", "Auto R at # Enemies", 3, 1, 5, 1)

BPAIO:Menu("D", "Draw Stuff")
BPAIO.D:Boolean("E", "E Range", true)
BPAIO.D:Boolean("R", "R Range", true)
--BPAIO.D:Boolean("Dmg", "Draw Dmg", true)
BPAIO.D:Boolean("AA", "AA Dmg to Min", true)

OnTick(function(myHero) self.Tick() end)
OnDraw(function(myHero) self.Draw() end)
end

function XinZhao:Tick()
local target = GetCurrentTarget()

	if not IsDead(target) then
	if Ready(_Q) and BPAIO.QWER.Q:Value() then
		CastSpell(_Q)
	end
	if Ready(_W) and BPAIO.QWER.W:Value() then
		CastSpell(_W)
	end
	if Ready(_E) and ValidTarget(target, 600) and BPAIO.QWER.E:Value() then
		CastTargetSpell(target, _E)
		DelayAction(function()
			CastSpell(_W)
			DelayAction(function()
				CastSpell(_Q)
			end, 0.01)
		end, 0.01)
	end
	if Ready(_R) and ValidTarget(target, 500) and BPAIO.QWER.R:Value() then
		CastSpell(_R)
	end
	for _,enemy in pairs(GetEnemyHeroes()) do
		if Ready(_R) and EnemiesAround(myHero, 500) >= BPAIO.QWER.eR:Value() then
			CastSpell(_R)
		end
	end
end
end

function XinZhao:Draw()

	if BPAIO.D.E:Value() then
		if Ready(_E) then
			DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.R:Value() then
		if Ready(_R) then
			DrawCircle(GetOrigin(myHero), 500, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 500, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	--for _, enemy in pairs(GetEnemyHeroes()) do
		--if BPAIO.D.Dmg:Value() and ValidTarget(enemy) then
			--DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), getdmg("R", enemy, myHero, GetCastLevel(myHero, _R)), getdmg("E", enemy, myHero, GetCastLevel(myHero, _E)), GoS.White)
		--end
	--end
	for _,mob in pairs(minionManager.objects) do
		if BPAIO.D.AA:Value() then
			if ValidTarget(mob) and GetTeam(mob) == MINION_ENEMY then
				if GetCurrentHP(mob) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
					DrawCircle(GetOrigin(mob), 60, 2, 8, ARGB(200, 255, 255, 255))
				end
			end
		end
	end
end

class "Irelia"

function Irelia:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q on Champ", string.byte("S"))
BPAIO.QWER:Key("mQ", "Cast Q on Min", string.byte("Q"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("sE", "Stun w/ E", string.byte("Z"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Slider("pR", "R Pred", 0, 0, 100, 5)

BPAIO:Menu("D", "Draw Stuff")
BPAIO.D:Boolean("Q", "Draw Q", true)
BPAIO.D:Boolean("mQ", "Draw Q Min Dmg", true)
BPAIO.D:Boolean("E", "Draw E", true)
BPAIO.D:Boolean("R", "Draw R", true)
BPAIO.D:Boolean("AA", "Draw AA on Min", true)

OnTick(function(myHero) self.Tick() end)
OnDraw(function(myHero) self.Draw() end)
end

function Irelia:Tick()
local target = GetCurrentTarget()
local IreliaR = { delay = 0, speed = 1600, width = 65, range = 1000 }
local RPred = GetPrediction(target, IreliaR)

	if not IsDead(target) then
	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 650) then
		CastTargetSpell(target, _Q)
	end
	for _, minion in pairs(minionManager.objects) do
		if BPAIO.QWER.mQ:Value() and Ready(_Q) and ValidTarget(minion, 650) and GetTeam(minion) == MINION_ENEMY and GetCurrentHP(minion) < getdmg("Q", minion, myHero, GetCastLevel(myHero, _Q)) then
			CastTargetSpell(minion, _Q)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, 425) then
		CastTargetSpell(target, _E)
	end
	if BPAIO.QWER.sE:Value() and Ready(_E) and ValidTarget(target, 425) and GetCurrentHP(target) >= GetCurrentHP(myHero) then
		CastTargetSpell(target, _E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, 1000) then
		if RPred and RPred.hitChance >= (BPAIO.QWER.pR:Value()/100) then
			CastSkillShot(_R, RPred.castPos)
		end
	end
end
end

function Irelia:Draw()
	if BPAIO.D.Q:Value() then
		if Ready(_Q) then
			DrawCircle(GetOrigin(myHero), 650, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 650, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	for _, minion in pairs(minionManager.objects) do
		if BPAIO.D.mQ:Value() and Ready(_Q) and GetTeam(minion) == MINION_ENEMY and ValidTarget(minion) then
			if GetCurrentHP(minion) < getdmg("Q", minion, myHero, GetCastLevel(myHero, _Q)) then
				DrawCircle(GetOrigin(minion), 50, 2, 100, ARGB(255, 0, 0, 255))
			end
		end
		if BPAIO.D.AA:Value() and GetTeam(minion) == MINION_ENEMY and ValidTarget(minion) then
			if GetCurrentHP(minion) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
				DrawCircle(GetOrigin(minion), 60, 2, 100, ARGB(255, 255, 255, 255))
			end
		end
	end
	if BPAIO.D.E:Value() then
		if Ready(_E) then
			DrawCircle(GetOrigin(myHero), 425, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 425, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.R:Value() then
		if Ready(_R) then
			DrawCircle(GetOrigin(myHero), 1000, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 1000, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
end

class "Cassiopeia"

function Cassiopeia:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("mQ", "Cast Q on Min", string.byte("Z"))
BPAIO.QWER:Slider("pQ", "Q Pred", 0, 0, 100, 5)
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Slider("pW", "W Pred", 0, 0, 100, 0)
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("mE", "Last Hit w/ E", string.byte("Q"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Slider("pR", "R Pred", 0, 0, 100, 0)

BPAIO:Menu("D", "Draw Stuff")
BPAIO.D:Boolean("Q", "Draw Q", true)
BPAIO.D:Boolean("W", "Draw W", true)
BPAIO.D:Boolean("E", "Draw E", true)
BPAIO.D:Boolean("R", "Draw R", true)
BPAIO.D:Boolean("AA", "Draw AA", true)
BPAIO.D:Boolean("mE", "Draw E on Min", true)

OnTick(function(myHero) self.Tick() end)
OnDraw(function(myHero) self.Draw() end)
end

function Cassiopeia:Tick()
local target = GetCurrentTarget()
local CassQ = { delay = 0.75, speed = math.huge, width = 150, range = 850 }
local CassW = { delay = nil, speed = math.huge, width = 160, range = 900 }
local CassR = { delay = 0.6, speed = math.huge, width = 150, range = 850 }
local QPred = GetCircularAOEPrediction(target, CassQ)
local WPred = GetCircularAOEPrediction(target, CassW)
local RPred = GetCircularAOEPrediction(target, CassR)

	if not IsDead(target) then
	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 850) then
		if QPred and QPred.hitChance >= (BPAIO.QWER.pQ:Value()/100) then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	for _, minion in pairs(minionManager.objects) do
		if BPAIO.QWER.mE:Value() and Ready(_E) and ValidTarget(minion, 700) and GetTeam(minion) == MINION_ENEMY and GetCurrentHP(minion) < getdmg("E", minion, myHero, GetCastLevel(myHero, _E)) then
			CastTargetSpell(minion, _E)
		end
		if BPAIO.QWER.mQ:Value() and Ready(_Q) and ValidTarget(minion, 850) and GetTeam(minion) == MINION_ENEMY then
			local QPred2 = GetCircularAOEPrediction(minion, CassQ)
			if QPred2 and QPred2.hitChance >= (BPAIO.QWER.pQ:Value()/100) then
				CastSkillShot(_Q, QPred2.castPos)
			end
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, 900) then
		if WPred and WPred.hitChance >= (BPAIO.QWER.pW:Value()/100) then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, 700) then
		CastTargetSpell(target, _E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, 850) then
		if RPred and RPred.hitChance >= (BPAIO.QWER.pR:Value()/100) then
			CastSkillShot(_R, RPred.castPos)
		end
	end
end
end

function Cassiopeia:Draw()
	if BPAIO.D.Q:Value() then
		if Ready(_Q) then
			DrawCircle(GetOrigin(myHero), 840, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 840, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.W:Value() then
		if Ready(_W) then
			DrawCircle(GetOrigin(myHero), 900, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 900, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.E:Value() then
		if Ready(_E) then
			DrawCircle(GetOrigin(myHero), 700, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 700, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.R:Value() then
		if Ready(_R) then
			DrawCircle(GetOrigin(myHero), 850, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 850, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	for _, minion in pairs(minionManager.objects) do
		if BPAIO.D.AA:Value() and GetTeam(minion) == MINION_ENEMY and ValidTarget(minion) then
			if GetCurrentHP(minion) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
				DrawCircle(GetOrigin(minion), 60, 2, 100, ARGB(255, 255, 255, 255))
			end
		end
		if BPAIO.D.mE:Value() and GetTeam(minion) == MINION_ENEMY and ValidTarget(minion) then
			if GetCurrentHP(minion) < getdmg("E", minion, myHero, GetCastLevel(myHero, _E)) then
				DrawCircle(GetOrigin(minion), 70, 2, 100, ARGB(255, 150, 80, 160))
			end
		end
	end
end

class "Jhin"

function Jhin:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("mQ", "Cast Q on Min", string.byte("Z"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Slider("pW", "W Pred", 0, 0, 100, 5)
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Slider("pE", "Cast E", 0, 0, 100, 5)
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Slider("pR", "R Pred", 0, 0, 100, 0)

BPAIO:Menu("D", "Draw Stuff")
BPAIO.D:Boolean("Q", "Draw Q", true)
BPAIO.D:Boolean("mQ", "Draw Q Min", true)
BPAIO.D:Boolean("W", "Draw W", true)
BPAIO.D:Boolean("E", "Draw E", true)
BPAIO.D:Boolean("R", "Draw R", true)
BPAIO.D:Boolean("AA", "Draw AA on Min", true)

OnTick(function(myHero) self.Tick() end)
OnDraw(function(myHero) self.Draw() end)
end

function Jhin:Tick()
local target = GetCurrentTarget()
local JhinW = { delay = 0.75, speed = 5000, width = 40, range = 2500 }
local JhinE = { delay = 0.75, speed = 1000, width = 260, range = 750 }
local JhinR = { delay = 0.25, speed = 5000, width = 80, range = 3000 }
local WPred = GetPrediction(target, JhinW)
local EPred = GetPrediction(target, JhinE)
local RPred = GetPrediction(target, JhinR)

	if not IsDead(target) then
	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 550) then
		CastTargetSpell(target, _Q)
	end
	for _, minion in pairs(minionManager.objects) do
		if BPAIO.QWER.mQ:Value() and Ready(_Q) and GetTeam(minion) == MINION_ENEMY and ValidTarget(minion, 550) and GetCurrentHP(minion) < getdmg("Q", minion, myHero, GetCastLevel(myHero, _Q)) then
			CastTargetSpell(minion, _Q)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, 2500) then
		if WPred and WPred.hitChance >= (BPAIO.QWER.pW:Value()/100) then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, 750) then
		if EPred and EPred.hitChance >= (BPAIO.QWER.pE:Value()/100) then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, 3500) then
		if RPred and RPred.hitChance >= (BPAIO.QWER.pR:Value()/100) then
			CastSkillShot(_R, RPred.castPos)
		end
	end
end
end

function Jhin:Draw()
	if BPAIO.D.Q:Value() then
		if Ready(_Q) then
			DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.W:Value() then
		if Ready(_W) then
			DrawCircle(GetOrigin(myHero), 2500, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 2500, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.E:Value() then
		if Ready(_E) then
			DrawCircle(GetOrigin(myHero), 750, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 750, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.R:Value() then
		if Ready(_R) then
			DrawCircle(GetOrigin(myHero), 3500, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 3500, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	for _, minion in pairs(minionManager.objects) do
		if BPAIO.D.AA:Value() and GetTeam(minion) == MINION_ENEMY and ValidTarget(minion) then
			if GetCurrentHP(minion) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
				DrawCircle(GetOrigin(minion), 60, 2, 100, ARGB(255, 255, 255, 255))
			end
		end
		if BPAIO.D.mQ:Value() and GetTeam(minion) == MINION_ENEMY and ValidTarget(minion) and Ready(_Q) then
			if GetCurrentHP(minion) < getdmg("Q", minion, myHero, GetCastLevel(myHero, _Q)) then
				DrawCircle(GetOrigin(minion), 70, 2, 100, ARGB(255, 230, 40, 170))
			end
		end
	end
end

class "Vayne"

function Vayne:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:DropDown("QL", "Q-Logic", 2, {"Advanced", "Simple"})
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
--BPAIO.QWER:Key("AA", "Last Hit Min", string.byte("Q"))

BPAIO:Menu("D", "Draw Stuff")
BPAIO.D:Boolean("Q", "Draw Q", true)
BPAIO.D:Boolean("E", "Draw E", true)
BPAIO.D:Boolean("AA", "Draw AA on Min", true)

OnTick(function(myHero) self.Tick() end)
OnDraw(function(myHero) self.Draw() end)
end

function Vayne:Tick()
local target = GetCurrentTarget()
local QPos = Vector(target) - (Vector(target) - Vector(myHero)):perpendicular():normalized() * ( GetDistance(myHero,target) * 1.2 )
local QPos2 = Vector(Vector(myHero) - Vector(target)) + Vector(myHero):normalized() * 75
local QPos3 = Vector(target) + Vector(target):normalized()

	if not IsDead(target) then
	if BPAIO.QWER.Q:Value() and Ready(_Q) then
		if BPAIO.QWER.QL:Value() == 1 and GetDistance(myHero,target) > 275 and ValidTarget(target, 875) then
			CastSkillShot(_Q, QPos)
		elseif BPAIO.QWER.QL:Value() == 1 and GetDistance(myHero,target) < 275 and ValidTarget(target, 875) then
			CastSkillShot(_Q, QPos2)
		elseif BPAIO.QWER.QL:Value() == 1 and GetDistance(myHero,target) > 650 and ValidTarget(target, 875) then
			CastSkillShot(_Q, QPos3)
		elseif BPAIO.QWER.QL:Value() == 2 then
			CastSkillShot(_Q, GetMousePos())
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		CastTargetSpell(target, _E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) then
		CastSpell(_R)
		DelayAction(function()
			CastSkillShot(_Q, GetMousePos())
		end, 0.01)
	end
	--for _, minion in pairs(minionManager.objects) do
		--if BPAIO.QWER.AA:Value() and GetTeam(minion) == MINION_ENEMY and ValidTarget(minion, 550) then
			---if GetCurrentHP(minion) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
				--AttackUnit(minion)
			--end
		--end
	--end
end
end

function Vayne:Draw()
	if BPAIO.D.Q:Value() then
		if Ready(_Q) then
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _Q), 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _Q), 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.E:Value() then
		if Ready(_E) then
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _E), 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _E), 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	for _, minion in pairs(minionManager.objects) do
		if BPAIO.D.AA:Value() and GetTeam(minion) == MINION_ENEMY and ValidTarget(minion) then
			if GetCurrentHP(minion) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
				DrawCircle(GetOrigin(minion), 60, 2, 100, ARGB(255, 255, 255, 255))
			end
		end
	end
end

class "Ezreal"

function Ezreal:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Slider("pQ", "Q Pred", 0, 0, 100, 5)
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Slider("pW", "W Pred", 0, 0, 100, 5)
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Slider("pR", "R Pred", 0, 0, 100, 0)
BPAIO.QWER:Key("mQ", "Cast Q Farm", string.byte("Q"))

BPAIO:Menu("D", "Draw Stuff")
BPAIO.D:Boolean("Q", "Draw Q", true)
BPAIO.D:Boolean("W", "Draw W", true)
BPAIO.D:Boolean("E", "Draw E", true)
BPAIO.D:Boolean("AA", "Draw AA on Min", true)
BPAIO.D:Boolean("mQ", "Draw Q on Min", true)

OnTick(function(myHero) self:Tick() end)
OnDraw(function(myHero) self:Draw() end)
end

function Ezreal:Tick()
local target = GetCurrentTarget()
local EzQ = { delay = 0.25, speed = 1975, width = 50, range = GetCastRange(myHero, _Q) }
local EzW = { delay = 0.25, speed = 1500, width = 80, range = GetCastRange(myHero, _W) }
local EzR = { delay = 1, speed = 2000, width = 150, range = GetCastRange(myHero, _R) }
local QPred = GetPrediction(target, EzQ)
local WPred = GetPrediction(target, EzW)
local RPred = GetPrediction(target, EzR)

	if not IsDead(target) then
	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		if QPred and QPred.hitChance >= (BPAIO.QWER.pQ:Value()/100) then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, GetCastRange(myHero, _W)) then
		if WPred and WPred.hitChance >= (BPAIO.QWER.pW:Value()/100) then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) then
		CastSkillShot(_E, GetMousePos())
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		if RPred and RPred.hitChance >= (BPAIO.QWER.pR:Value()/100) then
			CastSkillShot(_R, RPred.castPos)
		end
	end
	for _, minion in pairs(minionManager.objects) do
		if BPAIO.QWER.mQ:Value() and Ready(_Q) and GetTeam(minion) == MINION_ENEMY and ValidTarget(minion, GetCastRange(myHero, _Q)) and GetCurrentHP(minion) < getdmg("Q", minion, myHero, GetCastLevel(myHero, _Q)) then
			local QPred2 = GetPrediction(minion, EzQ)
			if QPred2 and QPred2.hitChance >= (BPAIO.QWER.pQ:Value()/100) then
				CastSkillShot(_Q, QPred2.castPos)
			end
		end
	end
end
end

function Ezreal:Draw()
	if BPAIO.D.Q:Value() then
		if Ready(_Q) then
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _Q), 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _Q), 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.W:Value() then
		if Ready(_W) then
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _W), 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _W), 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.E:Value() then
		if Ready(_E) then
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _E), 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _E), 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	for _, minion in pairs(minionManager.objects) do
		if BPAIO.D.AA:Value() and GetTeam(minion) == MINION_ENEMY and ValidTarget(minion) then
			if GetCurrentHP(minion) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
				DrawCircle(GetOrigin(minion), 60, 2, 100, ARGB(255, 255, 255, 255))
			end
		end
		if BPAIO.D.mQ:Value() and GetTeam(minion) == MINION_ENEMY and ValidTarget(minion) and Ready(_Q) then
			if GetCurrentHP(minion) < getdmg("Q", minion, myHero, GetCastLevel(myHero, _Q)) then
				DrawCircle(GetOrigin(minion), 70, 2, 100, ARGB(255, 0, 0, 255))
			end
		end
	end
end

class "Caitlyn"

function Caitlyn:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Slider("pQ", "Q Pred", 0, 0, 100, 5)
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Slider("pW", "Cast W", 0, 0, 100, 5)
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Slider("pE", "E Pred", 0, 0, 100, 5)
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
--BPAIO.QWER:Boolean("aR", "Auto R", true)

BPAIO:Menu("D", "Draw Stuff")
BPAIO.D:Boolean("Q", "Draw Q", true)
BPAIO.D:Boolean("W", "Draw W", true)
BPAIO.D:Boolean("E", "Draw E", true)
BPAIO.D:Boolean("R", "Draw R", true)
BPAIO.D:Boolean("AA", "Draw AA on Min", true)

OnTick(function(myHero) self.Tick() end)
OnDraw(function(myHero) self.Draw() end)
end

function Caitlyn:Tick()
local target = GetCurrentTarget()
local CaitQ = { delay = 0.625, speed = 1800, width = 90, range = GetCastRange(myHero, _Q) }
local CaitW = { delay = 0.75, speed = math.huge, width = 67, range = GetCastRange(myHero, _W) }
local CaitE = { delay = 0.4, speed = 1600, width = 70, range = GetCastRange(myHero, _E) }
local QPred = GetPrediction(target, CaitQ)
local WPred = GetCircularAOEPrediction(target, CaitW)
local EPred = GetPrediction(target, CaitE)

	if not IsDead(target) then
	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		if QPred and QPred.hitChance >= (BPAIO.QWER.pQ:Value()/100) then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, GetCastRange(myHero, _W)) then
		if WPred and WPred.hitChance >= (BPAIO.QWER.pW:Value()/100) then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		if EPred and EPred.hitChance >= (BPAIO.QWER.pE:Value()/100) then
			CastSkillShot(_E, EPred.castPos)
			AttackUnit(target)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		CastTargetSpell(target, _R)
	end
	--for _, enemy in pairs(GetEnemyHeroes()) do
		--if BPAIO.QWER.aR:Value() and ValidTarget(target, GetCastRange(myHero, _R)) and GetCurrentHP(target) < getdmg("R", enemy, myHero, GetCastLevel(myHero, _R)) then
			--CastTargetSpell(enemy, _R)
		--end
	--end
end
end

function Caitlyn:Draw()
	if BPAIO.D.Q:Value() then
		if Ready(_Q) then
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _Q), 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _Q), 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.W:Value() then
		if Ready(_W) then
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _W), 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _W), 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.E:Value() then
		if Ready(_E) then
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _E), 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _E), 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.R:Value() then
		if Ready(_R) then
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _R), 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _R), 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	for _, minion in pairs(minionManager.objects) do
		if BPAIO.D.AA:Value() and GetTeam(minion) == MINION_ENEMY and ValidTarget(minion) then
			if GetCurrentHP(minion) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
				DrawCircle(GetOrigin(minion), 60, 2, 100, ARGB(255, 255, 255, 255))
			end
		end
	end
end

class "Jayce"

function Jayce:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q1", "Cast Q1", string.byte("S"))
BPAIO.QWER:Key("Q2", "Cast Q2", string.byte("S"))
BPAIO.QWER:Slider("pQ2", "Q1 Pred", 0, 0, 100, 5)
BPAIO.QWER:Key("W1", "Cast W1", string.byte("D"))
BPAIO.QWER:Key("W2", "Cast W2", string.byte("D"))
BPAIO.QWER:Key("E1", "Cast E1", string.byte("F"))
BPAIO.QWER:Key("E2", "Cast E2", string.byte("F"))
BPAIO.QWER:Key("EQ", "Cast E + Q", string.byte("Q"))
--BPAIO.QWER:Slider("pE2", "E2 Pred", 0, 0, 100, 5)
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

BPAIO:Menu("D", "Draw Stuff")
BPAIO.D:Boolean("Q1", "Draw Q1", true)
BPAIO.D:Boolean("Q2", "Draw Q2", true)
BPAIO.D:Boolean("W1", "Draw W1", true)
BPAIO.D:Boolean("E1", "Draw E1", true)
BPAIO.D:Boolean("E2", "Draw E2", true)
BPAIO.D:Boolean("AA", "Draw AA on Min", true)

OnTick(function(myHero) self.Tick() end)
OnDraw(function(myHero) self.Draw() end)
end

function Jayce:Tick()
local target = GetCurrentTarget()
local JayceQ = { delay = 0.25, speed = 1450, width = 70, range = 1300 }
--local JayceE = { delay = 0.25, speed = math.huge, width = 100, range = 650 }
local QPred = GetPrediction(target, JayceQ)
--local EPred = GetPrediction(target, JayceE)


	if BPAIO.QWER.Q1:Value() and Ready(_Q) and ValidTarget(target, 600) and GotBuff(myHero, "JaycePassiveMeleeAttack") then
		CastTargetSpell(target, _Q)
	end
	if BPAIO.QWER.Q2:Value() and Ready(_Q) and ValidTarget(target, 1300) and GotBuff(myHero, "JaycePassiveRangeAttack") then
		if QPred and QPred.hitChance >= (BPAIO.QWER.pQ2:Value()/100) then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W1:Value() and Ready(_W) and ValidTarget(target, 285) and GotBuff(myHero, "JaycePassiveMeleeAttack") then
		CastSpell(_W)
	end
	if BPAIO.QWER.W2:Value() and Ready(_W) and GotBuff(myHero, "JaycePassiveRangeAttack") then
		CastSpell(_W)
	end
	if BPAIO.QWER.E1:Value() and Ready(_E) and ValidTarget(target, 240) and GotBuff(myHero, "JaycePassiveMeleeAttack") then
		CastTargetSpell(target, _E)
	end
	if BPAIO.QWER.E2:Value() and Ready(_E) and GotBuff(myHero, "JaycePassiveRangeAttack") then
		CastSkillShot(_E, GetMousePos())
	end
	if BPAIO.QWER.R:Value() and Ready(_R) then
		CastSpell(_R)
	end
	if BPAIO.QWER.EQ:Value() and Ready(_E) and Ready(_Q) and ValidTarget(target, 1300) and GotBuff(myHero, "JaycePassiveRangeAttack") then
		if QPred and QPred.hitChance >= (BPAIO.QWER.pQ2:Value()/100) then
			CastSkillShot(_E, GetMousePos())
			DelayAction(function()
				CastSkillShot(_Q, QPred.castPos)
			end, 0.01)
		end
	end
end

function Jayce:Draw()
	if BPAIO.D.Q1:Value() and GotBuff(myHero, "JaycePassiveMeleeAttack") then
		if Ready(_Q) then
			DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.Q2:Value() and GotBuff(myHero, "JaycePassiveRangeAttack") then
		if Ready(_Q) then
			DrawCircle(GetOrigin(myHero), 1300, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 1300, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.W1:Value() and GotBuff(myHero, "JaycePassiveMeleeAttack") then
		if Ready(_W) then
			DrawCircle(GetOrigin(myHero), 285, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 285, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.E1:Value() and GotBuff(myHero, "JaycePassiveMeleeAttack") then
		if Ready(_E) then
			DrawCircle(GetOrigin(myHero), 240, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 240, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.E2:Value() and GotBuff(myHero, "JaycePassiveRangeAttack") then
		if Ready(_E) then
			DrawCircle(GetOrigin(myHero), 650, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 650, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	for _, minion in pairs(minionManager.objects) do
		if BPAIO.D.AA:Value() and GetTeam(minion) == MINION_ENEMY and ValidTarget(minion) then
			if GetCurrentHP(minion) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
				DrawCircle(GetOrigin(minion), 60, 2, 100, ARGB(255, 255, 255, 255))
			end
		end
	end
end

class "LeeSin"

function LeeSin:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Slider("pQ", "Q Pred", 0, 0, 100, 5)
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function LeeSin:Tick()
local target = GetCurrentTarget()
local LeeQ = { delay = 0.1, speed = 1800, width = 65, range = 1000}
local QPred = GetPrediction(target, LeeQ)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 1000) then
		if QPred and QPred.hitChance >= (BPAIO.QWER.pQ:Value()/100) then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, 350) then
		CastSpell(_E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, 375) then
		CastTargetSpell(target, _R)
	end
end

class "Orianna"

function Orianna:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("mQ", "Cast Q on Min", string.byte("Q"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Orianna:Tick()
local target = GetCurrentTarget()
local OriQ = { delay = 0, speed = 1200, width = 80, range = GetCastRange(myHero, _Q) }
local QPred = GetPrediction(target, OriQ)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) then
		CastTargetSpell(GetMyHero(), _E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) then
		CastSpell(_R)
	end
	for _, minion in pairs(minionManager.objects) do
		if BPAIO.QWER.mQ:Value() and ValidTarget(minion, 1500) and Ready(_Q) and GetCurrentHP(minion) < getdmg("Q", minion, myHero, GetCastLevel(myHero, _Q)) then
			local QPred2 = GetPrediction(minion, OriQ)
			if QPred2 and QPred2.hitChance >= 0 then
				CastSkillShot(_Q, QPred2.castPos)
			end
		end
	end
end

class "Taric"

function Taric:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("W"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Taric:Tick()
local target = GetCurrentTarget()
local TaricE = { delay = 0.25, speed = 1000, width = 150, range = 900}
local EPred = GetPrediction(target, TaricE)

	if BPAIO.QWER.Q:Value() and Ready(_Q) then
		CastSpell(_Q)
	end
	for _, ally in pairs(GetAllyHeroes()) do
		if Ready(_W) and GetDistance(myHero, ally) <= 1000 and not IsDead(ally) then
			ally:Cast(_W, GetOrigin(ally))
		end
	end
	if Ready(_W) then
		myHero:Cast(_W, GetOrigin(myHero))
	end
	if Ready(_E) and ValidTarget(target, 900) and BPAIO.QWER.E:Value() then
		if EPred and EPred.hitChance >= 0 then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) then
		CastSpell(_R)
	end
end


class "Lulu"

function Lulu:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))

OnTick(function(myHero) self.Tick() end)
end

function Lulu:Tick()
local target = GetCurrentTarget()
local LuluQ = { delay = 0.25, speed = 1450, width = 60, range = 950 }
local QPred = GetPrediction(target, LuluQ)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 950) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
end

class "Leblanc"

function Leblanc:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Leblanc:Tick()
local target = GetCurrentTarget()
local LeW = { delay = 0, speed = 1450, width = 220, range = 600 }
local LeE = { delay = 0, speed = 1750, width = 70, range = 950 }
local WPred = GetCircularAOEPrediction(target, LeW)
local EPred = GetPrediction(target, LeE)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		CastTargetSpell(target, _Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, GetCastRange(myHero, _W)) then
		if WPred and WPred.hitChance >= 0 then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		if EPred and EPred.hitChance >= 0 then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) then
		if GetCastName(myHero, _R) == "LeblancChaosOrbM" and ValidTarget(target, GetCastRange(myHero, _Q)) then
			CastTargetSpell(target, _R)
		end
		if GetCastName(myHero, _R) == "LeblancSlideM" and ValidTarget(target, GetCastRange(myHero, _W)) then
			if WPred and WPred.hitChance >= 0 then
				CastSkillShot(_R, WPred.castPos)
			end
		end
		if GetCastName(myHero, _R) == "LeblancSoulShackleM" and ValidTarget(target, GetCastRange(myHero, _E)) then
			if EPred and EPred.hitChance >= 0 then
				CastSkillShot(_R, EPred.castPos)
			end
		end
	end
end

class "Malzahar"

function Malzahar:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Malzahar:Tick()
local target = GetCurrentTarget()
local MalzQ = { delay = 0.75, speed = math.huge, width = 100, range = GetCastRange(myHero, _Q) }
local MalzW = { delay = 0.75, speed = math.huge, width = 50, range = GetCastRange(myHero, _W) }
local QPred = GetPrediction(target, MalzQ)
local WPred = GetPrediction(target, MalzW)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, GetCastRange(myHero, _W)) then
		if WPred and WPred.hitChance >= 0 then
			CastSkillShot(_W, WPred.hitChance)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		CastTargetSpell(target, _E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		CastTargetSpell(target, _R)
	end
end

class "Yasuo"

function Yasuo:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Key("mQ", "Cast Q on Min", string.byte("Z"))
BPAIO.QWER:Key("mE", "Cast E on Min", string.byte("Q"))

OnTick(function(myHero) self.Tick() end)
end

function Yasuo:Tick()
local target = GetCurrentTarget()
local YasQ = { delay = 0.4, speed = math.huge, width = 20, range = 550 }
local YasQ2 = {delay = 0.5, speed = 1500, width = 90, range = 1200 }
local YasW = { delay = 0, speed = math.huge, width = 100, range = 20000}
local QPred = GetPrediction(target, YasQ)
local Q2Pred = GetPrediction(target, YasQ2)
local WPred = GetPrediction(target, YasW)

	if BPAIO.QWER.Q:Value() and Ready(_Q) then
		--if GetCastName(myHero, _Q) == "yasuoqw" or GetCastName(myHero, _Q) == "yasuoq2" then
			--if ValidTarget(target, 550) then
				--if QPred and QPred.hitChance >= 0 then
					--CastSkillShot(_Q, QPred.castPos)
				--end
			--end
		--end
		--if GetCastName(myHero, _Q) == "yasuoq3" then
			if ValidTarget(target, 1200) then
				if Q2Pred and Q2Pred.hitChance >= 0 then
					CastSkillShot(_Q, Q2Pred.castPos)
				end
			end
		--end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		if ValidTarget(target, 2000) then
			if WPred and WPred.hitChance >= 0 then
				CastSkillShot(_W, WPred.castPos)
			end
		else
			CastSkillShot(_W, GetMousePos())
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		CastTargetSpell(target, _E)
	end
	for _, mob in pairs(minionManager.objects) do
		if BPAIO.QWER.mE:Value() and Ready(_E) and ValidTarget(mob, GetCastRange(myHero, _E)) and GetCurrentHP(mob) < getdmg("E", mob, myHero, GetCastLevel(myHero, _E)) then
			CastTargetSpell(mob, _E)
		end
		if BPAIO.QWER.mQ:Value() and Ready(_Q) and ValidTarget(mob, GetCastRange(myHero, _Q)) and GetCurrentHP(mob) < getdmg("Q", mob, myHero, GetCastLevel(myHero, _Q)) then
			--if GetCastName(myHero, _Q) == "yasuoqw" or GetCastName(myHero, _Q) == "yasuoq2" then
				--local QPred2 = GetPrediction(mob, YasQ)
				--if QPred and QPred.hitChance >= 0 then
					--CastSkillShot(_Q, QPred2.castPos)
				--end
			--end
			if GetCastName(myHero, _Q) == "yasuoq3" then
				local QPred3 = GetPrediction(mob, YasQ2)
				if QPred3 and QPred.hitChance >= 0 then
					CastSkillShot(_Q, QPred3.castPos)
				end
			end
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		CastSpell(_R)
	end
end

class "Akali"

function Akali:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

BPAIO:Menu("D", "Draw Stuff")
BPAIO.D:Boolean("mQ", "Draw Q on Min", true)
BPAIO.D:Boolean("mE", "Draw E on Min", true)

OnTick(function(myHero) self.Tick() end)
OnDraw(function(myHero) self.Draw() end)
end

function Akali:Tick()
local target = GetCurrentTarget()
local AkaliW = { delay = 0.25, speed = math.huge, width = 400, range = 700 }
local WPred = GetPrediction(target, AkaliW)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		CastTargetSpell(target, _Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, 700) then
		if WPred and WPred.hitChance >= 0 then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		CastSpell(_E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		CastTargetSpell(target, _R)
	end
end

function Akali:Draw()
	for _, mob in pairs(minionManager.objects) do
		if BPAIO.D.mQ:Value() and Ready(_Q) and ValidTarget(mob) and GetCurrentHP(mob) < getdmg("Q", mob, myHero, GetCastLevel(myHero, _Q)) then
			DrawCircle(mob, 70, 2, 100, ARGB(255, 0, 0, 255))
		end
		if BPAIO.D.mE:Value() and Ready(_E) and ValidTarget(mob) and GetCurrentHP(mob) < getdmg("E", mob, myHero, GetCastLevel(myHero, _E)) then
			DrawCircle(mob, 60, 2, 100, ARGB(255, 255, 0, 255))
		end
	end
end

class "Sivir"

function Sivir:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Sivir:Tick()
local target = GetCurrentTarget()
local SivirQ = { delay = 0.25, speed = 1350, width = 100, range = 1075 }
local QPred = GetPrediction(target, SivirQ)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 1075) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) then
		CastSpell(_E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, 2000) then
		CastSpell(_R)
	end
end

class "Blitzcrank"

function Blitzcrank:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Blitzcrank:Tick()
local target = GetCurrentTarget()
local BlitzQ = { delay = 0.25, speed = 1800, width = 70, range = 1050 }
local QPred = GetPrediction(target, BlitzQ)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 1050) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, 250) then
		CastSpell(_E)
		DelayAction(function()
			AttackUnit(target)
		end, 0.01)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, 600) then
		CastSpell(_R)
	end
end

class "Draven"

function Draven:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Draven:Tick()
local target = GetCurrentTarget()
local DravenE = { delay = 0.25, speed = 1400, width = 130, range = 1100 }
local DravenR = { delay = 0.5, speed = 1400, width = 130, range = GetCastRange(myHero, _R) }
local EPred = GetPrediction(target, DravenE)
local RPred = GetPrediction(target, DravenR)

	if BPAIO.QWER.Q:Value() and Ready(_Q) then
		CastSpell(_Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, 2000) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _R)) then
		if EPred and EPred.hitChance >= 0 then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		if RPred and RPred.hitChance >= 0 then
			CastSkillShot(_R, RPred.castPos)
		end
	end
end

class "Evelynn"

function Evelynn:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("R"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Evelynn:Tick()
local target = GetCurrentTarget()
local EveR = { delay = 0.25, speed = math.huge, width = 350, range = 650 }
local RPred = GetPrediction(target, EveR)

	if BPAIO.QWER.Q:Value() and Ready(_Q) then
		CastSpell(_Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		CastTargetSpell(target, _E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		if RPred and RPred.hitChance >= 0 then
			CastSkillShot(_R, RPred.castPos)
		end
	end
end

class "Fiora"

function Fiora:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Fiora:Tick()
local target = GetCurrentTarget()
local FioraQ = { delay = 0, speed = 1200, width = 70, range = 800 }
local FioraW = { delay = 0.5, speed = 3200, width = 70, range = 800 }
local QPred = GetPrediction(target, FioraQ)
local WPred = GetPrediction(target, FioraW)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 800) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, 800) then
		if WPred and WPred.hitChance >= 0 then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, 300) then
		CastSpell(_E)
		DelayAction(function()
			AttackUnit(target)
		end, 0.01)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		CastTargetSpell(target, _R)
	end
end

class "Fizz"

function Fizz:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Fizz:Tick()
local target = GetCurrentTarget()
local FizzE = { delay = 0.25, speed = math.huge, width = 270, range = 800 }
local FizzR = { delay = 0.25, speed = 1350, width = 120, range = 1150 }
local EPred = GetPrediction(target, FizzE)
local RPred = GetPrediction(target, FizzR)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		CastTargetSpell(target, _Q)
		AttackUnit(target)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) then
		if ValidTarget(target, 800) then
			if EPred and EPred.hitChance >= 0 then
				CastSkillShot(_E, EPred.castPos)
			end
		elseif not ValidTarget(target, 800) then
			CastSkillShot(_E, GetMousePos())
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		if RPred and RPred.hitChance >= 0 then
			CastSkillShot(_R, RPred.castPos)
		end
	end
end

class "Hecarim"

function Hecarim:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Hecarim:Tick()
local target = GetCurrentTarget()
local HecR = { delay = 0, speed = 1500, width = 350, range = 1000 }
local RPred = GetPrediction(target, HecR)

	if BPAIO.QWER.Q:Value() and Ready(_Q) then
		CastSpell(_Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) then
		CastSpell(_E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, 1000) then
		if RPred and RPred.hitChance >= 0 then
			CastSkillShot(_R, RPred.castPos)
		end
	end
end

class "Talon"

function Talon:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Talon:Tick()
local target = GetCurrentTarget()
local TalonW = { delay = 0.25, speed = 2300, width = 80, range = 800 }
local WPred = GetPrediction(target, TalonW)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 300) then
		CastSpell(_Q)
		DelayAction(function()
			AttackUnit(target)
		end, 0.01)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, 800) then
		if WPred and WPred.hitChance >= 0 then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		CastTargetSpell(target, _E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		CastSpell(_R)
	end
end

class "Tryndamere"

function Tryndamere:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("aQ", "Auto Cast Q", string.byte("Q"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Slider("hQ", "Health for R", 10, 1, 100, 1)

OnTick(function(myHero) self.Tick() end)
end

function Tryndamere:Tick()
local target = GetCurrentTarget()
local TryndE = { delay = 0, speed = 1300, width = 93, range = 660 }
local EPred = GetPrediction(target, TryndE)

	if BPAIO.QWER.Q:Value() and Ready(_Q) then
		CastSpell(_Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, 660) then
		if EPred and EPred.hitChance >= 0 then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and GetPercentHP(myHero) <= BPAIO.QWER.hQ:Value() then
		CastSpell(_R)
	end
end

class "Renekton"

function Renekton:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("aQ", "Auto Cast Q", string.byte("Q"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Boolean("It", "Use Items", true)
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("aE", "Auto Cast E", string.byte("Z"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Boolean("aR", "Auto Cast R", false)
BPAIO.QWER:Slider("aR1", "Auto Cast R # of Enemies", 1, 1, 5, 1)
BPAIO.QWER:Slider("aR2", "Auto Cast R % Health", 10, 1, 100, 1)

OnTick(function(myHero) self.Tick() end)
end

function Renekton:Tick()
local target = GetCurrentTarget()
local RenekE = { delay = 0, speed = 1300, width = 70, range = 900 }
local EPred = GetPrediction(target, RenekE)
aaResetItems={3074,3077,3748}

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		CastSpell(_Q)
	end
	if BPAIO.QWER.aQ:Value() and Ready(_Q) then
		CastSpell(_Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, 250) then
		for _, id in pairs(aaResetItems) do
			if (BPAIO.QWER.It:Value() and GetItemSlot(myHero, id) > 0) then
				CastSpell(_W)
				AttackUnit(target)
					DelayAction(function()
					CastSpell(GetItemSlot(myHero,id))
				end, 0.01)
			else
				CastSpell(_W)
				AttackUnit(target)
			end
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, 900) then
		if EPred and EPred.hitChance >= 0 then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.aE:Value() and Ready(_E) then
		CastSkillShot(_E, GetMousePos())
	end
	if BPAIO.QWER.R:Value() and Ready(_R) then
		CastSpell(_R)
	end
	if BPAIO.QWER.aR:Value() and Ready(_R) and BPAIO.QWER.aR1:Value() >= EnemiesAround(myHero, 1500) and GetPercentHP(myHero) <= BPAIO.QWER.aR2:Value() then
		CastSpell(_R)
	end
end

class "Soraka"

function Soraka:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Boolean("aW", "Auto W", true)
BPAIO.QWER:Slider("aaW", "Ally % Health W", 40, 1, 100, 1)
BPAIO.QWER:Boolean("aR", "Auto R", true)
BPAIO.QWER:Slider("aaR", "Ally % Health R", 40, 1, 100, 1)

OnTick(function(myHero) self.Tick() end)
end

function Soraka:Tick()
local target = GetCurrentTarget()
local SorakaQ = { delay = 0.5, speed = 1750, width = 235, range = 950 }
local SorakaE = { delay = 0.25, speed = math.huge, width = 300, range = 925 }
local QPred = GetPrediction(target, SorakaQ)
local EPred = GetPrediction(target, SorakaE)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 950) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	for _,ally in pairs(GetAllyHeroes()) do
		if BPAIO.QWER.W:Value() and Ready(_W) and GetDistance(myHero,ally)<GetCastRange(myHero,_W) then
			CastTargetSpell(ally, _W)
		end
		if BPAIO.QWER.aW:Value() and Ready(_W) and GetDistance(myHero,ally)<GetCastRange(myHero,_W) and GetPercentHP(ally) <= BPAIO.QWER.aaW:Value() then
			CastTargetSpell(ally, _W)
		end
		if BPAIO.QWER.aR:Value() and Ready(_R) and not IsDead(ally) and GetPercentHP(ally) <= BPAIO.QWER.aaR:Value() then
			CastSpell(_R)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, 925) then
		if EPred and EPred.hitChance >= 0 then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) then
		CastSpell(_R)
	end
end

class "Corki"

function Corki:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Corki:Tick()
local target = GetCurrentTarget()
local CorkiQ = { delay = 0.3, speed = 1000, width = 250, range = 850 }
local CorkiW = { delay = 0.2, speed = 1600, width = 140, range = 600 }
local CorkiW2 = {delay = 0.2, speed = 1600, width = 140, range = 1900 }
local CorkiR = { delay = 0.2, speed = 2000, width = 40, range = 1300 }
local CorkiR2 = { delay = 0.2, speed = 2000, width = 40, range = 1500 }
local QPred = GetPrediction(target, CorkiQ)
local WPred = GetPrediction(target, CorkiW)
local WPred2 = GetPrediction(target, CorkiW2)
local RPred = GetPrediction(target, CorkiR)
local RPred2 = GetPrediction(target, CorkiR2)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 850) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		if GetCastName(myHero, _W) == "CarpetBomb" and ValidTarget(target, 600) then
			if WPred and WPred.hitChance >= 0 then
				CastSkillShot(_W, WPred.castPos)
			end
		elseif GetCastName(myHero, _W) == "CarpetBombMega" and ValidTarget(target, 1900) then
			if WPred2 and WPred2.hitChance >= 0 then
				CastSkillShot(_W, WPred2.castPos)
			end
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) then
		CastSkillShot(_E, GetOrigin(target))
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, 1300) then
			if RPred and RPred.hitChance >= 0 then
				CastSkillShot(_R, RPred.castPos)
			end
		end
end

class "Kalista"

function Kalista:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Slider("maE", "E mana", 10, 1, 100, 1)
BPAIO.QWER:Boolean("cE", "Auto E Champ", true)
BPAIO.QWER:Boolean("mE", "Auto E Minion", true)
BPAIO.QWER:Boolean("jE", "Auto E Jungle", true)
BPAIO.QWER:Slider("oE", "E Overkill", 50, 0, 250, 10)
BPAIO.QWER:Slider("dE", "Delay on E", 10, 0, 50, 1)
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Kalista:Tick()
local target = GetCurrentTarget()
local KaliQ = { delay = 0.25, speed = 1700, width = 40, range = 1200 }
local QPred = GetPrediction(target, KaliQ)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSkillShot(_W, GetMousePos())
	end
	if BPAIO.QWER.E:Value() and Ready(_E) then
		CastSpell(_E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) then
		CastSpell(_R)
	end
end

class "Karma"

function Karma:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function() self.Tick() end)
end

function Karma:Tick()
local target = GetCurrentTarget()
local KarmaQ = { delay = 0.25, speed = 1700, width = 60, range = 1050 }
local QPred = GetPrediction(target, KarmaQ)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, GetCastRange(myHero, _W)) then
		CastTargetSpell(target, _W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) then
		CastTargetSpell(GetMyHero(), _E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) then
		CastSpell(_R)
	end
end

class "Kassadin"

function Kassadin:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Key("Q2", "Cast Q on Min", string.byte("Q"))

OnTick(function() self.Tick() end)
end

function Kassadin:Tick()
local target = GetCurrentTarget()
local KassE = { delay = 0.25, speed = math.huge, width = 100, range = GetCastRange(myHero, _E) }
local KassR = { delay = 0.25, speed = math.huge, width = 270, range = GetCastRange(myHero, _R) }
local EPred = GetPrediction(target, KassE)
local RPred = GetPrediction(target, KassR)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		CastTargetSpell(target, _Q)
	end
	if BPAIO.QWER.E:Value() and Ready(_W) and ValidTarget(target, GetCastRange(myHero, _W)) then
		if EPred and EPred.hitChance >= 0 then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, 300) then
		CastSpell(_W)
		AttackUnit(target)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		if EPred and EPred.hitChance >= 0 then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		if RPred and RPred.hitChance >= 0 then
			CastSkillShot(_R, RPred.castPos)
		end
	end
	for _, mob in pairs(minionManager.objects) do
		if BPAIO.QWER.Q2:Value() and Ready(_Q) and GetTeam(mob) == MINION_ENEMY and ValidTarget(mob, GetCastRange(myHero, _Q)) then
			if GetCurrentHP(mob) + GetDmgShield(mob) <= getdmg("Q", mob, myHero, GetCastLevel(myHero, _Q)) then
				CastTargetSpell(mob, _Q)
			end
		end
	end	
end

class "Morgana"

function Morgana:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Boolean("aR", "Auto Cast R", true)
BPAIO.QWER:Slider("aaR", "Auto R # Enemies", 3, 1, 5, 1)

OnTick(function() self.Tick() end)
end

function Morgana:Tick()
local target = GetCurrentTarget()
local MorgQ = { delay = 0.2, speed = 1200, width = 80, range = 1300 }
local MorgW = { delay = 0.2, speed = math.huge, width = 275, range = GetCastRange(myHero, _W) }
local QPred = GetPrediction(target, MorgQ)
local WPred = GetPrediction(target, MorgW)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, GetCastRange(myHero, _W)) then
		if WPred and WPred.hitChance >= 0 then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) then
		CastTargetSpell(GetMyHero(), _E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) then
		CastSpell(_R)
	end
	for _, unit in pairs(GetEnemyHeroes()) do
		if BPAIO.QWER.aR:Value() and Ready(_R) and EnemiesAround(myHero, GetCastRange(myHero, _R)) >= BPAIO.QWER.aaR:Value() then
			CastSpell(_R)
		end
	end
end

class "Trundle"

function Trundle:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Boolean("It", "Use Items", true)
BPAIO.QWER:Key("aQ", "Auto Q", string.byte("Q"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Trundle:Tick()
local target = GetCurrentTarget()
local TrundleW = { delay = 0.25, speed = math.huge, width = 1000, range = 900 }
local TrundleE = { delay = 0.2, speed = math.huge, width = 270, range = 1000 }
local WPred = GetPrediction(target, TrundleW)
local EPred = GetPrediction(target, TrundleE)
aaResetItems={3074,3077,3748}

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 250) then
		for _, id in pairs(aaResetItems) do
			if (BPAIO.QWER.It:Value() and GetItemSlot(myHero, id) > 0) then
				CastSpell(_Q)
				AttackUnit(target)
					DelayAction(function()
					CastSpell(GetItemSlot(myHero,id))
				end, 0.01)
			else
				CastSpell(_Q)
				AttackUnit(target)
			end
		end
	end
	if BPAIO.QWER.aQ:Value() and Ready(_Q) then
		CastSpell(_Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, GetCastRange(myHero, _W)) then
		if WPred and WPred.hitChance >= 0 then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		if EPred and EPred.hitChance >= 0 then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		CastTargetSpell(target, _R)
	end
end

class "Udyr"

function Udyr:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Udyr:Tick()
local target = GetCurrentTarget()

	if BPAIO.QWER.Q:Value() and Ready(_Q) then
		CastSpell(_Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) then
		CastSpell(_E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) then
		CastSpell(_R)
	end
end

class "Nidalee"

function Nidalee:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("W2", "Auto Pounce", string.byte("Q"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Nidalee:Tick()
local target = GetCurrentTarget()
local NidQ = { delay = 0.25, speed = 1300, width = 40, range = 1500 }
local NidW = { delay = 0, speed = 1300, width = 100, range = 350 }
local NidW2 = { delay = 0, speed = 1300, width = 100, range = 850 }
local NidW3 = { delay = 1, speed = math.huge, width = 40, range = 900 }
local NidE = { delay = 0.25, speed = math.huge, width = 100, range = 300 }
local QPred = GetPrediction(target, NidQ)
local WPred = GetPrediction(target, NidW)
local WPred2 = GetPrediction(target, NidW2)
local WPred3 = GetPrediction(target, NidW3)
local EPred = GetPrediction(target, NidE)

	if BPAIO.QWER.Q:Value() and Ready(_Q) then
		if GetCastName(myHero, _Q) == "JavelinToss" and ValidTarget(target, 1500) then
			if QPred and QPred.hitChance >= 0 then
				CastSkillShot(_Q, QPred.castPos)
			end
		elseif GetCastName(myHero, _Q) == "Takedown" and ValidTarget(target, 250) then
			CastSpell(_Q)
			AttackUnit(target)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		if GetCastName(myHero, _W) == "Bushwhack" and ValidTarget(target, 900) then
			if WPred3 and WPred3.hitChance >= 0 then
				CastSkillShot(_W, WPred3.castPos)
			end
		elseif GetCastName(myHero, _W) == "Pounce" and ValidTarget(target, 850) then
			if WPred2 and WPred2.hitChance >= 0 then
				CastSkillShot(_W, WPred2.castPos)
			end
		end
	end
	if BPAIO.QWER.W2:Value() and Ready(_W) then
		if GetCastName(myHero, _W) == "Pounce" then
			CastSkillShot(_W, GetMousePos())
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) then
		if GetCastName(myHero, _E) == "PrimalSurge" then
			CastTargetSpell(GetMyHero(), _E)
		elseif GetCastName(myHero, _E) == "Swipe" and ValidTarget(target, 300) then
			if EPred and EPred.hitChance >= 0 then
				CastSkillShot(_E, EPred.castPos)
			end
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) then
		CastSpell(_R)
	end
end

class "Alistar"

function Alistar:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Alistar:Tick()
local target = GetCurrentTarget()

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		CastSpell(_Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, GetCastRange(myHero, _W)) then
		CastTargetSpell(target, _W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) then
		CastSpell(_E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) then
		CastSpell(_R)
	end
end

class "Jax"

function Jax:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast Q", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Jax:Tick()
local target = GetCurrentTarget()

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		CastTargetSpell(target, _Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) then
		CastSpell(_E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) then
		CastSpell(_R)
	end
end

class "Ahri"

function Ahri:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Key("aQ", "Cast Q on Min", string.byte("Q"))

OnTick(function(myHero) self.Tick() end)
end

function Ahri:Tick()
local target = GetCurrentTarget()
local AhriQ = {delay = 0.25, speed = 2500, width = 100, range = 1000}
local AhriE = {delay = 0.25, speed = 1550, range = 1000, width = 60}
local QPred = GetPrediction(target, AhriQ)
local EPred = GetPrediction(target, AhriE)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		if EPred and EPred.hitChance >= 0 then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) then
		CastSkillShot(_R, GetMousePos())
	end
	for _, minion in pairs(minionManager.objects) do
		if BPAIO.QWER.aQ:Value() and Ready(_Q) and ValidTarget(minion, GetCastRange(myHero, _Q)) then
			if GetCurrentHP(minion) + GetDmgShield(minion) <= getdmg("Q", minion, myHero, GetCastLevel(myHero, _Q)) then
				local QPred2 = GetPrediction(minion, AhriQ)
				if QPred2 and QPred2.hitChance >= 0 then
					CastSkillShot(_Q, QPred2.castPos)
				end
			end
		end
	end
end

class "Braum"

function Braum:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Braum:Tick()
local target = GetCurrentTarget()
local BraumQ = {delay = 0.25, speed = 1600, width = 100, range = 1000}
local BraumE = {delay = 0, speed = math.huge, width = 1, range = 25000}
local BraumR = {delay = 0.5, speed = 1250, width = 1, range = 1250}
local QPred = GetPrediction(target, BraumQ)
local EPred = GetPrediction(target, BraumE)
local RPred = GetPrediction(target, BraumR)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	for _,ally in pairs(GetAllyHeroes()) do
		if BPAIO.QWER.W:Value() and Ready(_W) and GetDistance(myHero,ally)<GetCastRange(myHero,_W) then
			CastTargetSpell(ally, _W)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, 25000) then
		if EPred and EPred.hitChance >= 0 then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		if RPred and RPred.hitChance >= 0 then
			CastSkillShot(_R, RPred.castPos)
		end
	end
end

class "Chogath"

function Chogath:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Boolean("cR", "Auto R on Champion", true)
BPAIO.QWER:Key("aR", "Cast R on Min", string.byte("Q"))

OnTick(function(myHero) self.Tick() end)
end

function Chogath:Tick()
local target = GetCurrentTarget()
local ChoQ = {delay = 0.25, speed = math.huge, width = 300, range = 950}
local ChoW = {delay = 0, speed = math.huge, width = 250, range = 650}
local QPred = GetPrediction(target, ChoQ)
local WPred = GetPrediction(target, ChoW)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, 800) then
		if WPred and WPred.hitChance >= 0 then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) then
		CastSpell(_E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		CastTargetSpell(target, _R)
	end
	for _, enemy in pairs(GetEnemyHeroes()) do
		if BPAIO.QWER.cR:Value() and Ready(_R) and ValidTarget(enemy, GetCastRange(myHero, _R)) then
			local realHP = (GetCurrentHP(enemy) + GetDmgShield(enemy) + (GetHPRegen(enemy) * 0.25))
			if realHP <= getdmg("R", enemy, myHero, GetCastLevel(myHero, _R)) then
				CastTargetSpell(enemy, _R)
			end
		end
	end
	for _, minion in pairs(minionManager.objects) do
		if BPAIO.QWER.aR:Value() and Ready(_R) and ValidTarget(minion, GetCastRange(myHero, _R)) then
			local realHP2 = (GetCurrentHP(minion) + GetDmgShield(minion) + (GetHPRegen(minion) * 0.25))
			if realHP2 <= getdmg("R", minino, myHero, GetCastLevel(myHero, _R)) then
				CastTargetSpell(minion, _R)
			end
		end
	end
end

class "JarvanIV"

function JarvanIV:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Key("EQ", "Cast E + Q", string.byte("Q"))

OnTick(function(myHero) self.Tick() end)
end

function JarvanIV:Tick()
local target = GetCurrentTarget()
local JarQ = {delay = 0.25, speed = 1400, width = 70, range = 770}
local JarE = {delay = 0.1, speed = 1450, width = 175, range = 850}
local QPred = GetPrediction(target, JarQ)
local EPred = GetPrediction(target, JarE)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, GetCastRange(myHero, _W)) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		if EPred and EPred.hitChance >= 0 then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		CastTargetSpell(target, _R)
	end
	if BPAIO.QWER.EQ:Value() and Ready(_E) and Ready(_Q) then
		CastSkillShot(_E, GetMousePos())
			DelayAction(function()
			CastSkillShot(_Q, GetMousePos())
		end, 0.01)
	end
end

class "KogMaw"

function KogMaw:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function KogMaw:Tick()
local target = GetCurrentTarget()
local KogQ = {delay = 0.25, speed = 1600, width = 80, range = 975}
local KogE = {delay = 0.25, speed = 1200, width = 120, range = 1200}
local KogR = {delay = 1.1, speed = math.huge, width = 250, range = 2200}
local QPred = GetPrediction(target, KogQ)
local EPred = GetPrediction(target, KogE)
local RPred = GetPrediction(target, KogR)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		if EPred and EPred.hitChance >= 0 then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		if RPred and RPred.hitChance >= 0 then
			CastSkillShot(_R, RPred.castPos)
		end
	end
end

class "Pantheon"

function Pantheon:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("R"))

OnTick(function(myHero) self.Tick() end)
end

function Pantheon:Tick()
local target = GetCurrentTarget()
local PanthR = {speed = 3000, delay = 1, range = 5500, width = 1000}
local PanthE = {speed = math.huge, delay = 0.25, range = 600, width = 100}
local EPred = GetPrediction(target, PanthE)
local RPred = GetPrediction(target, PanthR)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		CastTargetSpell(target, _Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, GetCastRange(myHero, _W)) then
		CastTargetSpell(target, _W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, 600) then
		if EPred and EPred.hitChance >= 0 then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, 5500) then
		if RPred and RPred.hitChance >= 0 then
			CastSkillShot(_R, RPred.castPos)
		end
	end
end

class "Skarner"

function Skarner:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("R"))

OnTick(function(myHero) self.Tick() end)
end

function Skarner:Tick()
local target = GetCurrentTarget()
local SkarE = {delay = 0.6, speed = 1200, width = 60, range = 1000}
local EPred = GetPrediction(target, SkarE)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 350) then
		CastSpell(_Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		if EPred and EPred.hitChance >= 0 then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		CastTargetSpell(target, _R)
	end
end

class "Thresh"

function Thresh:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("aW", "Cast W on Self", string.byte("Q"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Slider("hE", "Health for Pull", 25, 1, 100, 1)
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Thresh:Tick()
local target = GetCurrentTarget()
local ThreshQ = {delay = 0.25, speed = 1825, width = 70, range = 1050}
local ThreshW = {delay = 0, speed = 1000, width = 100, range = GetCastRange(myHero, _W)}
local ThreshE = {delay = 0.25, speed = 2000, width = 110, range = 450}
local QPred = GetPrediction(target, ThreshQ)
local EPred = GetPrediction(target, ThreshE)
local pulltime = 0
local flytime = 0
local flylength = 0

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	for _,ally in pairs(GetAllyHeroes()) do
		if BPAIO.QWER.W:Value() and Ready(_W) and GetDistance(myHero,ally)<GetCastRange(myHero,_W) and not IsDead(ally) then
			local WPred = GetPrediction(ally, ThreshW)
			if WPred and WPred.hitChance >= 0 then
				CastSkillShot(_W, WPred.castPos)
			end
		end
	end
	if BPAIO.QWER.aW:Value() and Ready(_W) then
		CastSkillShot(_W, GetOrigin(GetMyHero()))
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		if GetPercentHP(myHero) >= BPAIO.QWER.hE:Value() then
			if (GetGameTimer() > pulltime + 2) and (GetGameTimer() > flytime + flylength) then
			local xz = Vector(myHero) + (Vector(myHero) - Vector(target))
				if EPred and EPred.hitChance >= 0 then
					CastSkillShot(_E, xz)
				end
			end
		elseif GetPercentHP(myHero) <= BPAIO.QWER.hE:Value() then
			if EPred and EPred.hitChance >= 0 then
				CastSkillShot(_E, EPred.castPos)
			end
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		CastSpell(_R)
	end
end

class "Zyra"

function Zyra:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Zyra:Tick()
local target = GetCurrentTarget()
local ZyraQ = {delay = 0.7, speed = math.huge, width = 85, range = 800}
local ZyraW = {delay = 0.25, speed = math.huge, width = 1, range = 850}
local ZyraE = {delay = 0.25, speed = 1150, width = 70, range = 1100}
local ZyraR = {delay = 1, speed = math.huge, range = 1100, width = 500}
local QPred = GetPrediction(target, ZyraQ)
local WPred = GetPrediction(target, ZyraW)
local EPred = GetPrediction(target, ZyraE)
local RPred = GetPrediction(target, ZyraR)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		if QPred and WPred and QPred.hitChance >= 0 and WPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, 850) then
		if WPred and WPred.hitChance >= 0 then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		if EPred  and EPred.hitChance >= 0 and WPred.hitChance >= 0 then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		if RPred and RPred.hitChance >= 0 then
			CastSkillShot(_R, RPred.castPos)
		end
	end
end

class "Olaf"

function Olaf:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("aE", "Kill w/ E", string.byte("Q"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Boolean("aR", "Auto R", true)
BPAIO.QWER:Slider("ahR", "Auto R Health", 50, 0, 100, 5)
BPAIO.QWER:Slider("acR", "Auto R Enemies", 1, 1, 5, 1)

OnTick(function(myHero) self.Tick() end)
end

function Olaf:Tick()
local target = GetCurrentTarget()
local OlafQ = {delay = 0.25, speed = 1550, width = 100, range = 1000}
local QPred = GetPrediction(target, OlafQ)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		CastTargetSpell(target, _E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) then
		CastSpell(_R)
	end
	for _, mob in pairs(minionManager.objects) do
		if BPAIO.QWER.aE:Value() and Ready(_E) and ValidTarget(mob, GetCastRange(myHero, _E)) and GetTeam(mob) == MINION_ENEMY and (GetCurrentHP(mob) + GetDmgShield(mob) < 25 + 45 * GetCastLevel(myHero, _E) + GetBaseDamage(myHero) * 0.4) then
			CastTargetSpell(mob, _E)
		end
	end
end

class "Zed"

function Zed:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("R"))

OnTick(function(myHero) self.Tick() end)
end

function Zed:Tick()
local target = GetCurrentTarget()
local ZedQ = {delay = 0.25, speed = 1700, width = 50, range = 2000}
local ZedW = {delay = 0.25, speed = 1700, width = 50, range = 2000}
local QPred = GetPrediction(target, ZedQ)
local WPred = GetPrediction(target, ZedW)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 900) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, 2000) then
		if WPred and WPred.hitChance >= 0 then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) then
		CastSpell(_E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		CastTargetSpell(target, _R)
	end
end

class "Rengar"

function Rengar:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Rengar:Tick()
local target = GetCurrentTarget()
local RengarE = {delay = 0.25, speed = 1225, width = 80, range = 1000}
local EPred = GetPrediction(target, RengarE)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 725) then
		CastSpell(_Q)
		AttackUnit(target)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, 490) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		if EPred and EPred.hitChance >= 0 then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) then
		CastSpell(_R)
	end
end

class "Diana"

function Diana:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Diana:Tick()
local target = GetCurrentTarget()
local DianaQ = {delay = 0.25, speed = 1500, width = 130, range = 835}
local QPred = GetPrediction(target, DianaQ)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 835) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		CastSpell(_E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		CastTargetSpell(target, _R)
	end
end

class "Varus"

function Varus:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("Q2", "Cast Q2", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Varus:Tick()
local target = GetCurrentTarget()
local VarusQ = {delay = 0.25, speed = 1500, width = 100, range = 1625}
local VarusE = {delay = 0.25, speed = 1750, width = 235, range = 925}
local VarusR = {delay = 0.5, speed = 1200, width = 100, range = 800}
local QPred = GetPrediction(target, VarusQ)
local EPred = GetPrediction(target, VarusE)
local RPred = GetPrediction(target, VarusR)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 1625) then
		CastSkillShot(_Q, GetOrigin(myHero))
	end
	if BPAIO.QWER.Q2:Value() and Ready(_Q) and ValidTarget(target, 1625) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot2(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, 925) then
		if EPred and EPred.hitChance >= 0 then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, 800) then
		if RPred and RPred.hitChance >= 0 then
			CastSkillShot(_R, RPred.castPos)
		end
	end
end

class "Lux"

function Lux:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Lux:Tick()
local target = GetCurrentTarget()
local target2 = GetOrigin(GetAllyHeroes())
local LuxQ = {delay = 0.25, speed = 1200, width = 130, range = GetCastRange(myHero, _Q)}
local LuxW = {delay = 0.25, speed = 1630, width = 210, range = GetCastRange(myHero, _W)}
local LuxE = {delay = 0.25, speed = 1300, width = 345, range = GetCastRange(myHero, _E)}
local LuxR = {delay = 1, speed = math.huge, width = 250, range = GetCastRange(myHero, _R)}
local QPred = GetPrediction(target, LuxQ)
local WPred = GetPrediction(target2, LuxW)
local EPred = GetPrediction(target, LuxE)
local RPred = GetPrediction(target, LuxR)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		if EPred and EPred.hitChance >= 0 then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	for _,ally in pairs(GetAllyHeroes()) do
		if BPAIO.QWER.W:Value() and Ready(_W) and GetDistance(myHero,ally)<GetCastRange(myHero,_W) then
			if WPred and WPred.hitChance then
				CastSkillShot(_W, WPred.castPos)
			end
		end
		if BPAIO.QWER.W:Value() and Ready(_W) and GetDistance(myHero,ally)>GetCastRange(myHero,_W) then
			CastSkillShot(_W, GetOrigin(GetMyHero()))
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		if RPred and RPred.hitChance >= 0 then
			CastSkillShot(_R, RPred.castPos)
		end
	end
end

class "Jinx"

function Jinx:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Jinx:Tick()
local target = GetCurrentTarget()
local JinxW = {delay = 0.6, speed = 3000, width = 60, range = 1400}
local JinxE = {delay = 0.5, speed = 887, width = 0, range = 830}
local JinxR = {delay = 0.6, speed = 1700, width = 140, range = GetCastRange(myHero, _R)}
local WPred = GetPrediction(target, JinxW)
local EPred = GetPrediction(target, JinxE)
local RPred = GetPrediction(target, JinxR)

	if BPAIO.QWER.Q:Value() and Ready(_Q) then
		CastSpell(_Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, GetCastRange(myHero, _W)) then
		if WPred and WPred.hitChance >= 0 then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		if EPred and EPred.hitChance >= 0 then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		if RPred and RPred.hitChance >= 0 then
			CastSkillShot(_R, RPred.castPos)
		end
	end
end

class "Lissandra"

function Lissandra:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Key("R2", "SelfCast R", string.byte("Q"))

OnTick(function(myHero) self.Tick() end)
end

function Lissandra:Tick()
local target = GetCurrentTarget()
local LissQ = {delay = 0.25, speed = 2200, width = 75, range = 825}
--local LissW = {delay = 0, speed = math.huge, width = 450, range = 0}
local LissE = {delay = 0.25, speed = 850, width = 125, range = 1025}
local QPred = GetPrediction(target, LissQ)
--local WPred = GetPrediction(target, LissW)
local EPred = GetPrediction(target, LissE)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 825) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and EnemiesAround(myHero, 450) >= 1 then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		if EPred and EPred.hitChance >= 0 then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _E)) then
		CastTargetSpell(target, _R)
	end
	if BPAIO.QWER.R2:Value() and Ready(_R) then
		CastTargetSpell(GetMyHero(), _R)
	end
end

class "Kayle"

function Kayle:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Kayle:Tick()
local target = GetCurrentTarget()

	if BPAIO.QWER.Q:Value() and ValidTarget(target, GetCastRange(myHero, _Q)) and Ready(_Q) then
		CastTargetSpell(target, _Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastTargetSpell(GetMyHero(), _W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) then
		CastSpell(_E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) then
		CastTargetSpell(GetMyHero(), _R)
	end
end

class "Sion"

function Sion:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q1", "Cast Q1", string.byte("S"))
BPAIO.QWER:Key("Q2", "Cast Q2", string.byte("Q"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Sion:Tick()
local target = GetCurrentTarget()
local SionQ = {delay = 0.5, speed = math.huge, width = 200, range = 300}
local SionE = {delay = 0.25, speed = 1400, width = 100, range = 1500}
local QPred = GetPrediction(target, SionQ)
local EPred = GetPrediction(target, SionE)

	if BPAIO.QWER.Q1:Value() and Ready(_Q) and ValidTarget(target, 600) then
		if QPred and QPred.hitChance <= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.Q2:Value() and Ready(_Q) then
		CastSkillShot2(_Q, GetMousePos())
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, 1500) then
		if EPred and EPred.hitChance >= 0 then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		CastSkillShot(_R, GetOrigin(target))
	end
end

class "Warwick"

function Warwick:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Warwick:Tick()
local target = GetCurrentTarget()

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		CastTargetSpell(target, _Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) then
		CastSpell(_E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		CastTargetSpell(target, _R)
	end
end

class "Karthus"

function Karthus:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Karthus:Tick()
local target = GetCurrentTarget()
local KartQ = {delay = 0.775, speed = math.huge, width = 100, range = GetCastRange(myHero, _Q)}
local KartW = {delay = 0.25, speed = math.huge, width = 100, range = GetCastRange(myHero, _W)}
local QPred = GetPrediction(target, KartQ)
local WPred = GetPrediction(target, KartW)
	
	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, GetCastRange(myHero, _W)) then	
		if WPred and WPred.hitChance >= 0 then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) then
		CastSpell(_E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) then
		CastSpell(_R)
	end
end

class "Nocturne"

function Nocturne:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("R"))

OnTick(function(myHero) self.Tick() end)
end

function Nocturne:Tick()
local target = GetCurrentTarget()
local NocturneQ = {delay = 0.25, speed = 1400, width = 100, range = GetCastRange(myHero, _Q)}
local QPred = GetPrediction(target, NocturneQ)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		CastTargetSpell(target, _E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		CastTargetSpell(target, _R)
	end
end

class "Nautilus"

function Nautilus:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Nautilus:Tick()
local target = GetCurrentTarget()
local NautilusQ = {delay = 0.25, speed = 2000, width = 100, range = GetCastRange(myHero, _Q)}
local QPred = GetPrediction(target, NautilusQ)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) then
		CastSpell(_E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		CastTargetSpell(target, _R)
	end
end

class "Brand"

function Brand:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Brand:Tick()
local target = GetCurrentTarget()
local BrandQ = {delay = 0.25, speed = 1200, width = 80, range = 1050}
local BrandW = {delay = 0.625, speed = math.huge, width = 275, range = 1050}
local QPred = GetPrediction(target, BrandQ)
local WPred = GetPrediction(target, BrandW)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 1050) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, 1050) then
		if WPred and WPred.hitChance >= 0 then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		CastTargetSpell(target, _E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		CastTargetSpell(target, _R)
	end
end

class "FiddleSticks"

function FiddleSticks:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function FiddleSticks:Tick()
local target = GetCurrentTarget()
local FidR = {delay = 1, speed = math.huge, width = 10, range = GetCastRange(myHero, _R)}
local RPred = GetPrediction(target, FidR)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		CastTargetSpell(target, _Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, GetCastRange(myHero, _W)) then
		CastTargetSpell(target, _W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		CastTargetSpell(target, _E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		if RPred and RPred.hitChance >= 0 then
			CastSkillShot(_R, RPred.castPos)
		end
	end
end

class "Kennen"

function Kennen:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Kennen:Tick()
local target = GetCurrentTarget()
local KennenQ = {delay = 0.180, speed = 1700, width = 70, range = 1050}
local QPred = GetPrediction(target, KennenQ)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) then
		CastSpell(_E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and EnemiesAround(myHero, GetCastRange(myHero, _R)) then
		CastSpell(_R)
	end
end

class "Ziggs"

function Ziggs:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Ziggs:Tick()
local target = GetCurrentTarget()
local ZigQ = {delay = 0.25, speed = 1750, width = 80, range = 1400}
local ZigW = {delay = 0.25, speed = 1800, width = 275, range = GetCastRange(myHero, _W)}
local ZigE = {delay = 0.15, speed = 1750, width = 350, range = GetCastRange(myHero, _E)}
local ZigR = {delay = 0.15, speed = 1750, width = 530, range = GetCastRange(myHero, _R)}
local QPred = GetPrediction(target, ZigQ)
local WPred = GetPrediction(target, ZigW)
local EPred = GetPrediction(target, ZigE)
local RPred = GetPrediction(target, ZigR)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 1400) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, GetCastRange(myHero, _W)) then
		if WPred and WPred.hitChance >= 0 then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		if EPred and EPred.hitChance >= 0 then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		if RPred and RPred.hitChance >= 0 then
			CastSkillShot(_R, RPred.castPos)
		end
	end
end

class "Sejuani"

function Sejuani:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Sejuani:Tick()
local target = GetCurrentTarget()
local SejQ = {delay = 0, speed = 1200, width = 70, range = GetCastRange(myHero, _Q)}
local SejR = {delay = 0.25, speed = 1600, width = 110, range = GetCastRange(myHero, _R)}
local QPred = GetPrediction(target, SejQ)
local RPred = GetPrediction(target, SejR)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) then
		CastSpell(_E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		if RPred and RPred.hitChance >= 0 then
			CastSkillShot(_R, RPred.castPos)
		end
	end
end

class "Twitch"

function Twitch:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Twitch:Tick()
local target = GetCurrentTarget()
local TwitchW = {delay = 0.25, speed = 1750, width = 275, range = GetCastRange(myHero, _W)}
local WPred = GetPrediction(target, TwitchW)

	if BPAIO.QWER.Q:Value() and Ready(_Q) then
		CastSpell(_Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, GetCastRange(myHero, _W)) then
		if WPred and WPred.hitChance >= 0 then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, 1200) then
		CastSpell(_E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) then
		CastSpell(_R)
	end
end

class "Quinn"

function Quinn:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Quinn:Tick()
local target = GetCurrentTarget()
local QuinnQ = {delay = 0.25, speed = 1550, width = 80, range = 1050}
local QPred = GetPrediction(target, QuinnQ)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 1050) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		CastTargetSpell(target, _E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) then
		CastSpell(_R)
	end
end

class "Illaoi"

function Illaoi:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Illaoi:Tick()
local target = GetCurrentTarget()
local IllQ = {delay = 0.75, speed = math.huge, width = 160, range = 750}
local IllE = {delay = 0.25, speed = 1900, width = 50, range = 900}
local IllR = {delay = 0.5, speed = math.huge, width = 450, range = 0}
local QPred = GetLinearAOEPrediction(target, IllQ)
local EPred = GetPrediction(target, IllE)
local RPred = GetCircularAOEPrediction(target, IllR)

	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		if QPred and QPred.hitChance >= 0 then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		if EPred and EPred.hitChance >= 0 then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		CastSpell(_R)
	end
end

class "MissFortune"

function MissFortune:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function MissFortune:Tick()
local target = GetCurrentTarget()
local MissE = {delay = 0.25, speed = math.huge, width = 100, range = GetCastRange(myHero, _E)}
local MissR = {delay = 0.25, speed = math.huge, width = 700, range = 1400}
local EPred = GetPrediction(target, MissE)
local RPred = GetPrediction(target, MissR)
	
	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		CastTargetSpell(target, _Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		if EPred and EPred.hitChance >= 0 then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, 1400) then
		if RPred and RPred.hitChance >= 0 then
			CastSkillShot(_R, RPred.castPos)
		end
	end
end


class "Rumble"

function Rumble:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

OnTick(function(myHero) self.Tick() end)
end

function Rumble:Tick()
local target = GetCurrentTarget()
local RumbE = {delay = 0.25, speed = 1200, width = 90, range = GetCastRange(myHero, _E)}
local RumbR = {delay = 0.25, speed = 1700, width = 90, range = 1700}
local EPred = GetPrediction(target, RumbE)
local RPred = GetPrediction(target, RumbR)

	if BPAIO.QWER.Q:Value() and Ready(_Q) then
		CastSkillShot(_Q, GetOrigin(GetMyHero()))
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		if EPred and EPred.hitChance >= 0 then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, 1700) then
		if RPred and RPred.hitChance >= 0 then
			CastSkillShot3(_R, GetOrigin(target), RPred.castPos)
		end
	end
end
