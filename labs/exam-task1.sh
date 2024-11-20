if kubectl get ns indiana &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t namespace indiana was found"
	SCORE=$(( SCORE + 10 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t namespace indiana was not found"
fi
TOTAL=$(( TOTAL + 10 ))

if [[ $(echo $(kubectl get -n indiana secret insecret -o yaml | awk '/color/ { print $2 }')| base64 -d) == blue ]] &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t secret insecret with COLOR=blue was found"
        SCORE=$(( SCORE + 10 ))
elif kubectl get -n indiana secret insecret &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t secret insecret was found, but not with the expected variable"
else
        echo -e "\033[31m[FAIL]\033[0m\t\t secret insecret was not found"
fi
TOTAL=$(( TOTAL + 10 ))

if [[ $(echo $(kubectl get pods -n indiana inpod -o jsonpath='{.spec.containers[*].image}')) == nginx:latest ]] &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t found pod inpod that uses the latest version of nginx"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t pod inpod that uses the latest version of the nginx image was not found"
fi
TOTAL=$(( TOTAL + 10 ))


if kubectl get pods -n indiana inpod -o yaml | grep insecret &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t pod inpod uses the secret insecret"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t pod inpod doesn't use the secret insecret"
fi
TOTAL=$(( TOTAL + 10 ))
