FROM golang:1.22-bookworm as build

WORKDIR /go/src/app
COPY . .

RUN go mod download
RUN go vet .
RUN CGO_ENABLED=0 go build -o /go/bin/app .

FROM gcr.io/distroless/static-debian11

COPY --from=build /go/bin/app /
VOLUME [ "/books" ]

EXPOSE 8080
ENTRYPOINT ["/app"]
CMD ["-port", "8080", "-dir", "/books", "-hide-dot-files"]