import os
import zipfile

# get current working directory
current_dir = os.getcwd() #the folder where this script runs

# ask user for zip file name
zip_name = input("Enter a name for your zip file (without .zip): ").strip()

# check what user entered
if zip_name == "": 
    zip_name = "mytxt"
    print("No name entered. Using default name: mytxt.zip")
elif zip_name.lower().endswith(".zip"): 
    # remove the .zip part if user typed it
    zip_name = zip_name[:-4].strip() # remove last 4 characters
    print("Removed '.zip' from your input to avoid duplication.")

# final zip file path
zip_path = os.path.join(current_dir, zip_name + ".zip")

# find all .txt files in the folder
txt_files = []
for f in os.listdir(current_dir):
    if f.lower().endswith(".txt") and os.path.isfile(f):
        txt_files.append(f)

count = len(txt_files)

# create the zip only if there are .txt files
if count > 0:
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zipf:
        for f in txt_files:
            zipf.write(f, arcname=os.path.basename(f))
    print("There are", count, ".txt files and they were compressed into:")
    print(zip_path)
else:
    print("No .txt files found in this directory.")
