# SPDX-FileCopyrightText: 2021 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
#
# SPDX-License-Identifier: BSD-3-Clause

# Find all subprojects (i.e. subdirectories with a CMakeLists.txt) and set
# the variable with the name specified in $result_var with the list of subprojects
function(_liri_internal_find_subprojects result_var filter_items)
    set(subprojects_list "")

    # Find all subprojects (directories with CMakeLists.txt)
    if(NOT "${filter_items}" STREQUAL "")
        set(subprojects_list "${filter_items}")
    else()
        file(GLOB items LIST_DIRECTORIES true RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "*")
        foreach(item IN LISTS items)
            if(IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${item}"
                    AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${item}/CMakeLists.txt")
                list(APPEND subprojects_list "${item}")
            endif()
        endforeach()
    endif()

    message(DEBUG "_liri_internal_find_subprojects: ${subprojects_list}")

    # Collect all subprojects and dependencies
    set(all_subprojects_and_dependencies ${subprojects_list})
    foreach(subproject IN LISTS subprojects_list)
        set(dependencies_var "__liri_subproject_dependencies_${subproject}")
        if(DEFINED ${dependencies_var})
            list(APPEND all_subprojects_and_dependencies ${${dependencies_var}})
        endif()
    endforeach()

    # Remove duplicates
    list(REMOVE_DUPLICATES all_subprojects_and_dependencies)

    # Function to order subprojects based on dependencies
    function(_liri_internal_sort_subprojects subprojects out_var)
        set(ordered "")
        foreach(subproject IN LISTS subprojects)
            # Add subproject to the list if it wasn't already added
            list(FIND ordered "${subproject}" subproject_index)
            if(subproject_index EQUAL -1)
                list(LENGTH ordered subproject_index)
                list(APPEND ordered "${subproject}")
            endif()

            # Scan the dependencies for this subproject
            set(dependencies_list_var_name "__liri_subproject_dependencies_${subproject}")
            foreach(dependency IN LISTS "${dependencies_list_var_name}")
                # Search the dependency and load it if it wasn't already loaded,
                # also make sure it is before the subproject that requires it
                list(FIND ordered "${dependency}" dependency_index)
                if(dependency_index EQUAL -1)
                    list(INSERT ordered ${subproject_index} "${dependency}")
                elseif(dependency_index GREATER subproject_index)
                    list(REMOVE_AT ordered ${dependency_index})
                    list(INSERT ordered ${subproject_index} "${dependency}")
                endif()
            endforeach()
        endforeach()

        message(DEBUG "_liri_internal_sort_subprojects: ${ordered}")

        set(${out_var} "${ordered}" PARENT_SCOPE)
    endfunction()

    # Sort the subprojects based on dependencies
    _liri_internal_sort_subprojects("${all_subprojects_and_dependencies}" ordered_subprojects)

    message(DEBUG "_liri_internal_find_subprojects: Final sorted subprojects: ${ordered_subprojects}")

    set(${result_var} "${ordered_subprojects}" PARENT_SCOPE)
endfunction()
