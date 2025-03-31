# check for the role
if kubectl -n access get roles role1510 -o yaml | grep create &>/dev/null && kubectl -n access get roles role1510 -o yaml | grep deploy &>/dev/null && kubectl -n access get roles role1510 -o yaml | grep daemonset &>/dev/null && kubectl -n access get roles role1510 -o yaml | grep stateful &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t role role1510 was found with correct verbs and objects"
	SCORE=$(( SCORE + 10 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t no correct role configuration was found"
fi
TOTAL=$(( TOTAL + 10 ))

# check for the rolebinding to be set correctly
if kubectl get -n access rolebinding -o yaml | grep role1510 &>/dev/null && kubectl get -n access rolebinding -o yaml | grep lab1510access &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t rolebinding is set up the right way"
	SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t no correctly configured rolebinding was found"
fi
TOTAL=$(( TOTAL + 10 ))

# check for pod that uses the ServiceAccount
if kubectl get -n access pod lab1510pod -o yaml | grep 'serviceAccount: lab1510access' &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t the pod lab1510pod uses the serviceAccount lab1510access"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t the pod lab1510pod doesn't use the serviceAccount lab1510access"
fi
TOTAL=$(( TOTAL + 10 ))
