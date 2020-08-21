#!/bin/bash
set -e

set -a
. $(pwd)/environments/acme.sh.env
. $(pwd)/environments/app.env
. $(pwd)/environments/app.secret.env
. $(pwd)/environments/docker.env
. $(pwd)/environments/nginx.env
. $(pwd)/environments/postgres.env
. $(pwd)/environments/foo.env
set +a

#printenv | sort | less
