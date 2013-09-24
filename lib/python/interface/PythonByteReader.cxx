#include "PythonByteReader.h"
#include "hummus/interface_api.h"

PythonByteReader::PythonByteReader(PyObject* obj) : _obj(obj) {
    import_hummus__interface();
    Py_XINCREF(_obj);
}

PythonByteReader::~PythonByteReader() {
    Py_XDECREF(_obj);
}

IOBasicTypes::LongBufferSizeType PythonByteReader::Read(
        IOBasicTypes::Byte* stream,
        IOBasicTypes::LongBufferSizeType size) {
    return _hummus_br_read(_obj, stream, size);
}

bool PythonByteReader::NotEnded() {
    return _hummus_br_not_ended(_obj);
}
