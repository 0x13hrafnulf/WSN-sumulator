function simulatorDT
clc
clear all

%%%%%Window%%%%%
main_window = figure('Name', 'SimulatorDT', 'Units', 'Normalized', 'Position', [0, 0, 0.6, 0.9], 'Visible', 'off', 'MenuBar', 'none', 'Resize', 'on');
datacursormode on;

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
        'FontWeight','bold','FontAngle','italic','FontSize' , 10,'Position', [0.58, 0.2, 0.38, 0.15]);
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
stat_save_method = uicontrol('Parent', file_panel,'Style', 'popupmenu', 'String',...
        {'Total energy consumption','Energy consumption per round', 'Node energy consumption per round', 'Average node energy consumption', ...
        'Nodes alive per round', 'Nodes dead per round' }, ...
        'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 11 ,'Position', [0.45, 0.4, 0.55, 0.2]);

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Algorithm panel%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

algorithm_panel = uipanel('Parent', main_window, 'Units', 'Normalized', ...
        'Position', [0.25, 0.01, 0.5, 0.20], 'Title', 'Algorithm parameters:', 'Visible', 'on','FontWeight', 'bold' , 'FontSize' , 12);
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
    

energy_node_str = uicontrol('Parent', algorithm_panel, 'Style', 'text', 'String', 'Node energy(J)', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 9,'Position', [0.0, 0.8, 0.2, 0.12], 'Visible', 'on');
energy_node_edit = uicontrol('Parent', algorithm_panel,'Style', 'edit', 'String', '2', 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 10,'Position', [0.2, 0.8, 0.15, 0.15], 'Visible', 'on');  
msg_body_size_str = uicontrol('Parent', algorithm_panel, 'Style', 'text', 'String', 'Msg body(Bytes)', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 9,'Position', [0.0, 0.6, 0.2, 0.12], 'Visible', 'on');
msg_body_size_edit = uicontrol('Parent', algorithm_panel,'Style', 'edit','String', '250', 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 10,'Position', [0.2, 0.6, 0.15, 0.15], 'Visible', 'on');  
msg_header_size_str = uicontrol('Parent', algorithm_panel, 'Style', 'text', 'String', 'Msg header(Bytes)', 'Units', 'Normalized', ...
        'FontWeight', 'bold' ,'FontSize' , 9,'Position', [0.0, 0.4, 0.2, 0.12], 'Visible', 'on');
msg_header_size_edit = uicontrol('Parent', algorithm_panel,'Style', 'edit', 'String', '43', 'Units', 'Normalized', ...
        'FontAngle','italic','FontSize' , 10,'Position', [0.2, 0.4, 0.15, 0.15], 'Visible', 'on');         
  
uicontrol('Parent', algorithm_panel, 'Style', 'pushbutton', 'String', 'Reset statistics', 'Units', 'Normalized', ...
        'Position', [0.1, 0.0, 0.5, 0.2], 'FontWeight', 'bold' ,'FontSize' , 10, 'Callback', @reset_stats);

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Init%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
area_x = str2double(get(area_size_x_edit, 'String'));
area_y = str2double(get(area_size_y_edit, 'String'));    
ax1 = axes('Units', 'Normalized', 'Position', [0.05, 0.25, 0.9, 0.70]);
%xlim([0 area_x]);
%ylim([0 area_y]);
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
handler_base = plot(ax1, bs_x, bs_y, 'bs',...
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

nodes = zeros(n_nodes, 9); %x, y, id, cluster-id, status, energy = 2j or 0.5j, energy_consumption,role (1 = ch, 0 = simple node), label
for nd = 1:n_nodes
    
    nodes(nd,1) = rand(1,1)*area_x;	
    nodes(nd,2) = rand(1,1)*area_y;
    nodes(nd,3) = nd;
    nodes(nd,4) = 0;
    nodes(nd,5) = 1;
    nodes(nd,6) = init_energy;
end

hold(ax1, 'on');
handler_nodes = scatter(ax1, nodes(:,1), nodes(:,2), 'ko' , 'filled');
hold(ax1, 'off');

movegui(main_window, 'center');
set(main_window, 'Visible', 'on');
full_filename = [];
filename_for_saving = [];

total_energy = zeros(n_rounds,1);
total_energy_per_round = zeros(n_rounds,1);
node_energy_per_round = zeros(n_nodes, n_rounds);
nodes_alive = zeros(n_rounds,1);
nodes_dead = zeros(n_rounds,1);
handler_text = [];
handler_lines = [];
handler_nodes = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

    function set_bs(src, event)
        bs_x = str2double(get(base_station_x_edit, 'String'));
        bs_y =  str2double(get(base_station_y_edit, 'String'));
        handler_base(1).XData = bs_x;
        handler_base(1).YData = bs_y;
    end

    function set_area(src, event)
        area_x = str2double(get(area_size_x_edit, 'String'));
        area_y = str2double(get(area_size_y_edit, 'String'));    
        %xlim([0 area_x]);
        %ylim([0 area_y]);
    end

   function generate_nodes(src, event)
        hold(ax1, 'on');
        cla;
        n_nodes = str2double(get(num_of_nodes_edit, 'String'));
        nodes = zeros(n_nodes, 9);
        for i = 1:n_nodes
            nodes(i,1) = rand(1,1)*area_x;	
            nodes(i,2) = rand(1,1)*area_y;
            nodes(i,3) = i;
            nodes(i,4) = 0;
            nodes(i,5) = 1;
            nodes(i,6) = init_energy;
        end
        s_method = get(placement_method, 'String');
        s_value = get(placement_method, 'Value');
        %'Random', 'Square', 'Triangular', 'Hexagon', 'Tri-hexagon'
        switch s_method{s_value}
            case 'Random'
                for i = 1:n_nodes
                    nodes(i,1) = rand(1,1)*area_x;	
                    nodes(i,2) = rand(1,1)*area_y;
                end
            case 'Square'
                sz = max(area_x, area_y);
                gr = ceil((sqrt(n_nodes)));
                grid_sz = sz / gr;
                count_x = 1;
                count_y = 1;
                for i = 1:n_nodes
                    if(mod(i, gr) == 0)
                        nodes(i,1) = count_x * grid_sz;
                        nodes(i,2) = count_y * grid_sz;
                        count_y = count_y + 1;
                        count_x = 1;     
                    else
                        nodes(i,1) = count_x * grid_sz;
                        nodes(i,2) = count_y * grid_sz;
                        count_x = count_x + 1;
                    end
                end
            case 'Triangular'
                sz = max(area_x, area_y);
                gr = ceil((sqrt(n_nodes)));
                grid_sz = sz / gr;
                count_x = 1;
                count_y = 1;
                tri = 0;
                for i = 1:n_nodes 
                    if(tri == 1)     
                        nodes(i,1) = count_x * grid_sz + 0.5 * grid_sz;
                        nodes(i,2) = count_y * grid_sz;
                        count_x = count_x + 1;
                        if(mod(count_x, gr - 1) == 0) 
                            tri = 0;
                            count_y = count_y + 1;
                            count_x = 1;
                        end                        
                    elseif(tri == 0)
                        nodes(i,1) = count_x * grid_sz;
                        nodes(i,2) = count_y * grid_sz;
                        count_x = count_x + 1;
                        if(mod(count_x, gr) == 0) 
                            tri = 1;
                            count_y = count_y + 1;
                            count_x = 1;
                        end
                    end
                          
                end
            case 'Hexagon'
                sz = max(area_x, area_y);
                gr = ceil((sqrt(n_nodes)));
                grid_sz = sz / gr;
                count_x = 1;
                count_y = 1;
                hex = 0;
                tri = 0;
                for i = 1:n_nodes  
                    if(hex == 1)     
                        if(tri == 0)     
                            nodes(i,1) = count_x * grid_sz - 0.5 * grid_sz;
                            nodes(i,2) = count_y * grid_sz;
                            count_x = count_x + 1;
                            if(mod(count_x, gr + 1) == 0) 
                                tri = 1;
                                count_y = count_y + 1;
                                count_x = 1;
                            end                        
                        elseif(tri == 1)
                            nodes(i,1) = count_x * grid_sz;
                            nodes(i,2) = count_y * grid_sz;
                            count_x = count_x + 1;
                            if(mod(count_x, gr) == 0) 
                                tri = 0;
                                count_y = count_y + 1;
                                count_x = 1;
                                hex = 0;
                            end
                       end               
                    elseif(hex == 0)
                        if(tri == 1)     
                            nodes(i,1) = count_x * grid_sz - 0.5 * grid_sz;
                            nodes(i,2) = count_y * grid_sz;
                            count_x = count_x + 1;
                            if(mod(count_x, gr + 1) == 0) 
                                tri = 0;
                                count_y = count_y + 1;
                                count_x = 1;
                                hex = 1;
                            end                        
                        elseif(tri == 0)
                            nodes(i,1) = count_x * grid_sz;
                            nodes(i,2) = count_y * grid_sz;
                            count_x = count_x + 1;
                            if(mod(count_x, gr) == 0) 
                                tri = 1;
                                count_y = count_y + 1;
                                count_x = 1;
                            end
                       end 
                    end
                end
            case 'Tri-hexagon'
                sz = max(area_x, area_y);
                gr = ceil((sqrt(n_nodes)));
                grid_sz = sz / gr;
                count_x = 1;
                count_y = 1;
                trihex = 1;
                magnifier = 0.5;
                for i = 1:n_nodes
                    if(trihex == 1)
                        nodes(i,1) = count_x * grid_sz;
                        nodes(i,2) = count_y * grid_sz;
                        count_x = count_x + 1;
                        if(mod(count_x, gr) == 0) 
                            trihex = 2;
                            count_y = count_y + 1;
                            count_x = 1;
                            magnifier = 0.5;
                        end             
                    elseif(trihex == 2)
                        if(count_x == 1)
                            nodes(i,1) = count_x * grid_sz - grid_sz * magnifier;
                           
                        else
                            nodes(i,1) = count_x * grid_sz + grid_sz * magnifier;
                             magnifier = magnifier + 1;
                        end  
                        nodes(i,2) = count_y * grid_sz;
                        count_x = count_x + 1;
                        if(mod(count_x, gr - floor((gr/2 - 1))) == 0) 
                            trihex = 3;
                            count_y = count_y + 1;
                            count_x = 1;                           
                        end 
                    elseif(trihex == 3)
                        nodes(i,1) = count_x * grid_sz;
                        nodes(i,2) = count_y * grid_sz;
                        count_x = count_x + 1;
                        if(mod(count_x, gr) == 0) 
                            trihex = 4;
                            count_y = count_y + 1;
                            count_x = 1;
                            magnifier = 0.5;
                        end 
                    elseif(trihex == 4)
                        if(count_x == 1)
                            nodes(i,1) = count_x * grid_sz + grid_sz * magnifier;
                            magnifier = magnifier + 1;
                        else
                            nodes(i,1) = count_x * grid_sz + grid_sz * magnifier;
                            magnifier = magnifier + 1;
                        end
                        nodes(i,2) = count_y * grid_sz;
                        count_x = count_x + 1;
                        if(mod(count_x, floor(gr/2) + 1) == 0) 
                            trihex = 1;
                            count_y = count_y + 1;
                            count_x = 1;
                        end 
                    end
                end
        end
   
        handler_base = plot(ax1, bs_x, bs_y, 'bs',...
            'LineWidth',2,...
            'MarkerSize',15,...
            'MarkerEdgeColor','b',...
            'MarkerFaceColor', 'b');    
        handler_nodes = scatter(ax1, nodes(:,1), nodes(:,2), 'ko' , 'filled');
        hold(ax1, 'off');
    end



    function open_file(src, event)
        cla(ax1,'reset');
        [filename, pathname] = uigetfile('*.*');
        full_filename = [pathname filename];
        [pathstr, filename_for_saving, ext] = fileparts(full_filename);
        
        tmp = load(full_filename);
        disp(tmp);
        n_nodes = size(tmp,1);
        disp(n_nodes);
        nodes = zeros(n_nodes, 9);
        nodes(:,1:2) = tmp(:,1:2);
        disp(nodes);
        switch ext
            case ".mat"
                nodes = tmp.D; %specify matrix name that being loaded from file 
        end
        
        num_of_nodes_edit.String =  num2str(n_nodes);
        
        area_x = round(max(nodes(:,1)), -1);
        area_y = round(max(nodes(:,2)), -1);
        area_size_x_edit.String = num2str(area_x);
        area_size_y_edit.String = num2str(area_y);
        
        bs_x = area_x/2;
        bs_y = area_y/2;
        base_station_x_edit.String = num2str(bs_x);
        base_station_y_edit.String = num2str(bs_y);
        
        grid(ax1, 'on');
        %axis square;
        title(ax1, 'Network','FontWeight','bold');
        ylabel('Y (m)','FontSize',10, 'FontWeight', 'bold');
        xlabel('X (m)','FontSize',10, 'FontWeight', 'bold');
        tb1 = axtoolbar(ax1,'default');
        tb1.Visible = 'on'; 
        xticklabels('auto');
   
        hold(ax1, 'on');
        cla; 
        handler_base = plot(ax1, bs_x, bs_y, 'bs',...
            'LineWidth',2,...
            'MarkerSize',15,...
            'MarkerEdgeColor','b',...
            'MarkerFaceColor', 'b');  
        handler_nodes = scatter(ax1, nodes(:,1), nodes(:,2), 'ko' , 'filled');
        hold(ax1, 'off');
        for i = 1:n_nodes
            nodes(i,3) = i;
            nodes(i,4) = 0;
            nodes(i,5) = 1;
            nodes(i,6) = init_energy;
        end
        
    end
    
    function fn = get_filename_for_saving()
        current_date = date;
  
        %fn = strcat(filename_for_saving,'_',method{value},'_params:',number_of_clusters,'_date:',current_date);
         fn = strcat('DT','_date_',current_date);
    end

    function save_file(src, event)
        
        items = get(file_save_method,'String');
        index_selected = get(file_save_method,'Value');
        save_selected = items{index_selected};
        fileName = get_filename_for_saving();
        folder = pwd;
        switch save_selected
            case 'Text (.txt)'
                fileName = strcat(fileName, '.txt');
                dlmwrite(fullfile(folder, fileName), nodes(:,1:2), 'delimiter', ' ');
            otherwise
                fileName = strcat(fileName, '.mat');
                D = nodes(:,1:2);
                save(fileName, 'D');
        end
        
        msgbox({'Your file was saved:'; fileName}, 'Success');
       
    end

    function save_graph(src, event)
        
        folder = pwd;
        graphName = get_filename_for_saving();
        fig = main_window;
        fig.InvertHardcopy = 'off';
        graphName = fullfile(folder, graphName);
        print(graphName,'-dpng','-noui');
        
        msgbox({'Your graph was saved:'; graphName}, 'Success');
    end
 
    function calculate_energy(round)
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
        %5 - status, 6 - energy = 2j or 0.5j, 7 - energy_consumption
        msg = 10 * 8; % 5 || 8
        
        %%%%%%%%%%%%% check for Cluster status%%%%%%%%%%%%%%%%
        
        
        for i = 1:n_nodes
            if(nodes(i,5) == 0) 
                continue;
            else
                n_x = nodes(i, 1);
                n_y = nodes(i, 2);   
                Etx = 0;
                Erx = 0;
                Etotal = 0;
                d = ((n_x - bs_x)^2 + (n_y - bs_y)^2)^0.5;
                if(d0 > d)
                       Etx = (msg + msg_header_size)*(Eelec) + (msg + msg_header_size)*Efs*d^2;
                elseif(d0 < d)
                       Etx = (msg + msg_header_size)*(Eelec) + (msg + msg_header_size)*Emp*d^4;
                end                   
                Etotal = Etx;
                %handler_text = [handler_text, text(cluster(j,1) + area_x/100, cluster(j,2), num2str(Etotal),'Color', 'k','FontSize', 10)];
                total_energy_per_round(round) = total_energy_per_round(round) + Etotal;
                node_energy_per_round(i, round) = Etotal;
                nodes(i, 6) = nodes(i, 6) - Etotal;
                nodes(i, 7) = nodes(i, 7) + Etotal;          
            end
        end    
    end

    function check_node_status()
        nodes(nodes(:,6) <= 0, 5) = 0;
        hold(ax1, 'on');   
            handler_nodes = [handler_nodes, plot(ax1, nodes(nodes(:,5) == 0, 1), nodes(nodes(:,5) == 0 , 2), 'kx', 'LineWidth', 2, 'MarkerSize',12, 'MarkerEdgeColor','k','MarkerFaceColor', 'k')];
        hold(ax1, 'off');
    end

    function simulate(src, event)
%       Initialization step:
% Create static clusters based on node information (clustering techniques)
% Assign nodes to clusters
% Maybe to create cluster in balanced way, equal number of nodes
% Select cluster heads (indicate them)
% Find shortest paths for centroids?
% 		Simulation run:
% Select cluster head in cluster based on: closest distance? Or node cluster id order? (indicate them), check if its alive
% Calculate energy for nodes to cluster head, draw lines check if they alive
% Add to total energy etc.
% Calculate shortest path from cluster heads to base, draw lines
% Add to total energy etc.
% Msg is 4+6 (data + mac) from nodes or 4 + 1||4 (data + node id)
% Aggregated data is msg*n <= 250 bytes, EDA energy consumption
% Next CH has to send own data + received data, Etx*n transmits
% Next round

        n_rounds = str2double(get(num_of_rounds_edit, 'String'));      
        reset_stats();
        network_alive = 1;
        for round=1:n_rounds
            if(network_alive == 1)
                num_of_rounds_edit.String =  num2str(n_rounds - round);
                delete(handler_lines);
                delete(handler_text);   
                calculate_energy(round);
                draw_lines();
                check_node_status();
                total_energy(round) = sum(total_energy_per_round); 
                total_enerdy_edit.String = num2str(sum(total_energy));
                %disp(total_energy_per_round);
                %disp(node_energy_per_round);
                %disp(total_energy);
                nodes_alive_edit.String = num2str(size(nodes(nodes(:,5) == 1,1),1));
                nodes_dead_edit.String = num2str(size(nodes(nodes(:,5) == 0,1), 1));
                if(sum(nodes(:,5)) == 0)
                    network_alive = 0;
                end
                pause(2);
            else
                break;
            end;
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%DRAWING%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function draw_lines()
         hold(ax1, 'on');         
         for i = 1:n_nodes
             n_x = nodes(i, 1);
             n_y = nodes(i, 2);
             if(nodes(i,5) == 1)
                handler_lines = [handler_lines, plot([n_x, bs_x], [n_y, bs_y], '-.b')];
             end
         end      
         hold(ax1, 'off');
    end
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%STATISTICS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     function reset_stats(src, event)
        init_energy = str2double(get(energy_node_edit, 'String'));%2 or 0.5
        nodes(:,5) = 1;
        nodes(:,6) = init_energy;
        nodes(:,7) = 0;
        nodes(:,8) = 0;
        total_energy = zeros(n_rounds,1);
        total_energy_per_round = zeros(n_rounds,1);
        node_energy_per_round = zeros(n_nodes, n_rounds);    
        num_of_rounds_edit.String =  num2str(n_rounds);
        total_enerdy_edit.String = num2str(sum(total_energy));      
        nodes_alive_edit.String = num2str(size(nodes(nodes(:,5) == 1,1),1));
        nodes_dead_edit.String = num2str(size(nodes(nodes(:,5) == 0,1), 1)); 
        nodes_alive = zeros(n_rounds,1);
        nodes_alive(:,1) = n_nodes;
        nodes_dead = zeros(n_rounds,1);
     end

    function save_stat(src, event)
    %'Total energy consumption','Energy consumption per round', 
    %'Node energy consumption per round', 'Average node energy consumption', 'Cluster energy consumption per round'
    %'Total energy consumption per cluster', 'Nodes alive per round', 'Nodes dead per round'
    %Have to save respective table
        save_selected = get(stat_save_method, 'String');
        value = get(stat_save_method, 'Value');
        f_new = figure('Visible', 'on');
        f_new.InvertHardcopy = 'off';
        name = save_selected{value};
        switch name
            case 'Total energy consumption'
                ax_new = plot(1:n_rounds, total_energy(:,1), 'Linewidth', 2);
                hold on;
                title(name);
                xlabel 'Round';
                ylabel 'Total Energy(J)';
                %%Table saving template%%
                fileName = get_filename_for_saving();
                folder = pwd;
                fileName = strcat(name, '_', fileName, '.txt');
                dlmwrite(fullfile(folder, fileName), total_energy, 'delimiter', ' ');
                %%%%%%%%%%%%%%%%%%%%%%%%%
            case 'Energy consumption per round'  
                ax_new = plot(1:n_rounds, total_energy_per_round(:,1), 'Linewidth', 2);
                hold on;
                title(name);
                xlabel 'Round';
                ylabel 'Energy(J)';
                %%Table saving template%%
                fileName = get_filename_for_saving();
                folder = pwd;
                fileName = strcat(name, '_', fileName, '.txt');
                dlmwrite(fullfile(folder, fileName), total_energy_per_round, 'delimiter', ' ');
                %%%%%%%%%%%%%%%%%%%%%%%%%
            case 'Node energy consumption per round'
                ax_new = plot(1:n_rounds, node_energy_per_round, 'Linewidth', 2);
                hold on;
                l(:,1) = [1:n_nodes];
                l = arrayfun(@num2str, l, 'UniformOutput', false); 
                legend(l);
                title(name);
                xlabel 'Node ID';
                ylabel 'Energy(J)';
                %%Table saving template%%
                fileName = get_filename_for_saving();
                folder = pwd;
                fileName = strcat(name, '_', fileName, '.txt');
                dlmwrite(fullfile(folder, fileName), node_energy_per_round, 'delimiter', ' ');
                %%%%%%%%%%%%%%%%%%%%%%%%%
            case 'Average node energy consumption'
                ax_new = plot(1:n_rounds, total_energy_per_round(:,1)/n_nodes, 'Linewidth', 2);
                hold on;
                title(name);
                xlabel 'Rounds';
                ylabel 'Energy(J)';
                %%Table saving template%%
                fileName = get_filename_for_saving();
                folder = pwd;
                fileName = strcat(name, '_', fileName, '.txt');
                dlmwrite(fullfile(folder, fileName), total_energy_per_round/n_nodes, 'delimiter', ' ');
            %%%%%%%%%%%%%%%%%%%%%%%%%
            
            case 'Nodes alive per round'
                
            case 'Nodes dead per round'
                
            end
         
    end


end
