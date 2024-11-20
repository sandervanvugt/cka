# get the revision number of the last update that was found
kubectl rollout history deployment updates > /tmp/task6.txt
LAST=$(tail -2 /tmp/task6.txt | head -1 | awk '{ print $1 }')
BEFORE=$(( LAST -1 ))

if kubectl rollout history deployment updates --revision=${LAST} | grep 'nginx:1.17' &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t last revision of the updated deploy is set to nginx:1.17"
	SCORE=$(( SCORE + 10 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t last revision of the updated deploy is not set to nginx:1.17"
fi
TOTAL=$(( TOTAL + 10 ))

if kubectl rollout history deployment updates --revision=${BEFORE} | grep 'nginx:latest' &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t previous revision of deploy updated was using nginx:latest"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t previous revision of deploy updated not found or not using nginx:latest"
fi
TOTAL=$(( TOTAL + 10 ))
