#!/bin/bash

end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"

function tools () {

echo -e "${blue}Creating $(echo ~/.LazyXSS/)\n\n${end}"
mkdir ~/.LazyXSS && cd ~/.LazyXSS

#httprobe
echo -e "${blue}\nCloning Repos...${end}\n"

echo -e "${yellow}\nHTTPROBE${end}\n"

git clone https://github.com/tomnomnom/httprobe.git

#hakrawler
echo -e "${yellow}\nHAKRAWLER${end}\n"
git clone https://github.com/hakluke/hakrawler.git

#qsreplace
echo -e "${yellow}\nQSREPLACE${end}\n"
git clone https://github.com/tomnomnom/qsreplace.git

#airixss
echo -e "${yellow}\nAIRIXSS${end}\n"
git clone https://github.com/ferreiraklet/airixss.git

}

echo -e "${blue}\nBuilding GO tools\n\n${end}"

function build () {

echo -e "${YELLOW}\nBUILDING HAKRAWLER\n${end}"

cd ~/.LazyXSS/hakrawler/ && go build hakrawler.go

echo -e "${YELLOW}\nBUILDING HTTPROBE\n${end}"

cd ~/.LazyXSS/httprobe/ && go build -o httprobe

echo -e "${YELLOW}\nBUILDING QSREPLACE\n${end}"

cd ~/.LazyXSS/qsreplace/ && go build -o qsreplace

echo -e "${YELLOW}\nDownloading Compiled AIRIXSS\n${end}"

cd ~/.LazyXSS/airixss/ && wget https://github.com/ferreiraklet/airixss/releases/download/airixss/airixss && chmod +x ~/.LazyXSS/airixss/airixss

echo -e "${blue}\nDone...${end}\n"

}


go_check=$(whereis go|cut -d ":" -f 2|grep go >/dev/null 2>&1 || echo -n "no")

if [ $go_check == "no" 2>/dev/null ]; then
 echo -e "${red}GO is not installed ... Please install it 'apt install golang'${end}"
else
 tools
 build
fi

