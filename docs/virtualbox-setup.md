# التثبيت على VirtualBox (Monterey و Ventura فقط)

> للإصدارات من Sonoma وأحدث، استخدم [VMware](vmware-setup.md).

## 1. إيقاف Hyper-V
هذي أهم خطوة. لو Hyper-V شغال، VirtualBox يشتغل بوضع بطيء اسمه **NEM**، وهو السبب الأول للريستارت أثناء التثبيت وبطء الماوس.

شغّل [`scripts/disable-hyperv.bat`](../scripts/disable-hyperv.bat) وبعدها سوّ ريستارت.

**للتأكد:** بعد ما تشغّل الـ VM، افتح ملف `VBox.log`. إذا لقيت فيه هذا السطر، فـ Hyper-V ما زال شغال:
```
HM: HMR3Init: Attempting fall back to NEM: VT-x is not available
```

## 2. تجهيز صورة الاستعادة بصيغة VDI
```bat
scripts\prepare-macos-recovery.bat -Version Ventura -Format vdi -OutDir D:\macOS-VM
```

## 3. إنشاء الـ VM
في VirtualBox اختر **New**:
- Name: `macOS Ventura`
- Type: **Mac OS X**
- Version: **Mac OS X (64-bit)**
- Memory: 8192 MB أو أكثر
- Hard disk: Create a virtual hard disk now، بصيغة **VDI** وحجم **80GB**

بعدها افتح **Settings ← Storage**، واضغط على وحدة التحكم **SATA**، وأضف ملف `Ventura-recovery.vdi` كقرص ثاني.

## 4. تطبيق إعدادات macOS
سكّر VirtualBox بالكامل، وبعدها شغّل:
```bat
scripts\configure-virtualbox-vm.bat -VmName "macOS Ventura" -Cpus 8 -MemoryMB 16384
```
السكربت يضبط الـ VM عشان يقبله macOS:
- يعرّف الجهاز على إنه **iMac19,1** ويضبط CPUID و SMBIOS.
- يضيف مفتاح SMC اللي يحتاجه macOS عشان يقلع.
- يفعّل EFI وشريحة ICH9 والماوس بنوع USB Tablet.
- يخلي دقة شاشة الإقلاع 1920×1080.

## 5. التثبيت
كمّل من **الخطوة 6** في [vmware-setup.md](vmware-setup.md#6-التثبيت)، لأن الخطوات من هنا متطابقة: Disk Utility ثم Erase ثم Reinstall macOS.

## ملاحظات
- VirtualBox **ما فيه VMware Tools ولا Guest Additions لـ macOS**، فالماوس والشاشة بيكونون أبطأ من VMware.
- إذا علّق الـ VM على شعار Apple، قلّل الأنوية إلى 4 وجرّب مرة ثانية.
