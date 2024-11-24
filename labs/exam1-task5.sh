if kubectl get svc | grep 32567 | grep lab155deploy &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t a NodePort Service exposing lab155deploy was found listening at port 32567"
	SCORE=$(( SCORE + 7 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t no NodePort Service listening at port 32567 was found"
fi
TOTAL=$(( TOTAL + 7 ))

if kubectl get endpoints | grep lab155deploy | grep -E '^[^:]*(:[^:]*){3}$' &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t the NodePort Service is exposing 3 Pods"
	SCORE=$(( SCORE + 3 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t the NodePort Service is not exposing 3 Pods"
fi
TOTAL=$(( TOTAL + 3 ))
