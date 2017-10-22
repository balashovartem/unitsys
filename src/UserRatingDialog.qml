import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Dialog {
    property int rating: 0
    property string movieTitle: ""

    leftPadding: 24
    rightPadding: 24

    title: qsTr("Моя оценка") + " фильм '" + movieTitle + "'"
    standardButtons: Dialog.Ok | Dialog.Cancel
    modal: true

    ScrollView {
        id: scrollBar
        anchors.fill: parent
        clip: true
        rightPadding: 24

        GridLayout {
            id: gridLayout
            anchors.fill: parent
            columns: 2
            RadioButton {
                id: rating5
                checked: ( rating == 5 ) ? true : false
                text: qsTr("Отлично")
            }
            RatingWidget {
                size: 20
                rating: 5
            }
            RadioButton {
                id: rating4
                checked: ( rating == 4 ) ? true : false
                text: qsTr("Хорошо")
            }
            RatingWidget {
                size: 20
                rating: 4
            }
            RadioButton {
                id: rating3
                checked: ( rating == 3 ) ? true : false
                text: qsTr("Удовлетворительно")
            }
            RatingWidget {
                size: 20
                rating: 3
            }
            RadioButton {
                id: rating2
                checked: ( rating == 2 ) ? true : false
                text: qsTr("Неудовлетворительно")
            }
            RatingWidget {
                size: 20
                rating: 2
            }
            RadioButton {
                id: rating1
                checked: ( rating == 1 ) ? true : false
                text: qsTr("Посредственно")
            }
            RatingWidget {
                size: 20
                rating: 1
            }
        }

    }
    onAccepted: {
        if( rating1.checked )
            rating = 1
        if( rating2.checked )
            rating = 2
        if( rating3.checked )
            rating = 3
        if( rating4.checked )
            rating = 4
        if( rating5.checked )
            rating = 5
    }

}

