import pygame
import sys
# from main import main as game_main

# Initialize Pygame
pygame.init()

# Constants
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
FPS = 60

# Colors
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
GRAY = (100, 100, 100)
GREEN = (0, 255, 0)
DARK_GREEN = (0, 200, 0)

# Set up the screen
screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
pygame.display.set_caption("Game Title Screen")

# Set up font
font = pygame.font.Font(None, 74)
button_font = pygame.font.Font(None, 50)

# Clock for controlling frame rate
clock = pygame.time.Clock()

# Function to draw the button
def draw_button(surface, text, rect, color, hover_color, action=None):
    mouse_pos = pygame.mouse.get_pos()
    clicked = pygame.mouse.get_pressed()[0]

    # Check if mouse is over button
    if rect.collidepoint(mouse_pos):
        pygame.draw.rect(surface, hover_color, rect)
        if clicked and action:
            action()
    else:
        pygame.draw.rect(surface, color, rect)

    # Draw the button text
    button_text = button_font.render(text, True, WHITE)
    text_rect = button_text.get_rect(center=rect.center)
    surface.blit(button_text, text_rect)

# Action to start the game
def start_game():
    print("Game Starting...")
    # Transition to the game or another screen here
    

# Main loop
def main():
    title_text = font.render("Game Title", True, WHITE)
    title_rect = title_text.get_rect(center=(SCREEN_WIDTH // 2, SCREEN_HEIGHT // 3))

    # Button dimensions
    button_width = 200
    button_height = 80
    button_rect = pygame.Rect(
        (SCREEN_WIDTH // 2 - button_width // 2, SCREEN_HEIGHT // 2),
        (button_width, button_height),
    )

    running = True
    while running:
        screen.fill(BLACK)

        # Event handling
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()

        # Draw title
        screen.blit(title_text, title_rect)

        # Draw button
        draw_button(screen, "Start", button_rect, GREEN, DARK_GREEN, start_game)

        # Update the display
        pygame.display.flip()

        # Control the frame rate
        clock.tick(FPS)

if __name__ == "__main__":
    main()
