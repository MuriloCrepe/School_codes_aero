clear, clc, close all
%% Compensador Avanço de Fase
% FT de rolagem por deflexão de leme:
num = 0.1*[1 2.83]; den = [1 0.19 1.04]; G_ma = tf(num,den);
[wn,zeta] = damp(G_ma);
fprintf('FT de rolagem associada à guinada:'), G_ma
fprintf('Com frequência natural %f e amortecimento %f\n',wn(1),zeta(1))
wnd = 2; zetad = 0.6;
fprintf('Deseja-se um compensador que forneça wn = %.1f rad/s e zeta = %.1f\n',wnd,zetad)

figure('Name','LR do sistema sem compensador'), hold on
rlocus(G_ma), sgrid(zetad,wnd)
k = 40.5; %[k,p] = rlocfind(G);
G_mf = feedback(k*G_ma,1);

% Polo desejado:
sig = zetad*wnd; wd = wnd*sqrt(1-zetad^2); pd = [-sig + wd*1i, -sig - wd*1i];
plot(-sig,wd,'rx'), plot(-sig,-wd,'rx')
text(-sig+0.1,+wd,'pd','color','r')
text(-sig+0.1,-wd,'pd','color','r')
hold off

% Projeto de compensador por avanço de fase:
zc = -sig;
poles = pole(G_ma);
zeros = zero(G_ma);
theta_pc = - pi + pi/2;
for i = 1:length(poles)
    theta_pc = theta_pc - atan(wd/(poles(i) - zc)); 
end
for i = 1:length(zeros)
    theta_pc = theta_pc + atan(wd/(zeros(i) - zc)); 
end
pc = wd/tan(theta_pc) + zc;

num = conv(num,[1 -zc]); den = conv(den,[1 -pc]); Gc_ma = tf(num,den); 
figure('Name','LR com polo e zero do compensador'), hold on
rlocus(Gc_ma), sgrid(zetad,wnd) 
text(zc+0.05,0.1,'z_c','color','b')
text(pc+0.05,0.1,'p_c','color','b')
plot(-sig,wd,'rx'), plot(-sig,-wd,'rx')
kc = 20.5; %[Kc,Pd] = rlocfind(G_ma);
Gc_mf = feedback(kc*Gc_ma,1);

fprintf('Zeros do sistema sem compensador: z = %.2f\n',zeros(1)) 
fprintf('Polos do sistema sem compensador: p = %s  %s\n',num2str(poles(1)),num2str(poles(2)))
fprintf('Ganho do sistema para amortecimento desejado: k = %.2f\n',k)
fprintf('Polos desejados: pd = %s %s\n',num2str(pd(1)),num2str(pd(2)))
fprintf('Zero do compensador: zc = %.2f\n',zc)
fprintf('Polo do compensador: pc = %.2f\n',pc)
fprintf('Ganho do compensador: kc = %.2f\n',kc)
%% Verificação

% Resposta em degrau
t = 0:0.01:6;
figure('Name', 'Resposta degrau da FT de malha fechada'), hold on
step(G_mf,t,'b')
step(Gc_mf,t,'r')
plot(t,0*t+1,'--k')
legend('Sem compensador','Com compensador','Degrau unitário'), grid on

% Resposta ao impulso
t = 0:0.01:6;
figure('Name', 'Resposta impulso da FT de malha fechada'), hold on
impulse(G_mf,t,'b')
impulse(Gc_mf,t,'r')
plot([0 0],[0 1],'-k')
legend('Sem compensador','Com compensador','Impulso unitário'), grid on