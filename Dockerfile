ARG INSTALLTO=/usr/local

FROM debian:bullseye as builder

ARG INSTALLTO

RUN apt update && \
    apt upgrade -y && \
    apt install -y wget curl && \
    cd /tmp && wget https://go.dev/dl/go1.20.5.linux-amd64.tar.gz && \
    tar -C ${INSTALLTO} -xzf go*linux-amd64.tar.gz

ENV GOPATH=${INSTALLTO}/go
ENV PATH=${GOPATH}/bin:${PATH}

RUN go install github.com/gohugoio/hugo@latest

FROM alpine:3.14

ARG INSTALLTO

COPY --from=builder ${INSTALLTO}/go/bin/hugo /usr/bin/hugo

CMD ["hugo", "version"]