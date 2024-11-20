if grep $(minikube ip).*myapp.info /etc/hosts &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t name resolution for myapp.info is setup"
	SCORE=$(( SCORE + 10 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t no name resolution for myapp.info was found"
fi
TOTAL=$(( TOTAL + 10 ))

if kubectl describe svc task7svc | grep app=updates &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t Service task7svc found and exposes Deploy updates"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t No Service task7svc exposing Deploy updates was found"
fi
TOTAL=$(( TOTAL + 10 ))

if kubectl get pods -n ingress-nginx | grep controller | grep Running &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t found a running ingress controller"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t no running ingress controller was found"
fi
TOTAL=$(( TOTAL + 10 ))


if kubectl describe ing | grep task7svc:80 &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t ingress rule forwarding traffic to task7svc was found"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\" no ingress rule forwarding traffic to task7svc was found"
fi
TOTAL=$(( TOTAL + 10 ))
