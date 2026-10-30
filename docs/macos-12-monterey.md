# macOS 12 Monterey

| | |
|---|---|
| السنة | 2021 |
| البرنامج | **VMware** أو **VirtualBox** |
| خيار OS type في VMware | macOS 12 |
| الموارد المقترحة | 4 أنوية، 8GB رام، قرص 64GB |

## الطريقة الأولى: VMware
اتبع [vmware-setup.md](vmware-setup.md) بالكامل، واستخدم هذا الأمر في الخطوة 4:
```bat
scripts\prepare-macos-recovery.bat -Version Monterey -OutDir D:\macOS-VM
```

## الطريقة الثانية: VirtualBox
Monterey هو **أكثر إصدار مستقر على VirtualBox**. اتبع [virtualbox-setup.md](virtualbox-setup.md)، واستخدم هذا الأمر:
```bat
scripts\prepare-macos-recovery.bat -Version Monterey -Format vdi -OutDir D:\macOS-VM
```

## وش يختلف في Monterey
- **أخف إصدار** في القائمة، فهو مناسب للأجهزة اللي مواردها قليلة.
- لاحظ إن تطبيقات وأدوات كثيرة، ومنها Xcode الحديث، صارت تحتاج إصدارات أحدث من Monterey.
