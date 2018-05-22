all: env build

env:
	docker build -t android-libwebsockets-build .

build:
	mkdir -p out
	docker run --rm -v `pwd`/out:/home/dev/out android-libwebsockets-build