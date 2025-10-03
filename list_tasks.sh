#!/bin/bash

# Configuration

# Ensure this path is correct for your system.
TASK_FILE="/your/path/tasks.csv"

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

    if [[ -n "$task" && -n "$deadline" ]]; then
        # Print the task and its deadline in a formatted way
        printf " Deadline: %-12s | Task: %s\n" "$deadline" "$task"
    fi

done < "$TASK_FILE"

echo "-----------------"

exit 0
