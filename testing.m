
clear all;
close all;

% define filepath and names to read
f = readtable('/MATLAB Drive/noisy_signal.csv');
fclean = readtable('/MATLAB Drive/clean_signal.csv');
f = f{:,:};
fclean = fclean{:,:};

% remove the dc component
dc_component = mean(f);
dc_component_clean = mean(fclean);
f = f - dc_component;
fclean = fclean - dc_component_clean;

% 200Hz sample rate for signal from files
Fs = 200;
dt = 1/Fs;
t = 0:dt:20;
t = t(1:4000); % one too many points

% noisy and clean signals from hte YT example
% YT example, uncomment below to run
% Fs = 1000;
% dt = 1/Fs;
% t 0:dt:1;
% fclean = sin(2*pi*50*t) + sin(2*pi*120*t);
% f = fclean + 2.5*randn(size(t));

figure; set(gcf, 'Position', [1500 200 2000 2000])
subplot(3,1,1)
plot(t,f,'c'), hold on
plot(t, fclean, 'k')
legend('Noisy','Clean');
xlabel('Time (s)');
ylabel('Amplitude (v)');

% perform fft, setup PSD and plot half freq. spectra
n = length(t);
fhat = fft(f,n);
PSD = fhat.*conj(fhat)/n;
freq = 1/(dt*n)*(0:n);
L = 1:floor(n/2);

subplot(3,1,3);
stem(freq(L), PSD(L), 'c')
xlabel('DFT Frequency Bin');
ylabel('Amplitude');

%{
*************************************************************
TODO
*************************************************************
manually filter based on the PSD plot
Should be >100 for sine waves from the YouTube example
Should be >20 for signal from files
%}
indices = (PSD<20);  % find freq with large power
PSDclean = PSD.*indices; % zero everything else
fhat = indices.*fhat; % filter out the small freq
ffilt = ifft(fhat); % inverse ffs for filtered time signal

subplot(3,1,2);
plot(t,ffilt,'m-')
% ylim([-10 10])    % UNCOMMENT WHEN RUNNING YT EXAMPLE
legend('Filtered');
xlabel('Time (s)');
ylabel('Amplitude (v)');
