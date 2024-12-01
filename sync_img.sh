#!/bin/bash

# Define the directories
input_dir="gyculture/content"
output_dir="imgcdn/images"
# mkdir -p "$output_dir"

executed_file=$(mktemp)
echo "$executed_file"
echo "" > "$executed_file"

# update
cd "$input_dir"
git pull
cd ../../

# Find all .md files in the input directory
find "$input_dir" -name "*.md" | while read -r file; do
    # Extract the specified links
    grep -oP "https://github.com/user-attachments/assets/[a-z0-9-]+" "$file" | while read -r url; do
        echo "true" > "$executed_file"
        echo "$url"
        # Extract the filename from the URL
        filename="$(basename "$url").png"
        # Download the file to the output directory
        # wget "$url" -O "$output_dir/$filename"
        # Replace
        new_url="https://gitee.com/sudiaty/imgcdn/raw/master/images/$filename"
        find "$input_dir" -type f -name "*.md" -exec sed -i "s|${url}|${new_url}|g" {} +
    done
done 

executed=$(cat "$executed_file")
rm "$executed_file"

if [ -n "$executed" ]; then
    echo "Commit changes"
    cd "$output_dir"
    git pull; git add .; git commit -m "Migrate images from github to gitee"; git push;
    cd "../../$input_dir"
    git pull; git add .; git commit -m "Migrate images from github to gitee"; git push;
fi

