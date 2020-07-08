#!/bin/bash

# Usage
usage() {
	echo "find_repos [-d DIRECTORY] [-s SEARCH_STRING] [-o OUTPUT_FILE]"
}

# echo to standard out if VERBOSE
vprint() {
	TEXT="${1}"
	LOG=$2
	[[ $VERBOSE ]] && echo $TEXT 
	[[ $LOG ]] && echo $TEXT >> "${OUTPUT_FILE}" 
}

# Collects repo info for a directory
get_repo() {
	directory="${1}"
	repo_dir=""
	repo_name=""
	if [[ -d "${directory}/.git" ]]; then
		# This is a repo directory
		repo_dir="${directory}"
		repo_name=`cat ${directory}/.git/config | grep -m 1 url | awk -F'/' '{print $2}'`
		[[ -n ${repo_name} ]] && vprint "${repo_name}	${repo_dir}" log
	fi
}

# Check search string
filter_repos() {
	search="${1}"
	filtered=""
	if [[ -n ${search} ]]; then
		vprint "Filtering for ${search}" 
		grep ${search} ${OUTPUT_FILE} > ${OUTPUT_FILE}.filtered 
		[[ -e ${OUTPUT_FILE}.filtered ]] && mv ${OUTPUT_FILE}.filtered ${OUTPUT_FILE}
	fi
	[[ $VERBOSE ]] && cat ${OUTPUT_FILE}
}

# Sort the list
sort_repos() {
	sort ${OUTPUT_FILE} > ${OUTPUT_FILE}.sorted
	mv ${OUTPUT_FILE}.sorted ${OUTPUT_FILE}
}

# Process options
while getopts 'd:o:s:hv' OPTION; do
	case "$OPTION" in 
		d) DIR="$OPTARG"
		;;
		s) SEARCH_STRING="$OPTARG"
			vprint "Searching for $SEARCH_STRING"
		;;
		o) OUTPUT_FILE="$OPTARG"
		;;
		h) usage
		exit 0
		;;
		v) VERBOSE=1
		;;
		?) usage
		exit 1
		;;
	esac
done

# Global vars
DIR="${DIR:=`pwd`}"
OUTPUT_FILE="${OUTPUT_FILE:=/tmp/repos.out.$$}"

# Empty output file
>${OUTPUT_FILE}

vprint "Searching path $DIR"
vprint "Output will be in file $OUTPUT_FILE"

# Get an absolute path to DIR
[[ ${DIR} != "/"* ]] && DIR=$(pwd)/${DIR}

for dir in `ls -F ${DIR} | grep '/'`; do
	get_repo ${DIR}/${dir}
done

sort_repos
filter_repos $SEARCH_STRING