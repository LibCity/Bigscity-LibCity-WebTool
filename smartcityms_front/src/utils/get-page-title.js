import defaultSettings from '@/settings'
import i18n from '@/lang'

const title = defaultSettings.title || 'Vue Admin Template'

export default function getPageTitle(pageTitle) {
  if (pageTitle) {
    return i18n.t('route.' + pageTitle) + ` - ${title}`
  }
  return `${title}`
}
