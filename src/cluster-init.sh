#!/bin/bash

NODE1_IP=$(/usr/bin/getent redis-cluster-node01 | awk {' print $1 '})
NODE2_IP=$(/usr/bin/getent redis-cluster-node02 | awk {' print $1 '})

/usr/local/bin/redis-cli -h redis-cluster-node01 CLUSTER MEET $NODE1_IP 6379
