when HTTP_REQUEST {
       HTTP::redirect https://[getfield [HTTP::host] ":" 1][HTTP::uri]
    }
