%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Project : group 3
% Author : YANYU ZHANG
% Introduction :
% Date : 04/2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
clc;
% %% sound library
% [y1 Fs] =audioread('224.mp3');
% p1 = audioplayer(y1,Fs);
% [y2 Fs] =audioread('222.mp3');
% p2 = audioplayer(y2,Fs);
% [y3 Fs] =audioread('223.mp3');
% p3 = audioplayer(y3,Fs);
% [y4 Fs] =audioread('230.mp3');
% p4 = audioplayer(y4,Fs);
% [y5 Fs] =audioread('234.mp3');
% p5 = audioplayer(y5,Fs); 
% [y6 Fs] =audioread('236.mp3');
% p6 = audioplayer(y6,Fs); 
% [y7 Fs] =audioread('237.mp3');
% p7 = audioplayer(y7,Fs);
% [y8 Fs] =audioread('238.mp3');
% p8 = audioplayer(y8,Fs); 
% [y9 Fs] =audioread('239.mp3');
% p9 = audioplayer(y9,Fs);
% [y10 Fs] =audioread('240.mp3');
% p10 = audioplayer(y10,Fs);
% [y11 Fs] =audioread('resume.mp3');
% p11 = audioplayer(y11,Fs);
% [y12 Fs] =audioread('arrive.mp3');
% p12 = audioplayer(y12,Fs);
% [y13 Fs] =audioread('begin.mp3');
% p13 = audioplayer(y13,Fs);
% [y14 Fs] =audioread('elevator.mp3');
% p14 = audioplayer(y14,Fs);
% [y15 Fs] =audioread('correct.mp3');
% p15 = audioplayer(y15,Fs);
% [y16 Fs] =audioread('arrive.mp3');
% p16 = audioplayer(y16,Fs);
% [y17 Fs] =audioread('360.mp3');
% p17 = audioplayer(y17,Fs);
% [y18 Fs] =audioread('366.mp3');
% p18 = audioplayer(y18,Fs);
% [y19 Fs] =audioread('368.mp3');
% p19 = audioplayer(y19,Fs);
% [y20 Fs] =audioread('370.mp3');
% p20 = audioplayer(y20,Fs);
% [y21 Fs] =audioread('372.mp3');
% p21 = audioplayer(y21,Fs);
% [y22 Fs] =audioread('374.mp3');
% p22 = audioplayer(y22,Fs);
% [y23 Fs] =audioread('375.mp3');
% p23 = audioplayer(y23,Fs);
%% transfer room number
% play(p13);
a = input('please input the room number  ');

if a==240     %% room number
    travel = [4.6 -0.223 0 ; ...
              0 0 0];
%     play(p10);
    
elseif a==238    %% room number
      travel = [4.58 -0.48 0 ; ...
                3.27 -4.64 0 ; ...
                4.56 -4.56 0 ; ...
                4.58 -0.48 0 ; ... 
                0 0 0];
%     play(p8);

elseif a==236     %% room number
    travel = [4.58 -0.48 0 ; ...      %% Centering coordinates
              3.34 -10.7 0 ; ...      %% Room coordinates
              4.40 -10.8 0 ; ...      %% Centering coordinates
              4.58 -0.48 0 ; ...       %% Centering coordinates
              0 0 0];                  %% Origin coordinates

%     play(p6);

elseif a==234     %% room number
    travel = [4.58 -0.48 0 ; ...
              3.54 -17.1 0 ; ...
              4.79 -17.3 0 ; ...
              4.58 -0.48 0 ; ... 
              0 0 0];
    
    
%     play(p5);

elseif a==230    %% room number
    travel = [4.58 -0.48 0 ; ...
              3.83 -22.8 0 ; ...
              5.01 -23.0 0 ; ...
              4.58 -0.00243 0 ; ... 
              0 0 0];
    

%    play(p4);


          
elseif a== 000     %% elevator number
    travel = [4.58 -0.48 0 ; ...
              6.68 -23.5 0 ; ...
              8.47 -23.4 0 ; ...
              6.04 -23.4 0 ; ...
              5.34 -13.4 0 ; ...
              6.68 -23.5 0 ; ...
              8.47 -23.4 0 ; ...
              6.04 -23.4 0 ; ...
              4.58 -0.48 0 ; ...
              0 0 0];
%     play(p15);
else
     travel = [0 0 0];
%      play(p11);
end
disp(travel);
%%
rosshutdown;
ipaddress = '127.0.0.1';
rosinit(ipaddress);

robot = rospublisher('/cmd_vel');
movebase = rospublisher('/move_base/goal');
odom_subs = rossubscriber('/odom');
laser = rossubscriber('/scan');

velmsg = rosmessage(robot);
movebase_msg = rosmessage(movebase);
odom_msg = rosmessage(odom_subs);
laser_msg = rosmessage(laser);

%% This part is to close to the destination
movebase_msg.Goal.TargetPose.Header.FrameId = 'odom';
movebase_msg.Goal.TargetPose.Pose.Position.X = travel(1,1);
movebase_msg.Goal.TargetPose.Pose.Position.Y = travel(1,2);
movebase_msg.Goal.TargetPose.Pose.Position.Z = travel(1,3);
movebase_msg.Goal.TargetPose.Pose.Orientation.W = 1.0;
send(movebase,movebase_msg);

keepgoing = 1;
while (keepgoing)
    odom_rec = receive(odom_subs);
    x_current = odom_rec.Pose.Pose.Position.X;
    y_current = odom_rec.Pose.Pose.Position.Y;
    if sqrt((x_current-travel(1,1))^2 + (y_current-travel(1,2))^2) <=0.5
        break;
    end
end


movebase_msg.Goal.TargetPose.Header.FrameId = 'odom';
movebase_msg.Goal.TargetPose.Pose.Position.X = travel(2,1);
movebase_msg.Goal.TargetPose.Pose.Position.Y = travel(2,2);
movebase_msg.Goal.TargetPose.Pose.Position.Z = travel(2,3);
movebase_msg.Goal.TargetPose.Pose.Orientation.W = 1.0;
send(movebase,movebase_msg);

keepgoing = 1;
while (keepgoing)
    odom_rec = receive(odom_subs);
    x_current = odom_rec.Pose.Pose.Position.X;
    y_current = odom_rec.Pose.Pose.Position.Y;
    if sqrt((x_current-travel(2,1))^2+(y_current-travel(2,2))^2) <= 0.5
        k = 1;
%         play(p12);
        break;
    end
end

%% Judge the open/close of the elevator
% color =  rossubscriber('kinect2/hd/image_color');
% 
% while(1)
%     pic = receive(color);
%     I=readImage(pic);
%     imager = I(:,:,1);
%     imageg = I(:,:,2);
%     imageb = I(:,:,3);
%     imager_catch = imager([860:1060],[855:900]);
%     imageg_catch = imageg([860:1060],[855:900]);
%     imageb_catch = imageb([860:1060],[855:900]);
%     for i=1:1080
%         for j=1:1920
%             if((mean(imager_catch)>=100 && mean(imageg_catch)>=100 && mean(imageb_catch)>=100))    
%                 movebase_msg.Goal.TargetPose.Pose.Position.X = 8.28;
%                 movebase_msg.Goal.TargetPose.Pose.Position.Y = -23.4;
%                 movebase_msg.Goal.TargetPose.Pose.Position.Z = 0;
%                 movebase_msg.Goal.TargetPose.Pose.Orientation.W = 1.0;
%                 break;
%             end
%         end
%     end
% end
% 
% keepgoing = 1;
% while (keepgoing)
%     odom_rec = receive(odom_subs);
%     x_current = odom_rec.Pose.Pose.Position.X;
%     y_current = odom_rec.Pose.Pose.Position.Y;
%     if sqrt((x_current-8.28)^2+(y_current+23.4)^2) <=0.2
%         break;
%     end
% end
%% This part is to judge the open/close of elevator using hokuyo

% while (1)
%     k1 = 2;
%     laser_data = receive(laser);
%     filter_data = laser_data.Ranges(351:370,1);
%     filter_data(filter_data>10) = 0;
%     mean_filter = mean(filter_data);
%     if mean_filter >= 1
%         movebase_msg.Goal.TargetPose.Pose.Position.X = travel(3,1);
%         movebase_msg.Goal.TargetPose.Pose.Position.Y = travel(3,2);
%         movebase_msg.Goal.TargetPose.Pose.Position.Z = travel(3,3);   
%         k3 = 1;
%         break;
%     end
% end
% 
% send(movebase,movebase_msg);
% 
% keepgoing = 1;
% while (keepgoing)
%     k2 = 1;
%     odom_rec = receive(odom_subs);
%     x_current = odom_rec.Pose.Pose.Position.X;
%     y_current = odom_rec.Pose.Pose.Position.Y;
%     if sqrt((x_current-travel(3,1))^2+(y_current-travel(3,2))^2) <= 0.5
%         k4 = 1;
%         play(p12)
%         break;
%     end
% end


while (1)
    k1 = 2;
    laser_data = receive(laser);
    filter_data = laser_data.Ranges(351:370,1);
    filter_data(filter_data>10) = 0;
    mean_filter = mean(filter_data);
    if mean_filter >= 1
        movebase_msg.Goal.TargetPose.Header.FrameId = 'odom';
        movebase_msg.Goal.TargetPose.Pose.Position.X = travel(3,1);
        movebase_msg.Goal.TargetPose.Pose.Position.Y = travel(3,2);
        movebase_msg.Goal.TargetPose.Pose.Position.Z = travel(3,3); 
        send(movebase,movebase_msg);
        k3 = 1;
        break;
    end
end
send(movebase,movebase_msg);

keepgoing = 1;
while (keepgoing)
    odom_rec = receive(odom_subs);
    x_current = odom_rec.Pose.Pose.Position.X;
    y_current = odom_rec.Pose.Pose.Position.Y;
    if sqrt((x_current-travel(3,1))^2+(y_current-travel(3,2))^2) <=0.5
         
        break;
    end
end



i = 0;
while 1
    i = i+1;
    laser_msg = receive(laser);    
    velmsg.Angular.Z = 0.3;
    velmsg.Linear.X= 0 ; %change   
    pose = receive(odom_subs);
    x(i) = pose.Pose.Pose.Position.X; % extract the X
    y(i) = pose.Pose.Pose.Position.Y; % extract the Y
    W(i) = pose.Pose.Pose.Orientation.W; %choose the orientation of W
    Z(i) = pose.Pose.Pose.Orientation.Z; %choose the orientation of Z
    X(i) = pose.Pose.Pose.Orientation.X; %choose the orientation of X
    Y(i) = pose.Pose.Pose.Orientation.Y; %choose the orientation of Y
    c(i,:) = [W(i) X(i) Y(i) Z(i)]; %Compound W X Y Z to an array
    ang(i,:) = quat2eul(c(i,:)); %converts a quaternion rotation,quat,                                
    ang1(i,1) = ang(i,1);   
    if i>2
        if abs(ang1(i,1)-ang1(i-1,1))> pi
           ang1(i,1)=ang1(i,1)+2*pi;
        end
    end
    if ang1(i)-ang1(1) > 39*pi/40 && ang1(i)-ang1(1) < 41*pi/40
        velmsg.Angular.Z = 0;
        velmsg.Linear.X = 0;
        send(robot,velmsg);
        break;
    end 
    send(robot,velmsg);
end

  pause(20)

% % This part is to return to the initial point
movebase_msg.Goal.TargetPose.Header.FrameId = 'odom';
movebase_msg.Goal.TargetPose.Pose.Position.X = travel(4,1);
movebase_msg.Goal.TargetPose.Pose.Position.Y = travel(4,2);
movebase_msg.Goal.TargetPose.Pose.Position.Z = travel(4,3);
movebase_msg.Goal.TargetPose.Pose.Orientation.W = 1.0;
send(movebase,movebase_msg);

keepgoing = 1;
while (keepgoing)
    odom_rec = receive(odom_subs);
    x_current = odom_rec.Pose.Pose.Position.X;
    y_current = odom_rec.Pose.Pose.Position.Y;
    if sqrt((x_current-travel(4,1))^2+(y_current-travel(4,2))^2) <=0.5
        break;
    end
end

movebase_msg.Goal.TargetPose.Header.FrameId = 'odom';
movebase_msg.Goal.TargetPose.Pose.Position.X = travel(5,1);
movebase_msg.Goal.TargetPose.Pose.Position.Y = travel(5,2);
movebase_msg.Goal.TargetPose.Pose.Position.Z = travel(5,3);
movebase_msg.Goal.TargetPose.Pose.Orientation.W = 1.0;
send(movebase,movebase_msg);

keepgoing = 1;
while (keepgoing)
    odom_rec = receive(odom_subs);
    x_current = odom_rec.Pose.Pose.Position.X;
    y_current = odom_rec.Pose.Pose.Position.Y;
    if sqrt((x_current-travel(5,1))^2+(y_current-travel(5,2))^2) <=0.5
        k4=1;
        break;
    end
end

movebase_msg.Goal.TargetPose.Header.FrameId = 'odom';
movebase_msg.Goal.TargetPose.Pose.Position.X = travel(6,1);
movebase_msg.Goal.TargetPose.Pose.Position.Y = travel(6,2);
movebase_msg.Goal.TargetPose.Pose.Position.Z = travel(6,3);
movebase_msg.Goal.TargetPose.Pose.Orientation.W = 1.0;
send(movebase,movebase_msg);

keepgoing = 1;
while (keepgoing)
    odom_rec = receive(odom_subs);
    x_current = odom_rec.Pose.Pose.Position.X;
    y_current = odom_rec.Pose.Pose.Position.Y;
    if sqrt((x_current-travel(6,1))^2+(y_current-travel(6,2))^2) <=0.5
        k5=1;
        break;
    end
end
movebase_msg.Goal.TargetPose.Header.FrameId = 'odom';
movebase_msg.Goal.TargetPose.Pose.Position.X = travel(7,1);
movebase_msg.Goal.TargetPose.Pose.Position.Y = travel(7,2);
movebase_msg.Goal.TargetPose.Pose.Position.Z = travel(7,3);
movebase_msg.Goal.TargetPose.Pose.Orientation.W = 1.0;
send(movebase,movebase_msg);

keepgoing = 1;
while (keepgoing)
    odom_rec = receive(odom_subs);
    x_current = odom_rec.Pose.Pose.Position.X;
    y_current = odom_rec.Pose.Pose.Position.Y;
    if sqrt((x_current-travel(7,1))^2+(y_current-travel(7,2))^2) <=0.5
         k6=1;
        break;
    end
    
end

i = 0;
while 1
    i = i+1;
    laser_msg = receive(laser);    
    velmsg.Angular.Z = 0.3;
    velmsg.Linear.X= 0 ; %change   
    pose = receive(odom_subs);
    x(i) = pose.Pose.Pose.Position.X; % extract the X
    y(i) = pose.Pose.Pose.Position.Y; % extract the Y
    W(i) = pose.Pose.Pose.Orientation.W; %choose the orientation of W
    Z(i) = pose.Pose.Pose.Orientation.Z; %choose the orientation of Z
    X(i) = pose.Pose.Pose.Orientation.X; %choose the orientation of X
    Y(i) = pose.Pose.Pose.Orientation.Y; %choose the orientation of Y
    c(i,:) = [W(i) X(i) Y(i) Z(i)]; %Compound W X Y Z to an array
    ang(i,:) = quat2eul(c(i,:)); %converts a quaternion rotation,quat,                                
    ang1(i,1) = ang(i,1);   
    if i>2
        if abs(ang1(i,1)-ang1(i-1,1))> pi
           ang1(i,1)=ang1(i,1)+2*pi;
        end
    end
    if ang1(i)-ang1(1) > 39*pi/40 && ang1(i)-ang1(1) < 41*pi/40
        velmsg.Angular.Z = 0;
        velmsg.Linear.X = 0;
        send(robot,velmsg);
        break;
    end 
    send(robot,velmsg);
end

pause(20)
movebase_msg.Goal.TargetPose.Header.FrameId = 'odom';
movebase_msg.Goal.TargetPose.Pose.Position.X = travel(8,1);
movebase_msg.Goal.TargetPose.Pose.Position.Y = travel(8,2);
movebase_msg.Goal.TargetPose.Pose.Position.Z = travel(8,3);
movebase_msg.Goal.TargetPose.Pose.Orientation.W = 1.0;
send(movebase,movebase_msg);

keepgoing = 1;
while (keepgoing)
    odom_rec = receive(odom_subs);
    x_current = odom_rec.Pose.Pose.Position.X;
    y_current = odom_rec.Pose.Pose.Position.Y;
    if sqrt((x_current-travel(8,1))^2+(y_current-travel(8,2))^2) <=0.5
        k7=1;
        break;
    end
end
movebase_msg.Goal.TargetPose.Header.FrameId = 'odom';
movebase_msg.Goal.TargetPose.Pose.Position.X = travel(9,1);
movebase_msg.Goal.TargetPose.Pose.Position.Y = travel(9,2);
movebase_msg.Goal.TargetPose.Pose.Position.Z = travel(9,3);
movebase_msg.Goal.TargetPose.Pose.Orientation.W = 1.0;
send(movebase,movebase_msg);

keepgoing = 1;
while (keepgoing)
    odom_rec = receive(odom_subs);
    x_current = odom_rec.Pose.Pose.Position.X;
    y_current = odom_rec.Pose.Pose.Position.Y;
    if sqrt((x_current-travel(9,1))^2+(y_current-travel(9,2))^2) <=0.5
          k8=1;
        break;
    end
end
movebase_msg.Goal.TargetPose.Header.FrameId = 'odom';
movebase_msg.Goal.TargetPose.Pose.Position.X = travel(10,1);
movebase_msg.Goal.TargetPose.Pose.Position.Y = travel(10,2);
movebase_msg.Goal.TargetPose.Pose.Position.Z = travel(10,3);
movebase_msg.Goal.TargetPose.Pose.Orientation.W = 1.0;
send(movebase,movebase_msg);

keepgoing = 1;




while (keepgoing)
    odom_rec = receive(odom_subs);
    x_current = odom_rec.Pose.Pose.Position.X;
    y_current = odom_rec.Pose.Pose.Position.Y;
    if sqrt((x_current-travel(10,1))^2+(y_current-travel(10,2))^2) <=0.5
          k9=1;
        break;
    end
end

