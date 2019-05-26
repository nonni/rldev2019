terminal = require 'BearLibTerminal'
 
-- Initialize the library
terminal.open()
 
-- Print something
terminal.print(2, 1, 'Hello, world')
terminal.refresh()
 
-- The usual 'Press any key to exit...'
terminal.read()
 
-- Clean up
terminal.close()
