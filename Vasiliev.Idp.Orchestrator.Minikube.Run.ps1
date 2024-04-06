
#docker run -p 8080:8080 -p 8081:8081 --rm rates-orchestrator

kubectl create -f C:\Work\PetProject\RatesApplication\Vasiliev.Idp.Orchestrator.yml

kubectl expose deployment rates-orchestrator-deployment --type=NodePort --port=8080

minikube service rates-orchestrator-deployment --url