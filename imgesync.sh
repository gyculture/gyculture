#!/bin/bash

# Define the directories
input_dir="content"
output_dir="imagesync"
# mkdir -p "$output_dir"

executed_file=$(mktemp)
echo "$executed_file"
echo "" > "$executed_file"

# update
git pull

# Find all .md files in the input directory
find "$input_dir" -name "*.md" | while read -r file; do
    # Extract the specified links
    grep -oP "https://github.com/user-attachments/assets/[a-z0-9-]+" "$file" | while read -r url; do
        echo "true" > "$executed_file"
        echo "$url"
        # Extract the filename from the URL
        filename=$(basename "$url")
        # Download the file to the output directory
        # wget "$url" -O "$output_dir/$filename"
        api="https://api.superbed.cn/upload?token="
        # Upload
        new_url=$(curl -F "file=@$output_dir/$filename" $api | grep -oP '(?<="url": ")[^"]+')
        # Replace
        if [ -n "$new_url" ]; then
            echo "Replacing $url with $new_url"
            find "$input_dir" -type f -name "*.md" -exec sed -i "s|${url}|${new_url}|g" {} +
        fi
    done
done

executed=$(cat "$executed_file")
rm "$executed_file"

if [ -n "$executed" ]; then
    echo "Commit changes"
    git pull; git add .; git commit -m "Migrate images from github to gitee"; git push;
fi

