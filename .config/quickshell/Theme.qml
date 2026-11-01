pragma Singleton
import QtQuick

QtObject {
    id: root

    readonly property color primary: "#ffb3b0"
    readonly property color primaryText: "#571d1d"
    readonly property color primaryContainer: "#733332"
    readonly property color primaryContainerText: "#ffdad8"

    readonly property color secondary: "#e7bdba"
    readonly property color secondaryText: "#442928"
    readonly property color secondaryContainer: "#5d3f3e"
    readonly property color secondaryContainerText: "#ffdad8"

    readonly property color tertiary: "#e3c28c"
    readonly property color tertiaryText: "#412d05"

    readonly property color surface: "#1a1111"
    readonly property color surfaceText: "#f0dedd"
    readonly property color surfaceVariant: "#534342"
    readonly property color surfaceVariantText: "#d7c1c0"

    readonly property color surfaceContainerLowest: "#140c0c"
    readonly property color surfaceContainerLow: "#231919"
    readonly property color surfaceContainer: "#271d1d"
    readonly property color surfaceContainerHigh: "#322827"
    readonly property color surfaceContainerHighest: "#3d3232"

    readonly property color outline: "#a08c8b"
    readonly property color outlineVariant: "#534342"

    readonly property color error: "#ffb4ab"
    readonly property color errorText: "#690005"
    readonly property color errorContainer: "#93000a"

    // Typography
    readonly property string fontFamily: "JetBrainsMono Nerd Font Propo"
    readonly property string fontFamilyMono: "JetBrainsMono Nerd Font"

    // Metrics & Radius
    readonly property int radiusSmall: 8
    readonly property int radiusMedium: 14
    readonly property int radiusLarge: 22
    readonly property int radiusFull: 999

    readonly property int barHeight: 44
    readonly property int barMargin: 8
    readonly property int barWidth: 54
}
