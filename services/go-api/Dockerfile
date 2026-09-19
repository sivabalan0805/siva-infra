FROM golang:1.22 AS build
WORKDIR /src
COPY go.mod main.go .
RUN CGO_ENABLED=0 go build -o /go-api main.go

FROM gcr.io/distroless/static-debian12
COPY --from=build /go-api /go-api
EXPOSE 8081
ENTRYPOINT ["/go-api"]