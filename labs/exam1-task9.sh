if ssh student@worker2 sudo journalctl -u kubelet | grep 'Deactivated successfully' &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t You have stopped the kubelet service using sudo systemctl kubelet stop"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t You have not stopped the kubelet service using sudo systemctl kubelet stop"
fi
TOTAL=$(( TOTAL + 10 ))

if ssh student@worker2 sudo systemctl status kubelet | grep 'active' &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t The kubelet service is running again"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t The kubelet service is not running"
fi
TOTAL=$(( TOTAL + 10 ))


