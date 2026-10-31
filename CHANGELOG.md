# سجل التغييرات

كل التغييرات المهمة في المشروع تنكتب هنا. الصيغة مبنية على [Keep a Changelog](https://keepachangelog.com/).

## [غير منشور]

### أضيف
- رخصة MIT.
- `CONTRIBUTING.md` و `SECURITY.md`.
- قوالب Issues و Pull Requests.
- فحص تلقائي عن طريق GitHub Actions، يفحص صياغة سكربتات PowerShell والروابط في ملفات التوثيق.
- ملف `.editorconfig`.
- رابط رسمي لملف `darwin.iso` (VMware Tools)، وخطوات تثبيته بالتفصيل.
- علامة إن Sequoia مجرّب على VMware 17.6.2.

### تغيّر
- `.gitignore` صار يتجاهل مجلدات صور الاستعادة، وملفات الأدوات اللي تتحمّل، ومجلد auto-unlocker.

## 2026-10-30

### أضيف
- README رئيسي فيه جدول الإصدارات.
- دليل لكل إصدار من macOS: Tahoe 26 و Sequoia 15 و Sonoma 14 و Ventura 13 و Monterey 12.
- دليل للخطوات المشتركة على VMware، ودليل لـ VirtualBox.
- دليل حل المشاكل، وصفحة تشرح ليش ما ننصح بالهاكنتوش.
- سكربت `configure-virtualbox-vm` لضبط أي VM في VirtualBox.
- سكربت `prepare-macos-recovery` صار يدعم الخمس إصدارات وصيغتي `vmdk` و `vdi`.

### تغيّر
- نقل السكربتات إلى `scripts/`، والتوثيق إلى `docs/`.
- `setup-macos-vm` صار اسمه `disable-hyperv`، و `revert-macos-vm` صار اسمه `enable-hyperv`.
