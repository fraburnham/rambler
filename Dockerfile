FROM golang:1.20 AS builder
COPY . /go/src/github.com/elwinar/rambler
WORKDIR /go/src/github.com/elwinar/rambler
RUN go get ./... \
  && go build -ldflags="-s -linkmode external -extldflags -static -w"

FROM scratch
COPY --from=builder /go/src/github.com/elwinar/rambler/rambler /
CMD ["/rambler", "apply", "-a"]
