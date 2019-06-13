Item = Object:extend()

function Item:new(useFunction, opts)
    self.useFunction = useFunction
    self.defaultOpts = opts
end