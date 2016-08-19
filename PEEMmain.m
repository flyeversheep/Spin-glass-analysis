function  PEEMmain( )
%This function is used to transform the PEEM images into spreadsheet with
%each location indicating the PEEM intensity

total = input('please input the number of images:');
fname = input('please input the name of the file,end with #:');
spacing = input('please input the spacing:');
if(spacing==600)
    poshift=15;
    search=3;
end
for k = 0:total-1
    [I,result] = PEEMintensity(fname,k);
    backgroundlabel = mode(mode(result));
    if(k==0)
        X1=input('enter the coordinates of the upper-left vertex using notation [x y]: ');
        X2=input('enter the coordinates of the upper-right vertex using notation [x y]: ');
        X3=input('enter the coordinates of the lower-right vertex using notation [x y]: ');
        X4=input('enter the coordinates of the lower-left vertex using notation [x y]: ');
        rows=input('enter the total number of rows: ');
        columns=input('enter the total number of columns: ');
        xCoordPlane=[linspace(X1(1),X4(1),rows)]';%matrix keeping track of the x-coordinates of each vertex
        yCoordPlane=[linspace(X1(2),X4(2),rows)]';%matrix keeping track of the y-coordinates of each vertex
        xCoordPlane(:,columns)=[linspace(X2(1),X3(1),rows)]';
        yCoordPlane(:,columns)=[linspace(X2(2),X3(2),rows)]';
        for i=1:rows
            xCoordPlane(i,:)=linspace(xCoordPlane(i,1),xCoordPlane(i,columns),columns);
            yCoordPlane(i,:)=linspace(yCoordPlane(i,1),yCoordPlane(i,columns),columns);
        end
    end
    maxnumber = max(max(result));
    intensity=zeros(2,maxnumber);
    intensity=double(intensity);
    resultint=int32(result);
    dim = size(I);
    for i=1:dim(1)
        for j = 1:dim(2)
            if(result(i,j)~=0&&result(i,j)~=1)
                intensity(1,resultint(i,j))= intensity(1,resultint(i,j))+double(I(i,j));
                intensity(2,resultint(i,j))=intensity(2,resultint(i,j))+1;
            end
        end
    end
    finalresult=intensity(1,2:maxnumber)./intensity(2,2:maxnumber);
    spread=zeros(rows*2,columns*2);
    for i=1:rows
        for j=1:columns
            x=round(xCoordPlane(i,j));
            y=round(yCoordPlane(i,j));
            %up-left
            istart = max(1,y-poshift-search);
            jstart = max(1,x-poshift-search);
            iend = max(1,y-poshift+search);
            jend = max(1,x-poshift+search);
            temp = double(result(istart:iend,jstart:jend));
            temp = reshape(temp,1,[]);
            temp(temp==backgroundlabel|temp==0)=[];
            if(~isempty(temp))
                upleft = mode(temp);
                spread(2*i-1,2*j-1) = finalresult(upleft-1);
            end
            %up-right
            istart = max(1,y-poshift-search);
            jstart = min(dim(2),x+poshift-search);
            iend = max(1,y-poshift+search);
            jend = min(dim(2),x+poshift+search);
            temp = double(result(istart:iend,jstart:jend));
            temp = reshape(temp,1,[]);
            temp(temp==backgroundlabel|temp==0)=[];
            if(~isempty(temp))
                upright = mode(temp);
                spread(2*i-1,2*j) = finalresult(upright-1);
            end
            %low-left
            istart = min(dim(1),y+poshift-search);
            jstart = max(1,x-poshift-search);
            iend = min(dim(1),y+poshift+search);
            jend = max(1,x-poshift+search);
            temp = double(result(istart:iend,jstart:jend));
            temp = reshape(temp,1,[]);
            temp(temp==backgroundlabel|temp==0)=[];
            if(~isempty(temp))
                lowleft = mode(temp);
                spread(2*i,2*j-1) = finalresult(lowleft-1);
            end
            %low-right
            istart = min(dim(1),y+poshift-search);
            jstart = min(dim(2),x+poshift-search);
            iend = min(dim(1),y+poshift+search);
            jend = min(dim(2),x+poshift+search);
            temp = double(result(istart:iend,jstart:jend));
            temp = reshape(temp,1,[]);
            temp(temp==backgroundlabel|temp==0)=[];
            if(~isempty(temp))
                lowright = mode(temp);
                spread(2*i,2*j) = finalresult(lowright-1);
            end
        end
    end
    spreadsheetname=sprintf('%s%04d.xls',fname,k);
%     spread
    xlswrite(spreadsheetname,spread);
end

end

