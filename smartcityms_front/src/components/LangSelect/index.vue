<template>
  <!-- <el-tooltip class="item" effect="dark" :content="$t('common.selectLanguage')" placement="bottom" :open-delay="delay"> -->
  <el-dropdown trigger="click" class="international" @command="handleSetLanguage">
    <div>
      <svg-icon class-name="international-icon" icon-class="language" />
    </div>
    <el-dropdown-menu slot="dropdown">
      <el-dropdown-item :disabled="language==='zh'" command="zh">
        中文
      </el-dropdown-item>
      <el-dropdown-item :disabled="language==='en'" command="en">
        English
      </el-dropdown-item>
      <!-- <el-dropdown-item :disabled="language==='es'" command="es">
        Español
      </el-dropdown-item>
      <el-dropdown-item :disabled="language==='ja'" command="ja">
        日本語
      </el-dropdown-item> -->
    </el-dropdown-menu>
  </el-dropdown>
  <!-- </el-tooltip> -->
</template>

<script>
import i18n from '@/lang'

export default {
  inject: ['reload'],

  data() {
    return {
      delay: 500
    }
  },
  computed: {
    language() {
      return this.$store.getters.language
    }
  },
  methods: {
    handleSetLanguage(lang) {
      this.$i18n.locale = lang
      this.$store.dispatch('app/setLanguage', lang)
      this.$message({
        message: i18n.t('test.switchLanguageSuccess'),
        type: 'success'
      })
      // 刷新页面
      // location.reload()
      this.reload()
    }
  }
}
</script>
