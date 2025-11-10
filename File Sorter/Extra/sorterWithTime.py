# Import necessary modules
import os  # For interacting with the operating system (file paths, directory listings, etc.)
import zipfile  # For working with zip files (creating, extracting, etc.)
import time  # For measuring the execution time

# Get the current working directory
current_dir = os.getcwd()

# Ask the user for a name for the zip file (without ".zip" at the end)
zip_name = input("Enter a name for your zip file (without .zip): ").strip()

# Check if the user entered an empty name
if zip_name == "":
    zip_name = "mytxt"  # Use a default name if no name is entered
    print("No name entered. Using default name: mytxt.zip")
# Check if the user entered a name with ".zip" (and remove it)
elif zip_name.lower().endswith(".zip"):
    zip_name = zip_name[:-4].strip()  # Remove the ".zip" suffix to avoid duplication
    print("Removed '.zip' from your input to avoid duplication.")

# Create the full path for the zip file to be created
zip_path = os.path.join(current_dir, zip_name + ".zip")

# Find all .txt files in the current directory
txt_files = [f for f in os.listdir(current_dir) if f.lower().endswith(".txt") and os.path.isfile(f)]
count = len(txt_files)  # Count the number of .txt files found

# Check if any .txt files were found
if count > 0:
    # ✅ Start timing only for compression process
    start_time = time.perf_counter()  # Record the start time

    # Open the zip file in write mode and start adding files
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zipf:
        # Loop through each .txt file and add it to the zip file
        for f in txt_files:
            zipf.write(f, arcname=os.path.basename(f))  # Write each file to the zip, preserving the file name

    # End the timing once the compression is finished
    end_time = time.perf_counter()
    elapsed = end_time - start_time  # Calculate the elapsed time for the zipping process

    # Print the results: number of files, zip file location, and execution time
    print(f"There are {count} .txt files and they were compressed into:\n{zip_path}")
    print(f"Zipping execution time: {elapsed:.6f} seconds")  # Display the time with high precision
else:
    # If no .txt files were found, inform the user
    print("No .txt files found in this directory.")
