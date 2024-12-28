all: build

clean:
	@echo "purging old build"
	@rm -rf public/ resources/

build:	clean
	@hugo

upload:
	hugo deploy --maxDeletes 9999

server:
	@hugo server -w --disableFastRender
