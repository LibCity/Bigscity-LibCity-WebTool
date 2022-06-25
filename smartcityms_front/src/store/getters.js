const getters = {
  sidebar: state => state.app.sidebar,
  device: state => state.app.device,
  token: state => state.user.token,
  avatar: state => state.user.avatar,
  name: state => state.user.name,
  language: state => state.app.language,
  permissions: state => state.user.permissions,
  permission_routes: state => state.permission.routes,
  roles: state => state.user.roles,
  id: state => state.user.id
}
export default getters
