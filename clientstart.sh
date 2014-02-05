#!/usr/bin/env bash

echo -n "port? "
read port
echo -n "host? "
read host
echo -n "class? "
read klass

echo "port ${port}, host ${host}, class ${klass}"
ruby main.rb --port=${port} --host=${host} --chaser=${klass}
