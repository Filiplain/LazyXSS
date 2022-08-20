# LazyXSS

![](https://raw.githubusercontent.com/Filiplain/LazyXSS/main/screenshot-lazyxss.png)

## Install

```
git clone https://github.com/Filiplain/LazyXSS.git
cd LazyXSS && chmod +x tools/*
```

## Description
Script to automate XSS finding with the help of the following tools:

* airixss\
https://github.com/ferreiraklet/airixss
* hakrawler\
https://github.com/hakluke/hakrawler
* qsreplace\
https://github.com/tomnomnom/qsreplace
* httprobe\
https://github.com/tomnomnom/httprobe
* gau\
https://github.com/lc/gau


## Usage
~~~
./LazyXSS.sh -t < target > -a < # >
~~~

## Available Flags
~~~~
  -a)     Set attack number (1,2,3,4):
              1) Try finding XSS in parameters on Given URL or list of URLs in a File.
              2) Try finding XSS in PATHs on Given URL or list of URLs in a File.
              3) Probe given domain or domains in a file, Crawls the alive URLs and then try to find possible XSS on Parameters.
              eg: -a 3
              4) Fetch URLs of target domain and try to find possible XSS on Parameters.
              eg: -a 4
        
  -t)     Set target giving a URL/domain or a list in a file depending on the attack type. 
 	      eg: -t ./url-list.txt
 	      eg: -t http://vulnpage.test
 	
 	
  -p)     [When using attack #3 only] Set ports to probe (defaults 80,443).
	      eg: -p 8000,8080,8085,10443
  -x)     [OPTIONAL] Custom XSS Payload (Default: '\"><svg onload=confirm(1)>)'
              eg: -x '\"><sCrIpT>alert(1)<ScRiPt>'
  
  -h)	  Open this help panel

~~~~


## Things to note
* To get better results you can use the '-x' flag to use your own XSS paylaod
* the `-p` flag is only used when the attack type is #3
* Attack #2 only accepts 2000 urls, because it requires too much time to combine every URL path with the XSS payload
* Attack #1 and #2 only accepts URLs, not domains.
* Attack #3 will accept URLs but it only uses the domain in the URLs.
* Attack #4 Could take a lot of time to fetch the URLs depending on the amount
* This is a new project, so a lot of changes will be made soon.


