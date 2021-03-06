%% Galileo Reconstruction by John Clouse
%% Initialize
CelestialConstants;
color_order = get(groot,'defaultAxesColorOrder');

% Set up the baseline events
JD_Launch = 2447807.5; %October 8, 1989 00:00:00
JD_VGA = 2447932.5; % February 10, 1990 00:00:00
JD_EGA1 = 2448235.5; % December 10, 1990 00:00:00
JD_EGA2 = 2448966.0; % December 9, 1992 12:00:00
JD_JOI = 2450164.0; % March 21, 1996 12:00:00

% Anonymous function to print out the dates.
getDate = @(x_date) ...
    datestr(x_date-(floor(juliandate(date)) - datenum(date)),0);

%% Porkchop plots
% Launch to VGA
offset = 60;
window = -offset:0.5:offset;
Launch_dep = JD_Launch + window;
VGA_arr = JD_VGA + window;

params1.fig_dim = hw_pub.figPosn;
params1.Sun = Sun;
params1.planet1 = Earth;
params1.planet2 = Venus;
params1.c3_countours = 10:1:21;
params1.v_inf_arr_countours = 1:1:13;
params1.v_inf_dep_countours = 11:1:23;
params1.TOF_countours = 50:50:500;
params1.day2sec = day2sec;
params1.show_c3 = true;
params1.show_v_inf_dep = false;
params1.show_v_inf_arr = true;
params1.show_tof = true;
params1.debug = false;

[ fh , output_Launch_VGA, legend_vec, legend_cells] = PorkchopPlot( Launch_dep, VGA_arr, ...
    params1);
figure(fh);
title('Launch to VGA');
JD_true_launch = juliandate(1989,10,13,16,53,40);
JD_true_VGA = juliandate(1990,2,10);
legend_vec = [legend_vec ...
    plot(JD_Launch, JD_VGA,'d',...
    'Color',color_order(2,:),'LineWidth',hw_pub.lineWidth) ...
    plot(JD_true_launch, JD_true_VGA, 'd',...
    'Color',color_order(4,:),'LineWidth',hw_pub.lineWidth) ];
legend_cells = {legend_cells{:} 'Baseline Trajectory' 'Designed Trajectory'};
legend(legend_vec, legend_cells, 'Location', 'NorthWest')
figure('Position',hw_pub.figPosn);
plot(JD_Launch, JD_VGA,'d',...
    'Color',color_order(2,:),'LineWidth',hw_pub.lineWidth)
hold on
% axis equal
plot(Launch_dep(Launch_date_idx), VGA_arr(VGA_date_idx), 'd',...
    'Color',color_order(4,:),'LineWidth',hw_pub.lineWidth)
xlim([Launch_dep(1) Launch_dep(end)])
ylim([VGA_arr(1) VGA_arr(end)])
set(gca,'YTick',[]);
set(gca,'XTick',[]);

figure
% VGA to EGA1
EGA1_window = JD_EGA1 + window;

params2 = params1;
params2.show_c3 = false;
params2.show_v_inf_dep = true;
params2.planet1 = Venus;
params2.planet2 = Earth;
params2.v_inf_dep_countours = [5 7 9 11 15 19 23];

[ fh , output_VGA_EGA1, legend_vec, legend_cells] = PorkchopPlot( VGA_arr, EGA1_window, ...
    params2);
figure(fh);
title('VGA to EGA1');
JD_true_EGA1 = juliandate(1990,12,8);
legend_vec = [legend_vec ...
    plot(JD_VGA, JD_EGA1, 'd',...
    'Color',color_order(2,:),'LineWidth',hw_pub.lineWidth) ...
    plot(JD_true_VGA, JD_true_EGA1, 'd',...
    'Color',color_order(4,:),'LineWidth',hw_pub.lineWidth) ];
legend_cells = {legend_cells{:} 'Baseline Trajectory' 'Designed Trajectory'};
legend(legend_vec, legend_cells, 'Location', 'NorthWest')
figure('Position',hw_pub.figPosn);
plot(JD_VGA, JD_EGA1,'d',...
    'Color',color_order(2,:),'LineWidth',hw_pub.lineWidth)
hold on
% axis equal
plot(VGA_arr(VGA_date_idx), EGA1_window(EGA1_date_idx), 'd',...
    'Color',color_order(4,:),'LineWidth',hw_pub.lineWidth)
xlim([VGA_arr(1) VGA_arr(end)])
ylim([EGA1_window(1) EGA1_window(end)])
set(gca,'YTick',[]);
set(gca,'XTick',[]);

% EGA2 
EGA2_window = JD_EGA2 + window;
window = -120:0.5:30;
JOI_window = JD_JOI + window;

params3 = params2;
params3.planet1 = Earth;
params3.planet2 = Jupiter;
params3.v_inf_arr_countours = 5:0.5:7.5;
params3.v_inf_dep_countours = [5 7 9 11 15 19 23];

[ fh , output_EGA2_JOI, legend_vec, legend_cells] = PorkchopPlot( EGA2_window, JOI_window, ...
    params3);
figure(fh);
title('EGA2 to JOI');
JD_true_EGA2 = juliandate(1992,12,8);
JD_true_JOI = juliandate(1995,12,8);
legend_vec = [legend_vec ...
    plot(JD_EGA2, JD_JOI, 'd',...
    'Color',color_order(2,:),'LineWidth',hw_pub.lineWidth) ...
    plot(JD_true_EGA2, JD_true_JOI, 'd',...
    'Color',color_order(4,:),'LineWidth',hw_pub.lineWidth) ];
legend_cells = {legend_cells{:} 'Baseline Trajectory' 'Designed Trajectory'};
legend(legend_vec, legend_cells, 'Location', 'NorthWest')
figure('Position',hw_pub.figPosn);
plot(JD_EGA2, JD_JOI,'d',...
    'Color',color_order(2,:),'LineWidth',hw_pub.lineWidth)
hold on
% axis equal
plot(EGA2_window(EGA2_date_idx), JOI_window(JOI_date_idx), 'd',...
    'Color',color_order(4,:),'LineWidth',hw_pub.lineWidth)
xlim([EGA2_window(1) EGA2_window(end)])
ylim([JOI_window(1) JOI_window(end)])
set(gca,'YTick',[]);
set(gca,'XTick',[]);

%% Patch together the trajectories using constraints
lambert_out = [output_Launch_VGA output_VGA_EGA1 output_EGA2_JOI];

% Initialize desired constraints
% can interp2 for more granularity
% These are only short-ways... since it's for a long interplanetary mission
C3_max = 180; %km^2/s^2
launch_date_min = Launch_dep(1);%juliandate('9-Jan-2006');
launch_date_max = Launch_dep(end);%juliandate('10-Jan-2006');
V_flyby_final_max = 10;
max_GA_diff = .4; %km/s

% Here we determine the constraints on the slice for the first segment
% Get the dates for valid C3
valid_c3_sw = (lambert_out(1).sw_c3_store < C3_max);
%apparently this is the element-wise logical AND 
valid_launch_sw = Launch_dep >= launch_date_min ...
    & Launch_dep < launch_date_max; 

total_launch_constraints = ...
    valid_c3_sw & repmat(valid_launch_sw,length(EGA1_window),1)';
launch_idx1 = find(sum(total_launch_constraints,2)>0, 1, 'first');
launch_idx2 = find(sum(total_launch_constraints,2)>0, 1, 'last');

% Y of this plot is X of the next.
GA_idx1 = find(sum(total_launch_constraints,1)>0, 1, 'first');
GA_idx2 = find(sum(total_launch_constraints,1)>0, 1, 'last');

% Next determine the constraints on the slice for the last segment
valid_final_pass = lambert_out(3).short_way_dv2_store < V_flyby_final_max;
valid_final_pass = lambert_out(2).long_way_dv2_store < V_flyby_final_max;
fb_idx1 = find(sum(valid_final_pass,1)>0, 1, 'first');
fb_idx2 = find(sum(valid_final_pass,1)>0, 1, 'last');

% Each segment forms a grid of information for each departure/arrival
% combination. For a gravity assist, this forms a 3D grid. However, the
% velocity difference must be small for pure-GA maneuvers. This section
% determines what the valid GAs are in this 3D grid. 
% for each launch date, see what has a valid GA
num_depart = length(Launch_dep);
num_VGA_window = length(VGA_arr);
num_arr = length(EGA1_window);
VGA_valid = zeros(num_depart, num_VGA_window, num_arr);
VGA_vel_err_3d = nan(num_depart, num_VGA_window, num_arr);

for ii = launch_idx1:launch_idx2
    % 
    for jj = fb_idx1:fb_idx2
        GA_vel_err = abs(lambert_out(2).long_way_dv1_store(:,jj) ...
            - lambert_out(1).short_way_dv2_store(ii,:)');
        valid_GA = ...
            GA_vel_err <= max_GA_diff;
        VGA_vel_err_3d(ii,:,jj) = GA_vel_err;
        VGA_valid(ii,:,jj) = valid_GA;
    end
end

% Choose a date set based on some criteria
% I'm going with minimal dV error during the GA
[d3, EGA1_date_idx] = min(VGA_vel_err_3d, [], 3);
[d2, VGA_date_idx] = min(d3, [], 2);
[~, Launch_date_idx] = min(d2, [], 1);
VGA_date_idx=VGA_date_idx(Launch_date_idx);
EGA1_date_idx=EGA1_date_idx(Launch_date_idx,VGA_date_idx);
fprintf('Launch: '); disp(getDate(Launch_dep(Launch_date_idx)))
fprintf('VGA: '); disp(getDate(VGA_arr(VGA_date_idx)))
fprintf('EGA1: '); disp(getDate(EGA1_window(EGA1_date_idx)))
fprintf('velocity error in VGA: '); 
disp(VGA_vel_err_3d(Launch_date_idx, VGA_date_idx, EGA1_date_idx))
fprintf('\b\b km/s\n\n');
VGA_valid(Launch_date_idx, VGA_date_idx, EGA1_date_idx);
EGA1_v_inf = lambert_out(2).long_way_dv2_store(VGA_date_idx, EGA1_date_idx);

% 3:2 resonant orbit
% Need to keep the EGA windows the same. This will align the indices for
% EGA1 and EGA2.
% EGA2
% for simplicity, I had the windows the same. going to keep the indices the
% same as well, could offset half a day though...
EGA2_date_idx = EGA1_date_idx;
num_joi = length(JOI_window);
ResoOrb_valid = [];%zeros(num_joi,1);
ResoOrb_vel_err = [];%nan(num_joi,1);

for ii = 1:length(EGA2_window)
    % 
    ResoOrb_vel_err = ...
        abs(lambert_out(2).long_way_dv2_store(VGA_date_idx,EGA1_date_idx) ...
        - lambert_out(3).long_way_dv1_store(EGA2_date_idx,:)');
    valid_RO = ...
        ResoOrb_vel_err <= max_GA_diff;
    ResoOrb_valid = valid_RO;
end

[~, JOI_date_idx] = min(ResoOrb_vel_err);

fprintf('EGA2: '); disp(getDate(EGA2_window(EGA2_date_idx)))
fprintf('JOI: '); disp(getDate(JOI_window(JOI_date_idx)))
fprintf('velocity error in resonant orbit: '); 
disp(ResoOrb_vel_err(JOI_date_idx)); fprintf('\b\b km/s\n\n')

% Ephemerides
[r_earth_launch, v_earth_launch] = ...
    MeeusEphemeris(Earth, Launch_dep(Launch_date_idx),Sun);
[r_venus_vga, v_venus_vga] = ...
    MeeusEphemeris(Venus, VGA_arr(VGA_date_idx),Sun);
[r_earth_ega1, v_earth_ega1] = ...
    MeeusEphemeris(Earth, EGA1_window(EGA1_date_idx),Sun);
[r_earth_ega2, v_earth_ega2] = ...
    MeeusEphemeris(Earth, EGA2_window(EGA2_date_idx),Sun);
[r_jupiter_JOI, v_jupiter_JOI] = ...
    MeeusEphemeris(Jupiter, JOI_window(JOI_date_idx),Sun);

% Launch to VGA
[Launch_v_helio_out, VGA_v_helio_in] = lambert( r_earth_launch, r_venus_vga, ...
    (VGA_arr(VGA_date_idx)-Launch_dep(Launch_date_idx))*day2sec, ...
    1, Sun);
Launch_v_inf_out = Launch_v_helio_out - v_earth_launch;
VGA_v_inf_in = VGA_v_helio_in - v_venus_vga;

% Incoming velocity on EGA1
[VGA_v_helio_out, EGA1_v_helio_in] = lambert( r_venus_vga, r_earth_ega1, ...
    (EGA1_window(EGA1_date_idx)-VGA_arr(VGA_date_idx))*day2sec, ...
    -1, Sun);
VGA_v_inf_out = VGA_v_helio_out - v_venus_vga;
EGA1_v_inf_in = EGA1_v_helio_in - v_earth_ega1;

% The outgoing velocity on EGA2.
[EGA2_v_helio_out, JOI_v_helio] = lambert( r_earth_ega2, r_jupiter_JOI, ...
    (JOI_window(JOI_date_idx)-EGA2_window(EGA2_date_idx))*day2sec, ...
    -1, Sun);
EGA2_v_inf_out = EGA2_v_helio_out - v_earth_ega2;
Jup_v_inf_in = JOI_v_helio - v_jupiter_JOI;

%% Resonant Orbit
% Constructing a 2:1 resonant orbit

% period is 2 years
P = 2*365.242189*day2sec;
a_reso = (P*P/4/pi/pi*Sun.mu)^(1/3); %sma

% The veolocity immediately after the first gravity assist
V_sc_sun = sqrt(Sun.mu*(2/norm(r_earth_ega1) - 1/a_reso));

theta = acos((-norm(V_sc_sun)^2 + norm(v_earth_ega1)^2 + EGA1_v_inf^2)...
    /(2*EGA1_v_inf*norm(v_earth_ega1)));

% The velocity is calculated in the Earth VNC frame. Calculate the
% transformation from VNC to ecliptic coords.
V_hat = v_earth_ega1/norm(v_earth_ega1);
N_hat = cross(r_earth_ega1, v_earth_ega1)...
    /norm(cross(r_earth_ega1, v_earth_ega1)); % angular momentum
C_hat = cross(V_hat, N_hat);
T_VNC2Ecl = [V_hat N_hat C_hat];

% Cycle through the locus of possible orbits
r_min = 7000; % Minimum radius of earth approach
cos_term = cos(pi-theta);
sin_term = sin(pi-theta);
acceptable_phi = [];
acceptable_radii = [];
acceptable_EGA1_out = [];
acceptable_EGA2_in = [];
for phi = 0:0.01:2*pi
    V_GA1_out = T_VNC2Ecl*EGA1_v_inf...
        *[cos_term; sin_term*cos(phi);-sin_term*sin(phi)];
    
    V_GA2_in = V_GA1_out + v_earth_ega1 - v_earth_ega2;
    
    % Determine if there is impact potential.
    % GA1:
    % Turning angle
    psi1 = acos(dot(EGA1_v_inf_in,V_GA1_out)...
        /norm(EGA1_v_inf_in)/norm(V_GA1_out));
    % Closes approach to planet
    rp1 = Earth.mu/(norm(V_GA1_out))^2*(1/cos((pi-psi1)/2)-1);
    % GA2:
    % Turning angle
    psi2 = acos(dot(V_GA2_in,EGA2_v_inf_out)...
        /norm(V_GA2_in)/norm(EGA2_v_inf_out));
    % Closes approach to planet
    rp2 = Earth.mu/(norm(EGA2_v_inf_out))^2*(1/cos((pi-psi2)/2)-1);
    
    if rp1 > r_min && rp2 > r_min
        acceptable_phi = [acceptable_phi phi]; %#ok<AGROW>
        acceptable_radii = [acceptable_radii [rp1;rp2]]; %#ok<AGROW>
        acceptable_EGA1_out = [acceptable_EGA1_out V_GA1_out]; %#ok<AGROW>
        acceptable_EGA2_in = [acceptable_EGA2_in V_GA2_in]; %#ok<AGROW>
    end
end

% I'm choosing the phi such that both passes are as far away as possible to
% minimize drag and other near-earth affects.
[~,xxx] = min(max(acceptable_radii,[],2));
[~,max_r_idx] = max(acceptable_radii(xxx,:));
fprintf('Earth Resonant Orbit:\n')
fprintf('phi = ');disp(acceptable_phi(max_r_idx)*180/pi);
fprintf('\b\b deg\n');
fprintf('EGA1 r_p = ');disp(acceptable_radii(1,max_r_idx));
fprintf('\b\b km\n');
fprintf('EGA2 r_p = ');disp(acceptable_radii(2,max_r_idx));
fprintf('\b\b km\n');
fprintf('EGA1 V_out = \n');disp(acceptable_EGA1_out(:,max_r_idx));
fprintf('\b\b km/s\n');
fprintf('EGA2 V_in = \n');disp(acceptable_EGA2_in(:,max_r_idx));
fprintf('\b\b km/s\n');
fprintf('\n');
EGA1_v_inf_out = acceptable_EGA1_out(:,max_r_idx);
EGA2_v_inf_in = acceptable_EGA2_in(:,max_r_idx);

%% B Plane for all gravity assists
fprintf('B-plane targeting:\n')
% VGA
[b_VGA, B_hat_VGA, B_plane_VGA, psi_VGA, rp_VGA] = ...
    BPlaneTarget(VGA_v_inf_in, VGA_v_inf_out, Venus.mu);
BT_VGA = dot(b_VGA*B_hat_VGA, B_plane_VGA(:,2));
BR_VGA = dot(b_VGA*B_hat_VGA, B_plane_VGA(:,3));
fprintf('VGA r_p = '); disp(rp_VGA);fprintf('\b\b km\n')
fprintf('VGA turning angle = '); disp(psi_VGA*180/pi);fprintf('\b\b deg\n')
fprintf('VGA BT = '); disp(BT_VGA);fprintf('\b\b km\n')
fprintf('VGA BR = '); disp(BR_VGA);fprintf('\b\b km\n\n')

% EGA1
[b_EGA1, B_hat_EGA1, B_plane_EGA1, psi_EGA1, rp_EGA1] = ...
    BPlaneTarget(EGA1_v_inf_in, EGA1_v_inf_out, Earth.mu);
BT_EGA1 = dot(b_EGA1*B_hat_EGA1, B_plane_EGA1(:,2));
BR_EGA1 = dot(b_EGA1*B_hat_EGA1, B_plane_EGA1(:,3));
fprintf('EGA1 r_p = '); disp(rp_EGA1);fprintf('\b\b km\n')
fprintf('EGA1 turning angle = '); disp(psi_EGA1*180/pi);fprintf('\b\b deg\n')
fprintf('EGA1 BT = '); disp(BT_EGA1);fprintf('\b\b km\n')
fprintf('EGA1 BR = '); disp(BR_EGA1);fprintf('\b\b km\n\n')

% EGA2
[b_EGA2, B_hat_EGA2, B_plane_EGA2, psi_EGA2, rp_EGA2] = ...
    BPlaneTarget(EGA2_v_inf_in, EGA2_v_inf_out, Earth.mu);
BT_EGA2 = dot(b_EGA2*B_hat_EGA2, B_plane_EGA2(:,2));
BR_EGA2 = dot(b_EGA2*B_hat_EGA2, B_plane_EGA2(:,3));
fprintf('EGA2 r_p = '); disp(rp_EGA2);fprintf('\b\b km\n')
fprintf('EGA2 turning angle = '); disp(psi_EGA2*180/pi);fprintf('\b\b deg\n')
fprintf('EGA2 BT = '); disp(BT_EGA2);fprintf('\b\b km\n')
fprintf('EGA2 BR = '); disp(BR_EGA2);fprintf('\b\b km\n\n')

%% The target launch parameters
launch_C3 = lambert_out(1).sw_c3_store(...
    (Launch_date_idx),(VGA_date_idx));
launch_DLA = asin(Launch_v_inf_out(1)/norm(Launch_v_inf_out));
launch_RLA = atan2(Launch_v_inf_out(2),Launch_v_inf_out(1));
fprintf('Launch Targets:\n')
fprintf('C3 = %.6f km^2/s^2\n',launch_C3);
fprintf('DLA = %.6f deg\n',launch_DLA*180/pi);
fprintf('RLA = %.6f deg\n',launch_RLA*180/pi);

%% JOI
% from http://www2.jpl.nasa.gov/files/misc/gllele2.txt
%  Semi-major Axis    9814688.8        km 
%  Eccentricity       .971233 
%  Inclination        5.300            degree

a_JOI = 9814688.8; %km
e_JOI = .971233;
i_joi = 5.3; %deg
r_p_JOI = a_JOI*(1-e_JOI);
P_JOI = 2*pi*sqrt(a_JOI^3/Jupiter.mu)

a_Jup_hyp = -Jupiter.mu/norm(Jup_v_inf_in)^2;
e_Jup_hyp = r_p_JOI/abs(a_Jup_hyp)+1;
b_Jup_hyp = -a_Jup_hyp*sqrt(e_Jup_hyp*e_Jup_hyp-1);
BT_jup = b_Jup_hyp*cosd(i_joi)
BR_jup = -b_Jup_hyp*sind(i_joi)

%%

% [EGA2_v_helio_out, JOI_v_helio] = lambert( r_earth_ega2, r_jupiter_JOI, ...
%     (JOI_window(JOI_date_idx)-EGA2_window(EGA2_date_idx))*day2sec, ...
%     -1, Sun);
r_TCM4 = [-1.1718287242230503e+006;1.4660929961577514e+008;
    -291804.3640374601800000];
TCM4_initial_v = [-39.0900653941649950;
    0.7125395475475220;
    -0.3339664598402935];
[TCM4_final_v, ~] = lambert( r_earth_ega2, r_jupiter_JOI, ...
    (JOI_window(JOI_date_idx)-EGA2_window(EGA2_date_idx)-10)*day2sec, ...
    -1, Sun);

4.04413

TCM1_dv = norm([0.01960719667492187;                                          
      -0.09119868787744483; 
       0.04409718855638307]);
      
TCM2_dv = norm([0.03086161951055671; 
      0.003346990697327708; 
     -0.009372025584854725]);
      
TCM3_dv = norm([0.004079990197027538; 
      -0.00210616092634577; 
        0.0168876956331692]);
      
TCM4_dv = norm([0.02723484822490837; 
        0.4243964358261687; 
       -0.3362196230896702]);
              
JOI_dv = norm([-0.7861251732912726; 
         0.877626473509227; 
      -0.00336061711326272]);   