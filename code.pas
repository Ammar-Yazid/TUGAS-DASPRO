program KasirLengkap;

uses crt, sysutils;

var
    hari : string;
    next : char;
    opsi, admOpsi : integer;
    hargaBarang, discount : integer;
    sumBelanja : integer;

    daftar_harga : array of integer;
    daftar_barang : array of string;
    keranjang_nama : array of string;
    keranjang_harga : array of integer;

    hargaBaru, pilihBarang, index, i : integer;
    barangBaru : string;
    belanjaLagi, adaDiskon : char;
    diskonPersen, totDiskon, totalAkhir : integer;
    uangBayar, kembalian : integer;
    fileStruk : text;

begin
    sumBelanja := 0;

    repeat
        clrscr;
        writeln('====Sistem Kasir====');
        writeln('=Apa yang kamu mau?=');
        writeln('1. Memanage barang(Admin)');
        writeln('2. Berbelanja');
        writeln('3. Mode kasir');
        writeln('4. Cetak Struk');
        write('Pilih manaa(1/2/3/4) : ');
        readln(opsi);

        if opsi = 1 then
        begin
            writeln;
            writeln('Pilih opsi manage :');
            writeln('1. Menambah barang');
            writeln('2. Menghapus barang');
            writeln('3. Melihat saja');
            write('Pilihan: ');
            readln(admOpsi);

            if admOpsi = 1 then
            begin
                write('Masukkan harga barang baru: Rp ');
                readln(hargaBaru);
                write('Masukkan nama barang baru : ');
                readln(barangBaru);

                SetLength(daftar_harga, Length(daftar_harga) + 1);
                SetLength(daftar_barang, Length(daftar_barang) + 1);
                
                daftar_harga[High(daftar_harga)] := hargaBaru;
                daftar_barang[High(daftar_barang)] := barangBaru;

                writeln('Barang ''', barangBaru, ''' dengan harga Rp', hargaBaru, ' berhasil ditambahkan!');
            end
            else if admOpsi = 2 then
            begin
                if Length(daftar_harga) > 0 then
                begin
                    SetLength(daftar_harga, Length(daftar_harga) - 1);
                    SetLength(daftar_barang, Length(daftar_barang) - 1);
                    writeln('Barang terakhir berhasil dihapus.');
                end
                else
                begin
                    writeln('Daftar barang masih kosong!');
                end;
            end
            else if admOpsi = 3 then
            begin
                writeln;
                writeln('--- DAFTAR BARANG ---');
                if Length(daftar_harga) = 0 then
                begin
                    writeln('Belum ada barang yang tersimpan!');
                end
                else
                begin
                    for i := 0 to High(daftar_harga) do
                    begin
                        writeln('[ ', daftar_barang[i], ', Harga : Rp', daftar_harga[i], ' ]');
                    end;
                end;
            end;
        end

        else if opsi = 2 then
        begin
            writeln;
            writeln('===Menu Belanja===');
            if Length(daftar_harga) = 0 then
            begin
                writeln('Barang masih kosong, admin belum menambahkan barang!');
            end
            else
            begin
                repeat
                    writeln;
                    writeln('Daftar barang di toko:');
                    for i := 0 to High(daftar_harga) do
                    begin
                        writeln((i + 1), '. ', daftar_barang[i], ' - Rp', daftar_harga[i]);
                    end;

                    write('Pilih nomor barang : ');
                    readln(pilihBarang);

                    if (pilihBarang > 0) and (pilihBarang <= Length(daftar_harga)) then
                    begin
                        index := pilihBarang - 1;

                        SetLength(keranjang_nama, Length(keranjang_nama) + 1);
                        SetLength(keranjang_harga, Length(keranjang_harga) + 1);

                        keranjang_nama[High(keranjang_nama)] := daftar_barang[index];
                        keranjang_harga[High(keranjang_harga)] := daftar_harga[index];
                        sumBelanja := sumBelanja + daftar_harga[index];

                        writeln('-> ', daftar_barang[index], ' Berhasil Masuk keranjang !');
                    end
                    else
                    begin
                        writeln('Nomor barang tidak valid !');
                    end;

                    write('Mau beli barang lagi ? (y/n): ');
                    readln(belanjaLagi);
                    belanjaLagi := LowerCase(belanjaLagi);

                until belanjaLagi <> 'y';
            end;
        end

        else if opsi = 3 then
        begin
            writeln;
            writeln('=====Mode Kasir=====');
            if Length(keranjang_nama) = 0 then
            begin
                writeln('Keranjang masih kosong!, silakan berbelanja !');
            end
            else
            begin
                writeln('Total Belanjaan : Rp ', sumBelanja);

                diskonPersen := 0;
                totalAkhir := sumBelanja;

                write('Apakah ada diskon tambahan? (y/n): ');
                readln(adaDiskon);

                if LowerCase(adaDiskon) = 'y' then
                begin
                    write('Masukkan persen diskon (misal 10% menjadi 10): ');
                    readln(diskonPersen);
                    totDiskon := (sumBelanja * diskonPersen) div 100;
                    totalAkhir := sumBelanja - totDiskon;
                    writeln('-> Potongan Diskon : Rp', totDiskon);
                end;

                writeln;
                writeln('--------------------------------------------------');
                writeln('==Total yang harus di bayar adalah : Rp', totalAkhir);
                writeln('--------------------------------------------------');

                repeat
                    write('Masukkan nominal uang bayar : Rp ');
                    readln(uangBayar);

                    if uangBayar < totalAkhir then
                    begin
                        writeln('Uang kurang !, kurang Rp ', (totalAkhir - uangBayar), '. Silakan masukkan nominal yang pas/lebih.');
                    end;
                until uangBayar >= totalAkhir;

                kembalian := uangBayar - totalAkhir;
                writeln('Kembalian : Rp ', kembalian);
                writeln;
                writeln('[ TRANSAKSI LUNAS ]');
            end;
        end

        else if opsi = 4 then
        begin
            writeln;
            writeln('================================');
            writeln('===========Cetak Struk==========');
            writeln('================================');

            if Length(keranjang_harga) = 0 then
            begin
                writeln('Belum adaa transaksi/keranjang kosong !');
            end
            else
            begin
                for i := 0 to High(keranjang_nama) do
                begin
                    writeln((i + 1), '. ', keranjang_nama[i], ' ' + #9 + ': Rp', keranjang_harga[i]);
                end;
                writeln('---------------------------------');
                writeln('TOTAL BELANJA : Rp', sumBelanja);
                writeln('=================================');
                writeln(' Terima kasih telah berbelanja! ');
                writeln;

                assign(fileStruk, 'struk.txt');
                {$I-} rewrite(fileStruk); {$I+}
                if IOResult = 0 then
                begin
                    writeln(fileStruk, '=================================');
                    writeln(fileStruk, '          STRUK BELANJA          ');
                    writeln(fileStruk, '=================================');
                    for i := 0 to High(keranjang_nama) do
                    begin
                        writeln(fileStruk, (i + 1), '. ', keranjang_nama[i], ' ' + #9 + ': Rp', keranjang_harga[i]);
                    end;
                    writeln(fileStruk, '---------------------------------');
                    writeln(fileStruk, 'TOTAL BELANJA : Rp', sumBelanja);
                    writeln(fileStruk, '=================================');
                    writeln(fileStruk, ' Terima kasih telah berbelanja! ');
                    close(fileStruk);
                    writeln('-> Struk berhasil disimpan ke ''struk.txt''!');
                end
                else
                begin
                    writeln('-> Gagal menyimpan file struk.txt!');
                end;

                SetLength(keranjang_nama, 0);
                SetLength(keranjang_harga, 0);
                sumBelanja := 0;
                writeln('(Sistem: Keranjang telah dikosongkan untuk transaksi baru)');
            end;
        end;

        writeln;
        write('Apakah kamu mau melanjutkan kegiatan ?(y/n): ');
        readln(next);
        next := LowerCase(next);

    until next <> 'y';
end.