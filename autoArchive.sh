# 工程名
APP_NAME="XLLJenkinsDemo"
# 证书
CODE_SIGN_DEVELOPER="iPhone Developer"
# info.plist路径
project_infoplist_path="./${APP_NAME}/Info.plist"

#取版本号
bundleShortVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" "${project_infoplist_path}")

#取build值
bundleVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" "${project_infoplist_path}")

DATE="$(date +%Y%m%d)"
IPANAME="${APP_NAME}_V${bundleShortVersion}_${DATE}.ipa"

#要上传的ipa文件路径
IPA_PATH="$HOME/${IPANAME}"
echo ${IPA_PATH}
#echo "${IPA_PATH}">> text.txt

#集成有Cocopods的用法
echo "=================clean================="
xcodebuild -workspace "${APP_NAME}.xcworkspace" -scheme "${APP_NAME}"  -configuration 'Release' clean

echo "+++++++++++++++++build+++++++++++++++++"
xcodebuild -workspace "${APP_NAME}.xcworkspace" -scheme "${APP_NAME}" -sdk iphoneos -configuration 'Release' CODE_SIGN_IDENTITY="${CODE_SIGN_DEVELOPER}" SYMROOT='$(PWD)'

xcrun -sdk iphoneos PackageApplication "./Release-iphoneos/${APP_NAME}.app" -o ~/"${IPANAME}"


#上传到蒲公英
uKey="e3ab1abc7188421e8234258fb4240a7e"
#蒲公英上的API Key
apiKey="403a53481552187f105636dc888f69f7"
#蒲公英版本更新描述，这里取git最后一条提交记录作为描述
MSG=`git log -1 --pretty=%B`
#要上传的ipa文件路径
echo $IPA_PATH
 
#执行上传至蒲公英的命令
echo "++++++++++++++upload+++++++++++++"
curl -F "file=@${IPA_PATH}" -F "uKey=${uKey}" -F "_api_key=${apiKey}" -F "buildUpdateDescription=${MSG}" http://www.pgyer.com/apiv2/app/upload
