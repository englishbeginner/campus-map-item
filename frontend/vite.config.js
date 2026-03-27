import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  // 注册Vue插件，支持.vue文件解析
  plugins: [vue()],
  // 开发服务器配置（解决跨域）
  server: {
    proxy: {
      // 匹配/api开头的请求，代理到后端地址
      '/api': {
        target: 'http://localhost:8080', // 后端服务地址
        changeOrigin: true, // 开启跨域
        rewrite: (path) => path // 路径不重写（若后端接口前缀也是/api，无需修改）
      }
    }
  }
})