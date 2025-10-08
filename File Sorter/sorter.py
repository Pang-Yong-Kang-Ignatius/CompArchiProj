import os            # imports the os module to work with files and directories
import zipfile       # imports the zipfile module to create or read .zip files

txt_files = []       # create an empty list to store names of .txt files

# go through every file in the current directory
for file in os.listdir():
    # check if the file ends with .txt and is an actual file (not a folder)
    if file.endswith(".txt") and os.path.isfile(file):
        txt_files.append(file)   # add it to the list

count = len(txt_files)           # count how many .txt files were found

# create a new zip file called mytxt.zip in write mode
with zipfile.ZipFile("mytxt.zip", "w") as zipf:
    for f in txt_files:          # loop through each text file
        zipf.write(f)            # add the file to the zip

# print how many .txt files were found and that they were compressed
print("There are", count, ".txt files and compressed into a zip file")
