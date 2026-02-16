import QtQuick
import QtQuick.Window 
import QtQuick.Shapes 1.15 
import Qt5Compat.GraphicalEffects 

Window {
    id: window
    width: 600;
    height: 300
    visible: true
    color: "transparent"
    flags: Qt.FramelessWindowHint | Qt.Window
    title: "Quickshell Demo (Perfect Repulsion Sync)"

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

        Item {
            id: switchContent
            anchors.fill: parent
            
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
                        y: (mainButton.y + mainButton.height/2) - (height/2) - (5 * switchRoot.s)
                        x: (mainButton.x + mainButton.width/2) - (width/2)
                    }
                }
            }

            // --- [C] 云朵 (带斥力逻辑) ---
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
                            
                            // --- 斥力计算 ---
                            property real baseX: switchRoot.width - (d.r * switchRoot.s) - width - (15 * switchRoot.s)
                            property real proximityFactor: (d.r + 20) / 130.0
                            property real pushOffset: (!switchRoot.isDark && interactArea.containsMouse) ? (15 * switchRoot.s * proximityFactor) : 0
                            
                            x: baseX + pushOffset
                            y: switchRoot.height - (d.b * switchRoot.s) - height - (15 * switchRoot.s)
                            width: d.w * switchRoot.s
                            height: width
                            radius: width/2
                            color: "white"
                            
                            Behavior on x { NumberAnimation { duration: 600; easing.type: Easing.OutQuad } }

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
                                onRunningChanged: if(!running) { lightCloudTrans.x = 0; lightCloudTrans.y = 0; }
                            }
                        }
                    }
                }

                // 2. 前景云
                Repeater {
                    model: cloudsContainer.cloudData.length
                    delegate: Rectangle {
                        property var d: cloudsContainer.cloudData[index]
                        
                        // --- 斥力计算 ---
                        property real baseX: switchRoot.width - (d.r * switchRoot.s) - width
                        property real proximityFactor: (d.r + 20) / 130.0
                        property real pushOffset: (!switchRoot.isDark && interactArea.containsMouse) ? (18 * switchRoot.s * proximityFactor) : 0
                        
                        x: baseX + pushOffset
                        y: switchRoot.height - (d.b * switchRoot.s) - height
                        width: d.w * switchRoot.s
                        height: width
                        radius: width/2
                        color: "white"

                        Behavior on x { NumberAnimation { duration: 600; easing.type: Easing.OutQuad } }

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
                            onRunningChanged: if(!running) { mainCloudTrans.x = 0; mainCloudTrans.y = 0; }
                        }
                    }
                }
            }

            // --- [D] 星星 (带斥力逻辑) ---
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
                        id: starItem
                        property var d: starsContainer.starData[index]
                        
                        // --- 斥力计算 ---
                        property real baseX: d.x * switchRoot.s
                        property real proximityFactor: d.x / 100.0
                        property real pushOffset: (switchRoot.isDark && interactArea.containsMouse) ? (-12 * switchRoot.s * proximityFactor) : 0
                        
                        x: baseX + pushOffset
                        y: d.y * switchRoot.s
                        width: d.sz * 2 * switchRoot.s
                        height: width
                        
                        Behavior on x { NumberAnimation { duration: 600; easing.type: Easing.OutQuad } }

                        Shape {
                            anchors.fill: parent
                            layer.enabled: true; layer.samples: 4
                            ShapePath {
                                strokeWidth: 0; fillColor: "white"
                                startX: width / 2; startY: 0
                                PathQuad { x: width; y: height / 2; controlX: width / 2; controlY: height / 2 }
                                PathQuad { x: width / 2; y: height; controlX: width / 2; controlY: height / 2 }
                                PathQuad { x: 0; y: height / 2; controlX: width / 2; controlY: height / 2 }
                                PathQuad { x: width / 2; y: 0; controlX: width / 2; controlY: height / 2 }
                            }
                        }

                        transformOrigin: Item.Center
                        scale: 1.0
                        
                        states: State {
                            name: "flashing"
                            when: interactArea.containsMouse
                        }
                        transitions: [
                            Transition {
                                from: ""; to: "flashing"
                                SequentialAnimation {
                                    loops: Animation.Infinite
                                    NumberAnimation { target: starItem; property: "scale"; to: 1.2; duration: d.dur * 0.4; easing.type: Easing.OutQuad }
                                    NumberAnimation { target: starItem; property: "scale"; to: 0.3; duration: d.dur * 0.6; easing.type: Easing.InQuad }
                                }
                            },
                            Transition {
                                from: "flashing"; to: ""
                                NumberAnimation { target: starItem; property: "scale"; to: 1.0; duration: 300; easing.type: Easing.OutQuad }
                            }
                        ]
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
                property real endX: switchRoot.width - width - (7.5 * switchRoot.s)
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
                    opacity: switchRoot.isDark ? 0.2 : 1.0
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
                    opacity: switchRoot.isDark ? 1 : 0
                    visible: opacity > 0
                    rotation: switchRoot.isDark ? 0 : -90
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
        } 

        MouseArea {
            id: interactArea
            anchors.fill: parent
            hoverEnabled: true 
            cursorShape: Qt.PointingHandCursor
            onClicked: switchRoot.isDark = !switchRoot.isDark
        }
    }
}
