#!/usr/bin/env zsh

# *** mkcd ***
mkcd() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: mkcd <directory-name>"
        return 1
    fi

    mkdir "$1" && cd "$1"
}

# *** cdf ***
function cdf() {
    if [[ "$(pwd)" =~ "$HOME/.*" ]]; then
        target=$(fd -t d | fzf --height 50% --layout=reverse --border --inline-info --preview 'ls -F -1 {}')
        if [[ -n "$target" ]]; then
            cd $target
        fi
    else
        echo -e "\e[33mThe directory must be under your home directory to be able to run this.\e[m"
        return 1
    fi
}

# *** brew ***
brew() {
    # Run the original brew command
    command brew "$@"

    # If the command was an install or upgrade, update the Brewfile
    if [[ "$1" == "install" || "$1" == "upgrade" || "$1" == "uninstall" ]]; then
        echo "Updating Brewfile..."
        command brew bundle dump --force --file=~/dotfiles/Brewfile
    fi
}

# *** fcat ***
# NAME
#   fcat - Recursively display or process files in directories
#
# SYNOPSIS
#   fcat [options] <directory/file> [directory/file...]
#
# DESCRIPTION
#   fcat is a powerful file content display and processing tool that combines the functionality
#   of find, cat, and clipboard operations. It recursively processes files in directories,
#   displaying their contents with clear separators and optional processing.
#
#   By default, fcat respects .gitignore patterns to exclude files that should not be tracked.
#   It can handle both directories and individual files, and provides various output options.
#
# OPTIONS
#   -i, --ignore-gitignore
#           Respect .gitignore patterns. This will exclude files ignored by git.
#
#   -o, --output FILE
#           Write output to FILE instead of stdout. The output will include all file contents
#           with the same formatting as stdout output.
#
#   -c, --clipboard
#           Copy output to clipboard. On macOS, uses pbcopy; on Linux, uses xclip;
#           on Windows WSL, uses clip.exe. The output will be copied exactly as it would
#           appear on stdout.
#
#   -n, --name PATTERN
#           Filter files by name pattern using find -name. The pattern should be quoted
#           to prevent shell expansion. For example: '*.js' or '*.{js,ts}'.
#           Note: This uses find's -name option, not -n.
#
#   -h, --help
#           Display this help message and exit.
#
# EXAMPLES
#   Basic usage:
#     fcat src/                # Display all files in src directory
#     fcat file.txt            # Display contents of a single file
#
#   Multiple targets:
#     fcat src/ lib/          # Display files from multiple directories
#     fcat file1.txt file2.txt # Display multiple files
#
#   With options:
#     fcat -i .               # Show only git-tracked files (respect .gitignore)
#     fcat -n '*.js' src/     # Show only JavaScript files
#     fcat -c src/main.js     # Copy file content to clipboard
#     fcat -o output.txt lib/ # Save output to a file
#
#   Combined options:
#     fcat -i -n '*.{js,ts}' src/  # Show all JS/TS files, respecting .gitignore
#     fcat -c -n '*.md' docs/      # Copy all markdown files to clipboard
#
# OUTPUT FORMAT
#   Each file's content is displayed with a header showing the file path and
#   separated by a line of equal signs:
#
#     File: path/to/file
#     [file contents]
#     ==================================================
#
#   This format is preserved in both stdout output and when writing to files or
#   copying to clipboard.
#
# EXIT STATUS
#   0  Success
#   1  Error (invalid arguments, file not found, etc.)
#
# SEE ALSO
#   find(1), cat(1), gitignore(5)

# Helper function to check if a file matches a name pattern
_fcat_match_pattern() {
    local file="$1"
    local pattern="$2"
    local base_name=$(basename "$file")
    [[ "$base_name" == $pattern ]]
}

# Helper function to process a single file
_fcat_process_file() {
    local file="$1"
    local output_var="$2"

    if [ -f "$file" ]; then
        # Print to stdout
        echo "File: $file"
        cat "$file" 2>/dev/null
        echo "=================================================="

        # Buffer for file or clipboard output
        if [ -n "$output_var" ]; then
            eval "$output_var+=\"File: $file\n\""
            eval "$output_var+=\"\$(cat \"$file\" 2>/dev/null)\n\""
            eval "$output_var+=\"==================================================\n\""
        fi
    fi
}

# Helper function to find files in a directory
_fcat_find_files() {
    local dir="$1"
    local ignore_gitignore="$2"
    local name_pattern="$3"
    local files=()

    if [ "$ignore_gitignore" = false ]; then
        local tmp_exclude=$(mktemp)
        local tmp_output=$(mktemp)

        # Check root .gitignore first
        if [ -f ".gitignore" ]; then
            while IFS= read -r pattern; do
                [[ "$pattern" =~ ^# || -z "$pattern" ]] && continue
                # Escape special characters in the pattern
                pattern=$(echo "$pattern" | sed 's/[.*&$]/\\&/g')
                echo "$pattern" >>"$tmp_exclude"
            done <.gitignore
        fi

        # Check target directory .gitignore if different from current
        if [ -f "$dir/.gitignore" ] && [ "$dir" != "." ] && [ "$dir" != "./" ]; then
            while IFS= read -r pattern; do
                [[ "$pattern" =~ ^# || -z "$pattern" ]] && continue
                # Escape special characters in the pattern
                pattern=$(echo "$pattern" | sed 's/[.*&$]/\\&/g')
                echo "$pattern" >>"$tmp_exclude"
            done <"$dir/.gitignore"
        fi

        # Use find with exclusions if we have any
        if [ -s "$tmp_exclude" ]; then
            if [ -n "$name_pattern" ]; then
                find "$dir" -type f -name "$name_pattern" | grep -v -f "$tmp_exclude" >"$tmp_output"
            else
                find "$dir" -type f | grep -v -f "$tmp_exclude" >"$tmp_output"
            fi
        else
            if [ -n "$name_pattern" ]; then
                find "$dir" -type f -name "$name_pattern" >"$tmp_output"
            else
                find "$dir" -type f >"$tmp_output"
            fi
        fi

        # Read files from temporary output file
        while IFS= read -r file; do
            files+=("$file")
        done <"$tmp_output"

        # Clean up
        [ -f "$tmp_exclude" ] && rm "$tmp_exclude"
        [ -f "$tmp_output" ] && rm "$tmp_output"
    else
        local tmp_output=$(mktemp)

        if [ -n "$name_pattern" ]; then
            find "$dir" -type f -name "$name_pattern" >"$tmp_output"
        else
            find "$dir" -type f >"$tmp_output"
        fi

        # Read files from temporary output file
        while IFS= read -r file; do
            files+=("$file")
        done <"$tmp_output"

        # Clean up
        [ -f "$tmp_output" ] && rm "$tmp_output"
    fi

    # Return the array
    echo "${files[@]}"
}

# Helper function to write output to file or clipboard
_fcat_write_output() {
    local output="$1"
    local output_file="$2"
    local copy_to_clipboard="$3"

    if [ -n "$output_file" ]; then
        echo -e "$output" >"$output_file"
        echo "Output written to $output_file"
    fi

    if [ "$copy_to_clipboard" = true ]; then
        if command -v pbcopy >/dev/null 2>&1; then
            echo -e "$output" | pbcopy
            echo "Output copied to clipboard"
        elif command -v xclip >/dev/null 2>&1; then
            echo -e "$output" | xclip -selection clipboard
            echo "Output copied to clipboard"
        elif command -v clip.exe >/dev/null 2>&1; then
            echo -e "$output" | clip.exe
            echo "Output copied to clipboard"
        fi
    fi
}

# Main fcat function
fcat() {
    # Parse options
    local ignore_gitignore=true
    local output_file=""
    local copy_to_clipboard=false
    local name_pattern=""
    local dirs=()

    # Buffer for clipboard or file output
    local output=""

    # Show usage if no arguments
    if [ $# -eq 0 ]; then
        echo "Usage: fcat [options] <directory/file> [directory/file...]"
        echo ""
        echo "Options:"
        echo "  -i, --ignore-gitignore   Respect .gitignore patterns (default: show all files)"
        echo "  -o, --output FILE        Write output to FILE instead of stdout"
        echo "  -c, --clipboard          Copy output to clipboard"
        echo "  -n, --name PATTERN       Filter files by name pattern (like find -name)"
        echo "  -h, --help               Display this help message"
        echo ""
        echo "Examples:"
        echo "  fcat src/                # Display all files in src directory"
        echo "  fcat -i config/ data/    # Display files in multiple directories, respecting .gitignore"
        echo "  fcat -o output.txt lib/  # Save output to output.txt"
        echo "  fcat -c src/main.js      # Copy file content to clipboard"
        echo "  fcat -n '*.js' src/      # Display only JavaScript files in src directory"
        return 0
    fi

    # Process arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
        -i | --ignore-gitignore)
            ignore_gitignore=false
            shift
            ;;
        -o | --output)
            if [[ -z "$2" || "$2" == -* ]]; then
                echo "Error: --output requires a filename argument"
                return 1
            fi
            output_file="$2"
            shift 2
            ;;
        -c | --clipboard)
            if ! command -v pbcopy >/dev/null 2>&1 && ! command -v xclip >/dev/null 2>&1 && ! command -v clip.exe >/dev/null 2>&1; then
                echo "Error: No clipboard command found (pbcopy, xclip, or clip.exe required)"
                return 1
            fi
            copy_to_clipboard=true
            shift
            ;;
        -n | --name)
            if [[ -z "$2" || "$2" == -* ]]; then
                echo "Error: --name requires a pattern argument"
                return 1
            fi
            name_pattern="$2"
            shift 2
            ;;
        -h | --help)
            echo "Usage: fcat [options] <directory/file> [directory/file...]"
            echo ""
            echo "Options:"
            echo "  -i, --ignore-gitignore   Respect .gitignore patterns (default: show all files)"
            echo "  -o, --output FILE        Write output to FILE instead of stdout"
            echo "  -c, --clipboard          Copy output to clipboard"
            echo "  -n, --name PATTERN       Filter files by name pattern (like find -name)"
            echo "  -h, --help               Display this help message"
            echo ""
            echo "Examples:"
            echo "  fcat src/                # Display all files in src directory"
            echo "  fcat -i config/ data/    # Display files in multiple directories, respecting .gitignore"
            echo "  fcat -o output.txt lib/  # Save output to output.txt"
            echo "  fcat -c src/main.js      # Copy file content to clipboard"
            echo "  fcat -n '*.js' src/      # Display only JavaScript files in src directory"
            return 0
            ;;
        *)
            dirs+=("$1")
            shift
            ;;
        esac
    done

    # Check if we have directories/files to process
    if [ ${#dirs[@]} -eq 0 ]; then
        echo "Error: No directories or files specified"
        return 1
    fi

    # Process each directory/file
    for dir in "${dirs[@]}"; do
        if [ ! -e "$dir" ]; then
            echo "Warning: $dir does not exist, skipping" >&2
            continue
        fi

        if [ -d "$dir" ]; then
            # It's a directory, find files inside
            local files=($(_fcat_find_files "$dir" "$ignore_gitignore" "$name_pattern"))

            # Process each file
            for file in "${files[@]}"; do
                _fcat_process_file "$file" "output"
            done
        elif [ -f "$dir" ]; then
            # It's a single file (path matches)
            if [ -n "$name_pattern" ]; then
                if _fcat_match_pattern "$dir" "$name_pattern"; then
                    _fcat_process_file "$dir" "output"
                fi
            else
                _fcat_process_file "$dir" "output"
            fi
        fi
    done

    # Write output to file or clipboard
    _fcat_write_output "$output" "$output_file" "$copy_to_clipboard"
}

# *** ts2mp4 ***
ts2mp4() {
    # Parse options
    local output_dir="mp4"
    local force=false

    # Show usage if --help flag is used
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        echo "Usage: ts2mp4 [options]"
        echo ""
        echo "Convert all TS files in the current directory to MP4 format."
        echo ""
        echo "Options:"
        echo "  -o, --output DIR     Specify output directory (default: mp4)"
        echo "  -f, --force          Overwrite existing files without asking"
        echo "  -h, --help           Display this help message"
        echo ""
        echo "Examples:"
        echo "  ts2mp4                       # Convert all TS files to MP4 in 'mp4/' directory"
        echo "  ts2mp4 -o converted          # Convert all TS files to MP4 in 'converted/' directory"
        echo "  ts2mp4 --force               # Overwrite existing MP4 files without asking"
        return 0
    fi

    # Process arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
        -o | --output)
            if [[ -z "$2" || "$2" == -* ]]; then
                echo "Error: --output requires a directory name argument"
                return 1
            fi
            output_dir="$2"
            shift 2
            ;;
        -f | --force)
            force=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Run 'ts2mp4 --help' for usage information."
            return 1
            ;;
        esac
    done

    # Check for TS files in current directory
    local ts_files=(*.ts)
    if [[ ! -f $ts_files[1] ]]; then
        echo "Error: No TS files found in the current directory."
        return 1
    fi

    # Check if ffmpeg is installed
    if ! command -v ffmpeg &>/dev/null; then
        echo "Error: ffmpeg is not installed. Please install it first."
        return 1
    fi

    # Create output directory if it doesn't exist
    if [[ ! -d "$output_dir" ]]; then
        echo "Creating output directory: $output_dir"
        mkdir -p "$output_dir"
        if [[ $? -ne 0 ]]; then
            echo "Error: Failed to create output directory."
            return 1
        fi
    fi

    # Convert files
    local count=0
    local skipped=0
    echo "Converting TS files to MP4 format in $output_dir/ directory..."

    for file in *.ts; do
        local output_file="$output_dir/${file%.ts}.mp4"

        # Check if output file already exists
        if [[ -f "$output_file" && "$force" == false ]]; then
            echo "Skipping $file (output file already exists, use --force to overwrite)"
            ((skipped++))
            continue
        fi

        echo "Converting: $file -> $output_file"
        if [[ "$force" == true ]]; then
            ffmpeg -i "$file" -c copy "$output_file" -y 2>/dev/null
        else
            ffmpeg -i "$file" -c copy "$output_file" 2>/dev/null
        fi

        if [[ $? -eq 0 ]]; then
            ((count++))
        else
            echo "Error: Failed to convert $file"
        fi
    done

    echo "Conversion complete: $count files converted, $skipped files skipped."
}
