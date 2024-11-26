import pygame
import random
import config as cf

class Enemy:
    def __init(self, inputA, inputB, x, y):
        self.inputA = inputA
        self.inputB = inputB
        self.x = x
        self.y = y
        self.speed = ENEMY_DEFAULT_SPEED

    def update(self):
        self.x -= self.speed

    def draw(self, screen)
        co
