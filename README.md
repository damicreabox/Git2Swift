# Git2Swift
Swift binding for **libgit2** library

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


# How to compile

> Tested on MacOs Sierra with XCode 8 GM

*libgit2* must be installed in `/usr/local` directory.

# How to test credential

- create public and private key on a server and set it to use key for ssh authentication
- create JSON file containing credential information like ```Tests/Sample.json```  (username, password and keys files)
- set environnement variable ```AUTH_CONFIG_TEST_FILE``` with full path to JSON file.
