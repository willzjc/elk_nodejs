#!/usr/bin/env bash
GS_API='vuejs_api'
docker exec $GS_API "node" "server/load_data.js"
