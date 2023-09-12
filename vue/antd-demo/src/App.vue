<script setup> 
  import MyComponent from './MyComponent.vue'
  </script>

<template>
  <a-layout class="layout">
    <a-layout-header>
      <div class="logo" />
      <a-menu
        theme="dark"
        mode="horizontal"
        :style="{ lineHeight: '64px' }"
      >
        <a-menu-item key="1">Parlamentarier:innen</a-menu-item>
        <a-menu-item key="2">Info</a-menu-item>
        <!-- <a-menu-item key="3">nav 3</a-menu-item> -->
      </a-menu>
    </a-layout-header>
    <a-layout-content style="padding: 0 50px">
      <a-breadcrumb style="margin: 16px 0">
        <!-- <a-breadcrumb-item>Home</a-breadcrumb-item> -->
        <!-- <a-breadcrumb-item>List</a-breadcrumb-item> -->
        <!-- <a-breadcrumb-item>App</a-breadcrumb-item> -->
      </a-breadcrumb>
      <div :style="{ background: '#F5F5F5', padding: '24px', minHeight: '280px' }">
          <MyComponent />
      </div>
    </a-layout-content>
    <a-layout-footer style="text-align: center">

    </a-layout-footer>
  </a-layout>
</template>

<style scoped>
.site-layout-content {
  min-height: 280px;
  padding: 24px;
  background: #fff;
}
#components-layout-demo-top .logo {
  float: left;
  width: 120px;
  height: 31px;
  margin: 16px 24px 16px 0;
  background: rgba(255, 255, 255, 0.3);
}
.ant-row-rtl #components-layout-demo-top .logo {
  float: right;
  margin: 16px 0 16px 24px;
}

[data-theme='dark'] .site-layout-content {
  background: #141414;
}
</style>