#!/bin/bash
#
# build-plugin-documentation.sh
# 
# Copyright (c) 2014  Josef Kufner <jk@frozen-doe.net>
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if pwd | grep -q '/plugin/[^/]*/doc'
then

	(
		# get Doxyfile
		sed 's|\(=[\t ]*\)doc/|\1../../core/doc/|' ../../../core/doc/Doxyfile

		# override few options
		echo "PROJECT_NAME=\"`head -n 1 ../README.md`\""
		echo "PROJECT_BRIEF="
		echo "PROJECT_NUMBER=\"`git describe --tag --match "v[0-9]*"`\""

		## add tagfiles (link other docs)
		# echo "TAGFILES+=\"../../core/doc/doxygen/tagfile.xml=../../../../../core/doc/doxygen/html/\""

		# include stdin
		[ "$0" == "-" ] && cat

		echo Generating documentation ... it may take a few more seconds ... >&2

	) | ( cd .. && doxygen - )

elif pwd | grep -q '/lib/cascade/[^/]*/doc'
then

	(
		# get Doxyfile
		sed 's|\(=[\t ]*\)doc/|\1../../../core/doc/|' ../../../../core/doc/Doxyfile

		# override few options
		echo "PROJECT_NAME=\"`head -n 1 ../README.md`\""
		echo "PROJECT_BRIEF="
		echo "PROJECT_NUMBER=\"`git describe --tag --match "v[0-9]*"`\""

		# include stdin
		[ "$0" == "-" ] && cat

		echo Generating documentation ... it may take a few more seconds ... >&2

	) | ( cd .. && doxygen - )
else
	echo "This script must be run from plugin's doc directory." >&2
	exit 1
fi

