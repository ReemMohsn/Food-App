<p align="center">
  <img src="assets/splash/splash.png" alt="Recipe Finder — تطبيق اكتشاف وصفات الطعام" width="240" />
</p>

<h1 align="center">🍽️ Recipe Finder — مكتشف الوصفات</h1>

<p align="center">
  اكتشف وصفات جديدة، تعرّف على تفاصيلها، واحفظ المفضلة لديك.<br />
  مشروع تطبيقي ضمن <strong>تدريب Flutter في أكاديمية CS</strong>.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Built_with-Flutter-02569B?logo=flutter&amp;logoColor=white" alt="مبني باستخدام Flutter" />
  <img src="https://img.shields.io/badge/Language-Dart-0175C2?logo=dart&amp;logoColor=white" alt="لغة Dart" />
  <img src="https://img.shields.io/badge/Data-TheMealDB-F39C12" alt="مصدر البيانات TheMealDB" />
  <img src="https://img.shields.io/badge/CS_Academy-Training_Project-008577" alt="مشروع تدريبي في أكاديمية CS" />
</p>

<p align="center">
  <a href="#عن-التطبيق">عن التطبيق</a> ·
  <a href="#المميزات">المميزات</a> ·
  <a href="#التجربة-التعليمية">التجربة التعليمية</a> ·
  <a href="#التقنيات-المستخدمة">التقنيات المستخدمة</a> ·
  <a href="#التشغيل">التشغيل</a>
</p>

---

<a id="عن-التطبيق"></a>

## 🍴 عن التطبيق

**Recipe Finder** هو تطبيق Flutter لاستكشاف وصفات الطعام بطريقة بسيطة وسهلة. يستطيع المستخدم تصفح التصنيفات، البحث عن الوصفات، فتح تفاصيل أي وصفة، ثم حفظها في قائمة المفضلة للرجوع إليها لاحقًا.

يستخدم التطبيق [TheMealDB](https://www.themealdb.com/) كمصدر للوصفات، و[Supabase](https://supabase.com/) لإدارة حسابات المستخدمين وبيانات الملف الشخصي. تم تنفيذ المشروع كتطبيق عملي لتطبيق ما تم تعلمه خلال تدريب Flutter في **أكاديمية CS**.

<a id="المميزات"></a>

## ✨ المميزات

- 🔐 إنشاء حساب وتسجيل الدخول.
- 🔑 استعادة كلمة المرور وتحديثها عبر البريد الإلكتروني.
- 🌐 تسجيل الدخول باستخدام Google من خلال Supabase.
- 🗂️ تصفح تصنيفات الوصفات والبحث بينها.
- 🍲 عرض الوصفات حسب التصنيف.
- 📖 عرض تفاصيل الوصفة، المكونات، والتعليمات.
- ▶️ الانتقال إلى فيديو الوصفة على YouTube عند توفره.
- ❤️ إضافة الوصفات إلى المفضلة وإزالتها.
- 💾 حفظ المفضلة محليًا باستخدام `SharedPreferences`.
- 👤 عرض بيانات المستخدم وإعدادات الحساب.
- 🔄 التعامل مع التحميل والأخطاء وإتاحة إعادة المحاولة.

<a id="التجربة-التعليمية"></a>

## 📚 التجربة التعليمية

خلال تنفيذ المشروع تم تطبيق مجموعة من مفاهيم Flutter العملية، منها:

- بناء واجهات Flutter باستخدام Material Design.
- إدارة الحالة باستخدام `flutter_bloc` و`Cubit`.
- استهلاك REST API باستخدام `Dio` وتحويل البيانات إلى Models.
- فصل طبقات العرض والبيانات والمستودعات.
- استخدام حقن الاعتماديات من خلال `GetIt`.
- ربط التطبيق بـ Supabase للمصادقة.
- التعامل مع حالات النجاح، التحميل، والفشل.
- تنظيم المشروع حسب الميزات بطريقة قابلة للتوسع.

<a id="التقنيات-المستخدمة"></a>

## 🛠️ التقنيات المستخدمة

| الاستخدام | التقنية |
| :--- | :--- |
| الواجهة ولغة البرمجة | Flutter وDart |
| تصميم الواجهات | Material Design |
| إدارة الحالة | `flutter_bloc` و`Cubit` |
| جلب بيانات الوصفات | `Dio` وTheMealDB API |
| المصادقة وبيانات المستخدم | `Supabase` |
| التخزين المحلي | `SharedPreferences` |
| حقن الاعتماديات | `GetIt` |
| معالجة النتائج والأخطاء | `Dartz` |

## 🗂️ هيكل المشروع

```text
lib/
├── main.dart                         # نقطة تشغيل التطبيق
├── food_app.dart                     # إعداد التطبيق والثيم
├── core/                             # الخدمات والإعدادات المشتركة
│   ├── constants/                    # النصوص والمسارات والثوابت
│   ├── dependency_injection/         # تسجيل الاعتماديات
│   ├── networking/                   # تهيئة Supabase
│   ├── routing/                      # المسارات والتنقل
│   ├── services/                     # API والتخزين ومعالجة الأخطاء
│   └── themes/                       # الألوان والثيمات
└── features/
    ├── auth/                         # المصادقة والحسابات
    ├── favorites/                    # الوصفات المفضلة
    ├── home/                         # التصنيفات والوصفات والتفاصيل
    ├── main_home/                    # التنقل الرئيسي
    └── profile/                      # الملف الشخصي
```

<a id="التشغيل"></a>

## 🚀 التشغيل

تأكد من تثبيت Flutter وDart، ثم نفّذ الأوامر التالية من مجلد المشروع:

```bash
flutter pub get
flutter run
```

لتشغيل التطبيق على Chrome:

```bash
flutter run -d chrome
```

يتطلب التطبيق اتصالًا بالإنترنت للوصول إلى TheMealDB وSupabase. قبل التشغيل، راجع إعدادات Supabase في الملف:

[`lib/core/networking/supabase_service.dart`](lib/core/networking/supabase_service.dart)

## 🧪 الاختبار والتحليل

```bash
flutter test
flutter analyze
```

## 🔌 مصادر البيانات

يعتمد التطبيق على نقاط TheMealDB التالية:

- `categories.php` لجلب تصنيفات الوصفات.
- `filter.php` لجلب الوصفات حسب التصنيف.
- `lookup.php` لجلب تفاصيل وصفة محددة.

---

<p align="center">
  <img src="assets/splash/splash.png" alt="أكاديمية CS — تمكين رحلة التعلم" width="180" />
</p>

<p align="center">
  <strong>بُني باستخدام Flutter. صُمم بهدف التعلم.</strong><br />
  مشروع تدريبي من <a href="https://github.com/ReemMohsn">ReemMohsn</a><br />
  تدريب Flutter · أكاديمية CS
</p>
