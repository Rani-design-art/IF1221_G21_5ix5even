% File utama program
% fitur startGame (Bintang & Neysa)

:- include('file1.pl').
:- dynamic(status_uni/1).
:- dynamic(arah_permainan/1).
:- dynamic(kartu_disembunyikan/2).

startGame :-
    % bersihin state dari sisa game sebelumnya (kalau ada)
    retractall(kartu_aksi_terakhir(_)),
    retractall(urutan_pemain(_)),
    retractall(giliran_sekarang(_)),
    retractall(efek_kartu(_)),
    retractall(deck_kartu(_)),
    retractall(discard_top(_)),
    retractall(warna_aktif(_)),
    retractall(tangan_pemain(_, _)),
    retractall(arah_permainan(_)),
    retractall(status_uni(_)),
    retractall(kartu_disembunyikan(_, _)),
    asserta(arah_permainan(kanan)),

    % minta input jumlah sm nama pemain
    input_jumlah_pemain(N),
    input_nama_pemain(N, [], ListPemain),

    % simpan data ke state game
    asserta(urutan_pemain(ListPemain)),
    ListPemain = [PemainPertama|_], 
    asserta(giliran_sekarang(PemainPertama)),
    asserta(efek_kartu(none)),

    % feedback ke terminal biar tau sukses
    nl, write('                  .=**-.=%%*:    -=*+.:==.'), nl,
    write('                   @+::=@#::=%.  *%::-#@--%='), nl,
    write('                  .@*:::::::+#.  *%:::::::%#'), nl,
    write('                   :@%=-::=%+    :%%-:::-##'), nl,
    write('                     :*@@@%:       -#%#%#:'), nl,
    write('                       #+           :#-'), nl,
    write('                      :@%#+.        +#-:'), nl,
    write('             .--:.    .%#*#        +@#*# .-+++-.'), nl,
    write('           .##=:-#%+  :%:          #+.. +%-..-#@+'), nl,
    write('           @*     =@=-%@@@@@@@@@@@@@%+.:%-     =%:        Game berhasil disetup!'), nl,
    write('           %=     =%*=.             .=*#%=     -%:           Selamat bermain~'), nl,
    write('            =#:                                =%-'), nl,
    write('          *%#-                                :*'), nl,
    write('        =@#                                    .#@:                  ..'), nl,
    write('      :%%:                                       .*@*               .:=#+'), nl,
    write('    .*@+            -##*+:           =#%#*+        :%%.            :+#+ +='), nl,
    write('    +@-                                             :#@.              *#'), nl,
    write('   #@-               ...               ..            .%@:  *@%%%@*'), nl,
    write('  +@-             =@%=:*%-          -%%++%%-          =@*-@*::::=@+===-:'), nl,
    write(' -@#             -@@#==#@%.        .%@*.  #%.          %@@*:::::-%#-:-*@+'), nl,
    write(' +@:         .....%%=@%@@*         .%@*@@%@%           *@@-::::::::::::=%:'), nl,
    write(' *%.      .%*-%+--:-*%%%=           :#%#@@#:=+:=--:    -@@+::::::::::::=%-'), nl,
    write('.#%      .#=-#==%-##          +@-      .:..+#-%#=%*%.  :@@@-::::::::::=@+'), nl,
    write('.#%.      ..:::=::-.       %#*@@=--       .=:=+:==%-   :@=*@-:::::::+%@*'), nl,
    write(' +@.                            ..          ......     *@- @@+++#%@@#:'), nl,
    write('  *@:                                                 *%=%=.%+'), nl,
    write('   #%-                                               +@-@=:@*'), nl,
    write('    :%#.                                           .*@@@==@-'), nl,
    write('     .+@#:                                        =@*:##*%-'), nl,
    write('       :%-                                       .-.  -#+'), nl,
    write('       =%: :%-                                      *@:'), nl,
    write('       +%: :%-                                   .##:'), nl,
    write('       .#*+%*.                                   +@'), nl,
    write('         ..=%:                                  -@-'), nl,
    write('          *@@@=                                -@='), nl,
    write('         :#  -@#.                            .#%:'), nl,
    write('          =*#**+%#:                        :*%='), nl,
    write('                 -#@*:                  =#%*:'), nl,
    write('                    .=*%%+  .+.  -+**%%#-'), nl,
    write('                        :%= :%*  *%'), nl,
    write('                         +%..#* =@:'), nl,
    write('                          .===*@+'), nl,
    format('Pemain: ~w~n', [ListPemain]),
    format('Giliran awal: ~w~n', [PemainPertama]),
    nl,
    
    % logic mengacak deck & membagikan kartu
    write('                                                                                                    '), nl,
    write('                                                                                                    '), nl,
    write('                                                                                                    '), nl,
    write('                                                                                                    '), nl,
    write('                                                                                                    '), nl,
    write('                                *@@@@@@@@@@@@#-                                                     '), nl,
    write('                           +@@@@@@@@@@@@@@@@@@@@@@@:                                                '), nl,
    write('                        @@@@@@@@@@*+-==+@@@@@@@@@@@@@@-                                             '), nl,
    write('                     %@@@@@@@@@@@    .:=+*:     =@@@@@@@@                                           '), nl,
    write('                   @@@@@@@@@@@@@:     ..:=+#        @@@@@@@-                                        '), nl,
    write('                 *@@@@@@@-..:-=:.        ..=* =@@@@@@@@@@@@@                                     '), nl,
    write('                @@@@@@@%   . ::-=-.       .::-:-+%#%@@@@@@@@@@@@@                                   '), nl,
    write('               @@@@@@@@       .:--==.    .......:==-**%@@@@@@@@@@@#                                 '), nl,
    write('              @@@@@@@            :--=+........:..--=+=*%@@@@@@@@@@@@                                '), nl,
    write('              @@@@@#             .:-  . . .: .: ::::-=***%@@@@@@@@@@@                               '), nl,
    write('             -@@@@:                        .... ... -+#@@=*@@@@@@@@@@                               '), nl,
    write('             +@@@@                         . .:::..::=-@@@++*@@@@@@@@+                              '), nl,
    write('             +@@@%            .              .::..:::--+-=*#%%@@@@@@*=+=                            '), nl,
    write('             :@@@@         *-  =.              :::---#::=-=+#%@@@@@-:.:+=+                          '), nl,
    write('              @@@@        @@@@@@%-        .:    .:=@@@@ .-++#%@@@@-.  .:-++                         '), nl,
    write('               @@@=     -@@@@@@@@@*.      +@@@   :-+@*:-=+=**%@@%=..   .:=+.                        '), nl,
    write('               :@@@@    @@@@@@@@@@@@-     .*@@   .::--::*+==#*+*++-..:.::-* '), nl,
    write('                 @@@@@@@@@@@@@@@@@@@@*.    . .   .::--:+++--:====*+++:-=+*.                         '), nl,
    write('                   #@@@@@@@@@@@@@@@@@@@-.        ..:.:=---:------=+++**%+                           '), nl,
    write('                    .@@@@@@@@@@@@@@@@@@@#:   .    ..:....::=:::--=====**:                           '), nl,
    write('                       #@@@@@@@@@@@@@@@@@@=.          .: :::.:::::--:--=+:.::--=*=                  '), nl,
    write('                        :@@@@@%@@@@@@@@@@@@#:           ..:::..:.:-::.:..:.  .:==+* '), nl,
    write('                          %*@@@@@@@@@@@@@@@@%=          . ..:.:...::....     ...:-+#                '), nl,
    write('                           -%@@@@@@@@@@@@@@@*.              :.::..:.         .:::--+-               '), nl,
    write('                             *@@@@@@@@@@@@@+:.           .:. ::=.:::.      ..::::-=* '), nl,
    write('                               #@@@@@@@#-:=+-+:         . .:::--:-:::    . ...::-=#                 '), nl,
    write('                                  %##.--==-=++=          ...:---=---:.     .:..:-+.                 '), nl,
    write('                                     :.::---+++.      .:.::-==+++++===-..:..::---                   '), nl,
    write('                                        :=+==-=        .:--=*#%%@%%%%* '), nl,
    write('                                       ..:=+==:       .:-====+*#@@%#                                '), nl,
    write('                                        .:=-           .:-=++=+*##                                  '), nl,
    write('                                                     ..::===++*#* '), nl,
    write('                                                        ..=+-++*+                                   '), nl,
    write('                                                        ..-==*++#                                   '), nl,
    write('                                                       . :-=-+*++                                   '), nl,
    write('                                                        ::-=++==                                    '), nl,
    write('                                                       ::.:-=:-                                     '), nl,
    write('                                                                                                    '), nl,
    write('                                                                                                    '), nl,
    write('                                                                                                    '), nl,
    write('                                                                                                    '), nl,
    write('                                                                                                    '), nl,
    write('                                                                                                    '), nl,
    write('Mempersiapkan deck dan membagikan kartu...'), nl,
    inisialisasi_deck(DeckAwal),
    acak_deck(DeckAwal, DeckAcak),
    
    % bagikan 7 kartu ke masing-masing pemain
    bagi_kartu_pemain(ListPemain, DeckAcak, DeckSisaSetelahBagi),
    
    % tentukan kartu awal di meja (discard_top) -> HARUS KARTU ANGKA
    tentukan_discard_awal(DeckSisaSetelahBagi, KartuAwal, DeckFinal),
    asserta(discard_top(KartuAwal)),
    asserta(deck_kartu(DeckFinal)),
    
    % update warna aktif berdasarkan kartu awal
    KartuAwal = kartu(WarnaAwal, _),
    asserta(warna_aktif(WarnaAwal)),
    
    % --- BAGIAN INI YANG DIPERBAIKI ---
    write('Setiap pemain mendapatkan 7 kartu acak.'), nl,
    format('Kartu discard top: ~w-~w.~n', [WarnaAwal, KartuAwal]),
    format('Giliran ~w.~n', [PemainPertama]).

% helper bwt minta input jumlah pemain (batas 2-4)
input_jumlah_pemain(N) :-
    write('Berapa pemain (2-4)? [pake titik]: '),
    read(Input),
    (   integer(Input), Input >= 2, Input =< 4
    ->  N = Input
    ;   write('Sumbang euy, masukin angka 2, 3, atau 4 aja!'), nl,
        input_jumlah_pemain(N) % ngulang kalo sala input
    ).

% helper bwt minta nama pemain unik
input_nama_pemain(0, Acc, Acc) :- !. % base case: kalo udah pas, balikin listnya
input_nama_pemain(N, Acc, ListPemain) :-
    N > 0,
    write('Masukin nama pemain [pake titik]: '),
    read(Nama),
    (   member(Nama, Acc) % cek nama kembar
    ->  write('Namanya udah dipake, cari nama lain ngab!'), nl,
        input_nama_pemain(N, Acc, ListPemain)
    ;   N1 is N - 1,
        append(Acc, [Nama], AccBaru), % masukin nama ke list sementara
        input_nama_pemain(N1, AccBaru, ListPemain)
    ).

% helper pembuatan deck
valid_kartu(Warna, Jenis) :- warna(Warna), jenis_angka(Jenis).
valid_kartu(Warna, Jenis) :- warna(Warna), jenis_aksi(Jenis).
valid_kartu(hitam, Jenis) :- jenis_aksi_wild(Jenis).

% --- PENGGANTI FINDALL UNTUK INISIALISASI DECK ---

% 1. Bikin list eksplisit sebagai bahan dasar
daftar_warna([merah, kuning, hijau, biru]).
daftar_angka([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]).
daftar_aksi([skip, reverse, draw_two]).
daftar_wild([wild, wild_draw_four]).

% 2. Helper rekursif untuk bikin kartu angka
gabung_angka(_, [], []).
gabung_angka(Warna, [Angka|Tail], [kartu(Warna, Angka)|HasilTail]) :-
    gabung_angka(Warna, Tail, HasilTail).

loop_warna_angka([], _, []).
loop_warna_angka([Warna|TailWarna], ListAngka, Hasil) :-
    gabung_angka(Warna, ListAngka, KartuWarnaIni),
    loop_warna_angka(TailWarna, ListAngka, KartuWarnaLain),
    append(KartuWarnaIni, KartuWarnaLain, Hasil).

% 3. Helper rekursif untuk bikin kartu aksi
gabung_aksi(_, [], []).
gabung_aksi(Warna, [Aksi|Tail], [kartu(Warna, Aksi)|HasilTail]) :-
    gabung_aksi(Warna, Tail, HasilTail).

loop_warna_aksi([], _, []).
loop_warna_aksi([Warna|TailWarna], ListAksi, Hasil) :-
    gabung_aksi(Warna, ListAksi, KartuWarnaIni),
    loop_warna_aksi(TailWarna, ListAksi, KartuWarnaLain),
    append(KartuWarnaIni, KartuWarnaLain, Hasil).

% 4. Helper rekursif untuk bikin kartu wild (warna hitam otomatis)
loop_wild([], []).
loop_wild([Wild|Tail], [kartu(hitam, Wild)|HasilTail]) :-
    loop_wild(Tail, HasilTail).

% 5. FUNGSI UTAMA INISIALISASI DECK (Tanpa Findall)
inisialisasi_deck(DeckLengkap) :-
    daftar_warna(Warna),
    daftar_angka(Angka),
    daftar_aksi(Aksi),
    daftar_wild(Wild),
    
    % Generate semua kombinasi
    loop_warna_angka(Warna, Angka, DeckAngka),
    loop_warna_aksi(Warna, Aksi, DeckAksi),
    loop_wild(Wild, DeckWild),
    
    % Gabungin semua jadi satu DeckDasar
    append(DeckAngka, DeckAksi, TempDeck),
    append(TempDeck, DeckWild, DeckDasar),
    
    % Gandakan 2 deck dasar seperti kodemu sebelumnya
    append(DeckDasar, DeckDasar, DeckGanda),

    % Tambahkan kartu Mimic ke deck
    append(DeckGanda, [kartu(hitam, mimic)], DeckLengkap).

% helper pembagian kartu
bagi_kartu_pemain([], Deck, Deck). 
bagi_kartu_pemain([Pemain|SisaPemain], DeckSekarang, DeckSisaAkhir) :-
    ambil_N_kartu(7, DeckSekarang, TanganPemain, DeckSisaSementara),
    asserta(tangan_pemain(Pemain, TanganPemain)),
    bagi_kartu_pemain(SisaPemain, DeckSisaSementara, DeckSisaAkhir).

ambil_N_kartu(0, Deck, [], Deck) :- !.
ambil_N_kartu(N, [KartuTop|SisaDeck], [KartuTop|Tangan], DeckAkhir) :-
    N > 0,
    N1 is N - 1,
    ambil_N_kartu(N1, SisaDeck, Tangan, DeckAkhir).

% helper discard awal 
% kartu pertama di discard_top adalah ANGKA (sesuai aturan UNO/UNI)
tentukan_discard_awal([kartu(Warna, Jenis)|SisaDeck], kartu(Warna, Jenis), SisaDeck) :-
    jenis_angka(Jenis), !.

% kartu atas BUKAN angka (misal: reverse, draw_two, wild), pindahkan ke bawah deck, cari lagi
tentukan_discard_awal([KartuAksi|SisaDeck], KartuAwal, DeckSisaAkhir) :-
    \+ jenis_angka(KartuAksi), 
    append(SisaDeck, [KartuAksi], DeckBaru), 
    tentukan_discard_awal(DeckBaru, KartuAwal, DeckSisaAkhir).

% randomize deck
acak_deck([], []).
% Rekursi: Cabut 1 kartu acak, lalu acak sisanya
acak_deck(ListAwal, [KartuAcak|SisaAcak]) :-
    random_card(ListAwal, KartuAcak, ListSisa),
    acak_deck(ListSisa, SisaAcak).

random_card(List, Card, NewList) :-
    count_list(List, Len),
    random(0, Len, Index),
    pick_at_index(List, Index, Card, NewList).

count_list([], 0).
count_list([_|T], N) :-
    count_list(T, N1),
    N is N1 + 1.

pick_at_index([H|T], 0, H, T) :- !.
pick_at_index([H|T], I, Card, [H|Rest]) :-
    I > 0,
    I1 is I - 1,
    pick_at_index(T, I1, Card, Rest).

% --- ENDGAME & NGITUNG POIN ---

% aturan nilai poin kartu
poin_kartu(kartu(_, Jenis), Poin) :-
    jenis_angka(Jenis), Poin is Jenis, !.
poin_kartu(kartu(_, Jenis), 10) :-
    jenis_aksi(Jenis), !.
poin_kartu(kartu(hitam, Jenis), 20) :-
    jenis_aksi_wild(Jenis), !.

% ngitung total poin dari list kartu di tangan
hitung_poin_tangan([], 0).
hitung_poin_tangan([Kartu|Sisa], TotalPoin) :-
    poin_kartu(Kartu, Poin),
    hitung_poin_tangan(Sisa, PoinSisa),
    TotalPoin is Poin + PoinSisa.

% ngecek apakah permainan sudah selesai (kartunya kosong)
cek_selesai :-
    (   tangan_pemain(_, [])
    ->  endGame
    ;   true
    ).

% spek endGame
endGame :-
    tangan_pemain(Pemenang, []), !,
    format('Permainan selesai! ~w menghabiskan semua kartunya!~n~n', [Pemenang]),
    write('Berikut perhitungan poin sisa kartu.'), nl,
    
    % nyetak perhitungan poin tiap pemain
    urutan_pemain(UrutanAsli),
    cetak_semua_rincian(UrutanAsli),
    nl,
    
    write('Urutan pemenang:'), nl,
    kumpulkan_skor(UrutanAsli, UrutanAsli, ListSkor),
    sort(ListSkor, ListSkorSorted), 
    cetak_urutan_pemenang(ListSkorSorted, 1),
    nl,
    format('Selamat, ~w menjadi pemenang!~n', [Pemenang]),
    !.

endGame :-
    write('Belum ada pemain yang menghabiskan kartu. Lanjut main!'), nl.

% helper pencetakan rincian poin
cetak_semua_rincian([]).
cetak_semua_rincian([Pemain|T]) :-
    cetak_rincian_poin(Pemain),
    cetak_semua_rincian(T).

cetak_rincian_poin(Pemain) :-
    tangan_pemain(Pemain, Tangan),
    (   Tangan == []
    ->  format('~w: kartu habis = 0 poin~n', [Pemain])
    ;   format('~w: ', [Pemain]),
        cetak_kartu_rincian(Tangan),
        write(' = '),
        cetak_angka_rincian(Tangan),
        hitung_poin_tangan(Tangan, Total),
        format(' = ~w poin~n', [Total])
    ).

cetak_kartu_rincian([kartu(Warna, Jenis)]) :- format('~w-~w', [Warna, Jenis]), !.
cetak_kartu_rincian([kartu(Warna, Jenis)|T]) :- 
    format('~w-~w + ', [Warna, Jenis]), 
    cetak_kartu_rincian(T).

cetak_angka_rincian([Kartu]) :- poin_kartu(Kartu, Poin), write(Poin), !.
cetak_angka_rincian([Kartu|T]) :- 
    poin_kartu(Kartu, Poin), 
    format('~w + ', [Poin]), 
    cetak_angka_rincian(T).

% helper mengumpulkan data dan peringkat
% List output format: skor(TotalPoin, JmlKartu, IndexUrutanAwal, NamaPemain)
kumpulkan_skor([], _, []).
kumpulkan_skor([Pemain|T], UrutanAsli, [skor(Poin, JmlKartu, Index, Pemain)|SisaSkor]) :-
    tangan_pemain(Pemain, Tangan),
    hitung_poin_tangan(Tangan, Poin),
    length(Tangan, JmlKartu),
    nth0(Index, UrutanAsli, Pemain), % Index dipakai untuk tie-breaker ke-2
    kumpulkan_skor(T, UrutanAsli, SisaSkor).

cetak_urutan_pemenang([], _).
cetak_urutan_pemenang([skor(Poin, _, _, Pemain)|T], Peringkat) :-
    format('~w. ~w (~w poin)~n', [Peringkat, Pemain, Poin]),
    Peringkat1 is Peringkat + 1,
    cetak_urutan_pemenang(T, Peringkat1).
% --- FITUR TANGKAP ---

tangkap(TargetPemain) :-
    % 1. Validasi: pastikan TargetPemain beneran ada di dalam game
    urutan_pemain(ListPemain),
    member(TargetPemain, ListPemain),
    !,
    
    giliran_sekarang(Pemanggil),
    
    % 2. Cek jebakan: apakah target sedang menyembunyikan kartu?
    (   kartu_disembunyikan(TargetPemain, _) ->
        format('Eits! Tangkap gagal! Ada kartu yang disembunyikan oleh ~w.~n',[TargetPemain]),
        write('Hukuman: '), write(Pemanggil), write(' harus ambil 2 kartu tambahan.'), nl,
        
        % Beri 1 kartu penalti ke pemanggil
        deck_kartu(DeckSekarang),
        ambil_N_kartu(1, DeckSekarang, KartuHukuman, SisaDeck),
        retract(deck_kartu(DeckSekarang)),
        asserta(deck_kartu(SisaDeck)),
        
        % Masukkan kartu penalti ke tangan pemanggil
        tangan_pemain(Pemanggil, TanganLama),
        append(TanganLama, KartuHukuman, TanganBaru),
        retract(tangan_pemain(Pemanggil, TanganLama)),
        asserta(tangan_pemain(Pemanggil, TanganBaru)),
        
        % Langsung pindah giliran karena salah tangkap
        pindah_giliran
    ;   
        % 3. Jika aman, eksekusi logika tangkap normal (cek UNI)
        tangan_pemain(TargetPemain, Tangan),
        length(Tangan, JumlahKartu),
        (   JumlahKartu =:= 1 ->
            % Jika kartunya sisa 1, cek apakah dia udah bilang UNI
            (   \+ status_uni(TargetPemain) ->
                % Kalau BELUM bilang UNI -> Kena hukuman ambil 2 kartu
                write('MAMPUSSSZZSS! '), write(TargetPemain), write(' lupa bilang UNI kan lu'), nl,
                write('Hukuman: '), write(TargetPemain), write(' harus ambil 2 kartu tambahan.'), nl,

                % Proses ambil 2 kartu dari deck
                deck_kartu(DeckNormal),
                ambil_N_kartu(2, DeckNormal, KartuHukum2, SisaDeckNormal),

                % Update state deck
                retract(deck_kartu(DeckNormal)),
                asserta(deck_kartu(SisaDeckNormal)),

                % Update state tangan pemain yang ditangkap
                append(Tangan, KartuHukum2, TanganBaruNormal),
                retract(tangan_pemain(TargetPemain, Tangan)),
                asserta(tangan_pemain(TargetPemain, TanganBaruNormal))
            ;
                % Kalau SUDAH bilang UNI
                write('enak aje lu '), write(TargetPemain), write(' udah bilang UNI tadi, jadi aman dongg'), nl
            )
        ;
            % Jika kartunya BUKAN sisa 1
            write('Salah tangkap! Kartu '), write(TargetPemain), write(' masih '), write(JumlahKartu), write(' lembar...'), nl
        )
    ), !. 


% Fallback kalau nama pemain yang diinput ngawur / typo
tangkap(TargetPemain) :-
    write('??? Siapa '), write(TargetPemain), write('? Ga ada di game ini! Cek typo.'), nl.

% --- SAVE & LOAD GAME ---

efek_memblokir(draw_four).
efek_memblokir(draw_two).

% save game

saveGame :-
    % Cek efek aktif — kalau ada efek yang memblokir, tolak
    efek_kartu(Eff),
    (   efek_memblokir(Eff)
    ->  write('Game tidak bisa disimpan sekarang!'), nl,
        format('Efek ~w harus diselesaikan terlebih dahulu! (tantang/ambilKartu).~n', [Eff])
    ;   saveGame_eksekusi
    ).

saveGame_eksekusi :-
    write('Masukkan nama file penyimpanan: '),
    read(NamaFile),
    atom_concat(NamaFile, '.txt', NamaFileTxt),

    urutan_pemain(UrutanPemain),
    giliran_sekarang(GiliranSekarang),
    discard_top(kartu(WarnaTop, JenisTop)),
    warna_aktif(WarnaAktif),

    (   arah_permainan(Arah) -> true ; Arah = kanan ),

    findall(P, status_uni(P), ListUNI),

    open(NamaFileTxt, write, Stream),
    
    % urutan_pemain
    format(Stream, 'urutan_pemain:~w.~n', [UrutanPemain]),
    
    % giliran
    format(Stream, 'giliran:~w.~n', [GiliranSekarang]),
    
    % discard_top
    format(Stream, 'discard_top:~w-~w.~n', [WarnaTop, JenisTop]),
    
    % warna_aktif
    format(Stream, 'warna_aktif:~w.~n', [WarnaAktif]),
    
    % arah_permainan
    format(Stream, 'arah_permainan:~w.~n', [Arah]),
    
    % status_UNI
    format(Stream, 'status_UNI:~w.~n', [ListUNI]),
    
    % kartu tiap pemain
    tulis_kartu_pemain(Stream, UrutanPemain),
    
    % simpan status kartu tersembunyi
    tulis_kartu_sembunyi(Stream, UrutanPemain),

    close(Stream),
    write('                                                                        @@@@@@@@@'), nl,
    write('                                                                      @@@       @@@'), nl,
    write('                                                                     @@          @@'), nl,
    write('                                                                    @@           .@@'), nl,
    write('                                                                   @@             @@'), nl,
    write('                                                                   @@             @@.'), nl,
    write('                                                                   @@            @@'), nl,
    write('                                                                   @=           .@@'), nl,
    write('                                                                   @@          @@@@@@@@@@@@'), nl,
    write('                   @@@@@                                         @@        @@@           @@@@'), nl,
    write('           @@@@  @@    @@@                                     @@        @@@                @@@'), nl,
    write('          @   .@@@@      @@                                   @@       -@@                   @@@'), nl,
    write('         @@      @@@      @@                                 @@        @@                     =@@'), nl,
    write('          @@      @@@      @@                               @@        @@@@@@@@@@@@             @@@'), nl,
    write('           @@@      =@@    @@                               @@       @@                        .@@'), nl,
    write('            @@      @@      @@                              @:       @@                         @@'), nl,
    write('             @@-     @@     .@                              @       @@                         @@@'), nl,
    write('              :@@    @@      @+   @+                       @@       @@                         @@-'), nl,
    write('               @@   .@@.          @@@@@@                   @@       @@                         @@'), nl,
    write('           @@@@               @@@@@    @@@@@                @@      @@@@@@@@@@@@@             @@@'), nl,
    write('        @@@   @@@                  @@@@   @@@@               @@      @@                      .@@'), nl,
    write('      @@@   @@                        @@@   @@@             @@@@      @@@                   .@@'), nl,
    write('    @@@   @@                           @@@    @@@          @@  @@      @@@                 @@@'), nl,
    write('   @@#    @                             @@     @@@        @@@    @@@      @@@             @@@'), nl,
    write('  @@     @@                      @@@@=     @      @@     @@        @@@@      @@@@    @@@@@@'), nl,
    write(' @@      @@       @@@@=         @@  @@@         @@@   @@@            @@@@@@@@@@@@@@@@'), nl,
    write('+@@              @@  @@@         @@@@@@.        @@  @@                 @@@@'), nl,
    write('@@               @@@@@@.          @@@            @@@@@               @@@@'), nl,
    write('@@                 @@@                 @ @@ @    @@@              @@@@'), nl,
    write('@@        @  @ -             @@  @              @@            @@@@@'), nl,
    write('@@       @@ @  @          @@@  @@             @@@           @@@'), nl,
    write(' @@@                           .@.             @         .@@@'), nl,
    write('  @@                                                   @@@'), nl,
    write('    @@                                              .@@@'), nl,
    write('      @@@                                        .@@@'), nl,
    write('       @@                                       @@'), nl,
    write('        @@@                                    @'), nl,
    write('      @@.                                     @@'), nl,
    write('      @                                       @'), nl,
    format('      @@.@@@@                                @@      Status permainan berhasil disimpan ke ~w.', [NamaFileTxt]), nl,
    write('     @      @                                @-'), nl,
    write('    @       @@                              @@'), nl,
    write('    @       @@                               @@'), nl,
    write('     @     @@                        @@@@@@   @@'), nl,
    write('      @@@@ @@   @@@@@@@@@@@@@@@@@@@@      @@   @@'), nl,
    write('           @@ *@@                           @@@@'), nl,
    write('             @@'), nl.

% helper untuk nulis kartu pemain
tulis_kartu_pemain(_, []).
tulis_kartu_pemain(Stream, [Pemain|Sisa]) :-
    tangan_pemain(Pemain, ListKartu),
    kartu_list_ke_format(ListKartu, ListFormat),
    format(Stream, 'kartu(~w):~w.~n', [Pemain, ListFormat]),
    tulis_kartu_pemain(Stream, Sisa).

% helper untuk menulis kartu sembunyi
tulis_kartu_sembunyi(_, []).
tulis_kartu_sembunyi(Stream, [Pemain|Sisa]) :-
    (   kartu_disembunyikan(Pemain, Kartu)
    ->  Kartu = kartu(W, J),
        atomic_list_concat([W, J], '-', WJ),
        format(Stream, 'sembunyi(~w):~w.~n', [Pemain, WJ])
    ;   true
    ),
    tulis_kartu_sembunyi(Stream, Sisa).

% konversi list kartu internal ke format Warna-Jenis
kartu_list_ke_format([], []).
kartu_list_ke_format([kartu(W,J)|Sisa], [WJ|SisaFormat]) :-
    atomic_list_concat([W, J], '-', WJ),
    kartu_list_ke_format(Sisa, SisaFormat).

% load game

loadGame :-
    write('Masukkan nama file yang akan dimuat: '),
    read(NamaFile),
    atom_concat(NamaFile, '.txt', NamaFileTxt),
    
    (   exists_file(NamaFileTxt)
    ->  loadGame_eksekusi(NamaFileTxt)
    ;   format('Error: File ~w tidak ditemukan.~n', [NamaFileTxt])
    ).

loadGame_eksekusi(NamaFileTxt) :-
    retractall(urutan_pemain(_)),
    retractall(giliran_sekarang(_)),
    retractall(discard_top(_)),
    retractall(warna_aktif(_)),
    retractall(efek_kartu(_)),
    retractall(deck_kartu(_)),
    retractall(tangan_pemain(_, _)),
    retractall(kartu_disembunyikan(_, _)),
    retractall(kartu_aksi_terakhir(_)),
    retractall(status_uni(_)),
    retractall(arah_permainan(_)),

    open(NamaFileTxt, read, Stream),
    baca_semua_baris(Stream),
    close(Stream),

    asserta(efek_kartu(none)),

    write('                  .=**-.=%%*:    -=*+.:==.'), nl,
    write('                   @+::=@#::=%.  *%::-#@--%='), nl,
    write('                  .@*:::::::+#.  *%:::::::%#'), nl,
    write('                   :@%=-::=%+    :%%-:::-##'), nl,
    write('                     :*@@@%:       -#%#%#:'), nl,
    write('                       #+           :#-'), nl,
    write('                      :@%#+.        +#-:'), nl,
    write('             .--:.    .%#*#        +@#*# .-+++-.'), nl,
    write('           .##=:-#%+  :%:          #+.. +%-..-#@+'), nl,
    format('           @*     =@=-%@@@@@@@@@@@@@%+.:%-     =%:        Status permainan berhasil dimuat dari ~w.', [NamaFileTxt]), nl,
    write('           %=     =%*=.             .=*#%=     -%:           Selamat bermain~'), nl,
    write('            =#:                                =%-'), nl,
    write('          *%#-                                :*'), nl,
    write('        =@#                                    .#@:                  ..'), nl,
    write('      :%%:                                       .*@*               .:=#+'), nl,
    write('    .*@+            -##*+:           =#%#*+        :%%.            :+#+ +='), nl,
    write('    +@-                                             :#@.              *#'), nl,
    write('   #@-               ...               ..            .%@:  *@%%%@*'), nl,
    write('  +@-             =@%=:*%-          -%%++%%-          =@*-@*::::=@+===-:'), nl,
    write(' -@#             -@@#==#@%.        .%@*.  #%.          %@@*:::::-%#-:-*@+'), nl,
    write(' +@:         .....%%=@%@@*         .%@*@@%@%           *@@-::::::::::::=%:'), nl,
    write(' *%.      .%*-%+--:-*%%%=           :#%#@@#:=+:=--:    -@@+::::::::::::=%-'), nl,
    write('.#%      .#=-#==%-##          +@-      .:..+#-%#=%*%.  :@@@-::::::::::=@+'), nl,
    write('.#%.      ..:::=::-.       %#*@@=--       .=:=+:==%-   :@=*@-:::::::+%@*'), nl,
    write(' +@.                            ..          ......     *@- @@+++#%@@#:'), nl,
    write('  *@:                                                 *%=%=.%+'), nl,
    write('   #%-                                               +@-@=:@*'), nl,
    write('    :%#.                                           .*@@@==@-'), nl,
    write('     .+@#:                                        =@*:##*%-'), nl,
    write('       :%-                                       .-.  -#+'), nl,
    write('       =%: :%-                                      *@:'), nl,
    write('       +%: :%-                                   .##:'), nl,
    write('       .#*+%*.                                   +@'), nl,
    write('         ..=%:                                  -@-'), nl,
    write('          *@@@=                                -@='), nl,
    write('         :#  -@#.                            .#%:'), nl,
    write('          =*#**+%#:                        :*%='), nl,
    write('                 -#@*:                  =#%*:'), nl,
    write('                    .=*%%+  .+.  -+**%%#-'), nl,
    write('                        :%= :%*  *%'), nl,
    write('                         +%..#* =@:'), nl,
    write('                          .===*@+'), nl,
    giliran_sekarang(GiliranSekarang),
    format('Melanjutkan giliran ~w.~n', [GiliranSekarang]).

baca_semua_baris(Stream) :-
    read_term(Stream, Term, [end_of_file(eof)]),
    (   Term == eof
    ->  true
    ;   proses_baris(Term),
        baca_semua_baris(Stream)
    ).



proses_baris(urutan_pemain : ListPemain) :- !,
    asserta(urutan_pemain(ListPemain)).

proses_baris(giliran : Nama) :- !,
    asserta(giliran_sekarang(Nama)).

proses_baris(discard_top : (Warna - Jenis)) :- !,
    asserta(discard_top(kartu(Warna, Jenis))).

proses_baris(warna_aktif : Warna) :- !,
    asserta(warna_aktif(Warna)).

proses_baris(arah_permainan : Arah) :- !,
    asserta(arah_permainan(Arah)),
    (   Arah == kiri
    ->  urutan_pemain(ListLama),
        reverse_pemain(ListLama, ListBaru),
        retract(urutan_pemain(ListLama)),
        asserta(urutan_pemain(ListBaru))
    ;   true
    ).

proses_baris(status_UNI : ListUNI) :- !,
    pasang_status_uni(ListUNI).

proses_baris(kartu(Nama) : ListFormat) :- !,
    format_ke_kartu_list(ListFormat, ListKartu),
    asserta(tangan_pemain(Nama, ListKartu)).

proses_baris(sembunyi(Nama) : FormatKartu) :- !,
    FormatKartu =.. [-, W, J],
    asserta(kartu_disembunyikan(Nama, kartu(W, J))).

proses_baris(Term) :-
    format('[loadGame] Baris tidak dikenali, dilewati: ~w~n', [Term]).

% --- HELPER FUNGSI DIPINDAHKAN KE BAWAH SINI ---
% Supaya tidak memotong kumpulan 'proses_baris' di atas

pasang_status_uni([]).
pasang_status_uni([P|Sisa]) :-
    asserta(status_uni(P)),
    pasang_status_uni(Sisa).

format_ke_kartu_list([], []).
format_ke_kartu_list([WJ|Sisa], [kartu(W,J)|SisaKartu]) :-
    % WJ adalah term W-J (operator minus di Prolog)
    WJ =.. [-, W, J],
    format_ke_kartu_list(Sisa, SisaKartu).
