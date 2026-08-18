FROM alpine:latest
RUN apk add --no-cache curl unzip && \
    curl -L -H "Cache-Control: no-cache" -o /tmp/xray.zip https://github.com && \
    unzip /tmp/xray.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/xray && \
    rm -rf /tmp/*
RUN mkdir -p /etc/xray && echo '{\
  "inbounds": [{ \
    "port": 10000, \
    "protocol": "vless", \
    "settings": { \
      "clients": [{"id": "f81d4fae-7dec-11d0-a765-00a0c91e6bf6"}], \
      "decryption": "none" \
    }, \
    "streamSettings": { \
      "network": "ws", \
      "wsSettings": {"path": "/mysecretvpn"} \
    } \
  }], \
  "outbounds": [{"protocol": "freedom"}] \
}' > /etc/xray/config.json
EXPOSE 10000
CMD ["/usr/local/bin/xray", "run", "-c", "/etc/xray/config.json"]
