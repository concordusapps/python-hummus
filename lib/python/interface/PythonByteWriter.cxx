#include "PythonByteWriter.h"
#include "hummus/interface_api.h"

PythonByteWriter::PythonByteWriter(PyObject* obj) : _obj(obj) {
    import_hummus__interface();
    Py_XINCREF(_obj);
}

PythonByteWriter::~PythonByteWriter() {
    Py_XDECREF(_obj);
}

IOBasicTypes::LongBufferSizeType PythonByteWriter::Write(
        const IOBasicTypes::Byte* stream,
        IOBasicTypes::LongBufferSizeType size) {
    return _hummus_bw_write(_obj, stream, size);
}
