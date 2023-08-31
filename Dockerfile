FROM golang:1.20 AS builder
COPY . /go/src/github.com/custompro98/rambler
WORKDIR /go/src/github.com/custompro98/rambler
RUN go get ./... \
  && go build -ldflags="-s -linkmode external -extldflags -static -w"

FROM scratch
COPY --from=builder /go/src/github.com/custompro98/rambler/rambler /
CMD ["/rambler", "apply", "-a"]
