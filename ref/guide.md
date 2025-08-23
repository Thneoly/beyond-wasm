📖 《Beyond the Browser: WebAssembly 全景解析》撰写指导

1. 总体原则
   面向开发者：主要目标读者是对 WebAssembly 感兴趣的开发者，包括 Web 工程师、后端工程师、区块链工程师和系统工程师。
   循序渐进：从基础到进阶，逐步展开，避免一上来就堆细节。
   理论 + 实践结合：每一章最好有 概念解释 + 代码示例 + 实际应用场景。
   保持独立性：单章可独立阅读，但相互之间有递进关系。
   中英文兼顾：主要内容中文，代码注释与关键技术词汇保持英文，以便读者搜索和参考官方资料。
2. 章节写作建议
   第 1 章 引言
   目标：回答「为什么要学习 WASM」
   重点：
   简史（起源于浏览器 → 跨平台运行时）
   与传统字节码/虚拟机（JVM, CLR）的对比
   应用领域概览（Web、Serverless、区块链、插件系统、AI/ML）
   建议配图：WASM 在不同生态中的定位图
   第 2 章 基础篇：WASM 核心概念
   目标：让读者理解 WASM 是什么样的字节码和执行模型
   内容：
   Text format (.wat) 与 Binary format (.wasm) 对照
   类型系统（基本类型、函数签名）
   线性内存模型
   模块、导入/导出机制
   安全性（沙箱、确定性执行）
   示例：最小的 .wat 文件和对应 .wasm 的运行
   第 3 章 运行时与工具链
   目标：展示 如何运行 WASM 程序
   内容：
   主流运行时对比：Wasmtime、Wasmer、WasmEdge、WAMR
   编译工具链（LLVM, Emscripten, Rust 的 wasm32-\* target）
   调试工具（wasm-tools, wasmtime inspect）
   示例：
   使用 Rust 生成 WASM 并在 Wasmtime 中运行
   第 4 章 WASI（System Interface）
   目标：解释 为什么需要 WASI 以及它如何演进
   内容：
   WASI 的设计目标（标准化系统调用接口）
   preview1 的设计与局限
   preview2 的能力模型（capability-based）
   0.1 → 0.2 的变化
   示例：
   用 WASI 打开文件、打印时间
   第 5 章 组件模型与未来标准
   目标：展示 组件化和接口绑定如何扩展 WASM
   内容：
   动机（多语言互操作、组合模块）
   接口类型与 bindings
   组件拼接、虚拟化机制
   子规范：wasi:io, wasi:crypto, wasi:nn
   示例：
   两个 WASM 模块拼接成一个组件
   第 6 章 应用场景与模式
   目标：让读者看到 WASM 在真实世界的使用方式
   场景：
   浏览器中的 WASM
   边缘计算与 Serverless
   区块链智能合约
   插件系统（如 Envoy, Postgres, WasmCloud）
   AI/ML 推理
   示例：用 WasmEdge 跑一个 AI 推理 demo
   第 7 章 实践与示例
   目标：动手操作 + 综合案例
   示例集合：
   Hello World（Rust/C）
   访问文件系统（WASI）
   组件拼接
   插件式架构（Host + Plugin）
   第 8 章 展望与生态
   目标：展现 WASM 的未来
   内容：
   多语言互操作
   与容器（Docker/OCI）的关系
   安全模型的演进
   标准化趋势与产业落地
   建议配图：WASM Roadmap 时间线
   附录
   CLI 命令速查表
   生态项目索引（Wasmtime、Wasmer、Spin、WasmCloud…）
   学习资源与链接
3. 写作风格要求
   章节开头：简要介绍本章要解决的问题
   正文：概念解释 + 示例代码 + 输出结果 + 应用场景
   章节末尾：小结（要点回顾，下一章预告）
   代码风格：Rust 为主，C/C++ 与 AssemblyScript 作为补充
   图表：必要时用架构图、流程图，降低抽象难度
4. 协作方式
   所有章节以 docs/xx-chapter.md 形式存放
   示例代码放在 examples/ 下，与章节一一对应
   每个章节最好单独开一个 PR，方便 Review 与改进
   保持术语一致性（如：WASI preview1 不要写成 Preview v1）
