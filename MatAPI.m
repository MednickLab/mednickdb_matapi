classdef MatAPI
   properties
      server_address
   end
   methods
      function obj = MatAPI(server_address)
         if nargin > 0
            obj.server_address = server_address;
         end
      end
      
      function data = get_files(obj, studyid, visitid, sessionid, doctype)
          url = [obj.server_address '/Files'];
          if nargin > 1
              url = [url '?study=' studyid];
          end
          if nargin > 2
              url = [url '?visit=' visitid];
          end
          if nargin > 3
              url = [url '?session=' sessionid];
          end
          if nargin > 4
              url = [url '?doctype=' doctype];
          end
          data = webread(url);
      end
      
      function data = get_incomplete_files(obj, studyid, visitid, sessionid, doctype)
          url = [obj.server_address '/TempFiles'];
          if nargin > 1
              url = [url '?study=' studyid];
          end
          if nargin > 2
              url = [url '?visit=' visitid];
          end
          if nargin > 3
              url = [url '?session=' sessionid];
          end
          if nargin > 4
              url = [url '?doctype=' doctype];
          end
          data = webread(url);
      end
      
      function binary_data = download_file(obj, fileid, file_save_path)
          url = [obj.server_address '/DownloadFile'];
          url = [url '?id=' fileid];
          binary_data = webread(url, 'ContentType','binary');
          if exist('file_save_path','var') %FIXME
              fid = fopen(file_save_path);
              fwrite(fid,binary_data);
          end
      end
      
   end
end

