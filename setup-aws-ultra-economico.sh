#!/bin/bash

# Script ULTRA ECONÔMICO para configurar infraestrutura AWS
# Execute: chmod +x setup-aws-ultra-economico.sh && ./setup-aws-ultra-economico.sh

set -e

AWS_REGION="us-east-1"
ECR_REPO="nasa-api"

echo "💰 Configuração ULTRA ECONÔMICA da infraestrutura AWS..."
echo "💡 Custo estimado: ~$20-25/mês (vs ~$150/mês da versão original)"

# 1. Verificar AWS CLI
echo "📋 Verificando AWS CLI..."
if ! aws sts get-caller-identity > /dev/null 2>&1; then
    echo "❌ AWS CLI não configurado. Execute: aws configure"
    exit 1
fi

# 2. Criar ECR Repository
echo "🐳 Criando repositório ECR..."
aws ecr create-repository \
    --repository-name $ECR_REPO \
    --region $AWS_REGION \
    --image-scanning-configuration scanOnPush=true \
    || echo "⚠️  Repositório já existe"

# 3. Obter Account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
echo "🔑 Account ID: $AWS_ACCOUNT_ID"

echo "✅ ECR configurado!"
echo ""
echo "🚀 OPÇÃO MAIS ECONÔMICA - EKS Fargate:"
echo ""
echo "1. Acesse: https://console.aws.amazon.com/eks/home"
echo "2. Clique em 'Create cluster'"
echo "3. Nome: eks-nasa-fargate"
echo "4. Região: us-east-1"
echo "5. Selecionar 'Fargate' (sem nodes EC2!)"
echo "6. Aguarde a criação (10-15 min)"
echo ""
echo "💡 VANTAGENS DO FARGATE:"
echo "   ✅ Sem custos de EC2 nodes"
echo "   ✅ Paga apenas pelo que usa"
echo "   ✅ Escalamento automático"
echo "   ✅ Custo: ~$20-25/mês total"
echo ""
echo "🔗 ECR Repository criado:"
echo "https://console.aws.amazon.com/ecr/repositories/private/$AWS_ACCOUNT_ID/$ECR_REPO"
echo ""
echo "📝 Secrets para o GitHub:"
echo "AWS_ACCOUNT_ID = $AWS_ACCOUNT_ID"
echo "AWS_REGION = $AWS_REGION"
echo "ECR_REPO = $ECR_REPO"
echo ""
echo "🎯 PRÓXIMOS PASSOS:"
echo "1. Execute o script acima para criar o cluster Fargate"
echo "2. Configure kubectl: aws eks update-kubeconfig --region us-east-1 --name eks-nasa-fargate"
echo "3. Aplique os manifests: kubectl apply -f k8s/"
echo "4. Acesse via port-forward: kubectl port-forward svc/nasa-api 8080:80"
