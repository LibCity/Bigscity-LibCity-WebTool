from apscheduler.schedulers.background import BackgroundScheduler

from business.threads import ExecuteCommandThread

scheduler = BackgroundScheduler(timezone='Asia/Shanghai')
scheduler.start()


def task_execute(*args):
    ExecuteCommandThread(args[0], args[1]).start()


def task_execute_at(task_name, str_command, run_date, task_id):
    """
    定点执行任务

    :param task_id: 任务id
    :param task_name: 任务名
    :param str_command: 任务命令
    :param run_date: 执行时间：yyyy-MM-dd HH:mm:ss 例如：2021-12-27 17:14:01
    :return:
    """
    scheduler.add_job(task_execute, 'date', run_date=run_date, args=[task_name, str_command], name=task_id)


def task_execute_days(func, days):
    """
    定时任务 按天执行

    :param func: 需要定时执行任务的函数
    :param days: 多少天执行一次
    """
    scheduler.add_job(func, 'interval', days=days)


def task_is_exists(task_id):
    """
    任务是否已经加入定点执行的队列中

    :param task_id: 任务id
    :return: True or False
    """
    jobs = scheduler.get_jobs()
    for job in jobs:
        if job.name == task_id:
            return True
    return False


def remove_task(task_id):
    """
    根据任务名移除任务

    :param task_id: 任务id
    :return:
    """
    jobs = scheduler.get_jobs()
    for job in jobs:
        if job.name == task_id:
            job.remove()
