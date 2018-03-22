function parsave(filename,vars)

% numvars = length(vars);

% mf = matfile(filename, 'Writable', true);

ii = vars(1);
jj = vars(2);
kk = vars(3);
mm = vars(4);
Fk = vars(5);
kb = vars(6);
alpha = vars(7);
rho0 = vars(8);
err_dist = vars(9);
err_densratios = vars(10);
centerdensincrease = vars(11);

% save(filename, 'i')
% save(filename, 'j', '-append')
% save(filename, 'k', '-append')
% save(filename, 'm', '-append')
% save(filename, 'Fk', '-append')
% save(filename, 'kb', '-append')
% save(filename, 'alpha', '-append')
% save(filename, 'rho0', '-append')
% save(filename, 'err_total', '-append')
% save(filename, 'err_dist', '-append')
% save(filename, 'err_densratios', '-append')
% save(filename, 'centerdensincrease', '-append')

save(filename,'ii','jj','kk','mm','Fk','kb','alpha','rho0',...
    'err_dist','err_densratios','centerdensincrease')