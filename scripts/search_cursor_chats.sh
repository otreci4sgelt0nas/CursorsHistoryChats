#!/bin/bash

# search_cursor_chats.sh
# A utility script to search through Cursor chat history
# Usage: ./search_cursor_chats.sh "your search term"

# Important Cursor information:
# - Chat history is stored in SQLite databases in ~/Library/Application Support/Cursor/User/workspaceStorage/
# - Each workspace has a folder with an MD5 hash name containing state.vscdb files
# - Chat data is stored in 'aiService.prompts' key
# - Within Cursor, access chat history with ⌘+⌥+L (Mac) or Ctrl+Alt+L (Windows)
# - Chat history is stored locally and not synced between devices

search_term="$1"

if [ -z "$search_term" ]; then
  echo "Please provide a search term."
  echo "Usage: ./search_cursor_chats.sh \"your search term\""
  exit 1
fi

echo "Searching Cursor chat history for: $search_term"
echo "=========================================="

# Path to Cursor workspaceStorage
cursor_path="$HOME/Library/Application Support/Cursor/User/workspaceStorage"

# Check if path exists
if [ ! -d "$cursor_path" ]; then
  echo "Cursor storage directory not found at: $cursor_path"
  exit 1
fi

# Find all state.vscdb files
found_results=false

cd "$cursor_path"
for db in $(find . -name "state.vscdb"); do
  # Check if this database has chat history (aiService.prompts)
  has_prompts=$(sqlite3 "$db" "SELECT count(*) FROM ItemTable WHERE [key] = 'aiService.prompts';")
  
  if [ "$has_prompts" -gt 0 ]; then
    # Search for the term in chat history
    results=$(sqlite3 "$db" "SELECT value FROM ItemTable WHERE [key] = 'aiService.prompts' AND value LIKE '%$search_term%';")
    
    if [ ! -z "$results" ]; then
      found_results=true
      echo "Found in database: $db"
      echo "-----------------------------------------"
      
      # Extract and format the chat messages
      # Using jq if available, otherwise just print the raw JSON
      if command -v jq &> /dev/null; then
        echo "$results" | jq -r '.[] | select(.text != null) | .text' 2>/dev/null || echo "$results"
      else
        echo "$results"
      fi
      
      echo "-----------------------------------------"
      echo ""
    fi
  fi
done

if [ "$found_results" = false ]; then
  echo "No results found for: $search_term"
fi

echo "Search complete."
echo "Note: To use Cursor's built-in history search, press ⌘+⌥+L (Mac) or Ctrl+Alt+L (Windows)" 