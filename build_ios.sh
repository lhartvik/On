GOOGLE_CLIENT_ID=$(grep GOOGLE_CLIENT_ID .env | cut -d '=' -f2)
/usr/libexec/PlistBuddy -c "Set CFBundleURLTypes:0:CFBundleURLSchemes:0 $GOOGLE_CLIENT_ID" ios/Runner/Info.plist