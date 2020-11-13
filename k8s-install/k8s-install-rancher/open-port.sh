#!/bin/bash
firewall-cmd --zone=public --permanent --add-port=2379-2380/tcp
