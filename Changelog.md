# Version 0.3

Add revision log and associated dependencies

- Revision iterator
- File revision iterator
- Diff
  - Diff entry (partial)
- Tree
  - Tree entry (partial)

# Version 0.2

Add remotes actions

- Remotes
  - List
  - Get
  - Pull
  - Push
  - Autheticate
    - Password
    - SSH key

# Version 0.1

Only the local actions are implemented.

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
