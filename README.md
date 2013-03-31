sockettp
========

A simple presistent HTTP implementation over sockets, for learning purposes

## Running

```bundle exec rake -D``` for more help on the commands

```bundle exec rake server``` runs the sockettp server. You can specify the dir with the files to be served via the $SOCKETTP_DIR env var
and the port on which the server will run by passing a $SOCKETTP_PORT var

```bundle exec rake client``` runs a REPL that takes every input and makes a request to the a sockettp server running on localhost
you can specify the server port by exporting an environmental variable $SOCKETTP_PORT.
