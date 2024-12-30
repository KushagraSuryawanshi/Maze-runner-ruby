# Require the Gosu library 
require 'gosu'

# Define the Wall class
class Wall
  attr_accessor :x, :y

# Initialize the Wall object with x, y coordinates and image
  def initialize(x, y, image)
    @x = x
    @y = y
    @image = image
  end

# Draw the Wall on the screen
  def draw
    @image.draw(@x, @y, 1)
  end
end

# Define the Coin class
class Coin
  attr_accessor :x, :y

# Initialize the Coin object with x, y coordinates and image
  def initialize(x, y, image)
    @x = x
    @y = y
    @image = image
  end

# Draw the Coin on the screen
  def draw
    @image.draw(@x, @y, 1)
  end
end

# Define the Enemy class
class Enemy
  attr_accessor :x, :y

# Initialize the Enemy object with x, y coordinates, image, speed, and direction
  def initialize(x, y, image)
    @x = x
    @y = y
    @image = image
    @speed = 1
    @direction = [:up, :down, :left, :right].sample
  end

# Draw the Enemy on the screen
  def draw
    @image.draw(@x, @y, 1)
  end

# Move the Enemy within the maze
  def move(maze_layout)
    new_x, new_y = @x, @y
  
    case @direction
    when :up
      new_y -= @speed
    when :down
      new_y += @speed
    when :left
      new_x -= @speed
    when :right
      new_x += @speed
    end
  
    # Check for collision with walls
    block_collides = (maze_layout[new_y/20][new_x/20] == 1) ||                    # Top-left corner
                     (maze_layout[(new_y + 19)/20][(new_x + 19)/ 20] == 1) ||     # Bottom-right corner
                     (maze_layout[(new_y + 19)/20][new_x/20] == 1) ||             # Bottom-left corner
                     (maze_layout[new_y/20][(new_x + 19)/ 20] == 1)               # Top-right corner
  
    if !block_collides
      # Move to the new position if no collision detected
      @x, @y = new_x, new_y
    else
      # Randomly choose a new direction if collision detected with a wall
      @direction = [:up, :down, :left, :right].sample
    end
  end
  
end

# Define the Player class
class Player
  attr_accessor :x, :y

# Initialize the Player object with x, y coordinates and image
  def initialize(x, y, image)
    @x = x
    @y = y
    @image = image
    @speed = 1.5
  end

  # Draw the Player on the screen
  def draw
    @image.draw(@x, @y, 1)
  end

  # Move the Player left
  def move_left(maze_layout)
    new_x = @x - @speed
    if !wall_collision?(new_x, @y, maze_layout)
      @x = new_x
    end
  end

  # Move the Player right
  def move_right(maze_layout)
    new_x = @x + @speed
    if !wall_collision?(new_x, @y, maze_layout)
      @x = new_x
    end
  end

  # Move the Player up
  def move_up(maze_layout)
    new_y = @y - @speed
    if !wall_collision?(@x, new_y, maze_layout)
      @y = new_y
    end
  end

  # Move the Player down
  def move_down(maze_layout)
    new_y = @y + @speed
    if !wall_collision?(@x, new_y, maze_layout)
      @y = new_y
    end
  end

  # Check for collision with walls
  def wall_collision?(x, y, maze_layout)
    (maze_layout[y / 20][x / 20] == 1) ||                                  
    (maze_layout[(y + 16) / 20][(x + 16) / 20] == 1) ||                   
    (maze_layout[(y + 16) / 20][x / 20] == 1) ||                           
    (maze_layout[y / 20][(x + 16) / 20] == 1)  
  end
end

# Define the GameWindow class
class GameWindow < Gosu::Window

  # Initialize the GameWindow
  def initialize
    super 640, 480
    self.caption = "Maze Game"
    
    @wall_image = Gosu::Image.new("wall.jpg")
    @walls = generate_walls

    @coin_image = Gosu::Image.new("coin.jpg")
    @coins = generate_coins

    @enemy_image = Gosu::Image.new("enemy.jpg")
    @enemies = generate_enemies("easy")

    @player_image = Gosu::Image.new("player.jpg")
    @player = Player.new(20, 20, @player_image)

    @points = 0
    @font = Gosu::Font.new(20)
    
    @menu_image = Gosu::Image.new("menu.jpg")
    @game_state = :menu
    @selected_difficulty = "easy"
    @difficulties = ["easy", "medium", "hard"]
    @up_pressed = false
    @down_pressed = false
    
    @title_font = Gosu::Font.new(36)
    @menu_font = Gosu::Font.new(28)
    @difficulty_font = Gosu::Font.new(22)
    @instructions = Gosu::Font.new(20)

    @game_over_font = Gosu::Font.new(36)
    @option_font = Gosu::Font.new(28)
  end

  # Draw method for the GameWindow
  def draw
    case @game_state
    when :menu
      draw_menu
    when :playing
      draw_game
    when :game_over
      draw_game_over
    end
  end

  # Update method for the GameWindow
  def update
    case @game_state
    when :menu
      update_menu
    when :playing
      update_game
    when :game_over
      update_game_over 
    end
  end

  # Button down event handler
  def button_down(id)
    case id
    when Gosu::KB_RETURN
      if @game_state == :menu
        @game_state = :playing
        @walls = generate_walls
        @coins = generate_coins
        @enemies = generate_enemies(@selected_difficulty)
        @player = Player.new(20, 20, @player_image)
      end
    end
  end
  
  # Generates walls based on maze_layout
  def generate_walls
    walls = []
    y = 0
    while y < maze_layout.length
      x = 0
      while x < maze_layout[y].length
        if maze_layout[y][x] == 1
          walls << Wall.new(x * 20, y * 20, @wall_image)
        end
        x += 1
      end
      y += 1
    end
    walls
  end

  # Generates coins randomly in the maze
  def generate_coins
    coins = []
    while coins.length < 40
      x = rand(1..maze_layout[0].length - 2) * 20
      y = rand(1..maze_layout.length - 2) * 20
      if maze_layout[y / 20][x / 20] == 0
        coins << Coin.new(x, y, @coin_image) 
      end
    end
    coins
  end

# Defines the layout of the maze
  def maze_layout
    [
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1],
      [1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1],
      [1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1],
      [1, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1],
      [1, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1],
      [1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1],
      [1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    ]
  end

# Generates enemies based on the difficulty level
  def generate_enemies(difficulty)
    enemies = []

    # Sets the number of enemies based on the difficulty
    if difficulty == "easy"
      enemy_count = 15
    elsif difficulty == "medium"
      enemy_count = 30
    elsif difficulty == "hard"
      enemy_count = 60
    else
      enemy_count = 0
    end

    # Creates enemies at random positions on the maze layout
    while enemies.length < enemy_count
      x = rand(1..maze_layout[0].length - 2) * 20
      y = rand(1..maze_layout.length - 2) * 20
      if maze_layout[y / 20][x / 20] == 0
        enemies << Enemy.new(x, y, @enemy_image)  
      end
    end
    enemies
  end


  # Draws the main menu screen
  def draw_menu
    # Draw the background image
    @menu_image.draw(0, 0, 0)

    # Draw the title
    @title_font.draw_text("Maze Game", 230, 50, 1, 1.0, 1.0, Gosu::Color::WHITE)
   
    # Draw menu options and instructions
    @menu_font.draw_text("Press ENTER to Start", 190, 100, 1, 1.0, 1.0, Gosu::Color::WHITE)
    @menu_font.draw_text("To select difficulty level hit either ", 155, 160, 1, 0.9, 0.9, Gosu::Color::WHITE)
    @menu_font.draw_text("upward or downward key on your keyboard", 100, 190, 1, 0.9, 0.9, Gosu::Color::WHITE)
    @menu_font.draw_text("How to Play:", 40, 330, 1, 1.0, 1.0, Gosu::Color::WHITE)
    @instructions.draw_text("To play the game, use the Up and Down arrow keys to move your player", 40, 370, 1, 1.0, 1.0, Gosu::Color::WHITE)
    @instructions.draw_text("up and down, and the Left and Right arrow keys to move left and right.", 40, 390, 1, 1.0, 1.0, Gosu::Color::WHITE)
    @instructions.draw_text("Navigate through the maze, collect coins to gain points, and avoid", 40, 410, 1, 1.0, 1.0, Gosu::Color::WHITE)
    @instructions.draw_text("enemies to prevent losing points. Enjoy!", 40, 430, 1, 1.0, 1.0, Gosu::Color::WHITE)
    
    # Draw difficulty selection (easy, medium, hard)
    draw_difficulty_selection
  end

# Draws the game screen
  def draw_game
    # Draw walls, coins, enemies, and player
    @walls.each { |wall| wall.draw }
    @coins.each { |coin| coin.draw }
    @enemies.each { |enemy| enemy.draw }
    @player.draw
    @font.draw_text("Points: #{@points}", 10, 10, 2, 1.0, 1.0, Gosu::Color::YELLOW)
  end


# Draws the difficulty selection options on the menu screen
  def draw_difficulty_selection
    y = 230
    index = 0
    while index < @difficulties.length
      difficulty = @difficulties[index]
      color = @selected_difficulty == difficulty ? Gosu::Color::GREEN : Gosu::Color::WHITE
      @difficulty_font.draw_text(difficulty.capitalize, 280, y + index * 40, 1, 1.0, 1.0, color)
      index += 1
    end
  end
  
# Updates the menu based on user input for difficulty selection  
  def update_menu
    if Gosu.button_down?(Gosu::KB_UP) && !@up_pressed
      @up_pressed = true
      case @selected_difficulty
      when "easy"
        @selected_difficulty = "hard"
      when "medium"
        @selected_difficulty = "easy"
      when "hard"
        @selected_difficulty = "medium"
      end
    elsif Gosu.button_down?(Gosu::KB_DOWN) && !@down_pressed
      @down_pressed = true
      case @selected_difficulty
      when "easy"
        @selected_difficulty = "medium"
      when "medium"
        @selected_difficulty = "hard"
      when "hard"
        @selected_difficulty = "easy"
      end
    end
    # Reset the 'up' button press flag if the 'up' arrow key is not pressed
    @up_pressed = false if !Gosu.button_down?(Gosu::KB_UP)

    # Reset the 'down' button press flag if the 'down' arrow key is not pressed
    @down_pressed = false if !Gosu.button_down?(Gosu::KB_DOWN)
  end
  
  # Draws the game over screen with relevant information and options
  def draw_game_over
    # Draw background image
    @menu_image.draw(0, 0, 0)

    # Draw "Game Over" text
    @game_over_font.draw_text("Game Over", 250, 50, 1, 1.0, 1.0, Gosu::Color::WHITE)
    
    # Draw player's score
    @option_font.draw_text("Score: #{@points}", 270, 100, 1, 1.0, 1.0, Gosu::Color::WHITE)
    
    # Draw option to play again
    @option_font.draw_text("Play again, Press 1", 240, 150, 1, 1.0, 1.0, Gosu::Color::WHITE)
    
    # Draw option to go back to main menu
    @option_font.draw_text("Back to main menu, Press 2", 190, 200, 1, 1.0, 1.0, Gosu::Color::WHITE)
  end
    

  # Updates the game state based on player input and game logic
  def update_game
    move_enemies

    # Move player based on keyboard input
    if Gosu.button_down? Gosu::KB_LEFT
      @player.move_left(maze_layout)
    end
    if Gosu.button_down? Gosu::KB_RIGHT
      @player.move_right(maze_layout) 
    end
    if Gosu.button_down? Gosu::KB_UP
      @player.move_up(maze_layout)
    end
    if Gosu.button_down? Gosu::KB_DOWN
      @player.move_down(maze_layout)
    end

    # Handle collisions between player, coins, and enemies
    handle_collisions
    
    # Check for game over conditions
    if @coins.empty? || @enemies.empty?
      @game_state = :game_over
    end
  end


# Moves all enemies in the game
  def move_enemies
    index = 0
    while index < @enemies.length
      @enemies[index].move(maze_layout)
      index += 1
    end
  end

# Handles collisions between player, coins, and enemies
  def handle_collisions
      # Check for collisions between player and coins
      @coins.reject! do |coin|
      if Gosu.distance(@player.x, @player.y, coin.x, coin.y) < 20
        # Increase points when player collects a coin
        @points += 2
        # Remove the coin from the array
        true
      else
        false
      end
    end
  
    # Check for collisions between player and enemies
    @enemies.reject! do |enemy|
      if Gosu.distance(@player.x, @player.y, enemy.x, enemy.y) < 20
        # Decrease points when player clashes with an enemy
        @points -= 10
        # Remove the enemy, (which player collides with) from the array
        true
      else
        false
      end
    end
  end
  

# Updates game state when game is over
  def update_game_over
    # If "1" is pressed, restart the game
    if Gosu.button_down?(Gosu::KB_1)
      @game_state = :playing
      @points = 0
      @walls = generate_walls
      @coins = generate_coins
      @enemies = generate_enemies(@selected_difficulty)
      @player = Player.new(20, 20, @player_image)
      # If "2" is pressed, return to the main menu
    elsif Gosu.button_down?(Gosu::KB_2)
      @points = 0
      @game_state = :menu
    end
  end
  
end

window = GameWindow.new
window.show
 