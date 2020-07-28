function [raster,fractionRemoved] = Remove_Noisy_Spikes(raster,network)
% Reduce the noisy spikes from a given raster base on the connectivity
% between neurons
%
%       [raster,fractionRemoved] = Remove_Noisy_Spikes(raster,network)
%
% By Jesus Perez-Ortega, Dec 2019

spikesIni = sum(raster(:));
nFrames = size(raster,2);
for frame = 1:nFrames
    % Find active neurons on single frame
    active = find(raster(:,frame));

    if ~isempty(active)
        % Identify active neurons without no significant coactivation
        noSig = find(sum(network(active,active))==0);

        if ~isempty(noSig)
            % Delete no significant neuronal coactivity from frame
            raster(active(noSig),frame) = 0;
        end
    end
end
removed = spikesIni-sum(raster(:));
fractionRemoved = removed/spikesIni;
disp(['   ' num2str(removed) '(' num2str(fractionRemoved*100,'%.1f') '%) spikes removed!'])