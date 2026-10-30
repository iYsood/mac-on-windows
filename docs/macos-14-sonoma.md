# macOS 14 Sonoma

| | |
|---|---|
| السنة | 2023 |
| البرنامج | **VMware** |
| خيار OS type في VMware | macOS 14 |
| الموارد المقترحة | 4 إلى 8 أنوية، 8 إلى 16GB رام، قرص 80GB |

## الطريقة
اتبع [vmware-setup.md](vmware-setup.md) بالكامل، واستخدم هذا الأمر في الخطوة 4:
```bat
scripts\prepare-macos-recovery.bat -Version Sonoma -OutDir D:\macOS-VM
```

## وش يختلف في Sonoma
- طريقة تحويل صورة الاستعادة بـ `qemu-img` مجرّبة على Sonoma في أكثر من دليل، فهي الأضمن.
- **VirtualBox** يشتغل معه أحياناً بس فيه مشاكل كثيرة، فالأفضل VMware.
