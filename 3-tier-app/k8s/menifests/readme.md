<!-- kubectl set image deployment/<deployment-name> <container-name>=<image>:<tag> -->
kubectl set image deployment/backend backend=879381241087.dkr.ecr.ap-south-1.amazonaws.com/3tier-devopsdozo-backend:8d5d9bff8f81d2a6ab1ca654e268cdfdb17436cf -n 3-tier-app-eks

kubectl set image deployment/frontend frontend=879381241087.dkr.ecr.ap-south-1.amazonaws.com/3tier-devopsdozo-frontend:8d5d9bff8f81d2a6ab1ca654e268cdfdb17436cf -n 3-tier-app-eks

## Database migrations

Run migrations **after** deploying a new backend image. The migration Job must use the **same image tag** as `backend.yaml`.

```bash
# 1. Deploy backend with new image tag (update backend.yaml + db-migration.yaml to match)
kubectl apply -f backend.yaml

# 2. Run migration Job (default: upgrade to head)
kubectl delete job database-migration -n 3-tier-app-eks --ignore-not-found
kubectl apply -f db-migration.yaml
kubectl wait --for=condition=complete job/database-migration -n 3-tier-app-eks --timeout=120s
kubectl logs job/database-migration -n 3-tier-app-eks
```

**Downgrade** (manual — edit `MIGRATION_ACTION` / `MIGRATION_TARGET` in `db-migration.yaml` before apply):
```bash
# Example: downgrade from head to a05e32811b08
# Set MIGRATION_ACTION=downgrade and MIGRATION_TARGET=a05e32811b08 in db-migration.yaml
kubectl delete job database-migration -n 3-tier-app-eks --ignore-not-found
kubectl apply -f db-migration.yaml
```

**Check current revision** (one-off pod or exec):
```bash
MIGRATION_ACTION=current ./migrate.sh
```

Never drop `alembic_version` or reset migrations in production.

kubectl rollout status deployment/backend -n 3-tier-app-eks
kubectl rollout status deployment/frontend -n 3-tier-app-eks
