<template>
  <div class="login-container">

    <el-form ref="loginForm" :model="loginForm" :rules="loginRules" class="login-form" auto-complete="on" label-position="left">

      <div class="img-container" style="margin: 0 auto">
        <img class="logo" src="../../icons/logo.png" alt="logo">
      </div>

      <div class="title-container">
        <h3 class="title">{{ $t('login.title') }}</h3>
        <lang-select class="set-language" />
      </div>

      <el-form-item prop="account_number">

        <span class="svg-container">
          <svg-icon icon-class="user" />
        </span>

        <el-input
          ref="account_number"
          v-model="loginForm.account_number"
          :placeholder="$t('login.accountNumber')"
          name="account_number"
          type="text"
          tabindex="1"
        />

      </el-form-item>

      <el-form-item prop="password">

        <span class="svg-container">
          <svg-icon icon-class="password" />
        </span>

        <el-input
          ref="password"
          :key="passwordType"
          v-model="loginForm.password"
          autocomplete="new-password"
          :type="passwordType"
          :placeholder="$t('login.password')"
          name="password"
          tabindex="2"
          @keyup.enter.native="handleLogin"
        />
        <span class="show-pwd" @click="showPwd">
          <svg-icon :icon-class="passwordType === 'password' ? 'eye' : 'eye-open'" />
        </span>
      </el-form-item>

      <el-button :loading="loading" type="primary" style="width:100%;margin-bottom:30px;" @click.native.prevent="handleLogin">{{ $t('login.logIn') }}</el-button>
      <div style="float: right">
        <router-link to="/register">
          <el-link style="color: white">
            {{ $t('register.toRegister') }}
          </el-link>
        </router-link>
      </div>
    </el-form>
  </div>
</template>

<script>
import LangSelect from '@/components/LangSelect'
import { Message } from 'element-ui'
// import { login } from '@/api/auth'

export default {
  name: 'Login',
  components: { LangSelect },
  data() {
    const validateAccount = (rule, value, callback) => {
      if (value.length === 0) {
        callback(new Error(this.$t('login.accountNumberError')))
      } else {
        callback()
      }
    }
    const validatePassword = (rule, value, callback) => {
      if (value.length < 6) {
        callback(new Error(this.$t('login.passwordError')))
      } else {
        callback()
      }
    }
    return {
      loginForm: {
        account_number: '',
        password: ''
      },
      loginRules: {
        account_number: [{ required: true, trigger: 'blur', validator: validateAccount }],
        password: [{ required: true, trigger: 'blur', validator: validatePassword }]
      },
      loading: false,
      passwordType: 'password',
      redirect: undefined
    }
  },
  watch: {
    $route: {
      handler: function(route) {
        this.redirect = route.query && route.query.redirect
      },
      immediate: true
    }
  },
  methods: {
    showPwd() {
      if (this.passwordType === 'password') {
        this.passwordType = ''
      } else {
        this.passwordType = 'password'
      }
      this.$nextTick(() => {
        this.$refs.password.focus()
      })
    },
    handleLogin() {
      // login(this.loginForm).then(() => {
      //   console.log('request')
      // })
      this.$refs.loginForm.validate(valid => {
        if (valid) {
          this.loading = true
          this.$store.dispatch('user/login', this.loginForm).then(() => {
            Message({
              message: this.$t('login.verificationSuccess'),
              type: 'success',
              duration: 5 * 1000
            })
            this.$router.push({ path: this.redirect || '/' })
            this.loading = false
          }).catch((ex) => {
            this.loading = false
            console.log('catch')
            console.log(ex)
          })
        } else {
          console.log('error submit!!')
          return false
        }
      })
    }
  }
}
</script>

<style lang="scss">

$bg:#283443;
$light_gray:#fff;
$cursor: #fff;

@supports (-webkit-mask: none) and (not (cater-color: $cursor)) {
  .login-container .el-input input {
    color: $cursor;
  }
}

/* reset element-ui css */
.login-container {
  .el-input {
    display: inline-block;
    height: 47px;
    width: 85%;

    input {
      background: transparent;
      border: 0px;
      -webkit-appearance: none;
      border-radius: 0px;
      padding: 12px 5px 12px 15px;
      color: $light_gray;
      height: 47px;
      caret-color: $cursor;

      &:-webkit-autofill {
        box-shadow: 0 0 0px 1000px $bg inset !important;
        -webkit-text-fill-color: $cursor !important;
      }
    }
  }

  .el-form-item {
    border: 1px solid rgba(255, 255, 255, 0.1);
    background: rgba(0, 0, 0, 0.1);
    border-radius: 5px;
    color: #454545;
  }
}
</style>

<style lang="scss" scoped>
$bg:#2d3a4b;
$dark_gray:#889aa4;
$light_gray:#eee;

.img-container {
    width:159px;
    height: 146px;
    position: relative;
}

.logo {
    width: 100%;
    height: 100%;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%,-50%);
}

.login-container {
  min-height: 100%;
  width: 100%;
  background-color: $bg;
  overflow: hidden;

  .login-form {
    position: relative;
    width: 580px;
    max-width: 100%;
    padding: 60px 35px 0;
    margin: 0 auto;
    overflow: hidden;
  }

  .tips {
    font-size: 14px;
    color: #fff;
    margin-bottom: 10px;

    span {
      &:first-of-type {
        margin-right: 16px;
      }
    }
  }

  .svg-container {
    padding: 6px 5px 6px 15px;
    color: $dark_gray;
    vertical-align: middle;
    width: 30px;
    display: inline-block;
  }

  .title-container {
    position: relative;

    .title {
      font-size: 26px;
      color: $light_gray;
      margin: 16px auto 40px auto;
      text-align: center;
      font-weight: bold;
    }

    .set-language {
      color: #fff;
      position: absolute;
      top: 3px;
      font-size: 18px;
      right: 0px;
      cursor: pointer;
      display: inline;
    }
  }

  .show-pwd {
    position: absolute;
    right: 10px;
    top: 7px;
    font-size: 16px;
    color: $dark_gray;
    cursor: pointer;
    user-select: none;
  }
}
</style>
