#ifndef PYTHON_BYTE_READER_H_3C95E597_B354_4578_AE58_2CF4298D6FF7
#define PYTHON_BYTE_READER_H_3C95E597_B354_4578_AE58_2CF4298D6FF7

#include "Python.h"
#include "IOBasicTypes.h"
#include "IByteReader.h"

class PythonByteReader : public IByteReader {
public:
    PythonByteReader(PyObject* obj);

    virtual ~PythonByteReader();

    virtual IOBasicTypes::LongBufferSizeType Read(
        IOBasicTypes::Byte* stream,
        IOBasicTypes::LongBufferSizeType size);

    virtual bool NotEnded();

private:
    PyObject* _obj;

};

#endif
