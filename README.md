# ULA102
Assignment 5 ULA2 Grading

## Directory Structure
    .
    ├── submissions/             # Directory containing all student submissions
    │   ├── assigned_students/    # Specific students assigned for grading
    ├── compiled_outputs/         # Directory for storing compiled output files (C++ binaries)
    ├── logs/                     # Directory for logs from each script's compilation and execution
    ├── input.txt                 # Default input file used for Python scripts requiring input
    └── grading.txt               # File containing a list of student IDs for assigned students

### Input.txt
The grading script automatically redirects input.txt, as the input for each Python file in the assigned_students directory.
The file provides default input to all Python files that require it.

### Grading.txt
The list of student IDs for the submissions we're assigned for grading. The bash script filters the submissions to only those we're assigned to.
The formatting should be a single student ID to identify the specific submissions for each line. Copy and paste Cell B rows from the Grading Excel Sheet onto Grading.txt.

