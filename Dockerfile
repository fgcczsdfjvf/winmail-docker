FROM lixg/winmail:latest

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
