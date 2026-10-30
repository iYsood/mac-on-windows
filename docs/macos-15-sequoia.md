# macOS 15 Sequoia

| | |
|---|---|
| السنة | 2024 |
| البرنامج | **VMware** |
| خيار OS type في VMware | macOS 15، أو macOS 14 إذا ما ظهر |
| الموارد المقترحة | 8 أنوية، 16GB رام، قرص 100GB |

## الطريقة
اتبع [vmware-setup.md](vmware-setup.md) بالكامل، واستخدم هذا الأمر في الخطوة 4:
```bat
scripts\prepare-macos-recovery.bat -Version Sequoia -OutDir D:\macOS-VM
```

## وش يختلف في Sequoia
- **أخف من Tahoe** لأن تصميمه بدون Liquid Glass، فهو أنسب خيار لو تبي نظام حديث وسلس في الـ VM.
- **VMware Tools** يشتغل عادي بعد ما توافق عليه في Privacy & Security.
- **VirtualBox** غير مستقر معه، فالأفضل VMware.
