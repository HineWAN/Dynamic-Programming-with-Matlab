clearvars;
clc
%%
eta_electric = 0.90;         % motor efficiency 
load Pd.mat;                 % Driver's demanded power over 10 minute cycle 
SOC_bat = 30:80;             % Battery's SOC range
P_electric = -500:5:500;
time = 1:600;                % time during which driver's demanded power
J_mat = zeros(600,51);
cost = zeros(1,51);
%% 
for t = 599:-1:1             % time during which power was demanded 
   for soc = 51:-1:1                                % for SOC
         for m = 201:-1:1                       % electric motor
           Pengine_net = Pd(600) - eta_electric*P_electric(m);       % as given
           etaeng=0.3-(Pengine_net-400).^2./(400^2/.3);            % as provided
          if etaeng<0.05
           etaeng=0.05;
          end
          
          P_engine = round(Pengine_net/etaeng);       % determined engine power
   
          if (P_engine < 0) || (P_engine > 2000)     % engine power has to be in between 0 & 2000 KW
             P_engine = inf;                      % else it will go infinity
          end
          
          P_engine(m, 1) = P_engine;       % formed vector for time t
          etaeng_vector(m, 1) = etaeng;   % formed vector for engine efficiency varying over operating range of engine
          
          if SOC(soc) == 70
              dell = 0;
          else 
              dell = 1000000;
          end
          cost(m,1) = P_engine + dell;   % defined cost vector (state + control)
         end
         cost_min(soc, 1) = SOC_bat(soc);
         [cost_min(m, 2), r] = min(cost);
         cost_min(soc, 3) = P_engine(r,1);
         cost_min(soc, 4) = P_electric(r);
         cost_min(soc, 5) = etaeng_vector(r);
         cost_min(soc, 6) = Pd(600);
   end
   s= struct([]);
   s(600).cost_new = cost_min;
   s(600).
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
for m = length(P_electric):-1:1
          if (x_dot(m) >= 30)  && (x_dot(m) <= 80)   %SOC has to be in between 30 & 80
              J_new(m) = cost(x_dot(m) - 29);    
          else
              J_new(m) = inf;
          end
end

end
J_mat(t,:)= Cost_min;
index(t,:) = index_1;
end
%% 

target_SOC = find(SOC_bat ==70);                              % SOC need to be achived
x_0 = 70;                                                     % initial SOC as given 70%
for t = 1:599
    target_SOC = find(SOC_bat==round(x_0(t)));
    el_ind_mat = index(t,target_SOC);
    P_electric_current(t) = P_electric(el_ind_mat);
    x_0(t+1) = round(x_0(t) - P_electric_current(t)/360);
    if x_0(t+1) < min(SOC_bat)
        P_electric_current
    end 
    
    Pengnet_current(t) = Pd(t) - eta_electric * P_electric_current(t);   % engine power at time t
    etaeng=0.3-(Pengnet_current(t)-400).^2./(400^2/.3);                  % as provided
        if etaeng<0.05
           etaeng=0.05;
        end
        etaeng_vector = etaeng;                        % formed vector for engine efficiency varying over operating range of engine
        P_eng_current = Pengnet_current(t)/etaeng;     % determined engine power
        P_eng_req(t) = P_eng_current;
end 
%% Plotting
figure(1)  
plot(time, x_0(1:599));     % crrent SOC
xlabel('Time(sec)')
ylabel('State of Charge(%)')
legend('Battery SOC');
title('Optimal Control');
figure(2)
plot(time, Pd(1:599), time, P_electric_current*0.9, time, Pengnet_current(1:599));
xlabel('Time(sec)')
ylabel('Power(Kw)')
legend('Demanded Power', 'Power from Batterey', 'Power from Engine');
title('Optimal Control');
grid on;
figure(3)
plot(time, Pd(1:599), time, P_electric_current*0.9); 
xlabel('Time(sec)')
ylabel('Power(Kw)')
legend('Demanded Power', 'Power from Batterey');
title('Optimal Control'); 
figure(4)
plot(time, Pd(1:599), time, Pengnet_current(1:599));
xlabel('Time(sec)')
ylabel('Power(Kw)')
legend('Demanded Power', 'Power from Engine');
title('Optimal Control');  
su = fliplr(Pengnet_current);
optimal_cost = cumsum(su);
optimal_cost = fliplr(optimal_cost);
figure(5)
plot(time, optimal_cost(1:599))
xlabel('Time(sec)')
ylabel('Cost')
legend('Cost');
title('Optimal Trajectory');  

