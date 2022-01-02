#!/bin/bash

# 存放一些shell脚本中常用的方法

ensure_file(){
    file_path=$1 # eg: "~/log"
    file_type=$2 # eg: "folder" or "file"

    # echo file_path: ${file_path}
    # echo file_type: ${file_type}

    # i. 若文件已经存在
    if [ -e ${file_path} ]; then
        if [ -f ${file_path} ]; then
            echo "'${file_path}'已存在, 是一个普通文件"
            if [ ${file_type} == "file" ]; then
                echo "pass"
            elif [ ${file_type} == "folder" ]; then
                echo "把普通文件删除, 将'${file_path}'创建成一个目录"
                rm ${file_path}
                mkdir -p ${file_path}
            fi
        elif [ -d ${file_path} ]; then
            echo "'${file_path}'已存在, 是一个目录"
            if [ ${file_type} == "file" ]; then
                echo "把目录删除, 将'${file_path}'创建成一个普通文件"
                rm -rf ${file_path}
                touch ${file_path}
            elif [ ${file_type} == "folder" ]; then
                echo "pass"
            fi
        fi
    # ii. 若文件不存在
    else
        if [ ${file_type} == "file" ]; then
            echo "'${file_path}'不存在, 将此path创建成一个普通文件"
            touch ${file_path}
        elif [ ${file_type} == "folder" ]; then
            echo "'${file_path}'不存在, 将此path创建成一个目录"
            mkdir -p ${file_path}
        fi
    fi
    echo -e "\n"
}
# # 函数单元测试
# ensure_file ~/ttt/test_sh folder
# ensure_file ~/ttt/test_sh/file1 file
# ensure_file ~/ttt/test_sh/file2 file
# ensure_file ~/ttt/test_sh/folder1 folder
# ensure_file ~/ttt/test_sh/folder2 folder
# echo -e "\n\n"
# ensure_file ~/ttt/test_sh/file1 folder
# ensure_file ~/ttt/test_sh/folder1 file
