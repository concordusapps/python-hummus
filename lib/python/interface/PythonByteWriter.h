#ifndef _PYTHON_BYTE_WRITER_H_0EADA4FC_9BD3_4BC6_875F_54C8C397EDCA
#define _PYTHON_BYTE_WRITER_H_0EADA4FC_9BD3_4BC6_875F_54C8C397EDCA

#include "Python.h"
#include "IOBasicTypes.h"
#include "IByteWriter.h"

class PythonByteWriter : public IByteWriter {
public:
    PythonByteWriter(PyObject* obj);

    virtual ~PythonByteWriter();

    virtual IOBasicTypes::LongBufferSizeType Write(
        const IOBasicTypes::Byte* stream,
        IOBasicTypes::LongBufferSizeType size);

private:
    PyObject* _obj;

};

#endif
