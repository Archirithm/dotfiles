import QtQuick
import QtQuick.Window 
import QtQuick.Shapes 1.15 
// 如果报错找不到模块，请注释掉下面这行，改用 import QtGraphicalEffects 1.15
import Qt5Compat.GraphicalEffects 

Window {
    id: window
    width: 600; height: 300
    visible: true
    color: "transparent"
    flags: Qt.FramelessWindowHint | Qt.Window
    title: "Quickshell Demo (Perfect Sync)"

    MouseArea { 
        anchors.fill: parent
        onPressed: window.startSystemMove()
        z: -100 
    }

    Item {
        id: switchRoot
        anchors.centerIn: parent
        
        readonly property real s: 3.0
        width: 180 * s
        height: 70 * s
        
        property bool isDark: false
        property int animTime: 1000 
        property var cssBezier: [0.56, 1.35, 0.52, 1.0, 1.0, 1.0]

        // =================================================================
        // 【改进 1】：使用 Item 包裹内容并应用 OpacityMask 裁切
        // =================================================================
        Item {
            id: switchContent
            anchors.fill: parent
            
            // 开启遮罩：实现完美的抗锯齿圆角裁剪
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: switchContent.width
                    height: switchContent.height
                    radius: switchContent.height / 2
                    visible: false
                }
            }

            // --- [A] 背景颜色 ---
            Rectangle {
                anchors.fill: parent
                color: switchRoot.isDark ? "#191e32" : "#4685c0"
                Behavior on color { ColorAnimation { duration: 700 } }
            }

            // --- [B] 光晕 (Halos) ---
            // 【改进 2】：光晕位置完全跟随 mainButton (太阳/月亮)
            Item {
                width: parent.width
                height: parent.height
                Repeater {
                    model: [
                        { size: 110, op: 0.2 },
                        { size: 135, op: 0.1 },
                        { size: 160, op: 0.05 }
                    ]
                    Rectangle {
                        property var d: modelData
                        width: d.size * switchRoot.s
                        height: width
                        radius: width/2
                        color: "white"
                        opacity: d.op
                        
                        // 1. 垂直跟随：居中并稍微上移 (模拟原设计的偏移)
                        y: (mainButton.y + mainButton.height/2) - (height/2) - (5 * switchRoot.s)
                        
                        // 2. 水平跟随：完全绑定到 mainButton 的中心
                        // 这样当按钮做“欲拒还迎”的 Peek 动画时，光晕也会跟着动！
                        x: (mainButton.x + mainButton.width/2) - (width/2)
                    }
                }
            }

            // --- [C] 云朵 (Clouds) ---
            Item {
                id: cloudsContainer
                width: parent.width
                height: parent.height
                
                property real dayY: 0 * switchRoot.s
                property real nightY: 80 * switchRoot.s
                y: switchRoot.isDark ? nightY : dayY
                
                Behavior on y { 
                    NumberAnimation { 
                        duration: switchRoot.animTime
                        easing.type: Easing.Bezier
                        easing.bezierCurve: switchRoot.cssBezier 
                    } 
                }

                property var cloudData: [
                    {r: -20, b: 10, w: 50}, {r: -10, b: -25, w: 60}, {r: 20, b: -40, w: 60}, 
                    {r: 50, b: -35, w: 60}, {r: 75, b: -60, w: 75}, {r: 110, b: -50, w: 60}
                ]

                // 1. 背景云
                Item {
                    anchors.fill: parent
                    opacity: 0.5 
                    layer.enabled: true 
                    layer.samples: 4
                    Repeater {
                        model: cloudsContainer.cloudData.length
                        delegate: Rectangle {
                            property var d: cloudsContainer.cloudData[index]
                            width: d.w * switchRoot.s; height: width
                            radius: width/2; color: "white"; opacity: 1.0 
                            x: switchRoot.width - (d.r * switchRoot.s) - width - (15 * switchRoot.s)
                            y: switchRoot.height - (d.b * switchRoot.s) - height - (15 * switchRoot.s)
                            transform: Translate {
                                id: lightCloudTrans
                                Behavior on x { NumberAnimation { duration: 1200 } }
                                Behavior on y { NumberAnimation { duration: 1200 } }
                            }
                            Timer {
                                running: interactArea.containsMouse
                                repeat: true; interval: 1200
                                onTriggered: {
                                    var range = 2 * switchRoot.s
                                    lightCloudTrans.x = (Math.random() > 0.5 ? range : -range)
                                    lightCloudTrans.y = (Math.random() > 0.5 ? range : -range)
                                }
                            }
                        }
                    }
                }

                // 2. 前景云
                Repeater {
                    model: cloudsContainer.cloudData.length
                    delegate: Rectangle {
                        property var d: cloudsContainer.cloudData[index]
                        width: d.w * switchRoot.s; height: width
                        radius: width/2; color: "white"; opacity: 1.0
                        x: switchRoot.width - (d.r * switchRoot.s) - width
                        y: switchRoot.height - (d.b * switchRoot.s) - height
                        transform: Translate {
                            id: mainCloudTrans
                            Behavior on x { NumberAnimation { duration: 1000 } }
                            Behavior on y { NumberAnimation { duration: 1000 } }
                        }
                        Timer {
                            running: interactArea.containsMouse
                            repeat: true; interval: 1000
                            onTriggered: {
                                var range = 2 * switchRoot.s
                                mainCloudTrans.x = (Math.random() > 0.5 ? range : -range)
                                mainCloudTrans.y = (Math.random() > 0.5 ? range : -range)
                            }
                        }
                    }
                }
            }

            // --- [D] 星星 (Stars) ---
            Item {
                id: starsContainer
                width: parent.width
                height: parent.height
                
                property real dayY: -70 * switchRoot.s
                property real nightY: 0 * switchRoot.s
                y: switchRoot.isDark ? nightY : dayY
                
                Behavior on y { 
                    NumberAnimation { 
                        duration: switchRoot.animTime
                        easing.type: Easing.Bezier
                        easing.bezierCurve: switchRoot.cssBezier 
                    } 
                }

                property var starData: [
                    {x: 39, y: 11, sz: 7.5, dur: 2200}, {x: 91, y: 39, sz: 7.5, dur: 3500}, 
                    {x: 19, y: 26, sz: 5,   dur: 2100}, {x: 66, y: 37, sz: 5,   dur: 2800}, 
                    {x: 75, y: 21, sz: 3,   dur: 1800}, {x: 38, y: 51, sz: 3,   dur: 1500}
                ]

                Repeater {
                    model: starsContainer.starData.length
                    delegate: Item {
                        property var d: starsContainer.starData[index]
                        x: d.x * switchRoot.s; y: d.y * switchRoot.s
                        width: d.sz * 2 * switchRoot.s; height: width
                        
                        // 使用 Shape 绘制内凹四角星
                        Shape {
                            anchors.fill: parent
                            layer.enabled: true; layer.samples: 4
                            ShapePath {
                                strokeWidth: 0; strokeColor: "transparent"; fillColor: "white"
                                startX: width / 2; startY: 0
                                PathQuad { x: width; y: height / 2; controlX: width / 2; controlY: height / 2 }
                                PathQuad { x: width / 2; y: height; controlX: width / 2; controlY: height / 2 }
                                PathQuad { x: 0; y: height / 2; controlX: width / 2; controlY: height / 2 }
                                PathQuad { x: width / 2; y: 0; controlX: width / 2; controlY: height / 2 }
                            }
                        }

                        // 悬停闪烁动画
                        transformOrigin: Item.Center
                        scale: 0 
                        SequentialAnimation on scale {
                            loops: Animation.Infinite
                            running: interactArea.containsMouse
                            NumberAnimation { to: 1.0; duration: d.dur * 0.2; easing.type: Easing.OutQuad }
                            NumberAnimation { to: 0.8; duration: d.dur * 0.8 }
                            PropertyAction { value: 0 }
                        }
                    }
                }
            }

            // --- [E] 滑块按钮 ---
            Rectangle {
                id: mainButton
                width: 55 * switchRoot.s
                height: 55 * switchRoot.s
                radius: width / 2
                y: 7.5 * switchRoot.s
                
                property real startX: 7.5 * switchRoot.s
                property real endX: startX + 110 * switchRoot.s
                property real hoverOffset: 10 * switchRoot.s
                
                x: {
                    if (switchRoot.isDark) {
                        return interactArea.containsMouse ? (endX - hoverOffset) : endX
                    } else {
                        return interactArea.containsMouse ? (startX + hoverOffset) : startX
                    }
                }

                color: switchRoot.isDark ? "#c3c8d2" : "#ffc323"
                
                Behavior on x { NumberAnimation { duration: switchRoot.animTime; easing.type: Easing.Bezier; easing.bezierCurve: switchRoot.cssBezier } }
                Behavior on color { ColorAnimation { duration: switchRoot.animTime } }

                // 阴影
                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 3 * switchRoot.s
                    verticalOffset: 3 * switchRoot.s
                    radius: 12.0
                    samples: 17
                    color: "#80000000"
                }

                // 高光
                Rectangle { 
                    anchors.fill: parent
                    radius: width/2
                    color: "transparent"
                    opacity: switchRoot.isDark?0.2:1.0
                    Behavior on opacity { NumberAnimation { duration: 500 } }
                    Rectangle { 
                        width: parent.width*0.8
                        height: width
                        radius: width/2
                        color: "#ffe650"
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: -2*switchRoot.s
                        anchors.horizontalCenterOffset: -2*switchRoot.s
                        opacity: 0.6 
                    }
                }
                // 陨石坑
                Item {
                    anchors.fill: parent
                    opacity: switchRoot.isDark?1:0
                    visible: opacity>0
                    rotation: switchRoot.isDark?0:-90
                    Behavior on rotation { NumberAnimation { duration: switchRoot.animTime; easing.type: Easing.Bezier; easing.bezierCurve: switchRoot.cssBezier } }
                    Behavior on opacity { NumberAnimation { duration: 300 } }
                    Repeater { 
                        model: [{l:25,t:7.5,w:12.5}, {l:7.5,t:20,w:20}, {l:32.5,t:32.5,w:12.5}]
                        delegate: Rectangle { 
                            color: "#96a0b4"
                            x: modelData.l*switchRoot.s
                            y: modelData.t*switchRoot.s
                            width: modelData.w*switchRoot.s
                            height: width
                            radius: width/2 
                        } 
                    }
                }
            }
        } // switchContent 结束

        // =================================================================
        // 2. 顶层装饰：深色面板与挖孔效果
        // =================================================================
        // Shape {
        //     id: maskPanel 
        //     anchors.fill: parent
        //     layer.enabled: true
        //     layer.samples: 4 
        //
        //     property real holeX: (width - switchRoot.width) / 2
        //     property real holeY: (height - switchRoot.height) / 2
        //     property real holeW: switchRoot.width
        //     property real holeH: switchRoot.height
        //     property real r: holeH / 2 
        //
        //     ShapePath {
        //         fillColor: "#333333" // 面板颜色
        //         strokeColor: "transparent"
        //         fillRule: ShapePath.OddEvenFill 
        //
        //         startX: 0; startY: 0
        //         PathLine { x: maskPanel.width; y: 0 }
        //         PathLine { x: maskPanel.width; y: maskPanel.height }
        //         PathLine { x: 0; y: maskPanel.height }
        //         PathLine { x: 0; y: 0 }
        //
        //         // 挖孔位置
        //         PathRectangle {
        //             x: maskPanel.holeX
        //             y: maskPanel.holeY
        //             width: maskPanel.holeW
        //             height: maskPanel.holeH
        //             radius: maskPanel.r
        //         }
        //     }
        //
        //     // 内阴影描边 (装饰)
        //     Rectangle {
        //         x: maskPanel.holeX
        //         y: maskPanel.holeY
        //         width: maskPanel.holeW
        //         height: maskPanel.holeH
        //         radius: maskPanel.r
        //         color: "transparent"
        //         border.color: "#80000000"
        //         border.width: 5 * switchRoot.s
        //     }
        // }

        MouseArea {
            id: interactArea
            anchors.centerIn: parent
            width: switchRoot.width
            height: switchRoot.height
            hoverEnabled: true 
            cursorShape: Qt.PointingHandCursor
            onClicked: switchRoot.isDark = !switchRoot.isDark
        }
    }
}
