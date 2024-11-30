import pygame
import random



class Projectile:

    # Load images as class-level attributes so they are shared across instances
    image1 = None
    image0 = None


    @classmethod
    def load_images(cls):
        cls.image1 = pygame.image.load('art/1.png')
        cls.image1 = pygame.transform.scale(cls.image1, (20, 20))  
        cls.image0 = pygame.image.load('art/0.png')
        cls.image0 = pygame.transform.scale(cls.image0, (20, 20))  

    def __init__(self,value, x, y):
        self.value = value  
        self.x = x  # Initial x position
        self.y = y  # Initial y position
        self.speed = 5  # Speed of the projectile moving forward
        self.angle = 360


    def update(self):
        # Update the projectile's position
        self.x += self.speed

        # Update the rotation angle (adjust increment for desired speed of rotation)
        self.angle -= 3
        if self.angle <= 0:
            self.angle += 360 
        

    def draw(self, screen):
        # Draw the projectile on the screen
        # color = (255, 0, 0) if self.value == 1 else (0, 0, 255)  # Red for 1, Blue for 0
        # pygame.draw.circle(screen, color, (self.x, self.y), 5)
        image = Projectile.image1 if self.value == 1 else Projectile.image0
        rotated_image = pygame.transform.rotate(image, self.angle)
        rect = rotated_image.get_rect(center=(self.x, self.y))
        screen.blit(rotated_image, rect.topleft)
        #screen.blit(image, (self.x - image.get_width() // 2, self.y - image.get_height() // 2))
