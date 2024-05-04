configs:
  params:
    server.insecure: "true"
  cm:
    url: https://${ argocd_server_host }
    admin.enabled: "false"
    dex.config: |
      connectors:
        - type: github
          id: github
          name: Github
          config:
            clientID: ${ argocd_github_client_id }
            clientSecret: ${ argocd_github_client_secret }
            orgs:
              - name: ${ argocd_github_org_name }

server:
  ingress:
    enabled: true
    annotations:
      external-dns.alpha.kubernetes.io/hostname: ${ argocd_server_host }
      kubernetes.io/ingress.class: nginx
      networking.gke.io/managed-certificates: argocd-example-cert
    hostname: ${ argocd_server_host }

  serviceAccount:
    annotations:
      eks.amazonaws.com/role-arn: ${ eks_iam_argocd_role_arn }