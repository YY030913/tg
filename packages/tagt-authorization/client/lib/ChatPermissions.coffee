TAGT.authz.cachedCollection = new TAGT.CachedCollection({ name: 'permissions', eventType: 'onAll', initOnLogin: true })
@ChatPermissions = TAGT.authz.cachedCollection.collection
