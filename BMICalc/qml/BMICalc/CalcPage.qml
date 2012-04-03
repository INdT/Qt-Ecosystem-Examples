// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.extras 1.1

AppPage {
    id: calcPage

    ListModel {
        id: heightListModel

        Component.onCompleted: {
            for (var i = 0; i <= 2; i++) {
                append({"value" : i})
            }
        }
    }

    ListModel {
        id: weightListModel

        Component.onCompleted: {
            for (var i = 0; i <= 5; i++) {
                append({"value" : i})
            }
        }
    }

    ListModel {
        id: numbersListModel

        Component.onCompleted: {
            for (var i = 0; i <= 9; i++) {
                append({"value" : i})
            }
        }
    }

    TumblerColumn {
        id: moreTumbler
        selectedIndex: 0
        items: heightListModel
    }

    TumblerColumn {
        id: middleTumbler
        selectedIndex: 0
        items: numbersListModel
    }


    TumblerColumn {
        id: lessTumbler
        selectedIndex: 0
        items: numbersListModel
    }

    Column {
        id: column
        anchors.centerIn: parent
        spacing: 40

        AppTextField {
            id: heightTextField
            placeholderText: "Altura"
            enableSoftwareInputPanel: false
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    calcPage.state = "HEIGHTENABLED"
                    updateTumbler(heightTextField.text)
                }
            }
        }

        AppTextField {
            id: weightTextField
            placeholderText: "Peso"
            enableSoftwareInputPanel: false
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    calcPage.state = "WEIGHTENABLED"
                    updateTumbler(weightTextField.text)
                }
            }
        }

        Tumbler {
            id: tumbler
            columns: [moreTumbler, middleTumbler, lessTumbler]
            height: 200
            width: 240
        }

        AppButton {
            id: calculateButton
            text: "Calcular"
        }

        AppButtonRow {
            id: buttonRow
            width: 240

            AppButton {
                id: cancelButton
                width: 115
                text: "Cancelar"
                onClicked: {
                    calcPage.state = "NORMAL"
                }
            }
            AppButton {
                id: okButton
                width: 115
                text: "Ok"
                onClicked: {
                    var result = (tumbler.columns[0].selectedIndex * 100)
                                 + (tumbler.columns[1].selectedIndex * 10)
                                 + tumbler.columns[2].selectedIndex

                    if (calcPage.state === "HEIGHTENABLED")
                        heightTextField.text = result
                    else if (calcPage.state === "WEIGHTENABLED")
                        weightTextField.text = result

                    calcPage.state = "NORMAL"
                }
            }
        }
    }

    function updateTumbler(value) {
        var first = 0
        var middle = 0
        var last = 0

        if (!isNaN(value)) {
            first = Math.floor(value / 100)
            middle = Math.floor((value % 100) / 10)
            last = Math.floor(value % 10)
        }

        tumbler.columns[0].selectedIndex = first
        tumbler.columns[1].selectedIndex = middle
        tumbler.columns[2].selectedIndex = last
    }

    state: "NORMAL"

    states: [
        State {
            name: "NORMAL"
            PropertyChanges { target: column; spacing: 40 }
            PropertyChanges { target: heightTextField; visible: true }
            PropertyChanges { target: weightTextField; visible: true }
            PropertyChanges { target: tumbler; visible: false }
            PropertyChanges { target: calculateButton; visible: true }
            PropertyChanges { target: buttonRow; visible: false }
        },
        State {
            name: "HEIGHTENABLED"
            PropertyChanges { target: column; spacing: 5 }
            PropertyChanges { target: heightTextField; visible: true }
            PropertyChanges { target: weightTextField; visible: false }
            PropertyChanges { target: moreTumbler; items: heightListModel }
            PropertyChanges { target: tumbler; visible: true }
            PropertyChanges { target: calculateButton; visible: false }
            PropertyChanges { target: buttonRow; visible: true }
        },
        State {
            name: "WEIGHTENABLED"
            PropertyChanges { target: column; spacing: 10 }
            PropertyChanges { target: heightTextField; visible: false }
            PropertyChanges { target: weightTextField; visible: true }
            PropertyChanges { target: moreTumbler; items: weightListModel }
            PropertyChanges { target: tumbler; visible: true }
            PropertyChanges { target: calculateButton; visible: false }
            PropertyChanges { target: buttonRow; visible: true }
        }
    ]
}
