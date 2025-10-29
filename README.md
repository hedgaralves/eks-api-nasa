# 🚀 NASA API - Versão Ultra Econômica

API Flask para consumir dados da NASA com deploy otimizado para custos mínimos na AWS.

## 💰 Custo Estimado
- **Versão Original**: ~$150/mês
- **Versão Econômica**: ~$20-25/mês (**85% de economia!**)

## 🏗️ Arquitetura Otimizada
- **EKS Fargate**: Serverless, sem custos de EC2 nodes
- **1 Réplica**: Suficiente para desenvolvimento/teste
- **Recursos Mínimos**: 0.25 CPU, 0.5Gi RAM
- **ClusterIP**: Sem LoadBalancer caro
- **Sem Monitoramento**: Removido Prometheus/Grafana

## 🚀 Deploy Rápido

### 1. Configurar Infraestrutura
```bash
chmod +x setup-aws-ultra-economico.sh
./setup-aws-ultra-economico.sh
```

### 2. Deploy da Aplicação
```bash
chmod +x deploy-economico.sh
./deploy-economico.sh
```

### 3. Acessar Aplicação
```bash
kubectl port-forward svc/nasa-api 8080:80
# Acesse: http://localhost:8080
```

## 🔧 Pipeline CI/CD

A pipeline GitHub Actions está configurada para:
- ✅ Build automático da imagem Docker
- ✅ Push para ECR
- ✅ Deploy automático no EKS Fargate
- ✅ Atualização de manifests

### Secrets Necessários no GitHub:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `NASA_API_KEY` (para o cluster)

## 📁 Estrutura do Projeto

```
├── app.py                              # API Flask principal
├── Dockerfile                          # Imagem otimizada
├── requirements.txt                    # Dependências Python
├── setup-aws-ultra-economico.sh       # Script de infraestrutura
├── deploy-economico.sh                 # Script de deploy
├── k8s/
│   ├── nasa-api-fargate-deployment.yaml  # Deployment para Fargate
│   ├── nasa-api-deployment.yaml          # Deployment padrão
│   └── service.yaml                      # Service ClusterIP
└── .github/workflows/
    └── deploy.yml                         # Pipeline CI/CD
```

## 🌐 Endpoints

- `GET /api/nasa/apod` - Astronomy Picture of the Day
- `GET /api/nasa/planetary` - Earth imagery
- `GET /health` - Health check
- `GET /metrics` - Métricas Prometheus

## 🔑 Configuração

### 1. Permissões IAM Mínimas
Anexe a policy `iam-policy-minimal.json` ao usuário IAM:
```bash
aws iam put-user-policy --user-name nasa --policy-name EKSMinimalAccess --policy-document file://iam-policy-minimal.json
```

### 2. Configuração da Aplicação
1. **NASA API Key**: Configure a variável `NASA_API_KEY` no cluster
2. **AWS Credentials**: Configure via `aws configure`
3. **Cluster EKS**: Use o nome `eks-nasa-fargate`

### 3. Secrets do GitHub
Configure no repositório:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `NASA_API_KEY`

## 💡 Dicas de Economia

- ✅ Use Fargate em vez de EC2 nodes
- ✅ Mantenha apenas 1 réplica
- ✅ Use recursos mínimos necessários
- ✅ ClusterIP em vez de LoadBalancer
- ✅ Remova componentes de monitoramento desnecessários

---
**Desenvolvido com foco em economia máxima mantendo funcionalidade completa!** 🎯
