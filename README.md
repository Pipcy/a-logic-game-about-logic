# A Logic Game about Logic ("ALGAL") 👾
ALGAL is a **logic-focused** game where players solve **logic** puzzles to sharpen their **logical** reasoning and explore the power of **logic-driven** gameplay.
Watch the [DEMO VIDEO HERE](https://www.youtube.com/watch?v=_8Lh1Su_pLo).
## Code Structure 
The player controller is handled in the **modules** folder. Current working modules for UART are found in the **verilog** folder, with the topmost module being *uart_test.v*. The constraints file is located in the **constraints** folder. Then all Python code, including main.py, is in the **python** folder. Sprite assetts are in **python/art**.

🤓 
## Controls 
### For NEXYS A7 🕹️
- Button BTNU: Player Up
- Button BTND: Player Down
- Button BTNR: Fire Bullet
- Switch H17: Switch Ammo 0 / 1
- Button BTNL: Reset Game
### For Keyboard (Playtesting only) ⌨️
- W： Player Up
- S：Player Down
- Space： Fire Bullet
- U - Switch Ammo "1"
- I - Switch Ammo "0"


## Playtest on your Laptop 💻
Make sure you have Python installed 🐍.
```
git clone https://github.com/Pipcy/a-logic-game-about-logic.git
cd python
pip install pygame
pip install numpy
pip install serial
pip install threading
python main.py
```
Editor's note: My personal best record is level 6 🏆. Email me at ppp@bu.edu if you get a higher score than me and I may personally send you 5 dollars 💰.

## Run on the FPGA 🏃‍♀️
1. Create a new project in Vivado.
2. Download and add the files in the verilog folder from GitHub.
3. Download and add the constraints file from Github.
4. Generate the bitstream and push it to the FPGA to start sending serial data.
5. Follow the Python instructions above to run the Python program.

## Source 👩‍🏫
🔗 [Presentation Slides](https://docs.google.com/presentation/d/1rNwIijCkfnFcIcx30BswdSxuwaVUb0PAgqpbr5YiXKE/edit?usp=sharing) 

## Group Members 👩‍👩‍👧‍👧
- [Pippi Pi](mailto:ppp@bu.edu) 🤡
- [Elena Berrios](mailto:eberrios@bu.edu) 🤠
- Julie Green 🦈
- Kayla Tracey 🐬
