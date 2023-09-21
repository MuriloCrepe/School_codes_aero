close all; clear; clc
%% Sistemas de Controle

%Funcao transferencia: sys = tf(num,den) 
%Polos: pole(sys) 
%Zeros: zero(sys)
%Diagrama de Bode: bode(sys)
%Root Locus: pzmap(sys)
%Espaço de Estados: sys = ss(A,B,C,D) 

%Conversao EE <-> TF
%[num,den] = ss2tf(A,B,C,D)
%[A,B,C,D] = tf2ss(num,den)

%Para sistemas de segunda ordem
%FT: [num,den] = ord2(wn,zeta) 
%EE: [A,B,C,D] = ord2(wn,zeta)

%Entradas padrao unitarias
%Degrau: step(sys)
%Impulso: impulse(sys)
%Seno: lsim(sys,sin(t),t)
%Rampa: lsim(sys,t,t)

%% Comandos
%zeros(a,b) - Cria uma matriz de zeros com dimensões axb
%ones(a,b) - Cria uma matriz de 1 com dimensões axb
%eye(n) - Cria uma matriz identidade de ordem n
%A(end,:) - Apresenta a última linha de A 
%sum(A) - Soma dos valores de cada coluna de A
%diag(A) - Cria um vetor com os elementos da diagonal de A 
%transpose(A) - Cria a matriz transposta de A
%det(A) - Retorna o determinante da matriz A
%rank(A) - Retorna o número de linhas independentes de A
%inv(A) - Cria a matriz inversa de A
%eig(A) - Cria um vetor com os autovalores de A
%[V,D] = eig(A) - Cria um vetor V com os autovalores de A e uma matriz D com seus autovetores 
%poly(A) - Cria um vetor com os elementos da equação característica de A
%[r] = roots(y) - Raizes do Polinomio
%[r,p,k] = residue(num,den) // [num,den]=residue(r,p,k) - Fracoes Parciais
%[num,den] = series(num1,den1,num2,den2) - FT de blocos em serie
%[num,den] = parallel(num1,den1,num2,den2) - FT de blocos em paralelo
%[num,den] = feedback(num1,den1,num2,den2) - Realimentacao Padrao
%[num,den] = feedback(num1,den1,num2,den2,+1) - Realimentacao Positiva 

%% Plots

%Propriedades
%plot(t,y,'r--+')

%Multiplos Plots
%plot(x1,y1,'prop1',x2,y2,'prop2') 
%plot(x1,y1,'prop1'); hold on; plot(x2,y2,'prop2'); hold off
%subplot(2,1,1); plot(x1,y1,'prop1'); subplot(2,1,2); plot(x2,y2,'prop2')
%figure(1); plot(x1,y1,'prop1'); figure(2); plot(x2,y2,'prop2')

%Extras
%legend('x1','x2',...) - Insere legenda de x1, x2, ... 
%Title('texto') - Insere título no gráfico
%xlabel('x'), ylabel('y'), zlabel('z') - Nomeia os eixos x, y e z respectivamente 
%axis([xmin xmax ymin ymax]) - Limita a área apresentada pelo gráfico
%axis equal - O incremento nos eixos x e y ficam iguais 
%grid on - Cria uma malha no gráfico

%% Exemplo 1
%Subrotina para entrada degrau, variando zeta, wn = 1
t = 0:0.1:20; zeta = [0, 0.2, 0.5, 0.7, 1, 2]; wn = 1;
figure(1), hold on
for i = 1:length(zeta)
    [num,den] = ord2(wn,zeta(i));
    step(num,den,t)
end
plot(t,t*0+1,'k'), xlabel('Time'), ylabel('Amplitude'), grid on
legend('\zeta=0','\zeta=0.2','\zeta=0.5','\zeta=0.7','\zeta=1','\zeta=2','Degrau')

%% Exemplo 2
%Mesmo para impulso, rampa e parabola
t = 0:0.1:20; zeta = [0, 0.2, 0.5, 0.7, 1, 2]; wn = 1;
figure(2), hold on
for i = 1:length(zeta)
    [num,den] = ord2(wn,zeta(i));
    impulse(num,den,t)
end
plot([0 0],[0 1],'k'), xlabel('Time'), ylabel('Amplitude'), grid on
legend('\zeta=0','\zeta=0.2','\zeta=0.5','\zeta=0.7','\zeta=1','\zeta=2','Impulso')

figure(3), hold on
for i = 1:length(zeta)
    [num,den] = ord2(wn,zeta(i));
    sys = tf(num,den);
    lsim(sys,t,t)
end
plot(t,t,'k'), xlabel('Time'), ylabel('Amplitude'), grid on
legend('\zeta=0','\zeta=0.2','\zeta=0.5','\zeta=0.7','\zeta=1','\zeta=2','Rampa')
clc

figure(4), hold on
for i = 1:length(zeta)
    [num,den] = ord2(wn,zeta(i));
    sys = tf(num,den);
    lsim(sys,t.^2,t)
end
plot(t,t.^2,'k'), xlabel('Time'), ylabel('Amplitude'), grid on
legend('\zeta=0','\zeta=0.2','\zeta=0.5','\zeta=0.7','\zeta=1','\zeta=2','Parabola')
clc

%% Exemplo 3
%Resposta a degrau:
% Curva 1: wn = 0,5; zeta = 0.3 
% Curva 2: wn = 1; zeta = 0.3 
% Curva 3: wn = 2; zeta = 0.3

t = 0:0.1:20; wn = [0.5, 1, 2]; zeta = 0.3;
figure(5), hold on
for i = 1:length(wn)
    sys = tf(1,[1/wn(i)^2 2*zeta/wn(i) 1]);
    step(sys,t)
end
plot(t,t*0+1,'k'), xlabel('Time'), ylabel('Amplitude'), grid on
legend('wn=0.5','wn=1','wn=2','Degrau')

%% Desempenho de Sistemas
%Para se obter Frequência Natural, Amortecimento, Valores dos Polos e Constante de Tempo: damp(sys)
%Para se obter a multiplicação de polinômios: conv(poly1,poly2)

%% Exemplo 4 - Lockheed F-104 Starfighter
%Curto-período: 𝑠 + 0,269/𝑠2 + 0,911𝑠 + 4,884 
%Fugoide: 𝑠 + 0,133/𝑠2 + 0,015𝑠 + 0,021
numsp = [1 0.269]; numfg = [1 0.133];
densp = [1 0.911 4.884]; denfg = [1 0.015 0.021];
disp('Curto-periodo'), sp = tf(numsp,densp), damp(sp)
disp('Fugoide'), fg = tf(numfg,denfg), damp(fg)
disp('Longitudinal Completo'), long = tf(conv(numsp,numfg),conv(densp,denfg)), damp(long)

%% Exemplo 5
%G1(s) = 0,25/(s2 + s + 1)(s + 0,25)
%G2(s) = 1/(s2 + s + 1)(s + 1)
num1 = 0.25; 
den1 = [1 1 1]; den2 = [1 0.25];
sys1 = tf(num1,conv(den1,den2));
num2 = 1;
den3 = [1 1 1]; den4 = [1 1];
sys2 = tf(num2,conv(den3,den4));
figure(6), hold on
step(sys1,t,'b')
step(sys2,t,'g')
plot(t,t*0+1,'k'), xlabel('Time'), ylabel('Amplitude'), grid on
legend('G1','G2','Degrau')

%% Exemplo 6
%FT global e EE de sistema
%Controlador 1/s; Processo\Planta 10/(s+5); sensor 1/(s+1)
disp('Controlador'), sys1 = tf(1,[1 0])
disp('Processo'), sys2 = tf(10,[1 5])
disp('Sensor'), sys3 = tf(1,[1 1])
disp('Controlador e Processo - Cascata'), c = series(sys1,sys2)
disp('Sensor - Realimentacao'), disp('FT Global'), FT = feedback(c,sys3)

%% Exemplo 7
k = [1 2 5 10 12]; t = 0:0.01:1.5;
figure(7), hold on
for i = 1:length(k)
    sys1 = tf(6*k(i),1); sys2 = tf(1,[1 6 11 6]);
    Gma = series(sys1,sys2);
    Gmf = feedback(Gma,sys1);
    impulse(Gmf,t)
end
xlabel('Time'), ylabel('Amplitude'), grid on
legend('k = 1','k = 2','k = 5','k = 10','k = 12')

%% Root Locus
% Gráfico:   rlocus(sys)    rlocus(num,den)    rlocus(A,B,C,D)
% Vetor: r = rlocus(sys,K)  rlocus(num,den,K)  rlocus(A,B,C,D,K)

% Modificar área de plotagem: r = rlocus(sys,K), plot(r,'x'), plot(r,'o')

% Grades polares no LR: sgrid -> malhas para valores de 𝜁 e 𝜔𝑛 constantes
% Valor específico de de 𝜁 e 𝜔𝑛: sgrid(zeta,wn)

% Encontrar o ganho para um dado conjunto de raízes:
%[K,poles] = rlocfind(num,den)
%[K,poles] = rlocfind(num,den,p)

%syms s
%p = (s - pi)
%expand(p)

%% Exemplo 8
sys = tf([1 2],[1 5 4 0]);
figure(8)
rlocus(sys)
sgrid

%Adição de um polo
sys2 = tf([1 2],[1 11 34 24 0]);
figure(9)
rlocus(sys2)
sgrid
%Fica mais instável

%Adição de um zero
sys3 = tf([1 7 10],[1 11 34 24 0]);
figure(10)
rlocus(sys3)
sgrid
%Fica mais estável