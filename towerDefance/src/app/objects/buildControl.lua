buildControl=class("buildControl",function()
	return display.newSprite()
end)

function buildControl:ctor()
    
    self.label = cc.LabelTTF:create("1级塔", "Arial", 20):addTo(self):pos(0,35)

    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
            return self:onTouch(event)
     end
    )

end

function buildControl:onTouch(event)
    
    if event.name=="began" then
    	if self:getParent().money>= 40 then
	    	for i=1,#self:getParent().towerbase do
	    		if self:getParent().towerbase[i].hasBuild==false then
	               self:getParent().towerbase[i]:setVisible(true)
	               self:getParent().towerbase[i]:setTouchEnabled(true)
	               self:getParent().towerbase[i].base:setVisible(true)
	               self:getParent().towerbase[i].progressbg:setVisible(false)
	               self:getParent().towerbase[i].label:setVisible(false)
	               self:getParent().towerbase[i].touchTime=0
	            end
	    	end
        end
    end

end