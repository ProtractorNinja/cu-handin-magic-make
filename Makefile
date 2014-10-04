# Mr. Anderson's Web Handin-friendly Makefile template!
# Clemson University
# ama2@clemson.edu
# https://gist.github.com/ProtractorNinja/9e72377b349a19ec6ed7
# 
# USAGE INSTRUCTIONS
# 1. Make sure Mercurial is installed on your machine.
#    It's already there on the lab machines.
#    On Debian/Ubuntu, use `sudo apt-get install mercurial`.
#    The Mercurial executable is `hg`.
# 2. Make sure handin likes you. Follow the instructions at
#    https://handin.cs.clemson.edu/help/students/cli/setup/
#    for both your development machine and the lab machines.
# 3. Configure handin.sh for your classes. Look at handin.sh 
#    for instructions. Make sure handin.sh is in this directory.
# 4. Adjust the settings below: HGPROFESSOR, HGASSIGNMENT, and PROJECT
#    are probably the most important. You'll have to get HGASSIGNMENT 
#    from the current project on the web handin portal, e.g. for:
#    ssh://handin@handin.cs.clemson.edu/1401/cpsc3600-001/assignments/DNSQ/ama2
#    ...the HGASSIGNMENT would be "DNSQ".
# 5. You might need to make additional changes to archive format or 
#    included files.
#    + Make sure SOURCES and HEADERS include the file patterns you want.
#      SOURCES is configured for C by default.
#    + Adjust the first line under `submit: ...` and the PROJECT 
#      variable's extension if your professor wants a non-.tgz 
#      archive type.
#    + Adjust `submit`s dependencies to include all relevant files.
#      All dependencies are added to the archive and submitted.
# 7. Run `make submit`. Debug. Victory!
# 8. Add more rules and variables for building / cleaning / testing.

# ========= #
# Variables #
# ========= #

# handin.sh parameters
HGPROFESSOR = sorber
HGASSIGNMENT = project1a

# Names the archive file; usually given in your project spec.
PROJECT = project1.tgz

# Command to use to make your PROJECT file. Make sure your command
# matches the archive you're trying to make!
ARCHIVER = tar -czf

# Names your local Mercurial repository folder.
HGLOCAL = handin

# Autoglobically itemize important files
# This stuff gets submitted!
INFO = Makefile README handin.sh
SOURCES := memory_shim.c leakcount.c sctracer.c
HEADERS := $(wildcard *.h)

# C Stuff
CC = gcc
CFLAGS = -g -Wall

# Remote test stuff
USER=ama2
MACHINE=joey24
TESTDIR=test
REMOTEFILES=*.c Makefile
#
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
	@echo ">> Copying directory to the lab... <<"
	@rsync --quiet $(REMOTEFILES) $(USER)@access.cs.clemson.edu:~/$(TESTDIR)/$(HGASSIGNMENT)
	@echo ">> Executing \"make labtest\"... <<"
	@ssh $(USER)@access.cs.clemson.edu "ssh $(USER)@$(MACHINE).cs.clemson.edu \"\
	  cd $(TESTDIR)/$(HGASSIGNMENT) && make labtest\
	\""

# Connects to a lab machine and calls "make" on whatever you submitted last.
handout:
	@echo ">> Connecting to a lab machine... <<"
	@ssh $(USER)@access.cs.clemson.edu "ssh $(USER)@$(MACHINE).cs.clemson.edu \"\
	  echo '>> Connected! Cleaning old code... << ';\
	  rm -rf $(TESTDIR)/$(HGASSIGNMENT)-handin;\
	  echo '>> Cloning from handin... << ';\
	  hg -q clone $(shell ./handin.sh $(USER) $(HGPROFESSOR) $(HGASSIGNMENT)) $(TESTDIR)/$(HGASSIGNMENT)-handin && \
	  echo '>> Unpacking and running \"make\"... <<';\
	  cd $(TESTDIR)/$(HGASSIGNMENT)-handin && tar -xzf $(PROJECT) && make\
	\""

# Packs project files into a .tgz, and pushes to the remote handin repo.
# Snazzy!
handin: $(INFO) $(SOURCES) $(HEADERS)
	@echo ">> Setting up repo, if necessary... (Failed? Update handin.sh!) <<"
	@test -d handin || hg clone $$(./handin.sh $(USER) $(HGPROFESSOR) $(HGASSIGNMENT)) $(HGLOCAL)
	@echo ">> Archiving project files... <<"
	@$(ARCHIVER) $(HGLOCAL)/$(PROJECT) $^
	@echo ">> Submitting project to handin (ignore 'already tracked!' warning)... <<"
	@hg --quiet --cwd $(HGLOCAL) add $(PROJECT)
	@hg --quiet --cwd $(HGLOCAL) commit -m "Submitted new project version"
	@hg --quiet --cwd $(HGLOCAL) push
	@echo ">> Success! Use 'make handout' to test on a lab machine. <<"

# ============ #
# ADJUST THESE #
# ============ #
# You probably don't want to change the rules' names
# too much, but you can adjust their dependencies and what they do.

# Indicates that these special rules aren't for files (they're for doing cool things)
.PHONY: clean labtest build remote handout handin \
	test_trace test_shim

# Cleans out old code
clean: 

# Executing "make remote" will run this rule on a lab machine.
labtest: test_shim test_trace

# Run with just "make". Should compile things but run nothing.
all: memory_shim.so leakcount sctracer

# Run with "make test". Best test everything!
test: test_shim test_trace

# =============================== #
# PUT YOUR CUSTOM MAKE RULES HERE #
# =============================== #
# Then you can reference them above.

memory_shim.so: memory_shim.c
	$(CC) $(CFLAGS) -fPIC -shared -o $@ $^ -ldl -lm

%: %.c
	$(CC) $(CFLAGS) -o $@ $^

test_trace: sctracer sorber_test_trace_one
	./sctracer "./sorber_test_trace_one" sctrace.out
	cat sctrace.out

test_shim: memory_shim.so leakcount sorber_test_one
	./leakcount ./sorber_test_one
