import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

/* Layout */
import Layout from '@/layout'

/**
 * Note: sub-menu only appear when route children.length >= 1
 * Detail see: https://panjiachen.github.io/vue-element-admin-site/guide/essentials/router-and-nav.html
 *
 * hidden: true                   if set true, item will not show in the sidebar(default is false)
 * alwaysShow: true               if set true, will always show the root menu
 *                                if not set alwaysShow, when item has more than one children route,
 *                                it will becomes nested mode, otherwise not show the root menu
 * redirect: noRedirect           if set noRedirect will no redirect in the breadcrumb
 * name:'router-name'             the name is used by <keep-alive> (must set!!!)
 * meta : {
    permissions: ['admin','editor']    control the page permissions (you can set multiple permissions)
    title: 'title'               the name show in sidebar and breadcrumb (recommend set)
    icon: 'svg-name'/'el-icon-x' the icon show in the sidebar
    breadcrumb: false            if set false, the item will hidden in breadcrumb(default is true)
    activeMenu: '/example/list'  if set path, the sidebar will highlight the path you set
  }
 */

/**
 * constantRoutes
 * a base page that does not have permission requirements
 * all permissions can be accessed
 */
export const constantRoutes = [
  {
    path: '/login',
    component: () => import('@/views/login/index'),
    hidden: true
  },

  {
    path: '/register',
    component: () => import('@/views/register/index'),
    hidden: true
  },

  {
    path: '/404',
    component: () => import('@/views/404'),
    hidden: true
  },

  {
    path: '/updatePassword',
    component: Layout,
    redirect: '/updatePassword',
    children: [
      {
        path: '',
        component: () => import('@/views/password/index'),
        name: 'update password',
        meta: { title: 'updatePassword' },
        hidden: true
      }
    ]
  },

  // bindMail
  {
    path: '/bindMail',
    component: Layout,
    redirect: '/bindMail',
    children: [
      {
        path: '',
        component: () => import('@/views/mail/bind'),
        name: 'bind mail',
        meta: { title: 'bindMail' },
        hidden: true
      }
    ]
  },

  {
    path: '/',
    component: Layout,
    redirect: '/dashboard',
    children: [{
      path: 'dashboard',
      name: 'dashboard',
      component: () => import('@/views/dashboard/index'),
      meta: { title: 'dashboard', icon: 'dashboard' }
    }]
  },

  {
    path: '/evaluate',
    component: Layout,
    children: [
      {
        path: 'index',
        params: { taskIds: '', taskType: '' },
        component: () => import('@/views/evaluate/index'),
        name: 'evaluate',
        meta: { title: 'evaluate', icon: 'task1' },
        hidden: true
      }
    ]
  },

  // {
  //   path: '/map',
  //   component: Layout,
  //   children: [
  //     {
  //       path: 'map',
  //       component: () => import('@/views/google/map'),
  //       name: 'map',
  //       meta: { title: 'map', icon: 'task1' }
  //     }
  //   ]
  // },

  {
    path: '/task',
    component: Layout,
    children: [
      {
        path: 'result',
        params: { taskId: '', dataset: '' },
        component: () => import('@/views/task/result'),
        name: 'taskResult',
        meta: { title: 'taskResult', icon: 'task1' },
        hidden: true
      }
    ]
  },

  // 无权限访问页面
  {
    path: '/forbidden',
    component: Layout,
    children: [
      {
        path: 'index',
        component: () => import('@/views/forbidden/index'),
        name: 'forbidden',
        // meta: { title: 'taskResult', icon: 'task1' },
        hidden: true
      }
    ]
  }

  // {
  //   path: '/example',
  //   component: Layout,
  //   redirect: '/example/table',
  //   name: 'Example',
  //   meta: { title: 'Example', icon: 'el-icon-s-help' },
  //   children: [
  //     {
  //       path: 'table',
  //       name: 'Table',
  //       component: () => import('@/views/table/index'),
  //       meta: { title: 'Table', icon: 'table' }
  //     },
  //     {
  //       path: 'tree',
  //       name: 'Tree',
  //       component: () => import('@/views/tree/index'),
  //       meta: { title: 'Tree', icon: 'tree' }
  //     }
  //   ]
  // }

]

/**
 * asyncRoutes
 * the routes that need to be dynamically loaded based on user permissions
 */
export const asyncRoutes = [

  {
    path: '/taskList',
    component: Layout,
    children: [
      {
        path: 'index',
        component: () => import('@/views/task/index'),
        name: 'tasks list',
        meta: { title: 'taskList', icon: 'task1', permissions: ['admin', 'taskList'] }
      }
    ]
  },

  {
    path: '/taskAdd',
    component: Layout,
    children: [
      {
        path: 'addTask',
        component: () => import('@/views/task/addTask'),
        name: 'tasks add',
        meta: { title: 'tasksAdd', icon: 'taskadd', permissions: ['admin', 'tasksAdd'] }
      }
    ]
  },

  {
    path: '/taskEdit',
    component: Layout,
    children: [
      {
        path: 'editTask/:id',
        component: () => import('@/views/task/addTask'),
        name: 'tasks edit',
        meta: { title: 'tasksEdit', icon: '', permissions: ['admin', 'taskEdit'] },
        hidden: true
      }
    ]
  },

  // {
  //   path: '/tasks',
  //   component: Layout,
  //   redirect: '/tasks/index',
  //   name: 'tasks manage',
  //   meta: { title: 'taskManage', icon: 'task1', permissions: ['admin', 'taskManage'] },
  //   children: [
  //     {
  //       path: 'index',
  //       component: () => import('@/views/task/index'),
  //       name: 'tasks list',
  //       meta: { title: 'taskList', icon: '', permissions: ['admin', 'taskList'] }
  //     },
  //     {
  //       path: 'addTask',
  //       component: () => import('@/views/task/addTask'),
  //       name: 'tasks add',
  //       meta: { title: 'tasksAdd', icon: '', permissions: ['admin', 'tasksAdd'] }
  //     },
  //     {
  //       path: 'editTask/:id',
  //       component: () => import('@/views/task/addTask'),
  //       name: 'tasks edit',
  //       meta: { title: 'tasksEdit', icon: '', permissions: ['admin', 'taskEdit'] },
  //       hidden: true
  //     }
  //   ]
  // },

  {
    path: '/dataset',
    component: Layout,
    children: [
      {
        path: 'index',
        component: () => import('@/views/dataset/index'),
        name: 'dataset manage',
        meta: { title: 'datasetManage', icon: 'resource', permissions: ['admin', 'datasetManage'] }
      },
      {
        path: 'show_dataset/:file_name',
        component: () => import('@/views/dataset/show_dataset'),
        name: 'dataset_view',
        meta: { title: 'datasetView', icon: '', permissions: ['admin', 'datasetManage'] },
        hidden: true
      }
    ]
  },

  {
    path: '/accounts',
    component: Layout,
    children: [
      {
        path: 'index',
        component: () => import('@/views/account/index'),
        name: 'account manage',
        meta: { title: 'accountManage', icon: 'account', permissions: ['admin', 'accountManage'] }
      }
    ]
  },

  {
    path: '/roles',
    component: Layout,
    children: [
      {
        path: 'index',
        component: () => import('@/views/role/index'),
        name: 'roles manage',
        meta: { title: 'roleManage', icon: 'role', permissions: ['admin', 'roleManage'] }
      }
    ]
  },

  // 没必要展示权限查看页面
  // {
  //   path: '/permissions',
  //   component: Layout,
  //   children: [
  //     {
  //       path: 'index',
  //       component: () => import('@/views/permission/index'),
  //       name: 'permissions manage',
  //       meta: { title: 'permissionManage', icon: 'permission', permissions: ['admin', 'permissionQuery'] }
  //     }
  //   ]
  // },

  // {
  //   path: '/resources',
  //   component: Layout,
  //   children: [
  //     {
  //       path: 'index',
  //       component: () => import('@/views/resource/index'),
  //       name: 'resources manage',
  //       meta: { title: 'resourceManage', icon: 'resource', permissions: ['admin', 'resourceManage'] }
  //     }
  //   ]
  // },

  // {
  //   path: '/templates',
  //   component: Layout,
  //   children: [
  //     {
  //       path: 'index',
  //       component: () => import('@/views/template/index'),
  //       name: 'templates manage',
  //       meta: { title: 'templateManage', icon: 'template', permissions: ['admin', 'templateManage'] }
  //     }
  //   ]
  // },

  // {
  //   path: 'external-link',
  //   component: Layout,
  //   children: [
  //     {
  //       path: 'https://panjiachen.github.io/vue-element-admin-site/#/',
  //       meta: { title: 'External Link', icon: 'link' }
  //     }
  //   ]
  // },

  // 404 page must be placed at the end !!!
  { path: '*', redirect: '/404', hidden: true }
]

const createRouter = () => new Router({
  // mode: 'history', // require service support
  scrollBehavior: () => ({ y: 0 }),
  routes: constantRoutes
})

const router = createRouter()

// Detail see: https://github.com/vuejs/vue-router/issues/1234#issuecomment-357941465
export function resetRouter() {
  const newRouter = createRouter()
  router.matcher = newRouter.matcher // reset router
}

export default router
