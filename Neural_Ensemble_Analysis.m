function varargout = Neural_Ensemble_Analysis(varargin)
% NEURAL_ENSEMBLE_ANALYSIS MATLAB code for Neural_Ensemble_Analysis.fig
%      NEURAL_ENSEMBLE_ANALYSIS, by itself, creates a new NEURAL_ENSEMBLE_ANALYSIS
%      or raises the existing singleton*.
%
%      H = NEURAL_ENSEMBLE_ANALYSIS returns the handle to a new NEURAL_ENSEMBLE_ANALYSIS
%      or the handle to the existing singleton*.
%
%      NEURAL_ENSEMBLE_ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEURAL_ENSEMBLE_ANALYSIS.M with the given input arguments.
%
%      NEURAL_ENSEMBLE_ANALYSIS('Property','Value',...) creates a new NEURAL_ENSEMBLE_ANALYSIS
%      or raises the existing singleton*.
%      Starting from the left, property value pairs are
%      applied to the GUI before Neural_Ensemble_Analysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Neural_Ensemble_Analysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Neural_Ensemble_Analysis

% Last Modified by GUIDE v2.5 26-Apr-2019 13:04:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Neural_Ensemble_Analysis_OpeningFcn, ...
                   'gui_OutputFcn',  @Neural_Ensemble_Analysis_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end

function Neural_Ensemble_Analysis_OpeningFcn(hObject, eventdata, handles, varargin)
    handles.output = hObject;
    guidata(hObject, handles);
    btnRefreshWorkspace_Callback(hObject, eventdata, handles);
end

function varargout = Neural_Ensemble_Analysis_OutputFcn(~, ~, handles)
    varargout{1} = handles.output;
end

%% --- Functions ---

%% Read analysis variable
function Read_Analysis(handles,experiment)
    % Raster
    % samples per second
    samples_per_second=experiment.Raster.SamplesPerSecond;
    set(handles.txtSamplesPerSecond,'string',num2str(samples_per_second));
    
    % Coactivity
    % Smooth filter
    set(handles.txtSmoothFilter,'string',num2str(experiment.Coactivity.SmoothFilter));
    % Coactivity Threshold
    set(handles.txtCoactivityThreshold,'string',num2str(...
        experiment.Coactivity.CoactivityThreshold));
    % Z-score
    set(handles.chkZscore,'value',experiment.Coactivity.ZScore);
    % Remove oscillations
    set(handles.chkRemoveOscillations,'value',experiment.Coactivity.RemoveOscillations);
    
    % Peaks
    set(handles.chkJoin,'value',experiment.Peaks.Join);
    set(handles.chkFixedWidth,'value',experiment.Peaks.FixedWidth);
    set(handles.rdbSpikes,'value',experiment.Peaks.UseSpikes);
    set(handles.rdbFrequencies,'value',~experiment.Peaks.UseSpikes);
    set(handles.chkDividePeaks,'value',experiment.Peaks.DividePeaks);
    set(handles.txtFixedWidth,'string',num2str(...
        experiment.Peaks.FixedWidthWindow*1000/samples_per_second));
    set(handles.txtDividePeaks,'string',num2str(...
        experiment.Peaks.DivisionWindow*1000/samples_per_second));
    set(handles.chkDetectPeaksOrValleys,'value',experiment.Peaks.DetectPeaksOrValleys)
    if(experiment.Peaks.DetectPeaks)
        set(handles.popPeaksValleys,'value',1);
    elseif(experiment.Peaks.DetectValleys)
        set(handles.popPeaksValleys,'value',2);
    else
        set(handles.popPeaksValleys,'value',3);
        set(handles.popStimuli,'enable','on');
    end
    
    % Evaluate analysis computed to enable buttons
    if(experiment.Peaks.DividePeaks)
        set(handles.txtDividePeaks,'enable','on')
        set(handles.btnPlotSequenceByPeak,'enable','on')
    end
    
    % Method for create vectors
    set(handles.popNetworkMethod,'enable','off');
    switch(experiment.Peaks.VectorMethod)
        case 'sum'
            num=1;
        case 'binary'
            num=2;
        case 'average'
            num=3;
        case 'network'
            num=4;
            set(handles.popNetworkMethod,'enable','on');
        otherwise
            num=1;
    end        
    set(handles.popVectorMethod,'Value',num);
    
    % Method for create networks
    switch(experiment.Peaks.NetworkMethod)
        case 'coactivity'
            num=1;
        case 'jaccard'
            num=2;
        case 'pearson'
            num=3;
        otherwise
            num=1;
    end        
    set(handles.popNetworkMethod,'Value',num);
    
    % Similarity method
    switch(experiment.Clustering.SimilarityMethod)
        case 'euclidean'
            num=1;
        case 'jaccard'
            num=2;
        case 'cosine'
            num=3;
        case 'correlation'
            num=4;
        case 'hamming'
            num=5;
        case 'seuclidean'
            num=6;
        case 'cityblock'
            num=7;
        case 'minkowski'
            num=8;
        case 'chebychev'
            num=9;
        case 'mahalanobis'
            num=10;
        case 'spearman'
            num=11;
        otherwise
            num=1;
    end        
    set(handles.popSimilarityMethod,'Value',num);
    
    % Linkage method
    switch(experiment.Clustering.LinkageMethod)
        case 'ward'
            num=1;
        case 'centroid'
            num=2;
        case 'median'
            num=3;
        case 'single'
            num=4;
        case 'complete'
            num=5;
        case 'average'
            num=6;
        case 'weighted'
            num=7;
        otherwise
            num=1;
    end        
    set(handles.popLinkageMethod,'Value',num);
    
    % Clustering
    groups=experiment.Clustering.Groups;
    set(handles.txtGroups,'string',num2str(groups));
    if(isfield(experiment.Clustering,'GroupsToPlot'))
        groups_to_plot_double = experiment.Clustering.GroupsToPlot;
        groups_to_plot=[];
        for i=1:length(groups_to_plot_double)
            groups_to_plot=[groups_to_plot num2str(groups_to_plot_double(i)) ','];
        end
    else
        groups_to_plot=[];
        for i=1:(groups-1)
            groups_to_plot=[groups_to_plot num2str(i) ','];
        end
        groups_to_plot=[groups_to_plot num2str(groups)];
    end
    set(handles.txtGroupsToPlot,'string',groups_to_plot);
    
    % Plots
    % Similarity method
    try
        switch(experiment.Plot.CurrentSorting)
            case 'no sorting'
                num=1;
            case 'activity'
                num=2;
            case 'activation'
                num=3;
            case 'jaccard correlation'
                num=4;
            case 'linear correlation'
                num=5;
            otherwise
                by_group = strsplit(experiment.Plot.CurrentSorting,' ');
                group = str2num(by_group{2});
                num = 5 + group;
        end
    catch
        num = 1;
    end
    set(handles.popSortingNeurons,'Value',num);
    
    % Evaluate analysis computed to enable buttons
    set(handles.btnDunnTest,'enable','on')
    set(handles.btnSaveBySeconds,'enable','on')
    
    % Vectors
    % Normalized Instant Frequencies
    if(isfield(experiment.Raster,'Frequencies'))
        set(handles.btnGetFrequencies,'ForeGroundColor',[0 0.5 0])
        set(handles.btnPlotFrequencies,'enable','on')
        set(handles.rdbFrequencies,'enable','on')
    end
    if(experiment.Peaks.DetectPeaksOrValleys)
        % Enable
        set(handles.popPeaksValleys,'enable','on')
        set(handles.txtCoactivityThreshold,'enable','on')
        set(handles.btnShuffleTest,'enable','on')
        set(handles.chkFixedWidth,'enable','on')
        if(get(handles.chkFixedWidth,'value'))
            set(handles.txtFixedWidth,'enable','on')
        end
    else
        % Disable
        set(handles.popPeaksValleys,'enable','off')
        set(handles.txtCoactivityThreshold,'enable','off')
        set(handles.btnShuffleTest,'enable','off')
        set(handles.chkFixedWidth,'enable','off')
        % Set values
        set(handles.chkFixedWidth,'value',true)
    end
    
    % Coactivity
    if(isfield(experiment.Coactivity,'Coactivity'))
        set(handles.btnGetCoactivity,'ForeGroundColor',[0 0.5 0])
        set(handles.btnPlotCoactivity,'enable','on')
        set(handles.btnGetVectors,'enable','on')
        set(handles.popSortingNeurons,'string',{'no sorting','activity','activation',...
            'jaccard correlation','linear correlation'})
    end
    
    % Peaks
    if(isfield(experiment.Peaks,'Vectors'))
        set(handles.btnGetVectors,'ForeGroundColor',[0 0.5 0])
        set(handles.btnGetSimilarity,'enable','on')
        if(experiment.Peaks.DetectStimuli)
            set(handles.btnGetNetworksByStimuli,'enable','on')
        end
    end
    
    % Similarity
    if(isfield(experiment.Clustering,'Similarity'))    
        set(handles.btnGetSimilarity,'ForeGroundColor',[0 0.5 0])
        set(handles.btnPlotSimilarity,'enable','on')
        set(handles.btnGetClusters,'enable','on')
        set(handles.btnDunnTest,'enable','on')
    end
    
    % Clustering
    if(isfield(experiment.Clustering,'GroupIndices'))
        set(handles.btnGetClusters,'ForeGroundColor',[0 0.5 0])
        set(handles.btnPlotPeaks,'enable','on')
        set(handles.btnPlotSequence,'enable','on')
        set(handles.btnGetNetworks,'enable','on')
        % Enable options on sorting raster/frequencies
        labels={'no sorting','activity','activation','jaccard correlation',...
            'linear correlation'};
        for i=1:groups
            labels{end+1}=['group ' num2str(i)];
        end
        set(handles.popSortingNeurons,'string',labels);
        
        if(get(handles.popNetworkMethod,'value'))
            set(handles.btnGetNetworks,'enable','on')
        end
    end

    % Network
    if(isfield(experiment,'Network'))
        if(isfield(experiment.Network,'Network'))
            set(handles.btnGetNetworks,'ForeGroundColor',[0 0.5 0])
            set(handles.btnPlotNetworks,'enable','on')
        end
        if(isfield(experiment.Network,'Stimulus'))
            set(handles.btnGetNetworksByStimuli,'ForeGroundColor',[0 0.5 0])
            set(handles.btnPlotStimulusNetworks,'enable','on')
        end
        if(isfield(experiment.Network,'WholeNetwork'))
            set(handles.btnGetNetworkRaster,'ForeGroundColor',[0 0.5 0])
            set(handles.btnPlotWholeNetwork,'enable','on')
        end
        
    end
    
end

%% Read experiment
function experiment=Read_Experiment(handles)
    data_num=get(handles.popWorkspace,'Value');
    data_strings=get(handles.popWorkspace,'String');
    name=data_strings{data_num};
    if evalin('base',['exist(''' name '_analysis'')'])
        experiment=evalin('base',[name '_analysis']);
    else
        experiment=[];
    end
end

%% Write experiment data
function Write_Experiment(handles,experiment)
    data_num=get(handles.popWorkspace,'Value');
    data_strings=get(handles.popWorkspace,'String');
    name=data_strings{data_num};
    assignin('base',[name '_analysis'],experiment);
end

%% Refresh workspace data
function btnRefreshWorkspace_Callback(~, ~, handles)
    data_strings = evalin('base','who');
    set(handles.popWorkspace,'String',[{'Select raster'};data_strings])
    set(handles.popWorkspace,'Value',1)
    set(handles.popStimuli,'String',[{'select stimuli'};data_strings])
    set(handles.popStimuli,'Value',1)
    set(handles.lblRaster,'String','...')
    set(handles.lblRaster,'ForegroundColor','black')
    Disable_Buttons(handles,'Raster')
end

%% User number entry control
function user_entry = User_Number_Entry(hObject,default,minimum,maximum,multiple,negative)
    if(nargin==4)
        multiple=false;
        negative=false;
    elseif(nargin==5)
        negative=false;    
    end
    
    user_entry = str2double(get(hObject,'string'));
    neg=false;
    % verify if the data is a number m?ltiplo
    if ~isnan(user_entry)
        user_entry=floor(user_entry);
        if(user_entry<0)
            neg=true;
            user_entry=-user_entry;
        end
        % verify if the data is between the limits
        if(user_entry>maximum)
            user_entry=maximum;
        elseif(user_entry<minimum)
            user_entry=minimum;
        end
    else
        user_entry=default;
    end
    
    if(multiple)
        times=round(user_entry/minimum);
        user_entry=minimum*times;
    end
    
    if(negative && neg)
        user_entry=-user_entry;
    end
    
    set(hObject,'string',num2str(user_entry));
end

%% User number double entry control (one decimal point)
function user_entry = User_Double_Entry(hObject,default,minimum,maximum)
    user_entry = str2double(get(hObject,'string'));
    if ~isnan(user_entry)
        user_entry=floor(user_entry*10)/10;
        if(user_entry>maximum)
            user_entry=maximum;
        elseif(user_entry<minimum)
            user_entry=minimum;
        end
    else
        user_entry=default;
    end
    set(hObject,'string',num2str(user_entry));
end

%% User number double entry control (one decimal point)
function user_entry = User_Double_Entry_2(hObject,default,minimum,maximum)
    user_entry = str2double(get(hObject,'string'));
    if ~isnan(user_entry)
        user_entry=floor(user_entry*100)/100;
        if(user_entry>maximum)
            user_entry=maximum;
        elseif(user_entry<minimum)
            user_entry=minimum;
        end
    else
        user_entry=default;
    end
    set(hObject,'string',num2str(user_entry));
end

%% Set current GUI parameters
function experiment = Set_Current_Parameters(handles, experiment)
    
    % Samples per second
    samples_per_second = str2double(get(handles.txtSamplesPerSecond,'string'));
    samples_per_minute = 60*samples_per_second;
    
    % Coactivity
    % Smooth filter
    smooth_filter = str2double(get(handles.txtSmoothFilter,'string'));
    smooth_window=smooth_filter*samples_per_second/1000;
    % Z-score
    z_score= get(handles.chkZscore,'value');
    zscore_window=0;
    only_mean=false;
    
    % Remove oscillations
    remove_oscillations= get(handles.chkRemoveOscillations,'value');
    
    % Peaks
    detect_peaks_or_valleys=get(handles.chkDetectPeaksOrValleys,'value');
    detect_peaks=get(handles.popPeaksValleys,'value')==1;
    if(detect_peaks_or_valleys)
        coactivity_threshold = str2double(get(handles.txtCoactivityThreshold,'string'));
    else
        coactivity_threshold = [];
    end
    join=get(handles.chkJoin,'value');
    fixed_width=get(handles.chkFixedWidth,'value');
    use_spikes=get(handles.rdbSpikes,'value');
    divide_peaks=get(handles.chkDividePeaks,'value');
    fixed_width_window=str2num(get(handles.txtFixedWidth,'string'))...
        *samples_per_second/1000;
    division_window=str2num(get(handles.txtDividePeaks,'string'))...
        *samples_per_second/1000;
    % Method for create vectors
    data_num=get(handles.popVectorMethod,'Value');
    data_strings=get(handles.popVectorMethod,'String');
    vector_method=data_strings{data_num};
    % Method for create networks
    data_num=get(handles.popNetworkMethod,'Value');
    data_strings=get(handles.popNetworkMethod,'String');
    network_method=data_strings{data_num};
    % Similarity method
    data_num=get(handles.popSimilarityMethod,'Value');
    data_strings=get(handles.popSimilarityMethod,'String');
    similarity_method=data_strings{data_num};
    % Linkage method
    data_num=get(handles.popLinkageMethod,'Value');
    data_strings=get(handles.popLinkageMethod,'String');
    linkage_method=data_strings{data_num};
    % Clustering
    groups=str2double(get(handles.txtGroups,'string'));
    groups_to_plot=1:groups;
    
    % Write experiment
    experiment.Raster.SamplesPerSecond=samples_per_second;
    experiment.Raster.SamplesPerMinute=samples_per_minute;
    experiment.Coactivity.SmoothFilter=smooth_filter;
    experiment.Coactivity.SmoothWindow=smooth_window;
    experiment.Coactivity.CoactivityThreshold=coactivity_threshold;
    experiment.Coactivity.ZScore=z_score;
    experiment.Coactivity.RemoveOscillations=remove_oscillations;
    experiment.Coactivity.ZScoreWindow=zscore_window;
    experiment.Coactivity.ZScoreOnlyMean=only_mean;
    experiment.Peaks.DetectPeaksOrValleys=detect_peaks_or_valleys;
    experiment.Peaks.DetectPeaks=detect_peaks;
    experiment.Peaks.DetectValleys=~detect_peaks;
    experiment.Peaks.FixedWidth=fixed_width;
    experiment.Peaks.FixedWidthWindow=fixed_width_window;
    experiment.Peaks.DivisionWindow=division_window;
    experiment.Peaks.Join=join;
    experiment.Peaks.UseSpikes=use_spikes;
    experiment.Peaks.DividePeaks=divide_peaks;
    experiment.Peaks.VectorMethod=vector_method;
    experiment.Peaks.NetworkMethod=network_method;
    experiment.Clustering.SimilarityMethod=similarity_method;
    experiment.Clustering.LinkageMethod=linkage_method;
    experiment.Clustering.Groups=groups;
    experiment.Clustering.GroupsToPlot=groups_to_plot;
end

%% Disable buttons
function Disable_Buttons(handles,from)
    switch(from)
        case 'Raster'
            % Raster
            set(handles.btnGetFrequencies,'enable','off')
            set(handles.btnGetFrequencies,'ForeGroundColor','black')
            set(handles.btnPlotRaster,'enable','off')
            set(handles.btnPlotFrequencies,'enable','off')
            set(handles.btnPlotFrequencies,'ForeGroundColor','black')
            set(handles.txtSamplesPerSecond,'enable','off')
            set(handles.btnSaveBySeconds,'enable','off')
            % Coactivity
            set(handles.btnGetCoactivity,'enable','off')
            set(handles.btnGetCoactivity,'ForeGroundColor','black')
            set(handles.btnPlotCoactivity,'enable','off')
            set(handles.txtSmoothFilter,'enable','off')
            set(handles.chkZscore,'enable','off')
            set(handles.chkRemoveOscillations,'enable','off')
            set(handles.popSortingNeurons,'value',1)
            set(handles.popSortingNeurons,'string',{'no sorting','activity','activation'})
            % Peaks
            set(handles.chkDetectPeaksOrValleys,'enable','off')
            set(handles.popPeaksValleys,'enable','off')
            set(handles.popStimuli,'enable','off')
            set(handles.txtCoactivityThreshold,'enable','off')
            set(handles.btnShuffleTest,'enable','off')
            set(handles.btnShuffleTest,'ForeGroundColor','black')
            set(handles.rdbSpikes,'enable','off')
            set(handles.rdbFrequencies,'enable','off')
            set(handles.rdbSpikes,'value',true)
            set(handles.rdbFrequencies,'value',false)
            set(handles.chkFixedWidth,'enable','off')
            set(handles.txtFixedWidth,'enable','off')
            set(handles.chkJoin,'enable','off')
            set(handles.chkDividePeaks,'enable','off')
            set(handles.txtDividePeaks,'enable','off')
            set(handles.popVectorMethod,'enable','off')
            set(handles.popNetworkMethod,'enable','off')
            set(handles.btnGetVectors,'enable','off')
            set(handles.btnGetVectors,'ForeGroundColor','black')
            % Similarity
            set(handles.btnGetSimilarity,'enable','off')
            set(handles.btnGetSimilarity,'ForeGroundColor','black')
            set(handles.btnPlotSimilarity,'enable','off')
            set(handles.popSimilarityMethod,'enable','off')
            set(handles.popLinkageMethod,'enable','off')
            % Clustering
            set(handles.btnGetClusters,'enable','off')
            set(handles.btnGetClusters,'ForeGroundColor','black')
            set(handles.txtGroups,'enable','off')
            set(handles.txtGroupsToPlot,'enable','off')
            set(handles.btnPlotPeaks,'enable','off')
            set(handles.btnPlotSequence,'enable','off')
            set(handles.btnPlotSequenceByPeak,'enable','off')
            % Network
            set(handles.btnGetNetworkRaster,'enable','off')
            set(handles.btnPlotWholeNetwork,'enable','off')
            set(handles.btnGetNetworks,'enable','off')
            set(handles.btnGetNetworksByStimuli,'enable','off')
            set(handles.btnGetNetworks,'ForeGroundColor','black')
            set(handles.btnPlotNetworks,'enable','off')
            set(handles.btnPlotStimulusNetworks,'enable','off')

        case 'Peaks'
            % Peaks
            set(handles.btnGetVectors,'enable','off')
            set(handles.btnGetVectors,'ForeGroundColor','black')
            % Similarity
            set(handles.btnGetSimilarity,'enable','off')
            set(handles.btnGetSimilarity,'ForeGroundColor','black')
            set(handles.btnPlotSimilarity,'enable','off')
            % Clustering
            set(handles.btnGetClusters,'enable','off')
            set(handles.btnGetClusters,'ForeGroundColor','black')
            set(handles.btnPlotPeaks,'enable','off')
            set(handles.btnPlotSequence,'enable','off')
            set(handles.btnGetNetworks,'enable','off')
            % Network
            set(handles.btnGetNetworks,'enable','off')
            set(handles.btnGetNetworks,'ForeGroundColor','black')
            set(handles.btnGetNetworksByStimuli,'enable','off')
            set(handles.btnGetNetworksByStimuli,'ForeGroundColor','black')
            set(handles.btnPlotNetworks,'enable','off')
            set(handles.btnPlotStimulusNetworks,'enable','off')
        case 'Similarity'
            % Similarity
            set(handles.btnGetSimilarity,'enable','off')
            set(handles.btnGetSimilarity,'ForeGroundColor','black')
            set(handles.btnPlotSimilarity,'enable','off')
            % Clustering
            set(handles.btnGetClusters,'enable','off')
            set(handles.btnGetClusters,'ForeGroundColor','black')
            set(handles.btnPlotPeaks,'enable','off')
            set(handles.btnPlotSequence,'enable','off')
            set(handles.btnGetNetworks,'enable','off')
            % Network
            set(handles.btnGetNetworks,'enable','off')
            set(handles.btnGetNetworks,'ForeGroundColor','black')
            set(handles.btnGetNetworksByStimuli,'enable','off')
            set(handles.btnGetNetworksByStimuli,'ForeGroundColor','black')
            set(handles.btnPlotNetworks,'enable','off')
            set(handles.btnPlotStimulusNetworks,'enable','off')
        case 'Clustering'
            % Clustering
            set(handles.btnGetClusters,'enable','off')
            set(handles.btnGetClusters,'ForeGroundColor','black')
            set(handles.btnPlotPeaks,'enable','off')
            set(handles.btnPlotSequence,'enable','off')
            set(handles.btnGetNetworks,'enable','off')
            % Network
            set(handles.btnGetNetworks,'enable','off')
            set(handles.btnGetNetworks,'ForeGroundColor','black')
            set(handles.btnPlotNetworks,'enable','off')
            set(handles.btnPlotStimulusNetworks,'enable','off')
        case 'Network'
            % Network
            set(handles.btnGetNetworks,'enable','off')
            set(handles.btnGetNetworks,'ForeGroundColor','black')
            set(handles.btnPlotNetworks,'enable','off')
            set(handles.btnPlotStimulusNetworks,'enable','off')
    end
end

%% Enable buttons
function Enable_Buttons(handles,next)
    switch(next)
        case 'Raster'
            % Raster
            set(handles.btnGetFrequencies,'enable','on')
            set(handles.btnGetFrequencies,'ForeGroundColor','black')
            set(handles.btnPlotRaster,'enable','on')
            set(handles.btnPlotRaster,'ForeGroundColor','black')
            set(handles.txtSamplesPerSecond,'enable','on')
            set(handles.popSortingNeurons,'enable','on')
            % Coactivity
            set(handles.btnGetCoactivity,'enable','on')
            set(handles.btnGetCoactivity,'ForeGroundColor','black')
            set(handles.txtSmoothFilter,'enable','on')
            set(handles.chkZscore,'enable','on')
            set(handles.chkRemoveOscillations,'enable','on')
            % Peaks
            set(handles.chkDetectPeaksOrValleys,'enable','on')
            if(get(handles.chkDetectPeaksOrValleys,'value'))
                set(handles.popPeaksValleys,'enable','on')
                set(handles.txtCoactivityThreshold,'enable','on')
                set(handles.btnShuffleTest,'enable','on')
                set(handles.btnShuffleTest,'ForeGroundColor','black')
                set(handles.chkFixedWidth,'enable','on')
                if(get(handles.popPeaksValleys,'value')==3)
                    set(handles.popStimuli,'enable','on')
                end
            else
               set(handles.chkFixedWidth,'value',true) 
            end
            
            set(handles.rdbSpikes,'enable','on')
            if(get(handles.chkFixedWidth,'value'))
                set(handles.txtFixedWidth,'enable','on')
            end
            set(handles.chkJoin,'enable','on')
            if(get(handles.chkJoin,'value'))
                set(handles.chkDividePeaks,'enable','on')
                if(get(handles.chkDividePeaks,'value'))
                    set(handles.txtDividePeaks,'enable','on')
                end
            end
            set(handles.popVectorMethod,'enable','on')
            if(get(handles.popVectorMethod,'value')==4)
                set(handles.popNetworkMethod,'enable','on')
            end
            set(handles.btnSaveBySeconds,'enable','on')
            % Similarity
            set(handles.popSimilarityMethod,'enable','on')
            set(handles.popLinkageMethod,'enable','on')
            % Groups
            set(handles.txtGroups,'enable','on')
            set(handles.txtGroupsToPlot,'enable','on')
            % Network
            set(handles.btnGetNetworkRaster,'enable','on')
            set(handles.btnGetNetworkRaster,'ForeGroundColor','black')
        case 'Frequencies'
            set(handles.btnPlotFrequencies,'enable','on')
            set(handles.rdbFrequencies,'enable','on')    
        case 'Peaks'
            set(handles.btnPlotCoactivity,'enable','on')
            set(handles.btnGetVectors,'enable','on')
            set(handles.btnGetVectors,'ForeGroundColor','black')
        case 'Similarity'
            set(handles.btnGetSimilarity,'enable','on')
            set(handles.btnGetSimilarity,'ForeGroundColor','black')
        case 'Clustering'
            set(handles.btnPlotSimilarity,'enable','on')
            set(handles.btnGetClusters,'enable','on')
            set(handles.btnGetClusters,'ForeGroundColor','black')          
            set(handles.btnDunnTest,'enable','on')
        case 'Network'
            set(handles.btnGetNetworks,'enable','on')
            set(handles.btnGetNetworks,'ForeGroundColor','black')
        case 'PlotNetwork'
            set(handles.btnPlotNetworks,'enable','on')
            set(handles.btnGetNetworks,'ForeGroundColor','black')
        case 'PlotNetworkByStimulus'
            set(handles.btnPlotStimulusNetworks,'enable','on')
            set(handles.btnPlotStimulusNetworks,'ForeGroundColor','black')
        case 'PlotStates'
            set(handles.btnPlotPeaks,'enable','on')
            set(handles.btnPlotSequence,'enable','on')
            if(get(handles.popVectorMethod,'value')==4)
                set(handles.btnGetNetworks,'enable','on')
            end
    end
end

%% --- Analysis ---
%% Get frequencies
function btnGetFrequencies_Callback(hObject,~,handles)
    % Color yellow
    set(hObject,'ForeGroundColor',[0.5 0.5 0]); pause(0.1); pause on
    tic
    
    % Read experiment
    experiment=Read_Experiment(handles);
    raster=experiment.Raster.Raster;
    samples_per_second=experiment.Raster.SamplesPerSecond;

    % Get frequencies
    %frequencies = Get_Normalized_Instant_Freq(raster,samples_per_second,'zscore');
    bin=200*samples_per_second/1000;step=20*samples_per_second/1000;
    frequencies = Get_Zscore_From_Raster(raster,bin,step);
     
    set(handles.btnPlotFrequencies,'enable','on')
    
    % Write experiment
    experiment.Raster.Frequencies=frequencies;
    Write_Experiment(handles,experiment);
    
    % Enable buttons
    Enable_Buttons(handles,'Frequencies')
    
    % Color green
    set(hObject,'ForeGroundColor',[0 0.5 0])
    time=toc; disp(['Done in ' num2str(time) ' s.'])
end

%% Shuffle test
function btnShuffleTest_Callback(hObject,~,handles)
    % Color yellow
    set(hObject,'ForeGroundColor',[0.5 0.5 0]); pause(0.1); pause on
    
    prompt = {'Enter number of iterations:','Enter significance level',...
        'Enter shuffle type (1=Time shift; 2=Frames; 3=Time; 4=ISI; 5=Cell; 6=Exchange)',...
        'Interval (0=[0-maximum value of coactivity];1=[0-number of cells]'};
    title = 'Enter parameters';
    dims = [1 50; 1 50; 1 50; 1 50];
    default_input = {'10','0.01','1','0'};
    answer = inputdlg(prompt,title,dims,default_input);
    if(~isempty(answer))
        iterations=str2num(answer{1});
        if(isempty(iterations))
            iterations=10;
        elseif(iterations<2)
            iterations=2;
        end
        
        alpha=str2num(answer{2});
        if(isempty(alpha))
            alpha=0.05;
        elseif(alpha>1 && alpha<0)
        alpha=0.05;
        end
        
        shuffle_method=str2num(answer{3});
        if(isempty(shuffle_method))
            shuffle_method=1;
        end
        switch(shuffle_method)
            case 1
                shuffle_method='time_shift';
            case 2
                shuffle_method='frames';
            case 3
                shuffle_method='time';
            case 4
                shuffle_method='isi';
            case 5
                shuffle_method='cell';
            case 6
                shuffle_method='exchange';
            otherwise
                shuffle_method='time_shift';
        end
        
        interval_by_cell=str2num(answer{4});
        if(isempty(interval_by_cell))
            interval_by_cell=1;
        end
        
        % Read experiment
        experiment=Read_Experiment(handles);
        raster=experiment.Raster.Raster;
        name=experiment.Raster.Name;
        smooth_window=experiment.Coactivity.SmoothWindow;
        z_score=experiment.Coactivity.ZScore;
        zscore_window=experiment.Coactivity.ZScoreWindow;
        only_mean=experiment.Coactivity.ZScoreOnlyMean;
        remove_oscillations=experiment.Coactivity.RemoveOscillations;
        
        % Process
        plot=false;
        coactivity_threshold_shuffeld_test = Shuffle_Test(raster,smooth_window,...
            iterations,shuffle_method,alpha,interval_by_cell,remove_oscillations,...
            z_score,only_mean,zscore_window,plot);
        
        % Save
        if(get(handles.chkSavePlot,'value'))
            Save_Figure(['Shuffle test (' shuffle_method ') - ' name]);
        end
        
        % Write experiment
        experiment.Coactivity.ShuffleMethod=shuffle_method;
        experiment.Coactivity.CoactivityThresholdShuffleTest=...
            coactivity_threshold_shuffeld_test;
        experiment.Coactivity.AlphaShuffleTest=alpha;
        Write_Experiment(handles,experiment);
    end
    % Color black
    set(hObject,'ForeGroundColor',[0 0 0])
end

%% Get coactivity
function btnGetCoactivity_Callback(hObject,~,handles)
    % Color yellow
    set(hObject,'ForeGroundColor',[0.5 0.5 0]); pause(0.1); pause on
    tic
    
    % Read experiment
    experiment=Read_Experiment(handles);
    raster=experiment.Raster.Raster;
    smooth_window=experiment.Coactivity.SmoothWindow;
    z_score=experiment.Coactivity.ZScore;
    zscore_window=experiment.Coactivity.ZScoreWindow;
    only_mean=experiment.Coactivity.ZScoreOnlyMean;
    remove_oscillations=experiment.Coactivity.RemoveOscillations;
    
    % Get coactivity
    coactivity = Get_And_Filter_Coactivity(raster,smooth_window);
    
    % Remove Oscillations
    if(remove_oscillations)
        percentage = 0.1;
        [coactivity,removed]= Remove_Oscillations(coactivity,percentage);
        experiment.Coactivity.CoactivityRemoved=removed;
    end
    
    % Z-score
    if(z_score)
        coactivity=Z_Score_Coactivity(coactivity,zscore_window,only_mean);
    end
    
    % Write experiment
    experiment.Coactivity.Coactivity=coactivity;
    experiment.Plot.Correlation = [];
    experiment.Plot.JaccardCorrelation = [];
    experiment.Plot.CorrelationState = [];
                
    Write_Experiment(handles,experiment);
    
    % Refresh coactivity threshold
    txtCoactivityThreshold_Callback(handles.txtCoactivityThreshold,[],handles);
    
    % Enable options on sorting raster/frequencies
    set(handles.popSortingNeurons,'string',{'no sorting','activity','activation',...
        'jaccard correlation','linear correlation'})
    set(handles.popSortingNeurons,'value',1)
    
    
    % Disable/Enable buttons
    Disable_Buttons(handles,'Peaks')
    Enable_Buttons(handles,'Peaks')
    
    % Color green
    set(hObject,'ForeGroundColor',[0 0.5 0])
    time=toc; disp(['Done in ' num2str(time) ' s.'])
end

%% Get neural vectors
function btnGetVectors_Callback(hObject,~,handles)
    % Color yellow
    set(hObject,'ForeGroundColor',[0.5 0.5 0]); pause(0.1); pause on
    tic
    
    % Read experiment
    experiment=Read_Experiment(handles);
    coactivity=experiment.Coactivity.Coactivity;
    coactivity_threshold=experiment.Coactivity.CoactivityThreshold;
    vector_method=experiment.Peaks.VectorMethod;
    network_method=experiment.Peaks.NetworkMethod;
    fixed_width=experiment.Peaks.FixedWidth;
    join=experiment.Peaks.Join;
    divide_peaks=experiment.Peaks.DividePeaks;
    use_spikes=experiment.Peaks.UseSpikes;
    fixed_width_window=experiment.Peaks.FixedWidthWindow;
    division_window=experiment.Peaks.DivisionWindow;
    samples_per_second=experiment.Raster.SamplesPerSecond;
    detect_peaks_or_valleys=experiment.Peaks.DetectPeaksOrValleys;
    
    if join
        % Ask for minimum
        prompt = {['Enter the minimum time width in ms to consider peak'...
            ' (0 = without restriction):']};
        title = 'Enter parameters';
        dims = [1 50];
        default_input = {'0'};
        answer = inputdlg(prompt,title,dims,default_input);
        if(~isempty(answer))
            minimum_width=str2num(answer{1})/1000*samples_per_second;
            if(isempty(minimum_width))
                minimum_width=0;
            elseif(minimum_width<1)
                minimum_width=0;
            end
        else
            minimum_width=0;
        end
        %}
    else
        minimum_width=0;
    end
    
    if(use_spikes)
        data=experiment.Raster.Raster;
    else
        data=experiment.Raster.Frequencies;
    end
    
    if(fixed_width)
        width=fixed_width_window;
    else
        width=0;
    end
    
    if detect_peaks_or_valleys
        if(get(handles.popPeaksValleys,'value')==3)
            stimuli = experiment.Peaks.Stimuli;
            detect_peaks = true;
            ignore_ini_fin = true;
            [vector_indices,vector_widths,vector_amplitudes,vector_ini_fin] = ...
                Find_Peaks_Or_Valleys(stimuli,coactivity_threshold,join,detect_peaks,...
                minimum_width,width,ignore_ini_fin);
            experiment.Peaks.DetectPeaks = false;
            experiment.Peaks.DetectValleys = false;
            experiment.Peaks.DetectStimuli = true;
        else
            % Find peaks indexes
            detect_peaks = get(handles.popPeaksValleys,'value')==1;
            ignore_ini_fin = true;
            [vector_indices,vector_widths,vector_amplitudes,vector_ini_fin] = ...
                Find_Peaks_Or_Valleys(coactivity,coactivity_threshold,join,detect_peaks,...
                minimum_width,width,ignore_ini_fin);
            experiment.Peaks.DetectPeaks = true;
            experiment.Peaks.DetectValleys = false;
            experiment.Peaks.DetectStimuli = false;
        end
        % Write experiment
        experiment.Peaks.Widths = vector_widths;
        experiment.Peaks.Amplitudes = vector_amplitudes;
        experiment.Peaks.IniFin = vector_ini_fin;
    else
        % Create vector indices
        samples=experiment.Raster.Samples;
        n=ceil(samples/width);
        vector_indices=zeros(samples,1);
        for i=1:n
            ini=(i-1)*width+1;
            fin=i*width;
            if(fin>samples)
                fin=samples;
            end
            vector_indices(ini:fin)=i;
        end
        
        % Write experiment
        experiment.Peaks.DetectPeaks=false;
        experiment.Peaks.DetectValleys = true;
        experiment.Peaks.DetectStimuli = false;
    end

    if divide_peaks
        vector_indices = Divide_Peaks(vector_indices, division_window);
    end

    if max(vector_indices)>0
        % Create a matrix with all vector peaks
        bin_network = 25; % bin_network = 25;
        vectors=Get_Peak_Vectors(data,vector_indices,vector_method,network_method,bin_network);
        count=size(vectors,1);
        
        % Create raster with only peaks
        raster_peaks = data(:,vector_indices>0);
        raster_no_peaks = data(:,~vector_indices);

        % Write experiment
        experiment.Peaks.Indices=vector_indices;
        experiment.Peaks.Vectors=vectors;
        experiment.Peaks.Count=count;
        experiment.Peaks.RasterPeaks=raster_peaks;
        experiment.Peaks.RasterNoPeaks=raster_no_peaks;
        Write_Experiment(handles,experiment);

        % Disable/Enable buttons
        Disable_Buttons(handles,'Similarity')
        Enable_Buttons(handles,'Similarity')
        if(get(handles.popPeaksValleys,'value')==3)
            set(handles.btnGetNetworksByStimuli,'enable','on')
        else
            set(handles.btnGetNetworksByStimuli,'enable','off')
        end
        
        % Color green
        set(hObject,'ForeGroundColor',[0 0.5 0])
    else
        warning('No vectors created')
        % Color red
        set(hObject,'ForeGroundColor',[0.5 0 0])
    end
    time=toc; disp(['Done in ' num2str(time) ' s.'])
end

%% Get similarity
function btnGetSimilarity_Callback(hObject,~,handles)
    % Color yellow
    set(hObject,'ForeGroundColor',[0.5 0.5 0]); pause(0.1); pause on
    tic
    
    % Read experiment
    experiment=Read_Experiment(handles);
    vectors=experiment.Peaks.Vectors;
    similarity_method=experiment.Clustering.SimilarityMethod;
    linkage_method=experiment.Clustering.LinkageMethod;
    
    % Get similarity
    similarity = Get_Peaks_Similarity(vectors,similarity_method);
    if(~isempty(similarity))
        tree=linkage(squareform(1-similarity,'tovector'),linkage_method);
    else
        tree=[];
    end

    % Write experiment
    experiment.Clustering.Similarity=similarity;
    experiment.Clustering.Tree=tree;
    Write_Experiment(handles,experiment);
    
    % Enable buttons
    Enable_Buttons(handles,'Clustering')
    
    % Color green
    set(hObject,'ForeGroundColor',[0 0.5 0])
    time=toc; disp(['Done in ' num2str(time) ' s.'])
end

%% Groups test
function btnDunnTest_Callback(hObject,~,handles)
    % Color yellow
    set(hObject,'ForeGroundColor',[0.5 0.5 0]); pause(0.1); pause on
    
    prompt = {'Enter test type (1=Contrast; 2=Dunn; 3=Davies)'};
    title = 'Enter parameters';
    dims = [1 50];
    default_input = {'1'};
    answer = inputdlg(prompt,title,dims,default_input);
    if(~isempty(answer))
        test_method=str2num(answer{1});
        if(isempty(test_method))
            test_method=1;
        end
        
        switch(test_method)
            case 1
                test_method='Contrast';
            case 2
                test_method='Dunn';
            case 3
                test_method='Davies';
            otherwise
                test_method='Contrast';
        end

        % Read experiment
        experiment=Read_Experiment(handles);
        name=experiment.Raster.Name;
        tree=experiment.Clustering.Tree;
        similarity=experiment.Clustering.Similarity;    
        groups=experiment.Clustering.Groups;
        
        if(groups>30)
            groups=2:ceil(groups/10):groups;
        else
            groups=2:30;
        end
        

        % Process
        obj=Set_Figure(['Clustering test (' name ')'],[0 0 600 300]);
        [~,groups_test]=ClustIdx_JP(tree, similarity,test_method,obj,'hierarchical',...
            groups); % 'Connectivity', 'Davies', 'Contrast'
        
        % Save
        if(get(handles.chkSavePlot,'value'))
            Save_Figure(['Clustering test (' test_method ') - ' name]);
        end
        
        % Write experiment
        experiment.Clustering.GroupsTest=groups_test;
        Write_Experiment(handles,experiment);
    end
    
    % Color black
    set(hObject,'ForeGroundColor',[0 0 0])
end

%% Get clusters
function btnGetClusters_Callback(hObject,~,handles)
    % Color yellow
    set(hObject,'ForeGroundColor',[0.5 0.5 0]); pause(0.1); pause on
    tic
    
    % Read experiment
    experiment=Read_Experiment(handles);
    raster = experiment.Raster.Raster;
    indices = experiment.Peaks.Indices;
    tree=experiment.Clustering.Tree;
    groups=experiment.Clustering.Groups;
    
    % Process
    % Get clusters
    group_indices=cluster(tree,'maxclust',groups);
    % Get Sequences
    [sequence_sorted,sorted_indices] = Get_Peaks_Sequence_Sorted(group_indices);
    
    % Get raster from states
    for i = 1:groups
        peaks = find(sequence_sorted==i);
        n_peaks = length(peaks);
        
        raster_state = [];
        for j = 1:n_peaks
            peak = raster(:,indices==peaks(j));
            raster_state = [raster_state peak];
        end
        raster_states{i}=raster_state;
    end
    
    % Write experiment
    experiment.Clustering.GroupIndices = group_indices;
    experiment.Clustering.SortedIndices = sorted_indices;
    experiment.Clustering.SequenceSorted = sequence_sorted;
    experiment.Clustering.RasterStates = raster_states;
    experiment.Plot.CorrelationState = [];
    Write_Experiment(handles,experiment);
    
    % Enable options on sorting raster/frequencies
    labels={'no sorting','activity','activation','jaccard correlation','linear correlation'};
    for i=1:groups
        labels{end+1}=['group ' num2str(i)];
    end
    set(handles.popSortingNeurons,'string',labels);
    set(handles.popSortingNeurons,'value',1);
    
    % Enable buttons
    Enable_Buttons(handles,'PlotStates')
    Enable_Buttons(handles,'Network')
    
    if(experiment.Peaks.DividePeaks)
        set(handles.btnPlotSequenceByPeak,'enable','on')
    end
    
    % Color green
    set(hObject,'ForeGroundColor',[0 0.5 0])
    time=toc; disp(['Done in ' num2str(time) ' s.'])
end

%% Get network
function btnGetNetworkRaster_Callback(hObject,~,handles)
    % Color yellow
    set(hObject,'ForeGroundColor',[0.5 0.5 0]); pause(0.1); pause on
    tic
    
    % Read experiment
    experiment = Read_Experiment(handles);
    raster = experiment.Raster.Raster;
    bin = 1;
    iterations = 1000;
    alpha = 0.05;
    network_method = experiment.Peaks.NetworkMethod;
    shuffle_method = 'time_shift';
    single_th = true;
    
    % Get significant network
    [whole_network,whole_coactivity] = Get_Significant_Network_From_Raster(...
        raster,bin,iterations,alpha,network_method,shuffle_method,single_th);
                
    % Write experiment
    experiment.Network.WholeCoactivity = whole_coactivity;
    experiment.Network.WholeNetwork = whole_network;
    Write_Experiment(handles,experiment);
    
    % Enable buttons
    set(handles.btnPlotWholeNetwork,'enable','on')
    
    % Color green
    set(hObject,'ForeGroundColor',[0 0.5 0])
    time=toc; disp(['Done in ' num2str(time) ' s.'])
end

%% Get networks from states
function btnGetNetworks_Callback(hObject,~,handles)
    % Color yellow
    set(hObject,'ForeGroundColor',[0.5 0.5 0]); pause(0.1); pause on
    
    % Read experiment
    experiment = Read_Experiment(handles);
    n = experiment.Raster.Neurons;
    groups = experiment.Clustering.Groups;
    
    % clear current networks
    experiment.Network.State = {};
    experiment.Network.StateSignificant = {};
                
    with_th = true;
    if(with_th)
        bin = 1; %bin = 25;
        iterations = 1000;
        alpha = 0.05;
        network_method = experiment.Peaks.NetworkMethod;
        shuffle_method = 'time_shift';
        single_th = true;
        
        groups_to_plot = experiment.Clustering.GroupsToPlot;
        %
        %correlation = experiment.Plot.Correlation;
        
%         sequence_sorted = experiment.Clustering.SequenceSorted;
%         indices = experiment.Peaks.Indices;
%         raster = experiment.Raster.Raster;
        % Get significant networks of each state
        for i=1:groups
            if(ismember(i,groups_to_plot))
                
                % Get state raster
                raster_state = experiment.Clustering.RasterStates{i};
                
                % compute correlation
                try
                    correlation = experiment.Plot.CorrelationState(i,:);
                catch
                    correlation = Compute_Correlation_by_State(experiment,i);
                    experiment.Plot.CorrelationState(i,:)=correlation;
                end
                
                tic
                % Get significant network
%                 [state_network_th,state_network] = Get_Significant_Network_From_Raster(...
%                     raster_state,bin,iterations,alpha,network_method,shuffle_method,single_th);
                [state_network_th,state_network] = ...
                    Get_Significant_Network_From_Raster_And_Correlation(raster_state,...
                    correlation,bin,iterations,alpha,network_method,shuffle_method,single_th);
                
                % Minimum two coactivations
                %state_network_th(state_network < 2) = 0; 
                
                % Write in experiment
                experiment.Network.State{i}=state_network;
                experiment.Network.StateSignificant{i}=state_network_th;
                toc
                
            end
        end
        %}
        % Get core network
%         raster_peaks = experiment.Peaks.RasterPeaks;
%         [core_network_th,core_network] = Get_Significant_Network_From_Raster(raster_peaks,...
%                 bin,iterations,alpha,network_method,shuffle_method,single_th);
        
        % Network of all networks = union of states and core network = intersection
        core_network = ones(n);
        network = zeros(n);
        for i=1:groups
            if(ismember(i,groups_to_plot))
                state_network_th = experiment.Network.StateSignificant{i};
                network = network + state_network_th;
                core_network = core_network .* state_network_th;
            end
        end
        core_network_th = core_network;
        network_th = logical(network);        
    else
        networks = experiment.Peaks.Vectors;
        sequence = experiment.Clustering.SequenceSorted;
        % Get significant networks of each state
        for i=1:groups
            if(ismember(i,groups_to_plot))
                % Get significant network
                if(sum(sequence==i)==1)
                    state_network = squareform(networks(sequence==i,:)>0);
                else
                    state_network = squareform(mean(networks(sequence==i,:)>0));
                end
                state_network_th = state_network==1;

                % Write in experiment
                experiment.Network.State{i}=state_network;
                experiment.Network.StateSignificant{i}=state_network_th;
            end
        end

        % Network of whole raster = intersection of states
        core_network = squareform(mean(networks>0));
        core_network_th = core_network==1;

        % Network of all networks = union of states
        network = zeros(n);
        for i=1:groups
            if(ismember(i,groups_to_plot))
                state_network_th = experiment.Network.StateSignificant{i};
                network = network + state_network_th;
            end
        end
        network_th = logical(network);
    end
    
    % Write experiment
    experiment.Network.Network=network;
    experiment.Network.Significant=network_th;
    experiment.Network.CoreNetwork=core_network;
    experiment.Network.CoreSignificant=core_network_th;
    Write_Experiment(handles,experiment);
    
    % Enable buttons
    Enable_Buttons(handles,'PlotNetwork')
    
    % Color green
    set(hObject,'ForeGroundColor',[0 0.5 0])
end

%% Get networks by stimuli
function btnGetNetworksByStimuli_Callback(hObject,~,handles)
    % Color yellow
    set(hObject,'ForeGroundColor',[0.5 0.5 0]); pause(0.1); pause on
    
    % Read experiment
    experiment = Read_Experiment(handles);
    n = experiment.Raster.Neurons;
    stimuli = experiment.Peaks.Stimuli;
    raster = experiment.Raster.Raster;
    
    groups = sum(unique(stimuli)>0);
    stimuli_sequence = zeros(size(stimuli));
    j=1;
    for i = unique(stimuli)'
        if(i)
            stimuli_sequence(stimuli==i)=j;
            j=j+1;
        end
    end
    stimuli_sequence = Delete_Consecutive_Coactivation(stimuli_sequence');
    stimuli_sequence = Get_Peaks_Sequence_Sorted(stimuli_sequence);
    stimuli_sequence = stimuli_sequence(stimuli_sequence>0);
    
    idx = Get_Peak_Or_Valley_Indices(stimuli,0.0001,true);
    is = find(idx~=[0; idx(1:numel(idx)-1)+1]);    % index of same peak
    % number of total peaks
    count = numel(is);                                       
    if count
        for j = 1:count-1
            indices(idx(is(j)):idx(is(j+1)-1),1)=j;    % set #peak
        end
        indices(idx(is(count)):max(idx),1)=count;
    end
    
    % clear current networks
    experiment.Network.Stimulus = {};
    experiment.Network.StimulusSignificant = {};
                
    bin = 1; %bin = 25;
    iterations = 1000;
    alpha = 0.05;
    network_method = experiment.Peaks.NetworkMethod;
    shuffle_method = 'time_shift';
    single_th = true;

    % Get significant networks of each stimulus
    for i=1:groups
        % Get state raster
        peaks = find(stimuli_sequence==i);
        n_peaks = length(peaks);

        raster_state = [];
        idx_stim = [];
        for j = 1:n_peaks
            peak = indices==peaks(j);
            raster_peak = raster(:,peak);
            raster_state = [raster_state raster_peak];
            idx_stim = [idx_stim; find(peak)];
        end

        % compute correlation
        try
            correlation = experiment.Plot.CorrelationStimulus(i,:);
        catch
            % compute correlation
            for j = 1:n
                D(j) = pdist([idx_stim';raster_state(j,:)],'correlation');
            end
            correlation = 1-D;
            correlation(isnan(correlation)) = 0;
            correlation(correlation<0) = 0;
            experiment.Plot.CorrelationStimulus(i,:)=correlation;
        end

        tic
        % Get significant network
        [state_network_th,state_network] = Get_Significant_Network_From_Raster_And_Correlation(...
            raster_state,correlation,bin,iterations,alpha,network_method,shuffle_method,single_th);

        % Write in experiment
        experiment.Network.Stimulus{i}=state_network;
        experiment.Network.StimulusSignificant{i}=state_network_th;
        toc
    end
    %}  
    % Network of all networks = union of states and core network = intersection
    core_network = ones(n);
    network = zeros(n);
    for i=1:groups
        state_network_th = experiment.Network.StimulusSignificant{i};
        network = network + state_network_th;
        core_network = core_network .* state_network_th;
    end
    core_network_th = core_network;
    network_th = logical(network);        
    
    % Write experiment
    experiment.Network.UnionStimulus = network;
    experiment.Network.UnionSignificantStimulus = network_th;
    experiment.Network.IntersectionStimulus = core_network;
    experiment.Network.IntersectionSignificantStimulus = core_network_th;
    Write_Experiment(handles,experiment);
    
    % Enable buttons
    Enable_Buttons(handles,'PlotNetworkByStimulus')
    
    % Color green
    set(hObject,'ForeGroundColor',[0 0.5 0])
end

%% --- Callbacks ---
%% Raster
function popWorkspace_Callback(hObject,~,handles)
    % Get data
    data_num=get(hObject,'Value');
    set(handles.lblRaster,'String','...')
    Disable_Buttons(handles,'Raster');
    if data_num>1
        data_strings=get(hObject,'String');
        name=data_strings{data_num};
        % Check if exist
        if evalin('base',['exist(''' name ''',''var'')'])
            raster=evalin('base',name);
            % Evaluate data
            set(handles.lblRaster,'ForegroundColor',[0 0.5 0])
            [cells,samples]=size(raster);
            if (samples>1 && cells>1 && length(size(raster))==2)
                % Data with less than 500 samples or more than 500 cells
                if (samples<cells)
                    set(handles.lblRaster,'ForegroundColor','red')
                    info='Maybe the raster should be transposed';
                else
                    info=sprintf('%d neurons, %d samples',cells,samples);
                end
                
                % Read experiment
                experiment=Read_Experiment(handles);
                
                % Enable controls
                Enable_Buttons(handles,'Raster')
                
                if(isempty(experiment))
                    % Set current parameters
                    experiment = Set_Current_Parameters(handles,experiment);

                    % Outputs
                    experiment.Raster.Raster = raster;
                    experiment.Raster.Activity = sum(raster,2);
                    experiment.Raster.Name = name;
                    experiment.Raster.Neurons = cells;
                    experiment.Raster.Samples = samples;
                    experiment.Plot.CurrentIndices = 1:cells;

                    % Write experiment
                    Write_Experiment(handles,experiment);
                else
                    % Read analysis variable
                    Read_Analysis(handles,experiment);
                end
            else
                info={'Raster should have 2 dimensions'};
                set(handles.lblRaster,'ForegroundColor','red')
                Disable_Buttons(handles,'Raster');
            end
        else
            info='Variable data does not exist!';
            btnRefreshWorkspace_Callback([],[],handles)
            Disable_Buttons(handles,'Raster');
        end
        set(handles.lblRaster,'String',info)
    end
end

function txtSamplesPerSecond_Callback(hObject,~,handles)
    % Read experiment
    experiment=Read_Experiment(handles);
    smooth_filter=experiment.Coactivity.SmoothFilter;
    
    % Process
    samples_per_second = User_Double_Entry_2(hObject,1,1,50000);
    samples_per_minute = 60*samples_per_second;
    smooth_window=smooth_filter*samples_per_second/1000;
    fixed_width_window=str2num(get(handles.txtFixedWidth,'string'))...
        *samples_per_second/1000;
    division_window=str2num(get(handles.txtDividePeaks,'string'))...
        *samples_per_second/1000;
    
    % Write experiment
    experiment.Raster.SamplesPerSecond=samples_per_second;
    experiment.Raster.SamplesPerMinute=samples_per_minute;
    experiment.Coactivity.SmoothWindow=smooth_window;
    experiment.Peaks.FixedWidthWindow=fixed_width_window;
    experiment.Peaks.DivisionWindow=division_window;
    Write_Experiment(handles,experiment);
    
    % Disable buttons and alert
    Disable_Buttons(handles,'Peaks');
    set(handles.rdbFrequencies,'enable','off')
    set(handles.rdbFrequencies,'value',false)
    set(handles.rdbSpikes,'value',true)
    rdbSpikes_Callback([],[],handles)
    set(handles.btnGetFrequencies,'ForegroundColor','black')
    set(handles.btnGetCoactivity,'ForegroundColor','black')
end

%% Coactivity
function txtSmoothFilter_Callback(hObject,~,handles)
    % Read experiment
    experiment=Read_Experiment(handles);
    samples_per_second=experiment.Raster.SamplesPerSecond;
    samples=experiment.Raster.Samples;
    
    % Process
    default=5000/samples_per_second;
    minimum=1000/samples_per_second;
    maximum=samples*1000/samples_per_second;
    multiple=true;
    smooth_filter=User_Number_Entry(hObject,default,minimum,maximum,multiple);
    smooth_window=smooth_filter*samples_per_second/1000;

    % Write experiment
    experiment.Coactivity.SmoothFilter=smooth_filter;
    experiment.Coactivity.SmoothWindow=smooth_window;
    Write_Experiment(handles,experiment);
    
    % Disable buttons
    Disable_Buttons(handles,'Peaks')
    set(handles.btnGetCoactivity,'ForegroundColor','black')
end

function chkZscore_Callback(hObject,~,handles)
    % Read experiment
    experiment=Read_Experiment(handles);
    samples_per_second=experiment.Raster.SamplesPerSecond;
    samples=experiment.Raster.Samples;
    
    % Process
    z_score = get(hObject,'value');
    coactivity_threshold=1.5;
    set(handles.txtCoactivityThreshold,'string','1.5')
    
    if(z_score)
        prompt = {'Z-score (0) or only substract mean (1):',['Enter the seconds of'...
            ' window for computation (0=all raster):']};
        title = 'Enter parameters';
        dims = [1 50; 1 50];
        default_input = {'0','0'};
        answer = inputdlg(prompt,title,dims,default_input);
        if(~isempty(answer))
            only_mean=str2num(answer{1});
            if(isempty(only_mean))
                only_mean=false;
            else
                only_mean=logical(only_mean);
            end

            zscore_window=str2num(answer{2});
            if(isempty(zscore_window))
                zscore_window=0;
            elseif(zscore_window>samples_per_second*samples)
                zscore_window=0;
            else
                zscore_window=round(zscore_window*samples_per_second);
            end
            experiment.Coactivity.ZScoreWindow=zscore_window;
            experiment.Coactivity.ZScoreOnlyMean=only_mean;
        end
    end
    % Write experiment
    experiment.Coactivity.ZScore=z_score;
    experiment.Coactivity.CoactivityThreshold=coactivity_threshold;
    Write_Experiment(handles,experiment);
    
    % Disable buttons    
    Disable_Buttons(handles,'Peaks')
    set(handles.btnGetCoactivity,'ForegroundColor','black')
end

function chkRemoveOscillations_Callback(hObject,~,handles)
    % Read experiment
    experiment=Read_Experiment(handles);
    
    % Process
    remove_oscillations = get(hObject,'value');
    
    % Write experiment
    experiment.Coactivity.RemoveOscillations=remove_oscillations;
    Write_Experiment(handles,experiment);
    
    % Disable buttons    
    Disable_Buttons(handles,'Peaks')
    set(handles.btnGetCoactivity,'ForegroundColor','black')
end

%% Neural vectors

% Selection 
function chkDetectPeaksOrValleys_Callback(hObject,~,handles)
    % Read experiment
    experiment=Read_Experiment(handles);
    
    % Process
    detect_peaks_or_valleys=get(hObject,'value');
    
    % Enable/Disable
    if(detect_peaks_or_valleys)
        % Enable
        set(handles.popPeaksValleys,'enable','on')
        set(handles.txtCoactivityThreshold,'enable','on')
        set(handles.btnShuffleTest,'enable','on')
        set(handles.chkFixedWidth,'enable','on')
        if(get(handles.chkFixedWidth,'value'))
            set(handles.txtFixedWidth,'enable','on')
        end
        % Set values
        coactivity_threshold=str2double(get(handles.txtCoactivityThreshold,'string'));
        experiment.Coactivity.CoactivityThreshold=coactivity_threshold;
    else
        % Disable
        set(handles.popPeaksValleys,'enable','off')
        set(handles.txtCoactivityThreshold,'enable','off')
        set(handles.btnShuffleTest,'enable','off')
        set(handles.chkFixedWidth,'enable','off')
        set(handles.txtFixedWidth,'enable','on')
        % Set values
        set(handles.chkFixedWidth,'value',true)
        experiment.Peaks.FixedWidth=true;
        experiment.Coactivity.CoactivityThreshold=[];
    end
    
    % Write experiment
    experiment.Peaks.DetectPeaksOrValleys=detect_peaks_or_valleys;
    Write_Experiment(handles,experiment);
    
    % Disable buttons
    Disable_Buttons(handles,'Similarity')
    set(handles.btnGetVectors,'ForegroundColor','black')
end

% Peaks or valleys
function popPeaksValleys_Callback(hObject,~,handles)

    % Enable Stimuli signal if selected
    if(get(hObject,'value')==3)
        set(handles.popStimuli,'enable','on')
    else
        set(handles.popStimuli,'enable','off')
    end

    % Disable buttons
    Disable_Buttons(handles,'Similarity')
    set(handles.btnGetVectors,'ForegroundColor','black')
end

% Stimuli
function popStimuli_Callback(hObject,~,handles)
    set(hObject,'ForegroundColor','black')
    
    % Read experiment
    experiment=Read_Experiment(handles);
    
    % Get data
    data_num=get(hObject,'Value');
    if data_num>1
        data_strings=get(hObject,'String');
        name=data_strings{data_num};
        % Check if exist
        if evalin('base',['exist(''' name ''',''var'')'])
            stimuli=evalin('base',name);
            % Evaluate data
            set(handles.lblRaster,'ForegroundColor',[0 0.5 0])
            if(isvector(stimuli))
                if(length(stimuli)~=experiment.Raster.Samples)
                    set(hObject,'ForegroundColor','red')
                end
            else
                set(hObject,'ForegroundColor','red')
            end
        else
            btnRefreshWorkspace_Callback([],[],handles)
            Disable_Buttons(handles,'Raster');
        end
    end
    
    % Write experiment
    experiment.Peaks.Stimuli = stimuli;
    Write_Experiment(handles,experiment);
    
    % Disable buttons
    Disable_Buttons(handles,'Similarity')
    set(handles.btnGetVectors,'ForegroundColor','black')
end

% Coactivity Threshold
function txtCoactivityThreshold_Callback(hObject,~,handles)
    % Read experiment
    experiment=Read_Experiment(handles);
    z_score=experiment.Coactivity.ZScore;
    coactivity=experiment.Coactivity.Coactivity;
    
    % Process
    if(z_score)
        maximum=max(floor(coactivity*10)/10);
    else
        maximum=experiment.Raster.Neurons;
    end
    coactivity_threshold = User_Double_Entry(hObject,0,0,maximum);
    
    % Write experiment
    experiment.Coactivity.CoactivityThreshold=coactivity_threshold;
    Write_Experiment(handles,experiment);
    
    % Disable buttons
    Disable_Buttons(handles,'Similarity')
    set(handles.btnGetVectors,'ForegroundColor','black')
end

% Use spikes
function rdbSpikes_Callback(~,~,handles)
    % Read experiment
    experiment=Read_Experiment(handles);
    
    % Process
    if(~get(handles.rdbSpikes,'value'))
        set(handles.rdbSpikes,'value',true)
    end
    set(handles.rdbFrequencies,'value',false)
    use_spikes=true;
    
    % Write experiment
    experiment.Peaks.UseSpikes=use_spikes;
    Write_Experiment(handles,experiment);
    
    % Disable buttons
    Disable_Buttons(handles,'Similarity')
    set(handles.btnGetVectors,'ForegroundColor','black')
end

% Use frequencies
function rdbFrequencies_Callback(~,~,handles)
    % Read experiment
    experiment=Read_Experiment(handles);
    
    % Process
    if(~get(handles.rdbFrequencies,'value'))
        set(handles.rdbFrequencies,'value',true)
    end
    set(handles.rdbSpikes,'value',false)
    use_spikes=false;
    
    % Write experiment
    experiment.Peaks.UseSpikes=use_spikes;
    Write_Experiment(handles,experiment);
    
    % Disable buttons
    Disable_Buttons(handles,'Similarity')
    set(handles.btnGetVectors,'ForegroundColor','black')
end

% Fixed width
function chkFixedWidth_Callback(hObject,~,handles)
    % Read experiment
    experiment=Read_Experiment(handles);
    
    % Process
    fixed_width=get(hObject,'value');
    
    if(fixed_width)
        set(handles.txtFixedWidth,'enable','on')
    else
        set(handles.txtFixedWidth,'enable','off')
    end
    
    % Write experiment
    experiment.Peaks.FixedWidth=fixed_width;
    Write_Experiment(handles,experiment);
    
    % Disable buttons
    Disable_Buttons(handles,'Similarity')
    set(handles.btnGetVectors,'ForegroundColor','black')
end

% Define fixed with
function txtFixedWidth_Callback(hObject,~,handles)
    % Read experiment
    experiment = Read_Experiment(handles);
    samples = experiment.Raster.Samples;
    samples_per_second = experiment.Raster.SamplesPerSecond;
    detect_peaks_or_valleys = experiment.Peaks.DetectPeaksOrValleys;
    
    % Process
    minimum = 1000/samples_per_second;
    maximum = samples*1000/samples_per_second;
    multiple = true;
    fixed_width_window = round(User_Number_Entry(hObject,minimum,minimum,maximum,multiple,...
        detect_peaks_or_valleys)*samples_per_second/1000);

    % Write experiment
    experiment.Peaks.FixedWidthWindow=fixed_width_window;
    Write_Experiment(handles,experiment);
    
    % Disable buttons
    Disable_Buttons(handles,'Similarity')
    set(handles.btnGetVectors,'ForegroundColor','black')
end

% Join peaks
function chkJoin_Callback(hObject,~,handles)
    % Read experiment
    experiment=Read_Experiment(handles);
    
    % Process
    join=get(hObject,'value');
    
    if(join)
        set(handles.chkDividePeaks,'enable','on')
        if(get(handles.chkDividePeaks,'value'))
            set(handles.txtDividePeaks,'enable','on')
        end
    else
        set(handles.chkDividePeaks,'enable','off')
        set(handles.txtDividePeaks,'enable','off')
    end
    
    % Write experiment
    experiment.Peaks.Join=join;
    Write_Experiment(handles,experiment);
    
    % Disable buttons
    Disable_Buttons(handles,'Similarity')
    set(handles.btnGetVectors,'ForegroundColor','black')
end

% Divide Peaks
function chkDividePeaks_Callback(hObject,~,handles)
    % Read experiment
    experiment=Read_Experiment(handles);
    
    % Process
    divide_peaks=get(hObject,'value');
    
    if(divide_peaks)
        set(handles.txtDividePeaks,'enable','on')
    else
        set(handles.txtDividePeaks,'enable','off')
        set(handles.btnPlotSequenceByPeak,'enable','off')
    end
    
    % Write experiment
    experiment.Peaks.DividePeaks=divide_peaks;
    Write_Experiment(handles,experiment);
    
    % Disable buttons
    Disable_Buttons(handles,'Similarity')
    set(handles.btnGetVectors,'ForegroundColor','black')
end

% Define division time
function txtDividePeaks_Callback(hObject,~,handles)
    % Read experiment
    experiment=Read_Experiment(handles);
    samples_per_second=experiment.Raster.SamplesPerSecond;
    fixed_width_window=experiment.Peaks.FixedWidthWindow;
    
    % Process
    minimum=1000/samples_per_second;
    maximum=abs(fixed_width_window)*1000/samples_per_second;
    multiple=true;
    division_window=User_Number_Entry(hObject,minimum,minimum,maximum,...
        multiple)*samples_per_second/1000;

    % Write experiment
    experiment.Peaks.DivisionWindow=division_window;
    Write_Experiment(handles,experiment);
    
    % Disable buttons
    Disable_Buttons(handles,'Similarity')
    set(handles.btnGetVectors,'ForegroundColor','black')
end


% Vector method
function popVectorMethod_Callback(hObject,~,handles)
    % Get data
    data_num=get(hObject,'Value');
    data_strings=get(hObject,'String');
    vector_method=data_strings{data_num};
    
    % Disable/enable button
    if(data_num<4)
        set(handles.popNetworkMethod,'enable','off')
    else
        set(handles.popNetworkMethod,'enable','on')
    end

    % Read experiment
    experiment=Read_Experiment(handles);

    % Write experiment
    experiment.Peaks.VectorMethod=vector_method;
    Write_Experiment(handles,experiment);
    
    % Disable buttons
    Disable_Buttons(handles,'Similarity')
    set(handles.btnGetVectors,'ForegroundColor','black')
end
% Network method
function popNetworkMethod_Callback(hObject,~,handles)
    % Get data
    data_num=get(hObject,'Value');
    data_strings=get(hObject,'String');
    network_method=data_strings{data_num};

    % Read experiment
    experiment=Read_Experiment(handles);

    % Write experiment
    experiment.Peaks.NetworkMethod=network_method;
    Write_Experiment(handles,experiment);
    
    % Disable buttons
    Disable_Buttons(handles,'Similarity')
    set(handles.btnGetVectors,'ForegroundColor','black')
end

%% Similarity
% Similarity method
function popSimilarityMethod_Callback(hObject,~,handles)
    % Get data
    data_num=get(hObject,'Value');
    data_strings=get(hObject,'String');
    similarity_method=data_strings{data_num};

    % Read experiment
    experiment=Read_Experiment(handles);

    % Write experiment
    experiment.Clustering.SimilarityMethod=similarity_method;
    Write_Experiment(handles,experiment);
    
    % Disable buttons
    Disable_Buttons(handles,'Clustering')
    set(handles.btnGetSimilarity,'ForegroundColor','black')
end
% Linkage method
function popLinkageMethod_Callback(hObject,~,handles)
    % Get data
    data_num=get(hObject,'Value');
    data_strings=get(hObject,'String');
    linkage_method=data_strings{data_num};

    % Read experiment
    experiment=Read_Experiment(handles);

    % Write experiment
    experiment.Clustering.LinkageMethod=linkage_method;
    Write_Experiment(handles,experiment);
    
    % Disable buttons
    Disable_Buttons(handles,'Clustering')
    set(handles.btnGetSimilarity,'ForegroundColor','black')
end

%% Clustering
% Groups
function txtGroups_Callback(hObject,~,handles)
    % Read experiment
    experiment = Read_Experiment(handles);
    count = experiment.Peaks.Count;
    
    % Process
    groups = User_Number_Entry(hObject,5,2,count);
    groups_string = [];
    for i=1:(groups-1)
        groups_string = [groups_string num2str(i) ','];
    end
    groups_string = [groups_string num2str(groups)];
    set(handles.txtGroupsToPlot,'string',groups_string)
    groups_to_plot = 1:groups;
    
    % Write experiment
    experiment.Clustering.Groups = groups;
    experiment.Clustering.GroupsToPlot = groups_to_plot;
    Write_Experiment(handles,experiment);
    
    % Disable buttons
    set(handles.btnGetClusters,'ForegroundColor','black')
end

%% Plots
% Sort neurons
function popSortingNeurons_Callback(hObject, ~, handles)
    % Color yellow
    set(hObject,'ForeGroundColor',[0.5 0.5 0]); pause(0.1); pause on
    
    % Read experiment
    experiment=Read_Experiment(handles);
    raster = experiment.Raster.Raster;
    neurons = experiment.Raster.Neurons;
    
    % Process
    data_num=get(hObject,'Value');
    data_strings=get(hObject,'String');
    sorting_method=data_strings{data_num};

    % Select sorting method
    switch(sorting_method)
        case 'no sorting'
            cell_indices = 1:neurons;
        case 'activity'
            activity=experiment.Raster.Activity;
            [~,cell_indices]=sort(activity,'descend');
        case 'activation'
            [~,cell_indices] = Sort_Raster(raster);
        case 'jaccard correlation'
            coactivity=experiment.Coactivity.Coactivity;
            try
                correlation = experiment.Plot.JaccardCorrelation(1,:);
                [~, cell_indices]=sort(correlation,'descend');
            catch
                disp('Computing correlation...')
                tic
                for i=1:neurons
                    D(i)=pdist([coactivity'; raster(i,:)],'jaccard');
                end
                correlation=1-D;
                [~, cell_indices]=sort(correlation,'descend');
                experiment.Plot.JaccardCorrelation=correlation;
                toc
            end
        case 'linear correlation'
            if(get(handles.popPeaksValleys,'value')==3)
                stimuli = experiment.Peaks.Stimuli;
                
                disp('Computing correlation...')
                tic
                for i=1:neurons
                    D(i)=pdist([stimuli';raster(i,:)],'correlation');
                end
                correlation=1-D;
                correlation(isnan(correlation))=0;
                correlation(correlation<0)=0;
                [~, cell_indices]=sort(correlation,'descend');
                toc
            else
                try
                    correlation = experiment.Plot.Correlation(1,:);
                    [~, cell_indices]=sort(correlation,'descend');
                catch
                    disp('Computing correlation...')
                    tic
                    coactivity=experiment.Coactivity.Coactivity;
                    for i=1:neurons
                        D(i)=pdist([coactivity';raster(i,:)],'correlation');
                    end
                    correlation=1-D;
                    correlation(isnan(correlation))=0;
                    correlation(correlation<0)=0;
                    [~, cell_indices]=sort(correlation,'descend');
                    toc
                end
            end
            experiment.Plot.Correlation=correlation;
        case 'structure'
            cell_indices = experiment.Plot.IDstructure;
        case 'structure by stimulus'
            cell_indices = experiment.Plot.IDstructureStimulus;
        otherwise
            by_group=strsplit(sorting_method,' ');
            group=str2num(by_group{2});
            try
                correlation = experiment.Plot.CorrelationState(group,:);
                [~, cell_indices]=sort(correlation,'descend');
            catch
                [correlation,cell_indices] = Compute_Correlation_by_State(experiment,group);
                experiment.Plot.CorrelationState(group,:)=correlation;
            end
    end
    
    % Write experiment
    experiment.Plot.CurrentIndices = cell_indices;
    experiment.Plot.CurrentSorting = sorting_method;
    Write_Experiment(handles,experiment);
    
    % Color green
    set(hObject,'ForeGroundColor',[0 0 0])
end

%% Compute correlation by state
function [correlation,cell_indices] = Compute_Correlation_by_State(experiment,group)

    disp('Computing correlation...')
    tic
    
    if experiment.Peaks.DetectStimuli
        signal = experiment.Peaks.Stimuli;
    else
        signal = experiment.Coactivity.Coactivity;
    end
    
    indices = experiment.Peaks.Indices;
    group_sequence = experiment.Clustering.SequenceSorted;
    neurons = experiment.Raster.Neurons;
    raster = experiment.Raster.Raster;

    % find indices of group peaks
    idx_group=find(group_sequence==group)';
    idx_indices=zeros(size(indices));
    for i=idx_group
        idx_indices(indices==i)=1;
    end
    %signal = signal.*idx_indices;
    signal = idx_indices;

    % compute correlation
    for i=1:neurons
        D(i) = pdist([signal';raster(i,:)],'correlation');
    end
    correlation = 1-D;
    correlation(isnan(correlation)) = 0;
    correlation(correlation<0) = 0;
    % sort
    [~, cell_indices] = sort(correlation,'descend');
    
    toc
end

% Groups to plot
function txtGroupsToPlot_Callback(hObject,~, handles)
    % Read experiment
    experiment=Read_Experiment(handles);
    groups=experiment.Clustering.Groups;
    
    % Process
    % default
    default_entry=[];
    for i=1:(groups-1)
        default_entry=[default_entry num2str(i) ','];
    end
    default_entry=[default_entry num2str(groups)];
    default_groups_to_plot=[1:groups];
    
    % validate user entry
    user_entry = get(hObject,'string');
    if ~isnan(user_entry)
        cell_groups=strsplit(user_entry,',');
        n=length(cell_groups);
        groups_to_plot=[];
        for i=1:n
            group_num=str2num(cell_groups{i});
            if(isempty(group_num))
                user_entry=default_entry;
                groups_to_plot=default_groups_to_plot;
                break;
            end
            groups_to_plot=[groups_to_plot group_num];
        end
    else
        user_entry=default_entry;
        groups_to_plot=default_groups_to_plot;
    end
    set(hObject,'string',num2str(user_entry));
    
    % Write experiment
    experiment.Clustering.GroupsToPlot=groups_to_plot;
    Write_Experiment(handles,experiment);
end

%% --- Plots ---
%% Plot raster
function btnPlotRaster_Callback(hObject,~,handles)
    % Color yellow
    set(hObject,'ForeGroundColor',[0.5 0.5 0]); pause(0.1); pause on
    
    % Read experiment
    experiment = Read_Experiment(handles);
    raster = experiment.Raster.Raster;
    name = experiment.Raster.Name;
    
    try
        cell_indices = experiment.Plot.CurrentIndices;
        current_sorting = experiment.Plot.CurrentSorting;
    catch
        neurons = experiment.Raster.Neurons;
        cell_indices = 1:neurons;
        current_sorting = 'no sorting';
        
        % Write experiment
        experiment.Plot.CurrentIndices = cell_indices;
        experiment.Plot.CurrentSorting = current_sorting;
        Write_Experiment(handles,experiment);
    end
    
    % Plot raster
    plot_spikes=true;
    Plot_Raster(raster(cell_indices,:),name,plot_spikes)
    if (strcmp(current_sorting,'no sorting'))
        ylabel('neurons')
    else
        ylabel({'neurons sorted by'; current_sorting})
    end
    
    % Save
    if(get(handles.chkSavePlot,'value'))
        Save_Figure(['Raster - ' name]);
    end
    
    % Color black
    set(hObject,'ForeGroundColor',[0 0 0])
end

%% Plot frequencies
function btnPlotFrequencies_Callback(hObject,~,handles)
    % Color yellow
    set(hObject,'ForeGroundColor',[0.5 0.5 0]); pause(0.1); pause on
    
    % Read experiment
    experiment = Read_Experiment(handles);
    frequencies = experiment.Raster.Frequencies;
    name = experiment.Raster.Name;
    
    try
        cell_indices = experiment.Plot.CurrentIndices;
        current_sorting = experiment.Plot.CurrentSorting;
    catch
        neurons = experiment.Raster.Neurons;
        cell_indices = 1:neurons;
        current_sorting = 'no sorting';
        
        % Write experiment
        experiment.Plot.CurrentIndices = cell_indices;
        experiment.Plot.CurrentSorting = current_sorting;
        Write_Experiment(handles,experiment);
    end
    
    % Plot frequencies
    plot_spikes=false;
    Plot_Raster(frequencies(cell_indices,:),name,plot_spikes)
    if (strcmp(current_sorting,'no sorting'))
        ylabel('neurons')
    else
        ylabel({'neurons sorted by'; current_sorting})
    end
    
    % Save
    if(get(handles.chkSavePlot,'value'))
        Save_Figure(['Frequencies - ' name]);
    end
    
    % Color black
    set(hObject,'ForeGroundColor',[0 0 0])
end

%% Plot coactivity
function btnPlotCoactivity_Callback(hObject,~,handles)
    % Color yellow
    set(hObject,'ForeGroundColor',[0.5 0.5 0]); pause(0.1); pause on
    
    % Read experiment
    experiment=Read_Experiment(handles);
    coactivity_threshold=experiment.Coactivity.CoactivityThreshold;
    name=experiment.Raster.Name;
    samples_per_second=experiment.Raster.SamplesPerSecond;
    smooth_coactivity=experiment.Coactivity.Coactivity;
    
    
    if(get(handles.popPeaksValleys,'value')==3)
        coactivity_threshold = [];
    end
    
    % Plot coactivity
    Plot_Coactivity(smooth_coactivity,name,coactivity_threshold,samples_per_second)
    if(experiment.Coactivity.ZScore)
        ylabel({'coactivity';'(z-score)'})
    end
    if (experiment.Coactivity.SmoothFilter>1000/samples_per_second)
        if(experiment.Coactivity.RemoveOscillations)
            title(['smooth filter (' num2str(experiment.Coactivity.SmoothFilter)...
                ' ms) - slow oscillations removed']);
        else
            title(['smooth filter (' num2str(experiment.Coactivity.SmoothFilter) ' ms)']);
        end
    elseif(experiment.Coactivity.RemoveOscillations)
        title('slow oscillations removed');
    else
        title('');
    end
    
    % Save
    if(get(handles.chkSavePlot,'value'))
        Save_Figure(['Coactivity - ' name]);
    end
    
    % Color black
    set(hObject,'ForeGroundColor',[0 0 0])
end

%% Plot similarity
function btnPlotSimilarity_Callback(hObject,~,handles)
    % Color yellow
    set(hObject,'ForeGroundColor',[0.5 0.5 0]); pause(0.1); pause on
    
    % Read experiment
    experiment=Read_Experiment(handles);
    similarity=experiment.Clustering.Similarity;
    name=experiment.Raster.Name;
    tree=experiment.Clustering.Tree;
    similarity_method=experiment.Clustering.SimilarityMethod;
    linkage_method=experiment.Clustering.LinkageMethod;

    % Plot Similarity
    Plot_Similarity(similarity,name,tree,similarity_method,linkage_method)
    
    % Save
    if(get(handles.chkSavePlot,'value'))
        Save_Figure(['Similarity - ' name]);
    end
    
    % Color black
    set(hObject,'ForeGroundColor',[0 0 0])
end

%% Plot peaks
function btnPlotPeaks_Callback(hObject,~,handles)
    % Color yellow
    set(hObject,'ForeGroundColor',[0.5 0.5 0]); pause(0.1); pause on
    
    % Read experiment
    experiment=Read_Experiment(handles);
    name=experiment.Raster.Name;
    samples_per_second=experiment.Raster.SamplesPerSecond;
    coactivity=experiment.Coactivity.Coactivity;
    coactivity_threshold=experiment.Coactivity.CoactivityThreshold;
    peak_indices=experiment.Peaks.Indices;
    indices=experiment.Clustering.SequenceSorted;
    groups_to_plot=experiment.Clustering.GroupsToPlot;
    groups=experiment.Clustering.Groups;
    
    if(get(handles.popPeaksValleys,'value')==3)
        coactivity_threshold = [];
    end
    
    % noise_group
    noise_group=setdiff(1:groups,groups_to_plot);
    
    % Plot Peaks
    peak_number=false;
    Plot_Coactivity(coactivity,name,coactivity_threshold,samples_per_second);
    Plot_Peaks_On_Coactivity(coactivity,peak_indices,indices,...
        noise_group,peak_number)
    if(experiment.Coactivity.ZScore)
        ylabel({'coactivity';'(z-score)'})
    end
    if (experiment.Coactivity.SmoothFilter>1000/samples_per_second)
        if(experiment.Coactivity.RemoveOscillations)
            title(['smooth filter (' num2str(experiment.Coactivity.SmoothFilter)...
                ' ms) - slow oscillations removed']);
        else
            title(['smooth filter (' num2str(experiment.Coactivity.SmoothFilter) ' ms)']);
        end
    elseif(experiment.Coactivity.RemoveOscillations)
        title('slow oscillations removed');
    end
    
    % Save
    if(get(handles.chkSavePlot,'value'))
        Save_Figure(['Coactivity Peaks - ' name]);
    end
    
    % Color black
    set(hObject,'ForeGroundColor',[0 0 0])
end

%% Plot sequence
function btnPlotSequence_Callback(hObject,~,handles)
    
    % Color yellow
    set(hObject,'ForeGroundColor',[0.5 0.5 0]); pause(0.1); pause on
    
    % Ask for division
    prompt = {'Enter the seconds of windows to divide the raster: (0=all sequence)'};
    title = 'Enter parameters';
    dims = [1 50];
    default_input = {'0'};
    answer = inputdlg(prompt,title,dims,default_input);
    if(~isempty(answer))
        window_sec=str2num(answer{1});
        if(isempty(window_sec))
            window_sec=1;
        end
    
        % Read experiment
        experiment=Read_Experiment(handles);
        name=experiment.Raster.Name;
        groups_to_plot=experiment.Clustering.GroupsToPlot;
        sequence=experiment.Clustering.SequenceSorted;
        groups=experiment.Clustering.Groups;

        % noise_group
        noise_group=setdiff(1:groups,groups_to_plot);

        if(window_sec==0)
            % Plot Sequence
            Plot_States_Sequence(sequence,noise_group,name);

            % Save
            if(get(handles.chkSavePlot,'value'))
                Save_Figure(['Sequence - ' name]);
            end
        else
            % read indices
            indices=experiment.Peaks.Indices;
            samples=experiment.Raster.Samples;
            samples_per_second=experiment.Raster.SamplesPerSecond;
            window=window_sec*samples_per_second;
            
            n_seqs=ceil(samples/window);
            indices_seq=zeros(length(sequence),1);
            for i=1:n_seqs
                if(i*window>samples)
                    idx=find(indices(((i-1)*window+1):end)>0,1,'first');
                    ini=indices((i-1)*window+idx);
                    fin=max(indices(((i-1)*window+1):end));
                else    
                    idx=find(indices(((i-1)*window+1):i*window)>0,1,'first');
                    ini=indices((i-1)*window+idx);
                    fin=max(indices(((i-1)*window+1):i*window));
                end
                
                % Plot Sequence
                Plot_States_Sequence(sequence(ini:fin),noise_group,...
                    [name ' (' num2str(i) '-' num2str(n_seqs) ')'],...
                    Read_Colors(max(sequence)));
                
                if(i==1)
                    Hold_Axes('States count');
                    ylims = get(gca,'ylim');
                else
                    Hold_Axes('States count');
                    ylim(ylims)
                end
                
                % Save
                if(get(handles.chkSavePlot,'value'))
                    Save_Figure(['Sequence - ' name '_' num2str(i) '-' num2str(n_seqs)]);
                end
                indices_seq(ini:fin)=i;
            end
            % Write experiment
            experiment.Plot.SecondsForSequences=window_sec;
            experiment.Plot.IndicesForSequences=indices_seq;
            Write_Experiment(handles,experiment);
        end
    end
    
    % Color black
    set(hObject,'ForeGroundColor',[0 0 0])
end

%% Plot sequence by peak
function btnPlotSequenceByPeak_Callback(hObject,~,handles)
    % Color yellow
    set(hObject,'ForeGroundColor',[0.5 0.5 0]); pause(0.1); pause on
    
    % Read experiment
    experiment=Read_Experiment(handles);
    name=experiment.Raster.Name;
    division_window=experiment.Peaks.DivisionWindow;
    fixed_width_window=abs(experiment.Peaks.FixedWidthWindow);
    sequence=experiment.Clustering.SequenceSorted;
    samples_per_second=experiment.Raster.SamplesPerSecond;
    
    % Peak width
    width=ceil(fixed_width_window/division_window);
    
    % Plot save
    save_plot=get(handles.chkSavePlot,'value');
    
    % Plot states by width
    division_ms=division_window*1000/samples_per_second;
    
    % Plot state sequences
    sequences=Plot_States_By_Width(sequence,width,name,save_plot);
    Plot_Sequences(sequences,division_ms,save_plot,'Sequences');

    % Plot graphs from sequencies
    %adjacency_vectors=Plot_Sequence_Graph_By_Width(sequence,width,name,save_plot);
    %Plot_Sequences(double(adjacency_vectors>0),division_ms,save_plot,'Adjacencies',...
    %flipud(gray(max(adjacency_vectors(:)))));
    %Plot_Sequences(adjacency_vectors,division_ms,save_plot,'Adjacencies',...
    %flipud(gray(max(adjacency_vectors(:)))));
    
    % Write experiment
    experiment.Plot.Sequences=sequences;
    %experiment.Plot.AdjacencyVectors=adjacency_vectors;
    Write_Experiment(handles,experiment);
    
    % Color black
    set(hObject,'ForeGroundColor',[0 0 0])
end

%% Plot whole network 
function btnPlotWholeNetwork_Callback(hObject,~,handles)
    % Color yellow
    set(hObject,'ForeGroundColor',[0.5 0.5 0]); pause(0.1); pause on
    
    % Read experiment
    experiment = Read_Experiment(handles);
    name = strrep(experiment.Raster.Name,'_','-');
    n = experiment.Raster.Neurons;
    coactivity = experiment.Network.WholeCoactivity;
    network = experiment.Network.WholeNetwork;
    
    try
        cell_indices = experiment.Plot.CurrentIndices;
    catch
        neurons = experiment.Raster.Neurons;
        cell_indices = 1:neurons;
        current_sorting = 'no sorting';
        
        % Write experiment
        experiment.Plot.CurrentIndices = cell_indices;
        experiment.Plot.CurrentSorting = current_sorting;
        Write_Experiment(handles,experiment);
    end
    
    % Get coordinates of network
%     xy = Get_Force_XY(coactivity);
    xy = Get_Circular_XY(n);
        
    % Plot network
    save_plot=get(handles.chkSavePlot,'value');
    
    edge_color = [0.5 0.5 0.5];
    node_color = [0.8 0.8 0.8];
    network_plot = coactivity.*network;
    Plot_Adjacencies_And_Network(coactivity(cell_indices,cell_indices),...
        network_plot(cell_indices,cell_indices),['All networks (union) - ' name],...
        xy,node_color,edge_color,save_plot)
    
    % Color black
    set(hObject,'ForeGroundColor',[0 0 0])
end


%% Plot networks
function btnPlotNetworks_Callback(hObject,~,handles)
    % Color yellow
    set(hObject,'ForeGroundColor',[0.5 0.5 0]); pause(0.1); pause on
    
    % Read experiment
    experiment = Read_Experiment(handles);
    name = strrep(experiment.Raster.Name,'_','-');
    network_th = experiment.Network.Significant;
    save_plot=get(handles.chkSavePlot,'value');
    % old plot
    %{
%     n = experiment.Raster.Neurons;
%     groups = experiment.Clustering.Groups;
%     groups_to_plot=experiment.Clustering.GroupsToPlot;
%     network = experiment.Network.Network;
%     core_network = experiment.Network.CoreNetwork;
%     core_network_th = experiment.Network.CoreSignificant;
%     
%     try
%         cell_indices = experiment.Plot.CurrentIndices;
%     catch
%         neurons = experiment.Raster.Neurons;
%         cell_indices = 1:neurons;
%         current_sorting = 'no sorting';
%         
%         % Write experiment
%         experiment.Plot.CurrentIndices = cell_indices;
%         experiment.Plot.CurrentSorting = current_sorting;
%         Write_Experiment(handles,experiment);
%     end
%     
%     % Get coordinates of network
% %     xy = Get_Force_XY(network);
%     xy = Get_Circular_XY(n);
%         
%     
%     
%     edge_color = [0.5 0.5 0.5];
%     node_color = [0.8 0.8 0.8];
%     network_plot = network.*network_th;
%     Plot_Adjacencies_And_Network(network(cell_indices,cell_indices),...
%         network_plot(cell_indices,cell_indices),['All networks (union) - ' name],...
%         xy,node_color,edge_color,save_plot)
%     lims_x = get(gca,'xlim');
%     lims_y = get(gca,'ylim');
%     
%     % Plot core network
%     network_plot = core_network.*core_network_th;
%     Plot_Adjacencies_And_Network(core_network(cell_indices,cell_indices),...
%         network_plot(cell_indices,cell_indices),...
%         ['Core network (intersection) - ' name],...
%         xy,node_color,edge_color,save_plot)  
%     xlim(lims_x)
%     ylim(lims_y)
%     
%     % Plot network of each state
%     colors = Read_Colors(groups);
%     for i=1:groups
%         if(ismember(i,groups_to_plot))
%             state_network = experiment.Network.State{i};
%             state_network_th = experiment.Network.StateSignificant{i};
% 
%             network_plot = state_network.*state_network_th;
%             Plot_Adjacencies_And_Network(state_network(cell_indices,cell_indices),...
%             network_plot(cell_indices,cell_indices),...
%             ['State ' num2str(i) ' network - ' name],...
%             xy,colors(i,:),edge_color,save_plot)
% 
%             xlim(lims_x)
%             ylim(lims_y)
%         end
%     end
    %btnPlotRandomNetworks_Callback(hObject,[], handles)
    %}
    
    [~, xy_colors, id, structure] = Get_XY_Ensembles(experiment.Network.StateSignificant);
    Plot_Ensembles(network_th(id,id),[],xy_colors,structure,name,save_plot);

    % Set structure sorting
    labels = get(handles.popSortingNeurons,'string');
    n = length(labels);
    if ~strcmp(labels{n},'structure') && ~strcmp(labels{n-1},'structure')
        labels{n+1} = 'structure';
        set(handles.popSortingNeurons,'string',labels);
    end
    
    % Write experiment
    experiment.Plot.IDstructure = id;
    experiment.Plot.Structure = structure;
    experiment.Plot.ColorsStructure = xy_colors;
    Write_Experiment(handles,experiment);
        
    % Color black
    set(hObject,'ForeGroundColor',[0 0 0])
end

%% Plot networks by stimulus
function btnPlotStimulusNetworks_Callback(hObject,~,handles)
    % Color yellow
    set(hObject,'ForeGroundColor',[0.5 0.5 0]); pause(0.1); pause on
    
    % Read experiment
    experiment = Read_Experiment(handles);
    name = strrep(experiment.Raster.Name,'_','-');
    network_th = experiment.Network.UnionSignificantStimulus;
    save_plot = get(handles.chkSavePlot,'value');
   
    % plot networks
    [~, xy_colors, id, structure] = Get_XY_Ensembles(experiment.Network.StimulusSignificant);
    Plot_Ensembles(network_th(id,id),[],xy_colors,structure,name,save_plot);

    % Set structure sorting
    labels = get(handles.popSortingNeurons,'string');
    n = length(labels);
    if ~strcmp(labels{n},'structure by stimulus') && ~strcmp(labels{n-1},'structure by stimulus')
        labels{n+1} = 'structure by stimulus';
        set(handles.popSortingNeurons,'string',labels);
    end
    
    % Write experiment
    experiment.Plot.IDstructureStimulus = id;
    experiment.Plot.StructureStimulus = structure;
    experiment.Plot.ColorsStructureStimulus = xy_colors;
    Write_Experiment(handles,experiment);
        
    % Color black
    set(hObject,'ForeGroundColor',[0 0 0])
end

% Plot random
%{
function btnPlotRandomNetworks_Callback(hObject, ~, handles)
    % Color yellow
    set(hObject,'ForeGroundColor',[0.5 0.5 0]); pause(0.1); pause on
    
    % Read experiment
    experiment = Read_Experiment(handles);
    name = strrep(experiment.Raster.Name,'_','-');
    width = experiment.Peaks.FixedWidthWindow;
    n = experiment.Raster.Neurons;
    vector_method = experiment.Peaks.VectorMethod;
    network_method = experiment.Peaks.NetworkMethod;
    groups = experiment.Clustering.Groups;
    raster_states = experiment.Clustering.RasterStates;
    
    if(isfield(experiment,'Plot'))
        cell_indices = experiment.Plot.CellIndices;
    else
        cell_indices = 1:experiment.Raster.Neurons;
    end
    
    shuffled_joined = zeros(n);
    shuffled_core = ones(n);
    for i = 1:groups
        raster_state = raster_states{i};
        samples=size(raster_state,2);
        raster_shuffled = shuffle(raster_state,'time_shift');
        
        % Get vectors from state
        n=ceil(samples/width);
        vector_indices=zeros(samples,1);
        for j=1:n
            ini=(j-1)*width+1;
            fin=j*width;
            if(fin>samples)
                fin=samples;
            end
            vector_indices(ini:fin)=j;
        end
        % Create a matrix with all vector peaks
        shuffled_networks=Get_Peak_Vectors(raster_shuffled,vector_indices,...
            vector_method,network_method);        
        state_shuffled = squareform(mean(shuffled_networks>0));
        state_shuffled_th = state_shuffled==1;
        
        % Get 
        shuffled_joined = shuffled_joined + state_shuffled_th;
        shuffled_core = shuffled_core.*state_shuffled_th;
    
        % Write in experiment
        experiment.Network.StateShuffled{i}=state_shuffled;
        experiment.Network.StateSignificantShuffled{i}=state_shuffled_th;        
    end
    shuffled_joined_th = logical(shuffled_joined);
    
    % Get coordinates of network
    xy = Get_Force_XY(shuffled_joined);
    xy = xy(cell_indices,:);
    
    % Plot networks
    save_plot=get(handles.chkSavePlot,'value');
    edge_color = [0.5 0.5 0.5];
    node_color = [0.8 0.8 0.8];
    Plot_Adjacencies_And_Network(shuffled_joined(cell_indices,cell_indices),...
        shuffled_joined_th(cell_indices,cell_indices),...
        ['Shuffled all networks (union) - ' name],...
        xy,node_color,edge_color,save_plot)
    lims_x = get(gca,'xlim');
    lims_y = get(gca,'ylim');
    
    % Plot core network
    Plot_Adjacencies_And_Network(shuffled_core(cell_indices,cell_indices),...
        shuffled_core(cell_indices,cell_indices),...
        ['Shuffled core network (intersection) - ' name],...
        xy,node_color,edge_color,save_plot)  
    xlim(lims_x)
    ylim(lims_y)
    
    % Plot network of each state
    colors = Read_Colors(groups);
    for i=1:groups
        state_shuffled = experiment.Network.StateShuffled{i};
        state_shuffled_th = experiment.Network.StateSignificantShuffled{i};
        
        Plot_Adjacencies_And_Network(state_shuffled(cell_indices,cell_indices),...
        state_shuffled_th(cell_indices,cell_indices),...
        ['Shuffled state ' num2str(i) ' network - ' name],...
        xy,colors(i,:),edge_color,save_plot)
        
        xlim(lims_x)
        ylim(lims_y)
    end
    
    % Write experiment
    experiment.Network.NetworkShuffled=shuffled_joined;
    experiment.Network.ShuffledSignificant=shuffled_joined_th;
    experiment.Network.ShuffledCoreSignificant=shuffled_core;
    Write_Experiment(handles,experiment);
    
    % Color black
    set(hObject,'ForeGroundColor',[0 0 0])
end
%}

%% --- Save ---

%% Save raster by x seconds
function btnSaveBySeconds_Callback(hObject,~,handles)
    % Color yellow
    set(hObject,'ForeGroundColor',[0.5 0.5 0]); pause(0.1); pause on
    
    % Ask for division
    prompt = {'Enter the seconds of windows to divide the raster:'};
    title = 'Enter parameters';
    dims = [1 50];
    default_input = {'60'};
    answer = inputdlg(prompt,title,dims,default_input);
    if(~isempty(answer))
        window_sec=str2num(answer{1});
        if(isempty(window_sec))
            window_sec=60;
        end
        
        % Read experiment
        experiment=Read_Experiment(handles);
        name=experiment.Raster.Name;
        samples_per_second=experiment.Raster.SamplesPerSecond;
        samples=experiment.Raster.Samples;
        final_sec=samples/samples_per_second;
        use_spikes=experiment.Peaks.UseSpikes;

        % Check if raster was ploted
        h=findobj('name',['Raster (' name ')']);
        if isempty(h)
            % Plot
            if(use_spikes)
                btnPlotRaster_Callback([],[],handles);
            else
                btnPlotFrequencies_Callback([],[],handles);
            end
        end
        
        % Check if coactivity was ploted
        h=findobj('name',['Coactivity (' name ')']);
        i=findobj('tag',['CoactiveAxes' name]);
        if (isempty(h) && isempty(i))
            btnPlotPeaks_Callback([],[],handles);
        end
        
        % Save
        Save_Raster_By_Windows(name,samples_per_second,window_sec,final_sec)
    end
    % Color black
    set(hObject,'ForeGroundColor',[0 0 0])
end
