#!/bin/sh

cat webber.m \
    | gcc -framework Cocoa -framework WebKit -x objective-c -o myweb - \
    && ./myweb
