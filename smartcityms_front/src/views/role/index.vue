<template>
  <div class="app-container" :data-intro="$t('roleManageIntro.step01')" data-step="1">
    <!-- 顶部查询表单 -->
    <el-form size="small" :inline="true" class="demo-form-inline" :data-intro="$t('roleManageIntro.step02')" data-step="2">

      <el-form-item :label="$t('role.name')">
        <el-input v-model="queryParam.name" />
      </el-form-item>

      <el-form-item :label="$t('role.description')">
        <el-input v-model="queryParam.description" />
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
      <el-button size="small" type="primary" icon="el-icon-search" @click="getQueryList()">{{ $t('common.search') }}</el-button>
      <el-button size="small" type="default" icon="el-icon-delete" @click="resetData()">{{ $t('common.clear') }}</el-button>
    </el-form>

    <el-button
      size="small"
      :data-intro="$t('roleManageIntro.step03')"
      data-step="3"
      style="float: right"
      :disabled="addDisable"
      type="primary"
      icon="el-icon-circle-plus-outline"
      @click="add()"
    >
      {{ $t('common.add') }}
    </el-button>
    <!-- 数据表格 -->
    <el-table
      v-loading="listLoading"
      :data="tableData"
      fit
      border
    >
      <el-table-column
        type="index"
        :index="indexMethod"
        :label="$t('common.order')"
        width="120"
      />
      <el-table-column
        prop="name"
        :label="$t('role.name')"
      />
      <el-table-column
        prop="description"
        :label="$t('role.description')"
      />
      <el-table-column
        prop="create_time"
        :label="$t('common.createTime')"
      />
      <el-table-column
        prop="update_time"
        :label="$t('common.updateTime')"
      />
      <el-table-column
        :label="$t('common.operation')"
      >
        <template slot-scope="scope">
          <el-button-group v-intro-if="scope.$index === 0" :data-intro="$t('roleManageIntro.step04')" data-step="4">
            <el-link :disabled="editDisable" icon="el-icon-edit" @click="edit(scope.row.id)">{{ $t('common.edit') }}</el-link>
            <!-- <el-button :disabled="editDisable" type="primary" size="small" icon="el-icon-edit" @click="edit(scope.row.id)">
              {{ $t('common.edit') }}
            </el-button> -->
            <el-popconfirm
              :confirm-button-text="$t('common.confirm')"
              :cancel-button-text="$t('common.cancel')"
              confirm-button-type="danger"
              cancel-button-type="info"
              icon="el-icon-info"
              icon-color="red"
              :title="$t('common.deleteConfirm')"
              @onConfirm="deleteRole(scope.row.id)"
            >
              <el-link v-if="!deleteDisable" slot="reference" style="margin-left: 10px" :disabled="deleteDisable" icon="el-icon-delete">{{ $t('common.delete') }}</el-link>
              <!-- <el-button slot="reference" :disabled="deleteDisable" type="danger" size="small" icon="el-icon-delete">
                {{ $t('common.delete') }}
              </el-button> -->
            </el-popconfirm>
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
    <!-- 添加/编辑 对话框 -->
    <el-dialog :title="dialogType === 'edit' ? $t('role.edit') : $t('role.add')" :visible.sync="dialogFormVisible">
      <el-form ref="roleForm" :model="role" :rules="rules">
        <el-form-item :label="$t('role.name')" :label-width="formLabelWidth" prop="name">
          <el-input v-model="role.name" maxlength="16" show-word-limit autocomplete="off" />
        </el-form-item>
        <el-form-item :label="$t('role.description')" :label-width="formLabelWidth" prop="description">
          <el-input v-model="role.description" autocomplete="off" />
        </el-form-item>
        <el-form-item :label="$t('role.permissions')" :label-width="formLabelWidth">
          <el-tree
            ref="tree"
            :data="permissionTree"
            show-checkbox
            node-key="id"
            :props="defaultProps"
          />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">{{ $t('common.cancel') }}</el-button>
        <el-button type="primary" @click="submit()">{{ $t('common.confirm') }}</el-button>
      </div>
    </el-dialog>
  </div>
</template>
<script>
import { getRoleList, getRoleById, addRole, deleteRoleById, updateRoleById, roleExists } from '@/api/role'
import { getPermissionTree } from '@/api/permission'
import { checkPermission } from '@/utils/permission'

export default {
  data() {
    const validateRoleName = (rule, value, callback) => {
      if (value.length === 0) {
        callback(new Error(this.$t('role.roleNameError')))
      } else {
        this.role.role_name = value
        roleExists(this.role).then(res => {
          if (res.code !== 200 && this.role.id !== res.msg.id) {
            callback(new Error(this.$t('role.roleNameExistsError')))
          } else {
            callback()
          }
        })
      }
    }
    return {
      role: {
        name: '',
        description: '',
        permissionTree: []
      },
      listLoading: true,
      tableData: [],
      queryParam: {
        page: 1,
        size: 10
      },
      dialogFormVisible: false,
      total: 0,
      defaultPage: 1,
      defaultSize: 10,
      dialogType: 'add',
      formLabelWidth: '150px',
      permissionTree: {},
      defaultProps: {
        children: 'children',
        label: 'label'
      },
      // 按钮权限
      addDisable: true,
      editDisable: true,
      deleteDisable: true,
      listPermission: true,
      // 表单校验
      rules: {
        name: [{ required: true, trigger: 'blur', validator: validateRoleName }],
        description: [{ required: true, message: this.$t('role.descriptionError'), trigger: 'blur' }]
      }
    }
  },

  created() {
    this.checkButtonPermission()
    // 如果发现没有 listPermission 就需要向其展示权限不足提示
    if (!this.listPermission) {
      this.$router.push('/forbidden/index')
    }

    this.getList(this.queryParam)
    this.getPermissionTree()
  },

  mounted() {
    this.$nextTick(() => {
      setTimeout(() => {
        if (localStorage.getItem('roleIndexNew') === null || localStorage.getItem('roleIndexNew') !== '1') {
          this.$intro.start()
          localStorage.setItem('roleIndexNew', 1)
        }
      }, 300)
    })
  },

  methods: {
    checkPermission,
    checkButtonPermission() {
      this.addDisable = !checkPermission(['roleAdd'])
      this.editDisable = !checkPermission(['roleEdit'])
      this.deleteDisable = !checkPermission(['roleDelete'])
      this.listPermission = checkPermission(['roleList'])
    },
    // 初始化角色列表数据
    getList(queryParam) {
      this.listLoading = true
      getRoleList(queryParam).then(res => {
        this.tableData = res.data.results
        this.total = res.data.count
        this.listLoading = false
      }).catch(() => {
        this.listLoading = false
      })
    },
    getQueryList() {
      this.queryParam.page = this.defaultPage
      this.queryParam.size = this.defaultSize
      this.getList(this.queryParam)
    },
    // 初始化树节点数据
    getPermissionTree() {
      getPermissionTree().then(res => {
        this.permissionTree = res.data
      })
    },
    // 编辑/更新 提交
    submit() {
      this.$refs['roleForm'].validate(valid => {
        if (!valid) {
          return false
        }
        this.dialogFormVisible = false
        this.role.permissions = this.$refs.tree.getCheckedKeys()
        // bug 树节点父子关联的时候，选中部分子节点并不会把父节点的id也传过去，所以父节点需要单独获取
        const parent = this.$refs.tree.getHalfCheckedKeys()
        this.role.permissions.push(...parent)
        if (this.dialogType === 'edit') {
          this.listLoading = true
          updateRoleById(this.role.id, this.role).then(res => {
            this.$message({
              message: this.$t('common.modifiedSuccessfully'),
              type: 'success'
            })
            // 重新获取页面数据
            this.getList(this.queryParam)
          }).catch(() => {
            this.listLoading = false
            this.$message.error(this.$t('common.modificationFailed'))
          })
        }
        if (this.dialogType === 'add') {
          this.listLoading = true
          addRole(this.role).then(res => {
          // 重新获取页面数据
            this.$message({
              message: this.$t('common.addedSuccessfully'),
              type: 'success'
            })
            this.getList(this.queryParam)
          }).catch(() => {
            this.listLoading = false
            this.$message.error(this.$t('common.addFailed'))
          })
        }
      })
    },
    // 新增按钮点击弹窗
    add() {
      this.dialogType = 'add'
      this.dialogFormVisible = true
      this.role = {
        name: '',
        description: '',
        permissionTree: []
      }
      if (this.$refs['roleForm']) {
        this.$refs['roleForm'].resetFields()
      }
      // 清空树节点
      if (this.$refs.tree) {
        this.$refs.tree.setCheckedKeys(this.role.permissionTree)
      }
    },
    // 编辑按钮点击弹窗
    edit(id) {
      if (this.$refs['roleForm']) {
        this.$refs['roleForm'].resetFields()
      }
      getRoleById(id).then(res => {
        this.role = res.data
        // 只设置子节点选中情况，不设置父节点选中情况
        this.$nextTick(() => {
          const arr = []
          this.role.permissions.forEach(item => {
            if (!this.$refs.tree.getNode(item).childNodes || !this.$refs.tree.getNode(item).childNodes.length) {
              arr.push(item)
            }
          })
          this.$refs.tree.setCheckedKeys(arr)
        })
      })
      this.dialogType = 'edit'
      this.dialogFormVisible = true
    },
    // 删除数据
    deleteRole(id) {
      this.listLoading = true
      if (id === 6 || id === 12) {
        this.$message.error(this.$t('role.protectedRole'))
        this.listLoading = false
        return false
      } else {
        deleteRoleById(id).then(res => {
        // 重新获取页面数据
          this.$message({
            message: this.$t('common.deleteSucceeded'),
            type: 'success'
          })
          this.getList(this.queryParam)
        }).catch(() => {
          this.listLoading = false
          this.$message.error(this.$t('common.deletionFailed'))
        })
      }
    },
    indexMethod(index) {
      return (this.queryParam.page - 1) * this.queryParam.size + index + 1
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
      this.defaultPage = page
      this.getList(this.queryParam)
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
