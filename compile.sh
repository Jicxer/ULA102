#!/bin/bash

# Directory containing all submissions
SUBMISSIONS_DIR="submissions"
ASSIGNED_DIR="submissions/assigned_students"

# Directory to store compiled outputs and logs
OUTPUT_DIR="compiled_outputs"
LOG_DIR="logs"
INPUT_FILE="input.txt"

# Create the output and log directories if they don't exist
mkdir -p "$OUTPUT_DIR"
mkdir -p "$LOG_DIR"
mkdir -p "$ASSIGNED_DIR"

# Read IDs from the ids.txt file into an array
mapfile -t ids < grading.txt

# Loop through all files in the specified directory
for file in "$SUBMISSIONS_DIR"/*; do

    filename=$(basename "$file")    
    # Check if the filename contains any of the IDs
    for id in "${ids[@]}"; do
        if [[ "$filename" == *"$id"* ]]; then
            echo "Moving $filename to assigned directory."
            mv "$file" "$ASSIGNED_DIR"
            break
        fi
    done
done

# Initialize arrays to store compilation/execution results
successful_cpp=()
successful_py=()
failed_cpp=()
failed_py=()

# Loop through each file in the assigned submission directory
# Change the variable name to $SUBMISSIONS to compile all submisisons.
for FILE in "$ASSIGNED_DIR"/*; do
    # Get the base filename without extension (assumed to be username)
    BASENAME=$(basename "$FILE")
    USERNAME="${BASENAME%.*}"
    EXT="${BASENAME##*.}"

    if [ "$EXT" == "cpp" ]; then
        # For C++ files, compile with g++
        OUTPUT_FILE="$OUTPUT_DIR/$USERNAME.out"
        
        if clang++ "$FILE" -o "$OUTPUT_FILE" 2> "$LOG_DIR/$USERNAME.log"; then
            successful_cpp+=("$USERNAME")
        else
            failed_cpp+=("$USERNAME")
        fi

    elif [ "$EXT" == "py" ]; then
        if python "$FILE" < $INPUT_FILE >  "$LOG_DIR/$USERNAME.output" 2> "$LOG_DIR/$USERNAME.error"; then
            successful_py+=("$USERNAME")
        else
            failed_py+=("$USERNAME")
        fi
    else
        echo "Unsupported file type for $BASENAME. Skipping."
    fi

done

# Display summary
echo
echo "Compilation and Execution Summary:"
echo "----------------------------------"
echo "Successful C++ Compilations:"
for user in "${successful_cpp[@]}"; do
    echo "- $user"
done

echo
echo "Failed C++ Compilations:"
for user in "${failed_cpp[@]}"; do
    echo "- $user"
done

echo
echo "Successful Python Executions:"
for user in "${successful_py[@]}"; do
    echo "- $user"
done

echo
echo "Failed Python Executions:"
for user in "${failed_py[@]}"; do
    echo "- $user"
done
