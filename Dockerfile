FROM golang:1.15.6 AS builder

WORKDIR /go/src/github.com/alibaba/open-local
COPY . .
RUN make build && chmod +x bin/open-local

FROM alpine:3.9
LABEL maintainers="Alibaba Cloud Authors"
LABEL description="open-local is a local disk management system"
RUN apk update && apk upgrade && apk add util-linux coreutils e2fsprogs e2fsprogs-extra xfsprogs xfsprogs-extra blkid file open-iscsi jq
COPY --from=builder /go/src/github.com/alibaba/open-local/bin/open-local /bin/open-local
COPY --from=thebeatles1994/open-local:tools /usr/local/bin/restic-amd64 /usr/local/bin/restic
ENTRYPOINT ["open-local"]