FROM vaultwarden/server:testing-alpine AS src

FROM alpine:latest AS tz
RUN apk add --no-cache tzdata

# Health
FROM 11notes/distroless:localhealth AS distroless-localhealth

FROM scratch
COPY --chown=65532:65532 --from=src /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --chown=65532:65532 --from=src /vaultwarden /vaultwarden
COPY --chown=65532:65532 --from=src /web-vault /web-vault
COPY --chown=65532:65532 --from=tz /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime
COPY --chown=65532:65532 --from=distroless-localhealth / /

VOLUME ["/data"]

ENV ROCKET_PROFILE="release" \
    ROCKET_ADDRESS=0.0.0.0 \
    SSL_CERT_DIR=/etc/ssl/certs

EXPOSE 8080

HEALTHCHECK --interval=15s --timeout=2s --start-period=5s \
  CMD ["/usr/local/bin/localhealth", "http://127.0.0.1:8080/alive"]

USER 65532:65532

ENTRYPOINT ["/vaultwarden"]
