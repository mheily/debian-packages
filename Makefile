OBJDIR = obj
REFSPEC = v2.6.2
SRC = libkqueue_2.6.2.orig.tar.xz
DOCKER = docker run --rm -v $(shell pwd)/$(OBJDIR):/build -it libkqueue-build

all: package

$(SRC):
	git clone --depth=1 https://github.com/mheily/libkqueue.git -b $(REFSPEC) 
	mkdir cmake-build-source
	cmake -S libkqueue -B cmake-build-source
	make -C cmake-build-source package_source
	mv cmake-build-source/*.xz $(SRC)

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
	$(DOCKER) /build/build.sh "$(SRC)"

upload:
	debsign $(OBJDIR)/*.changes
	dput -d mentors $(OBJDIR)/*.changes

debug:
	$(DOCKER) bash

clean:
	$(DOCKER) sh -x -c 'rm -rf /build/*'
	rm -rf $(OBJDIR) cmake-build-source libkqueue

.PHONY: $(OBJDIR) image package debug all upload
