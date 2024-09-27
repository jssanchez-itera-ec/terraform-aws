mapUsers: |
    - userarn: arn:aws:iam::644263771432:user/test-eks
      username: test-eks
      groups:
        - system:masters


kubectl rollout restart deployment nginx-test-deployment
kubectl rollout undo deployment nginx-test-deployment
kubectl rollout history deployment nginx-test-deployment
kubectl rollout history deployment nginx-test-deployment --revision=2