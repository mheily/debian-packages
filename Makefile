OBJDIR = obj
SRC = libkqueue_2.3.1.orig.tar.gz
DOCKER = docker run --rm -v $(shell pwd)/$(OBJDIR):/build -it libkqueue-build

all: package

$(OBJDIR): $(SRC)
	mkdir -p $@
	cp $(SRC) $@

image:
	docker build -t libkqueue-build .

test-package: image
	docker run --rm -it libkqueue-build dh build --no-act
	#docker run --rm -it libkqueue-build dpkg-buildpackage -uc -us

package: image $(OBJDIR)
	install -m 755 build.sh $(OBJDIR)
	rsync -av --delete ./debian/ $(OBJDIR)/debian/
	$(DOCKER) /build/build.sh

upload:
	debsign $(OBJDIR)/*.changes
	dput -d mentors-ftp $(OBJDIR)/*.changes

debug:
	$(DOCKER) bash

clean:
	$(DOCKER) sh -x -c 'rm -rf /build/*'
	rm -rf $(OBJDIR)

.PHONY: $(OBJDIR) image package debug all upload
