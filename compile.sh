#!/bin/bash

# Directory containing all submissions
SUBMISSIONS_DIR="submissions"
ASSIGNED_DIR="submissions/assigned_students"

# Directories for outputs
OUTPUT_DIR="compiled_outputs"
LOG_DIR="logs"
CPP_LOG_DIR="logs/cpp_logs"
CPP_LOG_OUTPUT_DIR="logs/cpp_output_logs"
PY_LOG_OUTPUT_DIR="logs/py_logs"
INPUT_FILE="input.txt"

# Create them
mkdir -p "$OUTPUT_DIR"
mkdir -p "$LOG_DIR"
mkdir -p "$CPP_LOG_OUTPUT_DIR"
mkdir -p "$PY_LOG_OUTPUT_DIR"
mkdir -p "$ASSIGNED_DIR"
mkdir -p "$CPP_LOG_DIR"

# Read IDs from the ids.txt file into an array
mapfile -t ids < grading.txt

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

# Initialize arrays to store success or failures
successful_cpp=()
successful_py=()
failed_cpp=()
failed_py=()

# Loop through each file in the assigned submission directory
# Change the variable name to $SUBMISSIONS to compile all submisisons.
# This essentially just loops through CPP and PY extension files for the students
for FILE in "$ASSIGNED_DIR"/*; do
    # Get the base filename without extension (assumed to be username)
    # Use this for the student ID
    BASENAME=$(basename "$FILE")
    USERNAME="${BASENAME%.*}"
    EXT="${BASENAME##*.}"

    # If the file extension is CPP, compile it then store it into /compiled_outputs
    if [ "$EXT" == "cpp" ]; then
        OUTPUT_FILE="$OUTPUT_DIR/$USERNAME.out"
        
        # If the CPP file compiles, store this into a directory based on their user
        # Run this output file with a set input (input.txt)
        # Store the results of this file output into logs/cpp_output_logs
        # If file compiles correctly, store into array accordingly.
        if clang++ "$FILE" -o "$OUTPUT_FILE" 2> "$LOG_DIR/$USERNAME.log"; then
            if "$OUTPUT_FILE" < "$INPUT_FILE" > "$CPP_LOG_OUTPUT_DIR/${USERNAME}_output.log"; then 
                successful_cpp+=("$USERNAME")
            else
                failed_cpp+=("$USERNAME")
        fi
    else
        failed_cpp+=($USERNAME)
    fi

    # Same thing here as CPP.
    elif [ "$EXT" == "py" ]; then
        if python "$FILE" < $INPUT_FILE >  "$PY_LOG_OUTPUT_DIR/$USERNAME.output" 2> "$LOG_DIR/$USERNAME.error"; then
            successful_py+=("$USERNAME")
        else
            failed_py+=("$USERNAME")
        fi
    else
        echo "Unsupported file type for $BASENAME. Skipping."
    fi

done

# Display stuff
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
