if kubectl get nodes -o yaml | grep 'storage: ssd' &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t Found at least one node with the label storage=ssd"
	SCORE=$(( SCORE + 10 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t no nodes with label storage=ssd were found"
fi
TOTAL=$(( TOTAL + 10 ))

if kubectl get pods lab167pod -o yaml | grep nodeSelector -A1 | grep 'storage: ssd' &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t nodeSelector property was found on the Pod lab167pod"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t no nodeSelector propertyn was found on the Pod lab167pod"
fi
TOTAL=$(( TOTAL + 10 ))
