   %% resize image resolution
            simg = size(imgdata);
            simg(1) = simg(1)-const.coor(4)-const.coor(2)-1;
            simg(2) = simg(2)-const.coor(3)-const.coor(1)-1;
            
            if all(simg(1:2)>0)
                rx=ceil(rand*simg(2));
                ry=ceil(rand*simg(1));
                imgdata=imgdata(ry:ry+const.coor(4)-const.coor(2)-1,rx:rx+const.coor(3)-const.coor(1)-1,:);
            end