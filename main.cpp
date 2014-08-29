#include <QDebug>
#include <QFile>
#include <QCoreApplication>

#include "tracemodel.h"

int main(int argc, char **argv)
{
    QCoreApplication app(argc, argv);

    QFile f("trace.systrace");
    if (!f.open(QIODevice::ReadOnly)) {
        qWarning("Can't open trace");
        return -1;
    }

    TraceModel *tm = TraceModel::fromFile(&f);
    qDebug() << "Model represents " << tm->cpuCount() << " CPUs";

    for (int i = 0; i < tm->cpuCount(); ++i)
        qDebug() << "Frequency model for CPU ID " << i << " has " << tm->cpuFrequencyModel(i)->rowCount(QModelIndex()) << " slices";
    return 0;
}
