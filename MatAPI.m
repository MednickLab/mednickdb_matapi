classdef MatAPI
    properties
        server_address
        %Requires JSONlab toolbox
    end
    methods
        function obj = MatAPI(server_address)
            obj.server_address = server_address;
            if exist('loadjson') ~= 2
                error('This API requires JSONLab toolbox, please install [https://www.mathworks.com/matlabcentral/fileexchange/33381-jsonlab--a-toolbox-to-encode-decode-json-files]')
            end
            
        end
        
        function output_args = extract_args(~, struct_obj, only_extract, default_args)
            if ~exist('args','var')
                only_extract = fieldnames(struct_obj);
            end
            output_args = {};
            fnames = fieldnames(struct_obj);
            for f = 1:length(fnames)
                if any(strcmp(fnames{f}, only_extract))
                    output_args = [output_args fnames{f} struct_obj.(fnames{f})];
                end
            end
            
            if exist('default_args','var')
                vargs = reshape(default_args,2,[]);
                keys = vargs(1,:);
                vals = vargs(2,:);
                for k = 1:length(keys)
                    if all(~strcmp(key{k},'default_args'))
                        output_args = [output_args key{k} vals{k}];
                    end
                end
            end
        end
        
        function url = append_specifiers(~, vargin)
            vargs = reshape(vargin,2,[]);
            keys = vargs(1,:);
            vals = vargs(2,:);
            
            url = '';
            
            studyid = vals{strcmp('studyid',keys)};
            if exists('studyid','var')
                url = [url '&study=' studyid];
            end
            
            versionid = vals{strcmp('versionid',keys)};
            if exists('versionid','var')
                url = [url '&versionid=' versionid];
            end
            
            subjectid = vals{strcmp('subjectid',keys)};
            if exists('subjectid','var')
                url = [url '&subjectid=' subjectid];
            end
            
            visitid = vals{strcmp('visitid',keys)};
            if exists('visitid','var')
                url = [url '&visit=' visitid];
            end
            
            sessionid = vals{strcmp('sessionid',keys)};
            if exists('sessionid','var')
                url = [url '&session=' sessionid];
            end
            
            filetype = vals{strcmp('filetype',keys)};
            if exists('filetype','var')
                url = [url '&filetype=' doctype];
            end
        end
        
        function ids = get_file_ids(obj, vargin)
            url = [obj.server_address '/Files?' obj.append_specifiers(vargin)];
            ids = loadjson(webread(url));
        end
            
        function ids = get_deleted_file_ids(obj, vargin)
            url = [obj.server_address '/DeletedFiles?' obj.append_specifiers(vargin)];
            ids = loadjson(webread(url));
        end
        
        function ids = download_file(obj, id)
            url = [obj.server_address '/DownloadFile?id=' num2str(id)];
            ids = loadjson(webread(url));
        end
            
        function file_info = get_file_info(obj, id)
            url = [obj.server_address '/FileInfo?id=' num2str(id)];
            file_info = loadjson(webread(url));   
        end
            
        function id = upload_file(obj, data, filename, fileformat, vargin)
            url = [obj.server_address '/FileUpload?FileData=' 
                savejson('',data,filename)
                '&FileName=' filename
                '&FileFormat=' fileformat   
                obj.append_specifiers(vargin)];
            id = loadjson(webread(url));   
        end
        
        function update_file_info(obj, id, fileinfo)
            url = [obj.server_address '/FileUpload?FileData=' id
                '&FileInfo=' fileinfo];
            webread(url);   
        end
        
        function upload_data(obj, data, fid, vargin)
            %TODO. This will need to parse tabular and the like. Only works for structs for now
            specifiers = ['studyid','versionid','subjectid','visitid','sessionid','filetype'];
            specs_to_append = obj.append_specifiers(data, specifiers, vargin);
            url = [obj.server_address '/DataUpload?FileData=' 
                savejson('',data,filename)
                '&id=' fid
                '&FileName=' filename
                '&FileFormat=' fileformat   
                specs_to_append];
            webread(url);   
        end
            
        function data = get_data(obj, vargin)
            url = [obj.server_address '/Data?' obj.append_specifiers(vargin)];
            data = loadjson(webread(url));
        end


        function data = get_deleted_data(obj, vargin)
            url = [obj.server_address '/DeletedData?' obj.append_specifiers(vargin)];
            data = loadjson(webread(url));
        end


        function get_data_associated_with_file(obj, id)
            url = [obj.server_address '/FileData?id=' id];
            data = loadjson(webread(url));
        end


        function filetypes = get_filetypes(obj, vargin)
            url = [obj.server_address '/FileTypes?' obj.append_specifiers(vargin)];
            filetypes = loadjson(webread(url));
        end

        function sessionids = get_sessionids(obj, vargin)
            url = [obj.server_address '/Sessionids?' obj.append_specifiers(vargin)];
            sessionids = loadjson(webread(url));
        end

        function studyids = get_studyids(obj, store)
            url = [obj.server_address '/Studyids?' obj.append_specifiers(vargin)];
            studyids = loadjson(webread(url));
        end
        
        function visitids = get_visitids(obj, store, vargin)
            url = [obj.server_address '/Visitids?' obj.append_specifiers(vargin)];
            visitids = loadjson(webread(url));
        end
        
        function versionids = get_versionids(obj, store, vargin)
            url = [obj.server_address '/Versionids?' obj.append_specifiers(vargin)];
            versionids = loadjson(webread(url));
        end
            
        function update_parsed_status(obj, id, status)
            url = [obj.server_address '/UpdateParsedStatus?id=' id '&status=' status];
            webread(url);
        end

        function fids = get_unparsed_files(obj)
            url = [obj.server_address '/UnparsedFiles?'];
            fids = loadjson(webread(url));
        end

        function fids = search_filestore(obj, query_string)
            url = [obj.server_address '/QueryFile?query=' query_string];
            fids = loadjson(webread(url));
        end

        function data = search_datastore(obj, query_string)
            url = [obj.server_address '/QueryData?query=' query_string];
            data = loadjson(webread(url));
        end
        
    end
end

