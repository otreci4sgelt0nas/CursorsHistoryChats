# CursorsHistoryChats

A simple, lightweight utility for searching through your Cursor AI chat history across all workspaces.

![Cursor Chat Search Banner](https://raw.githubusercontent.com/username/CursorsHistoryChats/main/assets/banner.png)

## 🌟 Features

- Search through all Cursor workspace databases with a single command
- Find your important AI conversations by keyword or phrase
- Get statistics about your Cursor chat usage
- Works on macOS (and adaptable to Windows)
- Multiple utilities available:
  - `scripts/search_cursor_chats.sh` - Full-featured search with pretty output (requires jq)
  - `scripts/search_cursor_chats_simple.sh` - Lightweight search with no dependencies
  - `scripts/cursor_chat_stats.sh` - Statistics about your Cursor chat usage

## 📋 Background

Cursor.sh is an amazing AI-powered IDE, but finding specific conversations across multiple projects can be challenging. This tool solves that by letting you search through all your Cursor chat history at once, without having to manually open each project.

## 📁 Project Structure

```
CursorsHistoryChats/
├── assets/             # Images and other static assets
├── docs/               # Documentation
│   └── cursor_chat_reference.md  # Detailed reference about Cursor chat storage
├── scripts/            # Utility scripts
│   ├── search_cursor_chats.sh         # Full-featured search script (requires jq)
│   ├── search_cursor_chats_simple.sh  # Simple search script with no dependencies
│   └── cursor_chat_stats.sh           # Statistics about your Cursor chat usage
├── .gitignore          # Git ignore file
├── LICENSE             # MIT License
└── README.md           # This file
```

## 🔧 Installation

```bash
# Clone the repository
git clone https://github.com/your-username/CursorsHistoryChats.git

# Navigate to the project directory
cd CursorsHistoryChats

# Make the scripts executable
chmod +x scripts/search_cursor_chats.sh
chmod +x scripts/search_cursor_chats_simple.sh
chmod +x scripts/cursor_chat_stats.sh
```

## 🚀 Usage

### Basic Search

```bash
./scripts/search_cursor_chats_simple.sh "search term"
```

### Search with Formatted Output (requires jq)

```bash
./scripts/search_cursor_chats.sh "search term"
```

### View Chat Statistics

```bash
./scripts/cursor_chat_stats.sh
```

### Examples

```bash
# Search for React discussions
./scripts/search_cursor_chats.sh "react component"

# Get statistics about your Cursor usage
./scripts/cursor_chat_stats.sh
```

## 📖 How It Works

Cursor stores chat history in SQLite databases in:
- macOS: `~/Library/Application Support/Cursor/User/workspaceStorage/`
- Windows: `%APPDATA%\Cursor\User\workspaceStorage\`

Each workspace has its own database file (`state.vscdb`) with chat history stored in the `aiService.prompts` field of the `ItemTable` table.

The scripts search through all these databases for your search term and display matching conversations or statistics.

## 📝 Documentation

For more detailed information, see the `docs/cursor_chat_reference.md` file which includes:
- Complete database structure
- How to access chat history directly
- Common SQL queries
- Additional tips and tricks

## 🛠️ Requirements

- Bash shell environment
- SQLite3
- (Optional) jq for the full-featured search script

## 🔄 Compatibility

- Tested on macOS (darwin 24.3.0)
- Should work on most Unix-like systems
- Windows users may need to adapt paths or use WSL

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest features
- Submit pull requests

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- The amazing Cursor team for building such a useful AI-powered IDE
- The SQLite project for their lightweight database that makes this possible

## ⚠️ Disclaimer

This is an unofficial utility and is not affiliated with or endorsed by the Cursor team. Use at your own risk. 