#!/usr/bin/env python3
"""Enable Android Auto Backup of Flutter shared_preferences; no live sync claim."""
from pathlib import Path
from xml.etree import ElementTree as ET
import re,sys
root=Path.cwd()
manifest=root/'android/app/src/main/AndroidManifest.xml'
manifest.parent.mkdir(parents=True,exist_ok=True)
ANDROID='http://schemas.android.com/apk/res/android'
ns='{'+ANDROID+'}'
if manifest.exists():
    s=manifest.read_text()
else:
    # Flutter 3 embedding V2 fallback template. flutter create will supply native source files.
    s='''<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application android:label="Kelime Çemberi" android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <activity android:name=".MainActivity" android:exported="true"
            android:launchMode="singleTop" android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true" android:windowSoftInputMode="adjustResize">
            <meta-data android:name="io.flutter.embedding.android.NormalTheme"
                android:resource="@style/NormalTheme" />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        <meta-data android:name="flutterEmbedding" android:value="2" />
    </application>
    <queries>
        <intent><action android:name="android.intent.action.PROCESS_TEXT"/>
            <data android:mimeType="text/plain" /></intent>
    </queries>
</manifest>
'''
try:
    parsed=ET.fromstring(s)
except ET.ParseError as e:sys.exit('V313: AndroidManifest.xml XML bozuk: '+str(e))
applications=parsed.findall('application')
if len(applications)!=1:sys.exit('V313: Bir application bulunamadı; işlem iptal')
app=applications[0]
app.set(ns+'allowBackup','true')
app.set(ns+'fullBackupContent','@xml/v313_backup_rules')
app.set(ns+'dataExtractionRules','@xml/v313_data_extraction_rules')
# XML output normalizes formatting; attributes intact and prior icon untouched.
ET.register_namespace('android',ANDROID)
value=ET.tostring(parsed,encoding='unicode')
ET.fromstring(value)
manifest.write_text('<?xml version="1.0" encoding="utf-8"?>\n'+value+'\n')
folder=manifest.parent/'res/xml';folder.mkdir(parents=True,exist_ok=True)
(folder/'v313_backup_rules.xml').write_text('''<?xml version="1.0" encoding="utf-8"?>
<full-backup-content>
    <include domain="sharedpref" path="." />
</full-backup-content>
''')
(folder/'v313_data_extraction_rules.xml').write_text('''<?xml version="1.0" encoding="utf-8"?>
<data-extraction-rules>
    <cloud-backup>
        <include domain="sharedpref" path="." />
    </cloud-backup>
    <device-transfer>
        <include domain="sharedpref" path="." />
    </device-transfer>
</data-extraction-rules>
''')
print('V313: Android sistem yedekleme kuralları oluşturuldu (shared_preferences).')
print('NOT: Google hesap ayarlarında Android yedekleme etkin olmalı; anlık senkronizasyon değildir.')
