#!/bin/bash

FILES=jetty/siginfo/*

for f in $FILES
	do
	echo $f
	rake acm:add_siginfo yaml_file=$f
	done

