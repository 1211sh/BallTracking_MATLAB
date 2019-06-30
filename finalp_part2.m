
cenS = 601;%ENTER SIZE OF cen arrays
LAvg = 0;
RAvg = 0;
TAvg = 0;

LC = 0;
RC = 0;
TC = 0;

state = [];
stateI = [];

%go through data once to get average position of player, and average height of table

start = 0;
bounce = 1;
hit = 2;



for i = 2:601 %use size of cen_x or y
    
X2 = cen_x(i);
X1 = cen_x(i-1);

Y2 = cen_y(i);
Y1 = cen_y(i-1);
       
    
Vx = X2-X1;%velocity
Vy = X2-Y1;

    
if(Vx > 0 && Vpx < 0)
LAvg = LAvg + (X2-X1)/2 + X1; %midpoint between frames
LC = LC+1;
    state(RC+LC+TC) = hit;
    stateI(RC+LC+TC) = i;

elseif(Vx < 0 && Vpx > 0)%current direction left, past direction left
    RAvg = RAvg + (X2-X1)/2 + X1;
    RC = RC+1;
    state(RC+LC+TC) = hit;
    stateI(RC+LC+TC) = i;
    %player right
    %p right return

elseif(Vy < 0 && Vpy > 0)
    TAvg = TAvg + (Y2-Y1)/2 + Y1;
    TC = TC+1;
    state(RC+LC+TC) = bounce;
    stateI(RC+LC+TC) = i;
    %bounce in state
    %bounce location
end


Vpx = X2-X1;
Vpy = Y2-Y1;

end

check = start;
score = [0, 0];
ralley = 0;


for i = 1:(RC+LC+TC) 
    
    X2 =cen_x(stateI(i));
X1 = cen_x(stateI(i)-1);

   Y2 =cen_y(stateI(i));
Y1 = cen_y(stateI(i)-1);
       
    
Vx = X2-X1;%velocity
Vy = Y2-Y1;
    
    if (check == start)%check for start
        if (state(i) == bounce && (Vx > Vy))%if Vx > Vy at state[bounce, not a from ball thrown up before serve
            
            if (Vx > 0)
                player = 1;%ball starts from left, right can score
            else
                player = 0;
            end
            
            if (player == 0 && (X2-LAvg < RAvg - X2) || player == 1 && (X2-LAvg > RAvg - X2)) % point loss if ball bounced after net
                score(player) = score(player) + 1;
            else
                check = bounce;
            end
        end
    elseif (check == bounce)%check for bounce
        if (state(i) == bounce) %speed not checked just in case ball barely makes it over net
        if (player == 0 && (X2-LAvg > RAvg - X2) || player == 1 && (X2-LAvg < RAvg - X2)) % point gained if ball bounced before net
                score(player) = score(player) + 1;
                check = start;
        else
                player = mod(player+1,2);%switch scoring player
                check = hit;
        end
        elseif(state(i) == hit)%point gained if ball hit before bounce
                score(player) = score(player) + 1;
        end   
     elseif (check == hit)%check for hit
         if(state(i) == hit)
             if(~((RAvg-LAvg)/3<X2 && X2<(RAvg-LAvg)*2/3))%not in the middle (net)
                 ralley = ralley + 1;   
             check = bounce;
             end
         elseif(state(i) == bounce)
             score(player) = score(player) + 1;%double bounce
                check = start;
         end
       end
end

            
    







%start
%if ball bounces closer to origin player, initialite ralley

%ralley
%if ball bounces closer to opponent, check for reurn
%loops if ball is returned (2 states)

%end ralley if
%ball is bounces twice before return
%ball doesn't return (goes below table?)
%ball returned before bounce (might be hard to diffrenciate due to motion blur)

%bounce is when ball changes y direction, doesn't change x direction
%return is when ball changes x direction
%return has priority over bounce (sometimes, ball will rise a little when returned


%ball rolling over net 
%if ball doesn't reach at least 1/2 of max height before serve (eh)
%horizontal speed slowed (1/4?), but x direction is not changed
%if ball bounces at center (if average player positions are percise enough)
%if ball bounces above where table is (if average table is percise enough)


%net bounce is 2 diffrent sinerios
%if returned on the rise, high, check if resulting bounce is high
%if returned going straight, 


%2:57 and 2:58, lighting changes
%3:41, difficult net bounce



%likely can't be caught: ball glancing off table
%maybe could be caught by seeing checking for drastic speed change in y,
%better the glance, the harder it is to check

