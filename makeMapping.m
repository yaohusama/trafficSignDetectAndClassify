%直方图均衡函数
function mapping = makeMapping(imgHist,  fullRange, ...
    numPixInTile)%得到patch每一个灰度值变换后对应的灰度值，即表现为mapping

histSum = cumsum(imgHist);% cumsum：第1行到第m行的所有元素累加和。将像素叠加(1,1,2,3--->1,2,4,7)
valSpread  = fullRange(2) - fullRange(1);%255-0
  scale =  valSpread/numPixInTile;
  mapping = min(fullRange(1) + histSum*scale,...
                fullRange(2)); %limit to max (列向量)
end
