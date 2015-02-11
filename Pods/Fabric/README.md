Fabric
======
This repository contains CocoaPod for Fabric (https://fabric.io).


## Installing
1. Use official Fabric app to add components you need
2. Remove all frameworks from project which were added by Fabric app
3. Add pods

  ```ruby
pod 'Fabric/Crashlytics', '~> 1.0'
pod 'Fabric/MoPub', '~> 1.0'
pod 'Fabric/Twitter', '~> 1.0'
```

4. Change path in Run Script Build command to:

  `./Pods/Fabric/Fabric.framework/run <your organization API key> <your organization build secret>`

If you only need Crashlytics you can also install it without app:

1. Add pods (see above)
2. Add Run Script Build Phase (see http://www.runscriptbuildphase.com) and paste

 `./Pods/Fabric/Fabric.framework/run <your organization API key> <your organization build secret>`

  You can get your organization API key and build secret from organization settings page (https://fabric.io/settings/organizations).

3. Add the following to your project's Info.plist:

```xml
<key>Fabric</key>
<dict>
	<key>APIKey</key>
	<string><your organization API key></string>
	<key>Kits</key>
	<array>
		<dict>
			<key>KitInfo</key>
			<dict/>
			<key>KitName</key>
			<string>Crashlytics</string>
		</dict>
	</array>
</dict>
```
