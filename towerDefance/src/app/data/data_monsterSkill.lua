function monsterSkill1(bind)
	if bind.hpNow < bind.hp then
	    bind.hpNow=bind.hpNow+3
	    bind:updateHp()
    end
end