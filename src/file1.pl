:- dynamic(giliran_sekarang/1).
:- dynamic(giliran_ke/1). 
:- dynamic(tangan_pemain/2).
:- dynamic(discard_top/1).
:- dynamic(warna_aktif/1).
:- dynamic(sisa_kartu/1).
:- dynamic(efek_kartu/1).
:- dynamic(deck_kartu/1).
:- dynamic(urutan_pemain/1).
:- dynamic(kartu_disembunyikan/2).
:- dynamic(kartu_dibuang/1).
:- dynamic(kartu_aksi_terakhir/3).
:- dynamic(warna_sebelum_wild/1).
:- dynamic(pemain_wdf/1).

/* Facts */
warna(merah). warna(kuning). warna(hijau). warna(biru).
warna_wild(hitam).

jenis_angka(0). jenis_angka(1). jenis_angka(2). jenis_angka(3). jenis_angka(4).
jenis_angka(5). jenis_angka(6). jenis_angka(7). jenis_angka(8). jenis_angka(9).
jenis_aksi(skip). jenis_aksi(reverse). jenis_aksi(draw_two).
jenis_aksi_wild(wild). 
jenis_aksi_wild(wild_draw_four). 
jenis_aksi_wild(mimic).

/* Rules */
valid_dimainkan(kartu(hitam, wild), kartu(_,JenisAtas), _) :-
    JenisAtas \= wild,
    JenisAtas \= wild_draw_four.
valid_dimainkan(kartu(hitam, wild_draw_four), kartu(_, JenisAtas), _):-
    JenisAtas \= wild,
    JenisAtas \= wild_draw_four.
valid_dimainkan(kartu(hitam, mimic), _, _).
valid_dimainkan(kartu(Warna, _), _, Warna).
valid_dimainkan(kartu(_, Jenis), kartu(_, Jenis), _).

ambil_kartu(1, [H|_], H).
ambil_kartu(N, [_|T], KartuPilihan) :-
    N > 1,
    N1 is N - 1,
    ambil_kartu(N1, T, KartuPilihan).

hapus_kartu_ke(1, [_|T], T) :- !.
hapus_kartu_ke(N, [H|T], [H|R]) :-
    N > 1,
    N1 is N - 1,
    hapus_kartu_ke(N1, T, R).

/* Helper MAINKAN KARTU*/
input_lagi :-
    write('Tidak valid! Masukkan nomor urut kartu lain (atau ketik batal. untuk batal): '),
    read(Masukan),
    (   Masukan == batal
    ->  write('Batal memainkan kartu. Silakan lakukan aksi lain! (misal: ambilKartu).'), nl
    ;   mainkanKartu(Masukan)
    ).

update_warna_aktif(hitam) :- !,
    write('Pilih warna (merah/kuning/hijau/biru): '),
    read(WarnaBaru),
    (   warna(WarnaBaru)
    ->  retract(warna_aktif(_)),
        asserta(warna_aktif(WarnaBaru)),
        format('Warna aktif sekarang: ~w.~n', [WarnaBaru])
    ;   write('Warna tidak valid! Coba lagi.'), nl,
        update_warna_aktif(hitam)
    ).

update_warna_aktif(Warna) :-
    Warna \= hitam,
    retract(warna_aktif(_)),
    asserta(warna_aktif(Warna)).

reverse_pemain(List, Hasil) :- 
    reverseP(List, [], Hasil).

reverseP([], Acc, Acc).
reverseP([H|T], Acc, Hasil) :- 
    reverseP(T, [H|Acc], Hasil).

/* Efek Kartu Aksi */
catat_aksi_terakhir(Kartu) :-
    giliran_sekarang(Pemain),
    giliran_ke(N),
    retractall(kartu_aksi_terakhir(_, _, _)),
    asserta(kartu_aksi_terakhir(Kartu, Pemain, N)).
    
aplikasikan_efek(kartu(_, Jenis)) :-
    (jenis_angka(Jenis) ; Jenis == wild),
    !,
    pindah_giliran.
    
aplikasikan_efek(kartu(Warna, reverse)) :-
    Warna \= hitam,
    !,
    catat_aksi_terakhir(kartu(Warna, reverse)),
    retract(urutan_pemain(ListLama)),
    reverse_pemain(ListLama, ListBaru),
    asserta(urutan_pemain(ListBaru)),
    write('Kartu Reverse! Arah putaran pemain dibalik.'), nl,
    pindah_giliran.

aplikasikan_efek(kartu(Warna, skip)) :-
    Warna \= hitam,
    !,
    catat_aksi_terakhir(kartu(Warna, skip)),
    giliran_sekarang(PemainSekarang),
    urutan_pemain(List),
    pemain_selanjutnya(PemainSekarang, List, PemainTerlewati),
    format('Kartu Skip! ~w dilewati.~n', [PemainTerlewati]),
    pindah_giliran,
    pindah_giliran. 

aplikasikan_efek(kartu(Warna, draw_two)) :-
    Warna \= hitam,
    !,
    catat_aksi_terakhir(kartu(Warna, draw_two)),
    giliran_sekarang(PemainSekarang),
    urutan_pemain(List),
    pemain_selanjutnya(PemainSekarang, List, PemainKenaEfek),
    proses_ambil(PemainKenaEfek, 2),
    format('Kartu Draw Two! ~w mengambil 2 kartu dan dilewati.~n', [PemainKenaEfek]),
    pindah_giliran, 
    pindah_giliran. 

aplikasikan_efek(kartu(hitam, wild_draw_four)) :-
    catat_aksi_terakhir(kartu(hitam, wild_draw_four)),
    giliran_sekarang(PemainSekarang),
    urutan_pemain(List),
    pemain_selanjutnya(PemainSekarang, List, PemainKenaEfek),
    proses_ambil(PemainKenaEfek, 4),
    format('Kartu Draw Four! ~w mengambil 4 kartu dan dilewati.~n', [PemainKenaEfek]),
    pindah_giliran, 
    pindah_giliran. 

aplikasikan_efek(kartu(hitam, mimic)) :- !,
    write('Menelusuri riwayat permainan.'), nl,
    (   kartu_aksi_terakhir(KartuAksi, OlehSiapa, GiliranAksi)
    ->  KartuAksi = kartu(WA, JA),
        giliran_ke(NSekarang),
        SelisihGiliran is NSekarang - GiliranAksi,
        format('Kartu aksi terakhir yang dimainkan: ~w-~w (oleh ~w, ~w giliran lalu)~n',
               [WA, JA, OlehSiapa, SelisihGiliran]),
        format('Kartu mimic menyalin efek ~w!~n', [JA]),
        aplikasikan_efek_mimic(KartuAksi)
    ;   write('Belum ada kartu aksi sebelumnya. Mimic berlaku seperti wild.'), nl,
        update_warna_aktif(hitam),
        pindah_giliran
    ).

aplikasikan_efek_mimic(kartu(Warna, reverse)) :-
    Warna \= hitam, !,
    retract(urutan_pemain(ListLama)),
    reverse_pemain(ListLama, ListBaru),
    asserta(urutan_pemain(ListBaru)),
    write('Kartu Reverse! Arah putaran pemain dibalik.'), nl,
    pindah_giliran.

aplikasikan_efek_mimic(kartu(Warna, skip)) :-
    Warna \= hitam, !,
    giliran_sekarang(PemainSekarang),
    urutan_pemain(List),
    pemain_selanjutnya(PemainSekarang, List, PemainTerlewati),
    format('Kartu Skip! ~w dilewati.~n', [PemainTerlewati]),
    pindah_giliran,
    pindah_giliran.

aplikasikan_efek_mimic(kartu(Warna, draw_two)) :-
    Warna \= hitam, !,
    giliran_sekarang(PemainSekarang),
    urutan_pemain(List),
    pemain_selanjutnya(PemainSekarang, List, PemainKenaEfek),
    proses_ambil(PemainKenaEfek, 2),
    format('Kartu Draw Two! ~w mengambil 2 kartu dan dilewati.~n', [PemainKenaEfek]),
    pindah_giliran,
    pindah_giliran.

aplikasikan_efek_mimic(kartu(hitam, wild_draw_four)) :- !,
    giliran_sekarang(PemainSekarang),
    urutan_pemain(List),
    pemain_selanjutnya(PemainSekarang, List, PemainKenaEfek),
    proses_ambil(PemainKenaEfek, 4),
    format('Kartu Wild Draw Four! ~w mengambil 4 kartu dan dilewati.~n', [PemainKenaEfek]),
    pindah_giliran,
    pindah_giliran.

aplikasikan_efek_mimic(_) :- pindah_giliran.

/* MAINKAN KARTU */
mainkanKartu(NomorUrutKartudiTangan) :-
    giliran_sekarang(Pemain),
    tangan_pemain(Pemain, ListKartu),
    (   ambil_kartu(NomorUrutKartudiTangan, ListKartu, KartuPilihan)
    ->  discard_top(KartuAtas),
        warna_aktif(WarnaAktif),
        (   valid_dimainkan(KartuPilihan, KartuAtas, WarnaAktif)
        ->  KartuPilihan = kartu(WarnaKartu, JenisKartu),
            format('~w memainkan kartu: ~w-~w.~n', [Pemain, WarnaKartu, JenisKartu]),

            hapus_kartu_ke(NomorUrutKartudiTangan, ListKartu, ListKartuBaru),
            retract(tangan_pemain(Pemain, _)),
            asserta(tangan_pemain(Pemain, ListKartuBaru)),

            retractall(kartu_dibuang(_)),
            asserta(kartu_dibuang(KartuAtas)),
            
            retract(discard_top(_)),
            asserta(discard_top(KartuPilihan)),
            
            (KartuPilihan = kartu(hitam, wild_draw_four) ->
                retractall(pemain_wdf(_)),
                asserta(pemain_wdf(Pemain))
            ; true),

            (WarnaKartu == hitam -> 
                warna_aktif(WarnaSaatIni),
                retractall(warna_sebelum_wild(_)),
                asserta(warna_sebelum_wild(WarnaSaatIni))
            ; true),

            update_warna_aktif(WarnaKartu),
            aplikasikan_efek(KartuPilihan)
        ;   write('Kartu tidak valid! Warna atau jenisnya tidak sesuai.'), nl,
            input_lagi
        )   ;   write('Nomor urut tidak valid! Anda tidak memiliki kartu di posisi tersebut.'), nl,
        input_lagi
    ).

/* AMBIL KARTU */
ambilKartu :-
    giliran_sekarang(Pemain),
    efek_kartu(Eff),
    (Eff == draw2 -> N = 2;
     Eff == draw4 -> N = 4;
     N = 1),
    proses_ambil(Pemain, N),
    retract(efek_kartu(_)),
    asserta(efek_kartu(none)),
    format('~w mendapatkan kartu.~n', [Pemain]),
    pindah_giliran.

proses_ambil(_,0) :- !.
proses_ambil(Pemain, N) :-
    retractall(status_uni(Pemain)),
    retract(deck_kartu([H|T])),
    retract(tangan_pemain(Pemain, Tangan)),
    append(Tangan, [H], Tangan1),
    asserta(tangan_pemain(Pemain, Tangan1)),
    asserta(deck_kartu(T)),
    N1 is N - 1,
    proses_ambil(Pemain, N1).

pindah_giliran :-
    retract(giliran_sekarang(Pemain)),
    urutan_pemain(Urutan),
    pemain_selanjutnya(Pemain, Urutan, Pemain1),
    asserta(giliran_sekarang(Pemain1)),
    % increment counter giliran
    retract(giliran_ke(N)),
    N1 is N + 1,
    asserta(giliran_ke(N1)),
    format('Giliran ~w.~n', [Pemain1]).

get_element([Element|_], 0, Element).
get_element([_|Tail], Index, Element) :-
    Index > 0,
    NewIndex is Index - 1,
    get_element(Tail, NewIndex, Element).

get_indeks([Element|_], Element, 0).
get_indeks([_|Tail], Element, Indeks):-
    get_indeks(Tail, Element, Indeks1),
    Indeks is Indeks1 + 1.

pemain_selanjutnya(Sebelum, List, Sesudah) :- 
    get_indeks(List, Sebelum, Indeks),
    length(List, Len),
    Indeks1 is (Indeks + 1) mod Len,
    get_element(List, Indeks1, Sesudah).

/* LIHAT COMMAND */
lihatCommand :-
    efek_kartu(Eff),
    write('Aksi utama yang tersedia:'), nl,
    tampilkan_aksi_utama(Eff),
    nl,
    write('Aksi pendukung yang tersedia:'), nl,
    write('1. lihatCommand'), nl,
    write('2. lihatKartu'), nl,
    write('3. cekInfo'), nl.
 
tampilkan_aksi_utama(draw_two) :- !,
    write('1. ambilKartu'), nl.
 
tampilkan_aksi_utama(draw_four) :- !,
    write('1. ambilKartu'), nl,
    write('2. tantang'), nl.
 
tampilkan_aksi_utama(_) :-
    write('1. mainkanKartu(NomorUrut)'), nl,
    write('2. ambilKartu'), nl,
    write('3. tantang'), nl,
    write('4. uni(NomorUrut)'), nl,
    write('5. godsHand'), nl,
    write('6. sembunyikanKartu(NomorUrut)'), nl,
    write('7. tampilkanKartu'), nl.
 
/* LIHAT KARTU */
lihatKartu :-
    giliran_sekarang(Pemain),
    tangan_pemain(Pemain, ListKartu),
    write('Berikut kartu yang anda miliki.'), nl,
    tampilkan_list_kartu(ListKartu, Pemain, 1).
 
tampilkan_list_kartu([], _, _) :- !.
 
tampilkan_list_kartu([kartu(Warna, Jenis) | Sisa], Pemain, N) :-
    (   kartu_disembunyikan(Pemain, kartu(Warna, Jenis))
    ->  format('~w. ~w-~w (disembunyikan)~n', [N, Warna, Jenis])
    ;   format('~w. ~w-~w~n', [N, Warna, Jenis])
    ),
    N1 is N + 1,
    tampilkan_list_kartu(Sisa, Pemain, N1).
 
/* CEK INFO */
cekInfo :-
    discard_top(kartu(Warna, Jenis)),
    format('Kartu discard top: ~w-~w.', [Warna, Jenis]), nl,
    nl,
 
    urutan_pemain(ListPemain),
    write('Urutan pemain: '),
    cetak_urutan_pemain(ListPemain), nl,
    nl,
 
    cetak_info_semua_pemain(ListPemain, 1).
 
cetak_urutan_pemain([]).
cetak_urutan_pemain([P]) :- !, write(P), write('.').
cetak_urutan_pemain([P|Sisa]) :-
    write(P), write(' - '),
    cetak_urutan_pemain(Sisa).
 
cetak_info_semua_pemain([], _) :- !.
cetak_info_semua_pemain([Pemain|Sisa], N) :-
    tangan_pemain(Pemain, ListKartu),
    length(ListKartu, JumlahKartu),
    format('Nama pemain ~w: ~w~n', [N, Pemain]),
    format('Jumlah kartu : ~w~n', [JumlahKartu]),
    nl,
    N1 is N + 1,
    cetak_info_semua_pemain(Sisa, N1).

/* TANTANG */
pemain_sebelumnya(Sesudah, List, Sebelum):-
    get_indeks(List, Sesudah, Indeks),
    length(List, Len),
    (Indeks =:= 0 -> IndeksSebelum is Len - 1; IndeksSebelum is Indeks - 1),
    get_element(List, IndeksSebelum, Sebelum).

punya_kartu_valid(Pemain, kartu(Warna, Jenis)):-
    tangan_pemain(Pemain, ListKartu),
    member(Kartu, ListKartu),
    Kartu \= kartu(hitam, wild),
    Kartu \= kartu(hitam, wild_draw_four),
    (Kartu = kartu(Warna,_);Kartu = kartu(_,Jenis)).

tantang:-
    write('Tantangan dilakukan!'), nl,
    giliran_sekarang(Sesudah),
    pemain_wdf(Sebelum),
    format('Memeriksa kartu ~w...~n', [Sebelum]),
    
    warna_sebelum_wild(WarnaSebelum),
    KartuCek = kartu(WarnaSebelum, dummy),
    (punya_kartu_valid(Sebelum, KartuCek)->
        tantangBerhasil(Sebelum);tantangGagal(Sesudah)),
    retract(efek_kartu(_)),
    asserta(efek_kartu(none)),
    retractall(pemain_wdf(_)),
    pindah_giliran.

tantangBerhasil(Pemain):-
    proses_ambil(Pemain, 4),
    format('Tantangan berhasil. ~w mendapatkan 4 kartu acak.~n', [Pemain]).

tantangGagal(Pemain):-
    proses_ambil(Pemain, 6),
    format('Tantangan gagal. ~w mendapatkan 6 kartu acak.~n', [Pemain]).

/* UNI: NomorUrutKartudiTangan */

uni(NomorUrut) :-
    giliran_sekarang(Pemain),
    tangan_pemain(Pemain, ListKartu),
    length(ListKartu, JumlahDiTangan),
  
    (   kartu_disembunyikan(Pemain, _)
    ->  JumlahSembunyi = 1
    ;   JumlahSembunyi = 0
    ),
    TotalKartu is JumlahDiTangan + JumlahSembunyi,
    
    (   TotalKartu \= 2
    ->  write('Gagal deklarasi UNI! Anda hanya bisa menggunakan perintah ini jika total kartu Anda sisa 2.'), nl, !, fail
    ;   true
    ),

    (   ambil_kartu(NomorUrut, ListKartu, KartuPilihan)
    ->  discard_top(KartuAtas),
        warna_aktif(WarnaAktif),
        
        % cek valid
        (   valid_dimainkan(KartuPilihan, KartuAtas, WarnaAktif)
        ->  KartuPilihan = kartu(WarnaKartu, JenisKartu),
  
            format('~w berteriak: "UNI!!!"~n', [Pemain]),
            format('~w memainkan kartu: ~w-~w.~n', [Pemain, WarnaKartu, JenisKartu]),

            % catat status UNI
            asserta(status_uni(Pemain)),

            hapus_kartu_ke(NomorUrut, ListKartu, ListKartuBaru),
            retract(tangan_pemain(Pemain, _)),
            asserta(tangan_pemain(Pemain, ListKartuBaru)),

            retractall(kartu_dibuang(_)),
            asserta(kartu_dibuang(KartuAtas)),
            retract(discard_top(_)),
            asserta(discard_top(KartuPilihan)),

            (WarnaKartu == hitam -> 
                warna_aktif(WarnaSaatIni),
                retractall(warna_sebelum_wild(_)),
                asserta(warna_sebelum_wild(WarnaSaatIni))
            ; true),

            update_warna_aktif(WarnaKartu),
            aplikasikan_efek(KartuPilihan)
        ;   write('Kartu tidak valid! Warna atau jenisnya tidak sesuai dengan meja.'), nl
        )
    ;   write('Nomor urut tidak valid! Anda tidak memiliki kartu di posisi tersebut.'), nl
    ).

/* BONUS: SembunyikanKartu */
% menyembunyikan kartu
sembunyikanKartu(NomorUrut) :-
    giliran_sekarang(Pemain),
    tangan_pemain(Pemain, ListKartu),
    length(ListKartu, Jumlah),
    (
        Jumlah =:= 1 -> 
        write('Gagal: Kamu hanya memiliki satu buah kartu, tidak bisa disembunyikan!'), nl, !
    ;
        kartu_disembunyikan(Pemain, _) ->
        write('Gagal: Kamu sudah menyembunyikan sebuah kartu!'), nl, !
    ;
        ambil_elemen_ke(NomorUrut, ListKartu, KartuYgDipilih) ->
        asserta(kartu_disembunyikan(Pemain, KartuYgDipilih)),
        KartuYgDipilih = kartu(Warna, Jenis),
        format('Kartu ~w-~w berhasil disembunyikan.~n', [Warna, Jenis]), !
    ;
        write('Gagal: Nomor urut kartu tidak valid!'), nl
    ).

% helper mengambil elemen
ambil_elemen_ke(1, [H|_], H) :- !.
ambil_elemen_ke(N, [_|T], Elem) :-
    N > 1,
    N1 is N - 1,
    ambil_elemen_ke(N1, T, Elem).

% menampilkan kembali kartu
tampilkanKartu :-
    giliran_sekarang(Pemain),
    (
        retract(kartu_disembunyikan(Pemain, KartuYgDisembunyikan)) ->
        KartuYgDisembunyikan = kartu(Warna, Jenis),
        format('Kartu ~w-~w berhasil ditampilkan dan kembali normal.~n', [Warna, Jenis]), !
    ;
        write('Kamu tidak sedang menyembunyikan kartu apapun.'), nl
    ).

/* HELPER GOD'S HAND */
/* Cek semua kartu satu */
semua_kartu_satu:-
    urutan_pemain(List),
    cek_semua_satu(List).

cek_semua_satu([]).

cek_semua_satu([Pemain|Pemain1]):-
    tangan_pemain(Pemain, Tangan),
    length(Tangan, 1),
    cek_semua_satu(Pemain1).

/* Pilih pemain acak */
pilih_pemain_acak(Pemain):-
    urutan_pemain(List),
    length(List, N),
    random(N, I),
    Pos is I + 1,
    ambil_kartu(Pos, List, Pemain),

    tangan_pemain(Pemain, Tangan),
    length(Tangan, Len),
    Len > 1, 
    !.

pilih_pemain_acak(Pemain):-
    pilih_pemain_acak(Pemain).

/* Pilih kartu acak */
pilih_kartu_acak(Pemain, Pos, Kartu):-
    tangan_pemain(Pemain, Tangan),
    length(Tangan, N),
    random(N, I),
    Pos is I + 1,
    ambil_kartu(Pos, Tangan, Kartu).

/* Pilih pemain tujuan */
pemain_tujuan(Pemain, Tujuan):-
    urutan_pemain(List),
    length(List, N),
    random(N, I),
    Pos is I + 1,
    ambil_kartu(Pos, List, Tujuan),

    Pemain \= Tujuan,
    !.

pemain_tujuan(Pemain, Tujuan):-
    pemain_tujuan(Pemain, Tujuan).

/* Pindahkan kartu */
pindah_kartu(Pemain, Tujuan, PosisiKartu, KartuPilihan):-
    tangan_pemain(Pemain, Tangan),
    hapus_kartu_ke(PosisiKartu, Tangan, TanganBaru),

    retract(tangan_pemain(Pemain, _)),
    asserta(tangan_pemain(Pemain, TanganBaru)),

    tangan_pemain(Tujuan, TanganTujuan),
    append(TanganTujuan, [KartuPilihan], TanganTujuanBaru),

    retract(tangan_pemain(Tujuan, _)),
    asserta(tangan_pemain(Tujuan, TanganTujuanBaru)).

/* BONUS: GOD'S HAND */
godsHand:-
    semua_kartu_satu,
    write('godsHand tidak bisa dijalankan!'), nl,
    !.

godsHand:-
    random(100, X),
    X >= 20,
    write('Tuhan tidak telah berkehendak.'), nl,
    !.

godsHand:-
    pilih_pemain_acak(Pemain),
    pilih_kartu_acak(Pemain, Pos, Kartu),
    pemain_tujuan(Pemain, Tujuan),
    pindah_kartu(Pemain, Tujuan, Pos, Kartu),

    Kartu = kartu(Warna, Jenis),

    write('Tuhan telah berkehendak.'), nl,
    format('Kartu ~w-~w milik ~w berpindah ke tangan ~w.~n', [Warna, Jenis, Pemain, Tujuan]).
    
