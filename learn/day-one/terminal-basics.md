# Terminal Basics

> **15-minute read. The first thing to make peace with if you want to do anything in cloud, AI, or DevOps.**

## Why the terminal exists

A graphical interface (GUI) is great when you know what's available. The terminal is great when you want to do exactly *one specific thing*, very fast, and possibly automate it. Most cloud and AI tools are command-line first because:

- It's faster for engineers once you learn it.
- Commands are easy to script and repeat.
- It works the same over SSH on a remote machine where there's no GUI.
- AI tools, package managers, and deployment scripts all assume you have one.

You don't have to love it. You just have to be functional.

## What is a "terminal" exactly

A terminal (or "terminal emulator") is the window. The thing you type into.

A **shell** is the program running inside the terminal that interprets what you type. The most common shells:

- **bash** - older default, still everywhere
- **zsh** - default on macOS since 2019, slight upgrade
- **fish** - friendlier syntax, less universal

For our purposes: which one you have doesn't matter. Commands are the same.

A **command line** is a single line you type into the shell.

## Opening one

- **Mac**: `Cmd+Space`, type "Terminal," hit Enter.
- **Linux**: `Ctrl+Alt+T` usually works, or find "Terminal" in your apps.
- **Windows**: Install [WSL (Windows Subsystem for Linux)](https://learn.microsoft.com/en-us/windows/wsl/install). Then "Ubuntu" appears as an app. That's your terminal. (Don't use Command Prompt or PowerShell yet - the rest of the world uses bash/zsh, save yourself the friction.)

You'll see something like:

```
patrick@laptop:~$
```

That's the **prompt**. It's the shell saying "ready for input." After the `$` (or `%` on zsh) is where you type.

## The five commands you'll use a thousand times

### `pwd` - "print working directory"
Where am I right now?

```
$ pwd
/home/patrick
```

The terminal is always *somewhere* in your file system. `pwd` tells you where.

### `ls` - "list"
What's in the current directory?

```
$ ls
Documents  Downloads  Music  Pictures  projects
```

Useful flags:
- `ls -l` - long format (sizes, dates, permissions)
- `ls -a` - include hidden files (those starting with `.`)
- `ls -lah` - all of the above, human-readable sizes

### `cd` - "change directory"
Move into a folder.

```
$ cd Documents
$ pwd
/home/patrick/Documents
```

Special shortcuts:
- `cd` (alone) or `cd ~` - go home
- `cd ..` - go up one level
- `cd -` - go back to where you were

### `cat` - "concatenate" (used as: print a file)
Show the contents of a file.

```
$ cat README.md
# My Project
This is a readme.
```

For long files, use `less file.md` (press `q` to quit).

### `mkdir` and `rm` - make / remove
```
$ mkdir myproject       # make a directory
$ rm file.txt           # remove a file
$ rm -r mydir           # remove a directory and its contents
```

**Be careful with `rm`.** There's no recycle bin. `rm -rf /` will try to delete your entire filesystem. Don't run commands you don't understand.

## Paths: absolute vs relative

- **Absolute path** starts with `/`: `/home/patrick/Documents/notes.txt`. Always points to the same place.
- **Relative path** is relative to where you are: `./notes.txt`, `../sibling-folder/file.md`.
- `~` means "your home directory." `~/Documents` = `/home/patrick/Documents`.
- `.` means "right here." `..` means "one folder up."

## Pipes and redirection (the real power tool)

The thing that makes the terminal worth learning. The output of one command can feed into another.

### Pipe: `|`
"Take the output of the left side and use it as input on the right."

```
$ ls | grep ".txt"
notes.txt
todo.txt
```

`ls` lists everything; `grep` filters to lines containing `.txt`.

### Redirect to file: `>`
"Save output to this file."

```
$ ls > files.txt          # overwrite
$ ls >> files.txt         # append
```

### Read from file: `<`
"Use this file as input." Less common at the beginner stage, but you'll see it.

You'll combine these constantly:

```
$ cat server.log | grep "ERROR" | head -20
```

Read server.log, keep only lines with "ERROR," show the first 20. Replaces what would be a 30-line script in many languages.

## Environment variables

Variables that are available to every command. They control configuration without hardcoding.

```
$ echo $HOME
/home/patrick

$ echo $PATH
/usr/local/bin:/usr/bin:/bin
```

`$PATH` is special - it's the list of folders the shell searches when you type a command. When you type `git`, the shell looks in each `$PATH` folder for a program called `git`.

Setting your own:

```
$ export API_KEY=sk-abc123
$ echo $API_KEY
sk-abc123
```

That `export` only lasts in the current terminal. For permanent, you put it in `~/.bashrc` or `~/.zshrc`.

**Never put real API keys in commands you commit or share.** Use `.env` files (added to `.gitignore`) or a secrets manager.

## Tab completion (the killer feature)

Type the first few letters of a command or filename, hit `Tab`. The shell completes it.

```
$ cd Doc[Tab]
$ cd Documents/
```

If multiple matches, hit Tab twice to see them. Use this constantly. Typing full filenames is a sign you haven't learned the keyboard yet.

## Up arrow / history

Press `↑` to go back through commands you've run. `Ctrl+R` then type to search history. You'll re-run commands far more than you write new ones.

## Help

Two ways to ask "what does this command do?"

```
$ man ls           # manual page (press q to quit)
$ ls --help        # quick summary
```

`man` is denser, `--help` is faster. Use either.

## Mistakes you will make

| Mistake | What happens | Fix |
|---------|--------------|-----|
| Typo'd a command | "command not found" | Re-type it; use Tab next time |
| `rm` on the wrong thing | File gone, no recycle bin | Type slowly; consider `trash-cli` package |
| Hung command | Terminal frozen | `Ctrl+C` cancels; `Ctrl+Z` pauses |
| `Permission denied` | Trying to write somewhere only root owns | Use `sudo` (with care), or pick a different location |
| Stuck in a program (vim, less, man) | Doesn't respond to typing | `q` or `:q` usually exits; `Ctrl+C` if not |

## The thing nobody tells you

After 50 hours of using the terminal, it stops feeling weird. After 200 hours, you prefer it. There's no shortcut to that besides putting in the time.

## What to look at next

- **[Git basics](./git-basics.md)** - version control, the next universal tool
- **[CLI cheat sheets](../../resources/)** - AWS, Azure, GCP, kubectl, Terraform, Docker, GitHub CLI - all the cloud terminals
- **[The Missing Semester](https://missing.csail.mit.edu/)** - MIT's free crash course, longer and excellent
