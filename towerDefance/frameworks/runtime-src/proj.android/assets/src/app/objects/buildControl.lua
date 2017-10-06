local data_tower=require("app.data.data_tower")
buildControl=class("buildControl",function()
	return display.newSprite()
end)

function buildControl:ctor(i)
    
    self.sprite=display.newSprite(data_tower[i].pic):addTo(self)
    self.label = cc.LabelTTF:create("价格"..data_tower[i].price, "Arial", 10):addTo(self):pos(0,-20)
    self.label1 = cc.LabelTTF:create(data_tower[i].name, "Arial", 10):addTo(self):pos(0,20)
    self.id=i
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
            return self:onTouch(event)
     end
    )

end

function buildControl:onTouch(event)
    
    if event.name=="began" then
    	self:getParent():getParent().buildSelect=self.id
    	if self:getParent():getParent().money>= data_tower[self.id].price then
	    	for i=1,#self:getParent():getParent().towerbase do
	    		if self:getParent():getParent().towerbase[i].hasBuild==false then
	               self:getParent():getParent().towerbase[i]:setVisible(true)
	               self:getParent():getParent().towerbase[i]:setTouchEnabled(true)
	               self:getParent():getParent().towerbase[i].base:setVisible(true)
	               self:getParent():getParent().towerbase[i].progressbg:setVisible(false)
	               self:getParent():getParent().towerbase[i].label:setVisible(false)
	               self:getParent():getParent().towerbase[i].touchTime=0
	            end
	    	end
        end
    end

end