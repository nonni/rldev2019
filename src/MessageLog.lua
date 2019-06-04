MessageLog = Object:extend()

function MessageLog:new(x, width, height)
    self.messages = {}
    self.x = x
    self.width = width
    self.height = height
end

function MessageLog:addMessage(message)
    -- Split the message if necessary, among multiple lines
    local newMsgLines = wrap(message.text, self.width)

    for _,line in ipairs(newMsgLines) do
        -- If the buffer is full, remove the first line to make room for a new one
        if #self.messages == self.height then
            table.remove(self.messages, 1)
        end

        -- Add the new line as a message object, with text and color.
        table.insert(self.messages, Message(line, message.color))
    end
end
