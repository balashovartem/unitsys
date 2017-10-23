import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Item {
    property variant stars : [star1, star2, star3, star4, star5]
    property int rating : 0
    property int size: 24

    width: size*5
    height: size

    onRatingChanged: setRating(rating)

    function setRating(rating) {
        var starOutline = "qrc:/icons/star-outline.svg"
        var star = "qrc:/icons/star.svg"
        for (var i = 0; i < 5; i++) {
            if (rating <= 0 )
                stars[i].source = starOutline
            else
                stars[i].source = star
            --rating
        }
    }
    Image {
        id: star1
        width: size
        height: size
        anchors.verticalCenter: parent.verticalCenter
    }
    Image {
        id: star2
        width: size
        height: size
        anchors.left: star1.right
        anchors.leftMargin: 0
        anchors.verticalCenter: star1.verticalCenter
    }
    Image {
        id: star3
        width: size
        height: size
        anchors.verticalCenter: star2.verticalCenter
        anchors.left: star2.right
        anchors.leftMargin: 0

    }
    Image {
        id: star4
        width: size
        height: size
        anchors.verticalCenter: star3.verticalCenter
        anchors.left: star3.right
        anchors.leftMargin: 0
    }
    Image {
        id: star5
        width: size
        height: size
        anchors.verticalCenter: star4.verticalCenter
        anchors.left: star4.right
        anchors.leftMargin: 0

    }
}
