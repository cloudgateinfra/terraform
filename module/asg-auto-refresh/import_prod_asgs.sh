# import - terra resource name - cloud service resource name

terraform init
terraform import aws_autoscaling_group.prod_app_web1 CodeDeploy_PROD-web-app-1
terraform import aws_autoscaling_group.prod_app_web2 CodeDeploy_PROD-web-app-2
terraform import aws_autoscaling_group.prod_sm_celerybeat PROD-celerybeat-ASG
terraform import aws_autoscaling_group.prod_sm_celery PROD-celery-ASG
terraform import aws_autoscaling_group.prod_sf_celery PROD-celery-ASG
terraform import aws_autoscaling_group.prod_sf_celerybeat PROD-celerybeat-ASG
