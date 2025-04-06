# Using CursorsHistoryChats on Windows

This guide will help Windows users set up and use the CursorsHistoryChats tools.

## Option 1: Using Windows Subsystem for Linux (WSL) - Recommended

This is the easiest way to use the scripts without modification.

### Setup

1. Install WSL by opening PowerShell as administrator and running:
   ```powershell
   wsl --install
   ```

2. After installation and restart, open Ubuntu (or your chosen Linux distribution) from the Start menu

3. Install required packages:
   ```bash
   sudo apt update
   sudo apt install sqlite3 jq
   ```

4. Clone the repository:
   ```bash
   git clone https://github.com/otreci4sgelt0nas/CursorsHistoryChats.git
   cd CursorsHistoryChats
   chmod +x scripts/*.sh
   ```

5. Create a symbolic link to your Windows Cursor data directory:
   ```bash
   mkdir -p ~/win_cursor
   ln -s /mnt/c/Users/YOUR_USERNAME/AppData/Roaming/Cursor/User/workspaceStorage ~/win_cursor/workspaceStorage
   ```

6. Edit the scripts to use the Windows path:
   ```bash
   sed -i 's|$HOME/Library/Application Support/Cursor/User/workspaceStorage|$HOME/win_cursor/workspaceStorage|g' scripts/*.sh
   ```

7. Now you can run the scripts normally:
   ```bash
   ./scripts/search_cursor_chats.sh "your search term"
   ```

## Option 2: Using Git Bash

If you prefer to use Git Bash directly:

1. Install [Git for Windows](https://git-scm.com/download/win) which includes Git Bash

2. Install [SQLite for Windows](https://www.sqlite.org/download.html)
   - Download the Precompiled Binaries for Windows
   - Add SQLite to your PATH

3. (Optional) Install [jq for Windows](https://stedolan.github.io/jq/download/)
   - Add jq to your PATH

4. Clone the repository using Git Bash:
   ```bash
   git clone https://github.com/otreci4sgelt0nas/CursorsHistoryChats.git
   cd CursorsHistoryChats
   ```

5. Edit the scripts to use the Windows path:
   ```bash
   sed -i 's|$HOME/Library/Application Support/Cursor/User/workspaceStorage|$APPDATA/Cursor/User/workspaceStorage|g' scripts/*.sh
   ```

6. Run the scripts using Git Bash:
   ```bash
   ./scripts/search_cursor_chats_simple.sh "your search term"
   ```

## Option 3: PowerShell Equivalent

If you prefer a PowerShell native solution, you'd need to rewrite the scripts. Here's a starting point for a PowerShell version:

```powershell
# Simple PowerShell version of the search script
# Save as search_cursor_chats.ps1

param(
    [Parameter(Mandatory=$true)]
    [string]$SearchTerm
)

$CursorPath = "$env:APPDATA\Cursor\User\workspaceStorage"

Write-Host "Searching Cursor chat history for: $SearchTerm"
Write-Host "=========================================="

if (-not (Test-Path $CursorPath)) {
    Write-Host "Cursor storage directory not found at: $CursorPath"
    exit 1
}

$DbFiles = Get-ChildItem -Path $CursorPath -Recurse -Filter "state.vscdb" -File

foreach ($DbFile in $DbFiles) {
    # This is where you would search the SQLite database
    # You'll need to use a PowerShell SQLite module or invoke SQLite directly
    
    # Example using SQLite command line (assumes sqlite3.exe is in PATH):
    $Query = "SELECT value FROM ItemTable WHERE [key] = 'aiService.prompts' AND value LIKE '%$SearchTerm%' LIMIT 1;"
    $Result = & sqlite3.exe $DbFile.FullName $Query
    
    if ($Result) {
        Write-Host "Found in database: $($DbFile.FullName)"
        Write-Host $Result.Substring(0, [Math]::Min(500, $Result.Length))
        Write-Host "..."
        Write-Host "-----------------------------------------"
    }
}
```

Note: The PowerShell version is provided as a starting point and will require SQLite support to be fully functional. 