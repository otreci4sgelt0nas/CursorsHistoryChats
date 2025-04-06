#!/bin/bash

# cursor_chat_stats.sh
# A utility script to display statistics about your Cursor chat usage
# Usage: ./cursor_chat_stats.sh

echo "Cursor Chat Statistics"
echo "======================"

# Path to Cursor workspaceStorage
cursor_path="$HOME/Library/Application Support/Cursor/User/workspaceStorage"

# Check if path exists
if [ ! -d "$cursor_path" ]; then
  echo "Cursor storage directory not found at: $cursor_path"
  exit 1
fi

# Change to directory
cd "$cursor_path"

# Count total workspaces
total_workspaces=$(find . -type d | wc -l)
total_workspaces=$((total_workspaces - 1))  # Subtract the root directory

# Count databases with chat history
total_databases=$(find . -name "state.vscdb" | wc -l)
databases_with_chat=0
total_messages=0

# Process each database
for db in $(find . -name "state.vscdb"); do
  # Check if this database has chat history
  has_prompts=$(sqlite3 "$db" "SELECT count(*) FROM ItemTable WHERE [key] = 'aiService.prompts';")
  
  if [ "$has_prompts" -gt 0 ]; then
    databases_with_chat=$((databases_with_chat + 1))
    
    # Get the chat message count (approximate by counting message objects in JSON)
    chat_data=$(sqlite3 "$db" "SELECT value FROM ItemTable WHERE [key] = 'aiService.prompts';")
    message_count=$(echo "$chat_data" | grep -o "\"text\"" | wc -l)
    total_messages=$((total_messages + message_count))
  fi
done

# Display statistics
echo "Total workspaces: $total_workspaces"
echo "Total databases: $total_databases"
echo "Databases with chat history: $databases_with_chat"
echo "Approximate total messages: $total_messages"

# Check for most active database (most messages)
echo ""
echo "Most Active Workspaces"
echo "---------------------"

for db in $(find . -name "state.vscdb"); do
  has_prompts=$(sqlite3 "$db" "SELECT count(*) FROM ItemTable WHERE [key] = 'aiService.prompts';")
  
  if [ "$has_prompts" -gt 0 ]; then
    workspace_name=$(echo "$db" | sed 's/\.\///g' | cut -d'/' -f1)
    chat_data=$(sqlite3 "$db" "SELECT value FROM ItemTable WHERE [key] = 'aiService.prompts';")
    message_count=$(echo "$chat_data" | grep -o "\"text\"" | wc -l)
    
    echo "$workspace_name: $message_count messages"
  fi
done | sort -t ':' -k 2 -n -r | head -5

echo ""
echo "Note: These are approximate statistics based on the structure of the Cursor chat data." 