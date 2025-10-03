#!/bin/bash

# --- Configuration ---
# This script reads the tasks.csv file and prints a formatted list of tasks and deadlines.
# It will skip any rows that are missing a task name or a deadline.
# Ensure this path is correct for your system.
TASK_FILE="/home/neil/portfolio/reminder/tasks.csv"
# --- End of Configuration ---

# Check if the task file actually exists
if [ ! -f "$TASK_FILE" ]; then
    echo "Error: Task file not found at $TASK_FILE"
    exit 1
fi

echo "--- Task List ---"

# Read the CSV file line by line
while IFS=',' read -r task deadline _; do
    # Trim leading/trailing whitespace from the variables
    task=$(echo "$task" | xargs)
    deadline=$(echo "$deadline" | xargs)

    # --- NEW: Check if both task and deadline are non-empty ---
    # The '-n' operator checks if a string has a non-zero length.
    if [[ -n "$task" && -n "$deadline" ]]; then
        # Print the task and its deadline in a formatted way
        printf " Deadline: %-12s | Task: %s\n" "$deadline" "$task"
    fi
    # --- End of New Check ---

done < "$TASK_FILE"

echo "-----------------"

exit 0
