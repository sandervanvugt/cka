if kubectl exec exam2-task3 -c nginx -- cat /usr/share/nginx/html/date.log
then
	echo -e "\033[32m[OK]\033[0m\t\t the sidecar Pod provides access to the main app output"
	SCORE=$(( SCORE + 10 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t the sidecar Pod doesn't provide access to the main app output"
fi
TOTAL=$(( TOTAL + 10 ))
