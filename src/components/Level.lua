Level = Object:extend()

function Level:new(currentLevel, currentXP, levelUpBase, levelUpFactor)
    self.currentLevel = currentLevel or 1
    self.currentXP = currentXP or 0
    self.levelUpBase = levelUpBase or 200
    self.levelUpFactor = levelUpFactor or 150
end

function Level:experienceToNextLevel()
    return self.levelUpBase + self.currentLevel * self.levelUpFactor
end

function Level:addXP(xp)
    self.currentXP = self.currentXP + xp

    if self.currentXP > self:experienceToNextLevel() then
        self.currentXP = self.currentXP - self:experienceToNextLevel()
        self.currentLevel = self.currentLevel + 1

        return true
    else
        return false
    end
end