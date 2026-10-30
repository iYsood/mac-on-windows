# macOS 13 Ventura

| | |
|---|---|
| السنة | 2022 |
| البرنامج | **VMware** (الأفضل) أو **VirtualBox** |
| خيار OS type في VMware | macOS 13 |
| الموارد المقترحة | 4 إلى 8 أنوية، 8 إلى 16GB رام، قرص 80GB |

## الطريقة الأولى: VMware (الأفضل)
اتبع [vmware-setup.md](vmware-setup.md) بالكامل، واستخدم هذا الأمر في الخطوة 4:
```bat
scripts\prepare-macos-recovery.bat -Version Ventura -OutDir D:\macOS-VM
```

## الطريقة الثانية: VirtualBox
Ventura من آخر الإصدارات اللي تشتغل بشكل مقبول على VirtualBox. اتبع [virtualbox-setup.md](virtualbox-setup.md)، واستخدم هذا الأمر:
```bat
scripts\prepare-macos-recovery.bat -Version Ventura -Format vdi -OutDir D:\macOS-VM
```

## وش يختلف في Ventura
- يشتغل على VMware و VirtualBox، بعكس الإصدارات الأحدث اللي تحتاج VMware.
- إذا كان الـ VM يعيد التشغيل أثناء التثبيت، السبب غالباً إن **Hyper-V شغال**. شغّل `scripts\disable-hyperv.bat` وسوّ ريستارت.
