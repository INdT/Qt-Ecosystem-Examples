// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

AppWindow {
    id: mainWindow
    initialPage: SplashScreen {}

    Timer {
        interval: 1000
        running: true
        onTriggered: {
            mainWindow.pageStack.replace(Qt.resolvedUrl("qrc:/qml/BMICalc/CalcPage.qml"))
        }
    }
}
