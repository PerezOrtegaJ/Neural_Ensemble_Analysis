function validated = Validate_Name(name)
% Validate string to write a variable name in worskpace
%
%       validated = Validate_Name(name)
%
% Jesus Perez-Ortega May-19

no_alphanum = ~isstrprop(name,'alphanum');

ini = find(no_alphanum==0,1,'first');
fin = find(no_alphanum==0,1,'last');

validated = name(ini:fin);
no_alphanum = no_alphanum(ini:fin);

validated(no_alphanum) = '_';
n = sum(no_alphanum);

for i = 1:n
    validated = strrep(validated,'__','_');
end