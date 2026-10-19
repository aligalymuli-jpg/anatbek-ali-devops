FROM alpine:3.20
WORKDIR /app
COPY app/app.sh /app/app.sh
RUN chmod +x /app/app.sh
EXPOSE 8080
CMD ["/app/app.sh"]
