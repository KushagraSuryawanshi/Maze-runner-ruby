# Maze Runner Game

This is a maze runner game that I built as part of the **Intro to Programming** unit in my first semester, which started in February 2024. The project reflects my experience of coming up with an idea, learning to code in a new language (Ruby), and implementing that idea using the **Gosu** game development library—all on my own. It was a challenging yet rewarding experience, where I learned the importance of building something from scratch, figuring out the logic, and developing it in a language and library that were new to me at the time.

## Features

- **Player Movement:** The player controls a character that can move up, down, left, or right using the keyboard arrows.
- **Walls:** There are walls in the maze that the player cannot pass through.
- **Enemies:** Enemies randomly move around the maze based on difficulty (easy, medium, or hard).
- **Coins:** Collect coins scattered around the maze to increase your score.
- **Difficulty Levels:** The game allows you to choose between three difficulty levels (easy, medium, hard), each affecting the number of enemies.
- **Game States:** The game includes a main menu, gameplay, and a game-over state.
- **Graphics:** The game uses images for the player, enemies, walls, coins, and menu screen.

## Technologies Used

- **Gosu** - A Ruby library for making 2D games.
- **Ruby** - The programming language used to create the game.
- **Images** - Used for game objects like walls, coins, enemies, and the player.

## Code Structure

- **game_window.rb:** The main Ruby file where the game logic is implemented.
- **Wall, Coin, Enemy, and Player Classes:** These classes represent the game objects with properties like position and image.
- **Maze Layout:** The layout of the maze is defined in a 2D array, where `1` represents walls and `0` represents empty spaces.
- **Game States:** The game has several states like the menu, playing, and game over, each with specific functionality.

## How to Run the Game

To run the game on your system, follow these steps:

1. **Install Ruby:**
   - Ensure you have Ruby installed on your system. You can download it from [ruby-lang.org](https://www.ruby-lang.org).
   - To verify, run the command:
     ```bash
     ruby -v
     ```

2. **Install the Gosu Library:**
   - Install the Gosu gem using the following command:
     ```bash
     gem install gosu
     ```

3. **Clone the Repository:**
   - Clone this repository to your local machine or download the files as a ZIP archive.

4. **Run the Game:**
   - Navigate to the directory where the game files are located.
   - Run the game using the following command:
     ```bash
     ruby game_window.rb
     ```

5. **Enjoy the Game:**
   - The game window will open, and you can start playing!

## Challenges & Learning Experience

- **Building the Idea Independently:** I came up with the idea for this game and built it myself, from creating the basic layout to implementing the game mechanics. This project helped me apply my knowledge of programming concepts like logic, control flow, and object-oriented programming.
- **Learning Ruby and Gosu:** Ruby was new to me, and I had to learn it quickly to bring my idea to life. The Gosu library was also unfamiliar, but I managed to learn its basics within a short time to implement key features like movement, collision detection, and rendering.
- **Problem Solving:** Developing the game required me to think critically and solve problems around how different game elements (player, enemies, walls) interact with each other. I also worked on optimizing the maze generation and improving the user experience.

---

Thank you for checking out my **Maze Runner Game**. This project marks an important milestone in my programming journey, where I learned a lot about both coding and game development.

