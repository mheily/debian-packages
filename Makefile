all: image package

image:
	docker build -t libkqueue-build .

test-package: image
	docker run --rm -it libkqueue-build dh build --no-act
	#docker run --rm -it libkqueue-build dpkg-buildpackage -uc -us

package: image
	docker run --rm -it libkqueue-build dpkg-buildpackage -uc

debug:
	docker run --rm -it libkqueue-build bash

.PHONY: image package debug all
