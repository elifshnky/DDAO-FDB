%__________________________________________________________________     _%
%  Dynamic differential annealed optimization: 
%  New metaheuristic optimization algorithm for engineering applications
%  (DDAO) source codes version 1.0                                       %
%                                                                        %
%  Developed in MATLAB R2016b                                            %
%                                                                        %
%  Author and programmer: Hazim Nasir Ghafil                             %
%                                                                        %
%         e-Mail: hazimn.bedran@uokufa.edu.iq                            %
%                 hazimbedran@gmail.com                                  %
%                                                                        %
% Homepage: http://staff.uokufa.edu.iq/en/cv.php?hazimn.bedran           %                          
% Main paper:
% Hazim Nasir Ghafil, K?roly J?rmai                       
% Dynamic differential annealed optimization:New metaheuristic optimization 
% algorithm for engineering applications, Applied soft computing           
% in press,   doi: 10.1016/j.asoc.2020.106392                            %
%___________________________________________________________________     %
function d=DeJong(x)
    d=sum(x.^2);
end
