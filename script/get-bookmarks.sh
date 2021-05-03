#!/bin/sh
get_firefox_bookmarks(){
    firefox_dir="$HOME/.mozilla/firefox"
    default_dir=`find $firefox_dir -type d -name *.default`
    search_string=$1
    if [ -z $default_dir ]
    then
        echo "No default folder in mozilla"
        exit 1
    fi
    if ! [ -x `command -v sqlite3` ]
    then
        echo "Sqlite is not installed. Can't proceed further."
        exit 1
    fi
    get_bookmarks_command="sqlite3 $default_dir/places.sqlite 'SELECT url, moz_places.title from moz_places INNER JOIN moz_bookmarks ON moz_places.id=moz_bookmarks.fk' -separator \t -column -header"
    if ! [ -z $search_string ]
    then 
        get_bookmarks_command="$get_bookmarks_command | grep '$search_string'"
    fi
    output="$(eval $get_bookmarks_command )"
    echo "$output"
    echo "$output">test_op.md
    sqlite3 $default_dir/places.sqlite 'SELECT url, moz_places.title from moz_places INNER JOIN moz_bookmarks ON moz_places.id=moz_bookmarks.fk' -separator \t -column -header > test_op1.md
}
search_string=$1
firefox_installed=false
chrome_installed=false
if [ -z $search_string ]
then
    echo "No search_string passed"
fi
command -v firefox || firefox_installed=true
command -v chrome || chrome_installed=true
if firefox_installed==true
then
    get_firefox_bookmarks $search_string
fi