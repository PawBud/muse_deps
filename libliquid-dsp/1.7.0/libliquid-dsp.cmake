function(liquid_Populate remote_url local_path OS ARCH BUILD_TYPE)
    set(src_dir ${local_path}/src)
    set(build_dir ${local_path}/build)
    set(install_dir ${local_path}/install)

    if(NOT EXISTS ${src_dir})
        execute_process(COMMAND git clone --branch v1.7.0 https://github.com/jgaeddert/liquid-dsp.git ${src_dir})
    endif()

    execute_process(COMMAND ${CMAKE_COMMAND}
            -S ${src_dir}
            -B ${build_dir}
            -DCMAKE_INSTALL_PREFIX=${install_dir}
            -DCMAKE_BUILD_TYPE=${BUILD_TYPE}
    )

    execute_process(COMMAND ${CMAKE_COMMAND} --build ${build_dir} --target install)

    set_property(GLOBAL PROPERTY libliquid-dsp_INCLUDE_DIRS ${install_dir}/include)
    set_property(GLOBAL PROPERTY libliquid-dsp_LIBRARIES ${install_dir}/lib/libliquid.a)
    set_property(GLOBAL PROPERTY libliquid-dsp_INSTALL_LIBRARIES ${install_dir}/lib/libliquid.a)

    # Not using libliquid-dsp::libliquid-dsp
    if(NOT TARGET Liquid::liquid)
        add_library(Liquid::liquid INTERFACE IMPORTED GLOBAL)
        target_include_directories(Liquid::liquid INTERFACE ${install_dir}/include)
        target_link_libraries(Liquid::liquid INTERFACE ${install_dir}/lib/libliquid.a)
    endif()
endfunction()