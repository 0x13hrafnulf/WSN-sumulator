function simulator
clc
clear all

%%%%%Window%%%%%
main_window = figure('Name', 'Cluster Analyser', 'Units', 'Normalized', 'Position', [0, 0, 0.6, 0.9], 'Visible', 'off', 'MenuBar', 'none', 'Resize', 'on');


%%%%%GUI features (buttons etc.)%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Network panel%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

network_panel = uipanel('Parent', main_window, 'Units', 'Normalized', ...
        'Position', [0.05, 0.01, 0.2, 0.20], 'Title', 'Network parameters:', 'Visible', 'on','FontWeight', 'bold' , 'FontSize' , 12);
num_of_nodes = uicontrol('Parent', network_panel, 'Style', 'text', 'String', 'N-nodes', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 10,'Position', [0.0, 0.8, 0.4, 0.12], 'Visible', 'on');
num_of_nodes_edit = uicontrol('Parent', network_panel,'Style', 'edit',  'String', '50','Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 10,'Position', [0.4, 0.8, 0.18, 0.15], 'Visible', 'on');    
area_size_str = uicontrol('Parent', network_panel, 'Style', 'text', 'String', 'Area(x,y)', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 10,'Position', [0.0, 0.60, 0.4, 0.12], 'Visible', 'on');
area_size_x_edit = uicontrol('Parent', network_panel,'Style', 'edit', 'String', '100', 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 10,'Position', [0.4, 0.60, 0.18, 0.15], 'Visible', 'on');
area_size_y_edit = uicontrol('Parent', network_panel,'Style', 'edit', 'String', '100', 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 10,'Position', [0.58, 0.60, 0.18, 0.15], 'Visible', 'on');
base_station_str = uicontrol('Parent', network_panel, 'Style', 'text', 'String', 'B.Station(x,y)', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 10,'Position', [0.0, 0.40, 0.4, 0.12], 'Visible', 'on');  
base_station_x_edit = uicontrol('Parent', network_panel,'Style', 'edit','String', '50', 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 10,'Position', [0.4, 0.40, 0.18, 0.15], 'Visible', 'on');
base_station_y_edit = uicontrol('Parent', network_panel,'Style', 'edit', 'String', '50',  'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 10,'Position', [0.58, 0.40, 0.18, 0.15], 'Visible', 'on');    

uicontrol('Parent', network_panel, 'Style', 'pushbutton', 'String', 'Apply', 'Units', 'Normalized', ...
        'Position', [0.76, 0.60, 0.20, 0.15], 'FontWeight', 'bold' ,'FontSize' , 10, 'Callback', @set_area);     
uicontrol('Parent', network_panel, 'Style', 'pushbutton', 'String', 'Apply', 'Units', 'Normalized', ...
        'Position', [0.76, 0.40, 0.20, 0.15], 'FontWeight', 'bold' ,'FontSize' , 10, 'Callback', @set_bs); 
    
uicontrol('Parent', network_panel, 'Style', 'pushbutton', 'String', 'Generate', 'Units', 'Normalized', ...
        'Position', [0.58, 0.8, 0.38, 0.15], 'FontWeight', 'bold' ,'FontSize' , 10, 'Callback', @generate_nodes);    
uicontrol('Parent', network_panel, 'Style', 'pushbutton', 'String', 'Open file', 'Units', 'Normalized', ...
        'Position', [0.5, 0.0, 0.5, 0.15], 'FontWeight', 'bold' , 'FontSize' , 10, 'Callback', @open_file);    

uicontrol('Parent', network_panel, 'Style', 'text', 'String', 'Node placement', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 10,'Position', [0.0, 0.2, 0.58, 0.12]);    
placement_method = uicontrol('Parent', network_panel, 'Style', 'popupmenu', 'String', { 'Random', 'Square', 'Triangular', 'Hexagon', 'Tri-hexagon'}, 'Units', 'Normalized', ...
        'FontWeight','bold','FontAngle','italic','FontSize' , 10,'Position', [0.58, 0.2, 0.38, 0.15], 'Callback', @placement_chosen);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%File panel%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   

file_panel = uipanel('Parent', main_window, 'Units', 'Normalized', ...
        'Position', [0.75, 0.01, 0.2, 0.20], 'Title', 'File:', 'Visible', 'on','FontWeight', 'bold' , 'FontSize' , 12);
uicontrol('Parent', file_panel,'Style', 'pushbutton', 'String', 'Save file as', 'Units', 'Normalized', ...
        'Position', [0.05, 0.8, 0.4, 0.2], 'FontWeight', 'bold' ,'FontSize' , 11, 'Callback', @save_file);
uicontrol('Parent', file_panel,'Style', 'pushbutton', 'String', 'Save graph', 'Units', 'Normalized', ...
        'Position', [0.05, 0.6, 0.4, 0.2], 'FontWeight', 'bold' ,'FontSize' , 11,'Callback', @save_graph);
uicontrol('Parent', file_panel,'Style', 'pushbutton', 'String', 'Statistics', 'Units', 'Normalized', ...
        'Position', [0.05, 0.4, 0.4, 0.2], 'FontWeight', 'bold' ,'FontSize' , 11,'Callback', @save_stat);    
file_save_method = uicontrol('Parent', file_panel, 'Style', 'popupmenu', 'String', {'Binary (.mat)', 'Text (.txt)'}, 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 11 ,'Position', [0.45, 0.8, 0.55, 0.2]);    
graph_save_method = uicontrol('Parent', file_panel,'Style', 'popupmenu', 'String', {'Network graph','Input graph', 'Both graphs'}, 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 11 ,'Position', [0.45, 0.6, 0.55, 0.2]);
stat_save_method = uicontrol('Parent', file_panel,'Style', 'popupmenu', 'String', {'Network graph','Input graph', 'Both graphs'}, 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 11 ,'Position', [0.45, 0.4, 0.55, 0.2]);

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Algorithm panel%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

algorithm_panel = uipanel('Parent', main_window, 'Units', 'Normalized', ...
        'Position', [0.25, 0.01, 0.5, 0.20], 'Title', 'Algorithm parameters:', 'Visible', 'on','FontWeight', 'bold' , 'FontSize' , 12);
uicontrol('Parent', algorithm_panel, 'Style', 'text', 'String', '1. Clustering', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 10,'Position', [0.0, 0.9, 0.25, 0.1]);
cluster_method_chosen = uicontrol('Parent', algorithm_panel, 'Style', 'popupmenu', 'String', { 'K-Means', 'DBSCAN', 'GMM-clusters', 'Hierarchical', 'K-Means-M'}, 'Units', 'Normalized', ...
        'FontWeight','bold','FontAngle','italic','FontSize' , 11,'Position', [0.0, 0.8, 0.3, 0.1], 'Callback', @method_chosen);

uicontrol('Parent', algorithm_panel, 'Style', 'pushbutton', 'String', 'Run simulation', 'Units', 'Normalized', ...
        'Position', [0.7, 0.0, 0.3, 0.15], 'FontWeight', 'bold' ,'FontSize' , 10, 'Callback', @simulate);
num_of_rounds = uicontrol('Parent', algorithm_panel, 'Style', 'text', 'String', 'N-rounds',  'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 10,'Position', [0.65, 0.80, 0.2, 0.12], 'Visible', 'on');
num_of_rounds_edit = uicontrol('Parent', algorithm_panel,'Style', 'edit', 'String', '50', 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 10,'Position', [0.85, 0.80, 0.15, 0.15], 'Visible', 'on');

    
%%Statistics
total_enerdy_str = uicontrol('Parent', algorithm_panel, 'Style', 'text', 'String', 'Total energy',  'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 10,'Position', [0.65, 0.60, 0.2, 0.12], 'Visible', 'on');
total_enerdy_edit = uicontrol('Parent', algorithm_panel,'Style', 'edit', 'String', '0', 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 10,'Position', [0.85, 0.60, 0.15, 0.15], 'Visible', 'on');
nodes_alive_str = uicontrol('Parent', algorithm_panel, 'Style', 'text', 'String', 'Nodes alive',  'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 10,'Position', [0.65, 0.40, 0.2, 0.12], 'Visible', 'on');
nodes_alive_edit = uicontrol('Parent', algorithm_panel,'Style', 'edit', 'String', '50', 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 10,'Position', [0.85, 0.40, 0.15, 0.15], 'Visible', 'on');    
nodes_dead_str = uicontrol('Parent', algorithm_panel, 'Style', 'text', 'String', 'Dead nodes',  'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 10,'Position', [0.65, 0.20, 0.2, 0.12], 'Visible', 'on');
nodes_dead_edit = uicontrol('Parent', algorithm_panel,'Style', 'edit', 'String', '0', 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 10,'Position', [0.85, 0.20, 0.15, 0.15], 'Visible', 'on');    
    
%%%%%Panel for k-means, hierarchical, gmm%%%%%
method_panel = uipanel('Parent', algorithm_panel, 'Units', 'Normalized', ...
        'Position', [0.0, 0.0, 0.3, 0.75], 'Title', 'Parameters:', 'Visible', 'on', 'FontWeight', 'bold');
cluster_num_str = uicontrol('Parent', method_panel, 'Style', 'text', 'String', 'N-Clusters', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 10,'Position', [0.1, 0.8, 0.8, 0.2], 'Visible', 'on');
cluster_num_edit = uicontrol('Parent', method_panel,'Style', 'edit', 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 10,'Position', [0.1, 0.6, 0.8, 0.2], 'Visible', 'on');
uicontrol('Parent', method_panel, 'Style', 'pushbutton', 'String', 'Calculate', 'Units', 'Normalized', ...
        'Position', [0.1, 0.0, 0.8, 0.2], 'FontWeight', 'bold' ,'FontSize' , 10, 'Callback', @calculate_clusters);

%%%%%DBSCAN specific%%%%%
dbscan_panel = uipanel('Parent', algorithm_panel, 'Units', 'Normalized', ...
        'Position', [0.0, 0.0, 0.3, 0.75], 'Title', 'Parameters:', 'Visible', 'off', 'FontWeight', 'bold');
cluster_num_str_dbscan = uicontrol('Parent', dbscan_panel, 'Style', 'text', 'String', 'N-Clusters', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 9,'Position', [0.1, 0.88, 0.8, 0.12]);
cluster_num_edit_dbscan = uicontrol('Parent', dbscan_panel,'Style', 'edit', 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 9,'Position', [0.1, 0.73, 0.8, 0.15]);    
epsilon_str = uicontrol('Parent', dbscan_panel,'Style', 'text', 'String', 'Epsilon (radius)', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 9,'Position', [0.1, 0.61, 0.8, 0.12]);
epsilon =  uicontrol('Parent', dbscan_panel,'Style', 'edit', 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 9,'Position', [0.1, 0.46, 0.8, 0.15]);
neighbours_str = uicontrol('Parent', dbscan_panel,'Style', 'text', 'String', 'N-Neighbours', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 9,'Position', [0.1, 0.35, 0.8, 0.12]);
min_neigh =  uicontrol('Parent', dbscan_panel,'Style', 'edit', 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 9,'Position', [0.1, 0.2, 0.8, 0.15]);
uicontrol('Parent', dbscan_panel, 'Style', 'pushbutton', 'String', 'Calculate', 'Units', 'Normalized', ...
        'Position', [0.1, 0.0, 0.8, 0.2], 'FontWeight', 'bold' ,'FontSize' , 10, 'Callback', @calculate_clusters);

%%%%%Panel Shortest path%%%%%
uicontrol('Parent', algorithm_panel, 'Style', 'text', 'String', '2. Shortest-path', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 10,'Position', [0.3, 0.9, 0.3, 0.1]);
path_method_chosen = uicontrol('Parent', algorithm_panel, 'Style', 'popupmenu', 'String', { 'Dijkstra', 'Bellman-Ford'}, 'Units', 'Normalized', ...
        'FontWeight','bold','FontAngle','italic','FontSize' , 11,'Position', [0.35, 0.8, 0.3, 0.1]);
path_panel = uipanel('Parent', algorithm_panel, 'Units', 'Normalized', ...
        'Position', [0.35, 0.0, 0.3, 0.75], 'Title', 'Parameters:', 'Visible', 'on', 'FontWeight', 'bold');
energy_node_str = uicontrol('Parent', path_panel, 'Style', 'text', 'String', 'Node energy(J)', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 9,'Position', [0.0, 0.8, 0.7, 0.2], 'Visible', 'on');
energy_node_edit = uicontrol('Parent', path_panel,'Style', 'edit', 'String', '2', 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 10,'Position', [0.7, 0.8, 0.2, 0.2], 'Visible', 'on');  
msg_body_size_str = uicontrol('Parent', path_panel, 'Style', 'text', 'String', 'Msg body(Bytes)', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 9,'Position', [0.0, 0.6, 0.7, 0.2], 'Visible', 'on');
msg_body_size_edit = uicontrol('Parent', path_panel,'Style', 'edit','String', '250', 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 10,'Position', [0.7, 0.6, 0.2, 0.2], 'Visible', 'on');  
msg_header_size_str = uicontrol('Parent', path_panel, 'Style', 'text', 'String', 'Msg header(Bytes)', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 9,'Position', [0.0, 0.4, 0.7, 0.2], 'Visible', 'on');
msg_header_size_edit = uicontrol('Parent', path_panel,'Style', 'edit', 'String', '43', 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 10,'Position', [0.7, 0.4, 0.2, 0.2], 'Visible', 'on');         
uicontrol('Parent', path_panel, 'Style', 'pushbutton', 'String', 'Calculate Weights', 'Units', 'Normalized', ...
        'Position', [0.1, 0.2, 0.8, 0.2], 'FontWeight', 'bold' ,'FontSize' , 10, 'Callback', @calculate_weights);    
uicontrol('Parent', path_panel, 'Style', 'pushbutton', 'String', 'Calculate', 'Units', 'Normalized', ...
        'Position', [0.1, 0.0, 0.8, 0.2], 'FontWeight', 'bold' ,'FontSize' , 10, 'Callback', @calculate_paths);

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Init%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
area_x = str2double(get(area_size_x_edit, 'String'));
area_y = str2double(get(area_size_y_edit, 'String'));    
ax1 = axes('Units', 'Normalized', 'Position', [0.05, 0.25, 0.9, 0.70]);
xlim([0 area_x]);
ylim([0 area_y]);
grid(ax1, 'on');
%axis square;
title(ax1, 'Network','FontWeight','bold');
ylabel('Y (m)','FontSize',10, 'FontWeight', 'bold');
xlabel('X (m)','FontSize',10, 'FontWeight', 'bold');
tb1 = axtoolbar(ax1,'default');
tb1.Visible = 'on';
bs_x = str2double(get(base_station_x_edit, 'String'));
bs_y =  str2double(get(base_station_y_edit, 'String'));
xticklabels('auto');

hold(ax1, 'on');
p = plot(ax1, bs_x, bs_y, 'bs',...
    'LineWidth',2,...
    'MarkerSize',15,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor', 'b');
%plot(ax1, bs_x, bs_x, 'bo', 'MarkerSize', 200);
%xticks(0:10:area_x);
%yticks(0:10:area_y);


hold(ax1, 'off');

n_rounds = str2double(get(num_of_rounds_edit, 'String'));
n_nodes = str2double(get(num_of_nodes_edit, 'String'));
init_energy = str2double(get(energy_node_edit, 'String'));%2 or 0.5
msg_body_size = 8 * str2double(get(msg_body_size_edit, 'String')); %lbody = 250 bytes, 2000 bits
msg_header_size = 8 * str2double(get(msg_header_size_edit, 'String')); %lheader = 43 bytes, 344 bits

nodes = zeros(n_nodes, 7); %x, y, id, status, energy = 2j or 0.5j, energy_consumption, role (1 = ch, 0 = simple node)
for i = 1:n_nodes
    
    nodes(i,1) = rand(1,1)*area_x;	
    nodes(i,2) = rand(1,1)*area_y;
    nodes(i,3) = i;
    nodes(i,4) = 1;
    nodes(i,5) = init_energy;
    
end
hold(ax1, 'on');
scatter(ax1, nodes(:,1), nodes(:,2), 'ko' , 'filled');
hold(ax1, 'off');

movegui(main_window, 'center');
set(main_window, 'Visible', 'on');
full_filename = [];
filename_for_saving = [];
output_matrix = [];
labels = [];
centroids = [];
cluster_graph = [];
CHs = [];
total_energy = 0;
total_energy_per_round = zeros(n_rounds,1);
node_energy_per_round = zeros(n_nodes, n_rounds);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

    function set_bs(src, event)
        bs_x = str2double(get(base_station_x_edit, 'String'));
        bs_y =  str2double(get(base_station_y_edit, 'String'));
        p(1).XData = bs_x;
        p(1).YData = bs_y;
    end

    function set_area(src, event)
        area_x = str2double(get(area_size_x_edit, 'String'));
        area_y = str2double(get(area_size_y_edit, 'String'));    
        xlim([0 area_x]);
        ylim([0 area_y]);
    end

    function generate_nodes(src, event)
        hold(ax1, 'on');
        cla;
        n_nodes = str2double(get(num_of_nodes_edit, 'String'));
        nodes = zeros(n_nodes, 2);
        for i = 1:n_nodes
            nodes(i,1) = rand(1,1)*area_x;	
            nodes(i,2) = rand(1,1)*area_y;
        end
        p = plot(ax1, bs_x, bs_y, 'bs',...
            'LineWidth',2,...
            'MarkerSize',15,...
            'MarkerEdgeColor','b',...
            'MarkerFaceColor', 'b');    
        scatter(ax1, nodes(:,1), nodes(:,2), 'ko' , 'filled');
        hold(ax1, 'off');
    end

    function method_chosen(src, event)
        s_method = get(cluster_method_chosen, 'String');
        s_value = get(cluster_method_chosen, 'Value');
        switch s_method{s_value}
            case 'DBSCAN'
                set(dbscan_panel, 'Visible', 'on');
                set(method_panel, 'Visible', 'off');
            otherwise
                set(dbscan_panel, 'Visible', 'off');
                set(method_panel, 'Visible', 'on');
        end
    end

    function open_file(src, event)
        cla(ax1,'reset');
        [filename, pathname] = uigetfile('*.*');
        full_filename = [pathname filename];
        [pathstr, filename_for_saving, ext] = fileparts(full_filename);
        nodes = load(full_filename);
        switch ext
            case ".mat"
                nodes = nodes.D; %specify matrix name that being loaded from file 
        end
        marker = ['+','o','*','.','s','d','^','v','>','<','p','h'];
        colors = ['r', 'g', 'b', 'y', 'm', 'c', 'w', 'k'];
        %label = input_matrix(:,3);   
        %n = max(label);
        %for i = 1:n
                %index = 1 + mod(i, 12);
                %indexcol = 1 + mod(i, 8);
                %col = colors(indexcol);
                %col2 = colors(8 - indexcol + 1);
                %scatter(ax1, input_matrix(label == i,1), input_matrix(label == i,2), 'filled', marker(index), 'MarkerFaceColor', col, 'MarkerEdgeColor', col2);
                %hold(ax1, 'on');    
        %end
        scatter(ax1, nodes(:,1), nodes(:,2), 'ko' , 'filled');
    end
    
    function fn = get_filename_for_saving()
        current_date = date;
        method = get(cluster_method_chosen, 'String');
        value = get(cluster_method_chosen, 'Value');
        number_of_clusters = get(cluster_num_edt, 'String');
        number_of_neighbours = get(min_neigh, 'String');
        eps = get(epsilon, 'String');
        
        switch method{value}
            case 'DBSCAN'
                number_of_clusters = strcat('eps_', eps, '_neighbours_', number_of_neighbours);
        end
        
        fn = strcat(filename_for_saving,'_',method{value},'_params:',number_of_clusters,'_date:',current_date);
    end

    function save_file(src, event)
        
        items = get(save_method_chosen2,'String');
        index_selected = get(save_method_chosen2,'Value');
        save_selected = items{index_selected};
        fileName = get_filename_for_saving();
        
        switch save_selected
            case 'Text (.txt)'
                fileName = strcat(fileName, '.txt');
                dlmwrite(fileName, output_matrix, 'delimiter', ' ');
            otherwise
                fileName = strcat(fileName, '.mat');
                X = output_matrix;
                save(fileName, 'X');
        end
        
        msgbox({'Your file was saved:'; fileName}, 'Success');
       
    end
    function save_graph(src, event)
        
        graphName = get_filename_for_saving();
        
        items = get(save_method_chosen1,'String');
        index_selected = get(save_method_chosen1,'Value');
        save_selected = items{index_selected};
        switch save_selected
            case 'Both graphs'
                fig = main_window;
                fig.InvertHardcopy = 'off';
                graphName = strcat(graphName,'_', save_selected);
                print(graphName,'-dpng','-noui');
            otherwise
                if(strcmp(save_selected,'Output graph'))
                    ax = ax2;
                else
                    ax = ax1;
                end
                f_new = figure('Visible', 'off');
                f_new.InvertHardcopy = 'off';
                ax_new = copyobj(ax, f_new);
                set(ax_new,'Position','default');
                graphName = strcat(graphName,'_', save_selected);
                print(f_new, graphName,'-dpng');
                close(f_new);
        end
        
        msgbox({'Your graph was saved:'; graphName}, 'Success');
    end

    function calculate_clusters(src, event)
        method = get(cluster_method_chosen, 'String');
        value = get(cluster_method_chosen, 'Value');
        number_of_clusters = get(cluster_num_edit, 'String');
        number_of_neighbours = get(min_neigh, 'String');
        eps = get(epsilon, 'String');
        if(isempty(number_of_clusters) & strcmp(method{value}, 'DBSCAN') == 0)
            msgbox('Please enter the number of clusters.', 'Error','error');
        else
            number_of_clusters = str2double(number_of_clusters);
            switch method{value} %check the method for drawing 
            case 'DBSCAN'
                if(isempty(number_of_neighbours) | isempty(eps))
                    msgbox('Please enter the values of epsilon and neighbours', 'Error','error');
                else
                    number_of_clusters1 = str2double(get(cluster_num_edt1, 'String'));
                    number_of_neighbours = str2double(number_of_neighbours);
                    eps = str2double(eps);
                    data_sz = size(nodes, 1);
                    labels, centroids = get_dbscan_result(nodes, eps, number_of_neighbours, data_sz);
                    nodes = [nodes, labels];
                end 
            case 'K-Means'    
                 [labels, centroids] = get_k_means_result(nodes, number_of_clusters);
                 nodes = [nodes, labels];  
                 CHs = zeros(number_of_clusters, 2);
                 draw(centroids, number_of_clusters);
            case 'GMM-clusters'     
                 labels, centroids = get_gmm_result(nodes, number_of_clusters);
                 nodes = [nodes, labels];
            case 'Hierarchical'     
                 labels, centroids = get_hierarchical_result(nodes, number_of_clusters);
                 nodes = [nodes, labels];
            case 'K-Means-M'
                 labels, centroids = get_k_means_modernized_result(nodes, number_of_clusters);
                 nodes = [nodes, labels]; 
            end  
        end
    end
    
    

    function calculate_weights(src, event)
         number_of_clusters = get(cluster_num_edit, 'String');
         number_of_clusters = str2double(number_of_clusters);
         calculate_energy(centroids, number_of_clusters)
         draw_cluster_lines(centroids, number_of_clusters);
         draw_lines(centroids, number_of_clusters);
         
    end

    function calculate_energy(cluster_heads, n)
        %Etx = l*Eelec + l*Efs*d^2, d < d0
        %Etx = l*Eelec + l*Efs*d^4, d >= d0
        %Erx = l*Elec
        %%Eelec=Etx=Erx
        Eelec = 50*0.000000001;
        %Transmit Amplifier types
        Efs=10*0.000000000001;
        Emp=0.0013*0.000000000001;
        %Data Aggregation Energy
        EDA=5*0.000000001;
        %Do
        d0=sqrt(Efs/Emp);
        Points = [cluster_heads(:,1:2); bs_x, bs_y];
        Dist = pdist2(Points, Points);
        Weights = Dist;
        for i=1:n+1
            for j=1:n+1
                Etx = 0;
                Erx = 0;
                Etotal = 0;
                if(i ~= j)
                    if(d0 > Dist(i,j))
                        Etx = (msg_body_size + msg_header_size)*(Eelec+EDA) + (msg_body_size + msg_header_size)*Efs*Dist(i,j)^2;
                    elseif(d0 < Dist(i,j))
                        Etx = (msg_body_size + msg_header_size)*(Eelec+EDA) + (msg_body_size + msg_header_size)*Emp*Dist(i,j)^4;
                    end
                    Erx = (msg_body_size + msg_header_size)*(Eelec);
                    Etotal = Etx + Erx;
                    Weights(i, j) = Etotal;
                    t_x = Points(i,1) + Points(j,1);
                    t_y = Points(i,2) + Points(j,2);
                    text(t_x/2, t_y/2, num2str(Etotal),'Color', 'b','FontSize',11, 'FontWeight', 'bold' );
                end
            end
        end
        
        for i = 1:n
            ch_x = cluster_heads(i,1);
            ch_y = cluster_heads(i,2);
            cluster = nodes(labels == i,1:2);
            number_of_points = size(cluster,1);
            
            for j = 1:number_of_points
                Etx = 0;
                Erx = 0;
                Etotal = 0;
                d = ((cluster(j,1) - ch_x)^2 + (cluster(j,2) - ch_y)^2)^0.5;
                if(d0 > d)
                       Etx = (msg_body_size + msg_header_size)*(Eelec+EDA) + (msg_body_size + msg_header_size)*Efs*d^2;
                elseif(d0 < d)
                       Etx = (msg_body_size + msg_header_size)*(Eelec+EDA) + (msg_body_size + msg_header_size)*Efs*d^4;
                end
                Erx = (msg_body_size + msg_header_size)*(Eelec);
                Etotal = Etx + Erx;
                text(cluster(j,1), cluster(j,2), num2str(Etotal),'Color', 'k','FontSize', 10);
            end   
        end     

        %Graph calculation
        cluster_graph = graph(Weights);
        for i=1:n
            [path, d] = shortestpath(cluster_graph, n+1, i);
            disp(path);
            disp(d);
        end
    end

    function calculate_paths(src, event)
        method = get(path_method_chosen, 'String');
        value = get(path_method_chosen, 'Value');
        switch method{value} %check the method for drawing 
            case 'Dijkstra'
            case 'Bellman-Ford '    

        end  
    end

    function simulate(src, event)
        n_rounds = str2double(get(num_of_rounds_edit, 'String'));
        
        for i=n_rounds:-1:0  
            num_of_rounds_edit.String =  num2str(i);
            pause(1);
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%DRAWING%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function draw(centroids, n_clusters)
        cla;
        hold(ax1, 'on');
        for i=1:n_clusters
           draw_circle(centroids(i,1), centroids(i,2), centroids(i, 3)); %(x, y, max_dist);
           scatter(ax1, nodes(labels == i, 1), nodes(labels == i, 2), 'o' , 'filled');
           text(centroids(i,1)+area_x/100, centroids(i,2), num2str(i), 'Color', 'b','FontSize', 12, 'FontWeight', 'bold');
        end
        p = plot(ax1, bs_x, bs_y, 'bs',...
            'LineWidth',2,...
            'MarkerSize',15,...
            'MarkerEdgeColor','b',...
            'MarkerFaceColor', 'b');        
        scatter(ax1, centroids(:,1), centroids(:,2),100, 'b*', 'LineWidth', 2,...
            'MarkerEdgeColor','b',...
            'MarkerFaceColor', 'b');        
        hold(ax1, 'off');      
    end

    function draw_circle(x, y, r)
        th = 0:pi/100:2*pi;
        xunit = r * cos(th);
        yunit = r * sin(th);
        plot(xunit + x, yunit  + y, ':k');
    end

    function draw_cluster_lines(cluster_heads, n)
         hold(ax1, 'on');  
         for i = 1:n   
             plot([cluster_heads(i,1), bs_x], [cluster_heads(i,2), bs_y], 'b');          
             for j = 2:n
                 if(j > i) 
                     plot([cluster_heads(i,1), cluster_heads(j,1)], [cluster_heads(i,2), cluster_heads(j,2)],'b'); 
                 end;
            end  
         end      
         hold(ax1, 'off');
    end

    function draw_lines(cluster_heads, n)
         hold(ax1, 'on');  
         for i = 1:n
            ch_x = cluster_heads(i,1);
            ch_y = cluster_heads(i,2);
            cluster = nodes(labels == i,1:2);
            number_of_points = size(cluster,1);
            for j = 1:number_of_points     
                 plot([cluster(j,1), ch_x], [cluster(j,2), ch_y],'--k');
            end   
         end     
         hold(ax1, 'off');
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
