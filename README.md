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

1. Make sure Mercurial is installed on your machine. It's already there on the
   lab machines. On Debian/Ubuntu, use `sudo apt-get install mercurial`. The
   Mercurial executable is `hg`.

2. Make sure handin likes you. Follow the instructions at
   `https://handin.cs.clemson.edu/help/students/cli/setup/` for both your
   development machine and the lab machines.

3. Grab the Makefile. You can either `git clone` on this repository
   (`git@github.com:ProtractorNinja/cu-handin-magic-make.git <new directory
   name>`) or just download the Makefile straight from here.

4. For each project, you'll need to adjust the Makefile a little. Go to the web
   Handin page for your project, and copy the contents of the textbox labeled
   "Mercurial Repository URL" into the `REPO_URL` variable. Update the rest of
   the variables as needed (especially the empty ones!).

5. Run `make handin`. Check to see that your archive is up in web handin.

6. Try out `make remote` and `make handout`. They should complete with an instruction to update the `labtest` and `all` rules.

7. You're done. Good luck on that project!

