# webserver-in-bash

just for fun π

## nc command

`nc -Ul [socket name]`

listen unix socket

`echo HI | nc -U [socket name]`

[socket name] μ μμΌμ λ΄μ©μ λ³΄λ.

stdinμ λ°μμ μμΌμΌλ‘ λ³΄λ΄λ κ΅¬μ‘°.

`netstat -f unix` or `netstat -u` μ»€λ©λλ‘ unix domain socket μνλ₯Ό νμΈν  μ μλ€.

`echo -e 'HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\n<h1 style="color: blue;">Hello!</h1>' | nc -lvk 3000`

=> stdinμΌλ‘ λ€μ΄μ€λ λ©μμ§λ₯Ό ν΄λΌμ΄μΈνΈμ λμμ€

`mkfifo` μ»€λ©λλ‘ λͺλͺλ νμ΄νλ₯Ό λ§λ€ μ μμ;

`bash` μμ `=~` μ°μ°μλ‘ μ κ·μμ μ΄μ©ν `true/false` νκ° κ°λ₯

# Reference

https://dev.to/leandronsp/building-a-web-server-in-bash-part-i-sockets-2n8b
