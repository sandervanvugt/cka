# temporary cordon on worker1
kubectl cordon worker1 &>/dev/null

# verifying that the toleration works
if  kubectl run lab1512testpod1 --image=nginx --restart=Never --overrides='{
  "spec": {
    "tolerations": [
      {
        "key": "type",
        "operator": "Equal",
        "value": "db",
        "effect": "NoSchedule"
      }
    ]
  }
}' &>/dev/null && sleep 5
then
	echo -e "\033[32m[OK]\033[0m\t\t a pod with the toleration type=db will run on worker2"
	SCORE=$(( SCORE + 10 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t the toleration type=db doesn't allow the pod to run on worker2"
fi
TOTAL=$(( TOTAL + 10 ))

# verifying that a pod without toleration doesn't run
kubectl run lab1512testpod2 --image=nginx &>/dev/null

if kubectl get pods lab1512testpod2 | grep Pending &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t without a toleration the testpod doesn't shows a state of Pending and that exactly what we needed!"
	SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t the testpod without toleration works, so the taint isn't functional"
fi
TOTAL=$(( TOTAL + 10 ))

# cleaning up
kubectl delete pod lab1512testpod1 lab1512testpod2 &>/dev/null
kubectl uncordon worker1 &>/dev/null

