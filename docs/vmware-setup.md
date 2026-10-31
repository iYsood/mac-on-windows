# التثبيت على VMware Workstation Pro

هذا الدليل المشترك لكل الإصدارات. اقرأ قبله ملف الإصدار اللي تبيه من [README](../README.md#الإصدارات)، لأن فيه الاختلافات الخاصة بكل نظام.

---

## 1. إيقاف Hyper-V
شغّل [`scripts/disable-hyperv.bat`](../scripts/disable-hyperv.bat) ووافق على صلاحية المسؤول، أو اكتب في PowerShell كمسؤول:
```powershell
bcdedit /set hypervisorlaunchtype off
```
بعدها **أعد تشغيل ويندوز**، وتأكد إن **Intel VT-x** أو **AMD SVM** مفعّل في البايوس.

> للتراجع: [`scripts/enable-hyperv.bat`](../scripts/enable-hyperv.bat) ثم ريستارت.

---

## 2. تثبيت VMware Workstation Pro
1. سجّل حساب مجاني في موقع Broadcom Support.
2. نزّل **VMware Workstation Pro**، وهو مجاني للاستخدام الشخصي، وثبّته.
3. افتحه مرة وحدة وبعدها سكّره.

---

## 3. Auto-Unlocker
VMware على ويندوز ما يعرض خيار macOS افتراضياً، وهذي الأداة تفعّله.

- الأداة مفتوحة المصدر ومن طرف ثالث، مو من VMware ولا Apple. تلقاها على GitHub باسم **auto-unlocker**.
- سكّر VMware بالكامل، وشغّل الأداة **كمسؤول**، واضغط **Patch**.
- الأداة تنزّل بعد ملف `darwin.iso`، وهو VMware Tools الخاص بـ macOS.

---

## 4. تجهيز صورة الاستعادة
```bat
scripts\prepare-macos-recovery.bat -Version Tahoe -OutDir D:\macOS-VM
```
بدّل `Tahoe` باسم الإصدار اللي تبيه: `Sequoia` أو `Sonoma` أو `Ventura` أو `Monterey`.

السكربت يسوي التالي:
1. ينزّل `macrecovery.py` من مستودع [OpenCorePkg](https://github.com/acidanthera/OpenCorePkg).
2. ينزّل صورة الاستعادة الرسمية من **سيرفرات Apple**، وحجمها حوالي 1GB.
3. يثبّت [QEMU](https://www.qemu.org/) عن طريق winget، لأنه يحتاج أداة `qemu-img` منه.
4. يحوّل الصورة إلى ملف `D:\macOS-VM\<الإصدار>-recovery.vmdk`.

---

## 5. إنشاء الـ VM
في VMware اختر **File ← New Virtual Machine ← Custom**:

| الإعداد | القيمة |
|---|---|
| Guest OS | **I will install the operating system later** |
| OS type | Apple Mac OS X، واختر الإصدار المذكور في ملف نظامك |
| Location | مجلد على قرص SSD أو NVMe |
| Processors | 1 processor × **4 إلى 8 cores** |
| Memory | **8192 إلى 16384 MB** |
| Network | NAT |
| Disk | SATA، Create a new virtual disk، **100GB أو أكثر**، Store as a single file |

بعدها افتح **Edit virtual machine settings**:
1. اختر **Add ← Hard Disk ← SATA ← Use an existing virtual disk**، وحدد ملف `recovery.vmdk`. لو سألك عن تحويل الصيغة، اختر **Keep Existing Format**.
2. **CD/DVD**: خلّه فاضي.
3. **Display**: فعّل **Accelerate 3D graphics**.

---

## 6. التثبيت
1. شغّل الـ VM. إذا طلعت لك قائمة الإقلاع، اختر **قرص الاستعادة** (الأصغر حجماً).
2. انتظر لين تطلع شاشة **macOS Recovery**.
3. افتح **Disk Utility**، ومن **View** اختر **Show All Devices**، وحدد قرص **VMware Virtual SATA**، واضغط **Erase**:
   - Name: `Macintosh HD`
   - Format: **APFS**، أو **Mac OS Extended (Journaled)** إذا ما ظهر APFS في الإصدارات القديمة
   - Scheme: **GUID Partition Map**
4. سكّر Disk Utility، واختر **Reinstall macOS**، وحدد `Macintosh HD`.
5. النظام **ينزل كامل من الإنترنت**، وحجمه من 12 إلى 15GB. الجهاز بيعيد التشغيل أكثر من مرة، وكل مرة خله يقلع من `Macintosh HD`.

---

## 7. بعد التثبيت
1. **أطفِ الـ VM**، واحذف قرص الاستعادة من الإعدادات بخيار **Remove**. هذا يشيله من الـ VM بس، والملف يبقى على القرص.
2. **VMware Tools**: يحسّن دقة الشاشة والماوس، ويفعّل النسخ واللصق والسحب والإفلات بين ويندوز و macOS.
   - Auto-Unlocker يحاول ينزّل `darwin.iso`، بس أحياناً يفشل في نسخه لمجلد VMware. إذا ما لقيته، نزّله مباشرة من سيرفر VMware الرسمي: [darwin.iso](https://packages.vmware.com/tools/frozen/darwin/darwin.iso) (حوالي 3.4MB، لـ macOS 10.15 وأحدث).
   - من إعدادات الـ VM افتح **CD/DVD ← Use ISO image file**، واختر `darwin.iso`، وفعّل **Connected**.
   - داخل macOS افتح قرص **VMware Tools**، واضغط **Install VMware Tools**.
   - لما تطلع رسالة **System Extension Blocked**، افتح **System Settings ← Privacy & Security**، واضغط **Allow** جنب VMware, Inc.، وسوّ ريستارت.
   - بعد التثبيت افصل الـ ISO من إعدادات CD/DVD.
3. لتحسين السرعة، افتح **System Settings ← Accessibility ← Display** وفعّل **Reduce transparency** و **Reduce motion**.

إذا واجهتك مشكلة، راجع [troubleshooting.md](troubleshooting.md).
