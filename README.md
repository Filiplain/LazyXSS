# LazyXSS

## Install

To get up and running, please use the `install.sh` script to get all the required tools.

```
chmod +x ./install.sh && ./install.sh
```

## Description
Script to automate XSS finding with the help of the following tools:

* airixss
https://github.com/ferreiraklet/airixss
* hakrawler
https://github.com/hakluke/hakrawler
* qsreplace
https://github.com/tomnomnom/qsreplace
* httprobe
https://github.com/tomnomnom/httprobe


## Usage
~~~
./LazyXSS.sh -t < target > -a < attack # > -p [ ports for probing]
~~~

## Available Flags
-------------------------------------------------------------
  -a)	  Set attack number (1,2,3):
          1) Tries finding XSS in parameters on Given URL or list of URLs in a File.
          2) Tries finding XSS in PATHs on Given URL or list of URLs in a File.
          3) Probes given domain or domains in a file, Crawls the alive URLs and then try to find possible XSS on Parameters.
          eg: -a 3
        
        
  -t)     Set target giving a URL/domain or a list in a file depending on the attack type. 
 	  eg: -t ./url-list.txt
 	  eg: -t http://vulnpage.test
 	
 	
  -p)     Set ports to probe (defaults 80,443).
	  eg: -p 8000,8080,8085,10443

  -h)	  Opens the help panel

-----------------------------------------------------------------


## Things to note
* To get better results you can modify the `xss_payload=` and `reflect=` in the script, that way you can customize your XSS findings. Soon this will be added as a flag option like `-payload` and `-reflect`.
* the `-p` flag is only used when the attack type is #3
* Attack #2 only accepts 2000 urls, because it requires too much time to combine every URL path with the XSS payload
* Attack #1 and #2 only accepts URLs, not domains.
* Attack #3 will accept URLs but it only uses the domain in the URLs.
* This is a new project, so a lot of changes will be made soon.


