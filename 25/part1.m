clear all
close all
clc
tic
% Define the filename
filename = "input.txt";

% Initialize variables
cell_array = {};
current_cell = "";
is_new_cell = true;

% Open the file for reading
fid = fopen(filename, 'r');
if fid == -1
    error("Cannot open file %s", filename);
end

% Read the file line by line
while ~feof(fid)
    line = fgetl(fid);

    if isempty(line) && is_new_cell
        % Skip leading blank lines
        continue;
    end

    if isempty(line)
        % Blank line indicates a new cell
        cell_array{end+1} = current_cell;
        current_cell = "";
        is_new_cell = true;
    else
        % Append non-blank lines to the current cell
        if ~isempty(current_cell)
            current_cell = [current_cell; line];
        else
            current_cell = line;
        end
        is_new_cell = false;
    end
end

% Add the last cell if it's not empty
if ~isempty(current_cell)
    cell_array{end+1} = current_cell;
end

% Close the file
fclose(fid);

##% Display the contents of each cell array
##for i = 1:length(cell_array)
##    fprintf("Cell %d:\n", i);
##    disp(cell_array{i});
##    fprintf("\n");
##end


L=1;
K=1;
for i=1:length(cell_array)
  A = cell_array{i};
##  A =
  A = strrep(A,'#','1');
  A = strrep(A,'.','0');
  if A(1,1)=='1'
    locka(:,:,L) = A;
    L=L+1;
  elseif A(end,1)=='1'
    keya(:,:,K) = A;
    K=K+1;
  endif

end


clear A
clear cell_array
clear K
clear L
clear current_cell
clear fid
clear filename
clear i
clear j
clear is_new_cell
clear line

for i=1:size(locka,3)
  for j=1:size(locka,2)
    for k=1:size(locka,1)
      lock(k,j,i) = str2double(locka(k,j,i));
    endfor
  endfor
endfor

for i=1:size(keya,3)
  for j=1:size(keya,2)
    for k=1:size(keya,1)
      key(k,j,i) = str2double(keya(k,j,i));
    endfor
  endfor
endfor
##
##count = 0;
##for i=1:size(key,3)
##  for j=1:size(lock,3)
##    if max(max(key(:,:,i) + lock(:,:,j))) <= 1
##      count = count +1;
##    endif
##    endfor
##  endfor
##toc
clear keya
clear locka

for i=1:size(key,3)
  keys(i,:) = sum(key(:,:,i),1) - 1;
endfor

for i=1:size(lock,3)
  locks(i,:) = sum(lock(:,:,i),1) - 1;
endfor

siz = size(locks,2);
counter=0;

for i=1:size(locks,1)
  for j=1:size(keys,1)
    if max(keys(j,:) + locks(i,:)) <= siz
##      [keys(j,:); locks(i,:)];
      counter = counter +1;
endif
    endfor
  endfor

  toc

