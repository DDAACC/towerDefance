local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local battleSystem=require("app.logic.battleSystem")  --战斗控制系统
local data_wave=require("app.data.data_wave")
local data_tower=require("app.data.data_tower")
local data_monster=require("app.data.data_monster")
local data_towerbase=require("app.data.data_towerbase")
local Monster=require("app.objects.monster")
local Tower=require("app.objects.tower")
local Object=require("app.objects.object")
require("app.objects.towerbase")
require("app.objects.buildControl")
require("app.objects.title")

local MainScene = class("MainScene", function()
    return display.newPhysicsScene("MainScene")
end)





function clone(object)  
    local lookup_table = {}  
    local function _copy(object)  
        if type(object) ~= "table" then  
            return object  
        elseif lookup_table[object] then  
            return lookup_table[object]  
        end  
        local newObject = {}  
        lookup_table[object] = newObject  
        for key, value in pairs(object) do  
            newObject[_copy(key)] = _copy(value)  
        end  
        return setmetatable(newObject, getmetatable(object))  
    end  
    return _copy(object)  
end 



function MainScene:ctor()

    -- audio.playMusic("background.mp3")
    self.bg=display.newSprite("background.png"):addTo(self):pos(display.cx,display.cy)
    self.world=self:getPhysicsWorld()
    self.world:setGravity(cc.p(0,0))
    -- self.world:setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)

    self.ylabel = cc.LabelTTF:create("第1波", "Arial", 20):addTo(self):pos(1165,870)

    buildControl.new():addTo(self):pos(1000,600)


    self.btSystem=battleSystem.new(nil,nil)
    self.wave={}
    self.tower={}
    self.monster={}
    self.towerbase={}
    self.level=1
    self.hp=100
    self.money=200
    self.object={}
     
    self.monsterpath={
    [1]={96,32},
    [2]={736,32},
    [3]={736,224},
    [4]={416,224},
    [5]={416,352},
    [6]={864,352},
    [7]={864,480},
    [8]={544,480},
    [9]={544,672},
    [10]={1184,672},
    [11]={1184,32}
    }

    self.timer01=nil
    self.timer02=nil
    self.wavetimer=nil

    self:addCollision()

    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
        return self:onTouch(event)
    end)

    self.title=title.new(self.hp,self.money):addTo(self):pos(0,710)


    
    self:GameInit()
    self:GameStart()






end

function MainScene:onEnter()

end

function MainScene:onExit()

end


function MainScene:GameInit()--游戏初始化


   if #self.tower > 0 then
   	  for i=1,#self.tower do
   	  	   self.tower[i]:removeFromParent()
   	  end
   end


   if #self.monster >0 then
   	  for i=1,#self.monster do
   	  	   self.monster[i]:removeFromParent()
   	  end
   end

   for i=1,#data_towerbase do
      
      self.towerbase[i]=towerbase.new(i):addTo(self):pos(data_towerbase[i][1],data_towerbase[i][2])
      self.towerbase[i]:setTouchEnabled(false)
      self.towerbase[i]:setVisible(false)

   end

   self.tower={}
   self.monster={}
   self.wave=data_wave
   self.hp=100
   self.level=1
   self.money=200

end

function MainScene:GameEnd()

   scheduler.unscheduleGlobal(self.timer01)
   scheduler.unscheduleGlobal(self.timer02)
    for i=1,#self.tower do
         self.tower[i]:endAtk()
    end
    for i=1,#self.monster do
         self.monster[i]:endRun()
    end

end

function MainScene:nextWave()


    self.level=self.level+1
    for i=1,#self.monster do
        self.monster[i]:removeFromParent()
    end
    for i=1,#self.object do
        self.object[i]:removeFromParent()
    end

    self.monster={}
    self.object={}

    self.ylabel:setString("第"..self.level.."波")

end

function MainScene:GameStart()

  self.timer01=scheduler.scheduleGlobal(handler(self, self.WaveControl),1) 
  self.timer02=scheduler.scheduleGlobal(handler(self,self.MoneyControl),1)
end

function MainScene:MoneyControl()
     self.money=self.money+1
     self.title:setMoney(self.money)
end


function MainScene:WaveControl()--出兵系统

   
   if #self.wave[self.level] > 0 then
       self.monster[#self.monster+1]=Monster.new(data_monster[self.wave[self.level][1]],#self.monster+1):addTo(self):pos(96,704-20)
       self.monster[#self.monster].path=clone(self.monsterpath)
       self.monster[#self.monster]:run()
       table.remove(self.wave[self.level],1)
   end




   if #self.wave[self.level] <=0 then
       
       local flag=0

       for i=1,#self.monster do

           if self.monster[i].death==0 then
               flag=1
               break
           end
       end

       if flag==0 then
           
           self:nextWave()
       end


    end
 
end


function MainScene:addCollision()                   --怪的FLGA为1 ， 塔的FLAG为0


    local function onContactBegin(contact)   -- 1

        -- 2

        local a = contact:getShapeA():getBody():getNode()  

        local b = contact:getShapeB():getBody():getNode()


        if a:getTag()==1 then
            a:collision(b.id)
        end

        if b:getTag()==1 then
            b:collision(a.id)
        end



        return true

    end



    local function onContactSeperate(contact)   -- 6

        -- 在这里检测当玩家的血量减少是否为0，游戏是否结束。

    end



    local contactListener = cc.EventListenerPhysicsContact:create()

    contactListener:registerScriptHandler(onContactBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)

    contactListener:registerScriptHandler(onContactSeperate, cc.Handler.EVENT_PHYSICS_CONTACT_SEPERATE)

    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()

    eventDispatcher:addEventListenerWithFixedPriority(contactListener, 1)

end

function MainScene:onTouch(event)

     if event.name=="began" then

         self.title:boardInit()
         for i=1,#self.tower do
             self.tower[i].atkRangeCircle:setVisible(false)
         end

     end

end




return MainScene
