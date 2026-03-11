from PIL import Image

INPUT_IMAGE = "robot3.png"


RED_FILE = "red3.mem"
GREEN_FILE = "green3.mem"
BLUE_FILE = "blue3.mem"

img = Image.open(INPUT_IMAGE).convert("RGB")

img = img.resize((128,128))

pixels = img.load()

with open(RED_FILE, "w") as rf, open(GREEN_FILE, "w") as gf, open(BLUE_FILE, "w") as bf: 
    for y in range(128): 
        for x in range(128): 
            r8, g8, b8 = pixels[x, y]

            r4 = r8 >> 4
            g4 = g8 >> 4
            b4 = b8 >> 4

            rf.write(f"{r4:X}\n")
            gf.write(f"{g4:X}\n")
            bf.write(f"{b4:X}\n")

print("Done. Generated red.mem, green.mem, blue.mem")