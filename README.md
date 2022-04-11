# Measure HTTP request/response times using Curl.

Measures HTTP request/response times using Curl, with the output formatted as JSON.


## Usage

    ./timecurl.sh [loop <numRequests>] [sleep <numSeconds>] [curl options / URL]
    
Use '-L' to follow redirections.


## Example

**Command**
```
./timecurl.sh loop 2 143.205.180.80
```

**Output**
```
[{
            "remote":  "143.205.180.80:80",
         "http_code":  200,
      "num_connects":  1,
   "time_namelookup":  0.000102,
  "time_pretransfer":  0.000872,
"time_starttransfer":  0.001813,

      "time_connect":  0.000806,
        "time_total":  0.002152
},{
            "remote":  "143.205.180.80:80",
         "http_code":  200,
      "num_connects":  1,
   "time_namelookup":  0.000083,
  "time_pretransfer":  0.000801,
"time_starttransfer":  0.001429,

      "time_connect":  0.000727,
        "time_total":  0.001690
}]
```


## License

This project is licensed under the [MIT License](LICENSE.md).
