function p = SaturationPressure(T)
    %% Saturation Pressure of Water Per ASHRAE 2009 F1.2
    % Author: Dustin Moriary
    %
    % Arguments
    % T     Temperature (K)

    if T>=173.15 && T < 273.15
        C1 = -5.6745359e3;
        C2 = 6.3925247;
        C3 = -9.6778430e-3;
        C4 = 6.2215701e-7;
        C5 = 2.0747825e-9;
        C6 = -9.484024e-13;
        C7 = 4.1635019;
        p = exp(C1/T + C2 + C3*T + C4*T^2 + C5*T^3 + C6*T^4 + C7 * log(T));

    elseif T>= 273.15 && T< 473.15
        C8 = -5.8002206e3;
        C9 = 1.3914993;
        C10 = -4.8640239e-2;
        C11 = 4.1764768e-5;
        C12 = -1.4452093e-8;
        C13 = 6.5459673;
        p = exp(C8/T+C9+C10*T+C11*T^2+C12*T^3+C13*log(T));
    else
        p = NaN;
        fprintf('Temperature out of Range')
    end

end

