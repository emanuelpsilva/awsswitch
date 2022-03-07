#!/bin/bash

# Instructions:
#   1 - Copy this script into executable path: sudo cp awsswitch.sh /usr/local/bin/
#   2 - Give execute permissions: sudo chmod +x /usr/local/bin/awsswitch.sh
#   3 - Create alias: alias aws=awsswitch.sh (also add this line into your shell profile, ~/.zprofile or ~/.bash_profile or ~/.profile, etc)
#   4 - Run config: aws (follow instructions)
#   5 - To run in an interactive shell: aws s3 ls
#   6 - To run inside a script: /usr/local/bin/awsswitch.sh s3 ls

# 2022-01-20 1.0.0 ESilva - First version
# 2022-03-07 1.1.0 ESilva - Support for '--' argument that allows a wrapper to run any command (i.e.: aws -- terraform import aws_iam_role.my-role <aws arn>)

IGNORE_PROFILES="common default" # these profile names will not be shown in menu options

CONFIG_FILE="${HOME}/.awsswitch" # this is where the chosen profile name will be saved

get_current_profile()
{
    local CURRENT_PROFILE=""

    if [ -f ${CONFIG_FILE} ]; then
        CURRENT_PROFILE=$(cat ${CONFIG_FILE} | cut -d'=' -f2) # extract current profile from config file
    fi
    echo "${CURRENT_PROFILE}"
}

run_config()
{
    local PROFILES=$(aws-vault list --profiles | grep "\S")
    local CURRENT_PROFILE="$(get_current_profile)"
    local OPTIONS=""
    local OPT=""

    # remove IGNORE profiles from list
    for OPT in ${IGNORE_PROFILES}
    do
        PROFILES=$(echo $PROFILES | sed "s/${OPT}//g")
    done

    if [ -n "${CURRENT_PROFILE}" ]; then
        echo "Your current profile is=[${CURRENT_PROFILE}]"
    else
        echo "Welcome to awsswitch tool. Please select your profile:"
    fi

    PS3="Select AWS profile: "
    OPTIONS=(${PROFILES} "Quit") # add option Quit to list of options
    select OPT in "${OPTIONS[@]}"
    do
        case ${OPT} in
            "Quit")
                echo "Aborted by user, environment not changed!"
                break;;
            *)
                NEW_PROFILE=$(echo ${PROFILES} | cut -d' ' -f${REPLY})
                echo "current_profile=${NEW_PROFILE}" > ${CONFIG_FILE} # save choosed profile into config file
                echo "Changing aws-vault profile to=[${NEW_PROFILE}]..." # intructions to user
                echo "Please add the following command to your shell profile startup file:"
                echo "  alias=awsswitch.sh"
                echo "After the change, please restart your shell terminal"
                echo "Configuration finished successfully"
                break;;
        esac
    done
}

run_exec()
{
    local PROFILE="$(get_current_profile)"

    if [ -z ${PROFILE} ]; then
        run_config # failed to retrieve current profile, run config
    else
        unalias aws 2>/dev/null # avoid endless loop, this unalias only affects this ephemeral shell instance
        if [ "${1}" == "--" ]; then
            aws-vault exec ${PROFILE} ${@} # run aws-vault wrapper for other commands like terraform import
        else
            aws-vault exec ${PROFILE} -- aws ${@} # run aws-vault native command
        fi
    fi
}

# script entry point
if [ $# -eq 0 ]; then
    run_config # run config when calling awsswitch.sh without any parameters
else
    run_exec ${@} # run execution when calling awsswitch.sh with parameters
fi
exit 0
