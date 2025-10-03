#!/bin/bash

# --- Configuration ---
TASK_FILE="/home/neil/portfolio/reminder/tasks.csv"
LOG_FILE="/home/neil/portfolio/reminder/reminder_log.txt"
NOTIFY_DAYS_BEFORE=1
# --- End of Configuration ---

# Create the log file if it doesn't exist and add a timestamp
echo "----------------------------------------" >> "$LOG_FILE"
echo "Log for $(date)" >> "$LOG_FILE"

# Check if the task file exists
if [ ! -f "$TASK_FILE" ]; then
    echo "ERROR: Task file not found at $TASK_FILE" >> "$LOG_FILE"
    exit 1
fi

# Use an associative array to group tasks by email address
declare -A tasks_by_email
# THIS IS THE CORRECTED LINE: It now gets the seconds from the start of today (midnight)
TODAY_SECONDS=$(date -d "today 00:00:00" +%s)

# Read the task file line by line
while IFS=',' read -r task_name deadline email; do
    # Clean up any weird spacing or Windows line endings (\r)
    task_name=$(echo "$task_name" | xargs)
    deadline=$(echo "$deadline" | xargs)
    email=$(echo "$email" | xargs)

    # Calculate days left based on the start of each day
    DEADLINE_SECONDS=$(date -d "$deadline" +%s 2>/dev/null)
    SECONDS_DIFF=$((DEADLINE_SECONDS - TODAY_SECONDS))
    DAYS_LEFT=$((SECONDS_DIFF / 86400))

    if [ "$DAYS_LEFT" -eq "$NOTIFY_DAYS_BEFORE" ]; then
        tasks_by_email["$email"]+="• The task '$task_name' is due tomorrow ($deadline).\n"
    fi
done < "$TASK_FILE"

# Check if there are any tasks to email about
if [ ${#tasks_by_email[@]} -eq 0 ]; then
    echo "INFO: No tasks due today. No emails sent." >> "$LOG_FILE"
else
    # Loop through each email address that has pending tasks
    for email in "${!tasks_by_email[@]}"; do
        EMAIL_BODY="Hello,\n\nYou have the following deadlines approaching:\n\n${tasks_by_email[$email]}"
        SUBJECT="Daily Deadline Reminder"

        echo -e "$EMAIL_BODY" | mail -s "$SUBJECT" "$email"

        if [ $? -eq 0 ]; then
            echo "SUCCESS: Email sent to $email" >> "$LOG_FILE"
        else
            echo "!!! FAILURE: Failed to send email to $email" >> "$LOG_FILE"
        fi
    done
fi

exit 0
