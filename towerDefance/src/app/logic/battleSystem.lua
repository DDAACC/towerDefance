local battleSystem=class("battleSystem")

function battleSystem:ctor(a,b)
   self.monster=b
   self.tower=a  
end

function battleSystem:run()
    
    self:checkBuff()
    self:checkAtk()

end

function battleSystem:checkBuff()


end


function battleSystem:checkAtk()
    
    
end


return battleSystem