<template>
  <div class="app-container" style="text-align: center; width: 100%; height: 100%">
    <el-card shadow="nerver">
      <div
        style="width: 99%; margin-left: 13px; height: 90%"
        :data-intro="$t('addTaskIntro.step01')"
        data-step="1"
      >
        <div style="width: 93%; margin: 0 auto; text-align: left;">
          <el-form
            ref="elForm"
            :rules="rules"
            :model="task"
            :inline="true"
            label-position="right"
            label-width="200px"
          >
            <div>
              <el-card shadow="always" :header="$t('task.taskBaseParam')" style="margin-top:20px">
                <div :data-intro="$t('addTaskIntro.step02')" data-step="2">
                  <el-form-item :label="$t('task.taskName')" prop="task_name_show">
                    <el-input
                      v-model="task.task_name_show"
                      autocomplete="off"
                      clearable
                      show-word-limit
                      maxlength="25"
                      style="width: 650px"
                    />
                  </el-form-item>
                </div>
                <el-form-item label-position="right" :label="$t('task.taskDescription')">
                  <el-input
                    v-model="task.task_description"
                    type="textarea"
                    maxlength="100"
                    rows="3"
                    show-word-limit
                    clearable
                    style="width: 650px"
                  />
                </el-form-item>
                <br>
                <el-form-item :label="$t('dataset.isPublic')" style="text-align: left" prop="visibility">
                  <el-switch
                    v-model="task.visibility"
                    :active-text="$t('dataset.public')"
                    :inactive-text="$t('dataset.private')"
                    :active-value="1"
                    :inactive-value="0"
                  />
                </el-form-item>
              </el-card>
            </div>
            <!-- <el-form-item :label="$t('task.dataFile')" prop="data_file">
          <el-select v-model="task.data_file" style="float: left"  >
            <el-option
              v-for="file in fileList"
              :key="file.id"
              :label="file.file_name"
              :value="file.id"
            />
          </el-select>
        </el-form-item> -->
            <!-- 以下为任务执行参数配置 -->
            <el-card shadow="always" :header="$t('task.taskMustParam')" style="margin-top:20px">
              <span slot="header" class="card-title">
                {{ $t('task.taskMustParam') }}
                <el-link target="_blank" type="primary" href="https://github.com/LibCity/Bigscity-LibCity-Docs-zh_CN/blob/master/source/user_guide/data/dataset_for_task.md">
                  <span :data-intro="$t('addTaskIntro.step04')" data-step="4">
                    {{ $t('task.clickViewCorresponding') }}
                  </span>
                </el-link>
                <!-- {{ $t('dashboard.introduction') }} -->
              </span>
              <!-- <el-divider content-position="center">

              </el-divider> -->
              <div :data-intro="$t('addTaskIntro.step03')" data-step="3">
                <el-row :gutter="20">
                  <el-col :span="8">
                    <el-form-item :label="$t('task.task')" prop="task" label-width="100px">
                      <el-select
                        v-model="task.task"
                        style="float: left"
                        :placeholder="$t('common.pleasechoose')"
                        @change="onTaskChange"
                      >
                        <el-option
                          v-for="item in taskParamList"
                          :key="item.id"
                          :label="item.label"
                          :value="item.value"
                        />
                      </el-select>
                    </el-form-item>
                  </el-col>
                  <el-col :span="8">
                    <el-form-item :label="$t('task.model')" prop="model" label-width="100px">
                      <el-select v-model="task.model" default-first-option filterable style="float: left" :placeholder="$t('common.pleasechoose')">
                        <el-option
                          v-for="model in modelList"
                          :key="model"
                          :label="model"
                          :value="model"
                        />
                      </el-select>
                    </el-form-item>
                  </el-col>
                  <el-col :span="8">
                    <el-form-item :label="$t('task.dataset')" prop="dataset" label-width="100px">
                      <el-select v-model="task.dataset" filterable style="float: left" :placeholder="$t('common.pleasechoose')">
                        <el-option
                          v-for="file in fileList"
                          :key="file.id"
                          :label="file.file_original_name"
                          :value="file.file_name"
                        >
                          <el-tooltip :open-delay="500" class="item" effect="dark" :content="file.creator.toString()" placement="top">
                            <span style="float: left">{{ file.file_original_name }}</span>
                          </el-tooltip>
                        </el-option>
                      </el-select>
                    </el-form-item>
                  </el-col>
                </el-row>

              </div>
            </el-card>

            <!-- 以下非必填参数 -->
            <el-card shadow="always" :header="$t('task.taskNotMustParam')" style="margin-top:20px">
              <!-- <el-divider content-position="center">
                {{ $t('task.otherParamTip') }}
              </el-divider> -->
              <el-row :gutter="20">
                <el-col :span="8">
                  <!-- 最大训练轮数 -->
                  <el-form-item :label="$t('task.max_epoch')" prop="max_epoch" style="text-align: left" label-width="110px">
                    <el-popover
                      placement="top-start"
                      width="200"
                      trigger="hover"
                      :content="$t('task.maxEpochTip')"
                    >
                      <el-input-number slot="reference" v-model.number="task.max_epoch" controls-position="right" />
                    </el-popover>

                  </el-form-item>
                </el-col>
                <el-col :span="8">
                  <!-- 批次大小 -->
                  <el-form-item :label="$t('task.batch_size')" prop="batch_size" style="text-align: left" label-width="110px">
                    <el-input-number v-model.number="task.batch_size" controls-position="right" />
                  </el-form-item>
                </el-col>
                <el-col :span="8">
                  <!-- 学习率 -->
                  <el-form-item
                    :label="$t('task.learning_rate')"
                    prop="learning_rate"
                    label-width="150px"
                  >
                    <el-input v-model="task.learning_rate" />
                  </el-form-item>
                </el-col>
              </el-row>

              <el-row :gutter="20">
                <el-col :span="8">
                  <!-- 训练集所占比例 -->
                  <el-form-item :label="$t('task.train_rate')" prop="train_rate" label-width="110px">
                    <el-input v-model="task.train_rate" />
                  </el-form-item>
                </el-col>
                <el-col :span="8">
                  <!-- 验证集所占比例 -->
                  <el-form-item :label="$t('task.eval_rate')" prop="eval_rate" label-width="110px">
                    <el-input v-model="task.eval_rate" />
                  </el-form-item>
                </el-col>
                <el-col :span="8">
                  <!-- 是否保存训练好的模型 -->
                  <el-form-item :label="$t('task.saved_model')" style="text-align: left" label-width="160px">
                    <el-radio-group v-model="task.saved_model">
                      <el-radio :label="true">{{ $t('common.yes') }}</el-radio>
                      <el-radio :label="false">{{ $t('common.no') }}</el-radio>
                    </el-radio-group>
                  </el-form-item>
                </el-col>
              </el-row>

              <el-row :gutter="20">
                <el-col :span="8">
                  <!-- 是否使用GPU -->
                  <el-form-item :label="$t('task.gpu')" style="text-align: left" label-width="110px">
                    <el-radio-group v-model="task.gpu">
                      <el-radio :label="true">{{ $t('common.yes') }}</el-radio>
                      <el-radio :label="false">{{ $t('common.no') }}</el-radio>
                    </el-radio-group>
                  </el-form-item>
                </el-col>
                <el-col :span="8">
                  <!-- GPU编号 -->
                  <el-form-item v-if="task.gpu" :label="$t('task.gpu_id')" prop="gpu_id" style="text-align: left" label-width="110px">
                    <el-input-number v-model.number="task.gpu_id" controls-position="right" />
                  </el-form-item>
                </el-col>
                <!-- <el-col :span="8">
                  <div class="grid-content bg-purple" />
                </el-col> -->
              </el-row>

              <el-row :gutter="20">
                <el-col :span="8">
                  <!-- 是否使用以往实验保存的模型 -->
                  <el-form-item :label="$t('task.train')" style="text-align: left" label-width="110px">
                    <el-radio-group v-model="task.train">
                      <el-radio :label="true">{{ $t('common.yes') }}</el-radio>
                      <el-radio :label="false">{{ $t('common.no') }}</el-radio>
                    </el-radio-group>
                  </el-form-item>
                </el-col>
                <el-col :span="8">
                  <!-- expid实验ID -->
                  <el-form-item v-if="task.train == false" :label="$t('task.expId')" prop="exp_id" style="text-align: left" label-width="110px">
                    <el-input-number v-model.number="task.exp_id" controls-position="right" />
                  </el-form-item>
                </el-col>
                <!-- <el-col :span="8">
                  <div class="grid-content bg-purple" />
                </el-col> -->
              </el-row>

              <!-- 如果需要配置更多参数，可以上传配置文件 -->
              <el-divider content-position="center">{{ $t('task.taskMoreParamTip') }}</el-divider>
              <el-form-item :label="$t('task.config_file')" :data-intro="$t('addTaskIntro.step05')" data-step="5">
                <!-- <el-button-group> -->
                <el-upload
                  ref="upload"
                  style="text-align: left"
                  class="upload-demo"
                  :action="BASE_API + '/business/task/upload/'"
                  name="config"
                  :limit="fileLimit"
                  :on-success="handleFileUploadSuccess"
                  :before-upload="handleBeforeUpload"
                  :on-exceed="handleOnExceed"
                  accept="application/json"
                >
                  <el-button slot="trigger" size="small" type="primary"> {{ $t('task.clickUpload') }}</el-button>
                  <!-- <div slot="tip" class="el-upload__tip">{{ $t('task.uploadTips') }}
              <a :href="BASE_API + '/business/task/download_config/'" style="margin-left: 10px;">
                <el-button type="info" size="mini" icon="el-icon-download">{{ $t('task.downloadExample') }}
                </el-button>
              </a>
            </div> -->
                  <a :href="BASE_API + '/business/task/download_config/'" style="margin-left: 10px;">
                    <el-button type="info" size="mini" icon="el-icon-download">
                      {{ $t('task.downloadExample') }}
                    </el-button>
                  </a>
                  <br>
                  <!-- <span v-if="task.config_file !== null">
                <el-link type="primary" :underline="false" :href="BASE_API + '/business/task/' + task.id + '/download_task_config/'">
                  {{ $t('task.clickDownload') }}
                </el-link>
                <el-link style="margin-left: 10px" type="primary" :underline="false" @click="catConfig(task.id)">
                  {{ $t('task.clickCatConfig') }}
                </el-link>
              </span> -->
                </el-upload>

              <!-- </el-button-group> -->
              </el-form-item>
              <el-form-item v-if="task.config_file" style="text-align: left" :label="$t('task.uploadedConfigFile')">
                <el-link type="primary" :underline="false" :href="BASE_API + '/business/task/' + task.id + '/download_task_config/'">
                  {{ $t('task.clickDownload') }}
                </el-link>
                <el-link style="margin-left: 10px" type="primary" :underline="false" @click="catConfig(task.id)">
                  {{ $t('task.clickCatConfig') }}
                </el-link>
              </el-form-item>
            </el-card>
          </el-form>
          <div style="text-align: center; margin-top: 10px">
            <el-button
              @click="resetForm()"
            >{{ $t('common.clear') }}</el-button>
            <el-button
              :data-intro="$t('addTaskIntro.step06')"
              style="margin-left: 20px"
              data-step="6"
              type="primary"
              @click="submit()"
            >{{ $t('common.confirm') }}</el-button>
          </div>

        </div>
      </div>
    </el-card>

    <!-- 配置文件查看弹出框 -->
    <el-dialog
      :title="$t('task.configview')"
      :visible.sync="configDialogVisible"
      width="80%"
      class="dialog-div"
      style="text-align: left"
    >
      <!-- <div style="white-space: pre-line; margin: 20px" v-html="configData" /> -->
      <pre style="margin: 20px; background-color: black; color: white; font-family: Consolas; font-size: 16px; padding: 10px">{{ configData }}</pre>
      <span slot="footer" class="dialog-footer">
        <el-button @click="configDialogVisible = false">{{ $t('common.cancel') }}</el-button>
        <!-- <a style="margin-left: 10px" :href="BASE_API + '/business/task/' + task.id + '/download_log/'">
          <el-button type="primary" icon="el-icon-download">
            {{ $t('task.downloadLog') }}
          </el-button></a> -->
      </span>
    </el-dialog>
  </div>
</template>
<script>
import { getFileListAll } from '@/api/file'
import { addTask, taskExists, getTaskById, updateTaskById, getConfigDataById, getTaskModelConfig } from '@/api/task'
import { getSimpleAccountList } from '@/api/account'
export default {
  data() {
    // 任务名称校验
    const validateTaskName = (rule, value, callback) => {
      if (!value || value.length === 0) {
        callback(new Error(this.$t('task.taskNameError')))
      } else {
        var temp_obj = {}
        temp_obj.task_name = this.curUserName + '_' + value
        taskExists(temp_obj).then(res => {
          if (res.code !== 200 && this.task.id !== res.msg.id) {
            callback(new Error(this.$t('task.taskNameExistsError')))
          } else {
            callback()
          }
        })
      }
    }
    // 大于 0 的整数校验
    const validateMaxEpoch = (rule, value, callback) => {
      // 必须是大于0的整数
      if (typeof (value) !== 'undefined') {
        if (typeof (value) !== 'number') {
          callback(new Error(this.$t('task.numberError')))
        } else if (value % 1 !== 0) {
          callback(new Error(this.$t('task.maxEpochNumberError')))
        } else if (value < 0) {
          callback(new Error(this.$t('task.maxEpochError')))
        } else {
          callback()
        }
      } else {
        callback()
      }
    }
    // 小数校验
    const validateFloat = (rule, value, callback) => {
      // 必须是小数
      if (typeof (value) !== 'undefined') {
        var regs = /^(-?\d+)(\.\d+)?$/
        if (!regs.test(value) || value % 1 === 0) {
          callback(new Error(this.$t('task.floatError')))
        } else if (value < 0) {
          callback(new Error(this.$t('task.maxEpochError')))
        } else {
          callback()
        }
        // if (typeof (value) !== 'number') {
        //   callback(new Error(this.$t('task.numberError')))
        // } else if (value % 1 === 0) {
        //   callback(new Error(this.$t('task.floatError')))
        // } else if (value < 0) {
        //   callback(new Error(this.$t('task.maxEpochError')))
        // } else {
        //   callback()
        // }
      } else {
        callback()
      }
    }
    return {
      BASE_API: window.global_url.Base_url,
      curUserName: this.$store.getters.name,
      paramId: this.$route.params.id,
      // 任务默认值
      task: {
        task_name: '',
        max_epoch: 1,
        task: 'traffic_state_pred',
        model: 'GRU',
        gpu: true,
        gpu_id: 0,
        saved_model: true,
        train: true
      },
      configDialogVisible: false,
      configData: '',
      fileLimit: 1,
      formLabelWidth: '10%',
      fileList: [],
      accountList: [],
      // taskModelDict: {
      //   'traffic_state_pred': [
      //     'GRU', 'ACFM', 'STResNet', 'DSAN', 'ACFMCommon', 'STResNetCommon', 'RNN', 'FNN', 'AutoEncoder',
      //     'Seq2Seq', 'AGCRN', 'ASTGCNCommon', 'MSTGCNCommon', 'STSGCN', 'CONVGCNCommon', 'ToGCN', 'MultiSTGCnetCommon',
      //     'STNN', 'ASTGCN', 'MSTGCN', 'CONVGCN', 'DGCN', 'ResLSTM', 'MultiSTGCnet', 'CRANN', 'STDN', 'DCRNN',
      //     'STGCN', 'GWNET', 'MTGNN', 'STMGAT', 'TGCN', 'ATDM', 'HGCN', 'DKFN', 'STTN', 'GTS', 'GMAN', 'STAGGCN',
      //     'TGCLSTM', 'DMVSTNet', 'CCRNN', 'STG2Seq', 'GEML', 'CSTN', 'GSNet'],
      //   'traj_loc_pred': [
      //     'FPMC', 'RNN', 'ST-RNN', 'ATST-LSTM', 'DeepMove', 'HST-LSTM', 'LSTPM', 'STAN',
      //     'GeoSAN', 'SERM', 'CARA'],
      //   'eta': [
      //     'DeepTTE', 'TTPNet'
      //   ],
      //   'map_matching': ['STMatching', 'IVMM', 'HMMM'],
      //   'road_representation': ['ChebConv', 'LINE']
      // },
      taskModelDict: {},
      // modelList: ['CRANN', 'DeepTTE', 'IVMM', 'GeoSAN', 'AutoEncoder', 'MultiSTGCnet', 'DKFN', 'FNN', 'GWNET', 'MSTGCN', 'STTN', ' STNN', 'RNN', 'MSTGCNCommon', 'CONVGCNCommon', 'STGCN', 'GSNet', 'FPMC', 'HMMM', 'GTS', 'STMGAT', 'DMVSTNet', 'ASTGCN', 'ToGCN', 'DSAN', 'ATST-LSTM', 'ChebConv', 'MultiSTGCnetCommon', 'CCRNN', 'TGCN', 'STDN', 'ST-RNN', 'ATDM', 'SERM', 'DCRNN', 'DeepMove', 'LINE', ' GMAN', 'CARA', 'CSTN', ' ASTGCN', 'ACFM', 'MTGNN', 'STMatching', 'STAGGCN', 'TTPNet', 'HGCN', 'ACFMCommon', ' ATST-LSTM', 'STResNet', 'STResNetCommon', 'STNN', 'CONVGCN', ' ASTGCNCommon', 'GEML', 'STG2Seq', 'STAN', 'HST-LSTM', 'GMAN', ' STAGGCN', 'LSTPM', 'STSGCN', 'ResLSTM', 'AGCRN', 'Seq2Seq', 'DGCN', 'ASTGCNCommon', 'TGCLSTM'],
      modelList: [],
      // modelList: this.taskModelDict['traffic_state_pred'],
      taskParamList: [
        { id: '1', label: this.$t('task.traffic_state_pred'), value: 'traffic_state_pred' },
        { id: '2', label: this.$t('task.traj_loc_pred'), value: 'traj_loc_pred' },
        { id: '3', label: this.$t('task.road_representation'), value: 'road_representation' },
        { id: '4', label: this.$t('task.eta'), value: 'eta' },
        { id: '5', label: this.$t('task.map_matching'), value: 'map_matching' }],
      rules: {
        task_name_show: [{ required: true, trigger: 'blur', validator: validateTaskName }],
        task: [{ required: true, message: this.$t('task.taskError') }],
        model: [{ required: true, message: this.$t('task.modelError') }],
        dataset: [{ required: true, message: this.$t('task.datasetError') }],
        batch_size: [{ required: false, validator: validateMaxEpoch }],
        train_rate: [{ required: false, validator: validateFloat }],
        eval_rate: [{ required: false, validator: validateFloat }],
        learning_rate: [{ required: false, validator: validateFloat }],
        max_epoch: [{ required: false, validator: validateMaxEpoch }],
        gpu_id: [{ type: 'number', message: this.$t('task.numberError') }]
      }
    }
  },
  computed: {
    isEdit() {
      return this.$store.state.app.language // 需要监听的数据
    }
  },
  watch: {
    isEdit(newVal, oldVal) {
      console.log(newVal, oldVal)
    }
  },
  mounted() {
    // // 新手引导
    // this.$intro.start() // start the guide
    // this.$intro.showHints() // show hints
    this.$nextTick(() => {
      if (localStorage.getItem('addTaskNew') === null || localStorage.getItem('addTaskNew') !== '1') {
        this.$intro.start()
        localStorage.setItem('addTaskNew', 1)
      }
    })
  },

  created() {
    if (this.$route.params && this.$route.params.id) {
      // 从路径获取id值
      const id = this.$route.params.id
      // 修改按钮
      // this.submitButton = '立即修改'
      // 调用回显
      this.getById(id)
    }
    // 获取数据集文件列表
    this.getList()
    // 初始化任务和模型选择器
    this.initSelect()
  },
  updated() {
    // 在updated里面更新数组会触发死循环
    // this.taskParamList = [
    //   { id: '1', label: this.$t('task.traffic_state_pred'), value: 'traffic_state_pred' },
    //   { id: '2', label: this.$t('task.traj_loc_pred'), value: 'traj_loc_pred' },
    //   { id: '3', label: this.$t('task.road_representation'), value: 'road_representation' },
    //   { id: '4', label: this.$t('task.eta'), value: 'eta' },
    //   { id: '5', label: this.$t('task.map_matching'), value: 'map_matching' }]
  },
  methods: {
    // 查看配置文件信息
    catConfig(id) {
      this.task.id = id
      this.configDialogVisible = true
      getConfigDataById(id).then(res => {
        this.configData = res.data
      })
    },
    initSelect() {
      // 获取任务模型对应关系
      getTaskModelConfig()
        .then(res => {
          console.log(res)
          this.taskModelDict = res.data
          this.modelList = this.taskModelDict[this.task.task]
          // this.task.model = this.modelList[0]
        })
    },
    onTaskChange(curValue) {
      // console.log('change:', curValue)
      // console.log('model:', this.taskModelDict[curValue])
      this.modelList = this.taskModelDict[curValue]
      this.task.model = this.modelList[0]
    },
    // 解决el-input-number将null值处理为0的bug
    numberToEmpty(data) {
      for (var index in data) {
        if (data[index] === null) {
          data[index] = undefined
        }
      }
      return data
    },
    // 获取数据集list
    getList() {
      getFileListAll().then(res => {
        this.fileList = res.data
        getSimpleAccountList().then(res => {
          this.accountList = res.data
          // 根据 fileList 的 creator 和  accountList 的 id 赋值 creator 为 accountList 的 account_number
          this.fileList.forEach(item => {
            this.accountList.forEach(account => {
              if (item.creator === account.id) {
                item.creator = account.account_number
              }
            })
          })
        })
      })
    },
    // 回显任务数据
    getById(id) {
      getTaskById(id).then(res => {
        this.task = this.numberToEmpty(res.data)
      })
    },
    submit() {
      this.$refs['elForm'].validate(valid => {
        if (!valid) {
          this.loading = false
          return
        }
        const loading = this.$loading({
          lock: true,
          text: 'Loading',
          spinner: 'el-icon-loading',
          background: 'rgba(0, 0, 0, 0.7)'
        })
        // 判断是更新还是新增
        this.task.task_name = this.curUserName + '_' + this.task.task_name_show
        // 赋值真正的 config_file
        this.task.config_file = this.task.tmp_config_file
        if (this.task.id) {
          updateTaskById(this.task.id, this.task).then(res => {
            this.$message.success(this.$t('task.taskUpdateSuccess'))
            // 路由跳转到list
            this.$router.push({ path: '/taskList/index' })
          })
        } else {
          addTask(this.task).then(res => {
            if (res.code === 201) {
              this.$message.success(this.$t('task.taskCreateSuccess'))
              // 路由跳转到list
              this.$router.push({ path: '/taskList/index' })
            } else {
              this.$message.error(this.$t('task.taskCreateError'))
              this.task.config_file = null
            }
          })
        }
        loading.close()
      })
    },
    resetForm() {
      this.$refs['elForm'].clearValidate()
      this.$refs['upload'].clearFiles()
      this.$refs['elForm'].resetFields()
      this.task = {
        task_name: '',
        max_epoch: 1,
        task: 'traffic_state_pred',
        model: 'GRU',
        gpu: true,
        gpu_id: 0,
        saved_model: true,
        train: true
      }
    },

    // 文件上传相关
    // 上传成功，刷新页面
    handleFileUploadSuccess(response) {
      // this.task.config_file = response.data
      this.task.tmp_config_file = response.data
      this.$message.success(this.$t('dataset.uploadSuccess'))
    },
    // 上传之前，检查文件类型
    handleBeforeUpload(file) {
      var isJson = file.type === 'application/json'
      if (!isJson) {
        this.$message.error(this.$t('task.uploadError'))
      }
      return isJson
    },
    // 文件超出最大个数
    handleOnExceed() {
      this.$message.error(this.$t('task.OnExceedError'))
    }
  }
}
</script>
<style scoped>
/* dialog进度条 */
/* 使顶部进行吸顶 */
.dialog-div .top {
  position: sticky;
  position: -webkit-sticky;
  top: 0px;
 }

/* 表单大小设置 */
.dialog-div .el-dialog {
  margin: 0 auto !important;
  height: 90%;
  overflow: hidden;
}

.dialog-div .el-dialog__body {
  position: absolute;
  left: 0;
  top: 54px;
  bottom: 70px;
  right: 0;
  padding: 0;
  z-index: 1;
  overflow: hidden;
  overflow-y: auto;
}
/**表单 确定和取消 按钮的位置 */
.dialog-div .el-dialog__footer {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
}

/* 弹出框滚动条 */
/* 设置滚动条的样式 */
/**解决了滚动条之间发生错位的现象 */
::-webkit-scrollbar {
  width: 10px !important;
  height: 10px !important;
  border-radius: 5px;
}
::-webkit-scrollbar-thumb {
  border-radius: 5px;
  -webkit-box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.2);
  /* 滚动条的颜色 */
  background-color: #e4e4e4;
 }
</style>
<style lang="scss" scoped>
.requiredBox {

  ::v-deep .el-form-item__label {

    transform: translateX(-10px);
  }
}
// .el-form-item__label-wrap {
//   margin-left: 0px !important;
// }
</style>
