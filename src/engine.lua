Game = {}

function Game.init()
	LoaderFunctions.setGameConstants(Game)
	LoaderFunctions.initializeGameVariables(Game)
end

function Game.load(state)

end

function Game.gameloop()
	terminal.refresh()

	while(not Game.quit) do
		-- Parse input
		while(terminal.has_input()) do
			local action = InputHandler.handleKeys(terminal.read(), Game.state)
			if action then
				local playerTurnResults = {}

				if action[1] == 'move' and Game.state == Enums.States.PLAYERS_TURN then
					local destX = Game.player.x + action[2][1]
					local destY = Game.player.y + action[2][2]
					if not Game.gameMap:isBlocked(destX, destY) then
						local target = Entity.getBlockingEntitiesAtLocation(Game.entities, destX, destY)
						if target then
							local attackResults = Game.player.fighter:attack(target)
							for _,v in ipairs(attackResults) do
								playerTurnResults[#playerTurnResults+1] = v
							end
						else
							Game.player:move(action[2][1], action[2][2])
							Game.fovRecompute = true
						end

						Game.state = Enums.States.ENEMY_TURN
					end
				elseif action[1] == 'pickup' and Enums.States.PLAYERS_TURN then
					local itemFound = false
					for _,entity in ipairs(Game.entities) do
						if entity.item and entity.x == Game.player.x and entity.y == Game.player.y then
							local pickupResults = Game.player.inventory:addItem(entity)
							itemFound = true
							for _,v in ipairs(pickupResults) do
								table.insert(playerTurnResults, v)
							end
						end
					end
					if not itemFound then
						Game.messageLog:addMessage(Message('There is nothing here to pick up.', 'yellow'))
					end
				elseif action[1] == 'show_inventory' then
					Game.previousState = Game.state
					Game.state = Enums.States.SHOW_INVENTORY
				elseif action[1] == 'drop_inventory' then
					Game.previousState = Game.state
					Game.state = Enums.States.DROP_INVENTORY
				elseif action[1] == 'inventory_index' then
					if (Game.state == Enums.States.SHOW_INVENTORY or Game.state == Enums.States.DROP_INVENTORY) and
						Game.previousState ~= Enums.States.PLAYER_DEAD and
						action[2] and
						action[2] <= #Game.player.inventory.items
					then
						local item = Game.player.inventory.items[action[2]]
						local itemResults
						if Game.state == Enums.States.SHOW_INVENTORY then
							itemResults = Game.player.inventory:use(item, {entities = Game.entities, fov_map = Game.fovMap})
						else
							itemResults = Game.player.inventory:dropItem(item)
						end
						for _,v in ipairs(itemResults) do
							table.insert(playerTurnResults, v)
						end
					end
				elseif action[1] == 'take_stairs' and Game.state == Enums.States.PLAYERS_TURN then
					local foundStairs = false
					for _,v in ipairs(Game.entities) do
						if v.stairs and v.x == Game.player.x and v.y == Game.player.y then
							Game.entities = Game.gameMap:nextFloor(
								Game.maxRooms,
								Game.roomMinSize,
								Game.roomMaxSize,
								Game.mapWidth,
								Game.mapHeight,
								Game.player,
								Game.maxMonstersPerRoom,
								Game.maxItemsPerRoom,
								Game.messageLog
							)
							Game.fovMap = {}
							Game.fovRecompute = true
							foundStairs = true
							break
						end
					end
					if foundStairs == false then
						Game.messageLog:addMessage(Message('There are no stairs here.', 'yellow'))
					end
				elseif Game.state == Enums.States.TARGETING and action[1] == 'left_click' then
					local useResults = Game.player.inventory:use(Game.targetingItem, {entities = Game.entities, fov_map = Game.fovMap, target_x = action[2][1], target_y = action[2][2]})
					for _,v in ipairs(useResults) do
						table.insert(playerTurnResults, v)
					end
				elseif Game.state == Enums.States.TARGETING and action[1] == 'right_click' then
					table.insert(playerTurnResults, {'targeting_cancelled', true})
					RenderFunctions.clearLayer(Enums.Layers.INVENTORY, 0, 0, Game.screenWidth, Game.screenHeight)
					RenderFunctions.clearLayer(Enums.Layers.UI_BACK, 0, 0, Game.screenWidth, Game.screenHeight)
				elseif action[1] == 'exit' then
					if Game.state == Enums.States.SHOW_INVENTORY
						or Game.state == Enums.States.DROP_INVENTORY then
						Game.state = Game.previousState
						RenderFunctions.clearLayer(Enums.Layers.INVENTORY, 0, 0, Game.screenWidth, Game.screenHeight)
						RenderFunctions.clearLayer(Enums.Layers.UI_BACK, 0, 0, Game.screenWidth, Game.screenHeight)
					else
						LoaderFunctions.saveGame(Game.player, Game.entities, Game.gameMap, Game.messageLog, Game.state)
						Game.quit = true
						break
					end
				elseif action[1] == 'fullscreen' then
					if terminal.check(terminal.TK_FULLSCREEN) then
						terminal.set('window: fullscreen=false')
					else
						terminal.set('window: fullscreen=false')
					end
				end

				for _,v in ipairs(playerTurnResults) do
					if v[1] == 'message' then
						Game.messageLog:addMessage(v[2])
					elseif v[1] == 'dead' then
						if v[2].id == Game.player.id then
							local res = DeathFunctions.killPlayer(v[2])
							Game.messageLog:addMessage(res[1])
							Game.state = res[2]
						else
							local res = DeathFunctions.killMonster(v[2])
							Game.messageLog:addMessage(res)
						end
					elseif v[1] == 'itemAdded' then
						for i,ent in ipairs(Game.entities) do
							if ent.id == v[2].id then
								table.remove(Game.entities, i)
								break
							end
						end
						Game.state = Enums.States.ENEMY_TURN
					elseif v[1] == 'consumed' and v[2] == true then
						Game.state = Enums.States.ENEMY_TURN
						RenderFunctions.clearLayer(Enums.Layers.INVENTORY, 0, 0, Game.screenWidth, Game.screenHeight)
						RenderFunctions.clearLayer(Enums.Layers.UI_BACK, 0, 0, Game.screenWidth, Game.screenHeight)
					elseif v[1] == 'item_dropped' then
						table.insert(Game.entities, v[2])
						Game.state = Enums.States.ENEMY_TURN
						RenderFunctions.clearLayer(Enums.Layers.INVENTORY, 0, 0, Game.screenWidth, Game.screenHeight)
						RenderFunctions.clearLayer(Enums.Layers.UI_BACK, 0, 0, Game.screenWidth, Game.screenHeight)
					elseif v[1] == 'targeting' then
						Game.previousState = Enums.States.PLAYERS_TURN
						Game.state = Enums.States.TARGETING
						Game.targetingItem = v[2]
						Game.messageLog:addMessage(Game.targetingItem.item.targetingMessage)
						RenderFunctions.clearLayer(Enums.Layers.INVENTORY, 0, 0, Game.screenWidth, Game.screenHeight)
						RenderFunctions.clearLayer(Enums.Layers.UI_BACK, 0, 0, Game.screenWidth, Game.screenHeight)
					elseif v[1] == 'targeting_cancelled' then
						Game.state = Game.previousState
						Game.messageLog:addMessage(Message('Targeting cancelled'))
					end
				end
			end
		end

		-- Update stuff
		Game.update()

		-- Render
		Game.draw()
	end
end

function Game.update()
	if Game.fovRecompute then
		-- Recompute FOV.
		Game.fovMap = {}
		Game.fovAlgorithm:compute(Game.player.x, Game.player.y, Game.fovRadius, FOVFunctions.computeCallback)
		Game.fovRecompute = false
	end

	if Game.state == Enums.States.ENEMY_TURN then
		for _, e in ipairs(Game.entities) do
			if e.name ~= 'Player' then
				if e.ai then
					local enemyTurnResults = e.ai:takeTurn(Game.player, Game.fovMap, Game.gameMap, Game.entities)
					for _,v in ipairs(enemyTurnResults) do
						if v[1] == 'message' then
							Game.messageLog:addMessage(v[2])
						elseif v[1] == 'dead' then
							if v[2].id == Game.player.id then
								local res = DeathFunctions.killPlayer(v[2])
								Game.messageLog:addMessage(res[1])
								Game.state = res[2]
							else
								local res = DeathFunctions.killMonster(v[2])
								Game.messageLog:addMessage(res)
							end
						end
					end
				end
			end

			if Game.state == Enums.States.PLAYER_DEAD then
				break
			end
		end

		if Game.state  ~= Enums.States.PLAYER_DEAD then
			Game.state = Enums.States.PLAYERS_TURN
		end
	end
end

function Game.draw()
	-- Print something
	RenderFunctions.renderAll(
		Game.entities,
		Game.player,
		Game.gameMap,
		Game.fovMap,
		Game.messageLog,
		Game.screenWidth,
		Game.screenHeight,
		Game.state
	)
	terminal.refresh()
	RenderFunctions.clearAll(
		Game.entities,
		Game.screenHeight - Game.gameMap.height - 1
	)
end

function Game.cleanup()

end

return Game