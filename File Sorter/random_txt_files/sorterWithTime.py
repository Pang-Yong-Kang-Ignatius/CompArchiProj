# Import necessary modules
import os           # For interacting with the operating system (file paths, directory listings, etc.)
import zipfile      # For creating zip files
import time         # For measuring execution time

# Get current working directory
current_dir = os.getcwd()

# Ask user for zip file name
zip_name = input("Enter a name for your zip file (without .zip): ").strip()

# Handle empty input
if zip_name == "":
    zip_name = "mytxt"
    print("No name entered. Using default name: mytxt.zip")
# Remove ".zip" if the user included it
elif zip_name.lower().endswith(".zip"):
    zip_name = zip_name[:-4].strip()
    print("Removed '.zip' from your input to avoid duplication.")

# Create the zip file path
zip_path = os.path.join(current_dir, zip_name + ".zip")

# Find all .txt files in current directory
txt_files = [
    f for f in os.listdir(current_dir)
    if f.lower().endswith(".txt") and os.path.isfile(os.path.join(current_dir, f))
]


count = len(txt_files)

# Compress if there are .txt files
if count > 0:
    start_time = time.perf_counter()

    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zipf:
        for f in txt_files:
            zipf.write(f, arcname=os.path.basename(f))

    end_time = time.perf_counter()
    elapsed = end_time - start_time

    # ✅ Final output (matches your C version)
    print(f"There are number of {count} .txt files and compressed into a .zip file")
    print(f"Created zip file path: {zip_path}")
    print(f"Zipping execution time: {elapsed:.6f} seconds")

else:
    print("No .txt files found in this directory.")
