
classdef mas
%MAS -- Moist Air State
%MAS is based on ASHRAE F1 2009.
%Author: Dustin Moriarty
%Date: 02/19/2013
%
%MAS('t__t_w',t,t_w,p) creates a Moist Air State object given teh
%following arguments:
%   t       Temperature in deg C
%   t_w     Wet Bulb Temperature in deg C
%   p       pressure in Pa
%
%EXAMPLE 1
%
% patm = 101.1e3 %Pa
% 
% %Load State Data
% A = mas('t__t_w',21.9,8.9,patm); 
% B = mas('t__t_w',29.6,11.3,patm);
% C = mas('t__t_w',15.3,5.6,patm);
% D = mas('t__t_w',21.2,8.6,patm);
% 
% A.description = 'A';
% B.description = 'B';
% C.description = 'C';
% D.description = 'D';
% 
% %Make Plots Using Psychrometric Function
% f= psychrometric(patm*1e-3)
% plot(A,B,C,D)
% saveas(f,'out.tiff')
%  
% %Export Table 
%   %Requires latextable.m available at
%   %http://www.mathworks.com/matlabcentral/fileexchange/24387-latex-table-c
%   %reation
%
% latex('out.tex',A,B,C,D)
    
    
    properties
        T           %Dry Bulb Temperature (K)
        t           %Dry Bulb Temperature (deg C)
        T_w         %Wet Bulb Temperature (K)
        t_w         %Wet Bulb Temperature (deg C)
        p           %abosolute pressure
        p_da        %Vapor Pressure (Pa)
        p_ws        %wet bulb pressure at saturation
        W_ws        %Humidity Ratio at Saturation
        W           %Humidity Ratio
        p_w         %Partial Pressure of Water Vapor In Moist Air
        gamma       %Specific Humidity       
        phi         %Relative Humidity
        h           %Enthalpy
        description %description
        v           %Specific Volume m^3/kg
    end
    
    methods
        function obj = mas(Option,t,t_w,p)
            R = 8314.472; %J/mol/K
            if nargin == 4
                % If Arguements Are Present, Fill Properties
                if Option == 't__t_w'
                    % Fill Properties using Given Dry Bulb Temperature, T,
                    % in (K), wet Bulb Temperature, T_w, in (K), and
                    % pressure, (p)
                    T = t + 273.15;      %Dry Bulb Temperature (deg C)
                    T_w = t_w + 273.15;%Wet Bulb Temperature (deg C)
                    p_da = SaturationPressure(T);  %Partial Pressure Dry Air (Pa)
                    p_ws = SaturationPressure(T_w);   %wet bulb pressure at saturation
                    W_ws = 0.621945*p_ws/(p-p_ws);    %Humidity Ratio at Saturation
                    if t<0
                        W = ((2830 - 0.24*t_w)*W_ws -1.006*(t-t_w))/(2830 + 1.86*t-2.1*t_w); %Humidity Ratio
                    else
                        W = ((2501 -2.326*t_w)*W_ws - 1.006*(t-t_w))/(2501+1.86*t-4.186*t_w);
                    end
                    p_w = p*W/(0.621945 + W);   %Partial Pressure of Water Vapor In Moist Air
                    gamma = W/(1+W); %Specific Humidity       
                    phi = p_w/p_da;  %Relative Humidity
                    h = 1.006*t+W*(2501+1.86*t);
                    v = R*T*(1+1.607858*W)/28.966/p;
                end
                obj.T = T;
                obj.t = t;
                obj.T_w = T_w;
                obj.t_w = t_w;
                obj.p = p;
                obj.p_da = p_da;
                obj.p_ws = p_ws;
                obj.W_ws = W_ws;
                obj.W = W;
                obj.p_w = p_w;
                obj.gamma =  gamma;       
                obj.phi = phi;
                obj.h = h;
                obj.v = v;
            end
            
        end
        function plot(varargin)
            t = zeros(1,nargin);
            W = t;
            for i = 1:length(varargin)               
                t(i) = varargin{i}.t;
                W(i) = varargin{i}.W*1e3;
            end
            plot(t,W,'.--','MarkerSize',15,'color',[.5,.5,.5],'LineWidth',3)
            for i = 1:length(varargin)
                text(varargin{i}.t,varargin{i}.W*1e3,sprintf(['\\fontsize{16} ',varargin{i}.description]),'VerticalAlignment','top')
            end
        end
        function latex(varargin)
            % latex(outfile,mas1,mas2,mas3...)
                      
            % Slice and join data for table
            outfile = varargin{1};
            t = zeros(1,nargin-1);
            t_w = t;
            p = t;
            W = t;
            gamma = t;
            phi = t;
            h = t;
            v = t;
            description = cell(1,nargin-1);
            for i = 1:(length(varargin)-1)
                t(i) = varargin{i+1}.t;
                t_w(i) = varargin{i+1}.t_w;
                p(i) = varargin{i+1}.p*1e-3;
                W(i) = varargin{i+1}.W;
                gamma(i) = varargin{i+1}.gamma;
                phi(i) = varargin{i+1}.phi;
                h(i) = varargin{i+1}.h;
                v(i) = varargin{i+1}.v;
                description{i} = varargin{i+1}.description;
            end
            
            try
                latextable([t',t_w',p',W'*1e3,gamma'*1e3,phi',h',v'],...
                'Vert',description,'name',outfile,...
                'horiz',{'$t\,\left(^{\circ} C\right)$',...
                '$t^*\,\left(^{\circ} C\right)$',...
                '$p \,\left(kPa\right)$','$W\,\left(g_{w}/kg_{da}\right)$',...
                '$\gamma$','$\phi$',...
                '$h\,\left(kJ/kg_{da}\right)$','$v\,\left(m^3/kg\right)$'},...
                'format','%5.3g')
            catch MS1
                fprintf('ERROR: Requires latextable abailable at www.mathworks.com/matlabcentral/fileexchange/24387-latex-table-creation')
                rethrow(MS1)
            end
        end
    end
end

