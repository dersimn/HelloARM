FROM debian

COPY . /stuff

RUN cd /stuff && \
	cp echo.txt /echo.txt && \
	cd / && \
	rm -r /stuff

ENTRYPOINT [ "cat", "/echo.txt" ]
