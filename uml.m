% Settings
folder = 'c:/promotion/svn/libDirectional/lib/distributions/';
output = 'outputfilename';

dotExecutable ='"c:\Program Files (x86)\Graphviz2.38\bin\dot.exe"';

% read subfolders and find all potential classes
addpath(genpath(folder));
files = rdir([folder '\**\*.m' ]);

fID = fopen([output '.dot'], 'w');

fprintf(fID, 'digraph G {\n');

% node format
fprintf(fID, ...
['node [\n' ...
'fontname = "Bitstream Vera Sans"\n' ... 
'fontsize = 20\n' ...
'shape = "record"\n' ...
'nodesep = 0.1\n' ... 
'style=filled\n' ...
'fillcolor=gray95\n' ...
']\n' ]);

% create node for each class
for i=1:length(files)
    [~, classname, ~] = fileparts(files(i).name);
    currentclass = meta.class.fromName(classname);
    if ~isempty(currentclass)
        properties = '';
        for j=1:length(currentclass.PropertyList)
            % only add properties defined in this class
            if strcmp(currentclass.PropertyList(j).DefiningClass.Name, classname)
                if strcmp(currentclass.PropertyList(j).GetAccess, 'public') %todo what about SetAccess?
                    properties = [properties '+' currentclass.PropertyList(j).Name '\l'];
                elseif strcmp(currentclass.PropertyList(j).GetAccess, 'private') 
                    properties = [properties '-' currentclass.PropertyList(j).Name '\l'];
                else
                    properties = [properties currentclass.PropertyList(j).Name '\l'];
                end
            end
        end
        methods ='';
        for j=1:length(currentclass.MethodList)
            % only add methods defined in this class, do not include empty
            % method automatically added by MATLAB
            if strcmp(currentclass.MethodList(j).DefiningClass.Name, classname) && ~strcmp(currentclass.MethodList(j).Name, 'empty') 
                if strcmp(currentclass.MethodList(j).Access, 'public')
                    methods = [methods '+' currentclass.MethodList(j).Name '()\l'];
                elseif strcmp(currentclass.MethodList(j).Access, 'private')
                    methods = [methods '-' currentclass.MethodList(j).Name '()\l'];
                else
                    methods = [methods currentclass.MethodList(j).Name '()\l'];                    
                end
            end
        end
        fprintf(fID, '%s [label = "{%s|%s|%s}"]\n', classname, classname, properties, methods);
    end
end

% edge format
fprintf(fID, 'edge [\n arrowtail = "empty" \n]\n');

% create edges for inheritance
for i=1:length(files)
    [~, classname, ~] = fileparts(files(i).name);
    currentclass = meta.class.fromName(classname);
    if ~isempty(currentclass)
        for j=1:length(currentclass.SuperclassList)
            fprintf(fID, '%s -> %s [dir=back]\n',  currentclass.SuperclassList(j).Name, classname);
        end
    end
end

fprintf(fID, '}');
fclose(fID);

system([dotExecutable ' -Tpng ' output '.dot > ' output '.png']);
%system([dotExecutable ' -Tsvg uml.dot > uml.svg']);
%system([dotExecutable ' -Tpdf uml.dot > uml.pdf']);

