#!/bin/bash
set -e

echo 'Usage: make foo foo=12345'
echo $foo
printenv | sort | less
