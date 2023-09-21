clear, clc, close all
%% Dinâmica Longitudinal
% FTs de Fugoide e Curto-período:
Gfg = tf([1 -0.0006],[1 0.014 0.0068]);
disp('FT da Fugoide'), Gfg
[wn_fg, zeta_fg] = damp(Gfg);
fprintf('Com frequência natural %f e amortecimento %f\n',wn_fg(1),zeta_fg(1))

Gsp = tf([1 -115.28],[1 1.009 5.56]);
disp('FT do Curto-período'), Gsp
[wn_sp, zeta_sp] = damp(Gsp);
fprintf('Com frequência natural %f e amortecimento %f\n',wn_sp(1),zeta_sp(1))

% Entrada Degrau:
[Ys_fg,ts_fg] = step(Gfg);
[Ys_sp,ts_sp] = step(Gsp);
subplot(3,3,1)
plot(ts_fg,Ys_fg,'b')
title('Resposta a Degrau - Fugoide'), xlabel('Time'), ylabel('Amplitude'), legend('Fugoide'), grid on
subplot(3,3,2)
plot(ts_sp,Ys_sp,'g')
title('Resposta a Degrau - Curto-período'), xlabel('Time'), ylabel('Amplitude'), legend('Curto-período'), grid on
subplot(3,3,3), hold on
plot(ts_fg,Ys_fg,'b')
plot(ts_sp,Ys_sp,'g')
title('Resposta a Degrau - Longitudinal'), xlabel('Time'), ylabel('Amplitude'), legend('Fugoide','Curto-período'), grid on

% Entrada Rampa:
tg = 0:0.01:1000; u = 1*tg;
[Yr_fg,tr_fg] = lsim(Gfg,u,tg);
[Yr_sp,tr_sp] = lsim(Gsp,u,tg);
subplot(3,3,4)
plot(tr_fg,Yr_fg,'b')
title('Resposta a Rampa - Fugoide'), xlabel('Time'), ylabel('Amplitude'), legend('Fugoide'), grid on
subplot(3,3,5)
plot(tr_sp,Yr_sp,'g')
title('Resposta a Rampa - Curto-período'), xlabel('Time'), ylabel('Amplitude'), legend('Curto-período'), grid on
subplot(3,3,6), hold on
plot(tr_fg,Yr_fg,'b')
plot(tr_sp,Yr_sp,'g')
title('Resposta a Rampa - Longitudinal'), xlabel('Time'), ylabel('Amplitude'), legend('Fugoide','Curto-período'), grid on

% Entrada Impulso:
[Yi_fg,ti_fg] = impulse(Gfg);
[Yi_sp,ti_sp] = impulse(Gsp);
subplot(3,3,7)
plot(ti_fg,Yi_fg,'b')
title('Resposta a Impulso - Fugoide'), xlabel('Time'), ylabel('Amplitude'), legend('Fugoide'), grid on
subplot(3,3,8)
plot(ti_sp,Yi_sp,'g')
title('Resposta a Impulso - Curto-período'), xlabel('Time'), ylabel('Amplitude'), legend('Curto-período'), grid on
subplot(3,3,9), hold on
plot(ti_fg,Yi_fg,'b')
plot(ti_sp,Yi_sp,'g')
title('Resposta a Impulso - Longitudinal'), xlabel('Time'), ylabel('Amplitude'), legend('Fugoide','Curto-período'), grid on

% FT Global Longitudinal:
G = Gfg*Gsp;
disp('FT da Dinâmica Longitudinal'), G

% Zeros e polos
zeros = zero(G); poles = pole(G);
disp('Zeros da Dinâmica Longitudinal:'), disp(zeros)
disp('Polos da Dinâmica Longitudinal:'), disp(poles)

% Resposta a Degrau geral e detalhada:
[Yg, tg] = step(G);
tau_sp = 1/(zeta_sp.*wn_sp);
[Yd, td] = step(G,3*tau_sp(1));
figure(2)
plot(tg,Yg,'r')
title('Resposta a Degrau - Global'), xlabel('Time'), ylabel('Amplitude'), legend('Curva Geral'), grid on
figure(3)
plot(td,Yd,'g')
title('Resposta a Degrau - Global'), xlabel('Time'), ylabel('Amplitude'), legend('Curva Detalhada'), grid on
