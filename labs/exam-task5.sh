if kubectl get ns probes &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t namespace probes was found"
	SCORE=$(( SCORE + 10 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t namespace probes was not found"
fi
TOTAL=$(( TOTAL + 10 ))

if kubectl describe pods -n probes probepod | grep Liveness | grep '/healthz' &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t pod probepod was found, as well as its Liveness probe"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t no pod probepod with correct liveness probe was found"
fi
TOTAL=$(( TOTAL + 10 ))
