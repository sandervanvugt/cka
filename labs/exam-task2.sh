kubectl get pods -A --selector tier=control-plane | awk 'NR > 1 { print $2 }' > /tmp/task2file.txt

if diff /tmp/task2file.txt /tmp/task2pods
then
	echo -e "\033[32m[OK]\033[0m\t\t all pods with label tier=control-plane were found"
	SCORE=$(( SCORE + 10 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t your result file doesn't show all pods with the label tier=control-plane"
fi
TOTAL=$(( TOTAL + 10 ))

