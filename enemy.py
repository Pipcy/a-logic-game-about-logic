import pygame
import random
import config as cf
from projectile import Projectile

# class Enemy:
#     def __init(self, inputA, inputB, x, y):
#         self.inputA = inputA
#         self.inputB = inputB
#         self.x = x
#         self.y = y
#         self.speed = cf.ENEMY_DEFAULT_SPEED

#     def update(self):
#         self.x -= self.speed

#     # def draw(self, screen)
        
class Enemy:
    # Load image as a class-level attribute
    images = {}

    @classmethod
    def load_images(cls):
        # cls.image = pygame.image.load('art/and1-01.png')
        # cls.image = pygame.transform.scale(cls.image, (100, 100))  # Scale to desired size
        cls.images['AND1'] = pygame.transform.scale(pygame.image.load('art/and1-xx.png'), (200, 70))
        cls.images['OR1'] = pygame.transform.scale(pygame.image.load('art/or1-xx.png'), (200, 70))

    def __init__(self, x, y, enemyType='AND1', inputA=0, inputB=0):
        self.x = x  # Initial x position
        self.y = y  # Initial y position
        self.enemyType = enemyType
        self.inputA = inputA
        self.inputB = inputB
        self.speed = 3  # Speed of the enemy moving left
        self.isAlive = True  # Whether the enemy is still active
        
        if enemyType in Enemy.images:
            self.image = Enemy.images[enemyType]
        else:
            raise ValueError(f"Unknown enemyType: {enemyType}")

    def update(self):
        if self.isAlive:
            # Move the enemy left
            self.x -= self.speed

    def draw(self, screen):
        if self.isAlive:
            # Draw the enemy on the screen
            rect = self.image.get_rect(center=(self.x, self.y))
            screen.blit(self.image, rect.topleft)

    def check_collision(self, projectile):
        """
        Checks if the enemy has collided with the given projectile.
        If a collision occurs, sets isAlive to False.
        """
        if not self.isAlive:
            return False  # Skip collision check if already "dead"

        # Create rectangles for collision detection
        enemy_rect = self.image.get_rect(center=(self.x, self.y))
        projectile_image = Projectile.image1 if projectile.value == 1 else Projectile.image0
        projectile_rect = projectile_image.get_rect(center=(projectile.x, projectile.y))

        # Check for collision
        if enemy_rect.colliderect(projectile_rect):
            self.isAlive = False  # Mark the enemy as "dead"
            return True

        return False

