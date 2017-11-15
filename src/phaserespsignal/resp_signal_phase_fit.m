function [resp_phase, resp_amp] = resp_signal_phase_fit(resp_sig)
%% respiratory phase signal
% Calculation of respiratory phase signal using the formulation in
% "Reconstructed respiration and cardio-respiratory
% phase synchronization in post-infarction patients"
% Aicko Y. Schumann et al 2010

%CT-respiration recording, x(t)
s = resp_sig';

% prerequisites: filtering and oscillating around 0
Fs = 10;                                                % Sampling Frequency (Hz)
Fn = Fs/2;                                              % Nyquist Frequency (Hz)
Wp = [0.2 3]/Fn;                                    % Passband Frequencies (Normalised)
Ws = [0.17 3.05]/Fn;                                    % Stopband Frequencies (Normalised)
Rp = 10;                                                % Passband Ripple (dB)
Rs = 50;                                                % Stopband Ripple (dB)
[n,Ws] = cheb2ord(Wp,Ws,Rp,Rs);                         % Filter Order
[z,p,k] = cheby2(n,Rs,Ws);                              % Filter Design
[sosbp,gbp] = zp2sos(z,p,k);                            % Convert To Second-Order-Section For Stability
figure(1)
freqz(sosbp, 2^16, Fs)                                  % Filter Bode Plot
tv = linspace(0, 1, length(s))/Fs;                      % Time Vector (s)
s_filt = filtfilt(sosbp,gbp, s);                        % Filter Signal

%x_t = s_filt - smooth(s_filt,'rlowess');
x_t = s_filt - smooth(s_filt,20);%rolling mean 22 stands for angular change of 10º
%figure;plot(smooth(s_filt,'rlowess')); title('smooth')
%x_t = x_t-mean(x_t);

%counterpart approach
x_t_complex_counterpart = hilbert(x_t);
resp_analitic = x_t_complex_counterpart.*1i+x_t;
resp_phase = angle(resp_analitic);
resp_amp = abs(resp_analitic);
figure; plot(resp_phase); title('respiratory phase signal')
hold on;
%plot(resp_amp);



end
%% sinusoidal fitting
% x = (0:0.1:719*0.1);
% y = resp_sig;%(401:420);
% yu = max(y);
% yl = min(y);
% yr = (yu-yl);                               % Range of ‘y’
% yz = y-yu+(yr/2);
% zx = x(yz .* circshift(yz,[0 1]) <= 0);     % Find zero-crossings
% per = 2*mean(diff(zx));                     % Estimate period
% ym = mean(y);                               % Estimate offset
% fit = @(b,x)  b(1).*(sin(2*pi*x./b(2) + 2*pi/b(3))) + b(4);    % Function to fit
% fcn = @(b) sum((fit(b,x) - y).^2);                              % Least-Squares cost function
% options = optimset('MaxFunEvals',1e10);
% s = fminsearch(fcn, [yr;  per;  -1;  ym],options);                       % Minimise Least-Squares
% xp = linspace(min(x),max(x));
% figure
% plot(x,y,'b',  xp,fit(s,xp), 'r')
% grid