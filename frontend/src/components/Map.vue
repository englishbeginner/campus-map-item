<template>
  <div id="map-container" class="map-container"></div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import AMapLoader from '@amap/amap-jsapi-loader'

const map = ref(null)

onMounted(async () => {
  try {
    const AMap = await AMapLoader.load({
      key: import.meta.env.VITE_AMAP_KEY,
      version: '2.0',
      plugins: ['AMap.Scale', 'AMap.ToolBar']
    })

    map.value = new AMap.Map('map-container', {
      zoom: 16,
      center: [116.327156, 39.984706], // 校园中心坐标
      viewMode: '2D'
    })

    // 添加控件
    map.value.addControl(new AMap.Scale())
    map.value.addControl(new AMap.ToolBar())
  } catch (error) {
    console.error('地图加载失败:', error)
  }
})
</script>

<style scoped>
.map-container {
  width: 100%;
  height: 100vh;
}
</style>