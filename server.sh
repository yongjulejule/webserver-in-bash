#!/usr/bin/env bash

### Create the response FIFO
rm -f response
mkfifo response

function handleRequest() {
    # 1) Process the request
    # 2) Route request to the correct handler
    # 3) Build a response based on the request
    # 4) Send the response to the named pipe (FIFO)

	while read line; do
		echo $line
		trline=`echo $line | tr -d '[\r\n]'`


		[ -z "$trline" ] && break

		HEADLINE_REGEX='(.)(.).HTTP.*'
		
		[[ $trline =~ $HEADLINE_REGEX ]] &&
			REQUEST=$(echo $trline | sed -E "s/$HEADLINE_REGEX/\1\2/")
	done

	case $REQUEST in
		"GET /index.html") RESPONSE="HTTP/1.1 200 OK\nContent-Type: text/html\n\n<html><body><h1>Hello World</h1></body></html>" 
			;;
		"GET /login") RESPONSE=$(cat login.html)
			;;
		*) RESPONSE=$(cat 404.html)
			;;
	esac

	echo -e $RESPONSE > response
}

echo 'Listening on 3000...'

while true; do
cat response | nc -l 3000  | handleRequest
done

