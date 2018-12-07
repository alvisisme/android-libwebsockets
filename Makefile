all: env build

env:
	docker-compose build

build:
	docker-compose run android-build-libwebsockets

dist:
	rm -rf dist/*
	cp -r build/include dist/include
	cp build/lib/libwebsockets.so dist/
	cp build/lib/libwebsockets.a dist/

.PHONY: env build dist