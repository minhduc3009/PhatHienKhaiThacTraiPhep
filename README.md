# Hướng Dẫn Cài Đặt, Biên dịch code, và Sử Dụng Ứng Dụng farm_care_ai Flutter

## Giới Thiệu

Ứng dụng này được phát triển bằng Flutter và quản lý các phiên bản Flutter thông qua Flutter Version Management (FVM).

## Yêu Cầu Hệ Thống

- [Flutter](https://flutter.dev/docs/get-started/install)
- [FVM](https://fvm.app/docs/getting_started/installation)
- [Visual Studio Code](https://code.visualstudio.com/) (khuyến nghị)
- [Android Studio](https://developer.android.com/studio) (để build Android)
- [Xcode](https://developer.apple.com/xcode/) (để build iOS, chỉ trên macOS)

# Cài Đặt Các Công Cụ Cần
## FVM : Công cụ quản lý phiên bản
### Bước 1: Cài Đặt FVM : Flutter Version Management (FVM)

Nếu bạn chưa cài đặt FVM, hãy cài đặt bằng lệnh sau:

```bash
dart pub global activate fvm
```

### Bước 2: Cài Đặt Phiên Bản Flutter

Tại thư mục gốc của dự án, cài đặt phiên bản Flutter đã được chỉ định trong file `farm_care_ai\.fvmrc`: (khuyến nghị hiện tại sử dụn "flutter": "3.22.2")

```bash
fvm install 3.22.2
```

### Bước 3: Thiết Lập Phiên Bản Flutter

Chọn phiên bản Flutter để sử dụng cho dự án:

```bash
fvm use 3.22.2
```

### Bước 4: Cài Đặt Các Gói Thư Viện

Chạy lệnh sau để cài đặt các gói thư viện:

```bash
fvm flutter pub get
```

## Đổi Tên Ứng Dụng (Bỏ qua nếu ko cần)

```bash
fvm flutter pub global activate rename
rename setAppName --targets ios,android --value "AIoT-Nano"
```

(trong đó "AIoT-Nano" là tên app mới)

## Đổi logo app:(Bỏ qua nếu ko cần)

Bước 1: Thay đổi đường dẫn đến ảnh logo mới : sửa "image_path" trong pubspec.yaml
ví dụ hiện đang dùng là : image_path: "assets/images/AIoT-Nano_logo.jpg"
Sau khi sửa logo chạy lệnh sau để áp dụng:

```bash
fvm flutter pub run flutter_launcher_icons
```

## Chạy Ứng Dụng

### Chạy Trên Thiết Bị Thực Hoặc Trình Giả Lập

Để chạy ứng dụng trên thiết bị thực hoặc trình giả lập, sử dụng lệnh sau:

```bash
fvm flutter run
```

### Xây Dựng Ứng Dụng --> Tạo file apk

#### Android

##### Tạo ra các tệp APK cho ứng dụng mà mỗi tệp tương ứng với một ABI khác nhau

```bash
fvm flutter build apk --split-per-abi
```

ABI (Application Binary Interface) là một chuẩn mà hệ thống Android sử dụng để chạy và tương tác với mã nhị phân của ứng dụng.
Có nhiều loại ABI khác nhau tương ứng với các loại bộ vi xử lý khác nhau

- armeabi-v7a cho bộ vi xử lý ARM 32-bit,
- arm64-v8a cho bộ vi xử lý ARM 64-bit, <--- Chọn cái này để copy vào điện thoại và cài đặt
- x86_64 cho bộ vi xử lý Intel 64-bit

##### Để xây dựng APK ở chế độ release:

(tạo ra một APK lớn hơn hoạt động trên tất cả các thiết bị nhưng có thể yêu cầu nhiều dung lượng và dữ liệu hơn để tải và cài đặt.)

```bash
fvm flutter build apk --release
```

#### iOS

Để xây dựng IPA ở chế độ release:

```bash
fvm flutter build ios --release
```

==========================================================================
# Hướng Dẫn FireBase và Flutter
Để kết nối ứng dụng Flutter với Firebase, bạn cần cài đặt và cấu hình công cụ Firebase CLI và FlutterFire CLI. 
Dưới đây là các bước hướng dẫn chi tiết:

### Bước 1: Cài đặt Firebase CLI

1. Tải Firebase CLI bằng cách chạy lệnh sau (yêu cầu cài đặt **Node.js** trước):

   ```bash
   npm install -g firebase-tools
   ```

2. Đăng nhập vào Firebase bằng cách sử dụng lệnh:

   ```bash
   firebase login
   ```

3. Đảm bảo rằng bạn đã tạo một dự án Firebase trên [Firebase Console](https://console.firebase.google.com/).

### Bước 2: Cài đặt FlutterFire CLI

1. Tiếp theo, cài đặt FlutterFire CLI bằng cách chạy lệnh sau:

   ```bash
   dart pub global activate flutterfire_cli
   ```

2. Sau khi cài đặt, hãy đảm bảo `flutterfire` có thể được truy cập từ terminal của bạn bằng cách thêm `~/.pub-cache/bin` vào PATH của bạn (nếu cần).

### Bước 3: Chạy lệnh `flutterfire configure`

1. Trong thư mục dự án Flutter, chạy lệnh `flutterfire configure`:

   ```bash
   flutterfire configure
   ```

2. Công cụ sẽ yêu cầu bạn chọn dự án Firebase mà bạn muốn liên kết với ứng dụng Flutter của mình. Nếu bạn đã có nhiều dự án trên Firebase, hãy chọn dự án phù hợp.

3. Sau đó, `flutterfire configure` sẽ tự động tạo file `firebase_options.dart` chứa cấu hình cho Firebase, được đặt trong thư mục `lib/`.

### Bước 4: Cấu hình Firebase trong ứng dụng Flutter

1. Mở file `main.dart`, sau đó import `firebase_options.dart` và khởi tạo Firebase:

   ```dart
   import 'package:firebase_core/firebase_core.dart';
   import 'firebase_options.dart';

   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform,
     );
     runApp(MyApp());
   }
   ```

2. Đảm bảo thêm các package Firebase cần thiết vào `pubspec.yaml`. Ví dụ, nếu bạn muốn sử dụng Firebase Authentication:

   ```yaml
   dependencies:
     firebase_core: latest_version
     firebase_auth: latest_version
   ```

3. Chạy lệnh `flutter pub get` để cài đặt các package Firebase đã thêm.

### Bước 5: Kiểm tra kết nối

1. Chạy ứng dụng Flutter và kiểm tra xem Firebase đã được kết nối thành công chưa.
2. Bạn có thể sử dụng Firebase Console để kiểm tra hoạt động của ứng dụng và kiểm tra xem có dữ liệu hay sự kiện nào được gửi lên không.

### Một số lưu ý khi sử dụng `flutterfire configure`

- `flutterfire configure` tự động thiết lập cấu hình Firebase cho nhiều nền tảng (iOS, Android, Web).
- Khi cấu hình Firebase cho iOS, bạn cần đảm bảo cấu hình `ios/Runner/Info.plist` phù hợp, và với Android thì `android/app/google-services.json` cũng sẽ được tạo.
  
Sử dụng `flutterfire configure` giúp đơn giản hóa việc thiết lập Firebase, nhanh chóng kết nối ứng dụng Flutter với Firebase mà không cần phải cấu hình thủ công.