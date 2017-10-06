local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")


fly01=class("fly01",function ()
	return display.newSprite()
end)

function fly01:ctor(targetIndex,atk,crit)
	
    self.index=targetIndex --攻击目标在Monster table中的序列
    self:setTag(1)

    local s=display.newSprite("bullet01.png"):addTo(self)

    self.x1=nil
    self.x2=nil

    self.atk=atk
    self.crit=crit

    self.speed=300
    self.timer=nil

    local body =cc.PhysicsBody:createCircle(s:getContentSize().width/5,cc.PHYSICSBODY_MATERIAL_DEFAULT,cc.p(0,0))
    body:setCategoryBitmask(0x1111)
    body:setContactTestBitmask(0x1111)
    body:setCollisionBitmask(0x0000)
    self:setPhysicsBody(body)

    self:run()

end



function fly01:flydt()

	local x=self:getPositionX()
	local y=self:getPositionY()

	self.x1=self:getParent().monster[self.index]:getPositionX()
	self.y1=self:getParent().monster[self.index]:getPositionY()


	local dy=math.abs(self.y1-y)
	local dx=math.abs(self.x1-x)

	if dx==0 then
	   dx=0.00000001
	end

	local delta=math.atan(dy/dx)

	local mx=math.abs(math.cos(delta)*(self.speed)/60)
	local my=math.abs(math.sin(delta)*(self.speed)/60)

	if self.x1 < x then
		 mx=-mx
	end

	if self.y1<y then
		 my=-my
	end

	transition.moveBy(self,{x=mx,y=my,time=1/60})

end


function fly01:run()
    self.timer=scheduler.scheduleUpdateGlobal(handler(self,self.flydt))
end

function fly01:collision(t)


	if self.index==t then

	    if self:getParent().monster[self.index].death ==0  then
				
				local dmg=self.atk
				if math.random() < self.crit then
                      dmg=dmg*2
				end
		        self:getParent().monster[self.index].hpNow=self:getParent().monster[self.index].hpNow-dmg
		        self:getParent().monster[self.index]:updateHp()

		        if self:getParent().monster[self.index].hpNow <= 0 then                
		        	 self:getParent().monster[self.index]:deathFunc()
		        	 self:getParent().money=self:getParent().money+10
		        end

		end
		        
		scheduler.unscheduleGlobal(self.timer)
		self:setVisible(false)

    end

end


















fly02=class("fly02",fly01)

function fly02:ctor(targetIndex)
    
    self.index=targetIndex --攻击目标在Monster table中的序列
    self:setTag(1)

    self.s=display.newSprite("bullet02.png"):addTo(self)

    self.x1=nil
	self.y1=nil
	self.mx=nil
	self.my=nil
    self.speed=200
    self.timer=nil
    self.initTime=0

    local body =cc.PhysicsBody:createBox(self.s:getContentSize(),cc.PHYSICSBODY_MATERIAL_DEFAULT,cc.p(0,0))
    body:setCategoryBitmask(0x1111)
    body:setContactTestBitmask(0x1111)
    body:setCollisionBitmask(0x0000)
    self:setPhysicsBody(body)


    -- local move=cc.RotateBy:create(1,180)
    -- transition.execute(self,cc.RepeatForever:create(move))
    self:run()

end

function fly02:flydt()

	
	local x=self:getPositionX()
	local y=self:getPositionY()

	if self.x1==nil or self.y1==nil then

        if self.initTime==1 then

            self:removeFromParent()
        end
	end



	if self.initTime ==0 then

	    if self:getParent().monster[self.index].death==0  then
			self.x1=self:getParent().monster[self.index]:getPositionX()
			self.y1=self:getParent().monster[self.index]:getPositionY()
			local dy=math.abs(self.y1-y)
			local dx=math.abs(self.x1-x)

			if dx==0 then
			   dx=0.00000001
			end

			local delta=math.atan(dy/dx)


			self.mx=math.abs(math.cos(delta)*(self.speed)/60)
			self.my=math.abs(math.sin(delta)*(self.speed)/60)


			if self.x1 < x then
				 self.mx=-self.mx
			end

			if self.y1<y then
				 self.my=-self.my
			end



		end

		self.initTime=1

    end



	

	transition.moveBy(self,{x=self.mx,y=self.my,time=1/60})

end


function fly02:collision(t)



	    if self:getParent().monster[t].death ==0  then
				
		        self:getParent().monster[t].hpNow=self:getParent().monster[t].hpNow-20
		        self:getParent().monster[t]:updateHp()

		        if self:getParent().monster[t].hpNow <= 0 then                
		        	 self:getParent().monster[t]:deathFunc()

		        end

		end

end
