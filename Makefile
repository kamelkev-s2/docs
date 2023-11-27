all: build

clean:
	@echo "purging old build"
	@rm -rf public/ resources/

build:	clean
	@hugo

server:
	@hugo server -w --disableFastRender
