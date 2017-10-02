local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
messageBoard=class("messageBoard",function ()
	return display.newSprite()
end)

function messageBoard:ctor()
	self.label = cc.LabelTTF:create("", "Arial", 20):addTo(self)
	self.timer = nil
	self.monsterIndex=nil
end

function messageBoard:monsterShow(i)
	self.monsterIndex=i
    local name=self:getParent().monster[i].name
    local hp=self:getParent().monster[i].hp
    local hpNow=self:getParent().monster[i].hpNow
    self.label:setString(name.."   hp"..hp.."/"..hpNow)
    self.timer = scheduler.scheduleUpdateGlobal(handler(self,self.monsterfunc))
end

function messageBoard:monsterfunc()
   
    local name=self:getParent().monster[self.monsterIndex].name
    local hp=self:getParent().monster[self.monsterIndex].hp
    local hpNow=self:getParent().monster[self.monsterIndex].hpNow
    self.label:setString(name.."   hp"..hpNow.."/"..hp)

end


function messageBoard:towerShow(i)
   
    local name=self:getParent().tower[i].name
    local atk=self:getParent().tower[i].atk
    self.label:setString(name.. " atk "..atk)

end

function messageBoard:reBuild()
   
    if self.timer ~= nil then
         scheduler.unscheduleGlobal(self.timer)   
    end
    self.timer=nil
    self.label:setString("")

end