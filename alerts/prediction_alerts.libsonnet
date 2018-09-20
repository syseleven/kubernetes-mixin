{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'kubernetes-predictions',
        rules: [
          {
            alert: 'KubePersistentVolumeFullInFourDays',
            expr: |||
              (
                kubelet_volume_stats_used_bytes{%(prefixedNamespaceSelector)s%(kubeletSelector)s}
                  /
                kubelet_volume_stats_capacity_bytes{%(prefixedNamespaceSelector)s%(kubeletSelector)s}
              ) > 0.85
              and
              predict_linear(kubelet_volume_stats_available_bytes{%(prefixedNamespaceSelector)s%(kubeletSelector)s}[%(predictionSampleTime)s], 4 * 24 * 3600) < 0
            ||| % $._config,
            'for': '3h',
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Based on recent sampling, the PersistentVolume claimed by {{ $labels.persistentvolumeclaim }} in Namespace {{ $labels.namespace }} is expected to fill up within four days. Currently {{ $value }}% are in use.',
            },
          },

          {
            alert: 'ClusterCPUInsufficentInFourDays',
            expr: |||
              :node_cpu_utilization:avg1m * 100
                and
              predict_linear(:node_cpu_utilisation:avg1m[%(predictionSampleTime)s]), 4 * 24 * 3600) * 100
                > 100
            ||| % $._config,
            'for': '3h',
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Based on recent sampling the CPUs of the cluster are expected to be fully utilised within four days. Currently {{ $value }}% are in use.',
            },
          },
          {
            alert: 'ClusterMemoryInsufficentInFourDays',
            expr: |||
              :node_memory_utilisation: * 100
                and
              predict_linear(:node_memory_utilisation:[%(predictionSampleTime)s]), 4 * 24 * 3600) * 100
                > 100
            ||| % $._config,
            'for': '3h',
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Based on recent sampling the memory of the cluster is expected to be fully utilised within four days. Currently {{ $value }}% is in use.',
            },
          },
        ],
      },
    ],
  },
}
