# حل المشاكل

| المشكلة | السبب | الحل |
|---|---|---|
| الـ VM يعيد التشغيل أثناء التثبيت، أو الماوس والشاشة فيها لاق شديد | **Hyper-V شغال**، والبرنامج يشتغل بالوضع البطيء (NEM) | شغّل `scripts\disable-hyperv.bat` وسوّ ريستارت |
| رسالة "VMware Workstation and Hyper-V are not compatible" | Hyper-V شغال | نفس الحل اللي فوق |
| رسالة "VT-x is not available" بعد إيقاف Hyper-V | الخاصية مقفلة في البايوس | فعّل **Intel Virtualization Technology** أو **SVM Mode** من البايوس |
| خيار Apple Mac OS X ما يظهر في VMware | Auto-Unlocker ما اشتغل | سكّر VMware بالكامل وشغّل الأداة مرة ثانية **كمسؤول** |
| يعلّق على شعار Apple | عدد الأنوية، أو تصميم المعالجات الهجينة (Intel 12th Gen وما بعده) | قلّل الأنوية إلى 4. إذا استمرت المشكلة، جرّب إصدار أقدم |
| Reinstall macOS يقول ما فيه إنترنت | إعدادات الشبكة | تأكد إن الشبكة على **NAT**، وسوّ ريستارت للـ VM |
| الشاشة صغيرة (1024×768) | VMware Tools مو مثبت | ثبّته من `darwin.iso` كما في [vmware-setup.md](vmware-setup.md#7-بعد-التثبيت) |
| النظام بطيء حتى بعد كل الإصلاحات | ما فيه تسريع رسومي (GPU) في الـ VM | فعّل **Reduce transparency** و **Reduce motion**، أو استخدم إصدار أخف |
| `prepare-macos-recovery` يقول Python not found | Python مو مثبت | ثبّته من [python.org](https://www.python.org/downloads/) وفعّل **Add to PATH** أثناء التثبيت |
| `qemu-img convert failed` | صيغة ضغط صورة الاستعادة غير مدعومة | جرّب إصدار أقدم، مثل Sequoia أو Sonoma |
