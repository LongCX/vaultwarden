FROM vaultwarden/server:testing-alpine AS src

FROM gcr.io/distroless/cc-debian12:nonroot

COPY --chown=nonroot:nonroot --from=src /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY --chown=nonroot:nonroot --from=src /vaultwarden /vaultwarden

COPY --chown=nonroot:nonroot --from=src /web-vault /web-vault

VOLUME ["/data"]
USER nonroot

ENV TZ=Asia/Ho_Chi_Minh
ENV ROCKET_PROFILE="release" \
    ROCKET_ADDRESS=0.0.0.0 \
    SSL_CERT_DIR=/etc/ssl/certs 

ENTRYPOINT ["/vaultwarden"]