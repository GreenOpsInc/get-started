## Argo Workflows Quickstart

This setup process uses the default quickstart installation of Argo Workflows provided in the [main Github repository](https://raw.githubusercontent.com/argoproj/argo-workflows/master/manifests/quick-start-postgres.yaml), with a few minor changes.

To provide a unified, single-interface experience, GreenOps embeds the Argo Workflows UI via iframe. To make this as secure as possible, [a few minor updates were made](https://github.com/GreenOpsInc/argo-workflows/pull/3) to the Argo WF server:
- `frame-ancestors` was added in the `Content-Security-Policy` to ensure that only GreenOps can embed Argo Workflows via iframe.
- The Argo Workflow cookie settings are set to `SameSite=None;Secure`. `Access-Control-Allow-Origin` should also be set to the GreenOps URL. This allows only GreenOps to embed Argo Workflows, while ensuring that other third parties cannot make requests or interact with Argo Workflows.

All the changes made to the Argo Workflows server can be seen [here](https://github.com/GreenOpsInc/argo-workflows/pull/3).

The quickstart YAML file uses the updated Argo Workflows server image and leaves an empty space for the `FRAME_ANCESTOR` in the [environment variables section](https://github.com/GreenOpsInc/greenops-helm-chart/blob/main/argo-workflows/quick-start-postgres.yaml#L1708) and `--access-control-allow-origin` in the [arguments section](https://github.com/GreenOpsInc/greenops-helm-chart/blob/main/argo-workflows/quick-start-postgres.yaml#L1702).
