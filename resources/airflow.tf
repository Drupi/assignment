resource "helm_release" "airflow" {
  name       = "airflow"
  chart      = "airflow"
  repository = "https://airflow.apache.org"
  timeout = 600

  create_namespace = true
  namespace = "airflow"
  force_update = true

  set {
    name  = "webserver.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "webserver.defaultUser.username"
    value = var.airflow_username
  }

    set {
    name  = "webserver.defaultUser.password"
    value = var.airflow_password
  }
  
  set {
    name = "createUserJob.useHelmHooks"
    value = "false"
  }

  set {
    name = "migrateDatabaseJob.useHelmHooks"
    value = "false"
  }
}

output "airflow_access" {
  value = "Please use Login: ${var.airflow_username} and Password: ${var.airflow_password} to access Airflow UI"
}

output "airflow_ip" {
  value = "http://${data.kubernetes_service.airflow-webserver.status.0.load_balancer.0.ingress.0.ip}:8080"
}