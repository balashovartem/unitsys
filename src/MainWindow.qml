import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3

import UnitSys 1.0
import "Icon.js" as MdiFont
import "qrc:/src"



ApplicationWindow {
    id: mainWindow
    visible: true
    title: "unitsys"

    width: 1000
    height: 900

    header: ToolBar {
        id: header
        position: ToolBar.Header

        ColumnLayout {
            anchors.fill: parent

            RowLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                height: 64

                Label {
                    leftPadding: 24
                    font.pixelSize: 20
                    opacity: 0.87
                    text: qsTr("Список фильмов")
                }

                Item {
                    // spacer item
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                ToolButton {
                    font.pixelSize: 20
                    text: MdiFont.Icon.filterVariant

                    onClicked: {
                        filter.visible = !filter.visible
                        if( !filter.visible )
                        {
                            searchTextField.text = ""
                        }
                    }
                }
            }

            ColumnLayout {
                id: filter
                Layout.fillHeight: true
                Layout.fillWidth: true
                visible: false
                Layout.leftMargin: 24
                Layout.rightMargin: 14

                RowLayout {
                    ColumnLayout {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Label {
                            Layout.fillHeight: false
                            Layout.fillWidth: true
                            text: qsTr("Жанр")
                        }
                        ComboBox {
                            id: genresComboBox
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            flat: true

                            model: [ "Любой" ].concat( moviesModel.genres() )

                            onActivated: {
                                if( index == 0 )
                                {
                                    moviesModel.setFilter( Role.Genre, "" )
                                }
                                else
                                {
                                    moviesModel.setFilter( Role.Genre, "genre = '" + textAt( index )+ "'"  )
                                }
                            }
                        }
                    }
                    ColumnLayout {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Label {
                            Layout.fillHeight: false
                            Layout.fillWidth: true
                            text: qsTr("Год")
                        }
                        ComboBox {
                            Layout.fillHeight: true;
                            Layout.fillWidth: true;

                            flat: true;

                            model: [ "Любой" ].concat( moviesModel.years() )
                            onActivated: {
                                if( index == 0 )
                                {
                                    moviesModel.setFilter( Role.Year, "" )
                                }
                                else
                                {
                                    moviesModel.setFilter( Role.Year, "year = '" + textAt( index ) + "'" )
                                }
                            }
                        }
                    }
                    ColumnLayout {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Label {
                            Layout.fillHeight: false
                            Layout.fillWidth: true
                            text: qsTr("Рейтинг")
                        }
                        ComboBox {
                            Layout.fillHeight: true;
                            Layout.fillWidth: true;

                            flat: true;

                            model: [ qsTr("Любой"), "10%", "20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%" ]
                            onActivated: {
                                if( index == 0 )
                                {
                                    moviesModel.setFilter( Role.Rating, "" )
                                }
                                else
                                {
                                    moviesModel.setFilter( Role.Rating, "rating >=" + index  )
                                }
                            }
                        }
                    }
                    ColumnLayout {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Label {
                            Layout.fillHeight: false
                            Layout.fillWidth: true
                            text: qsTr("Моя оценка")
                        }
                        ComboBox {
                            Layout.fillHeight: true;
                            Layout.fillWidth: true;

                            flat: true;

                            model: [ qsTr("Любая"), "1", "2", "3", "4", "5" ]

                            onActivated: {
                                if( index == 0 ) {
                                    moviesModel.setFilter( Role.UserRating, "" )
                                }
                                else if( index == 1 ) {
                                    moviesModel.setFilter( Role.UserRating, "user_rating == null" )
                                }
                                else {
                                    moviesModel.setFilter( Role.UserRating, "user_rating >=" + textAt( index - 1 ) )
                                }
                            }
                        }
                    }
                }
                RowLayout {
                    TextField {
                        id: searchTextField
                        Layout.fillHeight: true;
                        Layout.fillWidth: true;
                        Material.theme: Material.Dark
                        placeholderText: qsTr("Введите название фильма или опишите сюжет")

                        onTextChanged: {
                            if( text.length == 0 )
                            {
                                moviesModel.setFilter( Role.Title, "" )
                                moviesModel.setFilter( Role.TitleOriginal, "" )
                                moviesModel.setFilter( Role.Plot, "" )
                                return
                            }
                            moviesModel.setFilter( Role.Title, "( title LIKE '%" + text + "%' OR title_original LIKE '%" + text + "%' OR plot LIKE '%" + text + "%' )" )
                        }
                    }
                }
            }
        }
    }

    ListView  {
        id: listView
        anchors.fill: parent

        flickableDirection: Flickable.VerticalFlick
        boundsBehavior: Flickable.StopAtBounds

        model: moviesModel

        header: Item {
            id: tableHeader
            height: 56
            width: listView.width

            RowLayout  {
                id: row
                anchors.fill: parent
                spacing: 0
                Item {
                    id: headerTitle
                    Layout.fillWidth: false
                    Layout.fillHeight: true
                    Layout.minimumWidth: headerTitleOriginalLabel.width + 24

                    Label {
                        id: headerTitleLabel

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 24

                        horizontalAlignment: Text.AlignLeft
                        opacity: 0.54
                        font.pixelSize: 12

                        text: qsTr("Название")
                    }
                }
                Item {
                    id: headerTitleOriginal
                    Layout.fillWidth: false
                    Layout.fillHeight: true
                    Layout.minimumWidth: headerTitleOriginalLabel.width + 56

                    property int sortingOrder: Order.None

                    Label {
                        id: headerTitleOriginalSort

                        anchors.verticalCenter: headerTitleOriginalLabel.verticalCenter
                        anchors.left: headerTitleOriginalLabel.left
                        anchors.leftMargin: -24

                        opacity: 0.87
                        font.pixelSize: 16
                        text: ""
                    }
                    Label {
                        id: headerTitleOriginalLabel

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 56

                        horizontalAlignment: Text.AlignLeft
                        opacity: 0.54
                        font.pixelSize: 12

                        text: qsTr("Орининальное название")
                    }
                    MouseArea {
                        anchors.fill: headerTitleOriginal
                        onClicked: {
                            if( headerTitleOriginal.sortingOrder === Order.None )
                            {
                                headerTitleOriginal.sortingOrder =Order.Asc
                            }
                            else
                            {
                                headerTitleOriginal.sortingOrder = ( headerTitleOriginal.sortingOrder === Order.Asc ) ? Order.Desc : Order.Asc
                            }
                        }
                    }
                    Connections {
                        target: headerTitleOriginal
                        onSortingOrderChanged: {
                            moviesModel.setOrder( Role.TitleOriginal, headerTitleOriginal.sortingOrder )
                        }
                    }
                    Connections {
                        target: moviesModel
                        onOrderChanged: {
                            if( role === Role.TitleOriginal ) {
                                headerTitleOriginal.showSorting( order )
                            }
                        }
                    }
                    function showSorting( order )
                    {
                        switch( order )
                        {
                        case Order.None:
                            headerTitleOriginalLabel.opacity = 0.54
                            headerTitleOriginalSort.visible = false
                            break
                        case Order.Asc:
                            headerTitleOriginalLabel.opacity = 0.87
                            headerTitleOriginalSort.visible = true
                            headerTitleOriginalSort.text = MdiFont.Icon.arrowDown
                            break
                        case Order.Desc:
                            headerTitleOriginalLabel.opacity = 0.87
                            headerTitleOriginalSort.visible = true
                            headerTitleOriginalSort.text = MdiFont.Icon.arrowUp
                            break
                        }
                    }
                }
                Item {
                    id: headerGenre
                    Layout.fillWidth: false
                    Layout.fillHeight: true
                    Layout.minimumWidth: 150

                    Label {
                        id: headerGenreLabel

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 56

                        horizontalAlignment: Text.AlignLeft
                        opacity: 0.54
                        font.pixelSize: 12

                        text: qsTr("Жанр")
                    }
                }
                Item {
                    id: headerPlot
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumWidth: headerPlotLabel.width + 56

                    Label {
                        id: headerPlotLabel

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 56

                        horizontalAlignment: Text.AlignLeft
                        opacity: 0.54
                        font.pixelSize: 12

                        text: qsTr("Сюжет")
                    }
                }
                Item {
                    id: headerYear
                    Layout.fillWidth: false
                    Layout.fillHeight: true
                    Layout.minimumWidth: headerYearLabel.width + 56

                    property int sortingOrder: Order.None

                    Label {
                        id: headerYearSort

                        anchors.verticalCenter: headerYearLabel.verticalCenter
                        anchors.left: headerYearLabel.left
                        anchors.leftMargin: -24

                        opacity: 0.87
                        font.pixelSize: 16

                        text: ""
                    }
                    Label {
                        id: headerYearLabel

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right

                        horizontalAlignment: Text.AlignRight
                        opacity: 0.54
                        font.pixelSize: 12

                        text: qsTr("Год выхода")
                    }
                    MouseArea {
                        anchors.fill: headerYear
                        onClicked: {
                            if( headerYear.sortingOrder === Order.None )
                            {
                                headerYear.sortingOrder = Order.Asc
                            }
                            else
                            {
                                headerYear.sortingOrder = ( headerYear.sortingOrder === Order.Asc ) ? Order.Desc : Order.Asc
                            }
                        }
                    }
                    Connections {
                        target: headerYear
                        onSortingOrderChanged: {
                            moviesModel.setOrder( Role.Year, headerYear.sortingOrder )
                        }
                    }
                    Connections {
                        target: moviesModel
                        onOrderChanged: {
                            if( role === Role.Year ) {
                                headerYear.showSorting( order )
                            }
                        }
                    }
                    function showSorting( order )
                    {
                        switch( order )
                        {
                        case Order.None:
                            headerYearLabel.opacity = 0.54
                            headerYearSort.visible = false
                            break
                        case Order.Asc:
                            headerYearLabel.opacity = 0.87
                            headerYearSort.visible = true
                            headerYearSort.text = MdiFont.Icon.arrowDown
                            break
                        case Order.Desc:
                            headerYearLabel.opacity = 0.87
                            headerYearSort.visible = true
                            headerYearSort.text = MdiFont.Icon.arrowUp
                            break
                        }
                    }
                }
                Item {
                    id: headerRating
                    Layout.fillWidth: false
                    Layout.fillHeight: true
                    Layout.minimumWidth: headerRatingLabel.width + 56

                    property int sortingOrder: Order.None

                    Label {
                        id: headerRatingSort

                        anchors.verticalCenter: headerRatingLabel.verticalCenter
                        anchors.left: headerRatingLabel.left
                        anchors.leftMargin: -24

                        opacity: 0.87
                        font.pixelSize: 16

                        text: ""
                    }
                    Label {
                        id: headerRatingLabel

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right

                        horizontalAlignment: Text.AlignRight
                        opacity: 0.54
                        font.pixelSize: 12

                        text: qsTr("Рейтинг")
                    }
                    MouseArea {
                        anchors.fill: headerRating
                        onClicked: {
                            if( headerRating.sortingOrder === Order.None )
                            {
                                headerRating.sortingOrder = Order.Asc
                            }
                            else
                            {
                                headerRating.sortingOrder = ( headerRating.sortingOrder === Order.Asc ) ? Order.Desc : Order.Asc
                            }
                        }
                    }
                    Connections {
                        target: headerRating
                        onSortingOrderChanged: {
                            moviesModel.setOrder( Role.Rating, headerRating.sortingOrder )
                        }
                    }
                    Connections {
                        target: moviesModel
                        onOrderChanged: {
                            if( role === Role.Rating ) {
                                headerRating.showSorting( order )
                            }
                        }
                    }
                    function showSorting( order )
                    {
                        switch( order )
                        {
                        case Order.None:
                            headerRatingLabel.opacity = 0.54
                            headerRatingSort.visible = false
                            break
                        case Order.Asc:
                            headerRatingLabel.opacity = 0.87
                            headerRatingSort.visible = true
                            headerRatingSort.text = MdiFont.Icon.arrowDown
                            break
                        case Order.Desc:
                            headerRatingLabel.opacity = 0.87
                            headerRatingSort.visible = true
                            headerRatingSort.text = MdiFont.Icon.arrowUp
                            break
                        }
                    }
                }
                Item {
                    id: headerUserRating
                    Layout.fillHeight: true
                    Layout.fillWidth: false
                    Layout.minimumWidth: headerUserRatingLabel.width + 56 + 24

                    property int sortingOrder: Order.None

                    Label {
                        id: headerUserRatingSort

                        anchors.verticalCenter: headerUserRatingLabel.verticalCenter
                        anchors.left: headerUserRatingLabel.left
                        anchors.leftMargin: -24

                        opacity: 0.87
                        font.pixelSize: 16

                        text: ""
                    }

                    Label {
                        id: headerUserRatingLabel
                        anchors.rightMargin: 24
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right

                        horizontalAlignment: Text.AlignRight
                        opacity: 0.54
                        font.pixelSize: 12

                        text: qsTr("Моя оценка")
                    }
                    MouseArea {
                        anchors.fill: headerUserRating
                        onClicked: {
                            if( headerUserRating.sortingOrder === Order.None )
                            {
                                headerUserRating.sortingOrder = Order.Asc
                            }
                            else
                            {
                                headerUserRating.sortingOrder = ( headerUserRating.sortingOrder === Order.Asc ) ? Order.Desc : Order.Asc
                            }
                        }
                    }
                    Connections {
                        target: headerUserRating
                        onSortingOrderChanged: {
                            moviesModel.setOrder( Role.UserRating, headerUserRating.sortingOrder )
                        }
                    }
                    Connections {
                        target: moviesModel
                        onOrderChanged: {
                            if( role === Role.UserRating ) {
                                headerUserRating.showSorting( order)
                            }
                        }
                    }
                    function showSorting( order )
                    {
                        switch( order )
                        {
                        case Order.None:
                            headerUserRatingLabel.opacity = 0.54
                            headerUserRatingSort.visible = false
                            break
                        case Order.Asc:
                            headerUserRatingLabel.opacity = 0.87
                            headerUserRatingSort.visible = true
                            headerUserRatingSort.text = MdiFont.Icon.arrowDown
                            break
                        case Order.Desc:
                            headerUserRatingLabel.opacity = 0.87
                            headerUserRatingSort.visible = true
                            headerUserRatingSort.text = MdiFont.Icon.arrowUp
                            break
                        }
                    }
                }
            }
            Rectangle {
                height: 1
                width: parent.width
                anchors.bottom: parent.bottom
                color: "#E5E5E5"
            }
        }

        highlight: Rectangle
        {
            id: selectionRectangle
            color: "#EEEEEE"
        }
        highlightResizeDuration: 0

        delegate: Item {
            id: delegate

            height: 56
            width: listView.width

            property int row: index
            Row {
                anchors.fill: parent
                Control {
                    height: parent.height
                    width: listView.headerItem.children[0].children[0].width
                    leftPadding: 24
                    contentItem: TextEdit {
                        id: titleTextEdit
                        enabled: false

                        verticalAlignment: Text.AlignVCenter
                        opacity: 0.87
                        font.pixelSize: 13

                        text: title
                        TextMetrics {
                            id: titleTextMetrics
                            elide: Text.ElideRight

                            function getElidedText( originalText, maxWidth ) {
                                if( originalText != undefined){
                                    text = originalText
                                    elideWidth = maxWidth
                                    return elidedText
                                }
                            }
                        }
                        onWidthChanged: {
                            text = titleTextMetrics.getElidedText( plot, width )
                        }
                        Component.onCompleted: {
                            var pos = text.search( searchTextField.text )
                            if( pos === -1 )
                                deselect()
                            else
                                select( pos, pos + searchTextField.text.length )
                        }
                    }
                }
                Control {
                    height: parent.height
                    width: listView.headerItem.children[0].children[1].width
                    leftPadding: 56
                    contentItem: TextEdit {
                        id: titleOriginalTextEdit
                        enabled: false

                        verticalAlignment: Text.AlignVCenter
                        opacity: 0.87
                        font.pixelSize: 13

                        text: title_original
                        TextMetrics {
                            id: titleOriginalTextMetrics
                            elide: Text.ElideRight

                            function getElidedText( originalText, maxWidth ) {
                                if( originalText != undefined){
                                    text = originalText
                                    elideWidth = maxWidth
                                    return elidedText
                                }
                            }
                        }
                        onWidthChanged: {
                            text = titleOriginalTextMetrics.getElidedText( plot, width )
                        }
                        Component.onCompleted: {
                            var pos = text.search( searchTextField.text )
                            if( pos === -1 )
                                deselect()
                            else
                                select( pos, pos + searchTextField.text.length )
                        }
                    }
                }
                Control {
                    height: parent.height
                    width: listView.headerItem.children[0].children[2].width
                    leftPadding: 56
                    contentItem: Label {
                        id: genreLabel

                        verticalAlignment: Text.AlignVCenter
                        opacity: 0.87
                        font.pixelSize: 13

                        elide: Text.ElideRight
                        text: genre
                    }
                }
                Control {
                    height: parent.height
                    width: listView.headerItem.children[0].children[3].width
                    leftPadding: 56
                    contentItem: TextEdit {
                        id: plotTextEdit
                        enabled: false

                        verticalAlignment: Text.AlignVCenter
                        opacity: 0.87
                        font.pixelSize: 13

                        text: plot
                        TextMetrics {
                            id: plotTextMetrics
                            elide: Text.ElideRight

                            function getElidedText( originalText, maxWidth ) {
                                if( originalText != undefined){
                                    text = originalText
                                    elideWidth = maxWidth
                                    return elidedText
                                }
                            }
                        }
                        onWidthChanged: {
                            text = plotTextMetrics.getElidedText( plot, width )
                        }
                        Component.onCompleted: {
                            var pos = text.search( searchTextField.text )
                            if( pos === -1 )
                                deselect()
                            else
                                select( pos, pos + searchTextField.text.length )
                        }
                    }
                }
                Control {
                    height: parent.height
                    width: listView.headerItem.children[0].children[4].width
                    leftPadding: 56
                    contentItem: Label {
                        id: yearLabel

                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        opacity: 0.87
                        font.pixelSize: 13

                        text: year
                        elide: Text.ElideRight
                    }
                }
                Control {
                    height: parent.height
                    width: listView.headerItem.children[0].children[5].width
                    leftPadding: 56
                    contentItem: Label {
                        id: ratingLabel

                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        opacity: 0.87
                        font.pixelSize: 13

                        text: rating + "%"
                        elide: Text.ElideRight
                    }
                }
                Control {
                    height: parent.height
                    width: listView.headerItem.children[0].children[6].width
                    leftPadding: 56
                    rightPadding: 24

                    contentItem: RatingWidget {
                        id: userRating
                        size: 13
                        opacity: ( user_rating == 0 ) ? 0.38 : 0.87
                        rating: user_rating
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            dialog.rating = user_rating
                            dialog.movieTitle = title
                            dialog.movieId = id
                            dialog.open()
                        }
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                propagateComposedEvents: true
                onHoveredChanged: {
                    listView.currentIndex = index
                }
            }
            Rectangle {
                height: 1
                width: parent.width
                anchors.bottom: parent.bottom
                color: "#E5E5E5"
            }
        }

        ScrollIndicator.horizontal: ScrollIndicator { }
        ScrollIndicator.vertical: ScrollIndicator { }
    }

    UserRatingDialog {
        id: dialog
        x: (parent.width - width)/2
        y: (parent.height -height)/2
        property string movieId: ""
        onAccepted: {
            moviesModel.setUserRating( movieId, rating )
        }
    }

    footer: ToolBar {
        id: footer
        width: listView.width
        position: ToolBar.Footer
        height: 48

        Label {
            font.pixelSize: 12
            opacity: 0.54
            text: qsTr("Строк на странице:")
            anchors.right: pageComboBox.right
            anchors.rightMargin: 64
            anchors.verticalCenter: parent.verticalCenter
        }

        ComboBox {
            id: pageComboBox
            font.pixelSize: 12
            opacity: 0.54
            flat: true
            model: [ "10", "25", "50" ]
            Layout.maximumWidth: 64
            width: 64
            currentIndex: 0
            anchors.right: pageStatus.left
            anchors.rightMargin: 32
            anchors.verticalCenter: parent.verticalCenter
            onActivated: {
                moviesModel.setPaginationStep( textAt( index ) )
            }
        }
        Label {
            id: pageStatus

            font.pixelSize: 12
            opacity: 0.54
            padding: 0

            property string textTemplate: qsTr("%1-%2 из %3")
            anchors.right: first.left
            anchors.rightMargin: 32
            anchors.verticalCenter: parent.verticalCenter

            function updateText() {
                var firstPageInView = moviesModel.currentPage() * moviesModel.paginationStep()
                var lastPageInView = ( firstPageInView + moviesModel.paginationStep() ) > moviesModel.count() ? moviesModel.count() : firstPageInView + moviesModel.paginationStep()
                pageStatus.text = pageStatus.textTemplate.arg( firstPageInView )
                .arg( lastPageInView )
                .arg( moviesModel.count() )
            }
            Component.onCompleted: {
                pageStatus.updateText()
            }

            Connections {
                target: moviesModel
                onCurrentPageChanged: {
                    pageStatus.updateText()
                }
                onPageCountChanged: {
                    pageStatus.updateText()
                }
                onPaginationStepChanged: {
                    pageStatus.updateText()
                }
            }
        }
        ToolButton  {
            id: first
            width: 24
            Layout.minimumWidth: 24
            Layout.maximumWidth: 24
            opacity: 0.54
            font.pixelSize: 24
            text: MdiFont.Icon.pageFirst
            anchors.right: previous.left
            anchors.rightMargin: 24
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                moviesModel.setCurrentPage( 0 )
            }
        }
        ToolButton  {
            id: previous
            width: 24
            Layout.minimumWidth: 24
            Layout.maximumWidth: 24
            opacity: 0.54
            text: MdiFont.Icon.chevronLeft
            font.pixelSize: 24
            anchors.right: next.left
            anchors.rightMargin: 24
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                moviesModel.setCurrentPage( moviesModel.currentPage() - 1 )
            }
        }
        ToolButton  {
            id: next
            width: 24
            Layout.minimumWidth: 24
            Layout.maximumWidth: 24
            opacity: 0.54
            text: MdiFont.Icon.chevronRight
            font.pixelSize: 24
            anchors.right: last.left
            anchors.rightMargin: 24
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                moviesModel.setCurrentPage( moviesModel.currentPage() + 1 )
            }
        }
        ToolButton  {
            id: last
            width: 24
            Layout.minimumWidth: 24
            Layout.maximumWidth: 24
            opacity: 0.54
            text: MdiFont.Icon.pageLast
            font.pixelSize: 24
            anchors.right: parent.right
            anchors.rightMargin: 14
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                moviesModel.setCurrentPage( moviesModel.pageCount() - 1 )
            }

        }
    }
}
