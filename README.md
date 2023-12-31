# Autograder
A bash cli utility that runs tests from a folder on an executable and compares the program output to precomputed output files.

Autograder is designed for quick input output testing of executables.

## Instalation
Download the script.
1. We begin by making the script an executable. </br>
  `chmod +x autograder.sh`
2. We then move it into our local program directory. </br>
  `mv autograder.sh /usr/local/bin/autograder`

Or we can use the installer: `sudo sh install.sh`.

## Usage
Files specifying input and output must have matching names per input/output pair. Furthermore input files must end with `.in` and output files with `.out`. </br>
The command can be ran with: `autograder`
### Flags
  - `-t` specifies timeout value in seconds.                   (default `1`)
  - `-p` specifies the name of the program.                    (default `a.out`)
  - `-d` specifies the directory where the tests are located.  (default `tests`)
  - `-v` verbose information about failed tests.               (default `false`)
  - `-i` shows the input for failed tests.                     (default `false`)
  - `-e` specifies the command used to run the executable.     (default depends on file type)
  - `-f` force tests to run even if they have no defined output. (default `false`)
  - `-a` argument mode, feeds input through file name as an argument instead of stdin. (default `false`)
  - `-s` specify a specific test.

Supported files without -e are: any c binary (`.out`) and `.py`.

### Example
Given the following folder structure.
```
.
├── myProgram
└── programTests
    ├── 10.in
    ├── 10.out
    ├── 1.in
    ├── 1.out
    ├── 2.in
    ├── 2.out
    ├── 3.in
    ├── 3.out
    ├── 4.in
    ├── 4.out
    ├── 5.in
    ├── 5.out
    ├── 6.in
    ├── 6.out
    ├── 7.in
    ├── 7.out
    ├── 8.in
    ├── 8.out
    ├── 9.in
    └── 9.out
```
We can run autograder with the following command `autograder -p myProgram -d programTests`
Which will produce the following output:
```
INCORRECT OUTPUT : tests/10
PASSED : tests/1
PASSED : tests/2
PASSED : tests/3
PASSED : tests/4
PASSED : tests/5
PASSED : tests/6
PASSED : tests/7
TIMEOUT : tests/8
INCORRECT OUTPUT : tests/9
```
