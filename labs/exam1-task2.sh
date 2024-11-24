if kubectl get pods lab152pod | grep '2/2' &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t the pod lab152pod was found and it is running 2 containers"
	SCORE=$(( SCORE + 10 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t cannot find the pod lab152pod running 2 containers"
fi
TOTAL=$(( TOTAL + 10 ))

if kubectl get pods lab152pod -o yaml | grep -i toleration -A3 | grep -iz noschedule.*control-plane &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t the pod lab152pod has a tolerations that allows it to run on control-plane nodes"
	SCORE=$(( SCORE + 10 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t the pod lab152pod does not have a toleration that allows it to run on a control-plane node"
fi
TOTAL=$(( TOTAL + 10 ))

