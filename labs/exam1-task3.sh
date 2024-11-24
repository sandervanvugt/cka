export LAB3POD=$(kubectl get pods | awk '/lab153/ { print $1 }') &>/dev/null
if kubectl get pods $LAB3POD -o yaml | grep initContainer &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t $LAB3POD is running and it does have an init container"
	SCORE=$(( SCORE + 10 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t cannot find $LAB3POD using an initcontainer"
fi
TOTAL=$(( TOTAL + 10 ))
