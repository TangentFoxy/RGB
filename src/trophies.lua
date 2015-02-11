local trophies = {
	-- note that image_url values are not actually URLs, they are local resources
	{
		id = 16814,
		title = "The Answer to Life, the Universe, and Everything",
		description = "Score 42 points in any mode.",
		difficulty = "Silver",
		image_url = "achievements/the_answer.png",
		achieved = false,
		isSecret = true,
		isVisible = true
	},
	{
		id = 16815,
		title = "h4x0r",
		description = "Unable to be achieved and only visible to me. To obtain, you must hack the game.",
		difficulty = "Bronze",
		image_url = "achievements/h4x0r.png",
		achieved = false,
		isSecret = true,
		isVisible = false
	},
	{
		id = 16816,
		title = "Failure",
		description = "Lose a game.",
		difficulty = "Bronze",
		image_url = "achievements/failure.png",
		achieved = false,
		isSecret = false,
		isVisible = true
	},
	{
		id = 16821,
		title = "l33t",
		description = "Score 1337 points in any mode.",
		difficulty = "Bronze",
		image_url = "achievements/l33t.png",
		achieved = false,
		isSecret = true,
		isVisible = true
	}
}

function trophies:getByID(id)
	for i=1,#self do
		if self[i].id == id then return self[i] end
	end
end

function trophies:achieve(id, session)
	local trophy
	for i=1,#self do
		if self[i].id == id then trophy = self[i] end
	end
	if not trophy.achieved then
		trophy.achieved = true
		-- TODO need to trigger a popup
		if session then
			local achieveSuccess = Gamejolt.giveTrophy(id)
			if achieveSuccess then
				log("Achieved trophy #" .. id)
			else
				log("Error with Game Jolt. Trophy #" .. id .. " could not be achieved.")
			end
		end
	end
end

-- only call if there is a session
-- returns true/false whether sync was successful
function trophies:syncTrophies()
	--first we fetch the trophies available
	local gjTrophies = Gamejolt.fetchAllTrophies()
	if gjTrophies then
		for i=1,#gjTrophies do  --within the remote
			for j=1,#self do    --check locally
				if self[j].id == gjTrophies[i].id then --if same
					if gjTrophies[i].achieved and not self[j].achieved then --if achieved remotely and not here,
						self[j].achieved = true                             --achieve here
					end
					if self[j].achieved and not gjTrophies[i].achieved then    --if achieved here and not remotely,
						local achieveSuccess = Gamejolt.giveTrohpy(self[j].id) --give it remotely
						if not achieveSuccess then
							log("Failed to achieve trophy #" .. self[j].id .. " on Game Jolt.")
							return false
						end
					end
				end
			end
		end
		return true
	else
		log("Failed to retrieve trophies from Game Jolt.")
		return false
	end
end

return trophies
