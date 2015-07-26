clear;
data=importdata('C:\Fraps\Benchmarks\csgo 2015-07-21 21-53-19-41 frametimes.csv'); %Path to the benchmark from fraps
FPSresolution=0.5;      %Time[s] while frames beeing counted. 
aboveTimems=1000/144;   %Accumulated time is counted if frametime is above this time
Percentile=0.1;         %Parcentile Framerate
targetFps=144;          %Target FPS, there will be a red line in the graph.

frameData=data.data(:,2);
frames=data.data(:,1);
[numberOfFrames t]=size(frameData);
frameTime=frameData(2:numberOfFrames)-frameData(1:numberOfFrames-1);
fps=1000./frameTime;

figure(1)
plot(frameTime)
line([1:numberOfFrames-1],(1000/targetFps)*ones(numberOfFrames-1,1),'Color','r')
ylabel('Frametime [ms]');
xlabel('Frame');
title('Frametimes during 60s CSGO deathmatch')
grid on

figure(2)
plot(fps)
line([1:numberOfFrames-1],(targetFps)*ones(numberOfFrames-1,1),'Color','r')
ylabel('FPS');
xlabel('Frame');
title('FPS during 60s CSGO deathmatch')
grid on

figure(3)
hist(frameTime,200)
grid on



last=0;

timeFrame=round(frameData(numberOfFrames)/1000/FPSresolution);
trueFPS=(zeros(timeFrame,1));
time=0;
timeSpendAbove=0;
for i = 1:(numberOfFrames-1)
    if(frameData(i)>((time+1)*FPSresolution)*1000)
        
        time=time+1;
        trueFPS(time)=(i-last)/FPSresolution;
        last=i;
    end
    if(frameTime(i)>aboveTimems)
        timeSpendAbove=timeSpendAbove+frameTime(i)-aboveTimems;
    end
end
x=0:FPSresolution:timeFrame*FPSresolution-FPSresolution;
figure(4)
plot(x,trueFPS)
line(x,(targetFps)*ones(timeFrame,1),'Color','r')
grid on

sortX=0:100/(numberOfFrames-1):100-100/(numberOfFrames-1);

figure(5)
sortedTime=sort(frameTime);
plot(sortX,sortedTime);
grid on

PercentageOfFramesBelowTarget = sum(frameTime > 1000/targetFps)/(numberOfFrames-1)*100
PercentileFrameRate=1000/sortedTime(round((numberOfFrames-1)*(100-Percentile)/100))
timeSpendAbove