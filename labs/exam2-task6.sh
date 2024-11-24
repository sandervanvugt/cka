if kubectl get pods -n kube-system | grep metrics-server | grep '1/1'
then
	echo -e "\033[32m[OK]\033[0m\t\t Good! Metrics server Pod is up and running"
	SCORE=$(( SCORE + 10 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t Metrics server Pod doesn't seem to be running"
fi
TOTAL=$(( TOTAL + 10 ))

if [[ $(kubectl top pods -A --sort-by=cpu | head -2 | tail -1 | awk '{ print $2 }') == $(cat /tmp/load.txt) ]]
then
        echo -e "\033[32m[OK]\033[0m\t\t kubectl top is working"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t kubectl top is not working correctly"
fi
TOTAL=$(( TOTAL + 10 ))
