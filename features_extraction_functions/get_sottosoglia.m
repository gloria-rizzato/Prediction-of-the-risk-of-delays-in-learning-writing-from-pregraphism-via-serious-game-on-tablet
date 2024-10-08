function [tempo_sotto_soglia,soglia]=get_sottosoglia(speed, new_time)
 
percentuale=nanmin(speed) + 3/100*range(speed);
comp=0.05;

% if percentuale<comp
    soglia=percentuale;
% else
%     soglia=comp;
% end


sotto=0;
tempoTot=0;

for pos=1:size(speed,1)
    if (speed(pos,1) < soglia) && (sotto==0)
            sotto=1;
            temposotto = new_time(pos,1);
        end

    
    if sotto==1 && speed(pos,1) > soglia
            sotto=0;
            temposopra= new_time(pos,1);

            timeUnder= temposopra - temposotto;
            tempoTot= tempoTot + timeUnder;
        end
    end


tempo_sotto_soglia= tempoTot;
    


end
