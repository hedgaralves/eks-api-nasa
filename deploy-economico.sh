#!/bin/bash

# Script de deploy ECONÔMICO para a aplicação NASA
# Execute: chmod +x deploy-economico.sh && ./deploy-economico.sh

set -e

AWS_REGION="us-east-1"
ECR_REPO="nasa-api"

echo "🚀 Deploy ECONÔMICO da aplicação NASA..."

# 1. Obter Account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_URI="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO"

echo "🔑 Account ID: $AWS_ACCOUNT_ID"
echo "🐳 ECR URI: $ECR_URI"

# 2. Login no ECR
echo "🔐 Fazendo login no ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URI

# 3. Build da imagem
echo "🔨 Fazendo build da imagem..."
docker build -t $ECR_REPO:latest .

# 4. Tag da imagem
echo "🏷️  Taggeando imagem..."
docker tag $ECR_REPO:latest $ECR_URI:latest

# 5. Push para ECR
echo "📤 Enviando imagem para ECR..."
docker push $ECR_URI:latest

# 6. Atualizar deployment com URI correta
echo "📝 Atualizando deployment..."
sed "s|<ECR_REPO_URI>|$ECR_URI|g" k8s/nasa-api-fargate-deployment.yaml > k8s/nasa-api-deployment-updated.yaml

# 7. Aplicar no cluster
echo "🚀 Aplicando no cluster..."
kubectl apply -f k8s/nasa-api-deployment-updated.yaml

# 8. Aguardar deployment
echo "⏳ Aguardando deployment..."
kubectl rollout status deployment/nasa-api

# 9. Mostrar status
echo "✅ Deploy concluído!"
echo ""
echo "📊 Status do deployment:"
kubectl get pods -l app=nasa-api
echo ""
echo "🌐 Para acessar a aplicação:"
echo "kubectl port-forward svc/nasa-api 8080:80"
echo ""
echo "🔗 Depois acesse: http://localhost:8080"
echo ""
echo "💰 Custo estimado: ~$20-25/mês (vs ~$150/mês da versão original)"
