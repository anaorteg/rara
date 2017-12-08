function [resp_phase, resp_amp] = resp_signal_phase_fit(resp_sig)
%% respiratory phase signal
% Calculation of respiratory phase signal using the formulation in
% "Reconstructed respiration and cardio-respiratory
% phase synchronization in post-infarction patients"
% Aicko Y. Schumann et al 2010

%CT-respiration recording, x(t)
s = resp_sig';%- smooth(resp_sig',20);%rolling mean 22 stands for angular change of 10º%-mean(resp_sig);

%counterpart approach
x_t =s;%-smooth(s,20);%*44000;
x_t_complex_counterpart = hilbert(x_t);
resp_analitic = x_t_complex_counterpart.*1i+x_t;
resp_phase = angle(resp_analitic);
resp_amp = abs(resp_analitic);
figure; plot(resp_phase); title('respiratory phase signal')

figure; plot(resp_amp); title('respiratory amplitude signal')


end
