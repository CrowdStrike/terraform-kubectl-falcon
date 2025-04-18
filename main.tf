module "falcon_operator" {
  source = "./modules/operator"
  count = var.platform == "kubernetes" ? 1 : 0

  client_id                          = var.client_id
  client_secret                      = var.client_secret
  cloud                              = var.cloud
  sensor_type                        = var.sensor_type
  environment                        = var.environment
  falcon_admission                   = var.falcon_admission
  iar                                = var.iar
  operator_version                   = var.operator_version
  node_sensor_mode                   = var.node_sensor_mode
  node_sensor_manifest_path          = var.node_manifest_path
  container_sensor_manifest_path     = var.container_sensor_manifest_path
  admission_controller_manifest_path = var.admission_controller_manifest_path
  iar_manifest_path                  = var.iar_manifest_path
  cleanup                            = var.cleanup
}

module "falcon_operator_openshift" {
  source = "./modules/operator-openshift"
  count = var.platform == "openshift" ? 1 : 0

  client_id                          = var.client_id
  client_secret                      = var.client_secret
  cloud                              = var.cloud
  environment                        = var.environment
  falcon_admission                   = var.falcon_admission
  iar                                = var.iar
  node_sensor_mode                   = var.node_sensor_mode
  node_sensor_manifest_path          = var.node_manifest_path
  admission_controller_manifest_path = var.admission_controller_manifest_path
  iar_manifest_path                  = var.iar_manifest_path
  cleanup                            = var.cleanup
}

module "falcon_kpa" {
  source = "./modules/k8s-protection-agent"
  count = var.kpa ? 1 : 0

  client_id        = var.client_id
  client_secret    = var.client_secret
  docker_api_token = var.docker_api_token
  cid              = var.cid
  cloud            = var.cloud
  cluster_name     = var.cluster_name
}
