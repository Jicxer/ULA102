#!/bin/bash

# Directory containing all submissions
SUBMISSIONS_DIR="submissions"
# Directory to store compiled outputs and logs
OUTPUT_DIR="compiled_outputs"
LOG_DIR="logs"
INPUT_FILE="input.txt"

# Create the output and log directories if they don't exist
mkdir -p "$OUTPUT_DIR"
mkdir -p "$LOG_DIR"

# Initialize arrays to store compilation/execution results
successful_cpp=()
successful_py=()
failed_cpp=()
failed_py=()

# Loop through each file in the submissions directory
for FILE in "$SUBMISSIONS_DIR"/*; do
    # Get the base filename without extension (assumed to be username)
    BASENAME=$(basename "$FILE")
    USERNAME="${BASENAME%.*}"
    EXT="${BASENAME##*.}"

    if [ "$EXT" == "cpp" ]; then
        # For C++ files, compile with g++
        OUTPUT_FILE="$OUTPUT_DIR/$USERNAME.out"
        
        if g++ "$FILE" -o "$OUTPUT_FILE" 2> "$LOG_DIR/$USERNAME.log"; then
            successful_cpp+=("$USERNAME")
        else
            failed_cpp+=("$USERNAME")
        fi

    elif [ "$EXT" == "py" ]; then
        # For Python files, run with python3
        
        if python3 "$FILE" < $INPUT_FILE >  "$LOG_DIR/$USERNAME.output" 2> "$LOG_DIR/$USERNAME.error"; then
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
