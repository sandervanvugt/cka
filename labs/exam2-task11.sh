if sudo etcdctl --write-out=table snapshot status /tmp/etcdbackup &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t a valid etcd backup was found"
	SCORE=$(( SCORE + 10 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t a valid etcd backup was not found"
fi
TOTAL=$(( TOTAL + 10 ))

if kubectl logs -n kube-system etcd-control | grep restore &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t etcd backup was successfully restored"
	SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t etcd backup was not restored"
fi
TOTAL=$(( TOTAL + 10 ))
