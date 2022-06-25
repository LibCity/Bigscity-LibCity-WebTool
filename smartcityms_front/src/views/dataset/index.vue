<template>
  <div class="app-container" :data-intro="$t('addDataIntro.step01')" data-step="1">
    <div style="width: 99%; margin-left: 13px; height: 80%">
      <!-- 顶部查询表单 -->
      <div style="height: 80%" :data-intro="$t('addDataIntro.step02')" data-step="2">
        <el-form size="small" :inline="true" class="demo-form-inline">

          <el-form-item :label="$t('dataset.fileName')">
            <el-input v-model="queryParam.file_name" :placeholder="$t('dataset.pleaseInputFileName')" />
          </el-form-item>

          <el-form-item :label="$t('dataset.creator')">
            <el-select
              v-model="queryParam.creator"
              style="float: left"
              clearable
              filterable
              @change="onCreatorChange"
            >
              <el-option
                v-for="item in accountList"
                :key="item.id"
                :label="item.account_number"
                :value="item.id"
              />
            </el-select>
          </el-form-item>

          <el-form-item :label="$t('dataset.visibility')">
            <el-select
              v-model="queryParam.visibility"
              style="float: left"
              clearable
            >
              <el-option
                v-for="item in visibilityList"
                :key="item.id"
                :label="item.value"
                :value="item.id"
              />
            </el-select>
          </el-form-item>

          <!-- <el-form-item :label="$t('common.createTime')">
            <el-date-picker
              v-model="queryParam.begin"
              type="datetime"
              :placeholder="$t('common.pleaseSelectBegin')"
              value-format="yyyy-MM-dd HH:mm:ss"
              default-time="00:00:00"
            />
          </el-form-item>

          <el-form-item>
            <el-date-picker
              v-model="queryParam.end"
              type="datetime"
              :placeholder="$t('common.pleaseSelectEnd')"
              value-format="yyyy-MM-dd HH:mm:ss"
              default-time="00:00:00"
            />
          </el-form-item> -->
          <el-button type="primary" size="small" icon="el-icon-search" @click="getQueryList()">{{ $t('common.search') }}</el-button>
          <el-button type="default" size="small" icon="el-icon-delete" @click="resetData()">{{ $t('common.clear') }}</el-button>
        </el-form>
      </div>
      <!-- 样例数据下载 数据集上传按钮 查看数据说明按钮 -->
      <div style="float: right">
        <div style="width: 100%; height: 100%" :data-intro="$t('addDataIntro.step03')" data-step="3">
          <!-- 样例数据下载 -->
          <a :href="BASE_API + '/business/file/download/'">
            <el-button type="primary" size="small" icon="el-icon-download">
              {{ lable=$t('dataset.datasetDownload') }}
            </el-button></a>
          <!-- 查看数据说明 -->
          <a target="_blank" :href="$t('dataset.atomicExplainUrl')" style="margin-left: 10px">
            <el-button type="primary" size="small" icon="el-icon-info">
              {{ lable=$t('dataset.atomicExplain') }}
            </el-button></a>
          <!-- 数据集上传 -->
          <el-button
            style="margin-left: 10px"
            :disabled="addDisable"
            type="primary"
            size="small"
            icon="el-icon-circle-plus-outline"
            @click="dialogFormVisible = true"
          >
            {{ $t('dataset.fileUpload') }}
          </el-button>
        </div>
      </div>
      <div style="width: 100%; height: 60%;margin-top: 40px" :data-intro="$t('addDataIntro.step04')" data-step="4">
        <el-table
          v-loading="listLoading"
          :data="tableData"
          size="medium"
          fit
          border
        >
          <el-table-column
            type="index"
            :index="indexMethod"
            :label="$t('common.order')"
            width="120"
          />
          <af-table-column
            prop="file_original_name"
            :label="$t('dataset.fileName')"
            sortable
          />
          <af-table-column
            prop="creator"
            :label="$t('dataset.creator')"
            sortable
          />

          <af-table-column
            prop="file_size"
            :label="$t('dataset.fileSize')"
          />
          <!-- 公开 私有 状态 -->
          <el-table-column
            prop="visibility"
            :label="$t('dataset.visibility')"
            width="200"
          >
            <template slot-scope="scope">
              <el-switch
                v-if="currentUserName === scope.row.creator"
                v-model="scope.row.visibility"
                :active-value="1"
                :inactive-value="0"
                :active-text="$t('dataset.public')"
                :inactive-text="$t('dataset.private')"
                @change="visibilitySwitchChange($event, scope.row.id)"
              />
              <div v-else>
                <span v-if="scope.row.visibility === 1"> {{ $t('dataset.public') }} </span>
                <span v-if="scope.row.visibility === 0"> {{ $t('dataset.private') }} </span>
              </div>
            </template>
          </el-table-column>
          <af-table-column
            prop="create_time"
            :label="$t('common.createTime')"
            sortable
          />
          <!-- <el-table-column
            prop="update_time"
            :label="$t('common.updateTime')"
          /> -->
          <af-table-column
            :label="$t('common.operation')"
            width="200"
          >
            <template slot-scope="scope">
              <!--
                关于 scope.row.dataset_status 的状态说明：
                数据集错误，不能展示 --- -1
                正在解析运行中 --- 0
                geojson 生成完毕（可以选择底图渲染并可视化了） --- 1
                可视化 html 生成完毕 --- 2
                已经生成geojson但是没有进行可视化处理 --- 3
                正在生成geojson（检查是否可以进行可视化处理） --- 4
                用来表示完成html文件生成 --- 5
               -->
              <el-button-group>
                <!-- 删除按钮带确认提示 -->
                <el-popconfirm
                  :confirm-button-text="$t('common.confirm')"
                  :cancel-button-text="$t('common.cancel')"
                  confirm-button-type="danger"
                  cancel-button-type="info"
                  icon="el-icon-info"
                  icon-color="red"
                  :title="$t('common.deleteConfirm')"
                  @onConfirm="deleteFile(scope.row.id)"
                >
                  <!-- 当这个人有删除权限 并且 也是当前数据集的上传者的时候 展示删除按钮 -->
                  <el-link
                    v-if="!deleteDisable && currentUserName === scope.row.creator"
                    slot="reference"
                    style="margin-left: 10px"
                    :disabled="deleteDisable"
                    icon="el-icon-delete"
                  >
                    {{ $t('common.delete') }}
                  </el-link>
                </el-popconfirm>
                <el-link
                  style="margin-left: 10px"
                  icon="el-icon-download"
                  :href="BASE_API + '/business/file/' + scope.row.id + '/download_by_id/'"
                >
                  {{ $t('dataset.download') }}
                </el-link>
                <div v-intro-if="scope.$index === 0" :data-intro="$t('addDataIntro.step05')" data-step="5">
                  <div v-intro-if="scope.$index === 0" :data-intro="$t('addDataIntro.step06')" data-step="6">
                    <!-- 只有 2 或 5 的时候才能显示展示按钮 -->
                    <el-link
                      v-if="scope.row.dataset_status === 2 || scope.row.dataset_status === 5"
                      style="margin-left: 10px"
                      icon="el-icon-view"
                    >
                      <router-link :to="'/dataset/show_dataset/'+scope.row.file_name">
                        {{ $t('common.view') }}
                      </router-link>
                    </el-link>
                    <!-- -1 的时候代表后台出异常了,显示错误按钮 -->
                    <el-link
                      v-if="scope.row.dataset_status === -1"
                      icon="el-icon-error"
                      disabled
                      style="margin-left: 10px; color: red"
                    >{{ $t('dataset.showFail') }}</el-link>
                    <!-- 并且显示查看数据集错误信息按钮 -->
                    <el-link
                      v-if="scope.row.dataset_status === -1"
                      style="margin-left: 10px"
                      icon="el-icon-warning"
                      @click="showErrorInfo(scope.row)"
                    >
                      {{ $t('dataset.showErrorInfo') }}
                    </el-link>
                    <!-- 0 代表正在处理中 -->
                    <el-link
                      v-if="scope.row.dataset_status === 0"
                      disabled
                      style="margin-left: 10px"
                      icon="el-icon-loading"
                    >{{ $t('dataset.processing') }}</el-link>
                    <!-- 3 表示已经生成geojson了,但是没有渲染到html中,提醒渲染 -->
                    <el-link
                      v-if="scope.row.dataset_status === 3"
                      icon="el-icon-info"
                      disabled
                      style="margin-left: 10px; color: green"
                    >
                      {{ $t('dataset.Remainshow') }}
                    </el-link>
                    <!-- 4 表示正在生成geojson，也就是可视化检验中 -->
                    <el-link
                      v-if="scope.row.dataset_status === 4"
                      icon="el-icon-loading"
                      disabled
                      style="margin-left: 10px"
                    >
                      {{ $t('dataset.preprocessing') }}
                    </el-link>
                  </div>
                  <div v-intro-if="scope.row.dataset_status == 2 || scope.row.dataset_status == 1 || scope.row.dataset_status == 3" :data-intro="$t('addDataIntro.step07')" data-step="7" style="margin-left: 10px">
                    <!-- 1 2 5 的时候可以展示选择底图 -->
                    <el-link
                      v-if="scope.row.dataset_status == 1 || scope.row.dataset_status == 2 || scope.row.dataset_status == 3"
                      style="margin-right: 10px"
                      icon="el-icon-circle-plus-outline"
                      @click="openSekectMap(scope.row.id)"
                    >{{ $t('dataset.choosemap') }}
                    </el-link>
                  </div>
                </div>
              </el-button-group>

            </template>
          </af-table-column>
        </el-table>
      </div>
    </div>
    <!-- 分页组件 -->
    <div>
      <el-pagination
        :hide-on-single-page="false"
        :current-page="queryParam.page"
        :page-sizes="[10, 20, 50, 100, 200]"
        :page-size="queryParam.size"
        style="padding: 30px 0; text-align: center;"
        layout="total, sizes, prev, pager, next, jumper"
        :total="total"
        background
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </div>
    <!-- 添加/编辑 对话框 -->
    <el-dialog
      :destroy-on-close="true"
      :title="$t('dataset.fileUpload')"
      :visible.sync="dialogFormVisible"
    >
      <div style="margin: 0 atuo">
        <el-form ref="uploadForm" :model="uploadForm">
          <el-form-item :label="$t('dataset.isPublic')" prop="isPublic">
            <el-switch
              v-model="uploadForm.isPublic"
              :active-text="$t('dataset.public')"
              :inactive-text="$t('dataset.private')"
            />
          </el-form-item>
          <el-form-item :label="$t('dataset.selectFile')">
            <el-upload
              ref="elupload"
              :action="BASE_API + '/business/file/'"
              name="dataset"
              :data="uploadForm"
              :headers="uploadHeaders"
              :file-list="filelist"
              multiple
              drag
              :auto-upload="false"
              :on-success="handleFileUploadSuccess"
              :before-upload="handleBeforeUpload"
              accept="application/x-zip-compressed"
            >
              <i class="el-icon-upload" />
              <div class="el-upload__text">{{ $t('dataset.clickUpload') }}</div>
              <!-- <el-button size="small" type="primary"> {{ $t('dataset.clickUpload') }}</el-button> -->
              <div slot="tip" class="el-upload__tip">{{ $t('dataset.uploadTips') }}</div>
            </el-upload>
          </el-form-item>
          <el-row :gutter="20" type="flex" justify="center">
            <el-col :span="6">
              <el-button type="primary" size="medium" @click="submitUpload">{{ $t('dataset.submit') }}</el-button>
            </el-col>
            <el-col :span="6">
              <el-button type="primary" size="medium" @click="dialogFormVisible = false">{{ $t('common.cancel') }}</el-button>
            </el-col>
          </el-row>
        </el-form>
      </div>
    </el-dialog>
    <!-- 选择可视化底图 -->
    <el-dialog :title="$t('common.getview')" :visible.sync="showFormVisible">
      <el-form ref="elForm1" :rules="rules" :model="dataset" label-width="auto" label-position="left">
        <el-form-item :label="$t('dataset.background')" prop="background">
          <el-select v-model="background" :placeholder="$t('common.pleasechoose')">
            <el-option
              v-for="item in backgroundParamList"
              :key="item.id"
              :label="item.label"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
      </el-form>
      <el-button type="primary" icon="el-icon-view" @click="getBackground()">{{ $t('common.getview') }}</el-button>
    </el-dialog>

    <!-- 日志查看弹出框 -->
    <el-dialog
      :title="$t('dataset.errorMsgView')"
      :visible.sync="logDialogVisible"
      width="56%"
      class="dialog-div"
    >
      <!-- <div style="white-space: pre-line; margin: 20px" v-html="logData" /> -->
      <pre style="white-space: pre-line; margin: 20px; background-color: black; color: white; font-family: Consolas; font-size: 16px;  padding: 10px">{{ logData }}</pre>
      <span slot="footer" class="dialog-footer">
        <el-button @click="logDialogVisible = false">{{ $t('common.cancel') }}</el-button>
      </span>
    </el-dialog>
  </div>
</template>
<script>
import { getFileList, deleteFileById, generate_background_byID, updateFileVisibility } from '@/api/file'
import { getSimpleAccountList } from '@/api/account'
import { getToken } from '@/utils/auth'
import { checkPermission } from '@/utils/permission'
import i18n from '@/lang'

export default {
  data() {
    return {
      BASE_API: window.global_url.Base_url,
      logDialogVisible: false, // 日志查看弹出框
      logData: '', // 日志内容
      dataset: {
      },
      currentUserName: '',
      uploadForm: {
        isPublic: false
      }, // 上传表单数据对象
      uploadHeaders: {
        'Authorization': 'Bearer ' + getToken()
      },
      visibilityList: [{ id: 1, value: '公开' }],
      backgroundParamList: [
        { id: '1', label: this.$t('dataset.google') },
        { id: '2', label: this.$t('dataset.google_s') },
        { id: '3', label: this.$t('dataset.amap') },
        { id: '4', label: this.$t('dataset.amap_s') },
        { id: '5', label: this.$t('dataset.origin') },
        { id: '6', label: this.$t('dataset.traffic') },
        { id: '7', label: this.$t('dataset.transport') }],
      rules: {
        background: [{ required: false, message: this.$t('common.pleasechoose') }]
      },
      tableData: [],
      listLoading: true,
      background: '1',
      queryParam: {
        page: 1,
        size: 10,
        file_name: '',
        create_time: ''
      },
      total: 0,
      defaultPage: 1,
      defaultSize: 10,
      dialogFormVisible: false,
      showFormVisible: false,
      filelist: [],
      // 按钮权限
      addDisable: true,
      deleteDisable: true,
      listPermission: true,
      file: {},
      accountList: []
    }
  },
  mounted() {
    // // 新手引导
    // this.$intro.start() // start the guide
    // this.$intro.showHints() // show hints
    this.$nextTick(() => {
      setTimeout(() => {
        if (localStorage.getItem('addDatasetnew') === null || localStorage.getItem('addDatasetnew') !== '1') {
          this.$intro.start()
          localStorage.setItem('addDatasetnew', 1)
        }
      }, 300)
    })
  },

  created() {
    this.checkButtonPermission()
    // 如果发现没有 listPermission 就需要向其展示权限不足提示
    if (!this.listPermission) {
      this.$router.push('/forbidden/index')
    }
    this.getAccountList()
    this.getList(this.queryParam)
    this.currentUserName = this.$store.getters.name
  },
  methods: {
    checkPermission,
    checkButtonPermission() {
      this.addDisable = !checkPermission(['datasetUpload'])
      this.deleteDisable = !checkPermission(['datasetDelete'])
      this.listPermission = checkPermission(['datasetList'])
    },
    showErrorInfo(datasetObj) {
      this.logDialogVisible = true
      this.logData = datasetObj.error_message
    },
    // 公开私有按钮改变
    visibilitySwitchChange(newValue, datasetId) {
      updateFileVisibility(datasetId, newValue).then(res => {
        this.getList(this.queryParam)
      })
    },
    // 提交确认上传
    submitUpload() {
      this.$refs.elupload.submit()
    },
    // 搜索表单 - 上传者下拉框改变
    onCreatorChange(creatorId) {
      if (creatorId === this.$store.getters.id) {
        this.visibilityList = [{ id: 1, value: this.$t('dataset.public') },
          { id: 0, value: this.$t('dataset.private') }, { id: 2, value: this.$t('dataset.all') }]
      } else {
        this.visibilityList = [{ id: 1, value: this.$t('dataset.public') }]
        this.queryParam.visibility = this.visibilityList[0].id
      }
    },
    // 获取系统所有账户列表
    getAccountList() {
      getSimpleAccountList().then(res => {
        this.accountList = res.data
      })
    },
    // 获取数据集列表
    getList(queryParam) {
      this.listLoading = true
      getFileList(queryParam).then(res => {
        this.tableData = res.data.results
        this.total = res.data.count
        this.listLoading = false
      }).catch(() => {
        this.listLoading = false
      })
    },
    // 打开更换底图弹框
    openSekectMap(id) {
      this.file.id = id
      this.showFormVisible = true
    },
    // 更换底图
    getBackground() {
      // 点击就关闭，防止客户端多次提交
      this.showFormVisible = false
      generate_background_byID(this.file.id, this.background).then(res => {
        const fileId = this.file.id
        // 重新获取页面数据
        this.$message({
          message: this.$t('dataset.background_ing'),
          type: 'success'
        })
        // 开启长轮询
        this.title = i18n.t('dataset.gisSuccessfully')
        this.message = i18n.t('dataset.gisViewSuccessfully')
        this.longPolling(fileId)
        this.getList(this.queryParam)
      })
    },
    // 长轮询获取状态
    longPolling(fileId, title, message) {
      this.$axios.get(this.BASE_API + `/business/file/${fileId}/get_file_status/`).then(res => {
        if (res.data.code === 200) {
          if (res.data.data.dataset_status === -1) {
            var errorMsg = i18n.t('dataset.gisFailed')
            var errorTitle = i18n.t('dataset.gisFailedTitle')
            // 错误信息弹窗提醒
            this.$notify({
              title: errorTitle,
              message: res.data.data.original_file_name + errorMsg,
              type: 'error',
              duration: 10000
            })
          } else {
            // 弹窗提醒
            this.$notify({
              title: this.title,
              message: res.data.data.original_file_name + this.message,
              type: 'success',
              duration: 10000
            })
          }

          // 刷新list
          this.getList(this.queryParam)
          return
        } else {
          // 重新轮询
          this.$nextTick(() => {
            this.timeObj = setTimeout(() => {
              this.longPolling(fileId)
            }, 1000 * 5)
          })
        }
      })
    },
    getQueryList() {
      this.queryParam.page = this.defaultPage
      this.queryParam.size = this.defaultSize
      this.getList(this.queryParam)
    },
    deleteFile(id) {
      this.listLoading = true
      deleteFileById(id).then(res => {
        if (res.code === 400) {
          // 提示数据集正在被使用
          this.$message.error(this.$t('dataset.deletionFailed'))
        } else {
          // 重新获取页面数据
          this.$message({
            message: this.$t('common.deleteSucceeded'),
            type: 'success'
          })
          this.getList(this.queryParam)
        }
        this.listLoading = false
      }).catch(() => {
        this.listLoading = false
        this.$message.error(this.$t('common.deletionFailed'))
      })
    },
    // 文件上传相关
    // 上传成功，刷新页面
    handleFileUploadSuccess(response, file, filelist) {
      if (response.code >= 200 && response.code <= 300) {
        this.$message.success(this.$t('dataset.uploadSuccess'))
        // 遍历 filelist 判断 filelist 每个 item percentage 是否都为 100
        const allCompleted = filelist.every(item => {
          if (item.percentage === 100) {
            return true
          } else {
            return false
          }
        })
        if (allCompleted) {
          this.dialogFormVisible = false
        }
        this.getList(this.queryParam)
        this.title = i18n.t('dataset.canView')
        this.message = i18n.t('dataset.canViewSuccessfully')
        this.longPolling(response.data.id)
      } else if (response.code === 400) {
        // 数据集文件错误
        file.status = 'error'
        // 清空filelist
        filelist.splice(0, filelist.length)
        this.$message.error(this.$t('dataset.atomicError'))
      } else if (response.code === 409) {
        // 数据集重复
        file.status = 'error'
        // 清空filelist
        filelist.splice(0, filelist.length)
        this.$message.error(this.$t('dataset.datasetRepeatError'))
      }
    },
    // 上传之前，检查文件类型
    handleBeforeUpload(file) {
      // var isZip = file.type === 'application/x-zip-compressed'  // bug mac 上不能识别
      // 因为 .zip 格式可以有很多种：application/zip, application/octet-stream, application/x-zip-compressed, multipart/x-zip
      // 所以这里直接判断包含 zip 字符串即可
      // 判断 file.type 是否包含 zip 字符串
      var isZip = file.type.includes('zip')
      if (!isZip) {
        this.$message.error(this.$t('dataset.uploadError'))
      }
      return isZip
    },
    // 清空查询条件，重新获取数据
    resetData() {
      this.queryParam = {}
      this.queryParam.page = this.defaultPage
      this.queryParam.size = this.defaultSize
      this.getList(this.queryParam)
    },
    handleSizeChange(size) {
      this.queryParam.size = size
      this.defaultSize = size
      this.getList(this.queryParam)
    },
    handleCurrentChange(page) {
      this.queryParam.page = page
      this.getList(this.queryParam)
    },
    indexMethod(index) {
      return (this.queryParam.page - 1) * this.queryParam.size + index + 1
    }
  }
}
</script>
<style lang="scss" scoped>
.el-table {
	.el-table__header-wrapper, .el-table__fixed-header-wrapper {
		th {
			word-break: break-word;
			background-color: #f8f8f9;
			color: #515a6e;
			height: 40px;
			font-size: 13px;
		}
	}
	.el-table__body-wrapper {
		.el-button [class*="el-icon-"] + span {
			margin-left: 1px;
		}
	}
}
.el-table .fixed-width .el-button--mini {
	padding-left: 0;
	padding-right: 0;
	width: inherit;
}
</style>
