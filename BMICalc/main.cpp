#include <QtGui/QApplication>
#include <QtGui/QDesktopWidget>
#include <QtDeclarative/QDeclarativeView>
#include <QtDeclarative/QDeclarativeEngine>

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setApplicationName("BMICalc");


    QDeclarativeView view;
    view.window()->setGeometry(QApplication::desktop()->screenGeometry());
    view.setResizeMode(QDeclarativeView::SizeRootObjectToView);
    view.setSource(QUrl("qrc:/qml/BMICalc/main.qml"));

    view.window()->showFullScreen();

    QObject::connect(view.engine(), SIGNAL(quit()), &view, SLOT(close()));

    return app.exec();
}
