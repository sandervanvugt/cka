# check for the role
if kubectl -n access get roles role1511 -o yaml | grep create &>/dev/null && kubectl -n access get roles role1511 -o yaml | grep deploy &>/dev/null && kubectl -n access get roles role1511 -o yaml | grep daemonset &>/dev/null && kubectl -n access get roles role1511 -o yaml | grep stateful &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t role role1511 was found with correct verbs and objects"
	SCORE=$(( SCORE + 10 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t no correct role configuration was found"
fi
TOTAL=$(( TOTAL + 10 ))

# check for the rolebinding to be set correctly
if kubectl get -n access rolebinding -o yaml | grep lab1511role &>/dev/null && kubectl get -n access rolebinding -o yaml | grep lab1511access &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t rolebinding is set up the right way"
	SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t no correctly configured rolebinding was found"
fi
TOTAL=$(( TOTAL + 10 ))

# check for pod that uses the ServiceAccount
if kubectl get -n access pod lab1511pod -o yaml | grep 'serviceAccount: lab1511access' &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t the pod lab1511pod uses the serviceAccount lab1511access"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t the pod lab1511pod doesn't use the serviceAccount lab1511access"
fi
TOTAL=$(( TOTAL + 10 ))
