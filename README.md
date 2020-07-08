# Bash tools

Janel's collection of bash tools

## find_repos
Lists all repos in a directory with the repo name and root path.

```
find_repos [-d DIRECTORY] [-s SEARCH_STRING] [-o OUTPUT_FILE] [-v]

Creates a list of repository name and directory name for each repository found in the specified DIRECTORY (or the current working directory by default). Can limit results with SEARCH_STRING.

-d DIRECTORY
   Find repos in the specified DIRECTORY. Only looks at directories directly in DIRECTORY.

-s SEARCH_STRING
   Look for SEARCH_STRING in repository names and directory names and only include matches.

-o OUTPUT_FILE
   Use OUTPUT_FILE to store list of repositories. Default is /tmp/repos.out.PID

-v
   Verbose output. Print output to standard out as well as to the output file.
```