# Bash Deadline Reminder
Never miss a deadline again with this command-line reminder tool. Powered by a simple Bash script and a CSV task list, it's designed to be automated with a daily cron job on any Linux machine, ensuring the right people get notified by email just before a deadline hits.

# Key Features
Simple CSV Database: Manages tasks in a straightforward tasks.csv file containing the task description, deadline, and recipient.

Automated Email Notifications: Connects to an SMTP server (e.g., Gmail) to send deadline reminders.

Consolidated Reminders: Groups all tasks due on the same day for a single person into one summary email.

Activity Logging: Records every action (success, failure, or no tasks due) to a log file for easy monitoring.

Cron Job Automation: Designed to be run automatically by the system's cron scheduler for set-and-forget operation.

# Setup & Configuration
Follow these steps to get the reminder system configured and running.

# 1. Prerequisites
Ensure you have a command-line mail client installed. This project is built using s-nail.

For Arch / Manjaro
sudo pacman -Syu s-nail

For Debian / Ubuntu
sudo apt-get install s-nail

# 2. Configure Email Sending
The script requires access to an SMTP server to send emails. This guide uses Gmail.

Create a Google App Password: For security, you cannot use your regular password. You must generate a 16-digit App Password for your Google account.

Create the .mailrc file: Create a configuration file in your home directory (~/.mailrc) to store your credentials securely.

Add Configuration: Paste the following into the ~/.mailrc file, replacing the placeholder values with your own.

Set the "From" name and address that will appear on emails
set from="your-email@gmail.com(Deadline Reminder)"

Gmail SMTP Relay Configuration
set smtp-use-starttls
set smtp=smtp://smtp.gmail.com:587
set smtp-auth=login
set smtp-auth-user=your-email@gmail.com
set smtp-auth-password="YOUR_16_DIGIT_APP_PASSWORD"

Secure the File: Restrict file permissions so only you can read it.

chmod 600 ~/.mailrc

# 3. Prepare the Task File (tasks.csv)
Create a file named tasks.csv in the project directory. The file must contain three columns in the following order: Task Description, YYYY-MM-DD, RecipientEmail.

Example tasks.csv:

"Submit quarterly report",2025-10-25,manager@example.com
"Prepare for team presentation",2025-10-26,alice@example.com
"Renew software license",2025-11-01,admin@example.com

# Usage

# Make the script executable:

chmod +x deadline_reminder.sh

# Run it manually to test:

bash ./deadline_reminder.sh

# Check the log file to see what happened:

cat ./reminder_log.txt

# Automation with Cron

To automate the script, add it to your user's crontab.

Open the crontab editor:

crontab -e

Add the following line. This example runs the script at 6:15 AM daily. You must adjust the time to your desired local time.

15 6 * * * /bin/bash ~/deadline_reminder.sh
