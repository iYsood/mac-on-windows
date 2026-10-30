# macOS 26 Tahoe

| | |
|---|---|
| السنة | 2025 |
| آخر إصدار لـ Intel | ✅ نعم، بعده macOS 27 لأجهزة Apple Silicon فقط |
| البرنامج | **VMware فقط** |
| خيار OS type في VMware | أعلى إصدار macOS يظهر عندك، غالباً macOS 15 أو 14 |
| الموارد المقترحة | 8 أنوية، 16GB رام، قرص 120GB |

## الطريقة
اتبع [vmware-setup.md](vmware-setup.md) بالكامل، واستخدم هذا الأمر في الخطوة 4:
```bat
scripts\prepare-macos-recovery.bat -Version Tahoe -OutDir D:\macOS-VM
```
السكربت يستخدم الخيار `-os latest` عشان Apple ترسل لك آخر نسخة من Tahoe.

## وش يختلف في Tahoe
- **Liquid Glass**: تصميم Tahoe فيه شفافية وتأثيرات كثيرة، والـ VM ما يستخدم كرت الشاشة. فلازم تفعّل **Reduce transparency** و **Reduce motion** بعد التثبيت، وإلا بيكون النظام ثقيل.
- **VMware Tools**: ممكن ما يشتغل كامل على Tahoe. إذا رفض، كمّل بدونه، بس بتبقى دقة الشاشة محدودة.
- **VirtualBox**: ما ننصح فيه أبداً مع Tahoe، لأنه يعلّق ويعيد التشغيل.
- **تحويل صورة الاستعادة**: طريقة `qemu-img` مجرّبة في المصادر لين Sonoma. إذا فشل التحويل مع Tahoe، استخدم [Sequoia](macos-15-sequoia.md).
