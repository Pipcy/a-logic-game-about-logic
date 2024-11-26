import pygame
import random
from projectile import Projectile

# Initialize Pygame
pygame.init()

# Screen dimensions
SCREEN_WIDTH = 1080
SCREEN_HEIGHT = 640

# Colors
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
RED = (255, 0, 0)
GREEN = (0, 255, 0)

# Game settings
FPS = 60
GAME_TIME = 30  # seconds

# Player settings
PLAYER_SIZE = 100
PLAYER_SPEED = 5

# Coin settings
COIN_SIZE = 20

# Initialize screen
screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
pygame.display.set_caption("Best Shooter Game Ever, literally")

# Clock and font
clock = pygame.time.Clock()
font = pygame.font.SysFont(None, 48)

# Player
player = pygame.Rect(SCREEN_WIDTH // 15, SCREEN_HEIGHT // 2, PLAYER_SIZE, PLAYER_SIZE)

# Player State ( 0 or 1)
player_state = 0

# Coin
coin = pygame.Rect(
    random.randint(0, SCREEN_WIDTH - COIN_SIZE),
    random.randint(0, SCREEN_HEIGHT - COIN_SIZE),
    COIN_SIZE,
    COIN_SIZE,
)

# Variables
score = 0
start_time = pygame.time.get_ticks()

# List to store projectiles
projectiles = []
projectile_value = 0

# Game loop
running = True
while running:
    # Calculate elapsed time
    elapsed_time = (pygame.time.get_ticks() - start_time) / 1000
    remaining_time = max(0, GAME_TIME - elapsed_time)

    

    if remaining_time == 0:
        running = False

    # Event handling
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        if event.type == pygame.KEYDOWN:
            # change ammo (1 or 0)
            if event.key == pygame.K_1:
                projectile_value = 1
            elif event.key == pygame.K_0:
                projectile_value = 0

            if event.key == pygame.K_SPACE:  # Space bar pressed
                # Instantiate a new projectile
                projectiles.append(Projectile(projectile_value, player.x+PLAYER_SIZE, player.y+PLAYER_SIZE/2))
                for p in projectiles:
                    print(p.y)
                
    
    
    # update projectiles
    for projectile in projectiles[:]:
            projectile.update()
            if projectile.y < 0:  # Remove projectiles that move off-screen
                projectiles.remove(projectile)
            else:
                projectile.draw(screen)

    # Movement
    keys = pygame.key.get_pressed()
    # if keys[pygame.K_LEFT]:
    #     player.x -= PLAYER_SPEED
    # if keys[pygame.K_RIGHT]:
    #     player.x += PLAYER_SPEED
    if keys[pygame.K_UP]:
        player.y -= PLAYER_SPEED
    if keys[pygame.K_DOWN]:
        player.y += PLAYER_SPEED

    # Chnage Player state:
    if keys[pygame.K_LEFT] and player_state == 0:
        player_state = 1
        pygame.time.wait(100)
    elif keys[pygame.K_LEFT] and player_state == 1:
        player_state = 0
        pygame.time.wait(100)

    # Boundaries
    player.x = max(0, min(SCREEN_WIDTH - PLAYER_SIZE, player.x))
    player.y = max(0, min(SCREEN_HEIGHT - PLAYER_SIZE, player.y))

    # Collision with coin
    if player.colliderect(coin):
        score += 1
        coin.x = random.randint(0, SCREEN_WIDTH - COIN_SIZE)
        coin.y = random.randint(0, SCREEN_HEIGHT - COIN_SIZE)

    # Drawing
    screen.fill(WHITE)
    if player_state == 0:
        pygame.draw.rect(screen, GREEN, player)
    else: 
        pygame.draw.rect(screen, RED, player)
    pygame.draw.rect(screen, RED, coin)

    # Display score and time
    score_text = font.render(f"Score: {score}", True, WHITE)
    time_text = font.render(f"Time: {int(remaining_time)}", True, WHITE)
    screen.blit(score_text, (10, 10))
    screen.blit(time_text, (10, 50))

    # update projectiles
    for projectile in projectiles[:]:
            projectile.update()
            if projectile.y < 0:  # Remove projectiles that move off-screen
                projectiles.remove(projectile)
            else:
                projectile.draw(screen)

    # Update display
    pygame.display.flip()
    clock.tick(FPS)

# Game over
screen.fill(BLACK)
game_over_text = font.render("Game Over!", True, WHITE)
final_score_text = font.render(f"Final Score: {score}", True, WHITE)
screen.blit(game_over_text, (SCREEN_WIDTH // 2 - 100, SCREEN_HEIGHT // 2 - 50))
screen.blit(final_score_text, (SCREEN_WIDTH // 2 - 130, SCREEN_HEIGHT // 2 + 10))
pygame.display.flip()

# Wait a bit before closing
pygame.time.wait(3000)

pygame.quit()
