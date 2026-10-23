# CTViewer · 3D 汽车拆解可视化查看器

基于 **Three.js** 的纯前端 3D 汽车拆解（爆炸图 / 装配图）查看器，支持车型切换、单部件拾取、实时换漆与旋转构图，**可全离线运行**（Three.js 运行时与 Draco 解码器已内置，不依赖任何 CDN）。

> 在线地址：[https://codeganhaoz.github.io/CTViewer/](https://codeganhaoz.github.io/CTViewer/)
> 主页面：[car-exploded.html](https://codeganhaoz.github.io/CTViewer/car-exploded.html) ｜ 选型台：[car-model-picker.html](https://codeganhaoz.github.io/CTViewer/car-model-picker.html)

---

## ✨ 功能特性

- **双车型切换**：Concept Car（零件级，109 网格，含方向盘/轮辐/踏板/刹车盘/车门内饰板）与 Ferrari 458（总成级，51 网格），标签页动态生成。
- **拆解 ↔ 装配动画**：100+ 部件沿「径向 + 分组偏置」方向爆炸（车身向上、内饰向下、动力向后、轮组沿 ±X），避免糊成一团。
- **实时换漆 + 工艺**：车漆替换为带清漆层的 `MeshPhysicalMaterial`，支持原厂色 / 金属 / 珠光 / 哑光 / 糖果工艺，460ms 缓动过渡，按车型各存一份不串色。
- **交互拾取**：射线拾取、悬停高亮（菲涅尔壳层而非染色）、点击切换拆解、空格全展开、双轴取大自动构图。
- **界面**：科技蓝黑主题、主题化滚动条、顶栏呼吸光标记、十余处 CSS 动效（已适配 `prefers-reduced-motion` 降级）。
- **加载韧性**：线上资源走 jsDelivr 镜像（带 CORS、比 GitHub Pages 快 7–9 倍），失败自动回退同源；渐进式加载 + 进度封顶 + 超时提示 + 失败重试。

## 🧩 页面构成

| 文件 | 说明 |
|---|---|
| `index.html` | 根目录入口，自动跳转主页面（补全 GitHub Pages 根地址） |
| `car-exploded.html` | **主交付物**：双车型拆解查看器（约 2200 行） |
| `car-model-picker.html` | 选型台：4 个 glTF 模型实时预览 + 真实结构指标对比 |
| `dji-action4-exploded.html` | 起源参考页（DJI Osmo Action 4 三维拆解，验证方案可行性） |
| `项目说明.md` | 中文项目说明（开发历程 / 技术踩坑 / 选型结论） |
| `serve.bat` | 双击起本地预览（`python -m http.server 8123`） |

## 📁 目录结构

```
CTViewer/
├─ car-exploded.html          # 主查看器
├─ car-model-picker.html      # 车型选型台
├─ dji-action4-exploded.html  # 参考页
├─ index.html                 # 根入口（跳转）
├─ serve.bat                  # 本地预览启动脚本
├─ assets/cars/
│  ├─ carconcept.draco.glb    # Concept（Draco 压缩版，4.0 MB）
│  ├─ carconcept.glb          # Concept（原始版，11.2 MB）
│  ├─ ferrari.glb             # Ferrari（Draco 压缩）
│  ├─ ferrari_ao.png          # 环境光遮蔽贴图
│  ├─ toycar.glb / truck.glb  # 备选模型（选型台用）
│  └─ kenney/                 # Kenney CC0 车包（当前禁用，保留）
└─ vendor/three/              # 离线 Three.js 运行时
   ├─ three.module.js         # r0.169
   ├─ addons/                 # GLTFLoader / DRACOLoader / OrbitControls / RoomEnvironment
   └─ addons/libs/draco/gltf/ # Draco 解码器（.wasm + .js）
```

## 🚀 本地运行

> Three.js 使用 ES Module + importmap，**不能直接 `file://` 打开**，需经 HTTP 服务。

**方式一：一键脚本（Windows）**

```bat
双击 serve.bat
```

自动启动 `http://localhost:8123/` 并打开主页面。

**方式二：任意静态服务器**

```bash
# 项目根目录执行
python -m http.server 8123
# 然后浏览器访问
#   http://localhost:8123/car-exploded.html
#   http://localhost:8123/car-model-picker.html
```

## 🌐 部署与在线访问

- 已开启 **GitHub Pages**（从 `main` 分支根目录部署）：<https://codeganhaoz.github.io/CTViewer/>
- 静态站点全部使用**相对路径**（`assets/…`、`vendor/…`），可在 `/CTViewer/` 子路径下正常加载。
- 大模型资源通过 **jsDelivr**（`cdn.jsdelivr.net/gh/CodeGanHaoZ/CTViewer@main/…`）加速，失败回退 GitHub Pages 源。

## 🛠 技术栈

- **渲染**：Three.js r0.169（ESM + importmap）
- **模型**：GLTFLoader + DRACOLoader（Draco 几何压缩）
- **控制**：OrbitControls
- **后期**：EffectComposer + UnrealBloom（辉光）
- **环境**：RoomEnvironment（基于图像的照明）
- **材质**：MeshPhysicalMaterial（clearcoat 清漆层 / transmission 透射 / texture_transform）

## 📝 体积优化说明

Concept 原始 GLB 11.23 MB（几何 8.27 MB + 贴图 2.79 MB）。通过 `@gltf-transform` 进行 Draco 几何压缩（保留 `KHR_materials_clearcoat` 等 6 个扩展），降至 **4.00 MB（压掉 64%）**，节点 / 材质 / 网格数量完全不变。原始文件 `carconcept.glb` 仍保留在仓库中，仅未用于线上加载。

## 📄 许可

代码与文档遵循仓库根目录 `LICENSE`。模型资产版权归属各自原作者：

- **Concept / Ferrari**：Khronos glTF Sample Assets（宽松署名许可）
- **Kenney 车包**：Kenney CC0（已内置但当前未启用）
