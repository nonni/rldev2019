Item = Object:extend()

function Item:new(useFunction, opts)
    self.useFunction = useFunction
    self.targeting = opts['targeting']
    self.targetingMessage = opts['targeting_message']
    self.functionName = opts['functionName']
    self.defaultOpts = opts
end