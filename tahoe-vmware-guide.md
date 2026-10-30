# تثبيت macOS Tahoe 26 على VMware — جهاز i9-14900K

> Tahoe آخر إصدار يدعم معالجات Intel. macOS 27 لـ Apple Silicon فقط وما يشتغل على أي PC.
> لو بغيت شي أخف وأسلس، استبدل Tahoe بـ Sequoia في كل الخطوات.

---

## الخطوة 1: إيقاف Hyper-V
شغّل `setup-macos-vm.bat`، أو افتح PowerShell كمسؤول واكتب:
```
bcdedit /set hypervisorlaunchtype off
```
بعدها سوّ **ريستارت**. وتأكد إن **Intel Virtualization Tech** مفعّل في البايوس (OC ← CPU Features).

> للتراجع: `revert-macos-vm.bat` ثم ريستارت.

---

## الخطوة 2: تثبيت VMware Workstation Pro
1. ادخل موقع Broadcom Support وسجّل حساب مجاني.
2. نزّل **VMware Workstation Pro** (مجاني للاستخدام الشخصي) وثبّته.
3. افتحه مرة وحدة وسكّره.

---

## الخطوة 3: Auto-Unlocker (يفعّل خيار macOS في VMware)
- أداة مفتوحة المصدر من طرف ثالث (ليست من VMware ولا Apple)، تلقاها على GitHub باسم **auto-unlocker**.
- سكّر VMware بالكامل، وشغّل الأداة **كمسؤول**، واضغط Patch.
- الأداة تنزّل لك بعد ملف `darwin.iso` (VMware Tools لـ macOS)، وراح نحتاجه في الخطوة 7.

---

## الخطوة 4: تجهيز صورة الاستعادة من Apple
شغّل:
```
prepare-macos-recovery.bat
```
السكربت:
1. ينزّل `macrecovery.py` من مستودع OpenCorePkg.
2. ينزّل صورة الاستعادة الرسمية من **سيرفرات Apple** (حوالي 1GB).
3. يثبّت QEMU عن طريق winget (يحتاج أداة `qemu-img` منه).
4. يحوّل الصورة إلى `D:\macOS-VM\Tahoe-recovery.vmdk`.

> لـ Sequoia: `prepare-macos-recovery.bat -Version Sequoia`

---

## الخطوة 5: إنشاء الـ VM
في VMware: **File ← New Virtual Machine ← Custom**:

| الإعداد | القيمة |
|---|---|
| Guest OS | **I will install the operating system later** |
| OS type | Apple Mac OS X ← أعلى إصدار موجود (macOS 15 أو 14) |
| Name / Location | `macOS Tahoe` ← `D:\macOS-VM\Tahoe` |
| Processors | 1 processor × **8 cores** |
| Memory | **16384 MB** |
| Network | NAT |
| Disk type | SATA ← Create a new virtual disk ← **120 GB** ← Store as a single file |

بعدها من **Edit virtual machine settings**:
1. **Add ← Hard Disk ← SATA ← Use an existing virtual disk**، واختر `D:\macOS-VM\Tahoe-recovery.vmdk`. لو سألك عن التحويل، اختر **Keep Existing Format**.
2. **CD/DVD**: شيله أو خلّه فاضي.
3. **Display**: فعّل **Accelerate 3D graphics** (ما يعطيك تسريع حقيقي، بس يساعد شوي).

---

## الخطوة 6: التثبيت
1. شغّل الـ VM. لو طلعت لك قائمة الإقلاع، اختر **قرص الاستعادة** (الحجم الصغير).
2. انتظر لين يطلع **macOS Recovery** (أول مرة تاخذ وقت).
3. **Disk Utility** ← View ← Show All Devices ← اختر قرص **VMware Virtual SATA 120GB** ← **Erase**:
   - Name: `Macintosh HD`
   - Format: **APFS**
   - Scheme: **GUID Partition Map**
4. سكّر Disk Utility ← **Reinstall macOS Tahoe** ← اختر `Macintosh HD`.
5. التثبيت **ينزّل النظام كامل من الإنترنت** (حوالي 15GB)، وبيعيد التشغيل كذا مرة. كل مرة يعيد التشغيل، خله يقلع من `Macintosh HD`.
6. كمّل إعداد الحساب. تقدر تتخطى تسجيل الدخول بـ Apple ID.

---

## الخطوة 7: بعد التثبيت
1. **أطفِ الـ VM** واحذف قرص الاستعادة من الإعدادات (Remove، لا تحذف الملف من القرص).
2. **VMware Tools**: من إعدادات CD/DVD اختر `darwin.iso` (جا مع Auto-Unlocker)، وشغّل المثبت داخل macOS. بعدها روح **System Settings ← Privacy & Security** ووافق على الإضافة، ثم ريستارت.
   - هذا يحسن الماوس ودقة الشاشة. على Tahoe ممكن ما يشتغل كامل، فإذا رفض كمّل بدونه.
3. **أهم شي للسرعة**: Tahoe فيه شفافية كثيرة (Liquid Glass) والـ VM ما عنده كرت شاشة. روح **System Settings ← Accessibility ← Display** وفعّل:
   - **Reduce transparency**
   - **Reduce motion**

---

## حل المشاكل
| المشكلة | الحل |
|---|---|
| خيار Apple Mac OS X ما يطلع | Auto-Unlocker ما اشتغل. سكّر VMware وشغّله مرة ثانية كمسؤول |
| رسالة "VMware Workstation and Hyper-V are not compatible" أو بطء شديد | Hyper-V ما زال شغال. ارجع للخطوة 1 وسوّ ريستارت |
| يعلّق على شعار Apple أو يعيد التشغيل | قلل الأنوية إلى 4 وجرّب. لو استمر، جرّب Sequoia |
| Reinstall macOS يقول ما فيه إنترنت | تأكد إن الشبكة NAT، وجرّب ريستارت للـ VM |
| الشاشة صغيرة (1024×768) | ثبّت VMware Tools (الخطوة 7) |
