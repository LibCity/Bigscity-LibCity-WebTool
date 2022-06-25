<template>
  <div style="height: auto">
    <iframe
      id="iframeBox"
      :src="reportUrl"
      frameborder="0"
      width="100%"
      height="auto"
      scrolling="auto"
      onload="this.height=1000"
    />
  </div>
</template>
<script>
import i18n from '@/lang'
export default {
  data() {
    return {
      reportUrl: ''
    }
  },
  // eslint-disable-next-line space-before-blocks
  mounted(){
    /**
     * iframe-宽高自适应显示
     */
    const oIframe = document.getElementById('iframeBox')
    // const deviceWidth = document.documentElement.clientWidth
    const deviceHeight = document.documentElement.clientHeight
    // oIframe.style.width = (Number(deviceWidth) - 220) + 'px' // 数字是页面布局宽度差值
    oIframe.style.height = (Number(deviceHeight) - 60) + 'px' // 数字是页面布局高度差
  },
  created() {
    if (this.$route.query && this.$route.query.taskId && this.$route.query.dataset) {
      console.log('taskId: ', this.$route.query.taskId)
      console.log('dataset: ', this.$route.query.dataset)
      const loading = this.$loading({
        lock: true,
        text: 'Loading',
        spinner: 'el-icon-loading',
        background: 'rgba(0, 0, 0, 0.7)'
      })
      // 调用回显
      this.reportUrl = this.$route.query.dataset + '_' + this.$route.query.taskId + '_result.html'
      loading.close()
      this.trajectoriesTip()
    } else {
      this.reportUrl = 'homepage.html'
    }
  },

  methods: {
    trajectoriesTip() {
      const trajectories = ['Gowalla', 'BrightKite', 'Fousquare', 'Instagram', 'Chengdu_Taxi_Sample1', 'Beijing_Taxi_Sample']
      const noList = ['LOOP_SEATTLE']
      var tip = true
      trajectories.forEach((item) => {
        tip = true
        if (this.reportUrl.toUpperCase().indexOf(item.toUpperCase()) !== -1) {
          // 不包含
          noList.forEach((item) => {
            if (this.reportUrl.toUpperCase().indexOf(item.toUpperCase()) !== -1) {
              tip = false
            }
          })
          // 弹窗提醒
          if (tip) {
            this.$notify.info({
            // title: i18n.t('dataset.gisSuccessfully'),
              message: i18n.t('dataset.trajTip'),
              duration: 10000
            })
          }
        }
      })
    }
  }
}
</script>
