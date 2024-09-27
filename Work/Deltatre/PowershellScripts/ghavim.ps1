gvim readme.md scripts/deploy.sh scripts/Dockerfile terraform/main.tf .dazn-manifest.yml

write-host "Remember to look for that optional alert gubbins too..." -f RED
gvim terraform/modules/newrelic_alert/conviva_responses_400plus/conviva_responses_400plus.tf terraform/modules/newrelic_alert/conviva_latency/conviva_latency.tf terraform/modules/dashboard/dashboard.tf

write-host "And the New Relic to AWS convertibobs" -f RED
gvim terraform\vars.tf terraform\modules\newrelic_alert\conviva_latency\vars.tf
