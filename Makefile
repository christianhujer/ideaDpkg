user.name:=$(shell git config user.name)
user.email:=$(shell git config user.email)

## The directory in which to install the symbolic links to the IntelliJ IDEA shell scripts.
# Must end with /.
BINDIR:=/usr/local/bin/

## The directory in which to install IntelliJ IDEA.
# Must end with /.
PREFIX:=/opt/local/


ifeq (,$(filter help,$(MAKECMDGOALS)))
IDEA_DEFAULT_VERSION?=$(error Need IDEA_VERSION:=version, i.e. IDEA_VERSION:=ideaIC-140.2110.5. I can guess the version from an idea*.tar.gz file if there one in this directory.)
else
IDEA_DEFAULT_VERSION:=Unable to determine version.
endif

## The version of IntelliJ IDEA to be installed.
# If there is an idea*.tar.gz file in the current directory, the version will be derived from that.
# If there are multiple idea*.tar.gz files, the newest (according to version) will be used.
IDEA_VERSION?=$(or $(patsubst %.tar.gz,%,$(lastword $(sort $(wildcard idea*.tar.gz)))),$(IDEA_DEFAULT_VERSION))

IDEA_TAR_GZ:=$(patsubst idea-IC%,ideaIC%,$(IDEA_VERSION)).tar.gz
IDEA_DIR:=$(patsubst ideaIC%,idea-IC%,$(IDEA_VERSION))
PURE_VERSION:=$(patsubst ideaIC-%,%,$(patsubst idea-IC-%,%,$(IDEA_VERSION)))

## Creates the .deb package.
all: dist/intellij-idea.deb

$(IDEA_TAR_GZ):
	echo $@
	ls $@
	echo wget https://download.jetbrains.com/idea/$(IDEA_VERSION).tar.gz

.PHONY: install
## Installs IntelliJ IDEA on your system.
install: $(IDEA_TAR_GZ)
	install -d $(PREFIX) $(BINDIR)
	tar xzf $(IDEA_TAR_GZ) -C $(PREFIX)
	ln -s $(PREFIX)$(IDEA_DIR)/bin/*.sh $(BINDIR)/

.PHONY: uninstall
## Removes IntelliJ IDEA from your system.
uninstall:
	$(RM) -r $(patsubst $(PREFIX)$(IDEA_DIR)/bin/%,$(BINDIR)%,$(wildcard $(PREFIX)$(IDEA_DIR)/bin/*.sh)) $(PREFIX)$(IDEA_DIR)

.PHONY: clean
## Removes all files that are generated by this Makefile.
clean:
	$(RM) -r dist control data.tar.gz control.tar.gz debian-binary

control:
	echo "Package: intellij-idea\nVersion: $(PURE_VERSION)\nSection: user/hidden\nPriority: optional\nArchitecture: all\nInstalled-Size: `du -cks $(PREFIX)$(IDEA_DIR) | tail -n 1 | cut -f 1`\nMaintainer: $(user.name) <$(user.email)>\nDescription: JetBrains IntelliJ IDEA Java Integrated Development Environment (IDE)." >$@

control.tar.gz: control
	tar czf $@ $^

data.tar.gz:
	tar czPf $@ $(PREFIX)$(IDEA_DIR) $(patsubst $(PREFIX)$(IDEA_DIR)/bin/%,$(BINDIR)%,$(wildcard $(PREFIX)$(IDEA_DIR)/bin/*.sh))

debian-binary:
	echo 2.0 >$@

dist/intellij-idea.deb: debian-binary control.tar.gz data.tar.gz
	mkdir -p $(dir $@)
	ar -Drc $@ $^

# Get makehelp from https://github.com/christianhujer/makehelp
-include makehelp/Help.mak
