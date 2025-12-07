FROM vaultwarden/server:testing-alpine AS src

FROM alpine:latest AS tz
RUN apk add --no-cache tzdata

FROM scratch
COPY --chown=65532:65532 --from=src /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --chown=65532:65532 --from=src /vaultwarden /vaultwarden
COPY --chown=65532:65532 --from=src /web-vault /web-vault
COPY --chown=65532:65532 --from=tz /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime

VOLUME ["/data"]

ENV ROCKET_PROFILE="release" \
    ROCKET_ADDRESS=0.0.0.0 \
    SSL_CERT_DIR=/etc/ssl/certs 

USER 65532:65532

ENTRYPOINT ["/vaultwarden"]
