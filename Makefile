APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=safordog
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux#linux darwin windows
TARGETARCH=arm64#amd64
IMAGE_TAG=test

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o tbot -ldflags "-X="github.com/safordog/tbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

linux: format get
	CGO_ENABLED=0 GOOS=linux GOARCH=$(TARGETARCH) go build -v -o tbot -ldflags "-X="github.com/safordog/tbot/cmd.appVersion=${VERSION}

windows: format get
	CGO_ENABLED=0 GOOS=windows GOARCH=$(TARGETARCH) go build -v -o tbot -ldflags "-X="github.com/safordog/tbot/cmd.appVersion=${VERSION}

macOS: format get
	CGO_ENABLED=0 GOOS=darwin GOARCH=$(TARGETARCH) go build -v -o tbot -ldflags "-X="github.com/safordog/tbot/cmd.appVersion=${VERSION}

clean:
	rm -rf tbot
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}