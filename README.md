[![Build Status](https://travis-ci.org/damicreabox/Git2Swift.svg)](https://travis-ci.org/damicreabox/Git2Swift.svg)

# Git2Swift

Swift library to manage GIT repository.
Implement Swift binding of native **libgit2** C library.

# About

At the moment, only some *libgit2* features are implemented. Merge requests are welcome.

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
 - Remotes
    - List
    - Get
    - Pull
    - Push
    - Autheticate
        - Password
        - SSH key
 - Revisions
    - Revision iterator
    - File revision iterator
    - Diff
        - Diff entry (partial)
    - Tree
        - Tree entry (partial)


# How to compile

> Tested on MacOs Sierra with XCode 8

*libgit2* must be installed in `/usr/local` directory.

# How to test credential

Create JSON file containing credential information like ```Tests/Sample.json```  
And set environnement variable ```AUTH_CONFIG_TEST_FILE``` with full path to JSON file.
