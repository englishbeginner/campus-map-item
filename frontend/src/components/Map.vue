<template>
  <div class="map-wrapper">
    <!-- 搜索框 -->
    <div class="search-container">
      <div class="search-box">
        <input 
          v-model="searchKeyword" 
          type="text" 
          placeholder="搜索建筑或地点..."
          @keyup.enter="handleSearch"
          @focus="showSearchResult = true"
        />
        <button @click="handleSearch">搜索</button>
      </div>
      
      <!-- 搜索结果列表 -->
      <div v-if="showSearchResult && searchResults.length > 0" class="search-results">
        <div
          v-for="item in searchResults"
          :key="item.id"
          class="search-result-item"
          @click="handleSearchResultClick(item)"
        >
          <span>{{ item.name }}</span>
          <span v-if="item.alias" class="alias">({{ item.alias }})</span>
        </div>
      </div>
    </div>
    
    <!-- 3D模式切换按钮 -->
    <div class="mode-toggle">
      <button 
        class="toggle-btn" 
        :class="{ active: is3DMode }"
        @click="toggle3DMode"
      >
        {{ is3DMode ? '2D模式' : '3D模式' }}
      </button>
    </div>
    
    <!-- 地图容器 -->
    <div id="map-container" class="map-container"></div>
    
    <!-- POI 详情弹窗 -->
    <div v-if="selectedPOI" class="poi-detail" @click.stop>
      <div class="poi-detail-header">
        <h3>{{ selectedPOI.name }}</h3>
        <button @click="closeDetail" class="close-btn">×</button>
      </div>
      <div v-if="selectedPOI.photo_url" class="poi-photo">
        <img :src="selectedPOI.photo_url" :alt="selectedPOI.name" />
      </div>
      <div class="poi-info">
        <p v-if="selectedPOI.alias">别名：{{ selectedPOI.alias }}</p>
        <p v-if="selectedPOI.description">{{ selectedPOI.description }}</p>
      </div>
      <div class="poi-actions">
        <button @click="navigateToPOI(selectedPOI)" class="nav-btn">导航</button>
        <button @click="closeDetail" class="close-btn">关闭</button>
      </div>
    </div>
    
    <!-- 公交线路Tab -->
    <div class="bus-tabs">
      <div class="tab-header">
        <div 
          v-for="(route, index) in busRoutes" 
          :key="route.id"
          class="tab-item"
          :class="{ active: activeBusRoute === index }"
          @click="handleBusRouteChange(index)"
        >
          {{ route.route_name }}
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import AMapLoader from '@amap/amap-jsapi-loader'
import { getPOIListInBounds, searchPOI, getPOIDetail } from '@/api/poi'
import { getBusRoutes, getBusRouteStops } from '@/api/bus'

// 地图相关
const map = ref(null)
const poiMarkers = ref([])
const polygons = ref([])
const busPolylines = ref([])
const busMarkers = ref([])
const is3DMode = ref(false) // 3D模式状态

// 搜索相关
const searchKeyword = ref('')
const searchResults = ref([])
const showSearchResult = ref(false)

// POI相关
const selectedPOI = ref(null)

// 公交线路相关
const busRoutes = ref([])
const activeBusRoute = ref(0)

// 初始化地图
const initMap = async () => {
  try {
    const AMap = await AMapLoader.load({
      key: import.meta.env.VITE_AMAP_KEY,
      version: '2.0',
      plugins: ['AMap.Scale', 'AMap.ToolBar', 'AMap.Geolocation', 'AMap.Walking']
    })

    // 定义学校边界范围（根据实际校园范围调整）
    // 西南角：最小经度，最小纬度
    // 东北角：最大经度，最大纬度
    const schoolBounds = new AMap.Bounds(
      new AMap.LngLat(106.417844, 29.813674), // 西南角
      new AMap.LngLat(106.434404, 29.830634)  // 东北角
    )

    // 初始化地图
    map.value = new AMap.Map('map-container', {
      zoom: 16, // 设置缩放级别为 16，显示约 50 米范围
      center: [106.426078, 29.822262], // 默认使用 8 号教学楼坐标
      viewMode: is3DMode.value ? '3D' : '2D',
      zooms: [14, 19], // 限制缩放级别范围
      showLabel: false // 隐藏地图上的文字标注（建筑名、路名等）
    })

    // 限制地图拖动范围
    map.value.setLimitBounds(schoolBounds)
    
    // 确保设置正确的缩放级别
    map.value.setZoom(18) // 缩放级别18大约对应50米范围

    // 添加控件
    map.value.addControl(new AMap.Scale())
    map.value.addControl(new AMap.ToolBar())

    // 监听地图事件
    map.value.on('zoomend', loadPOIsInBounds)
    map.value.on('moveend', loadPOIsInBounds)

    // 首次加载 POI
    loadPOIsInBounds()
    
    // 加载公交线路
    loadBusRoutes()
    
    // 添加测试标记：8号教学楼
    const testMarker = new AMap.Marker({
      position: [106.426078, 29.822262] // 8号教学楼坐标
      // 不设置icon，使用默认图标
      // 不设置title，隐藏文字信息
    })
    testMarker.setMap(map.value)
    
    // 添加27号教学楼标记
    const building27Marker = new AMap.Marker({
      position: [106.42272, 29.823184] // 27号教学楼坐标
      // 不设置icon，使用默认图标
      // 不设置title，隐藏文字信息
    })
    building27Marker.setMap(map.value)
    
    // 添加9号教学楼标记
    const building9Marker = new AMap.Marker({
      position: [106.429384, 29.826307] // 9号教学楼坐标
      // 不设置icon，使用默认图标
      // 不设置title，隐藏文字信息
    })
    building9Marker.setMap(map.value)
    
    // 添加10号教学楼标记
    const building10Marker = new AMap.Marker({
      position: [106.429063, 29.826791] // 10号教学楼坐标
      // 不设置icon，使用默认图标
      // 不设置title，隐藏文字信息
    })
    building10Marker.setMap(map.value)
    
    // 添加25号教学楼标记
    const building25Marker = new AMap.Marker({
      position: [106.424369, 29.822734] // 25号教学楼坐标
      // 不设置icon，使用默认图标
      // 不设置title，隐藏文字信息
    })
    building25Marker.setMap(map.value)
    
    // 添加第二运动场标记
    const secondSportsFieldMarker = new AMap.Marker({
      position: [106.427544, 29.825603] // 第二运动场坐标
      // 不设置icon，使用默认图标
      // 不设置title，隐藏文字信息
    })
    secondSportsFieldMarker.setMap(map.value)
    
    // 添加杏园食堂标记
    const xingyuanCanteenMarker = new AMap.Marker({
      position: [106.42617, 29.825155] // 杏园食堂坐标
      // 不设置icon，使用默认图标
      // 不设置title，隐藏文字信息
    })
    xingyuanCanteenMarker.setMap(map.value)
    
    // 飞点到8号教学楼，确保默认显示该位置
    map.value.setCenter([106.426078, 29.822262])
    map.value.setZoom(18) // 调整缩放级别，显示约50米范围
  } catch (error) {
    console.error('地图加载失败:', error)
  }
}



// 加载视野内的 POI
const loadPOIsInBounds = async () => {
  if (!map.value) return

  try {
    const bounds = map.value.getBounds()
    const southWest = bounds.getSouthWest()
    const northEast = bounds.getNorthEast()

    const params = {
      minLng: southWest.getLng(),
      maxLng: northEast.getLng(),
      minLat: southWest.getLat(),
      maxLat: northEast.getLat()
    }

    const res = await getPOIListInBounds(params)
    renderPOIMarkers(res)
  } catch (error) {
    console.error('加载 POI 失败:', error)
  }
}

// 渲染 POI 标记
const renderPOIMarkers = (pois) => {
  // 清除旧标记
  clearMarkers()

  pois.forEach(poi => {
    const marker = new window.AMap.Marker({
      position: [poi.center_lng, poi.center_lat],
      extData: poi
      // 不设置icon，使用默认图标
      // 不设置title，隐藏文字信息
    })

    marker.setMap(map.value)
    poiMarkers.value.push(marker)

    // 点击标记显示详情
    marker.on('click', async (e) => {
      const poiData = e.target.getExtData()
      await showPOIDetail(poiData.id)
    })

    // 绘制建筑轮廓
    if (poi.boundary) {
      try {
        const boundary = JSON.parse(poi.boundary)
        if (boundary && boundary.length > 0) {
          const polygon = new window.AMap.Polygon({
            path: boundary,
            fillColor: 'rgba(0, 128, 255, 0.2)',
            strokeColor: '#0080ff',
            strokeWeight: 1
          })
          polygon.setMap(map.value)
          polygons.value.push(polygon)
        }
      } catch (error) {
        console.error('解析边界数据失败:', error)
      }
    }
  })
}

// 不使用自定义图标，使用默认图标
const getPOIIcon = (type) => {
  return null
}

// 不使用自定义图标
const createMarkerIcon = (iconUrl) => {
  return null
}

// 清除所有标记
const clearMarkers = () => {
  poiMarkers.value.forEach(marker => {
    marker.setMap(null)
  })
  poiMarkers.value = []
  
  polygons.value.forEach(polygon => {
    polygon.setMap(null)
  })
  polygons.value = []
}

// 显示 POI 详情
const showPOIDetail = async (id) => {
  try {
    const res = await getPOIDetail(id)
    selectedPOI.value = res
    
    // 飞点到该位置
    map.value.setCenter([res.center_lng, res.center_lat])
    map.value.setZoom(18)
  } catch (error) {
    console.error('获取 POI 详情失败:', error)
  }
}

// 搜索 POI
const handleSearch = async () => {
  if (!searchKeyword.value.trim()) return

  try {
    const results = await searchPOI(searchKeyword.value)
    searchResults.value = results
    showSearchResult.value = true
  } catch (error) {
    console.error('搜索失败:', error)
    alert('搜索失败，请稍后重试')
  }
}

// 处理搜索结果点击
const handleSearchResultClick = async (item) => {
  // 飞到搜索结果位置
  map.value.setCenter([item.center_lng, item.center_lat])
  map.value.setZoom(18)
  await showPOIDetail(item.id)
  showSearchResult.value = false
}

// 关闭详情
const closeDetail = () => {
  selectedPOI.value = null
}

// 导航到POI
const navigateToPOI = (poi) => {
  if (!map.value) return

  const geolocation = new window.AMap.Geolocation({
    enableHighAccuracy: true
  })

  geolocation.getCurrentPosition(function(status, result) {
    if (status === 'complete') {
      const start = result.position
      const end = [poi.center_lng, poi.center_lat]

      // 初始化步行导航
      const walking = new window.AMap.Walking({
        map: map.value
      })

      // 规划路径
      walking.search(start, end, function(status, result) {
        if (status === 'complete') {
          // 路径规划成功
          console.log('路径规划成功:', result)
        } else {
          console.error('路径规划失败:', result)
        }
      })
    } else {
      console.error('获取位置失败:', result)
    }
  })
}

// 加载公交线路
const loadBusRoutes = async () => {
  try {
    const data = await getBusRoutes()
    busRoutes.value = data
  } catch (error) {
    console.error('加载公交线路失败:', error)
  }
}

// 处理公交线路切换
const handleBusRouteChange = async (index) => {
  if (!map.value || !busRoutes.value[index]) return

  activeBusRoute.value = index
  const route = busRoutes.value[index]

  // 清除旧的公交线路
  clearBusRoutes()

  try {
    // 获取线路站点和轨迹
    const data = await getBusRouteStops(route.id)

    // 绘制线路轨迹
    if (data.path_coords) {
      try {
        const pathCoords = JSON.parse(data.path_coords)
        if (pathCoords && pathCoords.length > 0) {
          const polyline = new window.AMap.Polyline({
            path: pathCoords,
            strokeColor: '#ff6600',
            strokeWeight: 4,
            strokeStyle: 'solid'
          })
          polyline.setMap(map.value)
          busPolylines.value.push(polyline)
        }
      } catch (error) {
        console.error('解析轨迹数据失败:', error)
      }
    }

    // 添加站点标记
    if (data.stops) {
      data.stops.forEach(stop => {
        const marker = new window.AMap.Marker({
          position: [stop.lng, stop.lat],
          icon: new window.AMap.Icon({
            size: new window.AMap.Size(24, 24),
            image: 'https://a.amap.com/jsapi_demos/static/demo-center/icons/poi-marker-default.png'
          })
          // 不设置title，隐藏文字信息
        })
        marker.setMap(map.value)
        busMarkers.value.push(marker)
      })
    }

    // 调整地图视野
    if (data.path_coords) {
      try {
        const pathCoords = JSON.parse(data.path_coords)
        if (pathCoords && pathCoords.length > 0) {
          map.value.setFitView(busPolylines.value.concat(busMarkers.value))
        }
      } catch (error) {
        console.error('解析轨迹数据失败:', error)
      }
    }
  } catch (error) {
    console.error('加载公交线路详情失败:', error)
  }
}

// 清除公交线路
const clearBusRoutes = () => {
  busPolylines.value.forEach(polyline => polyline.setMap(null))
  busMarkers.value.forEach(marker => marker.setMap(null))
  busPolylines.value = []
  busMarkers.value = []
}

// 切换2D/3D模式
const toggle3DMode = () => {
  is3DMode.value = !is3DMode.value
  if (map.value) {
    // 重新初始化地图以切换模式
    map.value.destroy()
    initMap()
  }
}

onMounted(() => {
  initMap()
})
</script>

<style scoped>
.map-wrapper {
  width: 100%;
  height: 100vh;
  position: relative;
}

.map-container {
  width: 100%;
  height: 100vh;
}

.search-container {
  position: absolute;
  top: 10px;
  left: 50%;
  transform: translateX(-50%);
  z-index: 1000;
  width: 90%;
  max-width: 400px;
}

.mode-toggle {
  position: absolute;
  top: 10px;
  right: 10px;
  z-index: 1000;
}

.toggle-btn {
  padding: 8px 16px;
  background: white;
  color: #333;
  border: 1px solid #ddd;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
}

.toggle-btn:hover {
  background: #f5f5f5;
}

.toggle-btn.active {
  background: #0091ff;
  color: white;
  border-color: #0091ff;
}

.search-box {
  display: flex;
  gap: 8px;
  background: white;
  padding: 10px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
}

.search-box input {
  flex: 1;
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.search-box button {
  padding: 8px 16px;
  background: #0091ff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.search-box button:hover {
  background: #0078d4;
}

.search-results {
  position: absolute;
  top: 60px;
  left: 0;
  right: 0;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  max-height: 300px;
  overflow-y: auto;
  z-index: 1001;
}

.search-result-item {
  padding: 12px 16px;
  border-bottom: 1px solid #f0f0f0;
  cursor: pointer;
}

.search-result-item:hover {
  background-color: #f5f5f5;
}

.alias {
  color: #999;
  margin-left: 8px;
}

.poi-detail {
  position: absolute;
  bottom: 100px;
  left: 50%;
  transform: translateX(-50%);
  z-index: 1000;
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.3);
  min-width: 300px;
  max-width: 400px;
  max-height: 60vh;
  overflow-y: auto;
}

.poi-detail-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.poi-detail-header h3 {
  margin: 0;
  color: #333;
  font-size: 18px;
}

.close-btn {
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
  color: #999;
  padding: 0;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.close-btn:hover {
  color: #333;
}

.poi-photo {
  margin-bottom: 16px;
}

.poi-photo img {
  width: 100%;
  height: 200px;
  object-fit: cover;
  border-radius: 8px;
}

.poi-info {
  margin-bottom: 20px;
}

.poi-info p {
  margin: 8px 0;
  color: #666;
  font-size: 14px;
  line-height: 1.5;
}

.poi-actions {
  display: flex;
  gap: 10px;
  justify-content: flex-end;
}

.nav-btn {
  padding: 8px 16px;
  background: #0091ff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.nav-btn:hover {
  background: #0078d4;
}

.bus-tabs {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: white;
  border-radius: 16px 16px 0 0;
  box-shadow: 0 -2px 12px rgba(0, 0, 0, 0.1);
  padding: 16px;
  z-index: 999;
}

.tab-header {
  display: flex;
  overflow-x: auto;
  gap: 10px;
  padding-bottom: 8px;
}

.tab-item {
  padding: 8px 16px;
  border-radius: 20px;
  background: #f5f5f5;
  white-space: nowrap;
  cursor: pointer;
  font-size: 14px;
}

.tab-item.active {
  background: #0091ff;
  color: white;
}

.tab-item:hover {
  background: #e0e0e0;
}

.tab-item.active:hover {
  background: #0078d4;
}
</style>