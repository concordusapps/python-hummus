#ifndef _PYTHON_BYTE_WRITER_WITH_POSITION_H_0EADA4FC_9BD3_4BC6_875F_54C8C397EDCA
#define _PYTHON_BYTE_WRITER_WITH_POSITION_H_0EADA4FC_9BD3_4BC6_875F_54C8C397EDCA

#include "Python.h"
#include "IOBasicTypes.h"
#include "IByteWriterWithPosition.h"

class PythonByteWriterWithPosition : public IByteWriterWithPosition {
public:
    PythonByteWriterWithPosition(PyObject* obj);

    virtual ~PythonByteWriterWithPosition();

    virtual IOBasicTypes::LongBufferSizeType Write(
        const IOBasicTypes::Byte* stream,
        IOBasicTypes::LongBufferSizeType size);

    virtual IOBasicTypes::LongFilePositionType GetCurrentPosition();

private:
    PyObject* _obj;

};

#endif
