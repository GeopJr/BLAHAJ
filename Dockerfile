FROM --platform=linux/amd64 crystallang/crystal:latest-alpine as builder

RUN apk add --no-cache \
  git \
  make
WORKDIR /root/src
COPY . . 
RUN make static_mt


FROM scratch
COPY --from=builder  /root/src/bin/blahaj /usr/local/bin/blahaj
ENTRYPOINT [ "blahaj" ]
