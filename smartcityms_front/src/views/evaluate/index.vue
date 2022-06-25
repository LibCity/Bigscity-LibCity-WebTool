<template>
  <div class="app-container">
    <div v-for="data in lineData" :key="data.id" style="margin-top: 10px">
      <chart :chartid="data.id" :data="data" />
    </div>
  </div>
</template>
<script>
import chart from '@/components/chart'
import { getStateLineData, getOtherLineData } from '@/api/task'
export default {
  components: {
    chart
  },
  data() {
    return {
      lineData: {},
      queryParam: { task: '' }
    }
  },
  created() {
    const loading = this.$loading({
      lock: true,
      text: 'Loading',
      spinner: 'el-icon-loading',
      background: 'rgba(0, 0, 0, 0.7)'
    })
    // 获取参数
    if (this.$route.query && this.$route.query.taskIds && this.$route.query.taskType) {
      this.queryParam.task = this.$route.query.taskIds
      if (this.$route.query.taskType === 'traffic_state_pred') {
        console.log('交通状态预测')
        this.getStateEavluateLineData()
      } else {
        console.log('轨迹下一跳、到达时间估计、路网匹配')
        this.queryParam.taskType = this.$route.query.taskType
        this.getOtherEavluateLineData()
      }
    } else {
      this.$message.error('参数错误')
    }
    loading.close()
  },
  methods: {
    // 获取交通状态预测任务的折线图数据
    getStateEavluateLineData() {
      getStateLineData(this.queryParam).then(res => {
        this.lineData = res.data
      })
    },
    // 获取轨迹下一跳、到达时间估计和路网匹配的折线图数据
    getOtherEavluateLineData() {
      getOtherLineData(this.queryParam).then(res => {
        this.lineData = res.data
      })
    }
  }
}
</script>
<style scope>
    .line-wrap{
        width:50%;
        height:500px;
    }
</style>
