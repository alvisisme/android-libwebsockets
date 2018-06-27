all: env build

env:
	docker build -t android-libwebsockets-build .

build:
	docker run --rm -v `pwd`/out:/home/out android-libwebsockets-build