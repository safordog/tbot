FROM quay.io/projectquay/golang:1.20 as builder
ARG TARGETOS=linux
ARG TARGETARCH=arm64

WORKDIR /go/src/app
COPY . .
RUN make $TARGETOS TARGETARCH=$TARGETARCH

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/tbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./tbot"]