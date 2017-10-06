local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
title = class("title",function () 
	return display.newSprite()
end)

function title:ctor(a,b)

    self.progressbg=display.newSprite("tback.png")
	self.fill=display.newProgressTimer("tfill.png",display.PROGRESS_TIMER_BAR)
    self.fill:setMidpoint(cc.p(0,0.5))
    self.fill:setBarChangeRate(cc.p(1.0,0))
    
    self.fill:setPosition(self.progressbg:getContentSize().width/2,self.progressbg:getContentSize().height/2)

    self.progressbg:addChild(self.fill)
    self.fill:setPercentage(100)
    self.progressbg:addTo(self):pos(250,45)

    self.board=cc.uiloader:load("NewUi_1.json"):addTo(self)
    self.hp=cc.uiloader:seekNodeByName(self.board,"Label_hp"):setString(a)
    self.money=cc.uiloader:seekNodeByName(self.board,"Label_money"):setString(b)
    self.imgHead=cc.uiloader:seekNodeByName(self.board,"Image_head")
    self.atk=cc.uiloader:seekNodeByName(self.board,"Label_atk")
    self.atkRange=cc.uiloader:seekNodeByName(self.board,"Label_atkRange")
    self.atkSpeed=cc.uiloader:seekNodeByName(self.board,"Label_atkSpeed")
    self.crit=cc.uiloader:seekNodeByName(self.board,"Label_Crit")
    self.atkNum=cc.uiloader:seekNodeByName(self.board,"Label_atkNum")
    self.towerName=cc.uiloader:seekNodeByName(self.board,"Label_towerName")
    self.monsterSpeed=cc.uiloader:seekNodeByName(self.board,"Label_monsterSpeed")
    self.monsterName=cc.uiloader:seekNodeByName(self.board,"Label_monsterName")
    self.introduction=cc.uiloader:seekNodeByName(self.board,"Label_introduction")
    self.skill=cc.uiloader:seekNodeByName(self.board,"Label_skill")
    self.timer=nil
    self.monsterid=nil
    self.lhp=cc.uiloader:seekNodeByName(self.board, "Label_lhp")


    self.build=cc.uiloader:seekNodeByName(self.board, "Image_build")
    self.cancel=cc.uiloader:seekNodeByName(self.board,"Image_16")

    self.build:setTouchEnabled(true)
    self.build:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
        return self:onbuildTouch(event)
    end)

    self.cancel:setTouchEnabled(true)
    self.cancel:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
        return self:oncancelTouch(event)
    end)

    self:boardInit()
end

function title:boardInit()
    self.imgHead:setVisible(false)
    self.atk:setVisible(false)
    self.atkRange:setVisible(false)
    self.atkSpeed:setVisible(false)
    self.crit:setVisible(false)
    self.atkNum:setVisible(false)
    self.towerName:setVisible(false)
    self.monsterSpeed:setVisible(false)
    self.monsterName:setVisible(false)
    self.introduction:setVisible(false)
    self.skill:setVisible(false)
    self.lhp:setVisible(false)
    self.progressbg:setVisible(false)
    if self.timer ~= nil then
        scheduler.unscheduleGlobal(self.timer)   
        self.timer=nil
    end
end

function title:monsterHp()
	if self:getParent().monster[self.monsterid] ~= nil then
	    local hpNow=math.ceil(self:getParent().monster[self.monsterid].hpNow)
	    local hp=self:getParent().monster[self.monsterid].hp
	    self.fill:setPercentage(hpNow/hp*100)
	    self.lhp:setString(hpNow.."/"..hp)
    end
end

function title:setMoney(i)
    self.money:setString(i)
end

function title:setHp(i)
    self.hp:setString(i)
end


function title:showMonster(index)
    self:boardInit()
    self.imgHead:setTexture(self:getParent().monster[index].pic[3]):setVisible(true)
    self.progressbg:setVisible(true)
    self.monsterid=index
    self.monsterName:setString(self:getParent().monster[index].name):setVisible(true)
    self.monsterSpeed:setString("移速:"..self:getParent().monster[index].speed):setVisible(true)
    self.introduction:setString(self:getParent().monster[index].introduction):setVisible(true)
    self.skill:setString(self:getParent().monster[index].skill):setVisible(true)
    self.lhp:setString(self:getParent().monster[index].hpNow.."/"..self:getParent().monster[index].hp):setVisible(true)
    self.timer=scheduler.scheduleUpdateGlobal(handler(self,self.monsterHp))
end

function title:showTower(index)
    self:boardInit()
    self.imgHead:setTexture(self:getParent().tower[index].pic):setVisible(true)
    self.towerName:setString(self:getParent().tower[index].name):setVisible(true)
    self.atkRange:setString("攻击范围:"..self:getParent().tower[index].atkRange):setVisible(true)
    self.atk:setString("攻击力:"..self:getParent().tower[index].atk):setVisible(true)
    self.atkNum:setString("攻击数量:"..self:getParent().tower[index].atkNumber):setVisible(true)
    self.crit:setString("暴击率:"..(100*self:getParent().tower[index].crit).."%"):setVisible(true)
    self.atkSpeed:setString("攻击速度:"..1/self:getParent().tower[index].atkSpeed):setVisible(true)
    self.introduction:setString(self:getParent().tower[index].introduction):setVisible(true)
    self.skill:setString(self:getParent().tower[index].skill):setVisible(true)
end

function title:onbuildTouch(event)
   
    if event.name=="began" then
          
        print("build")

    end


end

function title:oncancelTouch(event)

    if event.name=="began" then
        print("cancel")
    end
end