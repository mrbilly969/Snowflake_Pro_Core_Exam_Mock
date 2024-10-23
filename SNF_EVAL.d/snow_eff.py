import os
import time
import random
import sys

os.system('color 0f')

# Characters to be used in the snowflake effect
characters = ["*", "❄", "❅", "❆"]  # Snowflake symbols for better visual representation

# Set the height and width of the matrix screen
height = 20
width = 80  

# Initialize a grid to hold the falling characters
matrix = [[" " for _ in range(width)] for _ in range(height)]

# Keep track of the positions of falling snowflakes
falling_positions = [random.randint(0, height - 1) for _ in range(width)]

def update_matrix():
    for i in range(width):
        # Random chance for each column to generate a new snowflake at the top of the column
        if random.random() < 0.02:  # 2% chance to generate a new snowflake at the top of the column
            falling_positions[i] = 0  # Reset position to the top
        else:
            # Move the snowflake down if it's already in the grid
            if falling_positions[i] < height - 1:
                matrix[falling_positions[i]][i] = " "
                falling_positions[i] += 1  

            # Clear the last line if it's reached
            if falling_positions[i] == height - 1:
                falling_positions[i] += 1  # Move out of the grid
            
            # Update the new position in matrix
            if falling_positions[i] < height:  # Only add if still visible
                matrix[falling_positions[i]][i] = random.choice(characters)  # New snowflake in new position

def print_matrix():
    os.system('cls' if os.name == 'nt' else 'clear')
    
    # Print the matrix without side borders
    for row in matrix:
        print("".join(row))  # Just print the rows as they are

# Animation loop
try:
    while True:
        update_matrix()
        print_matrix()
        time.sleep(0.1)  # Control the speed of the falling effect
except KeyboardInterrupt:
    print("\nExiting...")
    sys.exit()
