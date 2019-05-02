%% Plot edge with or without arrow
%
% Jesús Pérez-Ortega - june 2018
% Modified nov 2018

function [x,y] = Plot_Edge(XY_initial,XY_final,radius,length_arrow,line_width,color)

    if(nargin==5)
        color=[0 0 0];
    elseif(nargin==4)
        color=[0 0 0];
        line_width=2;
    elseif(nargin==3)
        color=[0 0 0];
        line_width=2;
        length_arrow=3.5;
    elseif(nargin==2)
        color=[0 0 0];
        line_width=2;
        length_arrow=3.5;
        radius=0.15;
    end
    
    if(XY_initial(1)>0 && XY_final(1)>0 && XY_initial(2)>0 && XY_final(2)<0)
        XY_temporal=XY_initial;
        XY_initial=XY_final;
        XY_final=XY_temporal;
    end

    % If loop
    if (XY_initial==XY_final)
        r=0.2;
        [theta,rho] = cart2pol(XY_initial(1),XY_initial(2));
        rho=rho+r;
        [x_center,y_center] = pol2cart(theta,rho);
        
        % Circle
        ang=0:0.01:2*pi;
        x=r*cos(ang)+x_center;
        y=r*sin(ang)+y_center;
    else
        if(radius)
            % Curve
            l=norm(XY_initial-XY_final); % length of line
            dx=XY_final(1)-XY_initial(1);
            dy=XY_final(2)-XY_initial(2);

            alpha=atan2(dy,dx); % angle of rotation
            cosa=cos(alpha);
            sina=sin(alpha);

            points=linspace(pi/4,3*pi/4);
            a=(0.5-cos(points)/2^0.5)*l;
            b=((sin(points)-2^0.5/2)/(1-2^0.5/2))*radius;

            x=a*cosa-b*sina+XY_initial(1);
            y=a*sina+b*cosa+XY_initial(2);
        else
            x=[XY_initial(1) XY_final(1)];
            y=[XY_initial(2) XY_final(2)];
        end
    end
    plot(x,y,'-','color',color,'linewidth',line_width); hold on
    
    if(length_arrow)
        % Arrow end
        xai=x([end end-20]);
        yai=y([end end-20]);
        xa1=length_arrow*[0 0.1 0.08 0.1 0]';
        ya1=length_arrow*[0 0.03 0 -0.03 0]';
        dx=diff(xai);
        dy=diff(yai);
        alpha=atan2(dy,dx); % angle of rotation
        cosa=cos(alpha);
        sina=sin(alpha);
        xa=xa1*cosa-ya1*sina+xai(1);
        ya=xa1*sina+ya1*cosa+yai(1);

        if (XY_initial~=XY_final)
            fill(xa,ya,color)
            plot(xa,ya,'-','color',color)
        end
    end
end
