
function OpticalCharacterRecognition
NeuralNetworks;
imagen=imread('alphabets2.jpg');  %Input Image from the current Folder
figure;
imagen1 = imagen;

imshow(imagen1); %Show Image
title('Input Image with Noise');

%% Convert Image into gray scale
if size(imagen,3)==3  %RGB Color
   imagen=rgb2gray(imagen);
   figure;
   imshow(imagen);
end
%% Convert Image to binary Image
threshold=graythresh(imagen);
imagen=~im2bw(imagen,threshold);

figure;
imshow(imagen);
%% Remove all the objects containing less than 20 pixels
imagen=bwareaopen(imagen,20);
figure;
imshow(imagen);
%% 
RL=imagen;
word=[];
fid=fopen('alphabets2.txt','wt');
load templates
global templates
num_letters=size(templates,2);
disp(num_letters)
while 1
    [FL RL]=horizonatalSegmentation(RL);
    imagen=FL;
    n=0;
    spacevector=[];
    RA=FL;
    
    while 1
        [FA RA space]=verticalSegmentation(RA);
        imgChar=imresize(FA,[42 24]);
        n=n+1;
        spacevector(n)=space;
        
        letter=TemplateMatching(imgChar,num_letters);
        word=[word letter];
        
        if isempty(RA)
            break;
            
        end
    end
    
  max_space = max(spacevector);
    no_spaces = 0;
    
     for x= 1:n   %loop to introduce space at requisite locations
       if spacevector(x+no_spaces)> (0.75 * max_space)
          no_spaces = no_spaces + 1;
            for m = x:n
              word(n+x-m+no_spaces)=word(n+x-m+no_spaces-1);
            end
           word(x+no_spaces) = ' ';
           spacevector = [0 spacevector];
       end
     end
              
    fprintf(fid,'%s\n',word);%Write 'word' in text file (upper)
    % Clear 'word' variable
    word=[ ];
    %*When the sentences finish, breaks the loop
    if isempty(RL)  
        break
    end
end
fclose(fid);
%Open 'text.txt' file
winopen('alphabets2.txt')
clear all