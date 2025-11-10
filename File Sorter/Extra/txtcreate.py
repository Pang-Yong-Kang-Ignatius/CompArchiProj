import os
import random
import string

# Function to generate random text content
def generate_random_text(length=100):
    return ''.join(random.choices(string.ascii_letters + string.digits + string.punctuation + ' ', k=length))

# Directory to save the .txt files
output_dir = './random_txt_files'

# Create a directory to store the files if it doesn't exist
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

# Create 50 random .txt files
for i in range(1, 1000):
    file_name = f"{output_dir}/file_{i}.txt"
    with open(file_name, 'w') as file:
        content = generate_random_text()  # Generate random content
        file.write(content)

print("999 random .txt files have been created.")
