<template>
  <div class="app-container" style="text-align: center; width: 100%; margin-top: 20px">
    <div style="width: 50%; margin: 0 auto">
      <el-form
        ref="elForm"
        :model="formData"
        :rules="rules"
        size="medium"
        label-width="auto"
        label-position="left"
        :disabled="!bindEnable"
      >
        <!-- 邮箱 -->
        <el-form-item :label="$t('account.mail')" prop="mail">
          <el-input
            v-model="formData.mail"
            :placeholder="$t('register.inputMail')"
          />
        </el-form-item>

        <!-- 验证码 -->
        <el-form-item :label="$t('account.code')" prop="code">
          <el-row type="flex" :gutter="20">
            <el-col :span="18">
              <el-input
                v-model="formData.code"
                :placeholder="$t('register.inputCode')"
              />
            </el-col>
            <el-col align="bottom" :span="6">
              <el-link
                v-if="getCodeStatus"
                :underline="false"
                type="info"
                @click="getCode()"
              >
                <el-button type="default">
                  {{ $t('register.getCode') }}
                </el-button>
              </el-link>
              <el-link
                v-else
                :underline="false"
              >
                <el-button type="info">
                  {{ $t('register.getCode') }}({{ codeSecond }})
                </el-button>
              </el-link>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item size="large">
          <el-button :disabled="!bindEnable" :loading="loading" type="primary" @click="submitForm">{{ $t('common.submit') }}</el-button>
          <el-button @click="resetForm">{{ $t('common.clear') }}</el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>
<script>
import { getAuthCode, bindMail, getAccountById } from '@/api/account'
export default {
  data() {
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
      formData: {
        mail: '',
        code: ''
      },
      // 全屏loading
      fullScreenLoading: {},
      // 提交按钮 loading
      loading: false,
      // 是否允许获取验证码
      getCodeStatus: true,
      codeSecond: 60,
      // 表单校验规则
      rules: {
        mail: [
          { required: true, trigger: 'blur', validator: validateMail }
        ],
        code: [{ required: true, message: this.$t('register.pleaseInputCode'), trigger: 'blur' }]
      },
      // 是否允许绑定邮箱 flag
      bindEnable: true
    }
  },

  created() {
    this.checkAccount()
  },

  methods: {
    // 检查邮箱是否已经绑定，如果已经绑定则回显邮箱数据 并禁用 input 和 submit
    checkAccount() {
      getAccountById(this.$store.getters.id).then(res => {
        const mail = res.data.mail
        if (mail !== null && mail !== '' && mail.length !== 0) {
          this.formData.mail = res.data.mail
          this.bindEnable = false
          this.$message({
            message: this.$t('account.alreadyBindTip'),
            type: 'info'
          })
        }
      })
    },
    // 提交
    submitForm() {
      this.fullScreenLoading = this.$loading({
        lock: true,
        text: 'Loading',
        spinner: 'el-icon-loading',
        background: 'rgba(0, 0, 0, 0.7)'
      })
      bindMail(this.$store.getters.id, this.formData).then(res => {
        console.log(res)
        if (res.code === 200) {
          this.$message({
            message: this.$t('account.bindSuccess'),
            type: 'success'
          })
          this.fullScreenLoading.close()
          this.$router.push('/dashboard')
        } else {
          this.fullScreenLoading.close()
          this.$message.error(this.$t('account.bindError'))
        }
      })
      this.fullScreenLoading.close()
    },

    resetForm() {
      this.formData = {
        mail: '',
        code: ''
      }
    },

    // 获取验证码
    getCode() {
      if (!this.bindEnable) {
        return
      }
      // 发送验证码请求，先检查邮箱是否有值
      this.$refs.elForm.validateField(['mail'], errorMsg => {
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
          console.log('邮箱：', this.formData.mail)
          // 发送验证码请求
          getAuthCode({ 'mail': this.formData.mail }).then(res => {
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
    }
  }
}
</script>
<style lang="scss" scoped>

</style>
