resource "aws_lambda_layer_version" "sdk_layer" {
  layer_name          = var.sdk_layer_name
  filename            = "../../../layer-wrapper/build/distributions/opentelemetry-java-wrapper.zip"
  compatible_runtimes = ["java8", "java8.al2", "java11"]
  license_info        = "Apache-2.0"
  source_code_hash    = filebase64sha256("../../../layer-wrapper/build/distributions/opentelemetry-java-wrapper.zip")
}

resource "aws_lambda_layer_version" "collector_layer" {
  layer_name          = var.collector_layer_name
  filename            = "../../../../collector/build/collector-extension.zip"
  compatible_runtimes = ["nodejs10.x", "nodejs12.x", "nodejs14.x"]
  license_info        = "Apache-2.0"
  source_code_hash    = filebase64sha256("../../../../collector/build/collector-extension.zip")
}

module "hello-okhttp-function" {
  source                 = "../../../sample-apps/okhttp/deploy/wrapper"
  name                   = var.function_name
  collector_layer_arn    = aws_lambda_layer_version.sdk_layer.arn
  java_wrapper_layer_arn = aws_lambda_layer_version.collector_layer.arn
  enable_lambda_insights = var.enable_lambda_insights
}
