%Run this file to test the api. It will attempt to connect, upload a file, and then download it
%again and verify the contents
db = MatAPI('http://saclab.ss.uci.edu:8001');
files = db.get_incomplete_files();
tic
for i = 1:length(files)
    db.download_file(files(i).x_id, files(i).fileName);
end
toc