require("app.objects.tower")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local data_tower=require("app.data.data_tower")
towerbase=class("towerbase",function ()
	return display.newSprite()
end)

function towerbase:ctor(i)
    
    self.base=display.newSprite("towerbase.png"):addTo(self)
    self.buildRate=0
    self.buildtimer=nil
    self.touchTime=0
    self.id=i
    self.hasBuild=false
    local move1=cc.FadeTo:create(0.5,0)
    local move2=cc.FadeTo:create(0.5,255)
    local sequence=cc.Sequence:create(move1,move2)
    transition.execute(self.base,cc.RepeatForever:create(sequence))

    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
            return self:onTouch(event)
     end
    )

    self.progressbg=display.newSprite("p3.png")
    self.fill=display.newProgressTimer("p4.png",display.PROGRESS_TIMER_BAR)
    self.fill:setMidpoint(cc.p(0,0))
    self.fill:setBarChangeRate(cc.p(1,0))
    self.fill:setPosition(self.progressbg:getContentSize().width/2,self.progressbg:getContentSize().height/2)
    self.progressbg:addChild(self.fill)
    self.fill:setPercentage(0)
    self.progressbg:addTo(self):pos(-1,5)
    self.progressbg:setVisible(false)
    self.label = cc.LabelTTF:create("建造中", "Arial", 10):addTo(self):pos(0,35):setVisible(false)

end

function towerbase:build()
    
    if self.buildRate<= 100 then
    	self.label:setVisible(true)
    	self.progressbg:setVisible(true)
    	self.buildRate=self.buildRate+100/60/2
    	self.fill:setPercentage(self.buildRate)
    else
        self:getParent().tower[#self:getParent().tower+1]=tower01.new(data_tower[1],#self:getParent().tower+1):pos(self:getPositionX(),self:getPositionY()):addTo(self:getParent())
        self:getParent().tower[#self:getParent().tower]:beginAtk()
        self:setVisible(false)
        scheduler.unscheduleGlobal(self.buildtimer)     
    end

end


function towerbase:onTouch(event)

    if event.name=="began" then

        if self.touchTime==0 then
        	self.hasBuild=true
        	self:getParent().money=self:getParent().money-40
	    	self.buildtimer=scheduler.scheduleUpdateGlobal(handler(self,self.build))
	    	self.base:setVisible(false)
	    	self.touchTime=1
	    	for i=1,#self:getParent().towerbase do
                  if self:getParent().towerbase[i].id ~= self.id then
                         self:getParent().towerbase[i]:setVisible(false)
                         self:getParent().towerbase[i]:setTouchEnabled(false)
                  end
	    	end	      
        end

    end

end




