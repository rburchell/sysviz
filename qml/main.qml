import QtQuick 2.0
import QtQuick.Window 2.0

import "theme.js" as Theme;

Rectangle {
    id: root

    width: 800;
    height: 600;

    property var rowHeight: 1 * cm;

    RowGradient {
        id: header

        anchors.left: labels.right
        anchors.right: parent.right
        height: Math.floor(0.5 * cm);

        clip: true

        // Pixels per millisecond, a kinda of zoom ratio
        property real pps: 200;
        focus: true

        Keys.onPressed: {
            // TODO: is the zoom in/out behaviour optimal? right now it changes
            // contentX by the same factor, but maybe we want to keep the view
            // centered?
            if (event.key == Qt.Key_Up || event.key == Qt.Key_W) {
                pps *= 1.1
                flickable.contentX *= 1.1
            } else if (event.key == Qt.Key_Down || event.key == Qt.Key_S) {
                pps *= 0.9
                flickable.contentX *= 0.9
            } else if (event.key == Qt.Key_Left || event.key == Qt.Key_A) {
                flickable.contentX -= 100
            } else if (event.key == Qt.Key_Right || event.key == Qt.Key_D) {
                flickable.contentX += 100
            }
        }

//        NumberAnimation on pps { from: 100; to: 1000; duration: 10000; loops: Animation.Infinite }

        property real startTime: flickable.contentX / pps;
        property real visibleTimeSpan: width / pps;
        property int primaryUnitCount: Math.ceil(visibleTimeSpan) + 1;
        property real primaryUnitOffset: fmod(startTime, 1);

        function fmod(x, y) {
            return x - Math.floor(x / y);
        }

        Repeater {
            id: primaryUnitRepeater
            model: header.primaryUnitCount
            Rectangle {
                width: 1
                color: Theme.colors.timeIndicatorPrimary;
                height: header.height * 0.33
                y: header.height - height - 1;
                x: (-header.primaryUnitOffset + index) * header.pps;
                antialiasing: true
                Text {
                    anchors.bottom: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: (Math.floor(header.startTime) + index) + " s";
                    font.pixelSize: header.height * 0.4;
                }
            }
        }
    }

    Flickable {
        id: labels

        anchors.top: header.bottom
        width: 2 * cm
        height: flickable.height

        contentY: flickable.contentY

        clip: true

        Column {
            width: parent.width

            ViewLabel {
                height: root.rowHeight
                width: parent.width
                text: "Frequency:\nGPU"
            }

            Repeater {
                model: traceModel.cpuCount
                ViewLabel {
                    height: root.rowHeight
                    width: parent.width
                    text: "Frequency:\nCPU " + index;
                }
            }
        }
    }

    Flickable {
        id: flickable

        anchors.left: labels.right
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: header.bottom
        clip: true

//        NumberAnimation on contentX { from: 0; to: 500; duration: 2000; loops: Animation.Infinite }

        contentHeight: cm * cpuFrequencyRepeater.count;
        contentWidth: traceModel.traceLength * header.pps;

//        flickableDirection: Flickable.HorizontalFlick
//        draggingVertically: false
//        draggingHorizontally: true

        Column {
//            height: 2 * cm

//            GpuFrequencyView {
//                model: traceModel.gpuFrequencyModel();
//                width: flickable.contentWidth;
//                height: Math.floor(1 * cm);
//                pps: header.pps;
//            }

            FrequencyView {
                model: traceModel.gpuFrequencyModel();
                width: flickable.contentWidth;
                height: Math.floor(1 * cm);
                pps: header.pps;
                maxFrequency: traceModel.maxGpuFrequency
            }

            Repeater {
                id: cpuFrequencyRepeater
                model: traceModel.cpuCount
                FrequencyView {
                    model: traceModel.cpuFrequencyModel(index);
                    width: flickable.contentWidth;
                    height: Math.floor(1 * cm);
                    pps: header.pps;
                    maxFrequency: traceModel.maxCpuFrequency
                }
            }


        }

    }

    gradient: Gradient {
        GradientStop { position: 0; color: Qt.hsla(0.66, 0.2, 0.4); }
        GradientStop { position: 1; color: Qt.hsla(0, 0, 0.2); }
    }

}
