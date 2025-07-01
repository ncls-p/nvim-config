-- Cloud-native Monitoring and Observability Tools Configuration

return {
  -- Prometheus configuration detection
  {
    name = "prometheus-config",
    dir = vim.fn.stdpath("config"),
    config = function()
      -- Add Prometheus config patterns
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = {
          "prometheus.yml",
          "prometheus.yaml",
          "*.prometheus.yml",
          "*.prometheus.yaml",
          "alertmanager.yml",
          "alertmanager.yaml",
          "*/prometheus/**/*.yml",
          "*/prometheus/**/*.yaml",
          "*/monitoring/**/*.yml",
          "*/monitoring/**/*.yaml",
        },
        callback = function()
          vim.bo.filetype = "yaml"
          vim.bo.syntax = "yaml"
        end,
      })
    end,
  },

  -- Grafana dashboard JSON support  
  {
    name = "grafana-support",
    dir = vim.fn.stdpath("config"),
    config = function()
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = {
          "*.dashboard.json",
          "*/grafana/**/*.json",
          "*/dashboards/**/*.json",
        },
        callback = function()
          vim.bo.filetype = "json"
          vim.opt_local.formatprg = "jq"
        end,
      })
    end,
  },

  -- OpenTelemetry collector config support
  {
    "towolf/vim-helm",
    config = function()
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = {
          "otel-collector.yml",
          "otel-collector.yaml",
          "otelcol.yml",
          "otelcol.yaml",
          "*/otel/**/*.yml",
          "*/otel/**/*.yaml",
          "*/telemetry/**/*.yml",
          "*/telemetry/**/*.yaml",
        },
        callback = function()
          vim.bo.filetype = "yaml"
          vim.bo.syntax = "yaml"
        end,
      })
    end,
  },

  -- Service mesh configuration (Istio, Linkerd)
  {
    name = "service-mesh-support",
    dir = vim.fn.stdpath("config"),
    config = function()
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = {
          "*/istio/**/*.yml",
          "*/istio/**/*.yaml",
          "*/linkerd/**/*.yml",
          "*/linkerd/**/*.yaml",
          "*/service-mesh/**/*.yml",
          "*/service-mesh/**/*.yaml",
          "*/mesh/**/*.yml",
          "*/mesh/**/*.yaml",
        },
        callback = function()
          vim.bo.filetype = "yaml"
          vim.bo.syntax = "yaml"
        end,
      })
    end,
  },

  -- Additional DevOps config files
  {
    name = "devops-configs",
    dir = vim.fn.stdpath("config"),
    config = function()
      -- Jaeger configuration
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = {
          "jaeger.yml",
          "jaeger.yaml",
          "*/jaeger/**/*.yml",
          "*/jaeger/**/*.yaml",
        },
        callback = function()
          vim.bo.filetype = "yaml"
        end,
      })

      -- Fluentd/Fluent Bit configuration
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = {
          "fluent.conf",
          "td-agent.conf",
          "*/fluent/**/*.conf",
          "fluent-bit.conf",
          "*/fluent-bit/**/*.conf",
        },
        callback = function()
          vim.bo.filetype = "conf"
          vim.opt_local.commentstring = "# %s"
        end,
      })

      -- Elastic Stack configurations
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = {
          "elasticsearch.yml",
          "kibana.yml",
          "logstash.conf",
          "filebeat.yml",
          "metricbeat.yml",
          "*/elastic/**/*.yml",
          "*/elastic/**/*.yaml",
          "*/elk/**/*.yml",
          "*/elk/**/*.yaml",
        },
        callback = function()
          local ext = vim.fn.expand("%:e")
          if ext == "conf" then
            vim.bo.filetype = "conf"
            vim.opt_local.commentstring = "# %s"
          else
            vim.bo.filetype = "yaml"
          end
        end,
      })

      -- Vault configuration
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = {
          "vault.hcl",
          "*/vault/**/*.hcl",
          "*/secrets/**/*.hcl",
        },
        callback = function()
          vim.bo.filetype = "hcl"
          vim.opt_local.commentstring = "# %s"
        end,
      })

      -- Consul configuration
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = {
          "consul.hcl",
          "*/consul/**/*.hcl",
        },
        callback = function()
          vim.bo.filetype = "hcl"
          vim.opt_local.commentstring = "# %s"
        end,
      })

      -- Nomad configuration
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = {
          "*.nomad",
          "*/nomad/**/*.hcl",
        },
        callback = function()
          vim.bo.filetype = "hcl"
          vim.opt_local.commentstring = "# %s"
        end,
      })
    end,
  },
}