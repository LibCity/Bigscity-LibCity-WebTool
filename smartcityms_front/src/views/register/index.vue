<template>
  <div class="login-container">
    <el-form
      ref="registerForm"
      :model="registerForm"
      :rules="registerRules"
      class="login-form"
      label-position="left"
    >

      <!-- logo -->
      <!-- <div class="img-container" style="margin: 0 auto">
        <img class="logo" src="../../icons/logo.png" alt="logo">
      </div> -->

      <!-- 标题 -->
      <div class="title-container">
        <h3 class="title">{{ $t('register.title') }}</h3>
        <lang-select class="set-language" />
      </div>

      <!-- 账号 -->
      <el-form-item prop="account_number">

        <span class="svg-container">
          <svg-icon icon-class="user" />
        </span>

        <el-input
          ref="account_number"
          v-model="registerForm.account_number"
          :placeholder="$t('login.accountNumber')"
          name="account_number"
          type="text"
          tabindex="1"
        />

      </el-form-item>

      <!-- 密码 -->
      <el-form-item prop="password">

        <span class="svg-container">
          <svg-icon icon-class="password" />
        </span>

        <el-input
          ref="password"
          :key="passwordType"
          v-model="registerForm.password"
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

      <!-- 再次输入密码 -->
      <!-- <el-form-item>
        <span class="svg-container">
          <svg-icon icon-class="password" />
        </span>
        <el-input
          v-model="registerForm.new_password_repeat"
          :placeholder="$t('register.repeatPassword')"
          clearable
          show-password
        />
      </el-form-item> -->

      <!-- 邮箱 -->
      <el-form-item prop="mail">
        <span class="svg-container">
          <svg-icon icon-class="mail" />
        </span>
        <el-input
          v-model="registerForm.mail"
          :placeholder="$t('register.inputMail')"
        />
      </el-form-item>

      <!-- 验证码 -->
      <el-form-item prop="code">
        <el-row type="flex" :gutter="20">
          <el-col :span="18">
            <span class="svg-container">
              <svg-icon icon-class="code" />
            </span>
            <el-input
              v-model="registerForm.code"
              :placeholder="$t('register.inputCode')"
            />
          </el-col>
          <el-col align="bottom" :span="6">
            <el-link
              v-if="getCodeStatus"
              :underline="false"
              style="color: white; padding-top: 8px"
              @click="getCode()"
            >{{ $t('register.getCode') }}
            </el-link>
            <el-link
              v-else
              :underline="false"
              style="color: white; padding-top: 8px"
            >{{ $t('register.getCode') }}({{ codeSecond }})</el-link>
          </el-col>
        </el-row>
      </el-form-item>

      <el-button
        :loading="loading"
        type="primary"
        style="width:100%;margin-bottom:30px;"
        @click.native.prevent="handleRegister"
      >
        {{ $t('register.register') }}
      </el-button>
      <!-- tips -->
      <div style="float: right">
        <router-link to="/login">
          <el-link style="color: white">
            {{ $t('register.toLogin') }}
          </el-link>
        </router-link>
      </div>
    </el-form>
  </div>
</template>

<script>
import LangSelect from '@/components/LangSelect'
import { accountExists, getAuthCode, addAccount } from '@/api/account'
// import { Message } from 'element-ui'
export default {
  name: 'Login',
  components: { LangSelect },
  data() {
    // 账号校验
    const validateAccount = (rule, value, callback) => {
      if (value.length === 0) {
        callback(new Error(this.$t('login.accountNumberError')))
      } else {
        this.registerForm.account_number = value
        accountExists(this.registerForm).then(res => {
          if (res.code !== 200) {
            callback(new Error(this.$t('account.accountNumberExistsError')))
          } else {
            callback()
          }
        })
      }
    }
    // 密码校验
    const validatePassword = (rule, value, callback) => {
      if (value.length < 6) {
        callback(new Error(this.$t('login.passwordError')))
      } else {
        callback()
      }
    }
    // 邮箱校验
    const validateMail = (rule, value, callback) => {
      if (!value || value.length === 0) {
        callback(new Error(this.$t('register.pleaseInputMail')))
      } else if (!(/^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/.test(value))) {
        return callback(new Error(this.$t('register.wrongMailFormat')))
      } else {
        callback()
      }
    }
    return {
      // 注册表单存储对象
      registerForm: {
        account_number: '',
        password: '',
        mail: ''
      },
      // 表单校验规则
      registerRules: {
        account_number: [{ required: true, trigger: 'blur', validator: validateAccount }],
        password: [{ required: true, trigger: 'blur', validator: validatePassword }],
        mail: [
          { required: true, trigger: 'blur', validator: validateMail }
        ],
        code: [{ required: true, message: this.$t('register.pleaseInputCode'), trigger: 'blur' }]
      },
      loading: false,
      fullScreenLoading: {},
      passwordType: 'password',
      redirect: undefined,
      // 是否允许获取验证码
      getCodeStatus: true,
      codeSecond: 60
    }
  },

  methods: {

    // 获取验证码
    getCode() {
      // 发送验证码请求，先检查邮箱是否有值
      this.$refs.registerForm.validateField(['mail'], errorMsg => {
        if (errorMsg) {
          this.$message.error(this.$t('register.sendCodeError') + ' ' + errorMsg)
          return false
        } else {
          this.fullScreenLoading = this.$loading({
            lock: true,
            text: 'Loading',
            spinner: 'el-icon-loading',
            background: 'rgba(0, 0, 0, 0.7)'
          })
          // 发送验证码请求
          getAuthCode({ 'mail': this.registerForm.mail }).then(res => {
            if (res.code === 200) {
              this.$message({
                message: this.$t('register.sendCodeSuccess'),
                type: 'success'
              })
              this.getCodeStatus = false
              this.timeObj = setInterval(() => {
                this.codeSecond--
                if (this.codeSecond < 1) {
                  this.getCodeStatus = true
                  this.codeSecond = 60
                  clearInterval(this.timeObj)
                }
              }, 1000 * 1)
            } else if (res.code === 409) {
              // 邮箱重复码 提示重复
              this.$message.error(this.$t('register.mailRepeat'))
            } else {
              this.$message.error(this.$t('register.sendCodeError'))
            }
          })
        }
      })
      this.fullScreenLoading.close()
    },

    // 显示密码原文
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

    // 处理注册
    handleRegister() {
      this.loading = true
      // 表单校验
      this.$refs.registerForm.validate(valid => {
        console.log('valid', valid)
        if (!valid) {
          return false
        } else {
          addAccount(this.registerForm).then(res => {
            console.log(res)
            if (res.code === 200) {
              // 注册成功，跳转登录页面
              this.$message({
                message: this.$t('register.registerSuccess'),
                type: 'success'
              })
              this.$router.push('/login')
            } else {
              this.$message.error(this.$t('register.registerError'))
            }
          })
        }
      })
      this.loading = false
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
