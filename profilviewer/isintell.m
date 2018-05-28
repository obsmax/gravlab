function rep=isintell(a,b,xo,yo,xA,yA)

rep = false(size(xA));
rep((abs(xA - xo) <= a) & (abs(yA - yo) < b*(sqrt(1 - ((xA-xo)/a).^2))))=true;