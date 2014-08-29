#include <QDebug>
#include <QFile>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQml>

#include "tracemodel.h"

int main(int argc, char **argv)
{
    QGuiApplication app(argc, argv);
    qmlRegisterType<TraceModel>("my.thing", 1, 0, "TraceModel");
    QQmlApplicationEngine engine("main.qml");
    return app.exec();
}
