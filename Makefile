# Mr. Anderson's Magical Makefile!
# Check the README.md for usage instructions.

# ========= #
# Variables #
# ========= #

# Copy the contents of "Mercurial Repository URL" here!
REPO_URL = 

# Unique identifier for this assignment.
# Example: sorber-threads
ASSIGNMENT = 

# Names the archive file; usually given in your project spec.
# Example: project2.tgz
PROJECT_ARCHIVE =

# Command to use to make your PROJECT_ARCHIVE file. Make sure your command
# matches the archive you're trying to make!
# Default: tar -czf
ARCHIVE_COMMAND = tar -czf

# Names your local Mercurial repository folder.
# Default: handin
LOCAL_HANDIN = handin

# This stuff gets submitted to handin!
# Example: Makefile README *.c
HANDIN_FILES =

# These are settings for connecting to a lab machine.
# USER is your username, MACHINE is a lab machine (check the SoC motd for more
# of them), TEST_DIRECTORY is where all testing happens (it's created in your
# home directory), FILES are the files that will get copied to the lab when
# running `make remote`. Make sure FILES includes everything you'll need!
REMOTE_USER =
REMOTE_MACHINE = joey24
REMOTE_TEST_DIRECTORY = magic-project-tests
REMOTE_FILES = 

# ====================== #
# YOU CAN MESS WITH THIS #
# ====================== #

# Called with just "make". Make sure it works!
default: all

# ===================== #
# DON'T MESS WITH THESE #
# ===================== #

# Connects to a lab machine, copies the current directory over, and runs your
# remote tests.
remote:
	@echo ">> Connecting to a lab machine... <<"
	@ssh $(REMOTE_USER)@access.cs.clemson.edu "ssh $(REMOTE_USER)@$(REMOTE_MACHINE).cs.clemson.edu \"\
	  echo '>> Connected! Cleaning old code... << ';\
	  rm -rf $(REMOTE_TEST_DIRECTORY)/$(ASSIGNMENT);\
	\""
	@echo ">> Copying REMOTE_FILES to the lab... <<"
	@rsync --quiet $(REMOTE_FILES) $(REMOTE_USER)@access.cs.clemson.edu:~/$(REMOTE_TEST_DIRECTORY)/$(ASSIGNMENT)
	@echo ">> Executing \"make labtest\"... <<"
	@ssh $(REMOTE_USER)@access.cs.clemson.edu "ssh $(REMOTE_USER)@$(REMOTE_MACHINE).cs.clemson.edu \"\
	  cd $(REMOTE_TEST_DIRECTORY)/$(ASSIGNMENT) && make labtest\
	\""

# Connects to a lab machine and calls "make" on whatever you submitted last.
handout:
	@echo ">> Connecting to a lab machine... <<"
	@ssh $(REMOTE_USER)@access.cs.clemson.edu "ssh $(REMOTE_USER)@$(REMOTE_MACHINE).cs.clemson.edu \"\
	  echo '>> Connected! Cleaning old code... << ';\
	  rm -rf $(REMOTE_TEST_DIRECTORY)/$(ASSIGNMENT)-handin;\
	  echo '>> Cloning from handin... << ';\
	  hg -q clone $(REPO_URL) $(REMOTE_TEST_DIRECTORY)/$(ASSIGNMENT)-handin && \
	  echo '>> Unpacking and running \"make\"... <<';\
	  cd $(REMOTE_TEST_DIRECTORY)/$(ASSIGNMENT)-handin && tar -xzf $(PROJECT_ARCHIVE) && make\
	\""

# Packs project files into a .tgz, and pushes to the remote handin repo.
# Snazzy!
handin: $(HANDIN_FILES)
	@echo ">> Setting up repo, if necessary... (Failed? Update handin.sh!) <<"
	@test -d handin || hg clone $(REPO_URL) $(LOCAL_HANDIN)
	@echo ">> Archiving project files... <<"
	@$(ARCHIVE_COMMAND) $(LOCAL_HANDIN)/$(PROJECT_ARCHIVE) $^
	@echo ">> Submitting project to handin (ignore 'already tracked!' warning)... <<"
	@hg --quiet --cwd $(LOCAL_HANDIN) add $(PROJECT_ARCHIVE)
	@hg --quiet --cwd $(LOCAL_HANDIN) commit -m "Submitted new project version"
	@hg --quiet --cwd $(LOCAL_HANDIN) push
	@echo ">> Success! Use 'make handout' to test on a lab machine. <<"

# ============ #
# ADJUST THESE #
# ============ #
# You probably don't want to change the rules' names
# too much, but you can adjust their dependencies and what they do.

# Indicates that these special rules aren't for files (they're for doing cool things)
.PHONY: all test labtest remote handout handin \
	clean

# Cleans out old code
clean:

# Executing "make remote" will run this rule on a lab machine.
labtest:

# Run with just "make". Should compile things but run nothing.
all:

# Run with "make test". Best test everything!
test:

# =============================== #
# PUT YOUR CUSTOM MAKE RULES HERE #
# =============================== #
# Then you can reference them above.
