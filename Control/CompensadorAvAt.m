clear, clc, close all
%% Compensador por avanço e atraso de fase
% Máximo sobressinal 25%; Tempo de acomodação 2s (5%); Erro regime 5%
num = 1; den = conv(conv([1 1],[1 4]),[1 6]); G_ma = tf(num,den);
figure('Name','LR do sistema sem compensador'), hold on
rlocus(G_ma)
%
k = 70.5; %[k,p] = rlocfind(G_ma);
G_mf = feedback(k*G_ma,1);

% Especificações de desempenho:
Mp_d = 25/100; ts_d = 2; ess_d = 5/100; 
v = [4.6, 4, 3]; crit = 3; %Critérios [1% 2% 5%]

% Parâmetros:
zeta_d = sqrt((log(Mp_d)/pi)^2/(1 + (log(Mp_d)/pi)^2)); wn_d = v(crit)/zeta_d*1/ts_d;
sgrid(zeta_d,wn_d)

% Polo desejado:
sig = zeta_d*wn_d; wd = wn_d*sqrt(1-zeta_d^2); pd = [-sig + wd*1i, -sig - wd*1i];
plot(-sig,wd,'rx'), plot(-sig,-wd,'rx')
text(-sig+0.15,+wd+0.5,'pd','color','r')
text(-sig+0.15,-wd-0.5,'pd','color','r')
hold off

% Projeto de compensador por avanço de fase:
zc_av = -sig;
poles = pole(G_ma);
zeros = zero(G_ma);
theta_pc_av = - pi + pi/2;
for i = 1:length(poles)
    theta_pc_av = theta_pc_av - atan(wd/(poles(i) - zc_av)); 
end
% for i = 1:length(zeros)
%     theta_pc_av = theta_pc_av + atan(wd/(zeros(i) - zc_av)); 
% end
pc_av = wd/tan(theta_pc_av) + zc_av;

% Adicionar pc_av e zc_av ao sistema:
num2 = conv(num,[1 -zc_av]); den2 = conv(den,[1 -pc_av]); Gc_av_ma = tf(num2,den2); 
figure('Name','LR com polo e zero do compensador por avanço de fase'), hold on
rlocus(Gc_av_ma), sgrid(zeta_d,wn_d) 
text(zc_av+0.05,0.15,'z_c^{av}','color','b')
text(pc_av+0.05,0.15,'p_c^{av}','color','b')
plot(-sig,wd,'rx'), plot(-sig,-wd,'rx')
text(-sig+0.15,+wd+0.5,'pd','color','r')
text(-sig+0.15,-wd-0.5,'pd','color','r')
kc_av = 82.8; %[Kc,Pd] = rlocfind(G_av_ma);
Gc_av_mf = feedback(kc_av*Gc_av_ma,1);

% Verificação da resposta transitória - Entrada degrau
t = 0:0.01:6;
figure('Name', 'Resposta degrau da FT de malha fechada'), hold on
step(G_mf,t,'r')
step(Gc_av_mf,t,'b')
legend('Sem compensador','Com compensador de avanço de fase'), grid on

% Constante de erro estático
kp = k; % Constante de Posição
for i = 1:length(poles)
    kp = kp/abs(poles(i)); 
end
As = 1; % Degrau Unitário
kp_d = (As - ess_d)/ess_d;

% Adicionar pc_at e zc_at ao sistema:
alpha = kp_d/kp; 
pc_at = 0.1; zc_at = pc_at*alpha;
num3 = conv(num2,[1 zc_at]); den3 = conv(den2,[1 pc_at]); Gc_ma = tf(num3,den3);
figure('Name','LR com polo e zero do compensador por atraso de fase'), hold on
rlocus(Gc_ma), sgrid(zeta_d,wn_d) 
text(zc_av+0.05,0.15,'z_c^{av}','color','b')
text(pc_av+0.05,0.15,'p_c^{av}','color','b')
text(-zc_at+0.05,0.15,'z_c^{at}','color','g')
text(-pc_at+0.05,0.15,'p_c^{at}','color','g') 
plot(-sig,wd,'rx'), plot(-sig,-wd,'rx')
text(-sig+0.15,+wd+0.5,'pd','color','r')
text(-sig+0.15,-wd-0.5,'pd','color','r')

% Achar ganho final
kc = 76.7; %[Kc,pd] = rlocfind(Gc_ma)
Gc_mf = feedback(kc*Gc_ma,1);

% Verificação da resposta transitória - Entrada degrau
t = 0:0.01:6;
figure('Name', 'Resposta degrau da FT de malha fechada'), hold on
step(G_mf,t,'r')
step(Gc_av_mf,t,'b')
step(Gc_mf,t,'g')
legend('Sem compensador','Com compensador de avanço de fase','Com compensador de avanço e atraso de fase'), grid on

% Ajustes finos
p_af = pc_av - 0.525; z_af = zc_av + 0;
num4 = conv(conv(num,[1 -z_af]),[1 zc_at]); den4 = conv(conv(den,[1 -p_af]),[1 pc_at]); Gc_ma_final = tf(num4,den4);
figure('Name','LR após ajustes finos'), hold on 
rlocus(Gc_ma_final), sgrid(zeta_d,wn_d) 

kc_final = 90; %[Kc,pd] = rlocfind(Gc_ma_final)
Gc_mf_final = feedback(kc_final*Gc_ma_final,1);

% Verificação após ajustes finos
t = 0:0.01:6;
figure('Name', 'Resposta degrau da FT de malha fechada'), hold on
step(G_mf,t,'r')
step(Gc_av_mf,t,'b')
step(Gc_mf,t,'g')
step(Gc_mf_final,t,'k')
legend('Sem compensador','Com compensador de avanço de fase','Com compensador de avanço e atraso de fase','Após ajustes finos'), grid on
