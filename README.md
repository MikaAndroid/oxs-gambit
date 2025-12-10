# 🛠️ Panduan Pembuatan Level (Level Creation Guide)

Panduan ini menjelaskan langkah-langkah untuk membuat level baru dalam game **oxs-gambit**. Game ini dikembangkan menggunakan Godot 4. Level dibangun menggunakan kombinasi `TileMapLayer` untuk lingkungan dan berbagai `PackedScene` untuk mekanik puzzle.

## 1. Persiapan Scene Baru
1. Buka Godot Editor.
2. Buat **Scene** baru dan pilih **Node2D** sebagai root node.
3. Ubah nama root node menjadi nama level Anda (contoh: `Level_3`).
4. Simpan scene tersebut di dalam folder `res://scenes/` (contoh: `res://scenes/level_3.tscn`).

## 2. Menambahkan Player dan Kamera
Agar level bisa dimainkan, karakter utama harus ditambahkan ke dalam scene.
1. Cari scene `res://scenes/player.tscn` di tab FileSystem.
2. Drag & drop scene tersebut ke dalam scene level baru Anda.
3. **Penting:** Pastikan posisi `Player` tidak berada di dalam tembok (TileMap) agar tidak tersangkut.
4. Tambahkan node **Camera2D** sebagai child dari root level.
   - Atur properti `Zoom` pada Camera2D ke `(2, 2)` untuk tampilan pixel art yang optimal (sesuai referensi `world.tscn`).

## 3. Membangun Lingkungan (TileMap)
Kita menggunakan `TileMapLayer` untuk membuat lantai dan tembok.
1. Tambahkan node **TileMapLayer** ke dalam scene.
2. Pada Inspector `TileMapLayer`, cari properti **Tile Set**.
3. Masukkan resource `res://tilesets/dungeon.tres` ke dalam properti tersebut.
4. Gunakan tab **TileMap** di panel bawah untuk mulai menggambar level.
   - Gunakan tile tembok untuk pembatas.
   - Gunakan tile lantai untuk area pijakan.
   - *Catatan:* Tile tembok sudah memiliki collision shape yang diatur dalam `dungeon.tres`.

## 4. Menambahkan Objek Puzzle
Mekanik utama game ini melibatkan kotak (Box), pintu, dan pelat tekanan.

### A. Menambahkan Kotak (Box)
Kotak adalah objek fisik yang bisa diangkat atau diubah ukurannya oleh pemain.
1. Instance scene `res://scenes/box.tscn` ke dalam level.
2. **Mekanik:** Pemain bisa mengubah ukuran kotak (Kecil/Besar) dengan klik kiri mouse.
   - **Kotak Kecil:** Ringan, bisa dibawa, bisa dilempar.
   - **Kotak Besar:** Berat, digunakan untuk menahan tombol (pressure plate) atau sebagai pijakan tinggi.

### B. Membuat Pintu & Tombol (Pressure Plate)
Untuk membuat puzzle di mana kotak harus diletakkan di atas tombol untuk membuka pintu:
1. Instance scene `res://scenes/pressure_plate.tscn`.
2. Instance scene `res://scenes/door.tscn`.
3. Letakkan pintu di jalur yang ingin ditutup.
4. Letakkan pressure plate di lokasi puzzle.
5. **Menghubungkan Logika:**
   - Klik node `pressure_plate` yang baru dibuat.
   - Lihat bagian **Inspector** di sebelah kanan.
   - Cari variabel **Door To Open**.
   - Klik "Assign" dan pilih node `door` yang ingin dibuka oleh tombol tersebut.

### C. Menambahkan Jebakan (Spikes)
Jebakan akan membunuh pemain dan mereset posisi pemain.
1. Instance scene `res://spike.tscn` (berada di root folder).
2. Letakkan di lantai atau area berbahaya.
3. Jika pemain menyentuh ini, fungsi `die()` akan dipanggil dan pemain kembali ke posisi awal.

## 5. Menentukan Akhir Level (End Flag)
Setiap level harus memiliki titik finish untuk pindah ke level berikutnya.
1. Instance scene `res://scenes/endflag.tscn`.
2. Letakkan di akhir rute level.
3. Klik node `endflag`.
4. Di **Inspector**, cari variabel **Next Level Path**.
5. Isi dengan path file level selanjutnya (contoh: `res://scenes/level_4.tscn`).

## 6. Integrasi Level
Setelah level baru (misalnya Level 3) selesai dibuat, update level sebelumnya (Level 2) agar mengarah ke level baru.
1. Buka `res://scenes/level_2.tscn`.
2. Klik node `endflag` di level tersebut.
3. Ubah **Next Level Path** agar mengarah ke level baru Anda (`res://scenes/level_3.tscn`).

---

### Tips Desain Level
* **Physics:** Karena `Box` menggunakan RigidBody2D, pastikan lantai rata agar kotak tidak menggelinding sendiri.
* **Jumps:** `Jump Force` pemain diatur sekitar 500 (atau 700 di beberapa konfigurasi scene). Tes jarak lompatan agar rintangan bisa dilewati namun tetap menantang.
* **Box Puzzle:** Manfaatkan perubahan ukuran box. Gunakan celah sempit yang hanya muat box kecil, atau tombol yang hanya bisa ditekan box besar (karena massanya lebih berat).
