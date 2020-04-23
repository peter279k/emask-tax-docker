#!/bin/bash

no_cache=$1

if [[ ${no_cache} != '--no-cache' ]] && [[ ${no_cache} != '' ]]; then
    echo 'Sorry. This first argument only allows empty or "--no-cache" string...'
    echo 'Stopped it.'
    exit 1;
fi;

docker build -t emask-tax-docker . ${no_cache}
