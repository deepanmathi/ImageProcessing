%% Image processing enter the slice value in N

%step-1 read image
SrcImg = imread('image/path'); % give image path
[rows ,columns, numberOfColorBands]=size(SrcImg);
N=100;

%% step2 converting image matrix to N x N matrix
blockSizeR = N;
blockSizeC = N;

wholeBlockRows = floor(rows / blockSizeR);
blockVectorR = [blockSizeR * ones(1, wholeBlockRows), rem(rows, blockSizeR)];

wholeBlockCols = floor(columns / blockSizeC);
blockVectorC = [blockSizeC * ones(1, wholeBlockCols), rem(columns, blockSizeC)];

if numberOfColorBands > 1
   	cellArray = mat2cell(SrcImg, blockVectorR, blockVectorC, numberOfColorBands);
else
   	cellArray = mat2cell(SrcImg, blockVectorR, blockVectorC);
end
%% step 2 ends


plotIndex = 1;
numPlotsR = size(cellArray, 1);
numPlotsC = size(cellArray, 2);

fileID = fopen('exp.txt','w');%file to save
filetype= '.jpg';

for row = 1 : numPlotsR
    for column = 1 : numPlotsC
        
      		if row<numPlotsR &&  column<numPlotsC
            % Extract the numerical array out of the cell
            rgbBlock = cellArray{row,column};
          		
          		%step-3 calculates r g b mean and storing in file
          		red = mean(rgbBlock(:,:,1));
           	if numberOfColorBands > 1
             		 green = mean(rgbBlock(:,:,2));
             		 blue = mean(rgbBlock(:,:,3));
         		 else
            		 green=0;
     	             blue=0;
            end
          		fprintf(fileID,'Block R=%d G=%d B=%d\r\n','plotIndex',red,green,blue);
          		
          		%step-4 converting each plot to gray and displaying
          		grayPlot = mat2gray(rgbBlock);
          		figure; imhist(grayPlot);
          		
          		%histPlot = figure ; imhist(grayPlot);
          		%histFileName=strcat(strcat(plotIndex,'_hist'),filetype);
          		%saveas(histPlot ,histFileName)
            
          		%step-5 saving each tile
          		caption = sprintf('Block #%d of %d\n%d row by %d column', plotIndex, numPlotsR*numPlotsC, row, column);
          		savePlotFileName=strcat(caption,'.png')
          		imwrite(rgbBlock,savePlotFileName);
          		
      		end
      		
        % Increment the subplot to the next location.
        plotIndex = plotIndex + 1;
    end
end

fclose(fileID);


