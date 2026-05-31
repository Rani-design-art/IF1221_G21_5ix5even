# IF1221_G21_5ix5even
Tugas Besar Logika Komputasional - Kelompok G21 5ix5even K2

Mensimulasikan permainan UNI dengan Prolog. Dengan memodelkan aturan permainan dalam bentuk fakta dan rule, kami memeriksa kemungkinan langkah yang valid serta memastikan permainan berjalan sesuai dengan aturan keluarga tersebut.

---

## Anggota Kelompok

| No. | Nama | NIM |
|:---:|------|-----|
| 1 | Devina Athalia Putri Kusumah | 13525070 |
| 2 | Neysa Alya Mukhbita | 13525080 |
| 3 | Khasya Nurul Amini | 13525108 |
| 4 | Maharani Puan Satira | 13525137 |
| 5 | Josephine Bintang N.L | 13525139 |

---

## Fitur Utama

| No. | Kategori | Perintah |
|:---:|-------|-----------|
| 1 | Memulai Permainan | `startGame`, `1. Mode Klasik`, `2. Mode Turnamen` |
| 2 | Fitur Dasar | `mainkanKartu(NomorUrut)`, `ambilKartu`, `tantang`, `uni(NomorUrut)`, `saveGame`, `loadGame` |
| 3 | Fitur Khusus | `godsHand`, `sembunyikanKartu`, `tampilkanKartu` |
| 4 | Informasi | `lihatKartu`, `cekInfo` |
| 5 | Bantuan | `lihatCommand` |

## Prerequisites

Sebelum menjalankan game, pastikan Anda sudah menginstal compiler **GNU Prolog** (gprolog) di perangkat Anda.
* Unduh GNU Prolog resmi di: [http://www.gprolog.org/](http://www.gprolog.org/)

---

## Cara Menjalankan Program

1. Buka aplikasi **GNU Prolog** di terminal atau *command prompt* Anda.
2. Pastikan posisi *working directory* terminal Anda berada di *root folder* proyek ini (`IF1221_G21_5ix5even/`).
3. Lakukan kompilasi (*consult*) file utama dengan mengetikkan perintah berikut:
   ```prolog
   ['src/main.pl'].
4. Setelah muncul (`yes`), mulailah permainan dengan memanggil (`startGame`)
5. Ikuti instruksi di layar untuk memasukkan jumlah pemain dan nama pemain

---

## Struktur Repository
```text
IF1221_G21_5ix5even/
├── src/
│   ├── main.pl       (Entry Game: startGame, saveGame, loadGame, endGame)
│   └── file1.pl      (Logika Game/Fitur: kartu, validasi, efek, aksi pemain)
├── docs/
│   ├── Milestone1_G21.pdf   (Laporan progress Milestone 1)
│   ├── Milestone2_G21.pdf   (Laporan progress Milestone 2)
│   └── catatan.md           (Catatan pengerjaan kelompok)
├── .gitignore
├── LICENSE
└── README.md


```
