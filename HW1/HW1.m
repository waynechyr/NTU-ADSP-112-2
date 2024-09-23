N_val = 17;            
k_val = (N_val - 1)/2;      
delta_val = 0.0001;     
fs_val = 6000;
trbandleft_val = 1200; % Transition band range
trbandright_val = 1500;

F_val = [0; 0.05; 0.10; 0.13; 0.16; 0.29; 0.35; 0.4; 0.45; 0.5]; % Avoid transition band
f_val = 0:delta_val:0.5;
Hd_val = f_val <= 0.225;

A_val = zeros(k_val+2,k_val+2);   
S_val = zeros(k_val+2,1);    
H_val = zeros(k_val+2,1);    

H_val = F_val <= (trbandright_val/fs_val);
Wp_val = 1.0*(f_val<=(trbandleft_val/fs_val)); % Define the Weight Function
Ws_val = 0.6*(f_val>=(trbandright_val/fs_val));
Wt_val = 0;
W_val = Wp_val+Ws_val+Wt_val;

E1_val = 1000;
E0_val = 1;
while((E1_val-E0_val > delta_val) || (E1_val-E0_val < 0)) 
    for i_val = 1:1:10
        for j_val = 1:1:9
            A_val(i_val,j_val) = cos(2*pi*(j_val-1)*F_val(i_val));
        end
        A_val(i_val,10)=(-1)^(i_val-1)*1/Wf_func(F_val(i_val));
    end
    S_val = A_val\H_val;  
    
    RF_val = 0;
    for i_val = 1:9
        RF_val = RF_val + S_val(i_val)*cos(2*(i_val-1)*pi*f_val);
    end
    err_val = (RF_val-Hd_val).*W_val;
   
    q_val = 2;
    for i_val = 2:length(f_val)-1
        if(err_val(i_val) > err_val(i_val-1) && err_val(i_val) > err_val(i_val+1))
            F_val(q_val) = delta_val*i_val;
            q_val = q_val+1;
        end
        if(err_val(i_val) < err_val(i_val-1) && err_val(i_val) < err_val(i_val+1))
            F_val(q_val) = delta_val*i_val;
            q_val = q_val+1;
        end
    end
    E1_val = E0_val;
    [max_value_val, max_locs_val] = findpeaks(err_val);
    [min_value_val, min_locs_val] = findpeaks(-err_val);
    E0_val = max(max(abs(err_val)))
    F_val = sort([0 (max_locs_val-1)*delta_val (min_locs_val-1)*delta_val 0.5]);
    F_val = F_val';
end

h_val(k_val+1) = S_val(0+1);
for i_val = 1:k_val
    h_val(k_val+i_val+1) = S_val(i_val+1)/2;
    h_val(k_val-i_val+1) = S_val(i_val+1)/2;
end

subplot(211)
plot(f_val, RF_val,'k',f_val ,Hd_val,'b')
title('Frequency Response');
xlabel('frequency(Hz)');
x_val = 0:1:16;

subplot(212)
stem(x_val,h_val)
title('Impulse Response');
xlabel('time');
xlim([-1 17])

function w_val = Wf_func(F_val)
if F_val >= 0.25
    w_val = 0.6;
end
if F_val <= 0.2
    w_val = 1;
end
end
