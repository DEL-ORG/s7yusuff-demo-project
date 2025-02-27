#!/bin/bash
push_to_github() {
    REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
    cd "$REPO_ROOT"
    git pull || {
        echo "Error: Git pull failed."
        return 1
    }
    dirs=($(find . -type d -not -path "*/.*" -not -path "./.git" -not -path "."))
    for i in "${!dirs[@]}"; do
        echo "$((i+1))) ${dirs[i]}"
    done
    echo "Enter the numbers of the folders you want to push (e.g., 1 3 5):"
    read -r selected_indices
    selected_folders=()
    for index in $selected_indices; do
        if [[ $index -ge 1 && $index -le ${#dirs[@]} ]]; then
            selected_folders+=("${dirs[$((index-1))]}")
        else
            echo "Invalid selection: $index"
            return 1
        fi
    done
    for folder in "${selected_folders[@]}"; do
        echo "$folder"
    done
    for folder in "${selected_folders[@]}"; do
        git add "$folder"
    done
    echo "Enter a commit message:"
    read -r commit_message
    if [ -z "$commit_message" ]; then
        echo "Error: Commit message cannot be empty."
        return 1
    fi
    git commit -m "$commit_message"
    git push || {
        echo "Error: Git push failed."
        return 1
    }

    echo "Changes from the "$folder" have been pushed to GitHub successfully!"
}

push_to_github
