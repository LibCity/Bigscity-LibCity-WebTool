<template>
  <div class="app-container" :data-intro="$t('taskIndexIntroL.step01')" data-step="1">
    <!-- 顶部查询表单 -->
    <el-form size="small" :inline="true" class="demo-form-inline" :data-intro="$t('taskIndexIntroL.step02')" data-step="2">

      <el-form-item class="mgl" :label="$t('task.taskName')">
        <el-input v-model="queryParam.task_name" />
      </el-form-item>

      <el-form-item class="mgl" :label="$t('task.dataset')">
        <el-input v-model="queryParam.dataset" />
      </el-form-item>

      <el-form-item class="mgl" :label="$t('task.creator')">
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

      <!-- 实验状态 私有/公开 -->
      <el-form-item class="mgl" :label="$t('dataset.isPublic')">
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

      <el-form-item class="mgl" :label="$t('task.task_type')">
        <el-select v-model="queryParam.task" style="float: left" clearable>
          <el-option
            v-for="item in taskParamList"
            :key="item.id"
            :label="item.label"
            :value="item.value"
          />
        </el-select>
      </el-form-item>

      <el-form-item class="mgl" :label="$t('task.status')">
        <el-select v-model="queryParam.task_status" style="float: left" clearable>
          <el-option
            v-for="item in taskStatusList"
            :key="item.id"
            :label="item.label"
            :value="item.value"
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
      <el-button class="mgl" size="small" type="primary" icon="el-icon-search" @click="getQueryList()">{{ $t('common.search') }}</el-button>
      <el-button class="mgl" size="small" type="default" icon="el-icon-delete" @click="resetData()">{{ $t('common.clear') }}</el-button>
    </el-form>
    <el-button
      size="small"
      :data-intro="$t('taskIndexIntroL.step03')"
      data-step="3"
      type="primary"
      style="float: right"
      @click="contrast()"
    >
      {{ $t('task.modelEvaluateContrast') }}
    </el-button>
    <!-- 数据表格 -->
    <el-table
      ref="taskTable"
      v-loading="listLoading"
      :data="tableData"
      border
    >
      <el-table-column
        fixed="left"
        type="selection"
        width="55"
      />
      <el-table-column type="expand">
        <template slot-scope="props">
          <el-form label-position="left" label-width="auto">
            <!-- <el-form-item :label="$t('task.taskName')">
              <span>{{ props.row.task_name }}</span>
            </el-form-item> -->
            <el-form-item v-if="props.row.task_description !== null" :label="$t('task.taskDescription')">
              <span>{{ props.row.task_description }}</span>
            </el-form-item>
            <!-- 任务状态 -->
            <!-- <el-form-item :label="$t('task.status')">
              <span v-if="props.row.task_status === 0"> {{ $t('task.noStart') }} </span>
              <span v-if="props.row.task_status === 1"> {{ $t('task.executing') }} </span>
              <span v-if="props.row.task_status === 2"> {{ $t('task.completed') }} </span>
              <span v-if="props.row.task_status === -1"> {{ $t('task.executeError') }} </span>
            </el-form-item> -->
            <!-- 所属任务 -->
            <!-- <el-form-item :label="$t('task.task')">
              <span v-if="props.row.task === 'traffic_state_pred'"> {{ $t('task.traffic_state_pred') }} </span>
              <span v-if="props.row.task === 'traj_loc_pred'"> {{ $t('task.traj_loc_pred') }} </span>
              <span v-if="props.row.task === 'road_representation'"> {{ $t('task.road_representation') }} </span>
              <span v-if="props.row.task === 'eta'"> {{ $t('task.eta') }} </span>
              <span v-if="props.row.task === 'map_matching'"> {{ $t('task.map_matching') }} </span>
            </el-form-item> -->
            <!-- 模型和数据集 -->
            <!-- <el-form-item :label="$t('task.model')">
              <span>{{ props.row.model }}</span>
            </el-form-item>
            <el-form-item :label="$t('task.dataset')">
              <span>{{ props.row.dataset }}</span>
            </el-form-item> -->
            <el-form-item v-if="props.row.config_file !== null" :label="$t('task.config_file1')">
              <!-- <span>{{ props.row.config_file }}</span> -->
              <el-link type="primary" :underline="false" :href="BASE_API + '/business/task/' + props.row.id + '/download_task_config/'">
                {{ $t('task.clickDownload') }}
              </el-link>
              <el-link style="margin-left: 10px" type="primary" :underline="false" @click="catConfig(props.row.id)">
                {{ $t('task.clickCatConfig') }}
              </el-link>
            </el-form-item>
            <el-form-item v-if="props.row.saved_model !== null" :label="$t('task.saved_model')">
              <span>{{ props.row.saved_model }}</span>
            </el-form-item>
            <el-form-item v-if="props.row.train !== null" :label="$t('task.train')">
              <span>{{ props.row.train }}</span>
            </el-form-item>
            <el-form-item v-if="props.row.batch_size !== null" :label="$t('task.batch_size')">
              <span>{{ props.row.batch_size }}</span>
            </el-form-item>
            <el-form-item v-if="props.row.train_rate !== null" :label="$t('task.train_rate')">
              <span>{{ props.row.train_rate }}</span>
            </el-form-item>
            <el-form-item v-if="props.row.eval_rate !== null" :label="$t('task.eval_rate')">
              <span>{{ props.row.eval_rate }}</span>
            </el-form-item>
            <el-form-item v-if="props.row.learning_rate !== null" :label="$t('task.learning_rate')">
              <span>{{ props.row.learning_rate }}</span>
            </el-form-item>
            <el-form-item v-if="props.row.max_epoch !== null" :label="$t('task.max_epoch')">
              <span>{{ props.row.max_epoch }}</span>
            </el-form-item>
            <el-form-item v-if="props.row.gpu !== null" :label="$t('task.gpu')">
              <span>{{ props.row.gpu }}</span>
            </el-form-item>
            <el-form-item v-if="props.row.gpu" :label="$t('task.gpu_id')">
              <span>{{ props.row.gpu_id }}</span>
            </el-form-item>
            <el-form-item :label="$t('common.createTime')">
              <span>{{ props.row.create_time }}</span>
            </el-form-item>
          </el-form>
        </template>
      </el-table-column>
      <af-table-column
        type="index"
        :index="indexMethod"
        :label="$t('common.order')"
        width="80"
      />

      <!-- 实验名称 -->
      <af-table-column
        prop="task_name_show"
        :label="$t('task.taskName')"
      />
      <!-- 实验ID -->
      <af-table-column
        prop="exp_id"
        :label="$t('task.expId')"
      />
      <!-- 模型名 -->
      <el-table-column
        prop="model"
        :label="$t('task.model')"
        width="130"
      />
      <!-- 数据集名 -->
      <el-table-column
        prop="showDataset"
        :label="$t('task.dataset')"
        width="130"
      >
        <template slot-scope="scope">
          <el-tooltip class="item" effect="dark" :content="scope.row.datasetUploader" placement="top">
            <span> {{ scope.row.showDataset }} </span>
          </el-tooltip>
        </template>
      </el-table-column>
      <af-table-column
        prop="task"
        :label="$t('task.task')"
        width="130"
      >
        <template slot-scope="scope">
          <span v-if="scope.row.task === 'traffic_state_pred'"> {{ $t('task.traffic_state_pred') }} </span>
          <span v-if="scope.row.task === 'traj_loc_pred'"> {{ $t('task.traj_loc_pred') }} </span>
          <span v-if="scope.row.task === 'road_representation'"> {{ $t('task.road_representation') }} </span>
          <span v-if="scope.row.task === 'eta'"> {{ $t('task.eta') }} </span>
          <span v-if="scope.row.task === 'map_matching'"> {{ $t('task.map_matching') }} </span>
        </template>
      </af-table-column>
      <!-- <el-table-column
        prop="dataset"
        :label="$t('task.dataFile')"
      /> -->
      <af-table-column
        prop="task_status"
        :label="$t('task.status')"
        width="100"
      >
        <template slot-scope="scope">
          <span v-if="scope.row.task_status === 0"> {{ $t('task.noStart') }} </span>
          <span v-if="scope.row.task_status === 1"> {{ $t('task.executing') }} </span>
          <span v-if="scope.row.task_status === 2"> {{ $t('task.completed') }} </span>
          <span v-if="scope.row.task_status === 3"> {{ $t('task.reserved') }} </span>
          <span v-if="scope.row.task_status === -1"> {{ $t('task.executeError') }} </span>
        </template>
      </af-table-column>
      <af-table-column
        prop="creator"
        :label="$t('task.creator')"
      />
      <!-- 状态 -->
      <el-table-column
        prop="visibility"
        :label="$t('dataset.isPublic')"
        width="160"
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
        prop="execute_time"
        :label="$t('task.executeTime')"
        sortable
      />
      <af-table-column
        prop="execute_end_time"
        :label="$t('task.executeEndTime')"
        sortable
      />

      <!-- <el-table-column
        prop="create_time"
        :label="$t('common.createTime')"
      /> -->
      <el-table-column
        :label="$t('common.operation')"
        fixed="right"
        :width="itemLabelWidth"
      >
        <template slot-scope="scope">
          <el-button-group v-intro-if="scope.$index === 0" :data-intro="$t('taskIndexIntroL.step04')" data-step="4">
            <!--
              关于 scope.row.task_status 的状态说明
              0 未开始
              1 进行中
              2 已完成
              3 已预约
              -1 执行错误
             -->
            <!-- 编辑按钮（进行中 或 已完成 或 禁止编辑 的时候，无法编辑） -->
            <!-- 实验只能由创建者进行编辑 -->
            <el-link
              v-if="currentUserName === scope.row.creator"
              style="margin-left: 10px;"
              :disabled="editDisable || ( (scope.row.task_status) == 1 || (scope.row.task_status) === 2 )"
              icon="el-icon-edit"
            >
              <span v-if="editDisable || ( (scope.row.task_status) == 1 || (scope.row.task_status) === 2 )">
                {{ $t('common.edit') }}
              </span>
              <router-link v-else :to="'/taskEdit/editTask/'+scope.row.id" disabled>
                {{ $t('common.edit') }}
              </router-link>
            </el-link>

            <!-- 删除按钮 -->
            <el-popconfirm
              :confirm-button-text="$t('common.confirm')"
              :cancel-button-text="$t('common.cancel')"
              confirm-button-type="danger"
              cancel-button-type="info"
              icon="el-icon-info"
              icon-color="red"
              :title="$t('common.deleteConfirm')"
              @onConfirm="deleteTask(scope.row.id)"
            >
              <!-- 当有删除权限 并且 是实验的创建者的时候 就展示删除按钮 -->
              <el-link
                v-if="!deleteDisable && currentUserName === scope.row.creator"
                slot="reference"
                style="margin-left: 10px;"
                icon="el-icon-delete"
              >
                {{ $t('common.delete') }}
              </el-link>
            </el-popconfirm>
            <!-- 执行按钮 只有未开始的时候，才可以执行 PS 只有本人可以执行本人创建的实验 -->
            <el-link
              v-if="scope.row.task_status === 0 && currentUserName === scope.row.creator"
              style="margin-left: 10px"
              :disabled="executeDisable"
              icon="el-icon-video-play"
              @click="execute(scope.row.id)"
            >
              {{ $t('task.execute') }}
            </el-link>
            <!-- 修改执行时间 -->
            <el-link
              v-if="scope.row.task_status === 3 && currentUserName === scope.row.creator"
              style="margin-left: 10px"
              :disabled="executeDisable"
              icon="el-icon-video-play"
              @click="execute(scope.row.id)"
            >
              {{ $t('task.modifyExecuteTime') }}
            </el-link>
            <!-- 重新执行按钮 只有出错的时候，才可以重新执行 PS 本人创建的实验只有自己可以执行,其他人只能看 -->
            <el-link
              v-if="scope.row.task_status === -1 && currentUserName === scope.row.creator"
              style="margin-left: 10px"
              :disabled="executeDisable"
              icon="el-icon-video-play"
              @click="execute(scope.row.id)"
            >
              {{ $t('task.reExecute') }}
            </el-link>
            <!-- 执行中动画 -->
            <el-link
              v-if="scope.row.task_status === 1"
              style="margin-left: 10px"
              disabled
              icon="el-icon-loading"
            >
              {{ $t('task.executing') }}
            </el-link>
            <!-- 中断实验 只能中断自己创建的实验 -->
            <el-link
              v-if="scope.row.task_status === 1 && currentUserName === scope.row.creator"
              style="margin-left: 10px"
              icon="el-icon-circle-close"
              @click="openInterruptExpBox(scope.row.id)"
            >
              {{ $t('task.interruptExp') }}
            </el-link>

            <!-- 查看评价指标按钮 有查看权限就有这个按钮 下面都是 -->
            <el-link
              v-if=" scope.row.task_status === 2 && scope.row.task !== 'road_representation' "
              style="margin-left: 10px"
              icon="el-icon-notebook-2"
              @click="openEvaluateDialog(scope.row.id)"
            >
              {{ $t('task.catEvaluate') }}
            </el-link>
            <!-- 结果查看按钮 -->
            <el-link
              v-if=" scope.row.task_status === 2 && scope.row.task !== 'traj_loc_pred' "
              style="margin-left: 10px;"
              icon="el-icon-view"
              @click="showResult(scope.row.exp_id, scope.row.dataset)"
            >
              {{ $t('task.showResult') }}
            </el-link>
            <!-- 下载任务模型 -->
            <el-link
              v-if=" scope.row.task_status === 2 "
              style="margin-left: 10px"
              icon="el-icon-download"
              :href="BASE_API + '/business/task/' + scope.row.id + '/download_task_model/'"
            >
              {{ $t('task.downloadModel') }}
            </el-link>
            <!-- 查看日志按钮 实验 不是未开始状态 且 不是已预约实验状态  的时候显示查看日志按钮 -->
            <el-link
              v-if="scope.row.task_status !== 0 && scope.row.task_status !== 3"
              style="margin-left: 10px"
              icon="el-icon-document"
              @click="catLog(scope.row.id)"
            >
              {{ $t('task.catLog') }}
            </el-link>
          </el-button-group>
        </template>
      </el-table-column>
    </el-table>
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

    <!-- 任务执行弹出框 -->
    <el-dialog :title="$t('task.selectExecuteTime')" :visible.sync="executeTaskDialogVisible">
      <el-form ref="executeForm" :model="executeForm" :rules="executeRules">
        <el-form-item :label="$t('task.executeTime')" label-width="auto" prop="executeTime">
          <el-date-picker
            v-model="executeForm.executeTime"
            class="date-picker"
            type="datetime"
            :placeholder="$t('task.selectExecuteTime')"
            value-format="yyyy-MM-dd HH:mm:ss"
          />
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="executeTaskDialogVisible = false">{{ $t('common.cancel') }}</el-button>
        <el-button @click="executeNow">{{ $t('task.executeNow') }}</el-button>
        <el-button type="primary" @click="executeAtTime">{{ $t('task.executeAt') }}</el-button>
      </span>
    </el-dialog>

    <!-- 日志查看弹出框 -->
    <el-dialog
      :title="$t('task.logview')"
      :visible.sync="logDialogVisible"
      width="80%"
      class="dialog-div"
    >
      <!-- <div style="white-space: pre-line; margin: 20px" v-html="logData" /> -->
      <pre style="white-space: pre-line; margin: 20px; background-color: black; color: white; font-family: Consolas; font-size: 16px;  padding: 10px">{{ logData }}</pre>
      <span slot="footer" class="dialog-footer">
        <el-button @click="logDialogVisible = false">{{ $t('common.cancel') }}</el-button>
        <a style="margin-left: 10px" :href="BASE_API + '/business/task/' + task.id + '/download_log/'">
          <el-button type="primary" icon="el-icon-download">
            {{ $t('task.downloadLog') }}
          </el-button></a>
      </span>
    </el-dialog>

    <!-- 评价指标弹出框 -->
    <el-dialog
      :title="$t('task.eva_view')"
      :visible.sync="evaluateDialogVisible"
      width="80%"
      class="dialog-div"
      :destroy-on-close="evaluateDestroyOnClose"
      @closed="closeEvaluateDialog()"
    >
      <div style="height: 80%">
        <!-- 交通状态预测、到达时间估计表格 -->
        <el-table
          v-if="task.task === 'eta' || task.task === 'traffic_state_pred'"
          ref="etaStateTable"
          v-loading="evaluateListLoading"
          :data="evaluateData"
          style="width: 100%"
          height="100%"
          border
        >
          <af-table-column
            type="index"
            :index="stateIndexMethod"
            :label="$t('common.order')"
            width="80"
            height="auto"
            fixed
          />
          <!-- <af-table-column
            v-if="evaluateData[0].MAE !== null && evaluateData[0].MAE !== '' "
            prop="MAE"
            :label="$t('task.MAE')"
            fixed
          /> -->
          <af-table-column
            v-if="evaluateData[0].MAE !== null && evaluateData[0].MAE !== '' "
            prop="MAE"
            :label="$t('task.MAE')"
          />
          <af-table-column
            v-if="evaluateData[0].MAPE !== null && evaluateData[0].MAPE !== '' "
            prop="MAPE"
            :label="$t('task.MAPE')"
          />
          <af-table-column
            v-if="evaluateData[0].MSE !== null && evaluateData[0].MSE !== '' "
            prop="MSE"
            :label="$t('task.MSE')"
          />
          <af-table-column
            v-if="evaluateData[0].RMSE !== null && evaluateData[0].RMSE !== '' "
            prop="RMSE"
            :label="$t('task.RMSE')"
          />
          <af-table-column
            v-if="evaluateData[0].masked_MAE !== null && evaluateData[0].masked_MAE !== '' "
            prop="masked_MAE"
            :label="$t('task.masked_MAE')"
          />
          <af-table-column
            v-if="evaluateData[0].masked_MAPE !== null && evaluateData[0].masked_MAPE !== '' "
            prop="masked_MAPE"
            :label="$t('task.masked_MAPE')"
          />
          <af-table-column
            v-if="evaluateData[0].masked_MSE !== null && evaluateData[0].masked_MSE !== '' "
            prop="masked_MSE"
            :label="$t('task.masked_MSE')"
          />
          <af-table-column
            v-if="evaluateData[0].masked_RMSE !== null && evaluateData[0].masked_RMSE !== '' "
            prop="masked_RMSE"
            :label="$t('task.masked_RMSE')"
          />
          <af-table-column
            v-if="evaluateData[0].R2 !== null && evaluateData[0].R2 !== '' "
            prop="R2"
            :label="$t('task.R2')"
          />
          <af-table-column
            v-if="evaluateData[0].EVAR !== null && evaluateData[0].EVAR !== '' "
            prop="EVAR"
            :label="$t('task.EVAR')"
          />
          <af-table-column
            v-if="evaluateData[0].Precision !== null && evaluateData[0].Precision !== '' "
            prop="Precision"
            :label="$t('task.Precision')"
          />
          <af-table-column
            v-if="evaluateData[0].Recall !== null && evaluateData[0].Recall !== '' "
            prop="Recall"
            :label="$t('task.Recall')"
          />
          <af-table-column
            v-if="evaluateData[0].F1_Score !== null && evaluateData[0].F1_Score !== '' "
            prop="F1_Score"
            :label="$t('task.F1Score')"
          />
          <af-table-column
            v-if="evaluateData[0].MAP !== null && evaluateData[0].MAP !== '' "
            prop="MAP"
            :label="$t('task.MAP')"
          />
          <af-table-column
            v-if="evaluateData[0].PCC !== null && evaluateData[0].PCC !== '' "
            prop="PCC"
            :label="$t('task.PCC')"
          />
        </el-table>

        <!-- 路网匹配表格 -->
        <el-table
          v-if="task.task === 'map_matching'"
          v-loading="evaluateListLoading"
          :data="evaluateData"
          style="width: 100%"
          height="100%"
          border
          fit
        >
          <!-- <el-table-column
            type="index"
            :index="stateIndexMethod"
            :label="$t('common.order')"
            fixed
            width="100px"
          /> -->
          <af-table-column
            v-if="evaluateData[0].RMF !== null"
            prop="RMF"
            :label="$t('task.RMF')"
          />
          <af-table-column
            v-if="evaluateData[0].AN !== null"
            prop="AN"
            :label="$t('task.AN')"
          />
          <af-table-column
            v-if="evaluateData[0].AL !== null"
            prop="AL"
            :label="$t('task.AL')"
          />
        </el-table>

        <!-- 轨迹下一跳表格 -->
        <el-table
          v-if="task.task === 'traj_loc_pred'"
          v-loading="evaluateListLoading"
          :data="evaluateData"
          style="width: 100%"
          height="100%"
          border
          fit
        >
          <!-- <el-table-column
            type="index"
            :index="stateIndexMethod"
            :label="$t('common.order')"
            fixed
            width="100px"
          /> -->
          <af-table-column
            v-if="evaluateData[0].Recall !== null"
            prop="Recall"
            :label="$t('task.Recall')"
          />
          <af-table-column
            v-if="evaluateData[0].Precision !== null"
            prop="Precision"
            :label="$t('task.Precision')"
          />
          <af-table-column
            v-if="evaluateData[0].F1 !== null"
            prop="F1"
            :label="$t('task.F1Score')"
          />
          <af-table-column
            v-if="evaluateData[0].MRR !== null"
            prop="MRR"
            :label="$t('task.MRR')"
          />
          <af-table-column
            v-if="evaluateData[0].MAP !== null"
            prop="MAP"
            :label="$t('task.MAP')"
          />
          <af-table-column
            v-if="evaluateData[0].NDCG !== null"
            prop="NDCG"
            :label="$t('task.NDCG')"
          />
        </el-table>

        <!-- 指标分页组件 -->
        <div>
          <el-pagination
            :hide-on-single-page="true"
            :current-page="evaluateQueryParam.page"
            :page-sizes="[10, 20, 50, 100, 200]"
            :page-size="evaluateQueryParam.size"
            style="padding: 30px 0; text-align: center;"
            layout="total, prev, pager, next"
            :total="evaluateQueryParam.total"
            @size-change="handleEvaluateSizeChange"
            @current-change="handleEvaluateCurrentChange"
          />
        </div>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="evaluateDialogVisible = false">{{ $t('common.cancel') }}</el-button>
        <a style="margin-left: 10px" :href="BASE_API + '/business/evaluate/download/?task=' + task.id">
          <el-button type="primary" icon="el-icon-download">
            {{ $t('task.downEvaluate') }}
          </el-button></a>
      </span>
    </el-dialog>

    <!-- 配置文件查看弹出框 -->
    <el-dialog
      :title="$t('task.configview')"
      :visible.sync="configDialogVisible"
      width="80%"
      class="dialog-div"
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
import { checkPermission } from '@/utils/permission'
import { getSimpleAccountList } from '@/api/account'
import i18n from '@/lang'
import Cookies from 'js-cookie'
import { getTaskList, getTaskById, executeTaskById, deleteTaskById, getExecuteLogById, getStateEvaluateList, getMapMatchingEvaluateList,
  getTrajEvaluateList, getConfigDataById, getStateMode, getTaskStatus, updateTaskVisibility, interruptExp } from '@/api/task'

const DEFAULT_EVALUATE_DATA = [{ 'MAE': '', 'MAPE': '', 'MSE': '', 'RMSE': '', 'masked_MAE': '', 'masked_MAPE': '',
  'masked_MSE': '', 'masked_RMSE': '', 'R2': '', 'EVAR': '', 'Precision': '',
  'Recall': '', 'F1-Score': '', 'MAP': '', 'PCC': '', 'RMF': '', 'AN': '', 'AL': '',
  'F1': '', 'MRR': '', 'NDCG': '' }]

// 横向滚动条持续在视线范围内
function _scrollBarFixedHandle(el) {
  if (!el) return
  const tableBodyWrapDom = el.querySelector('.el-table__body-wrapper')
  const tableBodyDom = el.querySelector('.el-table__body')
  // top为dom上侧距离可视窗口顶部的值
  const { top: tableBodyWrapDomTop } = tableBodyWrapDom.getBoundingClientRect()
  const { bottom: tableBodyDomBottom } = tableBodyDom.getBoundingClientRect()
  if (
    tableBodyWrapDomTop >= window.innerHeight || // 表在视窗下方不可见区域
    (tableBodyDomBottom > 0 && tableBodyDomBottom <= window.innerHeight) || // 视窗内已经可以看到最后一条数据下的滚动条
    tableBodyWrapDom.classList.contains('is-scrolling-none') // 无滚动条
  ) {
    // 不做任何更改
    tableBodyWrapDom.style.height = 'unset'
    tableBodyWrapDom.style.marginBottom = 'unset'
  } else {
    // 窗口高度 - 列表距顶部值 且 不超过自身实际值
    const wrapHeight = Math.min(
      window.innerHeight - tableBodyWrapDomTop,
      tableBodyDom.offsetHeight
    )
    tableBodyWrapDom.style.height = wrapHeight + 'px'
    // 需要用marginBottom填充，以保持列表原有高度，避免页面的纵向滚动条变化导致页面滚动的不流畅
    // 可以通过注释这一行代码观察其效果差异
    tableBodyWrapDom.style.marginBottom =
      tableBodyDom.offsetHeight - wrapHeight + 'px'
  }
}

const ScrollBarFixed = {
  mounted() {
    this.$refs.taskTable.handleFixedMousewheel = function() {} // 观察源码发现，此方法会使得在right-fixed上滚动同时，wrapper也滚动
    // 监听事件
    document.addEventListener('scroll', this.scrollBarFixedHandle)
    window.addEventListener('resize', this.scrollBarFixedHandle)
  },
  destroyed() {
    // 在组件销毁时取消监听
    document.removeEventListener('scroll', this.scrollBarFixedHandle)
    window.removeEventListener('resize', this.scrollBarFixedHandle)
  },
  watch: {
    _list() {
      // 当列表数据源发生变化时，再次触发
      this.$nextTick(this.scrollBarFixedHandle)
    }
  },
  methods: {
    scrollBarFixedHandle() {
      _scrollBarFixedHandle(this.$el)
    }
  }
}

export default {

  mixins: [ScrollBarFixed],

  data() {
    const validateExecuteTime = (rule, value, callback) => {
      if (!value) {
        callback(new Error(this.$t('task.executeTimeError')))
      } else {
        if (new Date(value) < new Date()) {
          callback(new Error(this.$t('task.executeTimeEarlyError')))
        } else {
          callback()
        }
      }
    }
    return {
      BASE_API: window.global_url.Base_url,
      visibilityList: [{ id: 1, value: '公开' }],
      currentUserName: '',
      accountList: [],
      itemLabelWidth: 150,
      language: '',
      tableData: [],
      task: {},
      listLoading: true,
      queryParam: {
        page: 1,
        size: 10,
        task_name: ''
      },
      evaluateQueryParam: {
        page: 1,
        size: 8,
        total: 0
      },
      evaluateDialogFirstOpen: false,
      taskParamList: [
        { id: '1', label: this.$t('task.traffic_state_pred'), value: 'traffic_state_pred' },
        { id: '2', label: this.$t('task.traj_loc_pred'), value: 'traj_loc_pred' },
        { id: '3', label: this.$t('task.road_representation'), value: 'road_representation' },
        { id: '4', label: this.$t('task.eta'), value: 'eta' },
        { id: '5', label: this.$t('task.map_matching'), value: 'map_matching' }],
      taskStatusList: [
        { id: '1', label: this.$t('task.noStart'), value: '0' },
        { id: '2', label: this.$t('task.executing'), value: '1' },
        { id: '3', label: this.$t('task.completed'), value: '2' },
        { id: '4', label: this.$t('task.executeError'), value: '-1' }],
      total: 0,
      defaultPage: 1,
      defaultSize: 10,
      executeTaskDialogVisible: false,
      executeForm: { executeTime: '' },
      executeId: 0,
      logDialogVisible: false, // 日志查看弹出框
      logData: '', // 日志数据
      evaluateDialogVisible: false,
      evaluateListLoading: false,
      // 按钮权限
      executeDisable: true,
      editDisable: true,
      deleteDisable: true,
      listPermission: true,
      evaluateData: [{ 'MAE': '', 'MAPE': '', 'MSE': '', 'RMSE': '', 'masked_MAE': '', 'masked_MAPE': '',
        'masked_MSE': '', 'masked_RMSE': '', 'R2': '', 'EVAR': '', 'Precision': '',
        'Recall': '', 'F1-Score': '', 'MAP': '', 'PCC': '', 'RMF': '', 'AN': '', 'AL': '',
        'F1': '', 'MRR': '', 'NDCG': '' }],
      executeRules: {
        executeTime: [{ type: 'date', required: true, trigger: 'blur', validator: validateExecuteTime }]
      },
      // 指标dialog关闭时是否清空元素
      evaluateDestroyOnClose: true,
      configDialogVisible: false,
      configData: '',
      pollingTaskListInterval: null
    }
  },
  watch: {
    evaluateData(val) {
      this.doLayout()
    }
  },
  updated() {
    this.columnAdapt()
  },
  created() {
    this.checkButtonPermission()
    // 如果发现没有 listPermission 就需要向其展示权限不足提示
    if (!this.listPermission) {
      this.$router.push('/forbidden/index')
    }
    this.getList()
    this.columnAdapt()
    // this.getAccountList()
    this.currentUserName = this.$store.getters.name
    this.pollingTaskList()
  },
  mounted() {
    this.$nextTick(() => {
      setTimeout(() => {
        if (localStorage.getItem('taskIndexNew') === null || localStorage.getItem('taskIndexNew') !== '1') {
          this.$intro.start()
          localStorage.setItem('taskIndexNew', 1)
        }
      }, 300)
    })
  },
  destroyed() {
    clearInterval(this.pollingTaskListInterval)
  },
  methods: {
    checkPermission,
    // 打开中断实验消息框
    openInterruptExpBox(expId) {
      this.$confirm(this.$t('task.interruptConfirm'), this.$t('task.tips'), {
        confirmButtonText: this.$t('common.confirm'),
        cancelButtonText: this.$t('common.cancel'),
        type: 'warning'
      }).then(() => {
        interruptExp(expId).then(res => {
          if (res.code === 200) {
            this.$message({
              type: 'success',
              message: this.$t('task.interruptOk')
            })
            this.pollingTaskStatus(expId, 5)
            this.getList()
          }
        })
      }).catch(() => {
        this.$message({
          type: 'info',
          message: this.$t('task.interruptCancel')
        })
      })
    },
    // 轮询任务列表 监控任务执行时间是否到达
    pollingTaskList() {
      // 每五秒循环检查一次 tableData
      this.pollingTaskListInterval = setInterval(() => {
        this.tableData.forEach(item => {
          if (item.task_status === 3 && this.analysisExecuteTime(item.execute_time)) {
            this.getList()
          }
        })
      }, 1 * 1000)
    },
    // 分析时间 如何参数时间小于等于当前时间 表示任务列表该刷新了
    analysisExecuteTime(time) {
      if (time) {
        const now = new Date()
        const executeTime = new Date(time)
        if (executeTime.getTime() <= now.getTime()) {
          return true
        }
      }
      return false
    },
    // 中断实验
    interruptTask(expId) {

    },
    // 公开 私有 开关变化时触发此方法，更新对应状态
    visibilitySwitchChange(newValue, taskId) {
      updateTaskVisibility(taskId, newValue).then(res => {
        this.getList()
      })
    },
    // 当创建者下拉框值改变时，自动改变状态下拉列表值
    onCreatorChange(creatorId) {
      if (creatorId === this.$store.getters.id) {
        this.visibilityList = [{ id: 1, value: this.$t('dataset.public') },
          { id: 0, value: this.$t('dataset.private') }, { id: 2, value: this.$t('dataset.all') }]
      } else {
        this.visibilityList = [{ id: 1, value: this.$t('dataset.public') }]
        this.queryParam.visibility = this.visibilityList[0].id
      }
    },
    // 获取账号列表下拉值
    getAccountList() {
      getSimpleAccountList().then(res => {
        this.accountList = res.data
      })
    },
    // 自适应操作列列宽
    columnAdapt() {
      if (!this.language) {
        this.language = Cookies.get('language')
        if (!this.language) {
          Cookies.set('language', 'zh')
        }
      }
      if (this.language === 'zh') {
        this.itemLabelWidth = '150'
      } else {
        this.itemLabelWidth = '220'
      }
    },
    // 获取任务状态，长轮询
    pollingTaskStatus(taskId, seconds) {
      if (this.timeObj) {
        clearTimeout(this.timeObj)
      }
      getTaskStatus(taskId).then(res => {
        if (res.code === 202) {
          this.$nextTick(() => {
            this.timeObj = setTimeout(() => {
              this.pollingTaskStatus(taskId, seconds)
            }, 1000 * seconds)
          })
        } else if (res.code === 200) {
          // 刷新页面
          this.getList()
          var item = res.data.task_name
          var temp = item.split('_')
          // 移除temp的第一个元素 剩下的元素还是用下划线拼接成字符串
          temp.shift()
          item = temp.join('_')
          if (res.data.task_status === -1) {
            // 提示框
            this.$notify.error({
              title: i18n.t('task.taskExecuteError'),
              message: item + i18n.t('task.taskExecuteError'),
              duration: 10000
            })
          } else {
            // 提示框
            this.$notify({
              title: i18n.t('task.taskExecuteSuccessfully'),
              message: item + i18n.t('task.taskExecuteSuccessfully'),
              type: 'success',
              duration: 10000
            })
          }
        }
      })
    },

    // 解决elementui表格fixed错位bug
    doLayout() {
      this.$nextTick(() => {
        if (this.$refs.etaStateTable) {
          this.$refs.etaStateTable.doLayout()
        }
      })
    },
    checkButtonPermission() {
      this.executeDisable = !checkPermission(['taskExecute'])
      this.editDisable = !checkPermission(['taskEdit'])
      // 如果没有删除权限，那么 deleteDisable 会是 true
      this.deleteDisable = !checkPermission(['taskDelete'])
      this.listPermission = checkPermission(['expList'])
    },
    // 查看任务结果文件
    showResult(taskId, dataset) {
      // 新窗口打开  需求修改 当前页面展示
      const routeData = this.$router.resolve({
        path: '/task/result',
        query: {
          taskId: taskId,
          dataset: dataset
        }
      })
      window.open(routeData.href, '_self')
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
    // 模型指标对比
    contrast() {
      const tasks = this.$refs.taskTable.selection
      if (tasks.length === 0) {
        this.$message.warning(this.$t('task.selectTaskTip'))
        return
      }
      // 路网表征学习，无模型评价指标
      const isRoadRepresentation = tasks.every(item => item.task === 'road_representation')
      if (isRoadRepresentation) {
        this.$message.warning(this.$t('task.selectRoadRepresentation'))
        return
      }
      // 所有任务必须得是已完成的任务
      const isComplete = tasks.every(item => item.task_status === 2)
      if (!isComplete) {
        this.$message.warning(this.$t('task.selectCompleteTip'))
        return
      }
      // 数组中所有条目的任务类型(task)必须相同
      const defaultTask = tasks[0].task
      const taskIsSame = tasks.every(item => item.task === defaultTask)
      if (!taskIsSame) {
        this.$message.warning(this.$t('task.selectSameTask'))
        return
      }
      // 所有任务的数据集必须相同
      const defaultDataset = tasks[0].dataset
      const datasetIsSame = tasks.every(item => item.dataset === defaultDataset)
      if (!datasetIsSame) {
        this.$message.warning(this.$t('task.selectSameDataset'))
        return
      }
      // 所有任务的模型必须不同-需求修改，可以同模型对比
      // var isDifferentModel = true
      // const taskModels = tasks.map(item => item.model) // 模型list
      // const arr = []
      // for (let i = 0; i < taskModels.length; i++) {
      //   if (arr.indexOf(taskModels[i]) === -1) {
      //     arr.push(taskModels[i])
      //   } else {
      //     isDifferentModel = false
      //   }
      // }
      // if (!isDifferentModel) {
      //   this.$message.warning(this.$t('task.selectDifferentModelTask'))
      //   return
      // }
      // 取出id list
      const taskIds = tasks.map(item => item.id)
      const taskIdsStr = taskIds.join(',')
      // 新窗口打开
      const routeData = this.$router.resolve({
        path: '/evaluate/index',
        query: {
          taskIds: taskIdsStr,
          taskType: defaultTask
        }
      })
      window.open(routeData.href, '_self')
    },
    // 获取任务列表
    getList() {
      this.listLoading = true
      getSimpleAccountList().then(res => {
        this.accountList = res.data
        getTaskList(this.queryParam).then(res => {
          this.tableData = res.data.results
          // 对 tableData 的 dataset 字段进行检查 dataset 值重新赋值为 dataset取第一个下划线之后的值
          this.tableData.forEach(item => {
            var temp = item.dataset.split('_')
            // 移除temp的第一个元素 剩下的元素还是用下划线拼接成字符串
            var uploader_id = temp[0]
            temp.shift()
            item.showDataset = temp.join('_')
            this.accountList.forEach(account => {
              if (uploader_id === account.id.toString()) {
                item.datasetUploader = account.account_number
              }
            })
          })
          this.total = res.data.count
          this.listLoading = false
        }).catch(() => {
          this.listLoading = false
        })
      })
    },
    // 回显任务数据
    getById(id) {
      getTaskById(id).then(res => {
        this.task = res.data
      })
    },
    // 查看日志
    catLog(id) {
      this.task.id = id
      this.logDialogVisible = true
      // 每次查看日志，刷新所有任务状态
      this.getList()
      getExecuteLogById(id).then(res => {
        this.logData = res.data
      })
    },
    // 查看配置文件信息
    catConfig(id) {
      this.task.id = id
      this.configDialogVisible = true
      getConfigDataById(id).then(res => {
        this.configData = res.data
      })
    },
    openEvaluateDialog(taskId) {
      this.evaluateDialogVisible = true
      this.evaluateDialogFirstOpen = true
      this.catEvaluate(taskId)
    },
    // 查看评价指标
    catEvaluate(id) {
      this.evaluateListLoading = true
      // 获取当前任务相关数据
      getTaskById(id).then(res => {
        this.task = res.data
        if (this.task.task === 'traffic_state_pred' || this.task.task === 'eta') {
        // 走交通状态预测和到达时间估计接口
          this.evaluateQueryParam.task = this.task.id
          getStateEvaluateList(this.evaluateQueryParam).then(res => {
            this.evaluateData = res.data.results
            this.evaluateQueryParam.total = res.data.count
          })
          // 获取评价指标mode
          if (this.task.task === 'traffic_state_pred' && this.evaluateDialogFirstOpen) {
            getStateMode(this.task.id).then(res => {
              // 弹窗提醒
              this.$notify.info({
                message: this.$t('task.stateModeTip') + res.data.mode,
                duration: 10000
              })
              this.evaluateDialogFirstOpen = false
            })
          }
        } else if (this.task.task === 'map_matching') {
          // 走路网匹配接口
          this.evaluateQueryParam.task = this.task.id
          getMapMatchingEvaluateList(this.evaluateQueryParam).then(res => {
            this.evaluateData = res.data.results
            this.evaluateQueryParam.total = res.data.count
          })
        } else if (this.task.task === 'traj_loc_pred') {
          // 走轨迹下一跳预测接口
          this.evaluateQueryParam.task = this.task.id
          getTrajEvaluateList(this.evaluateQueryParam).then(res => {
            this.evaluateData = res.data.results
            this.evaluateQueryParam.total = res.data.count
          })
        } else {
          // 路网表征学习，无评价指标
          this.evaluateData = []
        }
      })
      this.evaluateListLoading = false
    },
    getQueryList() {
      this.queryParam.page = this.defaultPage
      this.queryParam.size = this.defaultSize
      this.getList()
    },
    deleteTask(id) {
      deleteTaskById(id).then(res => {
        this.getList()
      })
    },
    // 执行任务
    execute(id) {
      this.executeTaskDialogVisible = true
      this.executeId = id
    },
    executeNow() {
      executeTaskById(this.executeId).then(res => {
        this.getList()
        // 5 秒后再开始轮询，因为有一种情况是状态为执行错误的实验，重新执行后第一时间获取到的状态是错误，轮询就会停止
        // setTimeout(this.pollingTaskStatus(this.executeId, 30), 1000 * 5)
        setTimeout(() => {
          this.pollingTaskStatus(this.executeId, 5)
        }, 1000 * 5)
      })
      this.executeTaskDialogVisible = false
    },
    executeAtTime() {
      if (this.analysisExecuteTime(this.executeForm.executeTime)) {
        // 弹出警告信息
        this.$message.warning(this.$t('task.selectExecuteTimeError'))
        return
      }
      executeTaskById(this.executeId, this.executeForm.executeTime).then(res => {
        this.getList()
        // 5 秒后再开始轮询，因为有一种情况是状态为执行错误的实验，重新执行后第一时间获取到的状态是错误，轮询就会停止
        // setTimeout(this.pollingTaskStatus(this.executeId, 30), 1000 * 5)
        setTimeout(() => {
          this.pollingTaskStatus(this.executeId, 5)
        }, 1000 * 5)
      })
      this.executeTaskDialogVisible = false
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
    // 指标分页大小改变
    handleEvaluateSizeChange(size) {
      this.evaluateQueryParam.size = size
      this.catEvaluate(this.task.id)
    },
    handleCurrentChange(page) {
      this.queryParam.page = page
      this.getList(this.queryParam)
    },
    // 指标页码改变
    handleEvaluateCurrentChange(page) {
      this.evaluateQueryParam.page = page
      this.catEvaluate(this.task.id)
    },
    // 指标dialog关闭回调
    closeEvaluateDialog() {
      // 清空数据
      this.evaluateQueryParam.page = 1
      this.evaluateQueryParam.size = 8
      this.evaluateQueryParam.total = 0
      this.evaluateData = DEFAULT_EVALUATE_DATA
      this.evaluateDialogFirstOpen = false
    },
    indexMethod(index) {
      return (this.queryParam.page - 1) * this.queryParam.size + index + 1
    },
    // 交通状态预测，序号生成
    stateIndexMethod(index) {
      return (this.evaluateQueryParam.page - 1) * this.evaluateQueryParam.size + index + 1
    }
  }
}
</script>
<style>
.mgl {
  margin-left: 30px;
}
.word {
  word-break: break-word !important;
}
.el-picker-panel__footer .el-button--text.el-picker-panel__link-btn {
  display: '';
}
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
