FROM golang:1.10-alpine as builder

RUN apk add --no-cache git \
    && go get -u github.com/Masterminds/glide \
    && git clone https://github.com/btcsuite/btcd $GOPATH/src/github.com/btcsuite/btcd \
    && cd $GOPATH/src/github.com/btcsuite/btcd \
    && glide install \
    && go install . ./cmd/...

FROM alpine:latest

WORKDIR /root/

COPY --from=builder /go/bin/* ./

# p2p and rpc
EXPOSE 8333 8334

# testnet p2p and rpc
EXPOSE 18333 18334

VOLUME [ "/root/.btcd/data" ]

ENTRYPOINT ["/root/btcd"]