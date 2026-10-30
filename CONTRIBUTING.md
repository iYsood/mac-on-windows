# المساهمة في المشروع

شكراً لاهتمامك! أي مساهمة مرحّب فيها، سواء تصحيح خطأ، أو تجربة على جهاز جديد، أو تحسين في الشرح.

## التبليغ عن مشكلة
افتح [Issue جديد](https://github.com/iYsood/mac-on-windows/issues/new/choose) باستخدام قالب **Bug report**، واكتب فيه:
- إصدار ويندوز، والمعالج، وكرت الشاشة.
- إصدار macOS اللي تحاول تثبته، والبرنامج اللي تستخدمه (VMware أو VirtualBox).
- الخطوة اللي وقفت عندها، ونص رسالة الخطأ كامل.
- إذا تستخدم VirtualBox، أرفق آخر 100 سطر من ملف `VBox.log`.

## نجحت عندك على جهاز جديد؟
افتح Issue بقالب **Tested on my hardware**. هذا يساعدنا نعرف أي الأجهزة تشتغل عليها الطريقة.

## إرسال تعديل (Pull Request)
1. سوّ Fork للمستودع، وأنشئ فرع جديد: `git checkout -b fix/وصف-قصير`.
2. سوّ التعديل.
3. تأكد إن السكربتات سليمة:
   ```powershell
   Get-ChildItem scripts -Filter *.ps1 | ForEach-Object {
       $e = $null
       [void][System.Management.Automation.Language.Parser]::ParseFile($_.FullName, [ref]$null, [ref]$e)
       "$($_.Name): $($e.Count) errors"
   }
   ```
4. حدّث [CHANGELOG.md](CHANGELOG.md) تحت **[غير منشور]**.
5. افتح Pull Request واشرح فيه وش غيّرت وليش.

## قواعد الكتابة
- **التوثيق**: بالعربي، بأسلوب واضح ومباشر. أسماء البرامج والأوامر تبقى بالإنجليزي.
- **السكربتات**: رسائل الطباعة بالإنجليزي، عشان ما تتخرب الحروف في PowerShell 5.1.
- **المصادر**: أي ملف يتحمّل لازم يكون من مصدر رسمي، مثل Apple أو GitHub الرسمي للأداة أو winget. ممنوع أي رابط لملفات ISO أو VMDK جاهزة من مواقع مجهولة.
- **إصدار جديد من macOS**: أضف رقم اللوحة (board ID) من [recovery_urls.txt](https://github.com/acidanthera/OpenCorePkg/blob/master/Utilities/macrecovery/recovery_urls.txt) في `prepare-macos-recovery.ps1`، وأنشئ له ملف في `docs/`، وأضفه لجدول الـ README.
