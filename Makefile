user.name:=$(shell git config user.name)
user.email:=$(shell git config user.email)

BINDIR:=/usr/local/bin/
PREFIX:=/opt/local/

IDEA_VERSION?=$(or $(patsubst %.tar.gz,%,$(lastword $(wildcard idea*.tar.gz))),$(error Need IDEA_VERSION:=version, i.e. IDEA_VERSION:=ideaIC-140.2110.5))
IDEA_TAR_GZ:=$(patsubst idea-IC%,ideaIC%,$(IDEA_VERSION)).tar.gz
IDEA_DIR:=$(patsubst ideaIC%,idea-IC%,$(IDEA_VERSION))
PURE_VERSION:=$(patsubst ideaIC-%,%,$(patsubst idea-IC-%,%,$(IDEA_VERSION)))

all: dist/intellij-idea.deb

debug:
	echo $(IDEA_VERSION)
	echo $(IDEA_TAR_GZ)
	echo $(IDEA_DIR)

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

-include makehelp/Help.mak
