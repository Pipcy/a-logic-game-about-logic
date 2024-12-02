import pygame
import random
from projectile import Projectile
from enemy import Enemy

# config
from config import SCREEN_WIDTH
from config import SCREEN_HEIGHT
from config import FPS
from config import GAME_TIME
from config import PLAYER_SIZE
from config import PLAYER_SPEED
from config import ENEMY_DEFAULT_SPEED
from config import COIN_SIZE
from config import WHITE
from config import BLACK
from config import RED
from config import GREEN
import config as cf

# Initialize Pygame
pygame.init()

# Initialize screen
screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
pygame.display.set_caption("Best Shooter Game Ever, literally")
background_surface = pygame.image.load('art/background0.jpg')
resized_background = pygame.transform.scale(background_surface, (SCREEN_WIDTH, SCREEN_HEIGHT))


# Clock and font
clock = pygame.time.Clock()
font = pygame.font.SysFont(None, 48)

# Player
player = pygame.Rect(SCREEN_WIDTH // 15, SCREEN_HEIGHT // 2, PLAYER_SIZE, PLAYER_SIZE)
player_state = 0


# Variables
score = 0
start_time = pygame.time.get_ticks()

# List to store projectiles
projectiles = []
projectile_value = 0
Projectile.load_images()

#enemy
Enemy.load_images()
#enemies = [Enemy(1080, cf.ENEMY_SPAWN_Y[random.randint(0, 2)]) for _ in range(2)]  # Create some enemies
enemies = [Enemy(1080, random.choice(cf.ENEMY_SPAWN_Y)) for _ in range(2)]  # Create some enemies


#lose
def lose():
    screen.fill(BLACK)
    game_over_text = font.render("You lost!", True, WHITE)
    final_score_text = font.render(f"Final Score: {score}", True, WHITE)
    screen.blit(game_over_text, (SCREEN_WIDTH // 2 - 100, SCREEN_HEIGHT // 2 - 50))
    screen.blit(final_score_text, (SCREEN_WIDTH // 2 - 130, SCREEN_HEIGHT // 2 + 10))
    pygame.display.flip()
    pygame.time.wait(3000)
    pygame.quit()

# game over
def over():
    screen.fill(BLACK)
    game_over_text = font.render("Game Over!", True, WHITE)
    final_score_text = font.render(f"Final Score: {score}", True, WHITE)
    screen.blit(game_over_text, (SCREEN_WIDTH // 2 - 100, SCREEN_HEIGHT // 2 - 50))
    screen.blit(final_score_text, (SCREEN_WIDTH // 2 - 130, SCREEN_HEIGHT // 2 + 10))
    pygame.display.flip()
    # Wait a bit before closing
    pygame.time.wait(3000)
    pygame.quit()


# Game loop
running = True
while running:
    ## print(str(enemies[0].inputA)+str(enemies[0].inputB))
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
            if event.key == pygame.K_a:
                projectile_value = 1
                player_state = 1
            elif event.key == pygame.K_d:
                projectile_value = 0
                player_state = 0

            if event.key == pygame.K_SPACE:  # Space bar pressed
                # Instantiate a new projectile
                projectiles.append(Projectile(projectile_value, player.x+PLAYER_SIZE, player.y+PLAYER_SIZE/2))
                
    # Player Movement
    keys = pygame.key.get_pressed()
    if keys[pygame.K_w]:
        player.y -= PLAYER_SPEED
    if keys[pygame.K_s]:
        player.y += PLAYER_SPEED

    # Boundaries
    player.x = max(0, min(SCREEN_WIDTH - PLAYER_SIZE, player.x))
    player.y = max(0, min(SCREEN_HEIGHT - PLAYER_SIZE, player.y))

    # Drawing
    screen.fill(BLACK)
    screen.blit(resized_background,(0,0))

    if player_state == 0:
        pygame.draw.rect(screen, cf.BLUE, player)
    else: 
        pygame.draw.rect(screen, RED, player)
    #pygame.draw.rect(screen, RED, coin)

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

    # Update enemies and check for collisions
    print(str(enemies[0].inputA)+str(enemies[0].inputB)+str(enemies[0].input_result))
    for enemy in enemies:
        enemy.update()
        enemy.check_logic()
        for projectile in projectiles:
            if enemy.check_collision(projectile):
                score+=1
                projectiles.remove(projectile) # projectile disappear when hit an enemy
                break
        enemy.draw(screen)

        if enemy.x <= 100: # when enemy moved in danger zone
            lose()

        

    # Update display
    pygame.display.flip()
    clock.tick(FPS)

# Game over
over()
