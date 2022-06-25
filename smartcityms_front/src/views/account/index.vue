<template>
  <div class="app-container" :data-intro="$t('accountManageIntro.step01')" data-step="1">

    <!-- 顶部查询表单 -->
    <el-form size="small" :inline="true" class="demo-form-inline" :data-intro="$t('accountManageIntro.step02')" data-step="2">

      <el-form-item :label="$t('account.accountNumber')">
        <el-input v-model="queryParam.account_number" :placeholder="$t('account.pleaseInputAccount')" />
      </el-form-item>

      <el-form-item :label="$t('account.roles')">
        <el-select v-model="queryParam.roles" clearable :placeholder="$t('account.selectRole')">
          <el-option
            v-for="item in roleList"
            :key="item.id"
            :label="item.name"
            :value="item.id"
          >
            <span :title="item.description" style="float: left">{{ item.name }}</span>
          </el-option>
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
      <el-button size="small" type="primary" icon="el-icon-search" @click="getQueryList()">{{ $t('common.search') }}</el-button>
      <el-button size="small" type="default" icon="el-icon-delete" @click="resetData()">{{ $t('common.clear') }}</el-button>
    </el-form>

    <!-- 新增按钮 -->
    <el-button
      size="small"
      :data-intro="$t('accountManageIntro.step03')"
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
      border
      fit
    >
      <el-table-column
        type="index"
        :index="indexMethod"
        :label="$t('common.order')"
        width="120"
      />
      <el-table-column
        prop="account_number"
        :label="$t('account.accountNumber')"
      />
      <el-table-column
        prop="mail"
        :label="$t('account.mail')"
      />
      <el-table-column
        :label="$t('account.roles')"
      >
        <template slot-scope="scope">
          <span v-if="scope.row.roles.length === 0 "> {{ $t('account.noRole') }} </span>
          <span v-else>
            <span v-for="item in scope.row.roles" :key="item">
              {{ item }} <br>
            </span>
          </span>
        </template>
      </el-table-column>
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
          <el-button-group v-intro-if="scope.$index === 0" :data-intro="$t('accountManageIntro.step04')" data-step="4">
            <el-link
              :disabled="editDisable"
              style="margin-left: 10px"
              icon="el-icon-edit"
              @click="edit(scope.row.id)"
            >{{ $t('common.edit') }}</el-link>
            <el-popconfirm
              :confirm-button-text="$t('common.confirm')"
              :cancel-button-text="$t('common.cancel')"
              confirm-button-type="danger"
              cancel-button-type="info"
              icon="el-icon-info"
              icon-color="red"
              :title="$t('common.deleteConfirm')"
              @onConfirm="deleteAccount(scope.row.id)"
            >
              <el-link
                v-if="!deleteDisable"
                slot="reference"
                style="margin-left: 10px"
                :disabled="deleteDisable"
                icon="el-icon-delete"
              >{{ $t('common.delete') }}</el-link>
            </el-popconfirm>
            <el-link
              :disabled="editDisable"
              style="margin-left: 10px"
              icon="el-icon-refresh-right"
              @click="openResetDialog(scope.row.id)"
            >{{ $t('account.resetPassword') }}</el-link>
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
    <el-dialog :title="dialogType === 'edit' ? $t('account.edit') : $t('account.add')" :visible.sync="dialogFormVisible">
      <el-form ref="accountForm" :model="account" :rules="rules">
        <el-form-item :label="$t('account.accountNumber')" :label-width="formLabelWidth" prop="account_number">
          <el-input
            v-model="account.account_number"
            autocomplete="off"
            maxlength="16"
            show-word-limit
          />
        </el-form-item>
        <!-- <el-form-item :label="$t('account.password')" :label-width="formLabelWidth" prop="password">
          <el-input v-model="account.password" autocomplete="new-password" show-password />
        </el-form-item> -->
        <el-form-item :label="$t('account.roles')" :label-width="formLabelWidth">
          <el-select v-model="account.roles" multiple :placeholder="$t('account.selectRole')">
            <el-option
              v-for="item in roleList"
              :key="item.id"
              :label="item.name"
              :value="item.id"
            >
              <span :title="item.description" style="float: left">{{ item.name }}</span>
            </el-option>
          </el-select>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">{{ $t('common.cancel') }}</el-button>
        <el-button type="primary" @click="submit()">{{ $t('common.confirm') }}</el-button>
      </div>
    </el-dialog>
    <!-- 重置密码弹出框 -->
    <el-dialog
      :title="$t('account.resetPassword')"
      :visible.sync="resetPasswordDialogVisible"
    >
      <el-form ref="passwordForm" :model="account" :rules="passwdRules">
        <el-form-item :label="$t('account.password')" :label-width="formLabelWidth" prop="password">
          <el-input v-model="account.password" autocomplete="new-password" show-password />
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="resetPasswordDialogVisible = false">{{ $t('common.cancel') }}</el-button>
        <el-button type="primary" @click="resetPassword">{{ $t('common.confirm') }}</el-button>
      </span>
    </el-dialog>
  </div>
</template>
<script>
import { getAccountList, getAccountById, addAccount, updateAccountById, deleteAccountById, accountExists } from '@/api/account'
import { getRoleList } from '@/api/role'
import { checkPermission } from '@/utils/permission'

// 角色对象
const account = {
  id: '',
  account_number: '',
  password: null,
  roles: []
}
export default {
  data() {
    // 账号校验
    const validateAccountNumber = (rule, value, callback) => {
      if (value.length === 0) {
        callback(new Error(this.$t('account.accountNumberError')))
      } else {
        this.account.account_number = value
        accountExists(this.account).then(res => {
          if (res.code !== 200 && this.account.id !== res.msg.id) {
            callback(new Error(this.$t('account.accountNumberExistsError')))
          } else {
            callback()
          }
        })
      }
    }
    // 密码校验
    const validatePassword = (rule, value, callback) => {
      if (!value || value.length < 6) {
        callback(new Error(this.$t('login.passwordError')))
      } else {
        callback()
      }
    }
    return {
      account: account,
      listLoading: true,
      tableData: [],
      queryParam: {
        page: 1,
        size: 10,
        account_number: '',
        create_time: '',
        roles: null
      },
      dialogFormVisible: false,
      total: 0,
      dialogType: 'add',
      formLabelWidth: '150px',
      roleList: [], // 角色list
      defaultPage: 1,
      defaultSize: 10,
      resetPasswordDialogVisible: false, // 重置密码弹出框
      // 按钮权限
      addDisable: true,
      editDisable: true,
      deleteDisable: true,
      listPermission: true,
      // 表单校验
      rules: {
        account_number: [{ required: true, trigger: 'blur', validator: validateAccountNumber }]
      },
      // 重置密码表单校验
      passwdRules: {
        password: [{ required: true, trigger: 'blur', validator: validatePassword }]
      }
    }
  },

  created() {
    this.checkButtonPermission()
    // 如果发现没有 listPermission 就需要向其展示权限不足提示
    if (!this.listPermission) {
      this.$router.push('/forbidden/index')
    }

    // 权限通过，获取数据
    this.getList(this.queryParam)
    this.getRoleList()
  },

  mounted() {
    this.$nextTick(() => {
      setTimeout(() => {
        if (localStorage.getItem('accountIndexNew') === null || localStorage.getItem('accountIndexNew') !== '1') {
          this.$intro.start()
          localStorage.setItem('accountIndexNew', 1)
        }
      }, 300)
    })
  },

  methods: {
    checkPermission,
    checkButtonPermission() {
      this.addDisable = !checkPermission(['accountAdd'])
      this.editDisable = !checkPermission(['accountEdit'])
      this.deleteDisable = !checkPermission(['accountDelete'])
      this.listPermission = checkPermission(['accountList'])
    },
    // 获取列表数据
    getList(queryParam) {
      this.listLoading = true
      getAccountList(queryParam).then(res => {
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
    getRoleList() {
      getRoleList().then(res => {
        this.roleList = res.data.results
      })
    },
    // 编辑/更新 提交
    submit() {
      this.$refs['accountForm'].validate(valid => {
        if (!valid) {
          return false
        }
        this.dialogFormVisible = false
        if (this.dialogType === 'edit') {
          this.listLoading = true
          updateAccountById(this.account.id, this.account).then(res => {
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
          addAccount(this.account).then(res => {
            this.$notify({
              title: this.$t('common.addedSuccessfully'),
              message: this.$t('account.addedSuccessfully') + res.data.raw_password,
              type: 'success',
              duration: 10000
            })
            this.getList(this.queryParam)
          }).catch(() => {
            this.listLoading = false
            this.$message.error(this.$t('common.addFailed'))
          })
        }
      })
    },
    add() {
      this.account = {
        id: '',
        account_number: '',
        password: null,
        roles: []
      }
      this.dialogType = 'add'
      this.dialogFormVisible = true
    },
    edit(id) {
      this.dialogType = 'edit'
      this.dialogFormVisible = true
      getAccountById(id).then(res => {
        this.account = res.data
      })
    },
    // 打开重置密码对话框
    openResetDialog(id) {
      this.resetPasswordDialogVisible = true
      getAccountById(id).then(res => {
        this.account = res.data
      })
    },
    // 重置密码提交
    resetPassword() {
      this.resetPasswordDialogVisible = false
      this.$refs['passwordForm'].validate(valid => {
        if (!valid) {
          return false
        }
        updateAccountById(this.account.id, this.account).then(res => {
          this.$message({
            message: this.$t('account.resetPasswordSuccessfully'),
            type: 'success'
          })
          // 重新获取页面数据
          this.getList(this.queryParam)
          this.resetPasswordDialogVisible = false
        }).catch(() => {
          this.listLoading = false
          this.resetPasswordDialogVisible = false
          this.$message.error(this.$t('common.resetPasswordFailed'))
        })
      })
    },
    deleteAccount(id) {
      this.listLoading = true
      // 删除之前检查是否是系统保留账户
      if (id === 3) {
        this.$message.error(this.$t('account.protectedAccount'))
        this.listLoading = false
        return false
      } else {
        deleteAccountById(id).then(res => {
        // 重新获取页面数据
          this.$message({
            message: this.$t('common.deleteSucceeded'),
            type: 'success'
          })
          this.resetData()
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
