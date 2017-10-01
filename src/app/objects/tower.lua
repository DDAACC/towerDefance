require("app.objects.object")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
tower01=class("tower",function ()
	return display.newSprite()
end)

function tower01:ctor(tower_info)
   
   self.name=tower_info.name 
   self.atk=tower_info.atk
   self.atkSpeed=tower_info.atkSpeed
   self.atkSpeedFlag=tower_info.atkSpeed
   self.atkRange=tower_info.atkRange
   self.atkTimer=nil  
   self.atkNumber=2
   self.atkNumberFlag=0  
   self.x1=nil
   self.y1=nil

   local object=display.newSprite(tower_info.pic):addTo(self)
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

                   self:getParent().object[#self:getParent().object+1]=fly01.new(i):pos(x,y):addTo(self:getParent())
     
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


return tower01