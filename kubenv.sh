#!/bin/bash

KUBENV_SUFFIX="${HOME}/.kube/kubenv/"
KUBENV_KUBECONFIG_DEFAULT="${HOME}/.kube/config"

function _kubenv_usage()
{
    echo "kubenv allows to set kubectl context/namespace for current shell session."
    echo "You can also persist changes using 'save' command."
    echo "Remember to 'save' changes if you add new context (i.e. connect to new cluster)."
    echo
    echo "Usage: kubenv (context|ctx)|(namespace|ns)|save|reload [(cur|current)|all|<value-to-set>]"
    echo
    echo "Sub-commands:"
    echo
    echo "context | ctx"
    echo "      - With no argument | all - lists all contexts"
    echo "      - cur | current - lists current context"
    echo "      - any other argument sets context to that value"
    echo
    echo "namespace | ns"
    echo "      - With no argument | all - lists all namespaces"
    echo "      - cur | current - lists current namespaces"
    echo "      - any other argument sets namespace to that value"
    echo
    echo "save"
    echo "      - persists changes to ${KUBENV_KUBECONFIG_DEFAULT}"
    echo
    echo "reload"
    echo "      - reloads kubectl config from ${KUBENV_KUBECONFIG_DEFAULT}"
    echo
}

if [ ! "${0}" != "${BASH_SOURCE[0]}" ]
then
    echo "This script must be sourced. e.g."
    echo "$ . ${0}"
    echo
    _kubenv_usage
    exit 1
fi

mkdir -p "${KUBENV_SUFFIX}" || echo "Failed to create config directory"
KUBENV_CONFIG=$(mktemp "${KUBENV_SUFFIX}kubenv.XXXXXXXXXX")
cp "${KUBENV_KUBECONFIG_DEFAULT}" "${KUBENV_CONFIG}"
export KUBECONFIG="${KUBENV_CONFIG}"

trap "rm ${KUBENV_CONFIG}" EXIT
KUBENV_KUBECTL="kubectl --kubeconfig=${KUBENV_CONFIG}"

function _kubenv_ctx() 
{
    current_context=$(${KUBENV_KUBECTL} config current-context)
    case "${1}" in
        ""|all) 
            for c in $(${KUBENV_KUBECTL} config get-contexts --output=name)
            do
                if [[ "${c}" == "${current_context}" ]]
                then
                    echo "* ${c}"
                else
                    echo "  ${c}"
                fi
            done
            ;;
        cur|current)
            echo "${current_context}"
            ;;
        *)
            ${KUBENV_KUBECTL} config use-context "${1}"
            ;;
    esac
}

function _kubenv_ns() 
{
    current_context=$(${KUBENV_KUBECTL} config current-context)
    current_namespace=$(${KUBENV_KUBECTL} config view --output=jsonpath={.contexts[?(@.name==\"${current_context}\")].context.namespace})
    case "${1}" in
        ""|all) 
            for c in $(${KUBENV_KUBECTL} get namespace --output=jsonpath={range.items[\*]}{.metadata.name}:{end}|tr ':' '\n')
            do
                if [[ "${c}" == "${current_namespace}" ]]
                then
                    echo "* ${c}"
                else
                    echo "  ${c}"
                fi
            done
            ;;
        cur|current)
            echo "${current_namespace}"
            ;;
        *)
            ${KUBENV_KUBECTL} config set-context "${current_context}" --namespace "${1}"
            ;;
    esac
}

function kubenv()
{

    good=1
    if [[ ${#} -gt 0 ]]
    then
        good=0
        case "${1}" in
            context|ctx)
                _kubenv_ctx "${2}"
                ;;
            namespace|ns)
                _kubenv_ns "${2}"
                ;;
            save)
                cp "${KUBENV_KUBECONFIG_DEFAULT}" "${KUBENV_KUBECONFIG_DEFAULT}.bkp"
                cp "${KUBENV_CONFIG}" "${KUBENV_KUBECONFIG_DEFAULT}"
                ;;
            reload)
                cp "${KUBENV_KUBECONFIG_DEFAULT}" "${KUBENV_CONFIG}"
                ;;
            *)
                _kubenv_usage
                ;;
        esac
    fi

    if [[ ${good} != 0 ]]
    then
        _kubenv_usage
    fi
}