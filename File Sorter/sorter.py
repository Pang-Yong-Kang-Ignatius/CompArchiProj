import os
import zipfile
import time

current_dir = os.getcwd()
zip_name = input("Enter a name for your zip file (without .zip): ").strip()

if zip_name == "":
    zip_name = "mytxt"
    print("No name entered. Using default name: mytxt.zip")
elif zip_name.lower().endswith(".zip"):
    zip_name = zip_name[:-4].strip()
    print("Removed '.zip' from your input to avoid duplication.")

zip_path = os.path.join(current_dir, zip_name + ".zip")

txt_files = [f for f in os.listdir(current_dir) if f.lower().endswith(".txt") and os.path.isfile(f)]
count = len(txt_files)

if count > 0:
    # ✅ Start timing only for compression
    start_time = time.perf_counter()

    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zipf:
        for f in txt_files:
            zipf.write(f, arcname=os.path.basename(f))

    end_time = time.perf_counter()
    elapsed = end_time - start_time

    print(f"There are {count} .txt files and they were compressed into:\n{zip_path}")
    print(f"Zipping execution time: {elapsed:.6f} seconds")
else:
    print("No .txt files found in this directory.")
