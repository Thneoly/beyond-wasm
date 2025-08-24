---
id: component-types-and-syntax
title: WIT 数据类型与语法速览
sidebar_label: 类型与语法速览
sidebar_position: 4
---

# WIT 数据类型与语法速览

## 可用数据类型（按类别）

- 标量（标记/数值）
  - `bool`
  - 有符号整数：`s8`, `s16`, `s32`, `s64`
  - 无符号整数：`u8`, `u16`, `u32`, `u64`
  - 浮点数：`float32`, `float64`
  - 字符：`char`（Unicode 标量值）
- 字符串与序列
  - `string`（UTF-8 字符串）
  - `list<T>`（顺序列表/数组，例如 `list<u8>` 可作字节序列）
- 复合类型
  - `record { ... }`（结构体：具名字段）
  - `tuple(T1, T2, ...)`（元组：按位置）
  - `enum { A, B, ... }`（枚举：离散无负载）
  - `flags { a, b, ... }`（位标志集合）
  - `variant { case1, case2: T, ... }`（带负载的可区分联合）
  - `option<T>`（语义等价于 `variant { none, some: T }`）
  - `result<T, E>`（语义等价于 `variant { ok: T, err: E }`）
  - 类型别名：`type name = <某类型>`
- 资源与句柄
  - `resource R`（在 interface 中定义带生命周期的句柄）
  - `own R` / `borrow R`（拥有或借用资源，用于参数/返回值中表达所有权与借用）

约束要点：
- `borrow R` 通常仅允许出现在函数参数的顶层位置，不能作为返回值或嵌套在复合类型中；
 - `own R` 可作为字段或返回值，以转移所有权；
- `string` 必为 UTF-8；原始字节请用 `list<u8>` 表达；
- `flags` 的位数可超过 32/64，ABI 会拆分为若干机器字；
- 没有 128 位整数或半精度浮点（`i128`/`f16`）这类内建类型；
 - 类型演进：为 record 新增必填字段属于破坏性变更；新增可选字段用 `option<T>`。

## 函数签名

`func(a: T1, b: T2, ...) -> Tret` — 参数与返回可由上述类型组合，但必须遵守资源借用限制（仅在顶层参数使用 `borrow R`，返回值使用 `own R` 以转移所有权）。

## 语言构造与关键字（常用）

- 声明/组织：`package`, `interface`, `world`, `use`（支持 `as` 重命名）, `import`, `export`, `func`
- 类型与构造：
  - 基本标量：`bool`, `char`, `s8/s16/s32/s64`, `u8/u16/u32/u64`, `float32/float64`
  - 文本与序列：`string`, `list<T>`, `tuple<...>`
  - 代数数据类型：`record { ... }`, `enum { ... }`, `flags { ... }`, `variant { ... }`
  - 可选与结果：`option<T>`, `result<T, E>`
  - 资源与所有权：`resource`, `own<T>`, `borrow<T>`
  - 别名：`type name = <type>`

## 资源成员（现代语法）

- 在 `resource` 块内可声明构造器与方法：
  - `constructor(...)` 构造；
  - 方法通常写成 `name: func(...) -> ...`（隐含 `this`）；
  - 也可用 `this: borrow/own` 形式显式声明接收者；
- 说明：不同工具链/版本对“静态方法”的写法略有差异，常见做法是在 `interface` 顶层用普通 `func`，或在 `resource` 内不带 `this` 的函数视为关联函数。

## 语法要点

- 注释：`//` 行注释，`///` 文档注释；
- 关键字与内建类型是保留标识符，不能用作自定义名称；

## 极简示例
```wit
package demo:math
interface algebra {
  /// 向量
  type vec = list<float64>

  /// 结构化结果
  record point { x: float64, y: float64 }

  /// 离散选项
  enum mode { fast, accurate }

  /// 标志位集合
  flags opts { a, b, c }

  /// 可区分联合（带负载）
  variant payload { none, num: s64, msg: string }

  /// 资源句柄
  resource session {
    constructor(seed: u64)
    set-mode: func(this: borrow session, m: mode)
    compute: func(this: borrow session, v: vec, o: opts) -> result<point, string>
  }

  // 普通函数（无资源接收者）
  dot: func(a: vec, b: vec) -> result<float64, string>
}

world math-world {
  export algebra
}
```

## 对比与取舍：enum vs flags vs variant

示例定义：

```wit
// 离散等级（互斥、无负载）
enum level { info, warn, error }

// 可组合的权限集合（位标志，可多选）
flags perms { read, write, exec }

// 互斥的带负载联合（文本或二进制）
variant payload { text: string, data: list<u8> }
```

- 语义：
  - enum 是“互斥且无负载”的闭集标签；
  - flags 是“可并集”的位集合，适合开/关类选项；
  - variant 是“互斥且可携带不同负载”的可区分联合。
- 组合性：
  - enum 不能同时取多个值；
  - flags 支持组合（如 `read|write`）；
  - variant 只能多选一，每个分支负载类型可不同。
- ABI/演进：
  - enum/variant 新增分支通常是破坏性变更（旧消费者不识别新分支）；
  - flags 新增位通常更易前向兼容（旧消费者可忽略未知位）。

最小使用示例：

```wit
interface demo {
  log: func(lv: level, p: payload, ps: perms)
}
```

## 对比与取舍：record vs variant（kv 与 payload）

示例定义：

```wit
record kv { key: string, value: string }
variant payload { text: string, data: list<u8> }
```

- 语义：
  - record 是“乘积类型”，字段同时存在，表达并列信息（如键和值）；
  - variant 是“和类型”，分支互斥，只能选择其中一种形态（文本或二进制）。
- 使用场景：
  - 当两个字段应“同时出现且各司其职”用 record（如 `kv`）；
  - 当两种形态“只能选其一”用 variant（如 `payload`）。
- 兼容性：
  - record 新增必填字段是破坏性变更；新增可选字段用 `option<T>`；
  - variant 新增分支通常是破坏性变更（建议以新类型/新接口发布）。

## 非法签名示例（资源借用限制）

以下写法违反“borrow 仅能出现在函数参数顶层位置”的约束：

```wit
interface io {
  resource socket {
    // ...
  }

  // ❌ 无效：借用资源不能作为返回值
  get: func() -> borrow socket

  // ❌ 无效：不能将 borrow 嵌入复合类型
  send-bad1: func(msg: record { s: borrow socket, data: list<u8> })
  send-bad2: func(s: list<borrow socket>, data: list<u8>)
  send-bad3: func(s: option<borrow socket>, data: list<u8>)
}
```

推荐改写：

```wit
interface io {
  resource socket {
    constructor(addr: string)
    // ✅ 借用仅用于顶层参数
    write: func(this: borrow socket, data: list<u8>) -> result<u32, string>
  }

  // ✅ 返回拥有权，由调用方负责生命周期
  connect: func(addr: string) -> own socket
}
```

要点：读取/写入用 `this: borrow R` 或顶层 `borrow R`；跨调用传递返回 `own R`；避免在 `record/variant/list/option` 中嵌入 `borrow R`。

## 常见迁移路线（兼容性友好）

1) record 新增可选字段

```wit
// v1
record user { id: u64, name: string }

// v2：新增可选字段
record user-v2 { id: u64, name: string, email: option<string> }

get-user: func(id: u64) -> user
get-user-v2: func(id: u64) -> user-v2
```

2) variant 扩展分支

```wit
// v1
variant payload-v1 { text: string, data: list<u8> }

// v2：新增分支，建议以新类型/新接口发布
variant payload-v2 { text: string, data: list<u8>, json: string }

process: func(p: payload-v1)
process-v2: func(p: payload-v2)
```

3) enum 扩展与 flags 替代

- 若枚举可能扩容，优先评估是否改为 `flags`；
- 若必须扩展枚举，以新类型/新接口发布并保留旧接口一段时间。

4) 接口/世界分层与版本化

- 将新增能力放入新的 `interface`/`world`，减少对既有消费者的影响；
- 在文档与 CI 中明确弃用窗口与回退策略。
