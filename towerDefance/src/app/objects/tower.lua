require("app.objects.object")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
tower01=class("tower",function ()
	return display.newSprite()
end)

function tower01:ctor(tower_info,t)

    
   self.towerid=t
   self.name=tower_info.name 
   self.atk=tower_info.atk
   self.atkSpeed=tower_info.atkSpeed
   self.atkSpeedFlag=tower_info.atkSpeed
   self.atkRange=tower_info.atkRange
   self.atkTimer=nil  
   self.atkNumber=tower_info.atkNum
   self.pic=tower_info.pic
   self.atkNumberFlag=0  
   self.crit=tower_info.crit
   self.introduction=tower_info.introduction
   self.skill=tower_info.skill
   self.x1=nil
   self.y1=nil
   self.atkRangeCircle=nil
   local object=display.newSprite(self.pic):addTo(self)
   self:setTouchEnabled(true)
   self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
        return self:onTouch(event)
   end)

end

function tower01:beginAtk()
   self.atkTimer=scheduler.scheduleGlobal(handler(self,self.atkCheck),1/10)
end

function tower01:endAtk()
   scheduler.unscheduleGlobal(self.atkTimer)
end


function tower01:atkCheck()

   if self.atkSpeedFlag >=0 then
   	    self.atkSpeedFlag=self.atkSpeedFlag-1/10
   else   
      for i=1,#self:getParent().monster do

          if self:getParent().monster[i].death==0 then

                local x=self:getPositionX()
                local y=self:getPositionY()


                self.x1=self:getParent().monster[i]:getPositionX()
                self.y1=self:getParent().monster[i]:getPositionY()

                local distance=math.sqrt((x-self.x1)*(x-self.x1)+(y-self.y1)*(y-self.y1))


                if distance <= self.atkRange and self:getParent().monster[i].visible==true then

                   self:getParent().object[#self:getParent().object+1]=fly01.new(i,self.atk,self.crit):pos(x,y):addTo(self:getParent())
     
                	 self.atkSpeedFlag=self.atkSpeed
                	 self.atkNumberFlag=self.atkNumberFlag+1
                	 if self.atkNumberFlag >= self.atkNumber then
                          self.atkNumberFlag=0
                          break
                	 end

                end
          end
      end

   end

end

function tower01:onTouch(event)
    
    if event.name=="began" then

        self:getParent().title:showTower(self.towerid)

        if self.atkRangeCircle==nil then
               self.atkRangeCircle = display.newCircle(self.atkRange,
               {x = self:getPositionX(), y = self:getPositionY(),
               fillColor = cc.c4f(1, 0, 0, 0),
               borderColor = cc.c4f(1, 0, 0, 1),
               borderWidth = 0.5}):addTo(self:getParent())
               local move1=cc.FadeTo:create(0.5,0)
               local move2=cc.FadeTo:create(0.5,255)
               local sequence=cc.Sequence:create(move1,move2)
               transition.execute(self.atkRangeCircle,cc.RepeatForever:create(sequence))               
        else
              self.atkRangeCircle:setVisible(true)
        end
        for i=1,#self:getParent().tower do
            if self.towerid ~= i then              
                  self:getParent().tower[i].atkRangeCircle:setVisible(false)
            end
        end
    end

end
