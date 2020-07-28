function Plot_Raster_And_Similarity(raster,similarity,name,sim_method,states)
% Plot Similarity and raster toghether
%
%       Plot_Raster_And_Similarity(raster,similarity,name,sim_method,states)
%
% Pérez-Ortega Jesús - Dec 2019
% modified Mar 2020

switch nargin
    case 4
        states = [];
    case 3
        sim_method = '';
        states = [];
    case 2
        sim_method = '';
        name = '';
        states = [];
end

frames = size(raster,2);

if frames == size(similarity,1)

    Set_Figure(['Raster and similarity (' name ')'],[0 0 1220 900]);

    % Plot similarity in time function
    Set_Axes(['SimAxes' name],[0 0 1 0.65]);
    imagesc(similarity)
    set(gca,'YDir','normal','xtick',[],'ytick',[])
    title([sim_method ' similarity'])
    xlabel('neural vectors')

    % Plot raster
    ax = Set_Axes(['RasterAxes' name],[0 0.65 1 0.35]);
    
    if ~isempty(states)
        rasterColor = double(raster);
        rasterColor(rasterColor>0) = -1;
    
        ensembles(1,:) = unique(states);
        for i = ensembles
            % Get the raster form ensemble i
            rasterSingle = rasterColor(:,states==i);
            rasterSingle(rasterSingle==0) = i;
            rasterColor(:,states==i) = rasterSingle;
        end
        
        colors = Read_Colors(length(ensembles));
        colors = (colors+ones(size(colors)))/2;

        imagesc(rasterColor,[-1 length(ensembles)]);
        set(gca,'ydir','normal')
        colormap(ax,[0 0 0;1 1 1;colors])
        ylabel('neurons')
        title(strrep(name,'_','-'))
    else
        Plot_Raster(raster,name,true,false,false);
    end
else
    error('   Size of the neural vectors in the raster should be the same in the similarity matrix!')
end