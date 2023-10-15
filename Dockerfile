FROM --platform=linux/amd64 crystallang/crystal:latest-alpine as builder

WORKDIR /root/src
COPY . . 
RUN shards build --production --no-debug --release -Dpreview_mt --static


FROM scratch
COPY --from=builder  /root/src/bin/blahaj /usr/local/bin/blahaj
ENTRYPOINT [ "blahaj" ]
