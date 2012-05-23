#!/bin/bash

FILES=jetty/acm_metadata/*

for f in $FILES
	do
	echo $f
	rake acm:load_doi xml_file=$f
	done

