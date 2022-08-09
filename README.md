# webserver-in-bash

just for fun 😉

## nc command

`nc -Ul [socket name]`

listen unix socket

`echo HI | nc -U [socket name]`

[socket name] 의 소켓에 내용을 보냄.

stdin을 받아서 소켓으로 보내는 구조.

`netstat -f unix` or `netstat -u` 커멘드로 unix domain socket 상태를 확인할 수 있다.

`echo -e 'HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\n<h1 style="color: blue;">Hello!</h1>' | nc -lvk 3000`

=> stdin으로 들어오는 메시지를 클라이언트에 띄워줌

`mkfifo` 커멘드로 명명된 파이프를 만들 수 있음;

`bash` 에서 `=~` 연산자로 정규식을 이용한 `true/false` 평가 가능

# Reference

https://dev.to/leandronsp/building-a-web-server-in-bash-part-i-sockets-2n8b
