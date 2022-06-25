<template>
  <div class="app-container" style="text-align: center; width: 100%;">
    <div style="width: 60%; margin: 0 auto">
      <el-form ref="elForm" :model="formData" :rules="rules" size="medium" label-width="auto" label-position="left">
        <el-form-item :label="$t('login.oldPassword')" prop="old_password">
          <el-input
            v-model="formData.old_password"
            clearable
            show-password
          />
        </el-form-item>
        <el-form-item :label="$t('login.newPassword')" prop="new_password">
          <el-input
            v-model="formData.new_password"
            clearable
            show-password
          />
        </el-form-item>
        <el-form-item :label="$t('login.repeatPassword')" prop="new_password_repeat">
          <el-input
            v-model="formData.new_password_repeat"
            clearable
            show-password
          />
        </el-form-item>
        <el-form-item size="large">
          <el-button :loading="loading" type="primary" @click="submitForm">{{ $t('common.submit') }}</el-button>
          <el-button @click="resetForm">{{ $t('common.clear') }}</el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>
<script>
import { updatePassword } from '@/api/account'
export default {
  data() {
    const validatePassword = (rule, value, callback) => {
      if (value.length < 6) {
        callback(new Error(this.$t('login.passwordError')))
      } else {
        callback()
      }
    }
    const validateRepeatPassword = (rule, value, callback) => {
      if (value.length < 6) {
        callback(new Error(this.$t('login.passwordError')))
      } else if (value !== this.formData.new_password) {
        callback(new Error(this.$t('login.repeatPasswordError')))
      } else {
        callback()
      }
    }
    return {
      formData: {
        old_password: '',
        new_password: '',
        new_password_repeat: ''
      },
      loading: false,
      itemLabelWidth: '150px',
      rules: {
        old_password: [{ required: true, trigger: 'blur', validator: validatePassword }],
        new_password: [{ required: true, trigger: 'blur', validator: validatePassword }],
        new_password_repeat: [{ required: true, trigger: 'blur', validator: validateRepeatPassword }]
      }
    }
  },
  created() {
    if (this.$store.state.app.language === 'zh') {
      this.itemLabelWidth = '150px'
    } else {
      this.itemLabelWidth = '250px'
    }
  },
  updated() {
    if (this.$store.state.app.language === 'zh') {
      this.itemLabelWidth = '150px'
    } else {
      this.itemLabelWidth = '250px'
    }
  },
  methods: {
    submitForm() {
      this.loading = true
      this.$refs['elForm'].validate(valid => {
        if (!valid) {
          this.loading = false
          return
        }
        updatePassword(this.formData).then(async(res) => {
          if (res.code === 200) {
            this.loading = false
            this.$message({
              message: this.$t('login.updatePasswordSuccess'),
              type: 'success'
            })
            await this.$store.dispatch('user/logout')
            this.$router.push(`/login`)
          } else {
            this.loading = false
            this.$message({
              message: this.$t('login.updatePasswordFail'),
              type: 'error'
            })
          }
        }).catch(e => {
          this.loading = false
          console.log('catch')
          console.log(e)
        })
      })
    },
    resetForm() {
      this.$refs['elForm'].resetFields()
    }
  }
}
</script>
<style>
.el-form-item--large .el-form-item__content {
    display: flex;
    justify-content: center;
    margin-left: 0 !important;
}
</style>
