require "./entity"

# A planet on the game map.

# id: The planet ID.
# x: The planet x-coordinate.
# y: The planet y-coordinate.
# radius: The planet radius.
# owner_id: The player ID of the owner, if any. If nil, Planet is not owned.
# docking_spots: The max number of ships that can be docked.
# health: The planet's health.

class Planet < Entity
  getter :docking_spots,
    :health,
    :docked_ship_ids,
    :current_production,
    :remaining_resources,
    :owner_id

  @owner_id: (Int32)?
  @health : Int32
  @docking_spots : Int32
  @docked_ship_ids : Array(Int32)
  @current_production : Int32
  @remaining_resources : Int32

  def initialize(id, x, y, hp, radius, docking_spots, owner_id, docked_ship_ids, current_production, remaining_resources)
    @x = x
    @y = y
    @radius = radius
    @owner_id = owner_id
    @id = id
    @health = hp
    @docking_spots = docking_spots
    @docked_ship_ids = docked_ship_ids
    @docked_ships = {} of Int32 => Ship
    @current_production = current_production
    @remaining_resources = remaining_resources
  end

  # Return the docked ship designated by its id.
  # ship_id: the ID of the ship to be returned.
  # return: the Ship object representing that ID or nil if not docked.
  def docked_ship(ship_id)
    @docked_ships[ship_id]
  end

  # Determines if the planet has an owner.
  # return: true if owned, false otherwise
  def owned?
    !owner_id.nil?
  end

  # Determines if the planet is fully occupied (all docking slots are full)
  # return: true if full, false if not
  def full?
    @docked_ship_ids.length >= docking_spots
  end

  # Use the known owner id and ship ids to populate the docked_ships and owner
  # with real objects rather than just ids.
  # players: hash of { player_id: Player }
  # planets: hash of { planet_id: Planet }
  def link(players, planets)
    return if owner_id.nil?

    owner = players[owner_id]
    @docked_ship_ids.each do |ship_id|
      @docked_ships[ship_id] = owner.ship(ship_id)
    end
  end

  # Parse multiple planet data given a tokenized input.
  # tokens: Array of tokenized input
  # return: the populated planet hash and the unused tokens.
  def self.parse(tokens)
    count_of_planets = tokens.shift.to_i32
    planets = {} of Int32 => Planet

    count_of_planets.times do
      plid, planet, tokens = parse_single(tokens)
      planets[plid] = planet
    end

    return planets, tokens
  end

  # Create a single planet given tokenized input from the game environment.
  # tokens: Array of tokenized information
  # return: The planet ID, planet object, and unused tokens.
  #         (int, Planet, list[str])
  def self.parse_single(tokens)
    # the _ variables are deprecated, not used in this implementation.
    # They are: current production, remaining resources
    #id, x, y, hp, r, docking, current_production, remaining_resources, is_owned, owner, ship_count, *tokens = tokens
    id = tokens.shift.to_i32
    x = tokens.shift.to_f64
    y = tokens.shift.to_f64
    hp = tokens.shift.to_i32
    radius = tokens.shift.to_f64
    docking = tokens.shift.to_i32
    current_production = tokens.shift.to_i32
    remaining_resources = tokens.shift.to_i32
    is_owned = tokens.shift.to_i32
    owner_id = tokens.shift.to_i32
    ship_count = tokens.shift.to_i32

    owner_id = is_owned == 1 ? owner_id : nil
    docked_ship_ids = [] of Int32

    # Fetch the ship ids from the tokens array
    ship_count.times do
      docked_ship_ids << tokens.shift.to_i32
    end

    # (id, x, y, hp, radius, docking_spots, owner, docked_ship_ids)
    planet = Planet.new(id, x, y, hp, radius, docking,
                        owner_id,
                        docked_ship_ids,
                        current_production,
                        remaining_resources)
    return id, planet, tokens
  end
end

