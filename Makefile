REGIONS = eu-west-1

.PHONY: default
default: package

.PHONY: package
package:
	npm install
	mkdir -p build
	zip -r build/api-comments.zip api-comments/* data/* node_modules/* utils/* package.json package-lock.json
	zip -r build/api-issues.zip api-issues/* data/* node_modules/* utils/* package.json package-lock.json
	zip -r build/api-projects.zip api-projects/* data/* node_modules/* utils/* package.json package-lock.json

.PHONY: deploy_artifacts
deploy_artifacts:
	aws s3 cp build/api-comments.zip s3://artifact-lamdas/api-comments.zip
	aws s3 cp build/api-issues.zip s3://artifact-lamdas/api-issues.zip
	aws s3 cp build/api-projects.zip s3://artifact-lamdas/api-projects.zip

.PHONY: plan
plan:
	cd tf && terraform plan

.PHONY: create_bucket
create_bucket:
	aws s3api create-bucket --bucket artifact-lamdas --region us-east-1

.PHONY: apply
apply:
	cd tf && terraform apply

.PHONY: destroy
destroy:
	cd tf && terraform destroy

.PHONY: clean
clean:
	rm -rf build/
