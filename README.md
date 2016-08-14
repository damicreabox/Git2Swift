# Git2Swift
Swift binding for **libgit2** library

# About

At the moment, only some *libgit2* features are implemented. Merge requests are welcome.

In version *0.1*, only the local actions are implemented.

Available features:
- RepositoryManager
  - Open
  - Init (bare)
- Repository
  - Branches
    - Get
    - Create
    - Remove
    - List
  - Tags
    - Get
    - Create
    - Remove
    - List
 - Index
    - Add
    - Remove
    - Save
    - Load
    - Clear
 - Head
    - Analysis merge
    - Merge
    - Checkout (branch, tag, tree)
    - Reset (soft, hard)
 - Statues
    - WorkingDirectoryClean
    - List all
 - Tree (only concept)

# How to compile

> Tested on MacOs Sierra with XCode 8 beta 4

*libgit2* must be installed in `/usr/local` directory.
