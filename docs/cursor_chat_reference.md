# Cursor Chat History Reference

## Where Chat History is Stored

- **macOS**: `~/Library/Application Support/Cursor/User/workspaceStorage/`
- **Windows**: `%APPDATA%\Cursor\User\workspaceStorage\`

## Database Structure

Cursor chat history is stored in SQLite databases:
- Each workspace has a folder with an MD5 hash name (e.g., `f7d8b1ce8dde92721c95ac3bd31b63b4`)
- Inside each folder is a `state.vscdb` file containing the chat data
- Chat messages are stored in the `ItemTable` table under the key `aiService.prompts`
- The data is stored as JSON strings containing message history

## Accessing Chat History

### Within Cursor
- Click the history icon in the Cursor interface
- Keyboard shortcut: `⌘+⌥+L` (Mac) or `Ctrl+Alt+L` (Windows)

### Using SQL Queries
Common queries to extract chat data:

```sql
-- Check which tables exist in the database
SELECT name FROM sqlite_master WHERE type='table';

-- Find which databases contain chat history
SELECT count(*) FROM ItemTable WHERE [key] = 'aiService.prompts';

-- Search for a specific term in chat history
SELECT value FROM ItemTable WHERE [key] = 'aiService.prompts' AND value LIKE '%search_term%';
```

## Important Notes

1. **Local Storage**: Chat history is stored locally on your computer and is not synced to Cursor's servers
2. **Per Device**: If you switch to a different computer, you won't have access to your previous history
3. **No Export**: Cursor does not provide a built-in way to export chat history (as of current version)
4. **Database Format**: The chat data is stored as JSON arrays with message objects containing `text` and `commandType` fields

## Using the Search Script

The `search_cursor_chats.sh` script simplifies searching through chat history:

```bash
# Make the script executable
chmod +x search_cursor_chats.sh

# Search for a term
./search_cursor_chats.sh "l2unity"
```

## Third-Party Tools

There are community-created tools for browsing and exporting Cursor chat history:
- **cursor-chat-browser**: Allows browsing and downloading chat logs
- **SpecStory Cursor Extension**: View and save Chat & Composer history as Markdown 