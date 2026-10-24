# Built from the repo root (see fly/deploy.sh): vendor/botboard is the app source (git submodule).
FROM golang:1 AS build
ENV GOTOOLCHAIN=auto CGO_ENABLED=0
WORKDIR /src
COPY vendor/botboard/go.mod vendor/botboard/go.sum ./
RUN go mod download
COPY vendor/botboard/ ./
RUN go build -trimpath -ldflags="-s -w" -o /botboard .

FROM alpine:3
RUN apk add --no-cache ca-certificates
COPY --from=build /botboard /usr/local/bin/botboard
# Userspace networking (tsnet): no tailscaled, no TUN device, nothing listens on a public port.
# Control server comes from TS_CONTROL_URL, the join key from the TS_AUTHKEY secret (see fly.toml).
ENTRYPOINT ["botboard", "-hostname", "botboard", "-state-dir", "/data/tsnet"]
