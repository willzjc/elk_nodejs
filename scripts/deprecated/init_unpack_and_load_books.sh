#!/bin/bash

# Unzips books and then attempts to load into ES

function unpack_books(){

    echo -e "Unpacking books"

    # Delete any folders before unpacking
    rm -rf "books" "__MACOSX"

    # Unpack books
    WORKINGDIRECTORY=$(dirname "$0")
    unzip $WORKINGDIRECTORY/books.zip

    echo -e "$(ls -lh books)"

}

function cleanup(){
    # Clean up books / data
    echo -e "Loading completed, cleaning up files"
    for FOLDER in "books" "__MACOSX" ; do
    {
        if [[ -d $FOLDER ]] ; then
        {
            echo -e "Removing folder: $FOLDER"
            rm -rf "$FOLDER"
        }
        fi
    }
    done
}

function stage_to_elastic(){
    # Load data into Elasticsearch
    echo -e "Loading books into Elasticsearch"
    GS_API='vuejs_api'
    docker exec $GS_API "node" "server/load_data.js"
}

# Main
unpack_books
stage_to_elastic
cleanup