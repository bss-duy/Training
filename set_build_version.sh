#!/bin/bash

git=$(sh /etc/profile; which git)
number_of_commits=$("$git" rev-list HEAD --count)
git_release_version=$("$git" describe --tags --always --abbrev=0)

underscore="_"
target_plist="$TARGET_BUILD_DIR/$INFOPLIST_PATH"
dsym_plist="$DWARF_DSYM_FOLDER_PATH/$DWARF_DSYM_FILE_NAME/Contents/Info.plist"
product_name="$PRODUCT_NAME"
# echo $dsym_plist
# echo $target_plist
echo "----------------------SET BUILD VERSION----------------------"
echo "PRODUCT_NAME: $product_name"
echo "BUILD_NUMBER: $@"
build_number=$@
if [ "$build_number" != "" ]; then
	build_number=".$build_number"
fi

for plist in "$target_plist"; do
  if [ -f "$plist" ]; then
    #/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $number_of_commits" "$plist"
    /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${git_release_version#*v}" "$plist"
    /usr/libexec/PlistBuddy -c "Set :CFBundleName $product_name$underscore${git_release_version#*v}$build_number" "$plist"
  fi
done