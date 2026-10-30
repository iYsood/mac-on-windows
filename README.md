# macOS على Windows

دليل وسكربتات لتشغيل **macOS في جهاز وهمي (VM)** على ويندوز بأجهزة Intel و AMD، وبطريقة نظيفة: صورة النظام تنزل مباشرة من سيرفرات Apple، بدون ملفات ISO مجهولة المصدر.

![Platform](https://img.shields.io/badge/host-Windows%2010%20%7C%2011-0078D6?logo=windows)
![macOS](https://img.shields.io/badge/macOS-12%20→%2026-000000?logo=apple)
![VMware](https://img.shields.io/badge/VMware-Workstation%20Pro-607078?logo=vmware)

---

## المحتويات
- [البداية السريعة](#البداية-السريعة)
- [الإصدارات](#الإصدارات)
- [المتطلبات](#المتطلبات)
- [السكربتات](#السكربتات)
- [هيكل المستودع](#هيكل-المستودع)
- [أسئلة شائعة](#أسئلة-شائعة)

---

## البداية السريعة
1. **أوقف Hyper-V**: شغّل `scripts\disable-hyperv.bat`، وبعدها سوّ ريستارت.
2. **ثبّت VMware Workstation Pro**، وبعده Auto-Unlocker.
3. **جهّز صورة الاستعادة** من Apple:
   ```bat
   scripts\prepare-macos-recovery.bat -Version Tahoe -OutDir D:\macOS-VM
   ```
4. **أنشئ الـ VM وثبّت النظام**، واتبع [docs/vmware-setup.md](docs/vmware-setup.md).

---

## الإصدارات
اختر الإصدار وافتح ملفه، لأن كل ملف يوضح وش يختلف في طريقته.

| الإصدار | السنة | VMware | VirtualBox | الدليل |
|---|---|:---:|:---:|---|
| **macOS 26 Tahoe** | 2025 | ✅ | ❌ | [macos-26-tahoe.md](docs/macos-26-tahoe.md) |
| **macOS 15 Sequoia** | 2024 | ✅ | ❌ | [macos-15-sequoia.md](docs/macos-15-sequoia.md) |
| **macOS 14 Sonoma** | 2023 | ✅ | ⚠️ | [macos-14-sonoma.md](docs/macos-14-sonoma.md) |
| **macOS 13 Ventura** | 2022 | ✅ | ✅ | [macos-13-ventura.md](docs/macos-13-ventura.md) |
| **macOS 12 Monterey** | 2021 | ✅ | ✅ | [macos-12-monterey.md](docs/macos-12-monterey.md) |
| macOS 27 وما بعده | 2026 | ❌ | ❌ | لأجهزة Apple Silicon فقط |

> **ملاحظة عن الأرقام:** ما فيه macOS 16 إلى 25. Apple قفزت من الإصدار 15 إلى 26 عشان يصير الرقم مطابق للسنة.
> وإذا شفت رقم مثل **22** أو **23**، فغالباً هذا رقم نواة **Darwin** مو رقم macOS: Darwin 22 هو Ventura، و Darwin 23 هو Sonoma.

**أي إصدار أختار؟**
- تبي **أحدث إصدار** ← Tahoe 26
- تبي **حديث وسلس** في الـ VM ← Sequoia 15
- تبي **VirtualBox** ← Ventura 13 أو Monterey 12

---

## المتطلبات
| | الحد الأدنى | المقترح |
|---|---|---|
| المعالج | 4 أنوية مع VT-x أو AMD-V | 8 أنوية أو أكثر |
| الرام | 16GB | 32GB أو أكثر |
| التخزين | 100GB فاضية على SSD | NVMe |
| البرامج | Windows 10 أو 11، Python 3، winget | |

> ⚠️ macOS في الـ VM **ما يستخدم كرت الشاشة**، فتوقّع شوي بطء في الأنيميشن مهما كان جهازك قوي.

---

## السكربتات
| السكربت | وش يسوي |
|---|---|
| [`disable-hyperv.bat`](scripts/disable-hyperv.bat) | يوقف Hyper-V عشان VMware و VirtualBox يشتغلون بكامل سرعتهم |
| [`enable-hyperv.bat`](scripts/enable-hyperv.bat) | يرجّع Hyper-V، تحتاجه لـ WSL2 و Docker |
| [`prepare-macos-recovery.bat`](scripts/prepare-macos-recovery.bat) | ينزّل صورة الاستعادة من Apple ويحوّلها إلى `.vmdk` أو `.vdi` |
| [`configure-virtualbox-vm.bat`](scripts/configure-virtualbox-vm.bat) | يضبط VM في VirtualBox عشان يقلع عليه macOS |

**خيارات `prepare-macos-recovery`:**
| الخيار | القيم | الافتراضي |
|---|---|---|
| `-Version` | `Tahoe`, `Sequoia`, `Sonoma`, `Ventura`, `Monterey` | `Tahoe` |
| `-Format` | `vmdk` (VMware)، `vdi` (VirtualBox) | `vmdk` |
| `-OutDir` | أي مجلد | `%USERPROFILE%\macOS-VM` |

---

## هيكل المستودع
```
mac-on-windows/
├── README.md
├── docs/
│   ├── vmware-setup.md          # الخطوات المشتركة على VMware
│   ├── virtualbox-setup.md      # VirtualBox (Monterey و Ventura)
│   ├── macos-26-tahoe.md
│   ├── macos-15-sequoia.md
│   ├── macos-14-sonoma.md
│   ├── macos-13-ventura.md
│   ├── macos-12-monterey.md
│   ├── troubleshooting.md       # حل المشاكل
│   └── hackintosh.md            # ليش ما ننصح بالهاكنتوش
└── scripts/
    ├── disable-hyperv.bat / .ps1
    ├── enable-hyperv.bat / .ps1
    ├── prepare-macos-recovery.bat / .ps1
    └── configure-virtualbox-vm.bat / .ps1
```

---

## أسئلة شائعة
<details>
<summary><b>ليش الـ VM يعيد التشغيل أثناء التثبيت؟</b></summary>

السبب غالباً إن **Hyper-V شغال**، فيضطر VirtualBox يشتغل بوضع NEM البطيء. الحل: شغّل `disable-hyperv.bat` وسوّ ريستارت. التفاصيل في [troubleshooting.md](docs/troubleshooting.md).
</details>

<details>
<summary><b>أقدر أشغّل macOS 27؟</b></summary>

لا. macOS 27 لأجهزة Apple Silicon فقط، وما يشتغل على أي جهاز بمعالج Intel أو AMD، لا في VM ولا هاكنتوش.
</details>

<details>
<summary><b>وش عن الهاكنتوش؟</b></summary>

راجع [hackintosh.md](docs/hackintosh.md). باختصار: كروت NVIDIA غير مدعومة، والدعم بيوقف عند Tahoe 26.
</details>

<details>
<summary><b>هل هذا قانوني؟</b></summary>

اتفاقية ترخيص macOS من Apple تسمح بتشغيله فقط على أجهزة Apple. هذا المستودع لأغراض التجربة والتعليم، فاقرأ الاتفاقية وقرر بنفسك.
</details>

---

## المصادر
- [OpenCorePkg – macrecovery](https://github.com/acidanthera/OpenCorePkg/tree/master/Utilities/macrecovery): أداة تنزيل صورة الاستعادة من Apple
- [Dortania OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/)
- [QEMU](https://www.qemu.org/): أداة `qemu-img` لتحويل الصور

## جهاز التطوير
| | |
|---|---|
| المعالج | Intel Core i9-14900K |
| اللوحة الأم | MSI MAG Z790 TOMAHAWK MAX WIFI |
| الرام | 64GB |
| النظام | Windows 11 Pro |
