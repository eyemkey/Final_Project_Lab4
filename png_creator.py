from PIL import Image

WIDTH = 128
HEIGHT = 128

RED_FILE = "red1.mem"
GREEN_FILE = "green1.mem"
BLUE_FILE = "blue1.mem"
OUTPUT_IMAGE = "reconstructed.png"

# Read hex values from files
with open(RED_FILE, "r") as rf:
    red_vals = [int(line.strip(), 16) for line in rf if line.strip()]

with open(GREEN_FILE, "r") as gf:
    green_vals = [int(line.strip(), 16) for line in gf if line.strip()]

with open(BLUE_FILE, "r") as bf:
    blue_vals = [int(line.strip(), 16) for line in bf if line.strip()]

# Check size
num_pixels = WIDTH * HEIGHT
if not (len(red_vals) == len(green_vals) == len(blue_vals) == num_pixels):
    raise ValueError(
        f"Expected {num_pixels} values per file, got "
        f"R={len(red_vals)}, G={len(green_vals)}, B={len(blue_vals)}"
    )

# Create image
img = Image.new("RGB", (WIDTH, HEIGHT))
pixels = img.load()

for y in range(HEIGHT):
    for x in range(WIDTH):
        addr = y * WIDTH + x

        r4 = red_vals[addr]
        g4 = green_vals[addr]
        b4 = blue_vals[addr]

        # Expand 4-bit back to 8-bit
        # Example: 0xA -> 0xAA
        r8 = (r4 << 4) | r4
        g8 = (g4 << 4) | g4
        b8 = (b4 << 4) | b4

        pixels[x, y] = (r8, g8, b8)

img.save(OUTPUT_IMAGE)
print(f"Saved {OUTPUT_IMAGE}")