targets="darwin/arm64,darwin/amd64,darwin/386,linux/arm64,linux/amd64,linux/386"
pkg="github.com/custompro98/rambler"
version=$(shell git describe --tags)
ldflags="-X main.VERSION=${version}"

default: build
all: build test

.PHONY: build
build: ## Build the binary for the local architecture
	go build --ldflags=${ldflags}

.PHONY: help
help: ## Get help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' ${MAKEFILE_LIST} | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

.PHONY: release
release: ## Build the release files
	xgo --dest release --targets=$(targets) --ldflags=$(ldflags) $(pkg)
	docker-compose run -w /src main sh -c 'apk add build-base && go build -o release/rambler-alpine-amd64 --ldflags=${ldflags}'

.PHONY: test
test: ## Test the project
	go test ./...

.PHONY: push
push: ## Push image to docker
	docker buildx build --push --platform linux/arm64,linux/amd64 -t custompro98/rambler:$(version) -t custompro98/rambler:latest .
