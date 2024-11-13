if kubectl get pods -o yaml securepod | grep 'runAsGroup: 2000' &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t securepod is running with group ID 2000"
	SCORE=$(( SCORE + 10 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t securepod is not running with group ID 2000"
fi
TOTAL=$(( TOTAL + 10 ))

if kubectl get pods -o yaml securepod | grep 'allowPrivilegeEscalation: false' &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t container in pod securepod has privilege escalation disabled"
	SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t container in pod securepod has privilege escalation not disabled"
fi
TOTAL=$(( TOTAL + 10 ))
