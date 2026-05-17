# E-Commerce Flutter App

## Proje Repository URL

https://github.com/eminexedev/e-commerce-flutter-app

## Kısa Açıklama

Bu proje, Flutter ile geliştirilmiş basit bir e-ticaret uygulamasıdır.
Uygulamada kullanıcı girişi, ürün listeleme, ürün detayına gitme,
sepete ürün ekleme, sepetten ürün silme ve toplam tutar görüntüleme
özellikleri bulunur.

## Kullanılan Flutter Sürümü

- Flutter: 3.38.1 (stable)
- Dart: 3.10.0

## Çalıştırma Adımları

1. Projeyi klonlayın:

	git clone https://github.com/eminexedev/e-commerce-flutter-app.git

2. Proje klasörüne girin:

	cd e-commerce-flutter-app

3. Bağımlılıkları yükleyin:

	flutter pub get

4. Uygulamayı çalıştırın:

	flutter run

## Proje Yapısı
- `lib/`: Uygulamanın ana kodlarını içerir.
  - `main.dart`: Uygulamanın ana dosyası.
  - `screens/`: Farklı ekranları içerir (giriş, ürün listesi, ürün detay, sepet).
  - `models/`: Veri modellerini icerir (ürün, kullanıcı, sepet).
  - `services/`: Veri işleme ve API ile iletişim kodlarını icerir.
    - `widgets/`: Tekrar kullanilabilir widget'ları icerir.
- `assets/`: Resimler ve diğer statik dosyalar.
- `pubspec.yaml`: Proje bağımlılıklarını ve varlıklarını tanımlar.

## Özellikler
- Kullanıcı girişi ve kayıt olma
- Ürün listeleme ve arama
- Ürün detaylarını görüntüleme
- Sepete ürün ekleme ve silme
- Toplam tutar görüntüleme

