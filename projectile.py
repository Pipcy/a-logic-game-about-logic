import pygame
import random

class Projectile:
    def __init__(self,value, x, y):
        self.value = value  
        self.x = x  # Initial x position
        self.y = y  # Initial y position
        self.speed = 5  # Speed of the projectile moving forward

    def update(self):
        # Update the projectile's position
        self.x += self.speed

    def draw(self, screen):
        # Draw the projectile on the screen
        color = (255, 0, 0) if self.value == 1 else (0, 0, 255)  # Red for 1, Blue for 0
        pygame.draw.circle(screen, color, (self.x, self.y), 5)
