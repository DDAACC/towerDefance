local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
require("app.data.data_monsterSkill")
local monster=class("monster",function ()
	return display.newSprite()
end)

function monster:ctor(monster_info,id)

  -- local body =cc.PhysicsBody:createBox(self:getContentSize(),cc.PHYSICSBODY_MATERIAL_DEFAULT,cc.p(0,0))
  
    self:setTag(0)
    self.id=id
    self.hpNow=monster_info.hp
	  self.hp=monster_info.hp
	  self.name=monster_info.name
	  self.speed=monster_info.speed
  	self.path={}
	  self.direction=0
    self.death=0
    self.visible=true
    self.pic=monster_info.pic
    self.skill=monster_info.skill
    self.introduction=monster_info.introduction

    self.movetimer=nil
    self.skilltimer=nil

    self.dmg=monster_info.dmg
    self.life=2
	  self.object=display.newSprite(self.pic[2]):addTo(self)
    self.progressbg=display.newSprite("p2.png")
    self.fill=display.newProgressTimer("p1.png",display.PROGRESS_TIMER_BAR)
    self.fill:setMidpoint(cc.p(0,0.5))
    self.fill:setBarChangeRate(cc.p(1.0,0))
    
    self.fill:setPosition(self.progressbg:getContentSize().width/2,self.progressbg:getContentSize().height/2)

    self.progressbg:addChild(self.fill)
    self.fill:setPercentage(100)
    self.progressbg:addTo(self):pos(-1,20)

    self.skilltime1=1

    --碰撞检测初始化
    local body =cc.PhysicsBody:createBox(self.object:getContentSize(),cc.PHYSICSBODY_MATERIAL_DEFAULT,cc.p(0,0))
    body:setCategoryBitmask(0x1111)
    body:setContactTestBitmask(0x1111)
    body:setCollisionBitmask(0x0000)

    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
        return self:onTouch(event)
    end)

    self:setPhysicsBody(body)
end

function monster:onTouch(event)
    
    if event.name=="began" then
         self:getParent().title:showMonster(self.id)
    end 
end



function monster:updateHp()
    self.fill:setPercentage(self.hpNow/self.hp*100)
end



function monster:moveDown(dt)
    local move=cc.MoveBy:create(1/60,cc.p(0,-dt))
    transition.execute(self, move)
end

function monster:moveLeft(dt)
    local move=cc.MoveBy:create(1/60,cc.p(-dt,0))
    transition.execute(self, move)
end

function monster:moveRight(dt)
    local move=cc.MoveBy:create(1/60,cc.p(dt,0))
    transition.execute(self, move)
end

function monster:moveUp(dt)
    local move=cc.MoveBy:create(1/60,cc.p(0,dt))
    transition.execute(self, move)
end

function monster:run()
    self.movetimer=scheduler.scheduleUpdateGlobal(handler(self,self.moveDt))
    self.skilltimer=scheduler.scheduleUpdateGlobal(handler(self,self.skilltest))
end

function monster:endRun()
    scheduler.unscheduleGlobal(self.movetimer)
    scheduler.unscheduleGlobal(self.skilltimer)
end

function monster:deathFunc()   --死亡处理
    self.hpNow=0
    self.death=1
    self:setVisible(false)
    self:setTouchEnabled(false)
    scheduler.unscheduleGlobal(self.movetimer)
    scheduler.unscheduleGlobal(self.skilltimer)
end

function monster:skilltest()
    if self.name=="Boss" then
        monsterSkill1(self)
    end
end

function monster:moveDt()
           
           if  self.death==0 and #self.path==0 then
               
                self:getParent().hp=self:getParent().hp-self.dmg
                if self:getParent().hp <=0 then
                     self:getParent().hp=0
                end

                self:getParent().title:setHp(self:getParent().hp)
                
                self:deathFunc()

                if self:getParent().hp==0 then
                      self:getParent():GameEnd()
                end
           end

           if  self.death==0 and #self.path>0  then


              if self.direction==0 then
                  self.direction=2
              end

                  local x=self:getPositionX()
                  local y=self:getPositionY()
                  local x2=self.path[1][1]
                  local y2=self.path[1][2]
                  
                  local dt=self.speed/60

                  if self.direction==0 then

                  elseif self.direction==1 then

                         self:moveUp(dt)
                         if y>=y2 then

                             if #self.path==1 then
                                self.direction=0
                             else
                                if self.path[2][1]>=x then
                                   self.direction=4
                                   self.object:setTexture(self.pic[4])
                                else
                                   self.direction=3
                                   self.object:setTexture(self.pic[3])
                                end
                             end
                             table.remove(self.path,1)
                         end
                         
                  elseif self.direction==2 then
                       self:moveDown(dt)
                       if y<=y2 then

                       if #self.path==1 then
                           self.direction=0
                       else
                           if self.path[2][1]>=x then
                            self.direction=4
                            self.object:setTexture(self.pic[4])
                           else
                            self.direction=3
                            self.object:setTexture(self.pic[3])
                           end
                       end
                       table.remove(self.path,1)
                    end

                  elseif self.direction==3 then
                         self:moveLeft(dt)
                       if x<=x2 then

                         if #self.path==1 then
                             self.direction=0
                         else
                             if self.path[2][2]>=y then
                              self.direction=1
                              self.object:setTexture(self.pic[1])
                             else
                              self.direction=2
                              self.object:setTexture(self.pic[2])
                             end
                         end
                         table.remove(self.path,1)
                    end

                  elseif self.direction==4 then
                       self:moveRight(dt)
                       if x>=x2 then

                             if #self.path==1 then
                                self.direction=0
                             else
                                if self.path[2][2]>=y then
                                   self.direction=1
                                   self.object:setTexture(self.pic[1])
                                else
                                   self.direction=2
                                   self.object:setTexture(self.pic[2])
                                end
                             end
                             table.remove(self.path,1)
                       end
                  end

            end
end

    


return monster