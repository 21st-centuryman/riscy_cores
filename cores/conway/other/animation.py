from PIL import Image, ImageDraw, ImageFont
import os

# Parameters
text_file_path = './frames.txt'
font_path = '/Library/Fonts/Arial Unicode.ttf'
font_size = 24
gif_output_path = '../../../assets/conway.gif'
font = ImageFont.truetype(font_path, font_size)

# Read text file
with open(text_file_path, 'r', encoding='utf-8') as file:
    lines = file.readlines()

# Split and save
split_number = 1
current_split = []
frames = []
for i, line in enumerate(lines):
    current_split.append(line) 
    if (i + 1) % 60 == 0 or i == len(lines) - 1:
        max_width = max(len(line) for line in current_split) * font_size
        max_height = len(current_split) * font_size + 10
        
        img = Image.new('RGB', (max_width, max_height), color = (30, 30, 46))
        d = ImageDraw.Draw(img)
        
        y = 0
        for line in current_split:
            d.text((0, y), line, font=font, fill=(205, 214, 244))
            y += font_size

        frames.append(img)
        
        split_number += 1
        current_split = []

# Save GIF
frames[0].save(gif_output_path, save_all=True, append_images=frames[1:], optimize=True, duration=50, loop=0)

print(f"Text file has been split and saved as a GIF at {gif_output_path}.")
