#include "PythonByteWriterWithPosition.h"
#include "hummus/interface_api.h"

PythonByteWriterWithPosition::PythonByteWriterWithPosition(PyObject* obj) : _obj(obj) {
    import_hummus__interface();
    Py_XINCREF(_obj);
}

PythonByteWriterWithPosition::~PythonByteWriterWithPosition() {
    Py_XDECREF(_obj);
}

IOBasicTypes::LongBufferSizeType PythonByteWriterWithPosition::Write(
        const IOBasicTypes::Byte* stream,
        IOBasicTypes::LongBufferSizeType size) {
    return _hummus_bw_write(_obj, stream, size);
}

IOBasicTypes::LongFilePositionType PythonByteWriterWithPosition::GetCurrentPosition() {
    return _hummus_bw_tell(_obj);
}
