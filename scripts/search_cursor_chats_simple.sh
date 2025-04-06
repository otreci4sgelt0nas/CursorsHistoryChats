#!/bin/bash

# search_cursor_chats_simple.sh
# A simplified utility script to search through Cursor chat history
# Usage: ./search_cursor_chats_simple.sh "your search term"

search_term="$1"

if [ -z "$search_term" ]; then
  echo "Please provide a search term."
  echo "Usage: ./search_cursor_chats_simple.sh \"your search term\""
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
  # Search for the term in chat history
  results=$(sqlite3 "$db" "SELECT value FROM ItemTable WHERE [key] = 'aiService.prompts' AND value LIKE '%$search_term%' LIMIT 1;")
  
  if [ ! -z "$results" ]; then
    found_results=true
    echo "Found in database: $db"
    
    # Display the first 500 characters to preview
    preview=$(echo "$results" | cut -c 1-500)
    echo "$preview"
    echo "..."
    echo "(Database contains more data. Use 'sqlite3 \"$db\" \"SELECT value FROM ItemTable WHERE [key] = '\''aiService.prompts'\''\"' to see full content)"
    echo "-----------------------------------------"
  fi
done

if [ "$found_results" = false ]; then
  echo "No results found for: $search_term"
fi

echo "Search complete."
echo "Note: To use Cursor's built-in history search, press ⌘+⌥+L (Mac) or Ctrl+Alt+L (Windows)" 