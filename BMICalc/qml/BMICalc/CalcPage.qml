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
        id: headTumbler
        selectedIndex: 0
        items: heightListModel
    }

    TumblerColumn {
        id: middleTumbler
        selectedIndex: 0
        items: numbersListModel
    }


    TumblerColumn {
        id: tailTumbler
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
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    headTumbler.items = heightListModel
                    updateTumbler(heightTextField.text)
                    calcPage.state = "HEIGHTENABLED"
                }
            }
        }

        AppTextField {
            id: weightTextField
            placeholderText: "Peso"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    headTumbler.items = weightListModel
                    updateTumbler(weightTextField.text)
                    calcPage.state = "WEIGHTENABLED"
                }
            }
        }

        Item {
            id: tumblerItem
            height: 200
            width: 240

            Tumbler {
                id: tumbler
                anchors.fill: parent
                columns: [headTumbler, middleTumbler, tailTumbler]
            }
        }

        AppButton {
            id: calculateButton
            enabled: (heightTextField.text !== "") && (weightTextField.text !== "")
            text: "Calcular"
            onClicked: {
                resultTextField.text = bmiCalc(weightTextField.text, heightTextField.text)
                calcPage.state = "RESULT"
            }
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

    Column {
        id: resultColumn
        anchors.centerIn: parent
        spacing: 80

        AppTextField {
            id: resultTextField
            height: 100
        }

        AppButton {
            id: calculateNewButton
            text: "Calcular Novo"
            onClicked: {
                heightTextField.text = ""
                weightTextField.text = ""
                calcPage.state = "NORMAL"
            }
        }
    }

    function updateTumbler(value) {
        var head = 0
        var middle = 0
        var tail = 0

        if (!isNaN(value)) {
            head = Math.floor(value / 100)
            middle = Math.floor((value % 100) / 10)
            tail = Math.floor(value % 10)
        }

        headTumbler.selectedIndex = head
        middleTumbler.selectedIndex = middle
        tailTumbler.selectedIndex = tail
    }

    function bmiCalc(weight, height) {
        return weight / Math.pow((height/100), 2)
    }

    state: "NORMAL"

    states: [
        State {
            name: "NORMAL"
            PropertyChanges { target: resultColumn; visible: false }
            PropertyChanges { target: column; visible: true }
            PropertyChanges { target: column; spacing: 40 }
            PropertyChanges { target: heightTextField; visible: true }
            PropertyChanges { target: weightTextField; visible: true }
            PropertyChanges { target: tumblerItem; visible: false }
            PropertyChanges { target: calculateButton; visible: true }
            PropertyChanges { target: buttonRow; visible: false }
        },
        State {
            name: "HEIGHTENABLED"
            PropertyChanges { target: resultColumn; visible: false }
            PropertyChanges { target: column; visible: true }
            PropertyChanges { target: column; spacing: 5 }
            PropertyChanges { target: heightTextField; visible: true }
            PropertyChanges { target: weightTextField; visible: false }
            PropertyChanges { target: tumblerItem; visible: true }
            PropertyChanges { target: calculateButton; visible: false }
            PropertyChanges { target: buttonRow; visible: true }
        },
        State {
            name: "WEIGHTENABLED"
            PropertyChanges { target: resultColumn; visible: false }
            PropertyChanges { target: column; visible: true }
            PropertyChanges { target: column; spacing: 10 }
            PropertyChanges { target: heightTextField; visible: false }
            PropertyChanges { target: weightTextField; visible: true }
            PropertyChanges { target: tumblerItem; visible: true }
            PropertyChanges { target: calculateButton; visible: false }
            PropertyChanges { target: buttonRow; visible: true }
        },
        State {
            name: "RESULT"
            PropertyChanges { target: column; visible: false }
            PropertyChanges { target: resultColumn; visible: true }
        }
    ]
}
