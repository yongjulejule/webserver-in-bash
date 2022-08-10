#!/usr/bin/env bash

### Create the response FIFO
rm -f response
mkfifo response

function handleHomeGet() {
	RESPONSE=$(cat index.html | \
		sed "s/{{$COOKIE_NAME}}/$COOKIE_VALUE/")
}

function handleLoginGet() {
	RESPONSE=$(cat login.html)
}

function handleLogoutPost(){
	 RESPONSE=$(cat post-logout.http | \
    sed "s/{{cookie_name}}/$COOKIE_NAME/" | \
    sed "s/{{cookie_value}}/$COOKIE_VALUE/")

	 echo "logout response : $RESPONSE"
}

function handleLoginPost() {
	RESPONSE=$(cat post-login.http | \
		sed "s/{{cookie_name}}/$INPUT_NAME/" | \
		sed "s/{{cookie_value}}/$INPUT_VALUE/")
}

function handleNotFound() {
	RESPONSE=$(cat 404.html)
}

function handleRequest() {
	while read line; do
		echo $line
		trline=`echo $line | tr -d '[\r\n]'`


		[ -z "$trline" ] && break

		HEADLINE_REGEX='(.)(.).HTTP.*'
		[[ $trline =~ $HEADLINE_REGEX ]] &&
			REQUEST=$(echo $trline | sed -E "s/$HEADLINE_REGEX/\1\2/")

		CONTENT_LENGTH_REGEX='Content-Length:.(.*)'
		[[ "$trline" =~ $CONTENT_LENGTH_REGEX ]] &&
      CONTENT_LENGTH=`echo $trline | sed -E "s/$CONTENT_LENGTH_REGEX/\1/"`

		COOKIE_REGEX='Cookie:(.*)\=(.*).*'
    [[ "$trline" =~ $COOKIE_REGEX ]] &&
      read COOKIE_NAME COOKIE_VALUE <<< $(echo $trline | sed -E "s/$COOKIE_REGEX/\1 \2/")
	done

	echo "content length: $CONTENT_LENGTH"
	echo "RES Cookie: $COOKIE_NAME=$COOKIE_VALUE"

	## Check if Content-Length is not empty
	if [ ! -z "$CONTENT_LENGTH" ]; then
		BODY_REGEX='(.*)=(.*)'

		## Read the remaining request body
		while read -n$CONTENT_LENGTH -t1 body; do
			echo $body

			INPUT_NAME=$(echo $body | sed -E "s/$BODY_REGEX/\1/")
			INPUT_VALUE=$(echo $body | sed -E "s/$BODY_REGEX/\2/")
		done
	fi

	case $REQUEST in
		"GET /") handleHomeGet ;;
		"GET /index.html") handleIndexGet ;;
		"GET /login") handleLoginGet ;;
		"POST /login") handleLoginPost ;;
		"POST /logout") handleLogoutPost ;;
		*) handleNotFound ;;
	esac

	echo -e $RESPONSE > response
}

echo 'Listening on 3000...'

while true; do
cat response | nc -l 3000  | handleRequest
done

