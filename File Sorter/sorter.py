# Import necessary modules
import os       # For interacting with the operating system
import zipfile  # For creating zip files

# Get current working directory
current_dir = os.getcwd()

# Ask user for zip file name
zip_name = input("Enter a name for your zip file (without .zip): ").strip()

# Handle empty input
if zip_name == "":
    zip_name = "mytxt"
    print("No name entered. Using default name: mytxt.zip")
# Remove ".zip" if included
elif zip_name.lower().endswith(".zip"):
    zip_name = zip_name[:-4].strip()
    print("Removed '.zip' from your input to avoid duplication.")

# Create zip file path
zip_path = os.path.join(current_dir, zip_name + ".zip")

# Find all .txt files in the directory
txt_files = [
    f for f in os.listdir(current_dir)
    if f.lower().endswith(".txt") and os.path.isfile(os.path.join(current_dir, f))
]
count = len(txt_files)

# Compress if files exist
if count > 0:
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zipf:
        for f in txt_files:
            zipf.write(f, arcname=os.path.basename(f))

    print(f"There are number of {count} .txt files and compressed into a .zip file")
    print(f"Created zip file path: {zip_path}")
else:
    print("No .txt files found in this directory.")
