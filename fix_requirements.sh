#!/bin/bash

# Define the path to the requirements.txt file
REQUIREMENTS_FILE="requirements.txt"

# Create a temporary array to store package names and versions
declare -a packages

# Read the requirements.txt line by line
while IFS= read -r line; do
    # Extract the package name before the '@' symbol (if present)
    package_name=$(echo "$line" | cut -d' ' -f1 | cut -d'@' -f1)
    
    # Skip lines that are empty or comments
    if [[ -z "$package_name" || "$package_name" =~ ^# ]]; then
        continue
    fi

    # Get the version number of the package using pip show
    version=$(pip show "$package_name" | grep -i "Version" | cut -d' ' -f2)

    # Check if version is found
    if [[ -z "$version" ]]; then
        echo "Package $package_name not found or has no version."
        continue
    fi

    # Add the package and its version to the array (in the format package==version)
    packages+=("$package_name==$version")

done < "$REQUIREMENTS_FILE"

# Clear the existing contents of the requirements.txt file
> "$REQUIREMENTS_FILE"

# Write each package with its version on a new line
for package in "${packages[@]}"; do
    echo "$package" >> "$REQUIREMENTS_FILE"
done

echo "requirements.txt has been updated with package versions."
