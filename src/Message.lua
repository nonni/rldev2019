Message = Object:extend()

function Message:new(text, color)
    self.text = text
    self.color = color or 'white'
end