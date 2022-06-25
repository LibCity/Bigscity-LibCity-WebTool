/* eslint-disable vue/prop-name-casing */
<template>
  <!-- <div class="app-container">
    <div :id="chartid" class="line-wrap" />
  </div> -->
  <div class="parent">
    <!-- 图表 -->
    <div :id="chartid" class="div1" style="width: 100%; margin: 0 auto" />

    <!-- x轴按钮组 -->
    <div class="div2">
      <el-checkbox-group v-model="selectList">
        <div v-for="item in option.xAxis[0].data" :key="item">
          <el-tooltip v-if="item.length >= 21" :content="String(item)" placement="top" :open-delay="tooltipDelay">
            <el-checkbox :label="item">
              {{ cutWord(item) }}
            </el-checkbox>
          </el-tooltip>
          <el-checkbox v-else :label="item">
            {{ cutWord(item) }}
          </el-checkbox>
        </div>
      </el-checkbox-group>
    </div>

  </div>
</template>
<script>
import * as echarts from 'echarts'
export default {
  // eslint-disable-next-line vue/require-prop-types
  // props: ['chartid', 'data'],
  props: {
    // eslint-disable-next-line vue/require-default-prop
    data: Object,
    // eslint-disable-next-line vue/require-default-prop
    chartid: String
  },

  data() {
    return {
      chartLine: null,
      selectList: this.data.xdata,
      dictList: [],
      currentOption: {},
      isOneToOne: false,
      tooltipDelay: 300,
      option: {
        title: {
          show: true,
          text: ''
          // 标题居中
          // left: 'center'
        },
        tooltip: {
          trigger: 'axis'
        },
        legend: {
          // type: 'scroll',
          // orient: 'vertical',
          // left: 'right',
          // top: '20%',
          // top: -10,
          // bottom: 20,
          data: [],
          width: '60%',
          // 最如果太长就...
          formatter: function(value) {
            if (value.length >= 11) {
              return value.substr(0, 10) + '...'
            } else {
              return value
            }
          },
          tooltip: {
            show: true
          }
        },
        calculable: true,
        xAxis: [
          {
            type: 'category',
            boundaryGap: true,
            axisTick: {
              show: false,
              lineStyle: {
                type: 'dashed'
              }
            },
            // 坐标轴线相关设置
            axisLine: {
              show: true
            },
            axisLabel: {
              interval: 0,
              // rotate: 40,
              // 最如果太长就...
              formatter: function(value) {
                if (value.length >= 11) {
                  return value.substr(0, 10) + '...'
                } else {
                  return value
                }
              },
              color: '#333'
            },
            // 点击事件
            // triggerEvent: true,
            data: []
          }
        ],
        yAxis: [
          {
            type: 'value',
            axisTick: {
              show: false,
              lineStyle: {
                type: 'dashed'
              }
            },
            // 坐标轴线相关设置
            axisLine: {
              show: true
            },
            name: ''
          }
        ],
        series: [],
        // 工具栏
        toolbox: {
          show: true,
          feature: {
            myTool1: {
              show: true,
              title: '还原',
              icon:
                'path://M512 981.333333c-209.866667 0-396.693333-126.026667-466.293333-314.08a35.52 35.52 0 0 1 23.626666-44.426666 38.613333 38.613333 0 0 1 48 20.693333c58.666667 158.933333 217.013333 265.493333 394.666667 265.6s336-106.666667 394.666667-266.133333a37.6 37.6 0 0 1 28.853333-23.626667 38.986667 38.986667 0 0 1 35.786667 11.946667 34.773333 34.773333 0 0 1 7.146666 35.36c-69.386667 188.373333-256.48 314.666667-466.453333 314.666666z m431.36-574.08a37.92 37.92 0 0 1-35.946667-24.266666C849.386667 222.56 690.613333 114.88 512 114.72S174.72 222.346667 116.746667 382.773333A38.72 38.72 0 0 1 69.333333 403.733333a35.786667 35.786667 0 0 1-24.106666-44.373333C113.333333 169.866667 301.013333 42.666667 512 42.666667s398.666667 127.306667 467.146667 316.96a34.56 34.56 0 0 1-4.906667 32.64 38.933333 38.933333 0 0 1-30.88 14.986666z',
              onclick: () => {
                // const chart = echarts.init(document.getElementById(this.chartid), null, {
                //   height: 500
                // })
                // 还原
                this.chartLine.clear()
                this.chartLine.setOption(this.option)
                // 右侧复选框还原
                this.selectList = this.data.xdata
                // 传值
                this.$emit('init')
                console.log('click')
              }
            },
            // dataZoom: {
            //   yAxisIndex: 'none'
            // },
            dataView: { readOnly: false },
            magicType: { type: ['line', 'bar'] },
            // restore: {},
            saveAsImage: {}
          }
        },
        axisPointer: {
          link: [
            {
              xAxisIndex: 'all'
            }
          ],
          label: {
            backgroundColor: '#777'
          }
        }
      }
    }
  },

  watch: {
    // 监控数据的变化，及时改变折线图
    data: function(newData, oldData) {
      console.log('监听到data变了')
      this.changeChartOption()
      console.log('当前option:', this.option)
      // 使用刚指定的配置项和数据显示图表
      this.chartLine.setOption(this.option)
    },

    // 监控x轴复选框的变化
    selectList: function(newData, oldData) {
      console.log('复选框变了')
      console.log('newData:', newData)
      // 以新数据的list为准，重新给option设置x轴和y轴数据
      // 先清空x轴和y轴数据
      this.currentOption.xAxis[0].data = []
      this.currentOption.series.forEach((item, index) => {
        item.data = []
      })
      // 遍历已选择的x轴数据，重新赋值
      // 排序再遍历
      var currentList = this.deepCopy(this.selectList)
      // 多对多时需要排序
      if (!this.isOneToOne) {
        currentList = currentList.map(Number).sort(function(x, y) {
          if (x < y) {
            return -1
          }
          if (x > y) {
            return 1
          }
          return 0
        })
      }

      // 要先存储一下当前char是折线还是柱形图
      var charType = this.chartLine.getOption().series[0].type

      if (this.isOneToOne) {
        // 一对一的情况
        // 根据字典顺序赋值，顺序不会乱
        this.dictList.forEach((dictValue, index) => {
          currentList.forEach((x, index) => {
            if (dictValue.x === x) {
              console.log('x: ', x)
              this.currentOption.xAxis[0].data.push(x)
              this.currentOption.series[0].data.push(dictValue.value)
              this.currentOption.series[0].type = charType
            }
          })
        })
      } else {
        // 一对多的情况
        currentList.forEach((x, index) => {
          console.log('index:', index, ' x: ', x)
          // 查字典赋值
          this.dictList.forEach((dictValue, index) => {
            if (dictValue.x === x) {
              if (!this.currentOption.xAxis[0].data.includes(x)) {
                this.currentOption.xAxis[0].data.push(x)
              }
              this.currentOption.series.forEach((modelData, index) => {
                if (modelData.name === dictValue.modelName) {
                  modelData.data.push(dictValue.value)
                  modelData.type = charType
                }
              })
            }
          })
        })
      }
      // 重新set
      this.chartLine.setOption(this.currentOption)
      console.log('oldData:', oldData)
    }
  },

  updated() {
    // 暂不考虑国际化重新渲染的问题
    // console.log('updated')
    // if (this.$store.state.app.language === 'zh') {
    //   this.changeChartOption()
    // } else {
    //   this.changeChartOption()
    // }
  },

  mounted() {
    console.log('组件data', this.data)
    this.changeChartOption()
    console.log('当前option:', this.option)
    // 使用刚指定的配置项和数据显示图表
    // this.chartLine.setOption(this.option)
    this.$nextTick(() => {
      this.drawLineChart()
    })
    // 构造x轴和value对应的字典
    // 要考虑一对多的情况，和一对一的情况
    var current_data = this.data.data
    if (current_data.length === 1) {
      // 一对一，构造个字典完事了 [ {'x': RNN, 'value': 23} ]
      current_data.forEach((item, index) => {
        item.data.forEach((value, index) => {
          var tmpObj = {}
          tmpObj.x = this.data.xdata[index]
          tmpObj.value = value
          this.dictList.push(tmpObj)
        })
      })
      this.isOneToOne = true
      console.log('一对一')
      console.log('dictList:', this.dictList)
    } else if (current_data.length > 1) {
      // 一对多，构造一个对象，到时候一个值一个值往里push，[ { 'modelName': 'RNN', 'x': 1, 'value': 21} ]
      current_data.forEach((item, index) => {
        var modelName = item.name
        item.data.forEach((value, index) => {
          var tmpObj = {}
          tmpObj.modelName = modelName
          tmpObj.x = index + 1
          tmpObj.value = value
          this.dictList.push(tmpObj)
        })
      })
    }
  },

  methods: {
    drawLineChart() {
      this.chartLine = echarts.init(document.getElementById(this.chartid), null, {
        height: 500
      })// 基于准备好的dom，初始化echarts实例
      // 使用刚指定的配置项和数据显示图表
      this.chartLine.setOption(this.option)
      // TODO 点击删除达到可自定义
      // this.chartLine.on('click', 'xAxis.category', (params) => {
      //   console.log('params:', params)
      //   console.log('componentType:', params.componentType)
      //   console.log('name:', params.name)
      //   console.log('value:', params.value)
      //   console.log('value type:', typeof (params.value))
      //   console.log('value - 1:', params.value - 1)
      //   // 删除x轴此下标
      //   this.option.xAxis[0].data.splice(params.value - 1, 1)
      //   // 删除y轴对应值
      //   console.log('删除后的x轴：', this.option.xAxis[0].data)
      //   // 重新渲染
      //   this.chartLine.setOption(this.option)
      // })
    },

    changeChartOption() {
      this.option.title.text = this.$t('task.' + this.data.evaluate_name)
      if (this.data.legend) {
        this.option.legend.data = this.data.legend
      }
      this.option.xAxis[0].data = this.data.xdata
      this.option.yAxis[0].name = this.data.evaluate_name
      this.option.series = this.data.data
      // 深拷贝一份
      this.currentOption = this.deepCopy(this.option)
    },

    // 深拷贝
    deepCopy(obj) {
      if (typeof obj === 'function') {
        throw new TypeError('请传入正确的数据类型格式')
      }
      try {
        const data = JSON.stringify(obj)
        const newData = JSON.parse(data)
        return newData
      } catch (e) {
        console.log(e)
      }
    },

    // 文字过长处理方法
    cutWord(value) {
      if (value.length >= 21) {
        return value.substr(0, 20) + '...'
      } else {
        return value
      }
    }
  }
}
</script>
<style scope>
    .line-wrap{
        width:100%;
        height:100%;
    }
    .parent{
    display:flex;
    }
    .div1{
      width:80%;
      height:500px;
      flex:0 0 80%;
    }
    .div2{
      margin-left: 20px;
      margin-top: 20px;
      width:20%;
      height:500px;
      flex:0 0 20%;
    }
</style>
