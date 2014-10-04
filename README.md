# About #

Magic make is a Makefile and partner bash script that interacts with Clemson
University's web handin system for submitting Computer Science projects. Its
notable features are:

- A `make remote` rule that copies certain files to a lab machine and executes
  `make labtest` from the same Makefile on the lab machine.
- A `make handin` rule that packages your project files into an archive and 
  submits them to handin for you.
- A `make handout` rule that checks out the most recent submitted version of 
  your project and runs `make` on it _on a lab machine_.

You might like magic make if you regularl compose your programs on anything
other than a McAdams lab machine and don't want to deal with the hassle of
copying your files and testing manually.

# Usage Instructions #

## Handin.sh ## 
This script generates a handin repo SSH URL similar to the following:
ssh://handin@handin.cs.clemson.edu/1401/cpsc3600-001/assignments/DNSQ/ama2
...given appropriate settings. By default it's set up for Dr. Malloy's CPSC
4160 and Dr. Sorber's CPSC 3600.
 
To add a new class, go to web handin and copy the first and second URL
subdirectories (in the example above: `1401/cpsc3600-001`) into a new array
entry like the ones in lines 21 - 22.

1. Make sure Mercurial is installed on your machine. It's already there on the
   lab machines. On Debian/Ubuntu, use `sudo apt-get install mercurial`. The
   Mercurial executable is `hg`.

2. Make sure handin likes you. Follow the instructions at
   https://handin.cs.clemson.edu/help/students/cli/setup/ for both your
   development machine and the lab machines.

3. Configure handin.sh for your classes. Look at handin.sh for instructions.
   Make sure handin.sh is in this directory.

4. Adjust the settings below: HGPROFESSOR, HGASSIGNMENT, and PROJECT are
   probably the most important. You'll have to get HGASSIGNMENT from the
   current project on the web handin portal, e.g. for:
   ssh://handin@handin.cs.clemson.edu/1401/cpsc3600-001/assignments/DNSQ/ama2
   ...the HGASSIGNMENT would be "DNSQ".

5. You might need to make additional changes to archive format or included
   files. + Make sure SOURCES and HEADERS include the file patterns you want.
   SOURCES is configured for C by default. + Adjust the first line under
   `submit: ...` and the PROJECT variable's extension if your professor wants
   a non-.tgz archive type. + Adjust `submit`s dependencies to include all
   relevant files. All dependencies are added to the archive and submitted.

7. Run `make submit`. Debug. Victory!

8. Add more rules and variables for building / cleaning / testing.


