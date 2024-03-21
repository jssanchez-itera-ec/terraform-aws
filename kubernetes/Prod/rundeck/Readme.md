## Crear SA, Role & Role Binding
k apply -f ./kubernetes/Preprod/rundeck/

# crear Secreto
kubectl apply -f serviceAccount.yaml

# Validar que el token este asociado al ServiceAccount
kubectl -n wordpress describe sa rundeck-sa

# obtener secreto 
kubectl get secret rundeck-secret -n wordpress -o jsonpath='{.data.token}' | base64 --decode