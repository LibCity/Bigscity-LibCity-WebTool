import store from '@/store'

// 此方法返回当前用户是否有 value 中定义的权限 如果有权限 返回 true
export function checkPermission(value) {
  if (value && value instanceof Array && value.length > 0) {
    const permissions = store.getters && store.getters.permissions
    const permissionperms = value
    if (permissions.includes('admin')) {
      return true
    }
    const hasPermission = permissions.some(perm => {
      return permissionperms.includes(perm)
    })

    if (!hasPermission) {
      return false
    }
    return true
  } else {
    console.error(`need permissions! Like v-permission="['admin','editor']"`)
    return false
  }
}
