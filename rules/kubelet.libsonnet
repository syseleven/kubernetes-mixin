{
  _config+:: {
    kubeletSelector: 'job="kubelet"',
  },

  prometheusRules+:: {
    groups+: [
      {
        name: 'kubelet.rules',
        rules: [
          {
            record: 'node_quantile:kubelet_pleg_relist_duration_seconds:histogram_quantile',
            expr: |||
              histogram_quantile(%(quantile)s, sum(rate(kubelet_pleg_relist_duration_seconds_bucket[5m])) by (instance, le) * on(instance) group_left(node) kubelet_node_name{%(kubeletSelector)s})
            ||| % ({ quantile: quantile } + $._config),
            labels: {
              quantile: quantile,
            },
          }
          for quantile in ['0.99', '0.9', '0.5']
        ] + [
          {
            record: 'node_type:kube_node_status_capacity_pods_unless_unschedulable:sum',
            expr: |||
              sum by (node_type) (label_replace(kube_node_status_capacity_pods{job="kube-state-metrics"} unless kube_node_spec_unschedulable{job="kube-state-metrics"} == 1, "node_type", "$1", "node", "([^0-9]+)[0-9].*"))
            |||,
          },
          {
            record: 'node_type:kube_pod_info:count',
            expr: |||
              count by (node_type) (label_replace(kube_pod_info{job="kube-state-metrics"}, "node_type", "$1", "node", "([^0-9]+)[0-9].*"))
            |||,
          },
        ],
      },
    ],
  },
}
