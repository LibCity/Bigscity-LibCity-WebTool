<template>
  <div class="navbar">
    <hamburger :is-active="sidebar.opened" class="hamburger-container" @toggleClick="toggleSideBar" />

    <breadcrumb class="breadcrumb-container" />

    <div class="right-menu">

      <el-tooltip class="item" effect="dark" :content="$t('navbar.clickToBack')" placement="bottom">
        <span class="right-menu-item hover-effect" @click="back">
          <i class="el-icon-back" />
        </span>
      </el-tooltip>

      <el-tooltip class="item" effect="dark" :content="$t('intro.viewIntro')" placement="bottom">
        <span class="right-menu-item hover-effect" :data-intro="$t('intro.showIntro')" @click="showIntro()">
          <i class="el-icon-question" />
        </span>
      </el-tooltip>

      <template>
        <lang-select class="right-menu-item hover-effect" />
      </template>

      <el-dropdown class="right-menu-item" trigger="click">
        <span>
          <!-- <img :src="avatar+'?imageView2/1/w/80/h/80'" class="user-avatar"> -->
          <span font-size="16px" style="cursor: pointer">{{ name }}</span>
          <i style="cursor: pointer" class="el-icon-caret-bottom" />
        </span>
        <el-dropdown-menu slot="dropdown">
          <router-link to="/">
            <el-dropdown-item>
              {{ $t('navbar.dashboard') }}
            </el-dropdown-item>
          </router-link>
          <router-link to="/updatePassword">
            <el-dropdown-item divided>
              <span style="display:block;">
                {{ $t('navbar.updatePassword') }}
              </span>
            </el-dropdown-item>
          </router-link>
          <router-link to="/bindMail">
            <el-dropdown-item divided>
              <span style="display:block;">
                {{ $t('navbar.bindMail') }}
              </span>
            </el-dropdown-item>
          </router-link>
          <el-dropdown-item divided @click.native="logout">
            <span style="display:block;">
              {{ $t('navbar.logOut') }}
            </span>
          </el-dropdown-item>
        </el-dropdown-menu>
      </el-dropdown>

    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import Breadcrumb from '@/components/Breadcrumb'
import Hamburger from '@/components/Hamburger'
import LangSelect from '@/components/LangSelect'

export default {

  components: {
    Breadcrumb,
    Hamburger,
    LangSelect
  },
  computed: {
    ...mapGetters([
      'sidebar',
      'avatar',
      'name'
    ])
  },
  methods: {
    back() {
      this.$router.go(-1)// 返回上一层
    },
    showIntro() {
      // console.log('this:', this)
      // console.log('this.$route.path', this.$route.path)
      // const path = this.$route.path
      // if (path === '/taskList/index') {
      //   console.log('task启动需要预设步骤')
      //   const rowList = Array.from(this.$refs.taskTable.$el.getElementsByClassName('el-table__row'))
      //   this.$intro.setOptions({
      //     steps: [{
      //       title: 'Welcome',
      //       intro: 'Hello World! 👋'
      //     },
      //     {
      //       element: rowList[0].cells[0],
      //       intro: 'This step focuses on an image'
      //     },
      //     {
      //       title: 'Farewell!',
      //       element: rowList[0].cells[1],
      //       intro: 'And this is our final step!'
      //     }]
      //   })
      // }
      // 特定页面展示向导内容
      const allowPaths = ['/taskList/index', '/taskAdd/addTask', '/dataset/index', '/accounts/index', '/roles/index']
      const path = this.$route.path
      if (allowPaths.includes(path)) {
        this.$intro.start()
      } else {
        // 提示本页面暂无新手引导内容
        this.$message(this.$t('intro.noIntro'))
      }
    },
    toggleSideBar() {
      this.$store.dispatch('app/toggleSideBar')
    },
    async logout() {
      await this.$store.dispatch('user/logout')
      this.$router.push(`/login?redirect=${this.$route.fullPath}`)
    }
  }
}
</script>

<style lang="scss" scoped>
.navbar {
  height: 50px;
  overflow: hidden;
  position: relative;
  background: #fff;
  box-shadow: 0 1px 4px rgba(0,21,41,.08);

  .hamburger-container {
    line-height: 46px;
    height: 100%;
    float: left;
    cursor: pointer;
    transition: background .3s;
    -webkit-tap-highlight-color:transparent;

    &:hover {
      background: rgba(0, 0, 0, .025)
    }
  }

  .breadcrumb-container {
    float: left;
  }

  .right-menu {
    float: right;
    height: 100%;
    line-height: 50px;

    &:focus {
      outline: none;
    }

    .right-menu-item {
      display: inline-block;
      padding: 0 20px;
      height: 100%;
      font-size: 18px;
      color: #5a5e66;
      vertical-align: text-bottom;

      &.hover-effect {
        cursor: pointer;
        transition: background .3s;

        &:hover {
          background: rgba(0, 0, 0, .025)
        }
      }
    }

    .avatar-container {
      margin-right: 30px;

      .avatar-wrapper {
        margin-top: 5px;
        position: relative;

        .user-avatar {
          cursor: pointer;
          width: 40px;
          height: 20px;
          border-radius: 10px;
        }

        .el-icon-caret-bottom {
          cursor: pointer;
          position: absolute;
          right: -20px;
          top: 25px;
          font-size: 12px;
        }
      }
    }
  }
}
</style>
