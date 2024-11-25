echo -e "\033[35mhang on...\033[0m\t\t this task evaluation needs about a minute to complete"


##preparing test Pod without a label whihch should not get access
kubectl delete pod labgrade -n access &>/dev/null
sleep 5
kubectl run labgrade -n access --image=busybox -- sleep 3600 &>/dev/null
sleep 5

if kubectl exec -n access labgrade -- wget --spider --timeout=1 lab156web.restricted.svc.cluster.local &>/dev/null
then
	echo -e "\033[31m[FAIL]\033[0m\t\t testpod is getting access, which means the networkpolicy is not correct"
else
	echo -e "\033[32m[OK]\033[0m\t\t testpod is not getting access, good!"
	SCORE=$(( SCORE + 10 ))
fi
TOTAL=$(( TOTAL + 10 ))

###testing if a networkpolicy was found
#do we have a networkpolicy on the namespace restricted?
if kubectl get netpol lab156pol -n restricted &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t found a NetworkPolicy on the Namespace restricted"
        SCORE=$(( SCORE + 4 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t NetworkPolicy not found on the Namespace restricted"
fi
TOTAL=$(( TOTAL + 4 ))

#do we have a namespaceselector that allows incoming traffic from ns access
if kubectl get netpol -n restricted -o yaml | grep -A3 namespaceSelector | grep 'kubernetes.io/metadata.name: access' &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t namespaceSelector is set correctly in the NetworkPolicy"
        SCORE=$(( SCORE + 8 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t namespaceSelector is not set correctly in the NetworkPolicy"
fi
TOTAL=$(( TOTAL + 8 ))

#do we have a podselector that allows incoming traffic from pods that have label access=true
if kubectl get netpol -n restricted -o yaml | grep -A3 podSelector | grep 'access: "true"' &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t podSelector is set correctly in the NetworkPolicy"
        SCORE=$(( SCORE + 8 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t podSelector is not set correctly in the NetworkPolicy"
fi
TOTAL=$(( TOTAL + 8 ))

##setting the label so that the testpod is getting access
kubectl label -n access pod labgrade access="true"

if kubectl exec -n access labgrade -- wget --spider --timeout=1 lab156web.restricted.svc.cluster.local &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t previous revision of deploy updated was using nginx:latest"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t previous revision of deploy updated not found or not using nginx:latest"
fi
TOTAL=$(( TOTAL + 10 ))
