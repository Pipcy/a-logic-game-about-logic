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
        cls.images['1'] = pygame.transform.scale(pygame.image.load('art/1.png'), (20, 20))
        cls.images['0'] = pygame.transform.scale(pygame.image.load('art/0.png'), (20, 20))
        cls.images['AND'] = pygame.transform.scale(pygame.image.load('art/and.png'), (200, 80))
        cls.images['OR'] = pygame.transform.scale(pygame.image.load('art/or.png'), (200, 80))
        cls.images['NAND'] = pygame.transform.scale(pygame.image.load('art/nand.png'), (200, 80))
        cls.images['NOR'] = pygame.transform.scale(pygame.image.load('art/nor.png'), (200, 80))
        cls.images['XOR'] = pygame.transform.scale(pygame.image.load('art/xor.png'), (200, 80))
        cls.images['XNOR'] = pygame.transform.scale(pygame.image.load('art/xnor.png'), (200, 80))
        

    def __init__(self, x, y, inputA=2, inputB=2):
        self.x = x  # Initial x position
        self.y = y  # Initial y position
    
        self.inputA = inputA
        self.inputB = inputB
        self.enemyType = random.choice(cf.ENEMY_TYPE)       # randomly choose an enemy type
        self.output = random.randint(0, 1)                  # randomly generate output 0 or 1
        self.input_result = 0                                # empty, wrong, right


        self.speed = 2                                      # Speed of the enemy moving left
        self.isAlive = True                                 # Whether the enemy is still active
        
        if self.enemyType in Enemy.images:
            self.image = Enemy.images[self.enemyType]
        else:
            raise ValueError(f"Unknown enemyType: {self.enemyType}")

    def update(self):
        if self.isAlive:
            # Move the enemy left
            self.x -= self.speed

    def draw(self, screen):
        if self.isAlive:
            # Draw the enemy on the screen
            rect = self.image.get_rect(center=(self.x, self.y))
            screen.blit(self.image, rect.topleft)

            # draw input
            inputA_image = Enemy.images['1'] if self.inputA == 1 else Enemy.images['0'] if self.inputA == 0 else None
            inputB_image = Enemy.images['1'] if self.inputB == 1 else Enemy.images['0']if self.inputB == 0 else None    
            
            if inputA_image is not None:
                screen.blit(inputA_image, rect.topleft) 
            if inputB_image is not None: 
                screen.blit(inputB_image, rect.midleft)
            
            # draw output
            screen.blit(Enemy.images[str(self.output)], rect.midright)


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
        projectile_val = projectile.value

        # Check for collision
        if enemy_rect.colliderect(projectile_rect):
            # self.isAlive = False  # Mark the enemy as "dead"

            if projectile_val == 1 and projectile.y <= self.y: # 1 collide with the upper half
                self.inputA = 1
            elif projectile_val == 1 and projectile.y > self.y: # 1 collide with the lower half
                self.inputB = 1
            elif projectile_val == 0 and projectile.y <= self.y: # 0 collide with the upper half
                self.inputA = 0
            elif projectile_val == 0 and projectile.y > self.y: # 0 collide with the lower half
                self.inputB = 0
            return True

        return False
    
    def check_logic(self):
        # AND
        if self.enemyType == 'AND' and self.inputA != 2 and self.inputB != 2:
            self.input_result = self.inputA and self.inputB
            
        # OR
        if self.enemyType == 'OR' and self.inputA != 2 and self.inputB != 2:
            self.input_result = self.inputA or self.inputB

        # NAND
        if self.enemyType == 'NAND' and self.inputA != 2 and self.inputB != 2:
            self.input_result = self.inputA != 1 and self.inputB != 1

        # NOR
        if self.enemyType == 'NOR' and self.inputA != 2 and self.inputB != 2:
            self.input_result = self.inputA == 0 and self.inputB == 0

        # XOR
        if self.enemyType == 'XOR' and self.inputA != 2 and self.inputB != 2:
            self.input_result = self.inputA != self.inputB 

        # XNOR
        if self.enemyType == 'XNOR' and self.inputA != 2 and self.inputB != 2:
            self.input_result = self.inputA == self.inputB 

        if self.input_result == self.output:
            self.isAlive = False

        # increase speed if logic wrong
        if self.inputA != 2 and self.inputB != 2 and self.isAlive:
            self.speed = 4


