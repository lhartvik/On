GOOGLE_CLIENT_ID=$(grep GOOGLE_CLIENT_ID .env | cut -d '=' -f2)
/usr/libexec/PlistBuddy -c "Set CFBundleURLSchemes:0 $GOOGLE_CLIENT_ID" ios/Runner/Info.plist