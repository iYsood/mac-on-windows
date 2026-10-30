# الأمان

## مصادر الملفات
السكربتات في هذا المستودع تحمّل الملفات **من مصادر رسمية فقط**:

| الملف | المصدر |
|---|---|
| صورة استعادة macOS | سيرفرات Apple (`osrecovery.apple.com`) عن طريق `macrecovery.py` |
| `macrecovery.py` و `boards.json` | [acidanthera/OpenCorePkg](https://github.com/acidanthera/OpenCorePkg) على GitHub |
| QEMU (`qemu-img`) | حزمة `SoftwareFreedomConservancy.QEMU` في winget |

**Auto-Unlocker** أداة من طرف ثالث، وهذا المستودع ما يحمّلها ولا يشغّلها. قرار استخدامها يرجع لك.

## صلاحيات المسؤول
- `disable-hyperv` و `enable-hyperv` يطلبون صلاحية المسؤول، لأن أمر `bcdedit` يحتاجها. التغيير اللي يسوونه ينعكس بسهولة.
- باقي السكربتات تشتغل بصلاحيات المستخدم العادية، إلا تثبيت QEMU عن طريق winget.

## التبليغ عن ثغرة
إذا لقيت مشكلة أمنية، مثل رابط تحميل تغيّر أو صار يحمّل ملف من مصدر غير موثوق، **لا تفتح Issue عام**. استخدم [Report a vulnerability](https://github.com/iYsood/mac-on-windows/security/advisories/new) من تبويب Security في المستودع.
