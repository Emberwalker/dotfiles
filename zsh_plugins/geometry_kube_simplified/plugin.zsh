# Color definitions
GEOMETRY_COLOR_KUBE=${GEOMETRY_COLOR_KUBE:-blue}

# Symbol definitions
GEOMETRY_SYMBOL_KUBE=${GEOMETRY_SYMBOL_KUBE:-"⎈"}
GEOMETRY_KUBE=$(prompt_geometry_colorize $GEOMETRY_COLOR_KUBE $GEOMETRY_SYMBOL_KUBE)

prompt_geometry_kube_simplified_config() {
  GEOMETRY_KUBECTL_CONTEXT="$(kubectl config current-context 2> /dev/null)"
  GEOMETRY_KUBECTL_NAMESPACE="$(kubectl config view -o "jsonpath={.contexts[?(@.name==\"$GEOMETRY_KUBECTL_CONTEXT\")].context.namespace}" 2> /dev/null)"
}

geometry_prompt_kube_simplified_setup() {
    (( $+commands[kubectl] )) || return 1
}

geometry_prompt_kube_simplified_check() {
    (( $+commands[kubectl] )) && test -f ~/.kube/config || return 1
}

geometry_prompt_kube_simplified_render() {
    prompt_geometry_kube_simplified_config

    if [[ -z $GEOMETRY_KUBECTL_NAMESPACE  ]]; then
      GEOMETRY_KUBECTL_NAMESPACE=default
    fi

    echo "$GEOMETRY_KUBE $GEOMETRY_KUBECTL_CONTEXT/$GEOMETRY_KUBECTL_NAMESPACE"
}

geometry_plugin_register kube_simplified

