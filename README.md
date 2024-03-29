# Measure HTTP request/response times using Curl.

Measures HTTP request/response times using [Curl](https://curl.se/), with the output formatted as JSON.


## Usage

    ./timecurl.sh [--loop <numRequests>] [--sleep <numSeconds>] [--id <ID>] [--stdin] [<Curl options>] [<URL>]
    
Pass '-L' to Curl to follow redirections.

## Example

**Command**
```
./timecurl.sh --loop 2 143.205.180.80
```

**Output**
```
[{
            "remote":  "143.205.180.80:80",
         "http_code":  200,
      "num_connects":  1,
             "local":  "10.0.1.101:62227",
      "size_request":  70,
     "size_download":  169,
   "time_namelookup":  0.000102,
  "time_pretransfer":  0.000872,
"time_starttransfer":  0.001813,

      "time_connect":  0.000806,
        "time_total":  0.002152,
         "exit_code":  0,
                "id":  ""
},{
            "remote":  "143.205.180.80:80",
         "http_code":  200,
      "num_connects":  1,
             "local":  "10.0.1.101:62228",
      "size_request":  70,
     "size_download":  169,
   "time_namelookup":  0.000083,
  "time_pretransfer":  0.000801,
"time_starttransfer":  0.001429,

      "time_connect":  0.000727,
        "time_total":  0.001690,
         "exit_code":  0,
                "id":  ""
}]
```


## License

This project is licensed under the [MIT License](LICENSE.md).
