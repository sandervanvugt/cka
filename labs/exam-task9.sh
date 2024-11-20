if kubectl exec storepod -- cat /usr/share/nginx/html/index.html &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t file index.html accessible through hostPath storage" 
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t file index.html not accessible through hostPath storage"
fi
TOTAL=$(( TOTAL + 10 ))

if curl $(minikube ip):32032 | grep welcome &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t Pod storepod correctly exposed and hostPath volume content accessible"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t Pod storepod not correctly exposed"
fi
TOTAL=$(( TOTAL + 10 ))
