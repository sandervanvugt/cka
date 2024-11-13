if kubectl get ns nebraska &>/dev/null &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t namespace nebraska was found"
	SCORE=$(( SCORE + 10 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t namespace nebraska was not found"
fi
TOTAL=$(( TOTAL + 10 ))

if kubectl -n nebraska get deploy | grep snowdeploy &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t Deployment snowdeploy was found in Namespace nebraska"
	SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t Deployment snowdeploy was not found"
fi
TOTAL=$(( TOTAL + 10 ))

if kubectl -n nebraska get deploy snowdeploy -o yaml | grep -A1 requests | grep 64Mi &>/dev/null && kubectl -n nebraska get deploy snowdeploy -o yaml | grep -A1 limits | grep 128Mi &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t the requested memory request and limits have been found"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t the requested memory request and limits have not been found"
fi
TOTAL=$(( TOTAL + 10 ))
