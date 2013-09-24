#ifndef PYTHON_BYTE_READER_WITH_POSITION_H_3C95E597_B354_4578_AE58_2CF4298D6FF7
#define PYTHON_BYTE_READER_WITH_POSITION_H_3C95E597_B354_4578_AE58_2CF4298D6FF7

#include "Python.h"
#include "IOBasicTypes.h"
#include "IByteReaderWithPosition.h"

class PythonByteReaderWithPosition : public IByteReaderWithPosition {
public:
    PythonByteReaderWithPosition(PyObject* obj);

    virtual ~PythonByteReaderWithPosition();

    virtual IOBasicTypes::LongBufferSizeType Read(
        IOBasicTypes::Byte* stream,
        IOBasicTypes::LongBufferSizeType size);

    virtual bool NotEnded();

    virtual void SetPosition(LongFilePositionType inOffsetFromStart);

    virtual void SetPositionFromEnd(LongFilePositionType inOffsetFromEnd);

    virtual LongFilePositionType GetCurrentPosition();

    virtual void Skip(LongBufferSizeType inSkipSize);

private:
    PyObject* _obj;

};

#endif
