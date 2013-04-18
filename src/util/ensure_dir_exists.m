% function [ ] = ensure_dir_exists( dir_string )
% If dir_string does not exist, it is mkdir'd.

function [ ] = ensure_dir_exists( dir_string )
if ~exist(dir_string, 'dir')
    mkdir(dir_string);
end
end

