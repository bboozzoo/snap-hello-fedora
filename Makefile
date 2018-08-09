# This makefile just builds a simple C hello-world program, allows to install
# it and allows to build a snap out of it.
.PHONY: all
all:: hello-fedora

.PHONY: clean
clean::
	rm -f hello-fedora *.snap
	rm -rf prime/

.PHONY: install
install:: hello-fedora | $(DESTDIR)/usr/bin
	install --strip -m 0755 $< $|/$^

# Snapd requires a single file, /meta/snap.yaml to be present in every package.
# The file contains declarative description of the contents of the package.
install:: snap.yaml | $(DESTDIR)/meta
	install -m 0644 $< $|/$^

install:: LICENSE | $(DESTDIR)/usr/share/licenses/hello-fedora
	install -m 0644 $< $|/$^

.PHONY: snap
snap: hello-fedora_0.1_amd64.snap

$(addprefix $(DESTDIR),/usr/bin /meta /usr/share/licenses/hello-fedora):
	install -d $@

# This rule builds the application snap package from a tree of prepared files
# (like a mini-rootfs). The arguments -noappend, -comp, -no-xattrs and
# -no-fragments are important as they are verified by the store.
#
# The rule recursively calls make to install the program into the prime/
# directory.  The "prime" directory is can be also used to play with the snap
# without compressing and installing it using the "snap try" command.
.ONESHELL: snap
hello-fedora_0.1_amd64.snap: hello-fedora.c snap.yaml
	$(MAKE) install DESTDIR=prime/
	mksquashfs ./prime $@ -noappend -comp xz -no-xattrs -no-fragments -all-root
