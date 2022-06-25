<template>
  <div class="app-container">
    <!-- 顶部查询表单 -->
    <el-form :inline="true" class="demo-form-inline">

      <el-form-item :label="$t('permission.name')">
        <el-input v-model="queryParam.name" />
      </el-form-item>

      <el-form-item :label="$t('permission.type')">
        <el-select v-model="queryParam.type" clearable :placeholder="$t('permission.ChoiceType')">
          <el-option :label="$t('permission.menu')" value="menu" />
          <el-option :label="$t('permission.interface')" value="interface" />
        </el-select>
      </el-form-item>

      <el-form-item :label="$t('common.createTime')">
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
      </el-form-item>
      <el-button type="primary" icon="el-icon-search" @click="getQueryList()">{{ $t('common.search') }}</el-button>
      <el-button type="default" icon="el-icon-delete" @click="resetData()">{{ $t('common.clear') }}
      </el-button>
    </el-form>

    <!-- <el-button type="primary" size="medium" icon="el-icon-circle-plus-outline" @click="addPermission()">
      {{ $t('common.add') }}
    </el-button> -->
    <el-table
      v-loading="listLoading"
      :data="permissionList"
      fit
      border
    >
      <el-table-column
        type="index"
        :index="indexMethod"
        :label="$t('permission.order')"
        width="120"
      />
      <!-- <el-table-column
        prop="id"
        :label="$t('permission.id')"
      /> -->
      <el-table-column
        prop="name"
        :label="$t('permission.name')"
      />
      <el-table-column
        prop="type"
        :label="$t('permission.type')"
      >
        <template slot-scope="scope">
          <span v-if="scope.row.type == 'menu'"> 菜单 </span>
          <span v-if="scope.row.type == 'interface'"> 接口 </span>
        </template>
      </el-table-column>
      <el-table-column
        prop="code"
        :label="$t('permission.code')"
      />
      <el-table-column
        prop="parent"
        :label="$t('permission.parent')"
      />
      <el-table-column
        prop="create_time"
        :label="$t('permission.createTime')"
      />
      <el-table-column
        prop="update_time"
        :label="$t('permission.updateTime')"
      />
      <!-- <el-table-column
        :label="$t('permission.operation')"
        width="200"
      >
        <template slot-scope="scope">
          <el-button-group>
            <el-button type="primary" size="small" icon="el-icon-edit" @click="editPermission(scope.row.id)">
              {{ $t('common.edit') }}
            </el-button>
            <el-button type="danger" size="small" icon="el-icon-delete" @click="deletePermission(scope.row.id)">
              {{ $t('common.delete') }}
            </el-button>
          </el-button-group>
        </template>
      </el-table-column> -->
    </el-table>
    <div>
      <el-pagination
        :hide-on-single-page="false"
        :current-page="page"
        :page-sizes="[10, 20, 50, 100, 200]"
        :page-size="size"
        style="padding: 30px 0; text-align: center;"
        layout="total, sizes, prev, pager, next, jumper"
        :total="total"
        background
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </div>
    <el-dialog :title="dialogType === 'edit' ? $t('permission.edit') : $t('permission.add')" :visible.sync="dialogFormVisible">
      <el-form :model="permission">
        <el-form-item :label="$t('permission.name')" :label-width="formLabelWidth">
          <el-input v-model="permission.name" autocomplete="off" />
        </el-form-item>
        <el-form-item :label="$t('permission.type')" :label-width="formLabelWidth">
          <el-select v-model="permission.type" :placeholder="$t('permission.ChoiceType')">
            <el-option :label="$t('permission.menu')" value="menu" />
            <el-option :label="$t('permission.interface')" value="interface" />
          </el-select>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="dialogFormVisible = false">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>
<script>
import { getPermissionList } from '@/api/permission'

const queryParam = {
  page: 1,
  size: 10
}

const defaultPermission = {
  id: '',
  name: '',
  type: '',
  code: '',
  parent: ''
}
export default {
  data() {
    return {
      permission: defaultPermission,
      permissionList: [],
      listLoading: true,
      queryParam: queryParam,
      page: 1,
      size: 10,
      total: 0,
      dialogFormVisible: false,
      dialogType: 'add',
      formLabelWidth: '150px'
    }
  },

  created() {
    this.getList(queryParam)
  },

  methods: {
    getList(queryParam) {
      this.listLoading = true
      getPermissionList(queryParam).then(res => {
        this.permissionList = res.data.results
        this.listLoading = false
        this.total = res.data.count
      }).catch(() => {
        this.listLoading = false
      })
    },
    getQueryList() {
      this.queryParam.page = this.page
      this.queryParam.size = this.size
      this.getList(this.queryParam)
    },
    // 清空查询条件，重新获取数据
    resetData() {
      this.queryParam = {}
      this.queryParam.page = this.page
      this.queryParam.size = this.size
      this.getList(this.queryParam)
    },
    addPermission() {
      this.dialogType = 'add'
      this.dialogFormVisible = true
    },
    editPermission(id) {
      this.dialogType = 'edit'
      this.dialogFormVisible = true
      console.log(id)
    },
    deletePermission(id) {
      console.log(id)
    },
    indexMethod(index) {
      return (this.queryParam.page - 1) * this.queryParam.size + index + 1
    },
    handleSizeChange(size) {
      this.queryParam.size = size
      this.getList(this.queryParam)
    },
    handleCurrentChange(page) {
      this.queryParam.page = page
      this.getList(this.queryParam)
    }
  }
}
</script>
