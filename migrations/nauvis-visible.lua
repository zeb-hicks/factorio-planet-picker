for _, force in pairs(game.forces) do
    if force.technologies["planet-discovery-nauvis"].researched == true then
        force.unlock_space_location("nauvis");
        force.set_surface_hidden("nauvis", false);
    else
        force.lock_space_location("nauvis");
        force.set_surface_hidden("nauvis", true);
    end
end