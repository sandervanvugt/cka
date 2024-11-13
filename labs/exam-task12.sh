if  kubectl get ns | grep birds &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t namespace birds was found"
	SCORE=$(( SCORE + 10 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t namespace birds was not found"
fi
TOTAL=$(( TOTAL + 10 ))

if [[ $(kubectl -n birds get pods --show-labels --selector=type=allbirds | grep bird | wc -l) == "5" ]] &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t good, 5 pods with label type=allbirds were found"
	SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t couldn't finf 5 pods with the label type=allbirds"
fi
TOTAL=$(( TOTAL + 10 ))

if kubectl get -n birds svc allbirds | grep 32323 &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t NodePort Service allbirds listening on nodePort 32323 was found in Namespace birds"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t no NodePort Service allbirds listening on nodePort 32323 was found in Namespace birds"
fi
TOTAL=$(( TOTAL + 10 ))

