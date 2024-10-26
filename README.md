# Hướng Dẫn Cài Đặt, Biên dịch code, và Sử Dụng Ứng Dụng farm_care_ai Flutter

## Giới Thiệu

Ứng dụng này được phát triển bằng Flutter và quản lý các phiên bản Flutter thông qua Flutter Version Management (FVM).

## Yêu Cầu Hệ Thống

- [Flutter](https://flutter.dev/docs/get-started/install)
- [FVM](https://fvm.app/docs/getting_started/installation)
- [Visual Studio Code](https://code.visualstudio.com/) (khuyến nghị)
- [Android Studio](https://developer.android.com/studio) (để build Android)
- [Xcode](https://developer.apple.com/xcode/) (để build iOS, chỉ trên macOS)

## Cài Đặt

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
rename setAppName --targets ios,android --value "PlantSR"
```

(trong đó "PlantSR" là tên app mới)

## Đổi logo app:(Bỏ qua nếu ko cần)

Bước 1: Thay đổi đường dẫn đến ảnh logo mới : sửa "image_path" trong pubspec.yaml
ví dụ hiện đang dùng là : image_path: "assets/images/app_logo.png"
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
