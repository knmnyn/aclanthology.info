#!/bin/bash

#FILES=/home/praveen/RoR/acl_heroku/jetty/min-test/without_bib_type/*

#for f in $FILES
#	do
#	echo $f
#    	rake anthology:load_papers_withoutbib xml_file=$f
#	done

FILES=/home/praveen/RoR/acl_heroku/jetty/min-test/with_bib_type/W09-*
#FILES=/home/praveen/RoR/acl_heroku/jetty/min-test/acl_newxml/*

for f in $FILES
	do
	echo $f
	rake anthology:load_papers xml_file=$f
	done
