clc; clear; close all; warning off all;

%%% Proses pelatihan
%menetapkan lokasi folder data latih
nama_folder = 'Data Latih';
%membaca file yang berekstensi .jpg
nama_file = dir(fullfile(nama_folder,'*.jpg'));
%membaca jumlah file yang berekstensi .jpg
jumlah_file = numel(nama_file);

%menginisialisasi variabel ciri_latih
data_latih = zeros(jumlah_file, 6);
%melakukan pengolahan citra terhadap seluruh file
for n = 1:jumlah_file
    %membaca file citra rgb
    Img = imread(fullfile(nama_folder,nama_file(n).name));
    %figure, imshow(Img)
    
    % Konversi gambar ke tipe double untuk koreksi gamma
    gambarAsli = double(Img) / 255.0;
    % Tentukan nilai gamma (sesuaikan jika diperlukan)
    gamma = 1.2;
    % Terapkan koreksi gamma
    gambarHasil = gambarAsli .^ (1/gamma);
    % Konversi gambar hasil kembali ke format uint8 untuk ditampilkan
    gambarHasil = uint8(gambarHasil * 255);
    
    %melakukan pre-processing menggunakan filter gaussian
    image = gambarHasil;
    sigma = 1.0;
    filteredImage = imgaussfilt(image, sigma);
    %figure, imshow(filteredImage)
   
    %melakukan segmentasi menggunakan algoritma K-Means Clustering
    segmentasi = filteredImage;
    % Color-Based Segmentation Using K-Means Clustering
    cform = makecform('srgb2lab');
    lab = applycform(segmentasi,cform);
    %figure, imshow(lab), title('L*a*b color space');
    
    ab = double(lab(:,:,2:3));
    nrows = size(ab,1);
    ncols = size(ab,2);
    ab = reshape(ab,nrows*ncols,2);
 
    nColors = 3;
    [cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean','Replicates',3);
 
    pixel_labels = reshape(cluster_idx,nrows,ncols);
    RGB = label2rgb(pixel_labels);
    %figure, imshow(RGB,[]), title('image labeled by cluster index');

    segmented_images = cell(1,3);
    rgb_label = repmat(pixel_labels,[1 1 3]);
 
    for k = 1:nColors
        color = segmentasi;
        color(rgb_label ~= k) = 0;
        segmented_images{k} = color;
    end
 
    %figure,imshow(segmented_images{1}), title('objects in cluster 1');
    %figure,imshow(segmented_images{2}), title('objects in cluster 2');
    %figure,imshow(segmented_images{3}), title('objects in cluster 3');

    % Grape segmentation
    area_cluster1 = sum(sum(pixel_labels==1));
    area_cluster2 = sum(sum(pixel_labels==2));
    area_cluster3 = sum(sum(pixel_labels==3));
 
    [~,cluster_grape] = min([area_cluster1,area_cluster2,area_cluster3]);
    grape_bw = (pixel_labels==cluster_grape);
    grape_bw = imfill(grape_bw,'holes');
    grape_bw = bwareaopen(grape_bw,1000);

    grape = segmentasi;
    R = grape(:,:,1);
    G = grape(:,:,2);
    B = grape(:,:,3);
    R(~grape_bw) = 0;
    G(~grape_bw) = 0;
    B(~grape_bw) = 0;
    grape_rgb = cat(3,R,G,B);
    %figure, imshow(grape_rgb), %title('the grape only (RGB Color Space)');
    

    %melakukan ekstraksi fitur warna
    ef_warna = grape_rgb;
    % Ekstraksi warna
    red_channel = ef_warna(:,:,1);
    green_channel = ef_warna(:,:,2);
    blue_channel = ef_warna(:,:,3);
    % Hitung nilai mean dan standar deviasi untuk setiap saluran warna
    mean_red = mean(red_channel(:));
    mean_green = mean(green_channel(:));
    mean_blue = mean(blue_channel(:));
    std_dev_red = std(double(red_channel(:)));
    std_dev_green = std(double(green_channel(:)));
    std_dev_blue = std(double(blue_channel(:)));
    % Tampilkan hasil
    % disp('Fitur Warna:');
    disp(['Mean Red: ', num2str(mean_red)]);
    disp(['Mean Green: ', num2str(mean_green)]);
    disp(['Mean Blue: ', num2str(mean_blue)]);
    disp(['Std Dev Red: ', num2str(std_dev_red)]);
    disp(['Std Dev Green: ', num2str(std_dev_green)]);
    disp(['Std Dev Blue: ', num2str(std_dev_blue)]);
    
    %menyusun variabel data_latih 
    data_latih(n,1) = mean_red;
    data_latih(n,2) = mean_green;
    data_latih(n,3) = mean_blue;
    data_latih(n,4) = std_dev_red;
    data_latih(n,5) = std_dev_green;
    data_latih(n,6) = std_dev_blue;

end


%menyusun variabel kelas_latih
kelas_latih = cell(jumlah_file,1);

%mengisi nama2 anggur pada variabel kelas_latih
%split data 80:20
%for n = 1:80
%    kelas_latih(n) = {'hijau'};
%end
%for n = 81:160
%    kelas_latih(n) = {'hitam'};
%end
%for n = 161:240
%    kelas_latih(n) = {'merah'};
%end

%split data 70:30
for n = 1:70
    kelas_latih(n) = {'Anggur Hijau'};
end
for n = 71:140
    kelas_latih(n) = {'Anggur Hitam'};
end
for n = 141:210
    kelas_latih(n) = {'Anggur Merah'};
end

%split data 60:40
%for n = 1:60
%    kelas_latih(n) = {'hijau'};
%end
%for n = 61:120
%    kelas_latih(n) = {'hitam'};
%end
%for n = 121:180
%    kelas_latih(n) = {'merah'};
%end

%klasifikasi citra menggunakan algoritma naive bayes
Mdl = fitcnb(data_latih, kelas_latih);

%membaca kelas keluaran hasil dari pelatihan
hasil_latih = predict(Mdl,data_latih);

%menghitung akurasi pelatihan
jumlah_benar = 0;
for n = 1:jumlah_file    
    if isequal(hasil_latih{n},kelas_latih{n })
        jumlah_benar = jumlah_benar+1;    
    end
end

akurasi_pelatihan =  jumlah_benar/jumlah_file*100;

% Menghitung metrik evaluasi
CM = confusionmat(kelas_latih, hasil_latih);

% Menghitung akurasi
accuracy = sum(diag(CM)) / sum(CM(:));

% Menghitung presisi, recall, dan F1-score
precision = zeros(3, 1);
recall = zeros(3, 1);
f1_score = zeros(3, 1);

for i = 1:3
    precision(i) = CM(i, i) / sum(CM(:, i));
    recall(i) = CM(i, i) / sum(CM(i, :));
    f1_score(i) = 2 * (precision(i) * recall(i)) / (precision(i) + recall(i));
end

% Menampilkan hasil
fprintf('\n');
fprintf('Akurasi : %.2f%%\n', accuracy * 100);
fprintf('\n');
fprintf('Presisi Kelas Hijau : %.2f\n', precision(1));
fprintf('Presisi Kelas Hitam : %.2f\n', precision(2));
fprintf('Presisi Kelas Merah : %.2f\n', precision(3));
fprintf('\n');
fprintf('Recall Kelas Hijau : %.2f\n', recall(1));
fprintf('Recall Kelas Hitam : %.2f\n', recall(2));
fprintf('Recall Kelas Merah : %.2f\n', recall(3));
fprintf('\n');
fprintf('F1-score Kelas Hijau : %.2f\n', f1_score(1));
fprintf('F1-score Kelas Hitam : %.2f\n', f1_score(2));
fprintf('F1-score Kelas Merah : %.2f\n', f1_score(3));

%menyimpan model naive bayes hasil pelatihan
save Mdl Mdl
