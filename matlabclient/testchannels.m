%Coherent-RTL-SDR
%
%Matlab script demonstrating CZMQSDR

%Receive samples, examine spectrum (in realtime if possible, but zmq-
%buffers can and will stretch if matlab polls the socket too slowly).

clear all;close all;

nframes = 10;

sdr = CZMQSDR('IPAddress','127.0.0.1');
FESR = 1e6; % 2048000;
scope = dsp.SpectrumAnalyzer(...
    'Name',             'Spectrum',...
    'Title',            'Spectrum', ...
    'SpectrumType',     'Power',...
    'FrequencySpan',    'Full', ...
    'SampleRate',        FESR, ...
    'YLimits',          [-50,5],...
    'SpectralAverages', 50, ...
    'FrequencySpan',    'Start and stop frequencies', ...
    'StartFrequency',   -FESR/2, ...
    'StopFrequency',    FESR/2);

for n=1:nframes
    [x,gseq,seq]=sdr();
    x = x - mean(x);
    scope(x(:,2:end)); %ch 1 is reference noise, exclude it from f.scope
end

release(sdr);